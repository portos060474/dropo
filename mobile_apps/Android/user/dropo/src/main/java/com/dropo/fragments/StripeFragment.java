package com.dropo.fragments;

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

import com.dropo.user.R;
import com.dropo.adapter.CardAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.models.datamodels.Card;
import com.dropo.models.responsemodels.CardsResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.PaymentResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;
import com.stripe.android.ApiResultCallback;
import com.stripe.android.PaymentAuthConfig;
import com.stripe.android.PaymentConfiguration;
import com.stripe.android.SetupIntentResult;
import com.stripe.android.Stripe;
import com.stripe.android.model.ConfirmSetupIntentParams;
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

    public final String TAG = this.getClass().getSimpleName();

    public ArrayList<Card> cardList;
    private RecyclerView rcvStripCards;
    private CardAdapter cardAdapter;
    private BottomSheetDialog addCardDialog;
    private CardMultilineWidget stripeCard;
    private Stripe stripe;
    private PreferenceHelper preferenceHelper;
    private CustomFontEditTextView etCardHolderName;
    private TextInputLayout tiCardholderName;
    private LinearLayout ivEmpty;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_stripe, container, false);
        rcvStripCards = view.findViewById(R.id.rcvStripCards);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        cardList = new ArrayList<>();
        preferenceHelper = PreferenceHelper.getInstance(paymentActivity);
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

    }

    /**
     * this method called webservice for get all save credit card in stripe
     */
    private void getAllCards() {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        hashMap.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getUserId());
        hashMap.put(Const.Params.PAYMENT_GATEWAY_ID, Const.Payment.STRIPE);
        hashMap.put(Const.Params.TYPE, Const.Type.USER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.getAllCreditCards(hashMap);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        cardList.clear();
                        cardList.addAll(response.body().getCards());
                        setSelectCreditCart();
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
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
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

    public void openAddCardDialog() {
        if (addCardDialog != null && addCardDialog.isShowing()) {
            return;
        }

        addCardDialog = new BottomSheetDialog(paymentActivity);
        addCardDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        addCardDialog.setContentView(R.layout.dialog_add_credit_card);
        addCardDialog.findViewById(R.id.btnDialogAlertRight).setOnClickListener(view -> {
            if (isValidate()) {
                addCardDialog.dismiss();
                saveCreditCard(paymentActivity.gatewayItem.getId());
            }
        });

        addCardDialog.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> {
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
            Utils.showToast(msg, paymentActivity);
            return false;
        }
        return true;
    }

    private void saveCreditCard(String paymentId) {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.PAYMENT_ID, paymentId);
        map.put(Const.Params.TYPE, Const.Type.USER);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripSetupIntent(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                if (response.isSuccessful() && response.body().isSuccess()) {
                    PaymentMethodCreateParams createPaymentParams = PaymentMethodCreateParams.create(stripeCard.getPaymentMethodCard(), new PaymentMethod.BillingDetails.Builder().setName(etCardHolderName.getText().toString().trim()).setEmail(preferenceHelper.getEmail()).setPhone(preferenceHelper.getCountryPhoneCode() + preferenceHelper.getPhoneNumber()).build());
                    stripe.confirmSetupIntent(StripeFragment.this, ConfirmSetupIntentParams.create(createPaymentParams, response.body().getClientSecret()));
                } else {
                    Utils.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(StripeFragment.class.getSimpleName(), t);
            }
        });
    }

    /**
     * this method call a webservice for save credit card
     */
    private void addCreditCard(String paymentMethod, String lastFourDigits, String cardType) {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.PAYMENT_METHOD, paymentMethod);
        map.put(Const.Params.LAST_FOUR, lastFourDigits);
        map.put(Const.Params.CARD_TYPE, cardType);
        map.put(Const.Params.PAYMENT_ID, paymentActivity.gatewayItem.getId());
        map.put(Const.Params.NAME, etCardHolderName.getText().toString().trim());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.getAddCreditCard(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        cardList.add(response.body().getCard());
                        initRcvCards();
                        setSelectCreditCart();
                        closedAddCardDialog();
                        Utils.showMessageToast(response.body().getStatusPhrase(), paymentActivity);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), paymentActivity);
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
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void selectCreditCard(final int selectedCardPosition) {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getUserId());
        map.put(Const.Params.CARD_ID, cardList.get(selectedCardPosition).getId());
        map.put(Const.Params.TYPE, Const.Type.USER);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.selectCreditCard(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        for (Card card : cardList) {
                            card.setDefault(false);
                        }
                        cardList.get(selectedCardPosition).setDefault(response.body().getCard().isDefault());
                        setSelectCreditCart();
                        cardAdapter.notifyDataSetChanged();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), paymentActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CardsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void deleteCreditCard(final int deleteCardPosition) {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getUserId());
        map.put(Const.Params.CARD_ID, cardList.get(deleteCardPosition).getId());
        map.put(Const.Params.TYPE, Const.Type.USER);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteCreditCard(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (cardList.get(deleteCardPosition).isDefault()) {
                            cardList.remove(deleteCardPosition);
                            if (!cardList.isEmpty()) {
                                selectCreditCard(0);
                            } else {
                                setSelectCreditCart();
                            }
                        } else {
                            cardList.remove(deleteCardPosition);
                            setSelectCreditCart();
                        }
                        cardAdapter.notifyDataSetChanged();
                        Utils.showMessageToast(response.body().getStatusPhrase(), paymentActivity);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), paymentActivity);
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
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void openDeleteCard(final int position) {
        CustomDialogAlert customDialogAlert = new CustomDialogAlert(paymentActivity, paymentActivity.getResources().getString(R.string.text_delete_card), paymentActivity.getResources().getString(R.string.msg_are_you_sure), paymentActivity.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                deleteCreditCard(position);

            }
        };

        customDialogAlert.show();
    }

    private void setSelectCreditCart() {
        if (paymentActivity.selectCard != null) {
            paymentActivity.selectCard.setDefault(false);
        }
        paymentActivity.selectCard = null;
        for (Card card : cardList) {
            if (card.isDefault()) {
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
                Utils.showToast(getString(R.string.error_select_card_first), paymentActivity);
            }
        } else {
            Utils.showToast(paymentActivity.getResources().getString(R.string.msg_plz_add_card_first), paymentActivity);
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
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(getString(R.string.error_payment_cancel), paymentActivity);
                } else if (status == SetupIntent.Status.Processing) {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(getString(R.string.error_payment_processing), paymentActivity);
                } else if (status == SetupIntent.Status.RequiresPaymentMethod) {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(getString(R.string.error_payment_auth), paymentActivity);
                } else if (status == SetupIntent.Status.RequiresAction || status == SetupIntent.Status.RequiresConfirmation) {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(getString(R.string.error_payment_action), paymentActivity);
                } else if (status == SetupIntent.Status.RequiresCapture) {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(getString(R.string.error_payment_capture), paymentActivity);
                } else {
                    Utils.hideCustomProgressDialog();
                }
            }

            @Override
            public void onError(@NonNull Exception e) {
                Utils.hideCustomProgressDialog();
                Utils.showToast(e.getMessage(), paymentActivity);
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