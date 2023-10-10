package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.LinearInterpolator;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.store.adapter.CancellationReasonAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.NearestProviderDialog;
import com.dropo.store.component.VehicleDialog;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.datamodel.OrderDetail;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.ProviderDetail;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.models.responsemodel.CancellationReasonsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.OrderDetailResponse;
import com.dropo.store.models.responsemodel.OrderStatusResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.section.OrderDetailsSection;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.LatLngInterpolator;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.TwilioCallHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomEventMapView;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.TimeZone;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DeliveryDetailActivity extends BaseActivity implements OnMapReadyCallback, View.OnClickListener, BaseActivity.OrderListener {

    private final String TAG = "DeliveryDetailActivity";
    private final ArrayList<OrderDetails> orderDetailsList = new ArrayList<>();
    private TextView tvClientName, tvTotalItemPrice, tvPaymentMode;
    private ImageView ivClient;
    private OrderDetail orderDetail;
    private ProviderDetail providerDetail;
    private TextView tvStatus;
    private CardView llDriverDetail;
    private CustomTextView tvRate, btnGetCode, tvPickupCode;
    private CustomFontTextViewTitle tvProviderName;
    private CustomEventMapView mapView;
    private GoogleMap googleMap;
    private Marker currentMarker, providerMarker, deliveryMarker;
    private ArrayList<LatLng> markerList;
    private ImageView imgTargetLocation, ivProviderImage;
    private CustomTextView tvOrderNo;
    private LinearLayout llCallDeliveryman;
    private ScheduledExecutorService updateLocationAndOrderSchedule;
    private boolean isScheduledStart, isPaymentModeCash, isOrderPaymentStatusSetByStore;
    private Handler handler;
    private float cameraBearing = 0;
    private CustomAlterDialog cancelRequest;
    private VehicleDetail vehicleDetail;
    private CustomTextView tvDeliveryAddress;
    private TextView tvOrderSchedule;
    private String cancelReason;
    private int currentPosition = -1;
    private BottomSheetDialog cancelOrderDialog;
    private BottomSheetDialog cartDetailDialog;
    private boolean isCameraIdeal = true;
    private int deliveryPriceUsedType;
    private ImageView ivToolbarRightIcon3;
    private LinearLayout llScheduleOrder, llReassign, llViewCart, llUser, llCancelRequest;
    private BottomSheetDialog chatDialog;
    private CardView cardMap;
    private FrameLayout flCart;
    private int orderStatus;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_delivery_details);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_order));
        ivToolbarRightIcon3 = findViewById(R.id.ivToolbarRightIcon3);
        ivToolbarRightIcon3.setImageDrawable(AppColor.getThemeColorDrawable(R.drawable.ic_chat, this));
        ivToolbarRightIcon3.setOnClickListener(this);
        ivToolbarRightIcon3.setVisibility(View.VISIBLE);

        mapView = findViewById(R.id.mapView);
        mapView.getMapAsync(this);
        mapView.onCreate(savedInstanceState);

        cardMap = findViewById(R.id.cardMap);
        tvClientName = findViewById(R.id.tvClientName);
        imgTargetLocation = findViewById(R.id.imgTargetLocation);
        tvTotalItemPrice = findViewById(R.id.tvTotalItemPrice);
        tvPaymentMode = findViewById(R.id.tvPaymentMode);
        tvOrderNo = findViewById(R.id.tvOrderNo);
        ivClient = findViewById(R.id.ivClient);
        imgTargetLocation.setOnClickListener(this);
        tvStatus = findViewById(R.id.tvStatus);
        markerList = new ArrayList<>();
        ivProviderImage = findViewById(R.id.ivProviderImage);
        llDriverDetail = findViewById(R.id.llDriverDetail);
        tvProviderName = findViewById(R.id.tvProviderName);
        tvDeliveryAddress = findViewById(R.id.tvDeliveryAddress);
        tvRate = findViewById(R.id.tvRate);
        btnGetCode = findViewById(R.id.btnGetCode);
        tvPickupCode = findViewById(R.id.tvPickupCode);
        btnGetCode.setOnClickListener(this);
        llCancelRequest = findViewById(R.id.llCancelRequest);
        llCancelRequest.setOnClickListener(this);
        tvOrderSchedule = findViewById(R.id.tvOrderSchedule);
        llScheduleOrder = findViewById(R.id.llScheduleOrder);
        llReassign = findViewById(R.id.llReassign);
        llReassign.setOnClickListener(this);
        llViewCart = findViewById(R.id.llViewCart);
        llViewCart.setOnClickListener(this);
        llUser = findViewById(R.id.llUser);
        llUser.setOnClickListener(this);
        llCallDeliveryman = findViewById(R.id.llCallDeliveryman);
        llCallDeliveryman.setOnClickListener(this);
        flCart = findViewById(R.id.flCart);
        flCart.setVisibility(View.VISIBLE);
        initHandler();
        getDeliveryDetail();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        updateUiCancelOrderButton(false);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            getCancellationReasons();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    private void updateUiCancelOrderButton(boolean visible) {
        setToolbarEditIcon(visible, R.drawable.ic_cancel);
        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) flCart.getLayoutParams();
        if (visible) {
            layoutParams.setMarginEnd(0);
        } else {
            layoutParams.setMarginEnd(getResources().getDimensionPixelSize(R.dimen.activity_horizontal_margin));
        }
        flCart.setLayoutParams(layoutParams);
    }

    /**
     * this method set order data in view
     */
    private void setOrderDetailsList(OrderDetail orderDetail) {
        UserDetail userDetail = orderDetail.getRequestDetail().getUserDetail();
        tvClientName.setText(userDetail.getName());
        tvDeliveryAddress.setText(orderDetail.getRequestDetail().getDestinationAddresses().get(0).getAddress());
        isPaymentModeCash = orderDetail.getOrderPaymentDetail().isIsPaymentModeCash();
        isOrderPaymentStatusSetByStore = orderDetail.getOrderPaymentDetail().isOrderPaymentStatusSetByStore();

        tvTotalItemPrice.setText(PreferenceHelper.getPreferenceHelper(this).getCurrency().concat(parseContent.decimalTwoDigitFormat.format(orderDetail.getOrderPaymentDetail().getTotal())));
        tvOrderNo.setText(String.valueOf(orderDetail.getOrderPaymentDetail().getOrderUniqueId()));
        orderDetailsList.clear();
        orderDetailsList.addAll(orderDetail.getCartDetail().getOrderDetails());

        if (orderDetail.getOrderPaymentDetail().isIsPaymentModeCash()) {
            tvPaymentMode.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_cash, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
            tvPaymentMode.setText(R.string.text_cash);
        } else {
            tvPaymentMode.setText(R.string.text_card);
            tvPaymentMode.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_card, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
        }

        if (orderDetail.getOrder().getUserDetail() != null) {
            GlideApp.with(this).load(IMAGE_URL + orderDetail.getOrder().getUserDetail().getImageUrl()).placeholder(R.drawable.placeholder).dontAnimate().fallback(R.drawable.placeholder).into(ivClient);
        }
        if (orderDetail.getProviderDetail() == null) {
            llDriverDetail.setVisibility(View.GONE);
        } else {
            providerDetail = orderDetail.getProviderDetail();
            setProviderDetail(orderDetail.getRequestDetail().getDeliveryStatus());
            updateUIForPickupCode(orderDetail.getRequestDetail().getDeliveryStatus());
        }
        if (orderDetail.getOrder() != null && orderDetail.getOrder().isIsScheduleOrder()) {
            llScheduleOrder.setVisibility(View.VISIBLE);
            tvOrderSchedule.setVisibility(View.VISIBLE);
            try {
                Date date = ParseContent.getInstance().webFormat.parse(orderDetail.getOrder().getScheduleOrderStartAt());
                SimpleDateFormat dateFormat = new SimpleDateFormat(Constant.DATE_FORMAT, Locale.US);
                SimpleDateFormat timeFormat = new SimpleDateFormat(Constant.TIME_FORMAT_AM, Locale.US);
                if (!TextUtils.isEmpty(orderDetail.getOrder().getTimeZone())) {
                    dateFormat.setTimeZone(TimeZone.getTimeZone(orderDetail.getOrder().getTimeZone()));
                    timeFormat.setTimeZone(TimeZone.getTimeZone(orderDetail.getOrder().getTimeZone()));
                }
                if (date != null) {
                    String stringDate = getResources().getString(R.string.text_order_schedule) + " " + dateFormat.format(date) + " " + timeFormat.format(date);

                    if (!TextUtils.isEmpty(orderDetail.getOrder().getScheduleOrderStartAt2())) {
                        Date date2 = ParseContent.getInstance().webFormat.parse(orderDetail.getOrder().getScheduleOrderStartAt2());
                        if (date2 != null) {
                            stringDate = stringDate + " - " + timeFormat.format(date2);
                        }
                    }
                    tvOrderSchedule.setText(stringDate);
                }
            } catch (ParseException e) {
                Utilities.handleException(DeliveryDetailActivity.class.getName(), e);
            }
        } else {
            llScheduleOrder.setVisibility(View.GONE);
            tvOrderSchedule.setVisibility(View.GONE);
        }
        setViewBasedOnOrderStatus(orderDetail.getRequestDetail().getDeliveryStatus());
        deliveryPriceUsedType = orderDetail.getOrderPaymentDetail().getDeliveryPriceUsedType();
    }

    private void setProviderDetail(int deliveryStatus) {
        if (providerDetail != null && deliveryStatus != Constant.STORE_CANCELLED_REQUEST && deliveryStatus != Constant.DELIVERY_MAN_NOT_FOUND && deliveryStatus != Constant.DELIVERY_MAN_CANCELLED) {
            llDriverDetail.setVisibility(View.VISIBLE);
            tvProviderName.setText(providerDetail.getFirstName().concat(" ").concat(providerDetail.getLastName()));
            Glide.with(this)
                    .load(IMAGE_URL + providerDetail.getImageUrl())
                    .placeholder(R.drawable.placeholder).dontAnimate()
                    .fallback(R.drawable.placeholder)
                    .into(ivProviderImage);
            tvRate.setText(String.valueOf(providerDetail.getRate()));
        } else {
            llDriverDetail.setVisibility(View.GONE);
            btnGetCode.setVisibility(View.GONE);
        }
    }

    private void setViewBasedOnOrderStatus(int status) {
        tvStatus.setTextColor(Utilities.setStatusColor(this, Constant.COLOR_STATUS_PREFIX, status, false));
        switch (status) {
            case Constant.STORE_ORDER_READY:
                tvStatus.setText(getString(R.string.text_assign_provider));
                updateUIForRequestButton(true);
                updateUiCancelOrderButton(true);

                break;
            case Constant.WAITING_FOR_DELIVERY_MAN:
                tvStatus.setText(getString(R.string.text_status9));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(true);
                break;
            case Constant.DELIVERY_MAN_ACCEPTED:
                tvStatus.setText(getString(R.string.text_status11));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(true);
                break;
            case Constant.DELIVERY_MAN_COMING:
                tvStatus.setText(getString(R.string.text_status13));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(true);
                break;
            case Constant.DELIVERY_MAN_ARRIVED:
                tvStatus.setText(getString(R.string.text_status15));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(false);
                break;
            case Constant.DELIVERY_MAN_PICKED_ORDER:
                tvStatus.setText(getString(R.string.text_status17));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(false);
                break;
            case Constant.DELIVERY_MAN_STARTED_DELIVERY:
                tvStatus.setText(getString(R.string.text_status19));
                updateUIForRequestButton(false);
                updateUiCancelOrderButton(false);

                break;
            case Constant.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                updateUIForRequestButton(false);
                tvStatus.setText(getString(R.string.text_status21));
                break;
            case Constant.DELIVERY_MAN_COMPLETE_DELIVERY:
                updateUIForRequestButton(false);
                tvStatus.setText(getString(R.string.text_status23));
                updateUiCancelOrderButton(false);
                goToHomeActivity();
                break;
            case Constant.DELIVERY_MAN_NOT_FOUND:
                updateUiCancelOrderButton(true);
                stopSchedule();
                tvStatus.setText(getString(R.string.text_status109));
                updateUIForRequestButton(true);
                break;
            case Constant.DELIVERY_MAN_CANCELLED:
                updateUiCancelOrderButton(true);
                stopSchedule();
                tvStatus.setText(getString(R.string.text_status112));
                updateUIForRequestButton(true);
                break;
            case Constant.STORE_CANCELLED_REQUEST:
                updateUiCancelOrderButton(true);
                stopSchedule();
                tvStatus.setText(getString(R.string.text_status105));
                updateUIForRequestButton(true);
                break;
            case Constant.USER_CANCELED_ORDER:
                updateUiCancelOrderButton(true);
                stopSchedule();
                tvStatus.setText(getString(R.string.text_status101));
                updateUIForRequestButton(true);
                onBackPressed();
                break;
            default:
                break;
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    protected void onStart() {
        super.onStart();
        setOrderListener(this);
        if (orderDetail != null && !TextUtils.isEmpty(orderDetail.getRequestDetail().getId())) {
            startSchedule();
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        stopSchedule();
        setOrderListener(null);
    }

    @Override
    protected void onPause() {
        mapView.onPause();
        super.onPause();
    }

    @Override
    protected void onDestroy() {
        mapView.onDestroy();
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.imgTargetLocation) {
            if (!markerList.isEmpty()) {
                setLocationBounds(false, markerList);
            }
        } else if (id == R.id.llCallDeliveryman) {
            if (providerDetail != null) {
                if (preferenceHelper.getIsEnableTwilioCallMasking()) {
                    TwilioCallHelper.callViaTwilio(DeliveryDetailActivity.this, llCallDeliveryman, orderDetail.getOrder().getId(), String.valueOf(Constant.Type.PROVIDER));
                } else {
                    Utilities.openCallChooser(DeliveryDetailActivity.this, providerDetail.getCountryPhoneCode() + providerDetail.getPhone());
                }
            }
        } else if (id == R.id.llReassign) {
            openVehicleSelectDialog();
        } else if (id == R.id.llCancelRequest) {
            openCancelRequestDialog();
        } else if (id == R.id.btnGetCode) {
            openAdvancePayForCashOnDeliveryDialog();
        } else if (id == R.id.llUser) {
            if (preferenceHelper.getIsEnableTwilioCallMasking()) {
                TwilioCallHelper.callViaTwilio(DeliveryDetailActivity.this, llUser, orderDetail.getOrder().getId(), String.valueOf(Constant.Type.USER));
            } else {
                Utilities.openCallChooser(DeliveryDetailActivity.this, orderDetail.getRequestDetail().getUserDetail().getPhone());
            }
        } else if (id == R.id.llViewCart) {
            openOrderDetailDialog();
        } else if (id == R.id.ivToolbarRightIcon3) {
            openChatDialog();
        }
    }

    private void openChatDialog() {
        if (chatDialog != null && chatDialog.isShowing()) {
            return;
        }
        chatDialog = new BottomSheetDialog(this);
        chatDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        chatDialog.setContentView(R.layout.dialog_chat_with);
        TextView tvChatWithUser = chatDialog.findViewById(R.id.tvChatWithUser);
        tvChatWithUser.setOnClickListener(view -> {
            chatDialog.dismiss();
            String name = tvClientName.getText().toString();
            gotToChatActivity(Constant.ChatType.USER_AND_STORE, name, orderDetail.getRequestDetail().getUserId());
        });
        TextView tvChatWithAdmin = chatDialog.findViewById(R.id.tvChatWithAdmin);
        tvChatWithAdmin.setOnClickListener(view -> {
            chatDialog.dismiss();
            gotToChatActivity(Constant.ChatType.ADMIN_AND_STORE, getResources().getString(R.string.text_admin), Constant.ADMIN_RECIVER_ID);
        });
        TextView tvChatWithDeliveryMan = chatDialog.findViewById(R.id.tvChatWithDeliveryMan);
        if ((!orderDetail.getOrder().isUserPickUpOrder()) && (orderStatus == Constant.DELIVERY_MAN_ACCEPTED || orderStatus == Constant.DELIVERY_MAN_COMING || orderStatus == Constant.DELIVERY_MAN_ARRIVED || orderStatus == Constant.DELIVERY_MAN_PICKED_ORDER || orderStatus == Constant.DELIVERY_MAN_STARTED_DELIVERY || orderStatus == Constant.DELIVERY_MAN_ARRIVED_AT_DESTINATION) && llReassign.getVisibility() == View.GONE && orderDetail.getOrder().getDeliveryType() != Constant.DeliveryType.TABLE_BOOKING) {
            tvChatWithDeliveryMan.setVisibility(View.VISIBLE);
            tvChatWithDeliveryMan.setOnClickListener(view -> {
                chatDialog.dismiss();
                String provider_name = providerDetail.getFirstName() + " " + providerDetail.getLastName();
                gotToChatActivity(Constant.ChatType.PROVIDER_AND_STORE, provider_name, orderDetail.getRequestDetail().getProviderId());
            });
        } else {
            tvChatWithDeliveryMan.setVisibility(View.GONE);
        }
        chatDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> chatDialog.dismiss());

        WindowManager.LayoutParams params = chatDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        chatDialog.show();
    }

    /**
     * this method call a webservice for getOrderStatus (accepted,rejected,prepare etc.)
     */
    private void checkRequestStatus() {
        HashMap<String, Object> map = getCommonParam(orderDetail.getOrder().getId());
        map.put(Constant.REQUEST_ID, orderDetail.getRequestDetail().getId());
        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).checkRequestStatus(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        Order order = response.body().getOrderRequest();
                        providerDetail = response.body().getProviderDetail();
                        vehicleDetail = response.body().getVehicleDetail();
                        orderStatus = order.getDeliveryStatus();
                        setViewBasedOnOrderStatus(order.getDeliveryStatus());
                        List<Double> providerArray = providerDetail.getProviderLocation();
                        List<Double> srcArray = order.getPickupAddresses().get(0).getLocation();
                        List<Double> destArray = order.getDestinationAddresses().get(0).getLocation();
                        LatLng providerLatLng, destLatLng, srcLatLng;
                        srcLatLng = new LatLng(srcArray.get(0), srcArray.get(1));
                        destLatLng = new LatLng(destArray.get(0), destArray.get(1));
                        if (providerArray != null && !providerArray.isEmpty()) {
                            providerLatLng = new LatLng(providerArray.get(0), providerArray.get(1));
                            setMarkerOnLocation(srcLatLng, providerLatLng, destLatLng, order.getDeliveryStatus());
                            updateCamera(providerDetail.getBearing(), providerLatLng);
                        }
                        updateUIForPickupCode(order.getDeliveryStatus());
                        setProviderDetail(order.getDeliveryStatus());
                    } else {
                        ParseContent.getInstance().showErrorMessage(DeliveryDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), DeliveryDetailActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for create a order pickUp request to delivery man
     */
    private void assignDeliveryMan(String vehicleId, String providerId) {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = getCommonParam(orderDetail.getOrder().getId());
        map.put(Constant.VEHICLE_ID, vehicleId);
        if (!TextUtils.isEmpty(providerId)) {
            map.put(Constant.PROVIDER_ID, providerId);
        }

        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).assignProvider(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        Order order = response.body().getOrderRequest();
                        providerDetail = response.body().getProviderDetail();
                        orderDetail.getRequestDetail().setCurrentProvider(providerDetail.getId());
                        setViewBasedOnOrderStatus(order.getDeliveryStatus());
                        llReassign.setVisibility(View.GONE);
                        setProviderDetail(order.getDeliveryStatus());
                        updateUIForPickupCode(order.getDeliveryStatus());
                        startSchedule();
                    } else {
                        ParseContent.getInstance().showErrorMessage(DeliveryDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), DeliveryDetailActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Constant.PERMISSION_FOR_LOCATION) {
                goWithLocationPermission(grantResults);
            }
        }
    }

    private void openLocationPermissionDialog() {
        CustomAlterDialog customAlterDialog = new CustomAlterDialog(DeliveryDetailActivity.this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_permission_location), true, getString(R.string.text_re_try)) {
            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    ActivityCompat.requestPermissions(DeliveryDetailActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, Constant.PERMISSION_FOR_LOCATION);
                }
                dismiss();
            }
        };
        customAlterDialog.show();
    }

    /**
     * this method will make decision according to permission result
     *
     * @param grantResults set result from system or OS
     */
    private void goWithLocationPermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            //Do the stuff that requires permission...
        } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_COARSE_LOCATION) && ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.ACCESS_FINE_LOCATION)) {
                openLocationPermissionDialog();
            }
        }
    }


    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
    }

    private void setUpMap() {
        this.googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        this.googleMap.getUiSettings().setMapToolbarEnabled(false);
        this.googleMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
        this.googleMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
            final boolean doNotMoveCameraToCenterMarker = true;

            public boolean onMarkerClick(@NonNull Marker marker) {
                return doNotMoveCameraToCenterMarker;
            }
        });
        this.googleMap.setOnMapLoadedCallback(() -> moveCameraFirstMyLocation(false, CurrentBooking.getInstance().getStoreLatLng()));
    }

    /**
     * this method move a map camera at your current location on map
     *
     * @param isAnimate isAnimate
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng != null) {
            CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng).zoom(17).build();
            if (isAnimate) {
                googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            } else {
                googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            }
        }
    }

    private void openCancelRequestDialog() {
        if (cancelRequest != null && cancelRequest.isShowing()) {
            return;
        }

        cancelRequest = new CustomAlterDialog(this, getResources().getString(R.string.text_cancel_request), getResources().getString(R.string.msg_cancel_request), true, getResources().getString(R.string.text_yes)) {
            @Override
            public void btnOnClick(int btnId) {

                if (btnId == R.id.btnPositive) {
                    cancelDeliveryRequest();
                }
                dismiss();

            }
        };

        cancelRequest.show();
    }

    private void openAdvancePayForCashOnDeliveryDialog() {
        String message = orderDetail.isConfirmationCodeRequiredAtPickupDelivery() ? getResources().getString(R.string.msg_advance_pay_for_order) : getResources().getString(R.string.msg_advance_pay_for_order_with_out_code);
        CustomAlterDialog customAlterDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_order_payment), message, true, getResources().getString(R.string.text_yes)) {
            @Override
            public void btnOnClick(int btnId) {
                orderPaymentPaidBy(btnId != R.id.btnPositive);
                dismiss();
            }
        };
        customAlterDialog.show();
    }

    private void orderPaymentPaidBy(boolean isPayStore) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.IS_ORDER_PRICE_PAID_BY_STORE, isPayStore);
        map.put(Constant.ORDER_PAYMENT_ID, orderDetail.getOrder().getOrderPaymentId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.setOrderPaymentPaidBy(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                isOrderPaymentStatusSetByStore = response.body().isSuccess();
                updateUIForPickupCode(orderDetail.getRequestDetail().getDeliveryStatus());
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method is used to set marker on map
     *
     * @param storeLatLng    LatLng
     * @param providerLatLng LatLng
     */
    private void setMarkerOnLocation(LatLng storeLatLng, LatLng providerLatLng, LatLng deliveryLatLng, int deliveryStatus) {
        BitmapDescriptor bitmapDescriptor;
        boolean isBounce = false;
        if (googleMap != null) {
            if (storeLatLng != null) {
                if (currentMarker == null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utilities.drawableToBitmap(AppCompatResources.getDrawable(this, R.drawable.ic_store_pin)));
                    currentMarker = googleMap.addMarker(new MarkerOptions().position(storeLatLng).title(getResources().getString(R.string.text_store)).icon(bitmapDescriptor));
                } else {
                    currentMarker.setPosition(storeLatLng);
                }
            }
            if (deliveryLatLng != null) {
                if (deliveryMarker == null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utilities.drawableToBitmap(AppCompatResources.getDrawable(this, R.drawable.ic_user_pin)));
                    deliveryMarker = googleMap.addMarker(new MarkerOptions().position(deliveryLatLng).title(getResources().getString(R.string.text_delivery)).icon(bitmapDescriptor));
                    isBounce = true;
                } else {
                    deliveryMarker.setPosition(deliveryLatLng);
                }
            }
            if (providerLatLng != null && deliveryStatus != Constant.DELIVERY_MAN_NOT_FOUND) {
                if (providerMarker == null) {
                    providerMarker = googleMap.addMarker(new MarkerOptions().position(providerLatLng).title(getResources().getString(R.string.text_delivery_man)));
                    downloadVehiclePin();
                    providerMarker.setAnchor(0.5f, 0.5f);

                } else {

                    animateMarkerToGB(providerMarker, providerLatLng, new LatLngInterpolator.Linear());
                }
                markerList.add(providerLatLng);
            }
            if (deliveryStatus == Constant.WAITING_FOR_DELIVERY_MAN) {
                if (storeLatLng != null) {
                    markerList.add(storeLatLng);
                }
                if (deliveryLatLng != null) {
                    markerList.add(deliveryLatLng);
                }
            } else if (deliveryStatus <= Constant.DELIVERY_MAN_COMING) {
                if (storeLatLng != null) {
                    markerList.add(storeLatLng);
                }
            } else {
                if (deliveryLatLng != null) {
                    markerList.add(deliveryLatLng);
                }
            }
            if (isBounce) {
                try {
                    setLocationBounds(false, markerList);
                } catch (Exception e) {
                    Utilities.handleException(DeliveryDetailActivity.class.getName(), e);

                }
            }
        }
    }

    /**
     * this method used to animate marker on map smoothly
     *
     * @param marker             Marker
     * @param finalPosition      LatLag
     * @param latLngInterpolator LatLngInterpolator
     */
    private void animateMarkerToGB(final Marker marker, final LatLng finalPosition, final LatLngInterpolator latLngInterpolator) {
        if (marker != null) {
            final LatLng startPosition = marker.getPosition();
            final LatLng endPosition = new LatLng(finalPosition.latitude, finalPosition.longitude);
            ValueAnimator valueAnimator = ValueAnimator.ofFloat(0, 1);
            valueAnimator.setDuration(3000); // duration 3 second
            valueAnimator.setInterpolator(new LinearInterpolator());
            valueAnimator.addUpdateListener(animation -> {
                try {
                    float v = animation.getAnimatedFraction();
                    LatLng newPosition = latLngInterpolator.interpolate(v, startPosition, endPosition);
                    marker.setPosition(newPosition);
                    marker.setAnchor(0.5f, 0.5f);
                } catch (Exception ignored) {
                }
            });
            valueAnimator.addListener(new AnimatorListenerAdapter() {
                @Override
                public void onAnimationEnd(Animator animation) {
                    super.onAnimationEnd(animation);
                }
            });
            valueAnimator.start();
        }
    }

    /**
     * this method update camera for map
     *
     * @param bearing        float
     * @param positionLatLng LatLng
     */
    private void updateCamera(float bearing, LatLng positionLatLng) {
        if (isCameraIdeal) {
            isCameraIdeal = false;
            CameraPosition oldPos = googleMap.getCameraPosition();

            cameraBearing = bearing;
            CameraPosition pos = CameraPosition.builder(oldPos).bearing(bearing).target(positionLatLng).build();
            googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(pos), 3000, new GoogleMap.CancelableCallback() {

                @Override
                public void onFinish() {
                    isCameraIdeal = true;
                }

                @Override
                public void onCancel() {
                    isCameraIdeal = true;
                }
            });
        }
    }

    private void setLocationBounds(boolean isCameraAnim, ArrayList<LatLng> markerList) {
        LatLngBounds.Builder bounds = new LatLngBounds.Builder();
        int driverListSize = markerList.size();
        for (int i = 0; i < driverListSize; i++) {
            bounds.include(markerList.get(i));
        }
        //Change the padding as per needed
        CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(bounds.build(), getResources().getDimensionPixelSize(R.dimen.dimen_map_bounce));

        if (isCameraAnim) {
            googleMap.animateCamera(cu);
        } else {
            googleMap.moveCamera(cu);
        }
    }

    public void startSchedule() {
        if (!isScheduledStart && preferenceHelper.isApproved()) {
            Runnable runnable = () -> {
                Message message = handler.obtainMessage();
                handler.sendMessage(message);
            };
            updateLocationAndOrderSchedule = Executors.newSingleThreadScheduledExecutor();
            updateLocationAndOrderSchedule.scheduleWithFixedDelay(runnable, 0, Constant.DELIVERY_SCHEDULED, TimeUnit.SECONDS);
            isScheduledStart = true;
        }
    }

    public void stopSchedule() {
        if (isScheduledStart) {
            updateLocationAndOrderSchedule.shutdown(); // Disable new tasks from being submitted
            // Wait a while for existing tasks to terminate
            try {
                if (!updateLocationAndOrderSchedule.awaitTermination(60, TimeUnit.SECONDS)) {
                    updateLocationAndOrderSchedule.shutdownNow(); // Cancel currently executing
                    // tasks
                    // Wait a while for tasks to respond to being cancelled
                    updateLocationAndOrderSchedule.awaitTermination(60, TimeUnit.SECONDS);
                }
            } catch (InterruptedException e) {
                Utilities.handleException(HomeActivity.class.getName(), e);
                // (Re-)Cancel if current thread also interrupted
                updateLocationAndOrderSchedule.shutdownNow();
                // Preserve interrupt status
                Thread.currentThread().interrupt();
            }
            isScheduledStart = false;
        }
    }

    /**
     * This handler receive a message from  requestStatusScheduledService and update provider
     * location and order status
     */
    private void initHandler() {
        handler = new Handler(Looper.myLooper()) {
            @SuppressLint("HandlerLeak")
            @Override
            public void handleMessage(Message msg) {
                checkRequestStatus();
            }
        };
    }

    private void cancelDeliveryRequest() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.REQUEST_ID, orderDetail.getRequestDetail().getId());
        map.put(Constant.PROVIDER_ID, orderDetail.getRequestDetail().getCurrentProvider());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderStatusResponse> responseCall = apiInterface.cancelDeliveryRequest(map);
        responseCall.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.body().isSuccess()) {
                    setViewBasedOnOrderStatus(response.body().getDeliveryStatus());
                } else {
                    stopSchedule();
                    parseContent.showErrorMessage(DeliveryDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void updateUIForPickupCode(int deliveryStatus) {
        if (isPaymentModeCash) {
            if (deliveryStatus == Constant.DELIVERY_MAN_ARRIVED || deliveryStatus == Constant.DELIVERY_MAN_PICKED_ORDER || deliveryStatus == Constant.DELIVERY_MAN_STARTED_DELIVERY || deliveryStatus == Constant.DELIVERY_MAN_ARRIVED_AT_DESTINATION || deliveryStatus == Constant.DELIVERY_MAN_COMPLETE_DELIVERY) {
                if (!isOrderPaymentStatusSetByStore) {
                    btnGetCode.setVisibility(View.VISIBLE);
                    if (orderDetail.isConfirmationCodeRequiredAtPickupDelivery()) {
                        btnGetCode.setText(getResources().getString(R.string.text_get_code));
                    } else {
                        btnGetCode.setText(getResources().getString(R.string.text_who_pay));

                    }
                    tvPickupCode.setVisibility(View.GONE);
                } else {
                    btnGetCode.setVisibility(View.GONE);
                    if (orderDetail.isConfirmationCodeRequiredAtPickupDelivery()) {
                        tvPickupCode.setVisibility(View.VISIBLE);
                        tvPickupCode.setText(String.format("%s %s", getResources().getString(R.string.text_pik_up_code), orderDetail.getOrder().getConfirmationCodeForPickUpDelivery()));
                    } else {
                        tvPickupCode.setVisibility(View.GONE);
                    }
                }
            } else {
                btnGetCode.setVisibility(View.GONE);
                tvPickupCode.setVisibility(View.GONE);
            }
        } else {
            btnGetCode.setVisibility(View.GONE);
            if (orderDetail.isConfirmationCodeRequiredAtPickupDelivery()) {
                tvPickupCode.setVisibility(View.VISIBLE);
                tvPickupCode.setText(String.format("%s %s", getResources().getString(R.string.text_pik_up_code), orderDetail.getOrder().getConfirmationCodeForPickUpDelivery()));
            } else {
                tvPickupCode.setVisibility(View.GONE);
            }
        }
    }

    private void updateUIForRequestButton(boolean isReassign) {
        if (isReassign) {
            llReassign.setVisibility(View.VISIBLE);
            llCancelRequest.setVisibility(View.GONE);
            llDriverDetail.setVisibility(View.GONE);
            if (providerMarker != null) {
                providerMarker.remove();
                providerMarker = null;
            }
            cardMap.setVisibility(View.GONE);

        } else {
            llReassign.setVisibility(View.GONE);
            llCancelRequest.setVisibility(View.VISIBLE);
            llDriverDetail.setVisibility(View.VISIBLE);
            if (providerMarker != null) {
                providerMarker.remove();
                providerMarker = null;
            }
            cardMap.setVisibility(View.VISIBLE);
        }
    }

    public void downloadVehiclePin() {
        if (!TextUtils.isEmpty(vehicleDetail.getMapPinImageUrl())) {
            GlideApp.with(this).asBitmap().load(IMAGE_URL + vehicleDetail.getMapPinImageUrl())
                    .diskCacheStrategy(DiskCacheStrategy.ALL).placeholder(R.drawable.driver_car).listener(new RequestListener<Bitmap>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                            Utilities.handleException(getClass().getSimpleName(), e);
                            if (providerMarker != null) {
                                providerMarker.setIcon(BitmapDescriptorFactory.fromBitmap(Utilities.drawableToBitmap(AppCompatResources.getDrawable(DeliveryDetailActivity
                                        .this, R.drawable.driver_car))));
                            }
                            return true;
                        }

                        @Override
                        public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                            if (providerMarker != null) {
                                providerMarker.setIcon(BitmapDescriptorFactory.fromBitmap(resource));
                            }
                            return true;
                        }
                    }).dontAnimate()
                    .override(getResources().getDimensionPixelSize(R.dimen.vehicle_pin_width), getResources().getDimensionPixelSize(R.dimen.vehicle_pin_height))
                    .preload(getResources().getDimensionPixelSize(R.dimen.vehicle_pin_width), getResources().getDimensionPixelSize(R.dimen.vehicle_pin_height));
        } else {
            if (providerMarker != null) {
                providerMarker.setIcon(BitmapDescriptorFactory.fromBitmap(Utilities.drawableToBitmap(AppCompatResources.getDrawable(DeliveryDetailActivity
                        .this, R.drawable.driver_car))));
            }
        }
    }

    private void getCancellationReasons() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CancellationReasonsResponse> responseCall = apiInterface.getCancellationReasons(map);
        responseCall.enqueue(new Callback<CancellationReasonsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CancellationReasonsResponse> call, @NonNull Response<CancellationReasonsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response) && response.body() != null) {
                    openCancelOrderDialog(response.body().getReasons());
                } else {
                    openCancelOrderDialog(new ArrayList<>());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CancellationReasonsResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(TAG, t);
                openCancelOrderDialog(new ArrayList<>());
            }
        });
    }

    private void openCancelOrderDialog(ArrayList<String> cancellationReason) {
        if (cancelOrderDialog != null && cancelOrderDialog.isShowing()) {
            return;
        }
        cancelOrderDialog = new BottomSheetDialog(this);
        cancelOrderDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        cancelOrderDialog.setContentView(R.layout.dialog_cancel_order);

        final CancellationReasonAdapter cancellationReasonAdapter;
        final RecyclerView rvCancellationReason;

        rvCancellationReason = cancelOrderDialog.findViewById(R.id.rvCancellationReason);

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

        cancelOrderDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
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
                cancelOrderDialog.dismiss();
                rejectOrCancelOrder(DeliveryDetailActivity.this, orderDetail.getOrder().getId(), cancelReason);
            } else {
                Utilities.showToast(DeliveryDetailActivity.this, getResources().getString(R.string.msg_plz_give_valid_reason));
            }
        });
        cancelOrderDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> {
            cancelOrderDialog.dismiss();
            cancelReason = "";
        });
        WindowManager.LayoutParams params = cancelOrderDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        cancelOrderDialog.setCancelable(true);
        cancelOrderDialog.show();
    }

    /**
     * this method call a webservice for reject or cancel order
     *
     * @param context     context
     * @param orderItemId orderItemId
     */
    private void rejectOrCancelOrder(final Context context, String orderItemId, String cancelReason) {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = getCommonParam(orderItemId);
        map.put(Constant.ORDER_STATUS, Constant.STORE_ORDER_CANCELLED);
        map.put(Constant.CANCEL_REASON, cancelReason);
        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).CancelOrRejectOrder(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        onBackPressed();
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

    private void openOrderDetailDialog() {
        if (cartDetailDialog != null && cartDetailDialog.isShowing()) {
            return;
        }

        cartDetailDialog = new BottomSheetDialog(this);
        cartDetailDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        cartDetailDialog.setContentView(R.layout.dialog_delivery_order_detail);
        CustomTextView tvOrderNumber = cartDetailDialog.findViewById(R.id.tvOrderNumber);
        String orderNumber = getResources().getString(R.string.text_order_number) + " " + "#" + tvOrderNo.getText();
        tvOrderNumber.setText(orderNumber);
        RecyclerView rcvOrderProductItem = cartDetailDialog.findViewById(R.id.rcvOrderProductItem);
        rcvOrderProductItem.setLayoutManager(new LinearLayoutManager(this));
        OrderDetailsSection orderDetailsSection = new OrderDetailsSection(orderDetailsList, this);
        rcvOrderProductItem.setAdapter(orderDetailsSection);
        cartDetailDialog.findViewById(R.id.btnDone).setOnClickListener(v -> cartDetailDialog.dismiss());

        WindowManager.LayoutParams params = cartDetailDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        cartDetailDialog.setCancelable(true);
        cartDetailDialog.show();

    }

    @Override
    public void onOrderReceive() {
        checkRequestStatus();
    }

    private void openVehicleSelectDialog() {
        List<VehicleDetail> vehicleDetails = deliveryPriceUsedType == Constant.VEHICLE_TYPE ? CurrentBooking.getInstance().getVehicleDetails() : CurrentBooking.getInstance().getAdminVehicleDetails();
        if (vehicleDetails.isEmpty()) {
            Utilities.showToast(this, getResources().getString(R.string.text_vehicle_not_found));
        } else {
            final VehicleDialog vehicleDialog = new VehicleDialog(this, vehicleDetails);
            vehicleDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> vehicleDialog.dismiss());
            vehicleDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
                if (TextUtils.isEmpty(vehicleDialog.getVehicleId())) {
                    Utilities.showToast(DeliveryDetailActivity.this, getResources().getString(R.string.msg_select_vehicle));
                } else {
                    if (vehicleDialog.isManualAssign()) {
                        vehicleDialog.dismiss();
                        openNearestProviderDialog(orderDetail.getOrder().getId(), vehicleDialog.getVehicleId());
                    } else {
                        vehicleDialog.dismiss();
                        assignDeliveryMan(vehicleDialog.getVehicleId(), null);
                    }
                }
            });
            vehicleDialog.show();
        }
    }

    private void openNearestProviderDialog(String orderId, final String vehicleId) {
        final NearestProviderDialog providerDialog = new NearestProviderDialog(this, orderId, vehicleId);
        providerDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> providerDialog.dismiss());
        providerDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            providerDialog.dismiss();
            if (providerDialog.getSelectedProvider() == null) {
                Utilities.showToast(DeliveryDetailActivity.this, getResources().getString(R.string.msg_select_provider));
            } else {
                assignDeliveryMan(vehicleId, providerDialog.getSelectedProvider().getId());
            }
        });
        providerDialog.show();
    }

    private void gotToChatActivity(int chat_type, String title, String receiver_id) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(Constant.ORDER_ID, orderDetail.getOrder().getId());
        intent.putExtra(Constant.TYPE, String.valueOf(chat_type));
        intent.putExtra(Constant.TITLE, title);
        intent.putExtra(Constant.RECEIVER_ID, receiver_id);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void getDeliveryDetail() {
        if (getIntent() != null && getIntent().getParcelableExtra(Constant.ORDER_DETAIL) != null) {
            Order order = getIntent().getParcelableExtra(Constant.ORDER_DETAIL);
            Utilities.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            map.put(Constant.ORDER_ID, order.getOrderId());

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<OrderDetailResponse> responseCall = apiInterface.getOrderDetail(map);
            responseCall.enqueue(new Callback<OrderDetailResponse>() {
                @Override
                public void onResponse(@NonNull Call<OrderDetailResponse> call, @NonNull Response<OrderDetailResponse> response) {
                    Utilities.hideCustomProgressDialog();
                    if (parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            orderDetail = response.body().getOrderDetail();
                            setOrderDetailsList(orderDetail);
                            if (!TextUtils.isEmpty(orderDetail.getRequestDetail().getId())) {
                                startSchedule();
                            }
                        } else {
                            parseContent.showErrorMessage(DeliveryDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<OrderDetailResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });
        }
    }
}