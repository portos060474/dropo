package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.OrderInvoiceAdapter;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.responsemodel.InvoiceResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomFontTextViewTitle;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class InstantOrderInvoiceActivity extends BaseActivity {

    public static final String TAG = "InstantOrderInvoiceActivity";
    private CustomButton btnPlaceOrder;
    private CustomFontTextViewTitle tvInvoiceOderTotal;
    private RecyclerView rcvInvoice;
    private InvoiceResponse invoiceResponse;
    private String vehicleId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_instant_order_invoice);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(InstantOrderInvoiceActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_invoice));
        btnPlaceOrder = findViewById(R.id.btnPlaceOrder);
        tvInvoiceOderTotal = findViewById(R.id.tvInvoiceOderTotal);
        rcvInvoice = findViewById(R.id.rcvInvoice);
        btnPlaceOrder.setText(getResources().getString(R.string.text_place_order));
        btnPlaceOrder.setOnClickListener(this);

        if (getIntent().getExtras() != null) {
            invoiceResponse = getIntent().getExtras().getParcelable(Constant.INVOICE);
            vehicleId = getIntent().getExtras().getString(Constant.VEHICLE_ID);
            setInvoiceData(invoiceResponse);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnPlaceOrder) {
            payOrderPayment();
        }
    }


    private void setInvoiceData(InvoiceResponse invoiceResponse) {
        OrderPaymentDetail orderPayment = invoiceResponse.getOrderPayment();
        orderPayment.setTaxIncluded(invoiceResponse.isTaxIncluded());
        String currency = preferenceHelper.getCurrency();

        rcvInvoice.setLayoutManager(new LinearLayoutManager(this));
        rcvInvoice.setNestedScrollingEnabled(false);
        rcvInvoice.setAdapter(new OrderInvoiceAdapter(parseContent.parseInvoice(orderPayment, currency)));
        tvInvoiceOderTotal.setText(String.format("%s%s", currency, parseContent.decimalTwoDigitFormat.format(orderPayment.getTotal())));
        CurrentBooking.getInstance().setTotalInvoiceAmount(orderPayment.getTotal());
        CurrentBooking.getInstance().setOrderPaymentId(orderPayment.getId());
    }

    /**
     * this method called a webservice fro make payment for delivery order
     */
    private void payOrderPayment() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, invoiceResponse.getOrderPayment().getUserId());
        map.put(Constant.IS_PAYMENT_MODE_CASH, true);
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.ORDER_PAYMENT_ID, CurrentBooking.getInstance().getOrderPaymentId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.payOrderPayment(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        createOrderWithEmptyCart();
                    } else {
                        Utilities.hideCustomProgressDialog();
                        parseContent.showErrorMessage(InstantOrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
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

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    /**
     * this method called a webservice for create delivery order
     */
    private void createOrderWithEmptyCart() {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.CART_ID, preferenceHelper.getCartId());
        map.put(Constant.VEHICLE_ID, vehicleId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.createOrderWithEmptyCart(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        parseContent.showMessage(InstantOrderInvoiceActivity.this, response.body().getStatusPhrase());
                        CurrentBooking.getInstance().clearCart();
                        preferenceHelper.putCartId("");
                        preferenceHelper.putAndroidId(Utilities.generateRandomString());
                        goToHomeActivity();
                    } else {
                        parseContent.showErrorMessage(InstantOrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("PAYMENT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}