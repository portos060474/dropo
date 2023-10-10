package com.dropo.store.component;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.bumptech.glide.Glide;
import com.dropo.store.R;
import com.dropo.store.HomeActivity;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.OrderStatusResponse;
import com.dropo.store.models.responsemodel.PushDataResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.gson.Gson;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CustomNewOrderDialog extends BottomSheetDialog implements View.OnClickListener {

    private final String TAG = this.getClass().getSimpleName();
    private final Context context;
    private final String response;
    private final Gson gson;
    private TextView txDialogTitle, tvDestAddress;
    private TextView tvClientName, tvTotalItemPrice;
    private TextView tvViewMore, tvOrderNo;
    private Button btnNegative, btnPositive;
    private ImageView ivUserImage;
    private String orderId;
    private int count = 0;
    private PushDataResponse pushDataResponse;

    public CustomNewOrderDialog(@NonNull Context context, String response) {
        super(context);
        this.context = context;
        this.response = response;
        gson = new Gson();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_new_order);

        btnNegative = findViewById(R.id.btnNegative);
        btnPositive = findViewById(R.id.btnPositive);
        txDialogTitle = findViewById(R.id.txDialogTitle);
        tvClientName = findViewById(R.id.tvClientName);
        tvTotalItemPrice = findViewById(R.id.tvTotalItemPrice);
        tvDestAddress = findViewById(R.id.tvDestAddress);
        ivUserImage = findViewById(R.id.ivUserImage);
        tvViewMore = findViewById(R.id.tvViewMore);
        tvOrderNo = findViewById(R.id.tvOrderNo);
        tvViewMore.setOnClickListener(this);
        btnNegative.setText(context.getString(R.string.text_reject));
        btnPositive.setText(context.getString(R.string.text_accept));
        btnPositive.setOnClickListener(this);
        btnNegative.setOnClickListener(this);

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setData();
        setCancelable(true);
    }

    private void setData() {
        pushDataResponse = gson.fromJson(response, PushDataResponse.class);
        Glide.with(context)
                .load(IMAGE_URL.concat(pushDataResponse.getUserImage()))
                .placeholder(R.drawable.placeholder)
                .into(ivUserImage);
        txDialogTitle.setText(context.getString(R.string.text_new_order_request));
        tvClientName.setText(pushDataResponse.getFirstName().concat(" ").concat(pushDataResponse.getLastName()));
        tvDestAddress.setText(pushDataResponse.getDestinationAddresses().get(0).getAddress());
        orderId = pushDataResponse.getOrderId();
        tvTotalItemPrice.setText(String.format("%s %s", pushDataResponse.getCurrency(), ParseContent.getInstance().decimalTwoDigitFormat.format(pushDataResponse.getTotalOrderPrice())));
        count = pushDataResponse.getOrderCount();
        tvOrderNo.setText(String.valueOf(pushDataResponse.getUniqueId()));
        updateUI();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnNegative) {
            rejectOrder();
        } else if (id == R.id.btnPositive) {
            acceptOrder();
        } else if (id == R.id.tvViewMore) {
            dismiss();
            goToActivity();
        }
    }

    private void acceptOrder() {
        Utilities.showProgressDialog(context);
        HashMap<String, Object> map = getCommonParam();
        map.put(Constant.ORDER_STATUS, Constant.STORE_ORDER_ACCEPTED);

        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).setOrderStatus(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utilities.removeProgressDialog();
                sendBroadcast();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        dismiss();
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void rejectOrder() {
        Utilities.showProgressDialog(context);

        HashMap<String, Object> map = getCommonParam();
        map.put(Constant.ORDER_STATUS, Constant.STORE_ORDER_REJECTED);

        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).CancelOrRejectOrder(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                sendBroadcast();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        dismiss();
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private HashMap<String, Object> getCommonParam() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(context).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(context).getServerToken());
        map.put(Constant.ORDER_ID, orderId);
        return map;
    }

    private void sendBroadcast() {
        context.sendBroadcast(new Intent(Constant.Action.ACTION_ORDER_STATUS_ACTION));
    }

    public void notifyDataSetChange(String response) {
        pushDataResponse = gson.fromJson(response, PushDataResponse.class);
        count = pushDataResponse.getOrderCount();
        updateUI();
    }

    private void updateUI() {
        if (count >= 2) {
            btnNegative.setVisibility(View.GONE);
            btnPositive.setVisibility(View.GONE);
            tvViewMore.setVisibility(View.VISIBLE);
            tvViewMore.setText(String.format("%s +%s", context.getResources().getString(R.string.text_view_more), (count - 1)));
        } else {
            btnNegative.setVisibility(View.VISIBLE);
            btnPositive.setVisibility(View.VISIBLE);
            tvViewMore.setVisibility(View.VISIBLE);
            tvViewMore.setText(context.getResources().getString(R.string.text_view_more));
        }
    }

    private void goToActivity() {
        Intent intent = new Intent(context, HomeActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        context.startActivity(intent);
    }
}