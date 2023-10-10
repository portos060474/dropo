package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.PaymentActivity;
import com.dropo.store.PayStackPaymentActivity;
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
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFloatingButton;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PayStackFragment extends BasePaymentFragments {
    public static final String TAG = PayStackFragment.class.getName();

    public ArrayList<Card> cardList;
    private RecyclerView rcvStripCards;
    private CardAdapter cardAdapter;
    private LinearLayout ivEmpty;
    private CustomFloatingButton tvAddCard;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_stripe, container, false);
        rcvStripCards = view.findViewById(R.id.rcvStripCards);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        tvAddCard = view.findViewById(R.id.tvAddCard);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        tvAddCard.setOnClickListener(this);
        cardList = new ArrayList<>();
        getAllCards();
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.tvAddCard) {
            gotoPayStackAddCard();
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
        map.put(Constant.PAYMENT_GATEWAY_ID, Constant.Payment.PAYSTACK);
        map.put(Constant.TYPE, Constant.TYPE_STORE);

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

    public void selectCreditCard(final int selectedCardPosition) {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.CARD_ID, cardList.get(selectedCardPosition).getId());
        map.put(Constant.TYPE, Constant.TYPE_STORE);

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
        map.put(Constant.TYPE, Constant.TYPE_STORE);

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
        if (requestCode == Constant.REQUEST_ADD_CARD && resultCode == Activity.RESULT_OK) {
            getAllCards();
        } else if (requestCode == Constant.REQUEST_PAYU) {
            if (resultCode == Activity.RESULT_OK) {
                getAllCards();
            } else {
                Utilities.showToast(paymentActivity, getString(R.string.error_payment_cancel));
            }
        }
    }

    public void gotoPayStackAddCard() {
        Utilities.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, paymentActivity.preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, paymentActivity.preferenceHelper.getServerToken());
        map.put(Constant.PAYMENT_ID, paymentActivity.gatewayItem.getId());
        map.put(Constant.TYPE, Constant.TYPE_STORE);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripSetupIntent(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                if (response.isSuccessful() && response.body().isSuccess()) {
                    Utilities.hideCustomProgressDialog();
                    Intent intent = new Intent(paymentActivity, PayStackPaymentActivity.class);
                    intent.putExtra(Constant.AUTHORIZATION_URL, response.body().getAuthorizationUrl());
                    startActivityForResult(intent, Constant.REQUEST_ADD_CARD);
                } else {
                    Utilities.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(PaymentActivity.class.getSimpleName(), t);
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