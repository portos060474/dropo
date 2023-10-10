package com.dropo.provider.fragments;

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

import com.dropo.provider.PaymentActivity;
import com.dropo.provider.PayStackPaymentActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.CardAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomFloatingButton;
import com.dropo.provider.models.datamodels.Card;
import com.dropo.provider.models.responsemodels.CardsResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.PaymentResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;

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
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.PAYMENT_GATEWAY_ID, Const.Payment.PAYSTACK);
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.getAllCreditCards(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
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

    public void selectCreditCard(final int selectedCardPosition) {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.CARD_ID, cardList.get(selectedCardPosition).getId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CardsResponse> responseCall = apiInterface.selectCreditCard(map);
        responseCall.enqueue(new Callback<CardsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<CardsResponse> call, @NonNull Response<CardsResponse> response) {
                if (paymentActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        for (Card card : cardList) {
                            card.setIsDefault(false);
                        }
                        cardList.get(selectedCardPosition).setIsDefault(response.body().getCard().isIsDefault());
                        setSelectCreditCart(false);
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
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.CARD_ID, cardList.get(deleteCardPosition).getId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteCreditCard(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (paymentActivity.parseContent.isSuccessful(response)) {
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
                Utils.showToast(getString(R.string.error_select_card_first), paymentActivity);
            }
        } else {
            Utils.showToast(paymentActivity.getResources().getString(R.string.msg_plz_add_card_first), paymentActivity);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Const.REQUEST_ADD_CARD && resultCode == Activity.RESULT_OK) {
            getAllCards();
        } else if (requestCode == Const.REQUEST_PAYU) {
            if (resultCode == Activity.RESULT_OK) {
                getAllCards();
            } else {
                Utils.showToast(getString(R.string.error_payment_cancel), paymentActivity);
            }
        }
    }

    public void gotoPayStackAddCard() {
        Utils.showCustomProgressDialog(paymentActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, paymentActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, paymentActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.PAYMENT_ID, paymentActivity.gatewayItem.getId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripSetupIntent(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                if (response.isSuccessful() && response.body().isSuccess()) {
                    Utils.hideCustomProgressDialog();
                    Intent intent = new Intent(paymentActivity, PayStackPaymentActivity.class);
                    intent.putExtra(Const.Params.AUTHORIZATION_URL, response.body().getAuthorizationUrl());
                    startActivityForResult(intent, Const.REQUEST_ADD_CARD);
                } else {
                    Utils.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(PaymentActivity.class.getSimpleName(), t);
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