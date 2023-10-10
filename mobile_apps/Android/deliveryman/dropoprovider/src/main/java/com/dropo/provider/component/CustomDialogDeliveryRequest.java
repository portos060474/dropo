package com.dropo.provider.component;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.os.CountDownTimer;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.dropo.provider.ActiveDeliveryActivity;
import com.dropo.provider.AvailableDeliveryActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.DeliveryAddressAdapter;
import com.dropo.provider.models.datamodels.Addresses;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OrderStatusResponse;
import com.dropo.provider.models.responsemodels.PushDataResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.SoundHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.gson.Gson;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CustomDialogDeliveryRequest extends BottomSheetDialog implements View.OnClickListener {

    private final ImageView ivCustomerImage;
    private final CustomFontTextView tvDeliveryDate;
    private final CustomFontTextView tvOrderRemainTime;
    private final CustomFontTextView tvDeliveryStatus;
    private final CustomFontTextViewTitle tvOrderPrice;
    private final CustomFontTextView tvOrderNumber;
    private final RecyclerView rvAddress;
    private final PreferenceHelper preferenceHelper;
    private final ParseContent parseContent;
    private final Context context;
    private final String orderResponse;
    private final SoundHelper soundHelper;
    private final Gson gson;
    private final Button btnRejectOrder;
    private final Button btnAcceptOrder;
    protected String TAG = this.getClass().getSimpleName();
    private CountDownTimer countDownTimer;
    private boolean isCountDownTimerStart;
    private PushDataResponse pushDataResponse;
    private int count = 0;

    public CustomDialogDeliveryRequest(Context context, String orderResponse, String orderTimeRemain) {
        super(context);
        this.context = context;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_custom_delivery_request);
        gson = new Gson();
        soundHelper = SoundHelper.getInstance(context);
        this.orderResponse = orderResponse;
        preferenceHelper = PreferenceHelper.getInstance(context);
        parseContent = ParseContent.getInstance();
        ivCustomerImage = findViewById(R.id.ivCustomerImage);
        tvOrderPrice = findViewById(R.id.tvOrderPrice);
        tvDeliveryDate = findViewById(R.id.tvDeliveryDate);
        tvOrderRemainTime = findViewById(R.id.tvOrderRemainTime);
        btnRejectOrder = findViewById(R.id.btnRejectOrder);
        btnAcceptOrder = findViewById(R.id.btnAcceptOrder);
        tvDeliveryStatus = findViewById(R.id.tvDeliveryStatus);
        tvOrderNumber = findViewById(R.id.tvOrderNumber);
        rvAddress = findViewById(R.id.rvAddress);
        tvDeliveryStatus.setPaintFlags(tvDeliveryStatus.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        btnRejectOrder.setOnClickListener(this);
        btnAcceptOrder.setOnClickListener(this);
        tvDeliveryStatus.setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
        loadData();
        startCountDownTimer(Integer.parseInt(orderTimeRemain));

        BottomSheetDialog dialog = this;
        BottomSheetBehavior<?> behavior = dialog.getBehavior();
        behavior.setDraggable(false);
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnRejectOrder) {
            stopCountDownTimer();
            rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_REJECTED);
            dismiss();
        } else if (id == R.id.btnAcceptOrder) {
            stopCountDownTimer();
            setOrderStatus(Const.ProviderStatus.DELIVERY_MAN_ACCEPTED);
        } else if (id == R.id.tvDeliveryStatus) {
            stopCountDownTimer();
            dismiss();
            goToActivity();
        }
    }

    public void goToActivity() {
        Intent intent;
        if (count >= 2) {
            intent = new Intent(context, AvailableDeliveryActivity.class);
        } else {
            intent = new Intent(context, ActiveDeliveryActivity.class);
            intent.putExtra(Const.Params.ORDER_ID, pushDataResponse.getRequestId());
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        context.startActivity(intent);
    }

    /**
     * this method is set countDown timer for count a trip accepting time
     *
     * @param seconds seconds
     */
    private void startCountDownTimer(int seconds) {
        if (!isCountDownTimerStart && seconds > 0) {
            isCountDownTimerStart = true;
            final long milliSecond = 1000;
            long millisUntilFinished = seconds * milliSecond;
            countDownTimer = null;
            if (preferenceHelper.getIsNewOrderSoundOn()) {
                soundHelper.playWhenNewOrderSound();
            } else {
                soundHelper.stopWhenNewOrderSound(context);
            }
            countDownTimer = new CountDownTimer(millisUntilFinished, milliSecond) {

                public void onTick(long millisUntilFinished) {
                    final long seconds = millisUntilFinished / milliSecond;
                    tvOrderRemainTime.setText(String.format("%ss", seconds));
                }

                public void onFinish() {
                    if (isCountDownTimerStart) {
                        rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_REJECTED);
                    }
                    stopCountDownTimer();
                    dismiss();

                }

            }.start();
        }
    }

    private void stopCountDownTimer() {
        if (isCountDownTimerStart) {
            isCountDownTimerStart = false;
            countDownTimer.cancel();
            tvOrderRemainTime.setText("");
        }
        soundHelper.stopWhenNewOrderSound(context);
    }

    @Override
    protected void onStop() {
        super.onStop();
        stopCountDownTimer();
    }

    private void rejectOrCancelDeliveryOrder(int orderStatus) {
        Utils.showCustomProgressDialog(context, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.REQUEST_ID, pushDataResponse.getRequestId());
        map.put(Const.Params.DELIVERY_STATUS, orderStatus);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.rejectOrCancelDelivery(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    sendBroadcast();
                    Utils.hideCustomProgressDialog();
                    if (!response.body().isSuccess()) {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable("DIALOG_DELiVERY", t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void loadData() {
        pushDataResponse = gson.fromJson(orderResponse, PushDataResponse.class);
        tvOrderPrice.setText(pushDataResponse.getPickupAddresses().get(0).getUserDetails().getName());
        try {
            if (TextUtils.isEmpty(pushDataResponse.getEstimatedTimeForReadyOrder())) {
                Date date = parseContent.webFormat.parse(pushDataResponse.getCreatedAt());
                if (date != null) {
                    String stringBuilder = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                    tvDeliveryDate.setText(stringBuilder);
                }
            } else {
                Date date = parseContent.webFormat.parse(pushDataResponse.getEstimatedTimeForReadyOrder());
                if (date != null) {
                    if (pushDataResponse.isScheduleOrder()) {
                        tvDeliveryDate.setText(String.format("%s %s", context.getResources().getString(R.string.text_pick_up_order_after), parseContent.dateTimeFormat.format(date)));
                    } else {
                        tvDeliveryDate.setText(String.format("%s %s", context.getResources().getString(R.string.text_pick_up_order_after), parseContent.dateFormat.format(date)));
                    }
                }
            }
        } catch (ParseException e) {
            AppLog.handleThrowable("DIALOG_DELiVERY", e);
        }
        String orderNumber = context.getResources().getString(R.string.text_order_number) + " " + "#" + pushDataResponse.getOrderUniqueId();
        tvOrderNumber.setText(orderNumber);
        Glide.with(context)
                .load(IMAGE_URL + pushDataResponse.getPickupAddresses().get(0).getUserDetails().getImageUrl())
                .placeholder(R.drawable.placeholder)
                .into(ivCustomerImage);
        count = pushDataResponse.getOrderCount();
        if (pushDataResponse.getDeliveryType() == Const.DeliveryType.COURIER) {
            tvOrderPrice.setText(String.format("%s%s", pushDataResponse.getCurrency(), parseContent.decimalTwoDigitFormat.format(pushDataResponse.getTotal())));
        } else {
            tvOrderPrice.setText(String.format("%s%s", pushDataResponse.getCurrency(), parseContent.decimalTwoDigitFormat.format(pushDataResponse.getTotalOrderPrice())));
        }

        List<Addresses> addressesList = new ArrayList<>();
        addressesList.addAll(pushDataResponse.getPickupAddresses());
        addressesList.addAll(pushDataResponse.getDestinationAddresses());
        DeliveryAddressAdapter addressAdapter = new DeliveryAddressAdapter(context, addressesList);
        rvAddress.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false));
        rvAddress.setNestedScrollingEnabled(false);
        rvAddress.setAdapter(addressAdapter);
        updateUI();
    }

    private void setOrderStatus(int orderStatus) {
        Utils.showCustomProgressDialog(context, false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getSessionToken()));
        hashMap.put(Const.Params.PROVIDER_ID, ApiClient.makeTextRequestBody(preferenceHelper.getProviderId()));
        hashMap.put(Const.Params.REQUEST_ID, ApiClient.makeTextRequestBody(pushDataResponse.getRequestId()));
        hashMap.put(Const.Params.DELIVERY_STATUS, ApiClient.makeTextRequestBody(orderStatus));
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderStatusResponse> responseCall = apiInterface.setRequestStatus(null, hashMap);
        responseCall.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    sendBroadcast();
                    Utils.hideCustomProgressDialog();
                    if (!response.body().isSuccess()) {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                    }
                    dismiss();
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void sendBroadcast() {
        context.sendBroadcast(new Intent(Const.Action.ACTION_ORDER_STATUS));
    }

    public void notifyDataSetChange(String orderResponse) {
        pushDataResponse = gson.fromJson(orderResponse, PushDataResponse.class);
        count = pushDataResponse.getOrderCount();
        updateUI();
    }

    private void updateUI() {
        if (count >= 2) {
            btnAcceptOrder.setVisibility(View.GONE);
            btnRejectOrder.setVisibility(View.GONE);
            tvDeliveryStatus.setText(String.format("%s +%s", context.getResources().getString(R.string.text_view_more), (count - 1)));
        } else {
            btnAcceptOrder.setVisibility(View.VISIBLE);
            btnRejectOrder.setVisibility(View.VISIBLE);
            tvDeliveryStatus.setText(context.getResources().getString(R.string.text_view_more));
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        stopCountDownTimer();
    }
}