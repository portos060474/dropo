package com.dropo;

import static com.dropo.utils.Const.Params.ORDER_ID;
import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.constraintlayout.widget.Group;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.CancellationReasonAdapter;
import com.dropo.adapter.CourierDeliveryAddressAdapter;
import com.dropo.adapter.CourierItemAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomImageView;
import com.dropo.fragments.FeedbackFragment;
import com.dropo.fragments.InvoiceFragment;
import com.dropo.fragments.OrderPreparedFragment;
import com.dropo.fragments.ProviderTrackFragment;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.Order;
import com.dropo.models.datamodels.Status;
import com.dropo.models.responsemodels.ActiveOrderResponse;
import com.dropo.models.responsemodels.CancellationChargeResponse;
import com.dropo.models.responsemodels.CancellationReasonsResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OrderHistoryDetailResponse;
import com.dropo.models.responsemodels.OrderResponse;
import com.dropo.models.responsemodels.PushDataResponse;
import com.dropo.models.singleton.OrderEdit;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.gson.Gson;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrderDetailActivity extends BaseAppCompatActivity implements BaseAppCompatActivity.OrderStatusListener {

    public Order order, orderDetail;
    public boolean isCourier;
    public ActiveOrderResponse activeOrderResponse;
    public OrderHistoryDetailResponse historyDetailResponse;
    public boolean isShowHistory;
    private TextView ivOrderAccepted, ivOrderReady, ivDeliverymanOneTheWay, ivOrderReceived, tvOrderReady, tvOrderReceived,
            tvTableBooking, tvScheduleDate, tvDeliveryManOneTheWay;
    private ImageView ivStoreImage, ivIcon;
    private TextView tvOrderDate, tvStoreName, tvStoreAddress, tvOrderAcceptedTime, btnCancelOrder, tvOrderReadyTime,
            btnOderDetail, tvDeliveryManOneTime, btnDeliveryManDetail, tvOrderReceivedTime, btnViewInvoice, tvEta,
            btnPickupDetail, btnDeliveryDetail, btnGetCode, btnCourierPickupCode, btnRateUsDeliveryman, btnRateUsStore,
            btnCourierDeliveryDetail;
    private Group groupOrderOnTheWay;
    private String pickupImageUrl, deliveryImageUrl;
    private Dialog orderCancelDialog;
    private String cancelReason;
    private int currentPosition = -1;
    private CustomDialogAlert confirmDialog;
    private BottomSheetDialog chatDialog;

    @Override

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_detail);
        initToolBar();
        initViewById();
        setViewListener();
        getExtraData();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        ivStoreImage = findViewById(R.id.ivStoreImage);
        ivOrderAccepted = findViewById(R.id.ivOrderAccepted);
        ivOrderReady = findViewById(R.id.ivOrderReady);
        ivDeliverymanOneTheWay = findViewById(R.id.ivDeliverymanOneTheWay);
        ivOrderReceived = findViewById(R.id.ivOrderReceived);
        tvOrderDate = findViewById(R.id.tvOrderDate);
        tvStoreName = findViewById(R.id.tvStoreName);
        tvStoreAddress = findViewById(R.id.tvStoreAddress);
        tvOrderAcceptedTime = findViewById(R.id.tvOrderAcceptedTime);
        btnCancelOrder = findViewById(R.id.btnCancelOrder);
        tvOrderReadyTime = findViewById(R.id.tvOrderReadyTime);
        btnOderDetail = findViewById(R.id.btnOderDetail);
        tvDeliveryManOneTime = findViewById(R.id.tvDeliveryManOneTime);
        btnDeliveryManDetail = findViewById(R.id.btnDeliveryManDetail);
        tvOrderReceivedTime = findViewById(R.id.tvOrderReceivedTime);
        btnViewInvoice = findViewById(R.id.btnViewInvoice);
        tvEta = findViewById(R.id.tvEta);
        btnPickupDetail = findViewById(R.id.btnPickupDetail);
        btnDeliveryDetail = findViewById(R.id.btnDeliveryDetail);
        btnGetCode = findViewById(R.id.btnGetCode);
        groupOrderOnTheWay = findViewById(R.id.groupOrderOnTheWay);
        btnCourierPickupCode = findViewById(R.id.btnCourierPickupCode);
        btnRateUsDeliveryman = findViewById(R.id.btnRateUsDeliveryman);
        btnRateUsStore = findViewById(R.id.btnRateUsStore);
        tvOrderReady = findViewById(R.id.tvOrderReady);
        tvOrderReceived = findViewById(R.id.tvOrderReceived);
        tvTableBooking = findViewById(R.id.tvTableBooking);
        tvScheduleDate = findViewById(R.id.tvScheduleDate);
        ivIcon = findViewById(R.id.ivIcon);
        tvDeliveryManOneTheWay = findViewById(R.id.tvDeliveryManOneTheWay);
        btnCourierDeliveryDetail = findViewById(R.id.btnCourierDeliveryDetail);
    }

    @Override
    protected void setViewListener() {
        btnOderDetail.setOnClickListener(this);
        btnDeliveryManDetail.setOnClickListener(this);
        btnCancelOrder.setOnClickListener(this);
        btnGetCode.setOnClickListener(this);
        btnPickupDetail.setOnClickListener(this);
        btnDeliveryDetail.setOnClickListener(this);
        btnCourierPickupCode.setOnClickListener(this);
        btnViewInvoice.setOnClickListener(this);
        btnRateUsStore.setOnClickListener(this);
        btnRateUsDeliveryman.setOnClickListener(this);
        btnCourierDeliveryDetail.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnOderDetail) {
            OrderPreparedFragment orderPreparedFragment = new OrderPreparedFragment();
            orderPreparedFragment.show(getSupportFragmentManager(), Const.Tag.ORDER_DETAILS_FRAGMENT);
        } else if (view.getId() == R.id.btnCourierDeliveryDetail) {
            if (isShowHistory) {
                if (historyDetailResponse != null && historyDetailResponse.getOrderDetail() != null) {
                    if (historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.COURIER) {
                        showCourierDeliveryDetailsDialog(historyDetailResponse.getOrderDetail().getDestinationAddresses(), historyDetailResponse.getStatusTime());
                    } else {
                        showCourierDeliveryDetailsDialog(historyDetailResponse.getOrderDetail().getDestinationAddresses(), null);
                    }
                }
            } else {
                if (order != null) {
                    showCourierDeliveryDetailsDialog(order.getDestinationAddresses(), null);
                }
            }
        } else if (view.getId() == R.id.btnDeliveryManDetail) {
            int orderStatus;
            if (isShowHistory) {
                orderStatus = historyDetailResponse.getOrderDetail().getOrderStatus();
            } else {
                orderStatus = Math.max(activeOrderResponse.getDeliveryStatus(), activeOrderResponse.getOrderStatus());
            }
            if (orderStatus == Const.OrderStatus.DELIVERY_MAN_ACCEPTED || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMING || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED || orderStatus == Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER || orderStatus == Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
                ProviderTrackFragment providerTrackFragment = new ProviderTrackFragment();
                providerTrackFragment.show(getSupportFragmentManager(), providerTrackFragment.getTag());
            } else {
                Utils.showToast(getResources().getString(R.string.msg_order_not_pickup_at), this);
            }
        } else if (view.getId() == R.id.btnCancelOrder) {
            if (isCourier) {
                getCancellationReasons(0.0);
            } else {
                getCancellationCharges();
            }
        } else if (view.getId() == R.id.btnGetCode) {
            openConfirmCodeDialog(activeOrderResponse.getConfirmationCode());
        } else if (view.getId() == R.id.btnDeliveryDetail) {
            openDialogItemImage(deliveryImageUrl, getResources().getString(R.string.text_delivery_image));
        } else if (view.getId() == R.id.btnPickupDetail) {
            openDialogItemImage(pickupImageUrl, getResources().getString(R.string.text_pickup_image));
        } else if (view.getId() == R.id.btnCourierPickupCode) {
            openConfirmCodeDialog(activeOrderResponse.getConfirmationCodeForPickUpDelivery());
        } else if (view.getId() == R.id.btnViewInvoice) {
            InvoiceFragment invoiceFragment = new InvoiceFragment();
            invoiceFragment.show(getSupportFragmentManager(), invoiceFragment.getTag());
        } else if (view.getId() == R.id.btnRateUsDeliveryman) {
            FeedbackFragment feedbackFragment = new FeedbackFragment();
            Bundle bundle = new Bundle();
            bundle.putBoolean(Const.Params.IS_STORE_RATING, false);
            feedbackFragment.setArguments(bundle);
            feedbackFragment.show(getSupportFragmentManager(), feedbackFragment.getTag());

        } else if (view.getId() == R.id.btnRateUsStore) {
            FeedbackFragment feedbackFragment = new FeedbackFragment();
            Bundle bundle = new Bundle();
            bundle.putBoolean(Const.Params.IS_STORE_RATING, true);
            feedbackFragment.setArguments(bundle);
            feedbackFragment.show(getSupportFragmentManager(), feedbackFragment.getTag());
        } else if (view.getId() == R.id.ivToolbarRightIcon3) {
            openChatDialog();
        }
    }

    private void showCourierDeliveryDetailsDialog(List<Addresses> destinationAddresses, ArrayList<Status> statusTime) {
        BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_courier_delivery_details);

        RecyclerView rvDeliveryAddress = dialog.findViewById(R.id.rvDeliveryAddress);

        if (statusTime != null && !statusTime.isEmpty()) {
            for (int i = 0; i < destinationAddresses.size(); i++) {
                for (Status status : statusTime) {
                    if (status.getStopNo() == i + 1) {
                        try {
                            Date date = parseContent.webFormat.parse(status.getDate());
                            if (date != null) {
                                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                                destinationAddresses.get(i).setArrivedTime(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
                            }
                            break;
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        CourierDeliveryAddressAdapter addressAdapter = new CourierDeliveryAddressAdapter(destinationAddresses);
        rvDeliveryAddress.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvDeliveryAddress.setAdapter(addressAdapter);

        dialog.findViewById(R.id.btnCancel).setOnClickListener(view -> dialog.dismiss());

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);

        BottomSheetBehavior<?> behavior = dialog.getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);

        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        dialog.setCancelable(false);
        dialog.show();
    }

    private void getCancellationCharges() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.ORDER_ID, order.getId());
        Utils.showCustomProgressDialog(this, false);
        Call<CancellationChargeResponse> call = ApiClient.getClient().create(ApiInterface.class).getCancellationCharges(map);
        call.enqueue(new Callback<CancellationChargeResponse>() {
            @Override
            public void onResponse(@NonNull Call<CancellationChargeResponse> call, @NonNull Response<CancellationChargeResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        getCancellationReasons(response.body().getCancellationCharge());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), OrderDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CancellationChargeResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(FeedbackFragment.class.getSimpleName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            isShowHistory = getIntent().getBooleanExtra(Const.Params.IS_SHOW_HISTORY, false);
            order = new Order();
            if (isShowHistory) {
                getOrderHistoryDetail(getIntent().getExtras().getString(Const.Params.ORDER_ID));
                btnDeliveryManDetail.setText(R.string.text_view_delivery_man);
                btnViewInvoice.setText(R.string.text_view_invoice);
                btnViewInvoice.setVisibility(View.VISIBLE);
                btnCancelOrder.setVisibility(View.GONE);
            } else {
                setToolbarRightIcon3(R.drawable.ic_chat, this);
                tvOrderDate.setVisibility(View.GONE);
                if (getIntent().getExtras().getParcelable(Const.Params.ORDER) != null) {
                    order = getIntent().getExtras().getParcelable(Const.Params.ORDER);
                } else {
                    String pusData = getIntent().getExtras().getString(Const.Params.PUSH_DATA1);
                    PushDataResponse pushDataResponse = new Gson().fromJson(pusData, PushDataResponse.class);
                    order.setId(pushDataResponse.getOrderId());
                    order.setStoreName(pushDataResponse.getStoreName());
                }
                getOrderDetails();
                setTitleOnToolBar(order.getStoreName());
            }
        }
    }

    /**
     * this method called webservice for get order status
     *
     * @param orderId oderId in string
     */
    public void getOrderStatus(final String orderId) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(ORDER_ID, orderId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ActiveOrderResponse> responseCall = apiInterface.getActiveOrderStatus(map);
        responseCall.enqueue(new Callback<ActiveOrderResponse>() {
            @Override
            public void onResponse(@NonNull Call<ActiveOrderResponse> call, @NonNull Response<ActiveOrderResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        activeOrderResponse = response.body();
                        String orderNumber = getResources().getString(R.string.text_order_number) + " " + "#" + activeOrderResponse.getUniqueId();
                        setTitleOnToolBar(orderNumber);
                        int orderStatus = Math.max(activeOrderResponse.getDeliveryStatus(), activeOrderResponse.getOrderStatus());
                        isCourier = activeOrderResponse.getDeliveryType() == Const.DeliveryType.COURIER;
                        checkOrderStatus(orderStatus);
                        updateUIAsPerDelivery(activeOrderResponse.isUserPickUpOrder() || activeOrderResponse.getDeliveryType() == Const.DeliveryType.TABLE_BOOKING, activeOrderResponse.isConfirmationCodeRequiredAtCompleteDelivery(), activeOrderResponse.isConfirmationCodeRequiredAtPickupDelivery() && activeOrderResponse.getDeliveryType() == Const.DeliveryType.COURIER, activeOrderResponse.getProvider() != null && !activeOrderResponse.isUserPickUpOrder() && (orderStatus == Const.OrderStatus.DELIVERY_MAN_ACCEPTED || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMING || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED || orderStatus == Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER || orderStatus == Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) && activeOrderResponse.getDeliveryType() != Const.DeliveryType.TABLE_BOOKING, activeOrderResponse.getDeliveryType() == Const.DeliveryType.TABLE_BOOKING);
                        getDateAndTimeOnStatus(activeOrderResponse.getDeliveryStatus(), activeOrderResponse.getDeliveryStatusDetails(), activeOrderResponse.getOrderStatusDetails());
                        if (activeOrderResponse.getPickupAddresses() != null) {
                            setStoreDate(activeOrderResponse.getPickupAddresses().get(0), null);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), OrderDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ActiveOrderResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.ORDER_TRACK_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });

    }

    private void checkOrderStatus(int orderStatus) {
        updateUiCancelOrder(false);
        btnViewInvoice.setVisibility(View.GONE);
        if (isCourier) {
            switch (orderStatus) {
                case Const.OrderStatus.WAITING_FOR_DELIVERY_MEN:
                case Const.OrderStatus.DELIVERY_MAN_REJECTED:
                case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
                case Const.OrderStatus.DELIVERY_MAN_NOT_FOUND:
                    updateUiCancelOrder(true);
                    statusUnComplete(ivOrderAccepted);
                    statusUnComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_ACCEPTED:
                case Const.OrderStatus.DELIVERY_MAN_COMING:
                    updateUiCancelOrder(true);
                case Const.OrderStatus.DELIVERY_MAN_ARRIVED:
                    statusComplete(ivOrderAccepted);
                    statusUnComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusComplete(ivOrderReceived);
                    btnViewInvoice.setVisibility(View.VISIBLE);
                    btnRateUsStore.setVisibility(View.GONE);
                    if (isShowHistory) {
                        if (historyDetailResponse.getOrderDetail().isUserRatedToProvider()) {
                            setRatingForDeliveryMan(historyDetailResponse.getOrderDetail().getUserRatingToProvider());
                        } else {
                            btnRateUsDeliveryman.setVisibility(View.VISIBLE);
                        }
                    } else {
                        btnRateUsDeliveryman.setVisibility(View.VISIBLE);
                    }
                    setToolbarRightIcon3(-1, null);
                    break;
                default:
                    // do with default
                    break;
            }
        } else {
            switch (orderStatus) {
                case Const.OrderStatus.WAITING_FOR_ACCEPT_STORE:
                    statusUnComplete(ivOrderAccepted);
                    statusUnComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.STORE_ORDER_ACCEPTED:
                case Const.OrderStatus.STORE_ORDER_PREPARING:
                case Const.OrderStatus.WAITING_FOR_DELIVERY_MEN:
                    statusComplete(ivOrderAccepted);
                    statusUnComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;

                case Const.OrderStatus.STORE_ORDER_READY:
                case Const.OrderStatus.DELIVERY_MAN_ACCEPTED:
                case Const.OrderStatus.DELIVERY_MAN_COMING:
                case Const.OrderStatus.DELIVERY_MAN_REJECTED:
                case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
                case Const.OrderStatus.DELIVERY_MAN_NOT_FOUND:
                case Const.OrderStatus.DELIVERY_MAN_ARRIVED:
                case Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusUnComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;

                case Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusUnComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusComplete(ivOrderReceived);
                    break;
                case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                    statusComplete(ivOrderAccepted);
                    statusComplete(ivOrderReady);
                    statusComplete(ivDeliverymanOneTheWay);
                    statusComplete(ivOrderReceived);
                    btnViewInvoice.setVisibility(View.VISIBLE);
                    if (isShowHistory) {
                        if (historyDetailResponse.getOrderPaymentDetail().isUserPickUpOrder()) {
                            btnRateUsDeliveryman.setVisibility(View.GONE);
                        } else {
                            btnRateUsDeliveryman.setVisibility(View.VISIBLE);
                            if (historyDetailResponse.getOrderDetail().isUserRatedToProvider()) {
                                setRatingForDeliveryMan(historyDetailResponse.getOrderDetail().getUserRatingToProvider());
                            }
                        }
                        if (historyDetailResponse.getOrderDetail().isUserRatedToStore()) {
                            setRatingForStore(historyDetailResponse.getOrderDetail().getUserRatingToStore());
                        } else {
                            btnRateUsStore.setVisibility(View.VISIBLE);
                        }
                    } else {
                        if (activeOrderResponse.getProvider() == null || activeOrderResponse.isUserPickUpOrder()) {
                            btnRateUsDeliveryman.setVisibility(View.GONE);
                        } else {
                            btnRateUsDeliveryman.setVisibility(View.VISIBLE);
                        }
                        btnRateUsStore.setVisibility(View.VISIBLE);
                    }
                    setToolbarRightIcon3(-1, null);
                    break;
                case Const.OrderStatus.STORE_ORDER_REJECTED:
                case Const.OrderStatus.STORE_ORDER_CANCELLED:
                    if (!isShowHistory) {
                        onBackPressed();
                    }
                    break;
                default:
                    // do with default
                    break;
            }
            if (!isShowHistory && activeOrderResponse != null) {
                updateUiCancelOrder(orderStatus < activeOrderResponse.getCancellationChargeApplyTill());
            }
        }

        boolean isRunning = orderStatus == Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER || orderStatus == Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY;
        if (isShowHistory) {
            if (isRunning) {
                tvEta.setText(Utils.minuteToHoursMinutesSeconds(historyDetailResponse.getOrderPaymentDetail().getTotalTime()));
            } else {
                tvEta.setText(Utils.minuteToHoursMinutesSecondsWithText(0.0));
            }
        } else {
            if (activeOrderResponse != null) {
                if (isRunning) {
                    tvEta.setText(Utils.minuteToHoursMinutesSecondsWithText(activeOrderResponse.getEstimatedTimeForDeliveryInMin()));
                } else {
                    tvEta.setText(Utils.minuteToHoursMinutesSecondsWithText(activeOrderResponse.getTotalTime() + activeOrderResponse.getEstimatedTimeForDeliveryInMin()));
                }
            }
        }
    }

    private void updateUiCancelOrder(boolean show) {
        if (show) {
            btnCancelOrder.setOnClickListener(this);
            btnCancelOrder.setVisibility(View.VISIBLE);
        } else {
            btnCancelOrder.setOnClickListener(null);
            btnCancelOrder.setVisibility(View.GONE);
        }
    }

    private void getDateAndTimeOnStatus(int orderStatus, List<Status> deliveryStatusDetails, List<Status> orderStatusDetails) {
        List<Status> statusList = new ArrayList<>();
        statusList.addAll(deliveryStatusDetails);
        statusList.addAll(orderStatusDetails);
        if (isCourier && (orderStatus == Const.OrderStatus.WAITING_FOR_DELIVERY_MEN || orderStatus == Const.OrderStatus.DELIVERY_MAN_REJECTED || orderStatus == Const.OrderStatus.DELIVERY_MAN_CANCELLED || orderStatus == Const.OrderStatus.DELIVERY_MAN_NOT_FOUND)) {
            tvOrderAcceptedTime.setText("");
            tvOrderAcceptedTime.setText("");
        } else {
            for (Status status : statusList) {
                if (Const.OrderStatus.STORE_ORDER_ACCEPTED == status.getStatus() || (isCourier && Const.OrderStatus.DELIVERY_MAN_ACCEPTED == status.getStatus())) {
                    setDateAnTime(tvOrderAcceptedTime, status.getDate());
                } else if (Const.OrderStatus.STORE_ORDER_READY == status.getStatus() || Const.OrderStatus.TABLE_BOOKING_ARRIVED == status.getStatus() || (isCourier && Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER == status.getStatus())) {
                    setDateAnTime(tvOrderReadyTime, status.getDate());
                } else if (Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER == status.getStatus()) {
                    if (!TextUtils.isEmpty(status.getImageUrl())) {
                        btnPickupDetail.setVisibility(View.VISIBLE);
                        pickupImageUrl = status.getImageUrl();
                    }
                } else if (Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY == status.getStatus()) {
                    setDateAnTime(tvDeliveryManOneTime, status.getDate());
                } else if (Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION == status.getStatus()) {
                    setDateAnTime(tvOrderReceivedTime, status.getDate());
                    if (!TextUtils.isEmpty(status.getImageUrl())) {
                        btnDeliveryDetail.setVisibility(View.VISIBLE);
                        deliveryImageUrl = status.getImageUrl();
                    }
                } else if (Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY == status.getStatus()) {
                    setDateAnTime(tvOrderReceivedTime, status.getDate());
                }

                if (Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER == status.getStatus()) {
                    if (!TextUtils.isEmpty(status.getImageUrl())) {
                        btnPickupDetail.setVisibility(View.VISIBLE);
                        pickupImageUrl = status.getImageUrl();
                    }
                } else if (Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION == status.getStatus()) {
                    setDateAnTime(tvOrderReceivedTime, status.getDate());
                    if (!TextUtils.isEmpty(status.getImageUrl())) {
                        btnDeliveryDetail.setVisibility(View.VISIBLE);
                        deliveryImageUrl = status.getImageUrl();
                    }
                }
            }
        }
    }

    private void setDateAnTime(TextView timeView, String dateAndTime) {
        try {
            Date date = parseContent.webFormat.parse(dateAndTime);
            if (date != null) {
                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                timeView.setText(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
            }
            timeView.setVisibility(View.VISIBLE);

        } catch (ParseException e) {
            AppLog.handleException(OrderDetailActivity.class.getSimpleName(), e);
        }
    }

    @Override
    public void onOrderStatus() {
        if (!isShowHistory && !TextUtils.isEmpty(order.getId())) {
            getOrderStatus(order.getId());
        }
    }


    @Override
    protected void onStop() {
        super.onStop();
        setOrderStatusListener(null);
    }

    @Override
    protected void onResume() {
        super.onResume();
        setOrderStatusListener(isShowHistory ? null : this);
        if (!isShowHistory && !TextUtils.isEmpty(order.getId())) {
            getOrderStatus(order.getId());
        }


    }

    private void updateUIAsPerDelivery(boolean isPickupByUser, boolean isConfirmCodeRequried, boolean isConfirmCodePickup, boolean isShowDeliveryManDetails, boolean isTableBooking) {
        if (isConfirmCodeRequried) {
            btnGetCode.setVisibility(View.VISIBLE);
        } else {
            btnGetCode.setVisibility(View.GONE);
        }
        if (isConfirmCodePickup) {
            btnCourierPickupCode.setVisibility(View.VISIBLE);
        } else {
            btnCourierPickupCode.setVisibility(View.GONE);
        }
        if (isPickupByUser) {
            groupOrderOnTheWay.setVisibility(View.GONE);
            btnRateUsDeliveryman.setVisibility(View.GONE);
            ivOrderReceived.setText("3");
            if (isTableBooking) {
                tvOrderReady.setText(getResources().getString(R.string.text_customer_arrived));
                tvOrderReceived.setText(getResources().getString(R.string.text_order_completed));
            }
        } else {
            groupOrderOnTheWay.setVisibility(View.VISIBLE);
            ivOrderReceived.setText("4");
        }

        if (isCourier) {
            tvOrderReady.setText(getString(R.string.text_picked_up));
            tvDeliveryManOneTheWay.setText(getString(R.string.text_in_transit));
        }
        btnDeliveryManDetail.setVisibility(isShowDeliveryManDetails ? View.VISIBLE : View.GONE);
    }

    private void statusComplete(TextView textView) {
        textView.setBackground(ResourcesCompat.getDrawable(getResources(), R.drawable.shape_custom_status, getTheme()));
        textView.getBackground().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(this) ? R.color.color_app_tag_light : R.color.color_app_tag_dark, null));
        textView.setTextColor(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(this) ? R.color.color_app_text_light : R.color.color_app_text_dark, null));
    }

    private void statusUnComplete(TextView textView) {
        textView.setBackground(ResourcesCompat.getDrawable(getResources(), R.drawable.shape_custom_status, getTheme()));
        textView.getBackground().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(this) ? R.color.color_app_tag_dark : R.color.color_app_tag_light, null));
        textView.setTextColor(AppColor.getThemeTextColor(this));
    }

    /**
     * this method called a webservice for get order history detail
     *
     * @param orderId order id in string
     */
    private void getOrderHistoryDetail(final String orderId) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.ORDER_ID, orderId);
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderHistoryDetailResponse> responseCall = apiInterface.getOrderHistoryDetail(map);
        responseCall.enqueue(new Callback<OrderHistoryDetailResponse>() {
            @Override
            public void onResponse(Call<OrderHistoryDetailResponse> call, Response<OrderHistoryDetailResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        historyDetailResponse = response.body();

                        if (historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.COURIER) {
                            if (historyDetailResponse.getOrderDetail().getCourierItemsImages() == null || historyDetailResponse.getOrderDetail().getCourierItemsImages().isEmpty()) {
                                btnOderDetail.setVisibility(View.GONE);
                            }
                            btnCourierDeliveryDetail.setVisibility(View.VISIBLE);
                        }

                        Date date = null;
                        try {
                            date = parseContent.webFormat.parse(historyDetailResponse.getOrderDetail().getCreatedAt());
                            tvOrderDate.setVisibility(View.VISIBLE);
                            String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                            tvOrderDate.setText(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                        setTitleOnToolBar(getResources().getString(R.string.text_order_number) + " #" + historyDetailResponse.getOrderDetail().getUniqueId());
                        isCourier = historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.COURIER;
                        checkOrderStatus(historyDetailResponse.getOrderDetail().getOrderStatus());
                        setStoreDate(null, historyDetailResponse);
                        getDateAndTimeOnStatus(historyDetailResponse.getOrderDetail().getOrderStatus(), historyDetailResponse.getOrderDetail().getStatusTime(), historyDetailResponse.getStatusTime());
                        updateUIAsPerDelivery(historyDetailResponse.getOrderPaymentDetail().isUserPickUpOrder() || historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.TABLE_BOOKING, false, false, historyDetailResponse.getProviderDetail() != null && !historyDetailResponse.getOrderPaymentDetail().isUserPickUpOrder() && (historyDetailResponse.getOrderDetail().getOrderStatus() == Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER || historyDetailResponse.getOrderDetail().getOrderStatus() == Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY || historyDetailResponse.getOrderDetail().getOrderStatus() == Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || historyDetailResponse.getOrderDetail().getOrderStatus() == Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) && historyDetailResponse.getOrderDetail().getDeliveryType() != Const.DeliveryType.TABLE_BOOKING, historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.TABLE_BOOKING);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), OrderDetailActivity.this);
                    }
                    Utils.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(Call<OrderHistoryDetailResponse> call, Throwable t) {
                AppLog.handleThrowable(OrderDetailActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getOrderDetails() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.ORDER_ID, order.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderResponse> call = apiInterface.getOrderDetail(map);
        call.enqueue(new Callback<OrderResponse>() {
            @Override
            public void onResponse(Call<OrderResponse> call, Response<OrderResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        order = response.body().getOrder();
                        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                            if (order.getCourierItemsImages() == null || order.getCourierItemsImages().isEmpty()) {
                                btnOderDetail.setVisibility(View.GONE);
                            }
                            btnCourierDeliveryDetail.setVisibility(View.VISIBLE);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), OrderDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(Call<OrderResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setStoreDate(Addresses addresses, OrderHistoryDetailResponse detailResponse) {
        if (addresses == null) {
            GlideApp.with(this).load(IMAGE_URL + detailResponse.getStore().getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivStoreImage);
            tvStoreName.setText(isCourier ? detailResponse.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName() : detailResponse.getStore().getName());
            order.setStoreName(detailResponse.getStore().getName());
            tvStoreAddress.setText(isCourier ? detailResponse.getCartDetail().getDestinationAddresses().get(0).getAddress() : detailResponse.getCartDetail().getPickupAddresses().get(0).getAddress());

            if (isCourier && isShowHistory) {
                tvStoreName.setText(detailResponse.getCartDetail().getPickupAddresses().get(0).getUserDetails().getName());
                tvStoreAddress.setText(detailResponse.getCartDetail().getPickupAddresses().get(0).getAddress());
            }
            setScheduleUI(historyDetailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.TABLE_BOOKING, detailResponse.getCartDetail().getTableNo(), detailResponse.getCartDetail().getNoOfPerson());
        } else {
            CartUserDetail userData = addresses.getUserDetails();
            GlideApp.with(this).load(IMAGE_URL + userData.getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivStoreImage);
            tvStoreName.setText(userData.getName());
            order.setStoreName(userData.getName());
            tvStoreAddress.setText(addresses.getAddress());
            setScheduleUI(order.getDeliveryType() == Const.DeliveryType.TABLE_BOOKING, order.getOrderData() == null ? "" : order.getOrderData().getTableNo(), order.getOrderData() == null ? "" : order.getOrderData().getNoOfPerson());
        }
    }

    @SuppressLint("StringFormatInvalid")
    private void setScheduleUI(boolean isTableBooking, String tableNo, String noOfPerson) {
        if (isTableBooking) {
            tvTableBooking.setText(getString(R.string.text_table_no_booked_for_people, tableNo, noOfPerson));
            tvTableBooking.setVisibility(View.VISIBLE);
            ivIcon.setVisibility(View.VISIBLE);
            tvScheduleDate.setVisibility(View.VISIBLE);
            String date = isShowHistory ? historyDetailResponse.getOrderDetail().getScheduleOrderStartAt() : order.getScheduleOrderStartAt();
            if (!TextUtils.isEmpty(date)) {
                try {
                    tvScheduleDate.setText(getString(R.string.text_scheduled_at, parseContent.dateTimeFormat_am.format(parseContent.webFormat.parse(date))));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            ivIcon.setImageResource(R.drawable.ic_table_reservation);
        } else if ((isShowHistory && historyDetailResponse.getOrderDetail().isScheduleOrder()) || (order != null && order.isScheduleOrder())) {
            tvTableBooking.setVisibility(View.VISIBLE);
            ivIcon.setVisibility(View.VISIBLE);
            tvScheduleDate.setVisibility(View.GONE);
            String date = isShowHistory ? historyDetailResponse.getOrderDetail().getScheduleOrderStartAt() : order.getScheduleOrderStartAt();
            if (!TextUtils.isEmpty(date)) {
                try {
                    tvTableBooking.setText(getString(R.string.text_scheduled_at, parseContent.dateTimeFormat_am.format(parseContent.webFormat.parse(date))));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            ivIcon.setImageResource(R.drawable.ic_schedule);
        } else {
            tvScheduleDate.setVisibility(View.GONE);
            ivIcon.setVisibility(View.GONE);
            tvTableBooking.setVisibility(View.GONE);
        }
    }

    private void getCancellationReasons(Double cancellationCharge) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CancellationReasonsResponse> responseCall = apiInterface.getCancellationReasons(map);
        responseCall.enqueue(new Callback<CancellationReasonsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CancellationReasonsResponse> call, @NonNull Response<CancellationReasonsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response) && response.body() != null) {
                    openCancelOrderDialog(cancellationCharge, response.body().getReasons());
                } else {
                    openCancelOrderDialog(cancellationCharge, new ArrayList<>());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CancellationReasonsResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
                openCancelOrderDialog(cancellationCharge, new ArrayList<>());
            }
        });
    }


    private void openCancelOrderDialog(double cancellationAmount, ArrayList<
            String> cancellationReason) {
        if (orderCancelDialog != null && orderCancelDialog.isShowing()) {
            return;
        }

        orderCancelDialog = new BottomSheetDialog(this);
        orderCancelDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        orderCancelDialog.setContentView(R.layout.dialog_cancel_order);

        final CustomFontTextView tvCancelMessage, tvCharge;
        final CancellationReasonAdapter cancellationReasonAdapter;
        final RecyclerView rvCancellationReason;

        tvCharge = orderCancelDialog.findViewById(R.id.tvCharge);
        tvCancelMessage = orderCancelDialog.findViewById(R.id.tvCancelMessage);
        rvCancellationReason = orderCancelDialog.findViewById(R.id.rvCancellationReason);

        if (cancellationReason.isEmpty()) {
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_one));
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_two));
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_three));
        }
        cancellationReason.add(getString(R.string.text_other));

        cancellationReasonAdapter = new CancellationReasonAdapter(cancellationReason) {
            @Override
            public void onReasonSelected(int position) {
                currentPosition = position;
            }
        };
        rvCancellationReason.setAdapter(cancellationReasonAdapter);

        orderCancelDialog.findViewById(R.id.btnDialogAlertRight).setOnClickListener(view -> {
            if (currentPosition != -1) {
                if (currentPosition == cancellationReason.size() - 1) {
                    LinearLayoutManager linearLayoutManager = (LinearLayoutManager) rvCancellationReason.getLayoutManager();
                    View view1 = Objects.requireNonNull(linearLayoutManager).findViewByPosition(currentPosition);
                    cancelReason = ((EditText) Objects.requireNonNull(view1).findViewById(R.id.etOthersReason)).getText().toString();
                } else {
                    cancelReason = cancellationReason.get(currentPosition);
                }
            }

            if (cancelReason != null && !cancelReason.isEmpty()) {
                orderCancelDialog.dismiss();
                cancelOrder(cancelReason);
            } else {
                Utils.showToast(getResources().getString(R.string.msg_plz_give_valid_reason), OrderDetailActivity.this);
            }
        });

        orderCancelDialog.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> {
            orderCancelDialog.dismiss();
            cancelReason = "";
        });

        WindowManager.LayoutParams params = orderCancelDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        orderCancelDialog.setCancelable(false);
        orderCancelDialog.show();

        if (cancellationAmount > 0 && order.getStore().isOrderCancellationChargeApply()) {
            tvCharge.setText(activeOrderResponse.getCurrency() + parseContent.decimalTwoDigitFormat.format(cancellationAmount));
            tvCharge.setVisibility(View.VISIBLE);
            tvCancelMessage.setVisibility(View.VISIBLE);
        } else {
            tvCancelMessage.setVisibility(View.GONE);
            tvCharge.setVisibility(View.GONE);
        }

    }

    private void cancelOrder(String cancelReason) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.ORDER_ID, order.getId());
        map.put(Const.Params.ORDER_STATUS, Const.OrderStatus.ORDER_CANCELED_BY_USER);
        map.put(Const.Params.CANCEL_REASON, cancelReason);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.cancelOrder(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(Call<IsSuccessResponse> call, Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        onBackPressed();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), OrderDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(Call<IsSuccessResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.ORDER_TRACK_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });

    }

    private void openConfirmCodeDialog(String code) {
        if (confirmDialog != null && confirmDialog.isShowing()) {
            return;
        }
        confirmDialog = new CustomDialogAlert(this, getResources().getString(R.string.text_confirmation_code), code, getResources().getString(R.string.text_share)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                shareConfirmationCode();
            }
        };
        confirmDialog.show();

    }

    /**
     * this method will help to share your delivery conformation code to other user
     */
    private void shareConfirmationCode() {
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, getResources().getString(R.string.msg_delivery_confirm_code_is) + " " + activeOrderResponse.getConfirmationCode());
        startActivity(Intent.createChooser(sharingIntent, getResources().getString(R.string.msg_share_confirmation_code)));
    }

    public void openDialogItemImage(String imageUrl, String title) {
        BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.item_image_full_screen);

        TextView tvDialogAlertTitle = dialog.findViewById(R.id.tvDialogAlertTitle);
        tvDialogAlertTitle.setText(title);
        ImageView imageView = dialog.findViewById(R.id.itemImage);
        CustomImageView ivDelete = dialog.findViewById(R.id.ivDelete);

        GlideApp.with(this).load(IMAGE_URL + imageUrl).dontAnimate().placeholder(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null)).into(imageView);


        ivDelete.setOnClickListener(v -> dialog.dismiss());
        imageView.setOnClickListener(v -> dialogFullScreenImage(imageUrl));

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.show();

    }

    public void dialogFullScreenImage(String imageUrl) {
        Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_item_image);
        ViewPager imageViewPagerDialog = dialog.findViewById(R.id.dialogImageViewPager);
        dialog.findViewById(R.id.ivClose).setOnClickListener(v -> dialog.dismiss());
        ArrayList<String> imageList = new ArrayList<>();
        imageList.add(imageUrl);
        CourierItemAdapter courierItemAdapter = new CourierItemAdapter(this, imageList, R.layout.item_image_full);
        imageViewPagerDialog.setAdapter(courierItemAdapter);
        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.show();
    }

    public void setRatingForDeliveryMan(double rate) {
        btnRateUsDeliveryman.setClickable(false);
        Drawable drawable = AppCompatResources.getDrawable(this, R.drawable.ic_star2_01);
        drawable.setTint(AppColor.COLOR_THEME);
        btnRateUsDeliveryman.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable, null, null, null);
        btnRateUsDeliveryman.setText(String.valueOf(rate));
        btnRateUsDeliveryman.setVisibility(View.VISIBLE);

    }

    public void setRatingForStore(double rate) {
        btnRateUsStore.setClickable(false);
        Drawable drawable = AppCompatResources.getDrawable(this, R.drawable.ic_star2_01);
        drawable.setTint(AppColor.COLOR_THEME);
        btnRateUsStore.setCompoundDrawablesRelativeWithIntrinsicBounds(drawable, null, null, null);
        btnRateUsStore.setText(String.valueOf(rate));
        btnRateUsStore.setVisibility(View.VISIBLE);
    }

    private void openChatDialog() {
        if (chatDialog != null && chatDialog.isShowing()) {
            return;
        }
        chatDialog = new BottomSheetDialog(this);
        chatDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        chatDialog.setContentView(R.layout.dialog_chat_with);
        TextView tvChatWithStore = chatDialog.findViewById(R.id.tvChatWithStore);
        if (activeOrderResponse.getDeliveryType() == Const.DeliveryType.STORE || activeOrderResponse.getDeliveryType() == Const.DeliveryType.TABLE_BOOKING) {
            tvChatWithStore.setVisibility(View.VISIBLE);
            tvChatWithStore.setOnClickListener(view -> {
                chatDialog.dismiss();
                gotToChatActivity(Const.ChatType.USER_AND_STORE, order.getStoreName(), order.getStoreId());
            });
        } else {
            tvChatWithStore.setVisibility(View.GONE);
        }

        TextView tvChatWithAdmin = chatDialog.findViewById(R.id.tvChatWithAdmin);
        tvChatWithAdmin.setOnClickListener(view -> {
            chatDialog.dismiss();
            gotToChatActivity(Const.ChatType.ADMIN_AND_USER, getResources().getString(R.string.text_admin), Const.ADMIN_RECIVER_ID);
        });
        TextView tvChatWithDeliveryMan = chatDialog.findViewById(R.id.tvChatWithDeliveryMan);
        if (activeOrderResponse.isUserPickUpOrder() || activeOrderResponse.getDeliveryType() == Const.DeliveryType.TABLE_BOOKING) {
            tvChatWithDeliveryMan.setVisibility(View.GONE);
        } else {
            int orderStatus = Math.max(activeOrderResponse.getDeliveryStatus(), activeOrderResponse.getOrderStatus());
            if (isCourier || orderStatus == Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER || orderStatus == Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY || orderStatus == Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || orderStatus == Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
                tvChatWithDeliveryMan.setVisibility(View.VISIBLE);
                tvChatWithDeliveryMan.setOnClickListener(view -> {
                    chatDialog.dismiss();
                    if (activeOrderResponse.getProvider() != null) {
                        String name = activeOrderResponse.getProvider().getName();
                        gotToChatActivity(Const.ChatType.USER_AND_PROVIDER, name, activeOrderResponse.getProviderId());
                    }
                });

            } else {
                tvChatWithDeliveryMan.setVisibility(View.GONE);
            }
        }

        chatDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> chatDialog.dismiss());
        WindowManager.LayoutParams params = chatDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        chatDialog.show();
    }

    private void gotToChatActivity(int chat_type, String title, String topic) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(Const.Params.ORDER_ID, order.getId());
        intent.putExtra(Const.Params.TYPE, String.valueOf(chat_type));
        intent.putExtra(Const.TITLE, title);
        intent.putExtra(Const.RECEIVER_ID, topic);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    protected void onDestroy() {
        OrderEdit.getInstance().clearOrderEditModel();
        super.onDestroy();
    }
}