package com.dropo.fragments;

import static com.dropo.utils.Const.Params.ORDER_ID;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.OrderDetailActivity;
import com.dropo.user.R;
import com.dropo.adapter.InvoiceAdapter;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Invoice;
import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.responsemodels.InvoiceResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class InvoiceFragment extends BottomSheetDialogFragment implements View.OnClickListener {

    private CustomFontTextViewTitle tvOderTotal;
    private CustomFontButton btnInvoiceSubmit;
    private RecyclerView rcvInvoice;
    private OrderDetailActivity orderDetailActivity;
    private ArrayList<Invoice> invoiceArrayList;
    private OrderPayment orderPayment;
    private CustomFontTextView tvInvoiceMsg;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        orderDetailActivity = (OrderDetailActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_order_invoice, container, false);
        btnInvoiceSubmit = view.findViewById(R.id.btnInvoiceSubmit);
        tvOderTotal = view.findViewById(R.id.tvOderTotal);
        rcvInvoice = view.findViewById(R.id.rcvInvoice);
        tvInvoiceMsg = view.findViewById(R.id.tvInvoiceMsg);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismiss());
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        btnInvoiceSubmit.setOnClickListener(this);
        if (orderDetailActivity.isShowHistory) {
            btnInvoiceSubmit.setVisibility(View.GONE);
            orderDetailActivity.historyDetailResponse.getOrderPaymentDetail().setTaxIncluded(orderDetailActivity.historyDetailResponse.getCartDetail().getTaxIncluded());
            loadInvoiceData(orderDetailActivity.historyDetailResponse.getOrderPaymentDetail(),
                    orderDetailActivity.historyDetailResponse.getCurrency(), orderDetailActivity.historyDetailResponse.getOrderDetail().getDeliveryType());
        } else {
            getOrderInvoice(orderDetailActivity.order.getId());
            if (orderDetailActivity.activeOrderResponse != null) {
                if (orderDetailActivity.activeOrderResponse.isSubmitInvoice()) {
                    btnInvoiceSubmit.setVisibility(View.GONE);
                } else {
                    btnInvoiceSubmit.setVisibility(View.VISIBLE);
                }
            }
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnInvoiceSubmit) {
            setShowInvoice(orderDetailActivity.order.getId());
        }
    }

    private void getOrderInvoice(String orderId) {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
        map.put(ORDER_ID, orderId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> invoiceResponseCall = apiInterface.getInvoice(map);
        invoiceResponseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull Response<InvoiceResponse> response) {
                Utils.hideCustomProgressDialog();
                if (response.body() != null) {
                    if (response.body().isSuccess()) {
                        response.body().getOrderPayment().setTaxIncluded(response.body().isTaxIncluded());
                        loadInvoiceData(response.body().getOrderPayment(), response.body().getCurrency(), Const.DeliveryType.COURIER);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.INVOICE_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setShowInvoice(String orderId) {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
        map.put(ORDER_ID, orderId);
        map.put(Const.Params.IS_USER_SHOW_INVOICE, true);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.setShowInvoice(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (response.body().isSuccess()) {
                    dismiss();
                    orderDetailActivity.activeOrderResponse.setSubmitInvoice(true);
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.INVOICE_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private String setInvoiceMessage() {
        String message = "";
        if (orderPayment.isStorePayDeliveryFees() && orderPayment.isPaymentModeCash()) {
            message = getResources().getString(R.string.msg_delivery_fee_free_and_cash_pay);
        } else if (orderPayment.isStorePayDeliveryFees() && !orderPayment.isPaymentModeCash()) {
            message = getResources().getString(R.string.msg_delivery_fee_free_and_other_pay);
        } else if (orderPayment.isPaymentModeCash()) {
            message = getResources().getString(R.string.msg_pay_cash);
        } else {
            message = getResources().getString(R.string.msg_paid_by_card_payment);
        }

        if (orderPayment.getPromoPayment() > 0) {
            String promo = orderPayment.isPromoForDeliveryService() ? getResources().getString(R.string.msg_delivery_promo) : getResources().getString(R.string.msg_order_promo);
            message = message + "\n" + promo;
        }

        return message;
    }

    private void loadInvoiceData(OrderPayment orderPayment, String currency, int deliveryType) {
        CurrentBooking.getInstance().setDeliveryType(deliveryType);
        this.orderPayment = orderPayment;
        invoiceArrayList = orderDetailActivity.parseContent.parseInvoice(orderPayment, currency, true);
        rcvInvoice.setLayoutManager(new LinearLayoutManager(orderDetailActivity));
        rcvInvoice.setAdapter(new InvoiceAdapter(invoiceArrayList));
        tvOderTotal.setText(String.format("%s%s", currency, orderDetailActivity.parseContent.decimalTwoDigitFormat.format(orderPayment.getPromoPayment() > 0 ? orderPayment.getUserPayPayment() : orderPayment.getTotal())));
        tvInvoiceMsg.setText(setInvoiceMessage());
    }
}