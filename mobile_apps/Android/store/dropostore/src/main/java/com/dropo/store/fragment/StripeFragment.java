package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.CardAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.datamodel.Card;
import com.dropo.store.models.responsemodel.CardsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.PaymentResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputLayout;
import com.stripe.android.ApiResultCallback;
import com.stripe.android.PaymentAuthConfig;
import com.stripe.android.PaymentConfiguration;
import com.stripe.android.SetupIntentResult;
import com.stripe.android.Stripe;
import com.stripe.android.model.ConfirmSetupIntentParams;
import com.stripe.android.model.PaymentIntent;
import com.stripe.android.model.PaymentMethod;
import com.stripe.android.model.PaymentMethodCreateParams;
import com.stripe.android.model.SetupIntent;
import com.stripe.android.view.CardMultilineWidget;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StripeFragment extends BasePaymentFragments {
    public static final String TAG = StripeFragment.class.getName();

    public ArrayList<Card> cardList;
    private RecyclerView rcvStripCards;
    private CardAdapter cardAdapter;
    private BottomSheetDialog addCardDialog;
    private CardMultilineWidget stripeCard;
    private Stripe stripe;
    private FloatingActionButton tvAddCard;
    private PreferenceHelper preferenceHelper;
    private CustomInputEditText etCardHolderName;
    private TextInputLayout tiCardholderName;
    private LinearLayout ivEmpty;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_stripe, container, false);
        rcvStripCards = view.findViewById(R.id.rcvStripCards);
        tvAddCard = view.findViewById(R.id.tvAddCard);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        cardList = new ArrayList<>();
        tvAddCard.setOnClickListener(this);
        preferenceHelper = PreferenceHelper.getPreferenceHelper(paymentActivity);
        initStripePayment();
        getAllCards();

    }

    private void initStripePayment() {
        final PaymentAuthConfig.Stripe3ds2UiCustomization uiCustomization = new PaymentAuthConfig.Stripe3ds2UiCustomization.Builder().build();
        PaymentAuthConfig.init(new PaymentAuthConfig.Builder().set3ds2Config(new PaymentAuthConfig.Stripe3ds2Config.Builder()
                // set a 5 minute timeout for challenge flow
                .setTimeout(5)
                // customize the UI of the challenge flow
                .setUiCustomization(uiCustomization).build()).build());

        PaymentConfiguration.init(paymentActivity, paymentActivity.stripeKeyId);
        stripe = new Stripe(paymentActivity, PaymentConfiguration.getInstance(paymentActivity).getPublishableKey());
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.tvAddCard) {
            openAddCardDialog();
        }
    }

    /**
     * this method called webservice for get all save credit card in stripe
     */
    private void getAllCards() {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(Constant.PAYMENT_GATEWAY_ID, Constant.Payment.STRIPE);


        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.getAllCreditCards(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    cardList.clear();
                    if (response.body().isSuccess()) {
                        cardList.addAll(response.body().getCards());
                        setSelectCreditCart(true);
                        initRcvCards();
                    }

                    if (cardList.isEmpty()) {
                        rcvStripCards.setVisibility(View.GONE);
                        ivEmpty.setVisibility(View.VISIBLE);
                    } else {
                        rcvStripCards.setVisibility(View.VISIBLE);
                        ivEmpty.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CardsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvCards() {
        if (cardAdapter != null) {
            cardAdapter.notifyDataSetChanged();
        } else {
            rcvStripCards.setLayoutManager(new LinearLayoutManager(paymentActivity));
            cardAdapter = new CardAdapter(this, cardList);
            rcvStripCards.setAdapter(cardAdapter);
        }
    }

    private void openAddCardDialog() {
        if (addCardDialog != null && addCardDialog.isShowing()) {
            return;
        }

        addCardDialog = new BottomSheetDialog(paymentActivity);
        addCardDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        addCardDialog.setContentView(R.layout.dialog_add_credit_card);
        addCardDialog.findViewById(R.id.btnDialogAlertRight).setOnClickListener(view -> {
            if (isValidate()) {
                saveCreditCard(paymentActivity.gatewayItem.getId());
            }
        });

        addCardDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> {
            paymentActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            addCardDialog.dismiss();
        });
        stripeCard = addCardDialog.findViewById(R.id.stripeCard);
        etCardHolderName = addCardDialog.findViewById(R.id.etCardHolderName);
        tiCardholderName = addCardDialog.findViewById(R.id.tiCardholderName);

        WindowManager.LayoutParams params = addCardDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        addCardDialog.getWindow().setAttributes(params);
        addCardDialog.setCancelable(false);
        addCardDialog.show();
    }

    private void closedAddCardDialog() {
        if (addCardDialog != null && addCardDialog.isShowing()) {
            addCardDialog.dismiss();
        }
    }

    private boolean isValidate() {
        String msg = null;
        if (etCardHolderName.getText().toString().trim().isEmpty()) {
            tiCardholderName.setError(getString(R.string.msg_please_enter_valid_name));
            etCardHolderName.requestFocus();
            return false;
        } else if (!stripeCard.validateAllFields()) {
            msg = getString(R.string.msg_card_invalid);
        }

        tiCardholderName.setError(null);

        if (msg != null) {
            Utilities.showToast(paymentActivity, msg);
            return false;
        }

        return true;
    }

    private void saveCreditCard(String paymentId) {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.PAYMENT_ID, paymentId);
        map.put(Constant.TYPE, Constant.TYPE_STORE);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripSetupIntent(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                if (response.isSuccessful() && response.body().isSuccess()) {
                    PaymentMethodCreateParams createPaymentParams = PaymentMethodCreateParams.create(stripeCard.getPaymentMethodCard(), new PaymentMethod.BillingDetails.Builder().setName(etCardHolderName.getText().toString().trim()).setEmail(preferenceHelper.getEmail()).setPhone(preferenceHelper.getCountryPhoneCode() + preferenceHelper.getPhone()).build());
                    stripe.confirmSetupIntent(StripeFragment.this, ConfirmSetupIntentParams.create(createPaymentParams, response.body().getClientSecret()));
                } else {
                    Utilities.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(StripeFragment.class.getSimpleName(), t);
            }
        });
    }

    /**
     * this method call a webservice for save credit card
     */
    private void addCreditCard(String paymentMethod, String lastFourDigits, String cardType) {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.PAYMENT_METHOD, paymentMethod);
        map.put(Constant.LAST_FOUR, lastFourDigits);
        map.put(Constant.CARD_TYPE, cardType);
        map.put(Constant.PAYMENT_ID, paymentActivity.gatewayItem.getId());
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(Constant.NAME, etCardHolderName.getText().toString().trim());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.getAddCreditCard(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        cardList.add(response.body().getCard());
                        initRcvCards();
                        setSelectCreditCart(false);
                        closedAddCardDialog();
                        ParseContent.getInstance().showMessage(paymentActivity, response.body().getStatusPhrase());
                    } else {
                        ParseContent.getInstance().showErrorMessage(paymentActivity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                    if (cardList.isEmpty()) {
                        rcvStripCards.setVisibility(View.GONE);
                        ivEmpty.setVisibility(View.VISIBLE);
                    } else {
                        rcvStripCards.setVisibility(View.VISIBLE);
                        ivEmpty.setVisibility(View.GONE);
                    }
                    if (cardList.isEmpty()) {
                        rcvStripCards.setVisibility(View.GONE);
                        ivEmpty.setVisibility(View.VISIBLE);
                    } else {
                        rcvStripCards.setVisibility(View.VISIBLE);
                        ivEmpty.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CardsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void selectCreditCard(final int selectedCardPosition) {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(Constant.CARD_ID, cardList.get(selectedCardPosition).getId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.selectCreditCard(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        for (Card card : cardList) {
                            card.setIsDefault(false);
                        }
                        cardList.get(selectedCardPosition).setIsDefault(response.body().getCard().isIsDefault());
                        setSelectCreditCart(false);
                        cardAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(paymentActivity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CardsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void deleteCreditCard(final int deleteCardPosition) {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.CARD_ID, cardList.get(deleteCardPosition).getId());
        map.put(Constant.TYPE, Constant.Type.STORE);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteCreditCard(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        if (cardList.get(deleteCardPosition).isIsDefault()) {
                            cardList.remove(deleteCardPosition);
                            if (!cardList.isEmpty()) {
                                selectCreditCard(0);
                            } else {
                                setSelectCreditCart(false);
                            }
                        } else {
                            cardList.remove(deleteCardPosition);
                            setSelectCreditCart(false);
                        }
                        cardAdapter.notifyDataSetChanged();
                        ParseContent.getInstance().showMessage(paymentActivity, response.body().getStatusPhrase());
                    } else {
                        ParseContent.getInstance().showErrorMessage(paymentActivity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                    if (cardList.isEmpty()) {
                        rcvStripCards.setVisibility(View.GONE);
                        ivEmpty.setVisibility(View.VISIBLE);
                    } else {
                        rcvStripCards.setVisibility(View.VISIBLE);
                        ivEmpty.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void openDeleteCard(final int position) {
        CustomAlterDialog customDialogAlert = new CustomAlterDialog(paymentActivity, paymentActivity.getResources().getString(R.string.text_delete_card), paymentActivity.getResources().getString(R.string.text_are_you_sure), true, paymentActivity.getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                if (R.id.btnPositive == btnId) {
                    deleteCreditCard(position);
                }
                dismiss();
            }
        };
        customDialogAlert.show();
    }

    private void setSelectCreditCart(boolean isFromAllCards) {
        if (!isFromAllCards) {
            if (paymentActivity.selectCard != null) {
                paymentActivity.selectCard.setIsDefault(false);
            }
            paymentActivity.selectCard = null;
        }
        for (Card card : cardList) {
            if (card.isIsDefault()) {
                paymentActivity.selectCard = card;
                return;
            }
        }
    }

    public void addWalletAmount() {
        if (paymentActivity.selectCard != null) {
            if (paymentActivity.selectCard.getPaymentId().equals(paymentActivity.gatewayItem.getId())) {
                paymentActivity.createStripePaymentIntent();
            } else {
                Utilities.showToast(paymentActivity, getString(R.string.error_select_card_first));
            }
        } else {
            Utilities.showToast(paymentActivity, paymentActivity.getResources().getString(R.string.msg_plz_add_card_first));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        stripe.onSetupResult(requestCode, data, new ApiResultCallback<SetupIntentResult>() {
            @Override
            public void onSuccess(@NonNull SetupIntentResult result) {
                final SetupIntent setupIntent = result.getIntent();
                final SetupIntent.Status status = setupIntent.getStatus();
                if (status == SetupIntent.Status.Succeeded) {
                    addCreditCard(setupIntent.getPaymentMethodId(), Objects.requireNonNull(stripeCard.getPaymentMethodCard()).getLast4(), Objects.requireNonNull(stripeCard).getBrand().getDisplayName());
                } else if (status == SetupIntent.Status.Canceled) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(paymentActivity, getString(R.string.error_payment_cancel));
                } else if (status == SetupIntent.Status.Processing) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(paymentActivity, getString(R.string.error_payment_processing));
                } else if (status == PaymentIntent.Status.RequiresPaymentMethod) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(paymentActivity, getString(R.string.error_payment_auth));
                } else if (status == SetupIntent.Status.RequiresAction || status == SetupIntent.Status.RequiresConfirmation) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(paymentActivity, getString(R.string.error_payment_action));
                } else if (status == SetupIntent.Status.RequiresCapture) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(paymentActivity, getString(R.string.error_payment_capture));
                } else {
                    Utilities.hideCustomProgressDialog();
                }
            }

            @Override
            public void onError(@NonNull Exception e) {
                Utilities.hideCustomProgressDialog();
                Utilities.showToast(paymentActivity, e.getMessage());
            }
        });

    }

    @SuppressLint("NotifyDataSetChanged")
    public void notifyCardData() {
        if (cardAdapter != null) {
            cardAdapter.notifyDataSetChanged();
        }
    }
}