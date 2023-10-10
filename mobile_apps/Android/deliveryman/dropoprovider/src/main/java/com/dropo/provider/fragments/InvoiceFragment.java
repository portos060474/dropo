package com.dropo.provider.fragments;

import static com.dropo.provider.utils.Const.Params.REQUEST_ID;

import android.os.Bundle;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.BaseAppCompatActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.InvoiceAdapter;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.InvoicePayment;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.models.responsemodels.InvoiceResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class InvoiceFragment extends BottomSheetDialogFragment implements View.OnClickListener {
    private final String TAG = this.getClass().getSimpleName();

    private LinearLayout llInvoiceDistance, llInvoicePayment;
    private OrderPayment orderPayment;
    private CustomFontTextViewTitle tvOderTotal;
    private CustomFontButton btnInvoiceSubmit;
    private RecyclerView rcvInvoice;
    private CustomFontTextView tvInvoiceMsg;
    private String requestId, payment;
    private UserDetail userDetail;
    private int deliveryType;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_order_invoice, container, false);
        llInvoiceDistance = view.findViewById(R.id.llInvoiceDistance);
        llInvoicePayment = view.findViewById(R.id.llInvoicePayment);
        btnInvoiceSubmit = view.findViewById(R.id.btnSave);
        tvOderTotal = view.findViewById(R.id.tvOderTotal);
        rcvInvoice = view.findViewById(R.id.rcvInvoice);
        tvInvoiceMsg = view.findViewById(R.id.tvInvoiceMsg);
        view.findViewById(R.id.btnClose).setOnClickListener(view1 -> dismiss());
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        btnInvoiceSubmit.setOnClickListener(this);
        Bundle bundle = getArguments();
        orderPayment = bundle.getParcelable(Const.ORDER_PAYMENT);
        requestId = bundle.getString(REQUEST_ID);
        payment = bundle.getString(Const.Params.PAYMENT_METHOD);
        userDetail = bundle.getParcelable(Const.USER_DETAIL);
        deliveryType = bundle.getInt(Const.Params.DELIVERY_TYPE);
        boolean backToDelivery = bundle.getBoolean(Const.BACK_TO_ACTIVE_DELIVERY);
        if (orderPayment != null) {
            setInvoiceData();
            setInvoiceDistanceAndTime();
            setInvoicePayments();
            setInvoiceMessage(!backToDelivery);
        } else {
            getOrderInvoice(requestId);
        }
        if (backToDelivery) {
            btnInvoiceSubmit.setVisibility(View.VISIBLE);
        } else {
            btnInvoiceSubmit.setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnSave) {
            setShowInvoice(requestId);
        }
    }

    private void setInvoiceData() {
        rcvInvoice.setLayoutManager(new LinearLayoutManager(getContext()));
        rcvInvoice.setAdapter(new InvoiceAdapter(ParseContent.getInstance().parseInvoice(orderPayment, deliveryType)));
    }

    /**
     * this method will help to load a image in invoice screen
     *
     * @param title    set tile text
     * @param subTitle set sub title text
     * @param id       sett image id in image resource
     * @return invoicePayment object
     */
    private InvoicePayment loadInvoiceImage(String title, String subTitle, int id) {
        InvoicePayment invoicePayment = new InvoicePayment();
        invoicePayment.setTitle(title);
        invoicePayment.setValue(subTitle);
        invoicePayment.setImageId(id);
        return invoicePayment;
    }

    /**
     * this method used to set invoice distance and time view
     */
    private void setInvoiceDistanceAndTime() {
        String unit = orderPayment.isDistanceUnitMile() ? getResources().getString(R.string.unit_mile) : getResources().getString(R.string.unit_km);

        ArrayList<InvoicePayment> invoicePayments = new ArrayList<>();
        invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_time_h_m), Utils.minuteToHoursMinutesSeconds(orderPayment.getTotalTime()), R.drawable.ic_wall_clock_24dp));
        invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_distance), appendString(orderPayment.getTotalDistance(), unit), R.drawable.ic_route_24dp));
        invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_pay), payment, orderPayment.isPaymentModeCash() ? R.drawable.ic_cash : R.drawable.ic_wallet_payment_stroke));

        int size = invoicePayments.size();
        for (int i = 0; i < size; i++) {
            CardView cardView = (CardView) llInvoiceDistance.getChildAt(i);
            LinearLayout currentLayout = (LinearLayout) cardView.getChildAt(0);
            ImageView imageView = (ImageView) currentLayout.getChildAt(0);
            imageView.setImageDrawable(AppCompatResources.getDrawable(requireContext(), invoicePayments.get(i).getImageId()));
            ((CustomFontTextView) currentLayout.getChildAt(1)).setText(invoicePayments.get(i).getTitle());
            ((CustomFontTextView) currentLayout.getChildAt(2)).setText(invoicePayments.get(i).getValue());
        }
    }

    /**
     * this method used to set invoice payment view
     */
    private void setInvoicePayments() {
        String currency = CurrentOrder.getInstance().getCurrency();

        ArrayList<InvoicePayment> invoicePayments = new ArrayList<>();
        invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_wallet), appendString(currency, orderPayment.getWalletPayment()), R.drawable.ic_wallet_24dp));

        if (orderPayment.isPaymentModeCash()) {
            invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_cash), appendString(currency, orderPayment.getCashPayment()), R.drawable.ic_cash));
        } else {
            invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_card), appendString(currency, orderPayment.getCardPayment()), R.drawable.ic_wallet_payment_stroke));
        }
        invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_promo), appendString(currency, orderPayment.getPromoPayment()), R.drawable.ic_promo_code));

        int size = invoicePayments.size();
        for (int i = 0; i < size; i++) {
            CardView cardView = (CardView) llInvoicePayment.getChildAt(i);
            LinearLayout currentLayout = (LinearLayout) cardView.getChildAt(0);
            ImageView imageView = (ImageView) currentLayout.getChildAt(0);
            imageView.setImageDrawable(AppCompatResources.getDrawable(requireContext(), invoicePayments.get(i).getImageId()));
            ((CustomFontTextView) currentLayout.getChildAt(1)).setText(invoicePayments.get(i).getTitle());
            ((CustomFontTextView) currentLayout.getChildAt(2)).setText(invoicePayments.get(i).getValue());
        }

        tvOderTotal.setText(String.format("%s%s", currency, ParseContent.getInstance().decimalTwoDigitFormat.format(orderPayment.getTotal())));
    }


    private String appendString(String string, Double value) {
        return string + ParseContent.getInstance().decimalTwoDigitFormat.format(value);
    }

    private String appendString(Double value, String unit) {
        return ParseContent.getInstance().decimalTwoDigitFormat.format(value) + unit;
    }

    private void getOrderInvoice(String orderId) {
        Utils.showCustomProgressDialog(getContext(), false);
        HashMap<String, Object> map = new HashMap<>();

        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(requireContext()).getSessionToken());
        map.put(Const.Params.PROVIDER_ID, PreferenceHelper.getInstance(requireContext()).getProviderId());
        map.put(REQUEST_ID, orderId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> invoiceResponseCall = apiInterface.getInvoice(map);
        invoiceResponseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull Response<InvoiceResponse> response) {
                Utils.hideCustomProgressDialog();
                if ((getActivity() instanceof BaseAppCompatActivity) && ((BaseAppCompatActivity) getActivity()).parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        payment = response.body().getPayment();
                        orderPayment = response.body().getOrderPayment();
                        CurrentOrder.getInstance().setCurrency(response.body().getCurrency());
                        setInvoiceData();
                        setInvoiceDistanceAndTime();
                        setInvoicePayments();
                        setInvoiceMessage(false);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), getContext());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setShowInvoice(String orderId) {
        Utils.showCustomProgressDialog(getContext(), false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(requireContext()).getSessionToken());
        map.put(Const.Params.PROVIDER_ID, PreferenceHelper.getInstance(requireContext()).getProviderId());
        map.put(Const.Params.REQUEST_ID, orderId);
        map.put(Const.Params.IS_PROVIDER_SHOW_INVOICE, true);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.setShowInvoice(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if ((getActivity() instanceof BaseAppCompatActivity) && ((BaseAppCompatActivity) getActivity()).parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        dismiss();
                        FeedbackFragment feedbackFragment = new FeedbackFragment();
                        Bundle bundle = new Bundle();
                        bundle.putParcelable(Const.USER_DETAIL, userDetail);
                        bundle.putParcelable(Const.STORE_DETAIL, null);
                        bundle.putString(REQUEST_ID, requestId);
                        bundle.putString(Const.Params.NEW_ORDER, null);
                        feedbackFragment.setArguments(bundle);
                        feedbackFragment.show(getActivity().getSupportFragmentManager(), feedbackFragment.getTag());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), getContext());
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

    private void setInvoiceMessage(boolean isHistory) {
        if (isHistory) {
            if (orderPayment.isStorePayDeliveryFees()) {
                tvInvoiceMsg.setText(getResources().getString(R.string.msg_delivery_fee_free_and_invoice));
            }
        } else if (orderPayment.isPaymentModeCash()) {
            if (orderPayment.isStorePayDeliveryFees()) {
                tvInvoiceMsg.setText(getResources().getString(R.string.msg_delivery_fee_free_and_cash_pay));
            } else {
                tvInvoiceMsg.setText(getResources().getString(R.string.msg_pay_cash));
            }
        } else {
            tvInvoiceMsg.setText(getString(R.string.msg_paid_by_card_payment));
            tvInvoiceMsg.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimensionPixelSize(R.dimen.size_app_text_large));
        }
    }
}