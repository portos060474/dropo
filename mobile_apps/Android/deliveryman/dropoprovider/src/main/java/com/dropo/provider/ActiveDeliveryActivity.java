package com.dropo.provider;

import static com.dropo.provider.utils.Const.REQUEST_CHECK_SETTINGS;
import static com.dropo.provider.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;
import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.location.Location;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.provider.MediaStore;
import android.text.Html;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.LinearInterpolator;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.provider.adapter.CancellationReasonAdapter;
import com.dropo.provider.adapter.CourierItemAdapter;
import com.dropo.provider.adapter.CourierItemDetailAdapter;
import com.dropo.provider.adapter.DeliveryAddressAdapter;
import com.dropo.provider.adapter.OrderDetailsAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomEventMapView;
import com.dropo.provider.component.CustomFloatingButton;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.component.CustomPhotoDialog;
import com.dropo.provider.fragments.InvoiceFragment;
import com.dropo.provider.interfaces.LatLngInterpolator;
import com.dropo.provider.models.datamodels.Addresses;
import com.dropo.provider.models.datamodels.CancelReasons;
import com.dropo.provider.models.datamodels.Message;
import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.Status;
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.models.responsemodels.CancellationReasonsResponse;
import com.dropo.provider.models.responsemodels.CompleteOrderResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OrderStatusResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.ImageCompression;
import com.dropo.provider.utils.ImageHelper;
import com.dropo.provider.utils.LocationHelper;
import com.dropo.provider.utils.SoundHelper;
import com.dropo.provider.utils.TwilioCallHelper;
import com.dropo.provider.utils.Utils;
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
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.ValueEventListener;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ActiveDeliveryActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived, OnMapReadyCallback, ValueEventListener {

    private LocationHelper locationHelper;
    private CustomEventMapView mapView;
    private CustomFontTextView tvOrderTimer, tvEstTime, tvEstDistance, tvDeliveryDate, tvOrderNumber;
    private CustomFontTextViewTitle tvCustomerName;
    private CustomFontButton btnRejectOrder, btnAcceptOrder, btnJobStatus;
    private ImageView ivCustomerImage, ivActiveTargetLocation;
    private CustomFloatingButton ivNavigate;
    private LinearLayout llCallUser, llCart;
    private GoogleMap googleMap;
    private String requestId;
    private int orderStatus = Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY;
    private boolean isCountDownTimerStart;
    private CountDownTimer countDownTimer;
    private LinearLayout flAccept;
    private LinearLayout llUpdateStatus;
    private Order order;
    private Location lastLocation, currentLocation;
    private LatLng currentLatLng, pickUpLatLng, deliveryLatLng;
    private ArrayList<LatLng> markerList;
    private Marker providerMarker, pickUpMarker, destinationMarker;
    private String cancelReason;
    private int currentPosition = -1;
    private SoundHelper soundHelper;
    private CustomDialogAlert noteDialog, orderItemConfirmDialog;
    private CustomPhotoDialog mapDialog;
    private Dialog orderCancelDialog, cartDetailDialog;
    private CustomDialogVerification pickUpDeliveryDialog, completeDeliveryDialog;
    private OrderStatusReceiver orderStatusReceiver;
    private String call, type;
    private boolean isCameraIdeal = true;
    private UserDetail userDetail;
    private UserDetail userDetailOrder;
    private Dialog uploadImageDialog;
    private CustomDialogAlert closedPermissionDialog;
    private String currentPhotoPath;
    private Uri picUri;
    private ImageHelper imageHelper;
    private ImageView uploadImageView, ivContactLessDelivery, ivHaveMessage;
    private LinearLayout llChat;
    private BottomSheetDialog chatDialog;
    private TextView tvCallTo, tvChatUser;
    private TextView tvBringChange;
    private boolean isBringChange;
    private LinearLayout llDotsDialog;
    private ViewPager imageViewPagerDialog;
    private ArrayList<Addresses> addressesList;
    private DeliveryAddressAdapter addressAdapter;
    private RecyclerView rvAddress;
    private boolean isLoadDataFirstTime = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_active_delivery);
        getExtraData();
        initToolBar();
        initViewById();
        setViewListener();
        setTitleOnToolBar(getResources().getString(R.string.text_active_delivery));
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);
        markerList = new ArrayList<>();
        soundHelper = SoundHelper.getInstance(this);
        orderStatusReceiver = new OrderStatusReceiver();
        imageHelper = new ImageHelper(this);
        locationHelper.setLocationSettingRequest(ActiveDeliveryActivity.this, REQUEST_CHECK_SETTINGS, o -> {
        }, () -> {
        });
        getRequestStatus();

        tvBringChange.setVisibility(isBringChange ? View.VISIBLE : View.GONE);
    }

    @Override
    public void onStart() {
        super.onStart();
        registerReceiver(orderStatusReceiver, new IntentFilter(Const.Action.ACTION_STORE_CANCELED_REQUEST));
    }


    @Override
    protected void onResume() {
        super.onResume();
        mapView.onResume();
        locationHelper.onStart();
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        mapView.onSaveInstanceState(outState);
        super.onSaveInstanceState(outState);
    }

    @Override
    protected void onPause() {
        mapView.onPause();
        super.onPause();
        locationHelper.onStop();
    }

    @Override
    protected void onDestroy() {
        mapView.onDestroy();
        super.onDestroy();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        mapView = findViewById(R.id.mapViewActiveDelivery);
        tvOrderTimer = findViewById(R.id.tvOrderAcceptTimer);
        btnAcceptOrder = findViewById(R.id.btnAcceptOrder);
        btnRejectOrder = findViewById(R.id.btnRejectOrder);
        tvEstDistance = findViewById(R.id.tvEstDistance);
        tvEstTime = findViewById(R.id.tvEstTime);
        flAccept = findViewById(R.id.flAccept);
        llUpdateStatus = findViewById(R.id.llUpdateStatus);
        btnJobStatus = findViewById(R.id.btnJobStatus);
        ivNavigate = findViewById(R.id.ivNavigate);
        ivCustomerImage = findViewById(R.id.ivCustomerImage);
        tvCustomerName = findViewById(R.id.tvCustomerName);
        tvDeliveryDate = findViewById(R.id.tvDeliveryDate);
        tvDeliveryDate.setVisibility(View.GONE);
        ivActiveTargetLocation = findViewById(R.id.ivActiveTargetLocation);
        tvOrderNumber = findViewById(R.id.tvOrderNumber);
        llCallUser = findViewById(R.id.llCallUser);
        llCallUser.setVisibility(View.VISIBLE);
        llCart = findViewById(R.id.llCart);
        ivContactLessDelivery = findViewById(R.id.ivContactLessDelivery);
        llChat = findViewById(R.id.llChat);
        ivHaveMessage = findViewById(R.id.ivHaveMessage);
        tvCallTo = findViewById(R.id.tvCallTo);
        tvChatUser = findViewById(R.id.tvChatUser);
        tvBringChange = findViewById(R.id.tvBringChange);
        rvAddress = findViewById(R.id.rvAddress);
    }

    @Override
    protected void setViewListener() {
        btnRejectOrder.setOnClickListener(this);
        btnAcceptOrder.setOnClickListener(this);
        btnJobStatus.setOnClickListener(this);
        ivNavigate.setOnClickListener(this);
        ivActiveTargetLocation.setOnClickListener(this);
        llCallUser.setOnClickListener(this);
        llCart.setOnClickListener(this);
        llChat.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onLocationChanged(Location location) {
        currentLocation = location;
        currentLatLng = new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude());
        if (lastLocation == null) {
            lastLocation = currentLocation;
        }
        setMarkerOnLocation(currentLatLng, pickUpLatLng, deliveryLatLng);
        lastLocation = currentLocation;
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
        moveCameraFirstMyLocation(false);
    }


    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnAcceptOrder) {
            setOrderStatus(Const.ProviderStatus.DELIVERY_MAN_ACCEPTED);
        } else if (id == R.id.btnRejectOrder) {
            rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_REJECTED, false);
        } else if (id == R.id.ivActiveTargetLocation) {
            if (!markerList.isEmpty()) {
                setLocationBounds(true, markerList);
            }
        } else if (id == R.id.btnJobStatus) {
            if (orderStatus == Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
                openCompleteDeliveryDialog();
            } else if (orderStatus == Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER) {
                openDeliveryOrderItemConfirm();
            } else if (orderStatus == Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION) {
                if (order.isAllowContactlessDelivery()) {
                    openUploadImageDialog(orderStatus);
                } else {
                    setOrderStatus(orderStatus);
                }
            } else {
                setOrderStatus(orderStatus);
            }
        } else if (id == R.id.ivNavigate) {
            openPhotoMapDialog();
        } else if (id == R.id.llCallUser) {
            if (preferenceHelper.getIsEnableTwilioCallMasking()) {
                TwilioCallHelper.callViaTwilio(ActiveDeliveryActivity.this, llCallUser, requestId, type);
            } else {
                Utils.openCallChooser(ActiveDeliveryActivity.this, call);
            }
        } else if (id == R.id.llCart) {
            openCartDetailDialog();
        } else if (id == R.id.llChat) {
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
        if (order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER || order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY || order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION || order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY || order.getDeliveryType() == Const.DeliveryType.COURIER) {
            tvChatWithUser.setVisibility(View.VISIBLE);
        } else {
            tvChatWithUser.setVisibility(View.GONE);
        }
        tvChatWithUser.setOnClickListener(view -> {
            chatDialog.dismiss();
            if (userDetail != null && userDetailOrder != null) {
                gotToChatActivity(Const.ChatType.USER_AND_PROVIDER, userDetail.getName(), userDetailOrder.getId());
            } else {
                Utils.showToast(getString(R.string.msg_request_details_not_found), ActiveDeliveryActivity.this);
            }
        });
        TextView tvChatWithAdmin = chatDialog.findViewById(R.id.tvChatWithAdmin);
        tvChatWithAdmin.setOnClickListener(view -> {
            chatDialog.dismiss();
            gotToChatActivity(Const.ChatType.ADMIN_AND_PROVIDER, getResources().getString(R.string.text_admin), Const.ADMIN_RECIVER_ID);
        });
        TextView tvChatWithStore = chatDialog.findViewById(R.id.tvChatWithStore);
        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
            tvChatWithStore.setVisibility(View.GONE);
        } else {
            tvChatWithStore.setVisibility(View.VISIBLE);
            tvChatWithStore.setOnClickListener(view -> {
                chatDialog.dismiss();
                gotToChatActivity(Const.ChatType.PROVIDER_AND_STORE, order.getStoreName(), order.getStoreId());
            });
        }

        chatDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> chatDialog.dismiss());
        WindowManager.LayoutParams params = chatDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        chatDialog.show();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void setUpMap() {
        this.googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        this.googleMap.getUiSettings().setMapToolbarEnabled(false);
        this.googleMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
    }

    private void getExtraData() {
        if (getIntent() != null) {
            requestId = getIntent().getExtras().getString(Const.Params.ORDER_ID);
            isBringChange = getIntent().getExtras().getBoolean(Const.Params.IS_BRING_CHANGE);
        }
    }

    /**
     * this method call webservice for get current active order status
     */
    private void getRequestStatus() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.REQUEST_ID, requestId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderStatusResponse> responseCall = apiInterface.getRequestStatus(map);
        responseCall.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        order = response.body().getOrderRequest();
                        userDetailOrder = response.body().getUserDetail();
                        pickUpLatLng = new LatLng(order.getPickupAddresses().get(0).getLocation().get(0), order.getPickupAddresses().get(0).getLocation().get(1));
                        deliveryLatLng = new LatLng(order.getDestinationAddresses().get(0).getLocation().get(0), order.getDestinationAddresses().get(0).getLocation().get(1));
                        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                            if (isLoadDataFirstTime && order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY) {
                                deliveryLatLng = new LatLng(order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getLocation().get(0), order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getLocation().get(1));
                            } else {
                                if (order.getArrivedAtStopNo() - 1 > order.getDestinationAddresses().size()) {
                                    deliveryLatLng = new LatLng(order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getLocation().get(0), order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getLocation().get(1));
                                } else {
                                    deliveryLatLng = new LatLng(order.getDestinationAddresses().get(0).getLocation().get(0), order.getDestinationAddresses().get(0).getLocation().get(1));
                                }
                            }
                        }
                        loadOrderData(order.getDeliveryStatus());
                        tvEstTime.setText(Utils.minuteToHoursMinutesSeconds(order.getTotalTime()));
                        String unit = response.body().isDistanceUnitMile() ? getResources().getString(R.string.unit_mile) : getResources().getString(R.string.unit_km);
                        tvEstDistance.setText(String.format("%s%s", parseContent.decimalTwoDigitFormat.format(order.getTotalDistance()), unit));
                        checkCurrentOrderStatus(order.getDeliveryStatus());
                        setMarkerOnLocation(currentLatLng, pickUpLatLng, deliveryLatLng);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ActiveDeliveryActivity.this);
                        goToHomeActivity();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method used to manage UI according to order status
     *
     * @param orderStatus int
     */
    private void checkCurrentOrderStatus(int orderStatus) {
        switch (orderStatus) {
            case Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY:
                updateUiCancelOrder(false);
                updateUiOrderStatus(false);
                startCountDownTimer(order.getTimeLeftToRespondsTrip());
                break;
            case Const.ProviderStatus.DELIVERY_MAN_ACCEPTED:
                stopCountDownTimer();
                this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_COMING;
                updateUiOrderStatus(true);
                updateUiCancelOrder(true);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_COMING:
                stopCountDownTimer();
                this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_ARRIVED;
                btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_arrive));
                updateUiOrderStatus(true);
                updateUiCancelOrder(true);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED:
                this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER;
                btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_pickup));
                updateUiOrderStatus(true);
                updateUiCancelOrder(true);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER:
                this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY;
                btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_start));
                updateUiOrderStatus(true);
                updateUiCancelOrder(false);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION;
                if (order.getDestinationAddresses().size() > 1
                        && order.getArrivedAtStopNo() != order.getDestinationAddresses().size() - 1
                        && order.getArrivedAtStopNo() + 1 < order.getDestinationAddresses().size()) {
                    btnJobStatus.setText(String.format("%s %s", getString(R.string.text_tap_here_to_arrive_destination), order.getArrivedAtStopNo() + 1));
                } else {
                    btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_arrive_destination));
                }
                updateUiOrderStatus(true);
                updateUiCancelOrder(false);
                order.setArrivedAtStopNo(order.getArrivedAtStopNo() + 1);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                if (order.getArrivedAtStopNo() >= order.getDestinationAddresses().size()) {
                    this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY;
                    btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_end));
                } else {
                    this.orderStatus = Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER;
                    if (order.getDestinationAddresses().size() > 1 && order.getArrivedAtStopNo() != 0) {
                        btnJobStatus.setText(String.format("%s %s", getString(R.string.text_start_from_address), order.getArrivedAtStopNo()));
                    } else {
                        btnJobStatus.setText(getResources().getString(R.string.text_tap_here_to_pickup));
                    }
                }
                updateUiOrderStatus(true);
                updateUiCancelOrder(false);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                btnJobStatus.setText(getResources().getString(R.string.text_view_invoice));
                updateUiOrderStatus(true);
                ivNavigate.setVisibility(View.GONE);
                btnJobStatus.setOnClickListener(view -> {
                    if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                        userDetail = order.getPickupAddresses().get(0).getUserDetails();
                    } else {
                        userDetail = order.getDestinationAddresses().get(0).getUserDetails();
                    }
                    goToInvoiceFragment(null, "", userDetail, requestId, order.getDeliveryType());
                });
                updateUiCancelOrder(false);
                break;
            case Const.ProviderStatus.STORE_CANCELLED_REQUEST:
                goToHomeActivity();
                break;
            default:
                break;
        }
        showPickupTimeAndDate();
    }

    private void showPickupTimeAndDate() {
        if (!TextUtils.isEmpty(order.getEstimatedTimeForReadyOrder()) && (orderStatus == Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY || orderStatus == Const.ProviderStatus.DELIVERY_MAN_ACCEPTED || orderStatus == Const.ProviderStatus.DELIVERY_MAN_COMING || orderStatus == Const.ProviderStatus.DELIVERY_MAN_ARRIVED)) {
            try {
                Date date = parseContent.webFormat.parse(order.getEstimatedTimeForReadyOrder());
                if (date != null) {
                    tvDeliveryDate.setText(String.format("%s %s", getResources().getString(R.string.text_pick_up_order_after), parseContent.dateTimeFormat.format(date)));
                    tvDeliveryDate.setVisibility(View.VISIBLE);
                }
            } catch (ParseException e) {
                AppLog.handleException(ActiveDeliveryActivity.class.getName(), e);
            }
        } else {
            tvDeliveryDate.setVisibility(View.GONE);
        }
    }

    /**
     * this method call webservice for reject or cancel active order
     *
     * @param orderStatus in int
     * @param isCanceled  true for cancel order
     */
    private void rejectOrCancelDeliveryOrder(int orderStatus, boolean isCanceled) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();

        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.REQUEST_ID, requestId);
        map.put(Const.Params.DELIVERY_STATUS, orderStatus);
        if (isCanceled) {
            CancelReasons cancelReasons = new CancelReasons();
            cancelReasons.setCancelledAt(parseContent.webFormat.format(new Date()));
            cancelReasons.setCancelReason(cancelReason);
            UserDetail userDetail = new UserDetail();
            userDetail.setName(preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName());
            userDetail.setPhone(preferenceHelper.getPhoneNumber());
            userDetail.setCountryPhoneCode(preferenceHelper.getPhoneCountyCode());
            userDetail.setId(preferenceHelper.getProviderId());
            userDetail.setEmail(preferenceHelper.getEmail());
            userDetail.setUniqueId(preferenceHelper.getUniqueId());
            cancelReasons.setUserDetail(userDetail);
            map.put(Const.Params.CANCEL_REASONS, cancelReasons);
        }


        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.rejectOrCancelDelivery(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        onBackPressed();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ActiveDeliveryActivity.this);
                        goToHomeActivity();
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

    /**
     * this method call webservice for set order status by provider
     *
     * @param orderStatus in int
     */
    private void setOrderStatus(int orderStatus) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getSessionToken()));
        hashMap.put(Const.Params.PROVIDER_ID, ApiClient.makeTextRequestBody(preferenceHelper.getProviderId()));
        hashMap.put(Const.Params.REQUEST_ID, ApiClient.makeTextRequestBody(requestId));
        hashMap.put(Const.Params.DELIVERY_STATUS, ApiClient.makeTextRequestBody(orderStatus));
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderStatusResponse> responseCall = apiInterface.setRequestStatus(ApiClient.makeMultipartRequestBody(currentPhotoPath, Const.Params.IMAGE_URL), hashMap);
        responseCall.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        isLoadDataFirstTime = false;
                        currentPhotoPath = null;
                        picUri = null;
                        int orderStatus = response.body().getDeliveryStatus();
                        if (order != null) {
                            order.setDeliveryStatus(orderStatus);
                            order.setStatusTime(response.body().getStatusTime());
                        }
                        checkCurrentOrderStatus(orderStatus);
                        loadOrderData(orderStatus);
                        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                            if (isLoadDataFirstTime && order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY) {
                                deliveryLatLng = new LatLng(order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getLocation().get(0), order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getLocation().get(1));
                            } else {
                                if (order.getArrivedAtStopNo() - 1 > order.getDestinationAddresses().size()) {
                                    deliveryLatLng = new LatLng(order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getLocation().get(0), order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getLocation().get(1));
                                } else {
                                    deliveryLatLng = new LatLng(order.getDestinationAddresses().get(0).getLocation().get(0), order.getDestinationAddresses().get(0).getLocation().get(1));
                                }
                            }
                            setMarkerOnLocation(currentLatLng, pickUpLatLng, deliveryLatLng);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ActiveDeliveryActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method is set countDown timer for count a order accepting time
     *
     * @param seconds seconds
     */
    private void startCountDownTimer(int seconds) {
        if (seconds <= 0) {
            rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_REJECTED, false);
            return;
        }
        if (!isCountDownTimerStart) {
            isCountDownTimerStart = true;
            final long milliSecond = 1000;
            long millisUntilFinished = seconds * milliSecond;
            countDownTimer = null;
            if (preferenceHelper.getIsNewOrderSoundOn()) {
                soundHelper.playWhenNewOrderSound();
            } else {
                soundHelper.stopWhenNewOrderSound(ActiveDeliveryActivity.this);
            }
            countDownTimer = new CountDownTimer(millisUntilFinished, milliSecond) {

                public void onTick(long millisUntilFinished) {
                    final long seconds = millisUntilFinished / milliSecond;
                    tvOrderTimer.setText(String.format("%ss", seconds));
                }

                public void onFinish() {
                    if (isCountDownTimerStart) {
                        rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_REJECTED, false);
                        isCountDownTimerStart = false;
                    }
                    soundHelper.stopWhenNewOrderSound(ActiveDeliveryActivity.this);
                }

            }.start();
        }
    }

    private void stopCountDownTimer() {
        if (isCountDownTimerStart) {
            isCountDownTimerStart = false;
            countDownTimer.cancel();
            tvOrderTimer.setText("");
        }
        soundHelper.stopWhenNewOrderSound(ActiveDeliveryActivity.this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        stopCountDownTimer();
        unregisterReceiver(orderStatusReceiver);
    }


    private void updateUiOrderStatus(boolean isUpdate) {
        if (isUpdate) {
            llUpdateStatus.setVisibility(View.VISIBLE);
            flAccept.setVisibility(View.GONE);
        } else {
            llUpdateStatus.setVisibility(View.GONE);
            flAccept.setVisibility(View.VISIBLE);
        }
    }


    /**
     * this method is used to set marker on map
     *
     * @param currentLatLng LatLng
     * @param pickUpLatLng  LatLng
     * @param destLatLng    LatLng
     */
    private void setMarkerOnLocation(LatLng currentLatLng, LatLng pickUpLatLng, LatLng destLatLng) {
        BitmapDescriptor bitmapDescriptor;
        markerList.clear();
        if (currentLatLng != null) {
            if (providerMarker == null) {
                providerMarker = googleMap.addMarker(new MarkerOptions().position(currentLatLng).title(getResources().getString(R.string.text_my_location)));
                providerMarker.setAnchor(0.5f, 0.5f);
                parseContent.downloadVehiclePin(this, providerMarker);
            } else {
                animateMarkerToGB(providerMarker, currentLatLng, new LatLngInterpolator.Linear());
            }
            markerList.add(currentLatLng);

            if (pickUpLatLng != null) {
                if (pickUpMarker == null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(this, R.drawable.ic_pickup_map)));
                    pickUpMarker = googleMap.addMarker(new MarkerOptions().position(pickUpLatLng).title(getResources().getString(R.string.text_pick_up_loc)).icon(bitmapDescriptor));
                } else {
                    pickUpMarker.setPosition(pickUpLatLng);
                }
            }
            if (destLatLng != null) {
                if (destinationMarker == null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(this, R.drawable.ic_pin_delivery)));
                    destinationMarker = googleMap.addMarker(new MarkerOptions().position(destLatLng).title(getResources().getString(R.string.text_drop_location)).icon(bitmapDescriptor));
                } else {
                    destinationMarker.setPosition(destLatLng);
                }
            }

            if (orderStatus == Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY) {
                if (destLatLng != null) {
                    markerList.add(destLatLng);
                }
                if (pickUpLatLng != null) {
                    markerList.add(pickUpLatLng);
                }
            } else if (orderStatus <= Const.ProviderStatus.DELIVERY_MAN_COMING) {
                if (pickUpLatLng != null) {
                    markerList.add(pickUpLatLng);
                }
            } else {
                if (destLatLng != null) {
                    markerList.add(destLatLng);
                }
            }

            try {
                if (markerList.size() > 1) {
                    setLocationBounds(true, markerList);
                }
            } catch (Exception e) {
                AppLog.handleException(TAG, e);
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
                    if (getDistanceBetweenTwoLatLng(startPosition, finalPosition) > LocationHelper.DISPLACEMENT) {
                        updateCamera(getBearing(startPosition, new LatLng(finalPosition.latitude, finalPosition.longitude)), newPosition);
                    }
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
        if (positionLatLng != null && isCameraIdeal) {
            isCameraIdeal = false;
            CameraPosition oldPos = googleMap.getCameraPosition();
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

    private float getBearing(LatLng begin, LatLng end) {
        double lat = Math.abs(begin.latitude - end.latitude);
        double lng = Math.abs(begin.longitude - end.longitude);

        double v = Math.toDegrees(Math.atan(lng / lat));
        if (begin.latitude < end.latitude && begin.longitude < end.longitude)
            return (float) v;
        else if (begin.latitude >= end.latitude && begin.longitude < end.longitude)
            return (float) ((90 - v) + 90);
        else if (begin.latitude >= end.latitude && begin.longitude >= end.longitude)
            return (float) (v + 180);
        else if (begin.latitude < end.latitude && begin.longitude >= end.longitude)
            return (float) ((90 - v) + 270);
        return -1;
    }

    private float getDistanceBetweenTwoLatLng(LatLng startLatLng, LatLng endLatLang) {
        Location startLocation = new Location("start");
        Location endLocation = new Location("end");
        endLocation.setLatitude(endLatLang.latitude);
        endLocation.setLongitude(endLatLang.longitude);
        startLocation.setLatitude(startLatLng.latitude);
        startLocation.setLongitude(startLatLng.longitude);
        return startLocation.distanceTo(endLocation);
    }

    /**
     * this method set map camera at current location
     *
     * @param isAnimate ture for animate camera in map
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate) {
        locationHelper.getLastLocation(location -> {
            currentLocation = location;
            if (currentLocation != null) {
                currentLatLng = new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude());
                CameraPosition cameraPosition = new CameraPosition.Builder().target(currentLatLng).zoom(17).build();
                if (isAnimate) {
                    googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                } else {
                    googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                }
            }
        });
    }

    /**
     * this method call webservice for complete a active or running  order
     */
    private void completeOrder() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.REQUEST_ID, requestId);


        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CompleteOrderResponse> responseCall = apiInterface.completeOrder(map);
        responseCall.enqueue(new Callback<CompleteOrderResponse>() {
            @Override
            public void onResponse(@NonNull Call<CompleteOrderResponse> call, @NonNull Response<CompleteOrderResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), ActiveDeliveryActivity.this);
                        CurrentOrder.getInstance().setCurrency(response.body().getCurrency());
                        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                            userDetail = order.getPickupAddresses().get(0).getUserDetails();
                        } else {
                            userDetail = order.getDestinationAddresses().get(0).getUserDetails();
                        }
                        checkCurrentOrderStatus(orderStatus);
                        goToInvoiceFragment(response.body().getOrderPayment(), response.body().getPaymentGatewayName(), userDetail, requestId, order.getDeliveryType());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ActiveDeliveryActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<CompleteOrderResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openPickupDeliveryDialog() {
        if (order.isConfirmationCodeRequiredAtPickupDelivery()) {
            if (pickUpDeliveryDialog != null && pickUpDeliveryDialog.isShowing()) {
                return;
            }
            pickUpDeliveryDialog = new CustomDialogVerification(ActiveDeliveryActivity.this, getResources().getString(R.string.text_pickup_delivery), getResources().getString(R.string.msg_enter_delivery_pick_up_code), getResources().getString(R.string.text_submit), null, getResources().getString(R.string.text_confirmation_code), false, InputType.TYPE_CLASS_TEXT, InputType.TYPE_CLASS_NUMBER, false) {
                @Override
                protected void resendOtp() {

                }

                @Override
                public void onClickLeftButton() {
                    dismiss();
                }

                @Override
                public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                    if (TextUtils.equals(etDialogEditTextTwo.getText().toString(), order.getConfirmationCodeForPickUp())) {
                        if (order.isAllowPickupOrderVerification()) {
                            openUploadImageDialog(orderStatus);
                        } else {
                            setOrderStatus(orderStatus);
                        }
                        dismiss();
                        hideSoftKeyboard(ActiveDeliveryActivity.this);
                    } else {
                        etDialogEditTextTwo.setError(getResources().getString(R.string.msg_invalid_information_code));
                        etDialogEditTextTwo.requestFocus();
                    }
                }
            };
            pickUpDeliveryDialog.show();
        } else {
            if (order.isAllowPickupOrderVerification()) {
                openUploadImageDialog(orderStatus);
            } else {
                setOrderStatus(orderStatus);
            }
        }

    }

    private void openCompleteDeliveryDialog() {
        if (order.isConfirmationCodeRequiredAtCompleteDelivery()) {

            if (completeDeliveryDialog != null && completeDeliveryDialog.isShowing()) {
                return;
            }

            completeDeliveryDialog = new CustomDialogVerification(this, getResources().getString(R.string.text_complete_delivery), getResources().getString(R.string.msg_enter_delivery_code), getResources().getString(R.string.text_submit), null, getResources().getString(R.string.text_confirmation_code), false, InputType.TYPE_CLASS_TEXT, InputType.TYPE_CLASS_NUMBER, false) {
                @Override
                protected void resendOtp() {

                }

                @Override
                public void onClickLeftButton() {
                    dismiss();
                }

                @Override
                public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                    if (TextUtils.equals(etDialogEditTextTwo.getText().toString(), order.getConfirmationCodeForCompleteDelivery())) {
                        completeOrder();
                        dismiss();
                    } else {
                        etDialogEditTextTwo.setError(getResources().getString(R.string.msg_invalid_information_code));
                        etDialogEditTextTwo.requestFocus();
                    }

                }
            };
            completeDeliveryDialog.show();
        } else {
            completeOrder();
        }

    }

    private void goToInvoiceFragment(OrderPayment orderPayment, String payment, UserDetail userDetail, String requestId, int deliveryType) {
        InvoiceFragment invoiceFragment = new InvoiceFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable(Const.ORDER_PAYMENT, orderPayment);
        bundle.putString(Const.PAYMENT, payment);
        bundle.putParcelable(Const.USER_DETAIL, userDetail);
        bundle.putString(Const.Params.REQUEST_ID, requestId);
        bundle.putBoolean(Const.BACK_TO_ACTIVE_DELIVERY, true);
        bundle.putInt(Const.Params.DELIVERY_TYPE, deliveryType);
        invoiceFragment.setArguments(bundle);
        invoiceFragment.show(getSupportFragmentManager(), invoiceFragment.getTag());
    }


    private boolean isOrderPickedUp(int orderStatus) {
        switch (orderStatus) {
            case Const.ProviderStatus.DELIVERY_MAN_ACCEPTED:
            case Const.ProviderStatus.DELIVERY_MAN_COMING:
            case Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY:
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED:
                return false;
            case Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER:
            case Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            case Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                return true;
            default:
                break;
        }
        return false;
    }

    private void loadOrderData(int orderStatus) {
        String name, image;
        if (isOrderPickedUp(orderStatus)) {
            if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                if (isLoadDataFirstTime && order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY) {
                    userDetail = order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getUserDetails();
                } else {
                    userDetail = order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getUserDetails();
                }
            } else {
                userDetail = order.getDestinationAddresses().get(0).getUserDetails();
            }
            name = userDetail.getName();
            image = IMAGE_URL + userDetail.getImageUrl();
            call = userDetail.getCountryPhoneCode() + userDetail.getPhone();
            type = String.valueOf(Const.TYPE_USER);
            tvCallTo.setText(R.string.text_call_user);
            tvChatUser.setText(R.string.text_chat);
        } else {
            if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                userDetail = order.getPickupAddresses().get(0).getUserDetails();
                if (order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY) {
                    name = getString(R.string.text_courier);
                } else {
                    name = userDetail.getName();
                }
                tvCallTo.setText(R.string.text_call_user);
                tvChatUser.setText(R.string.text_chat_user);
            } else {
                name = order.getStoreName();
                tvCallTo.setText(R.string.text_call_store);
                tvChatUser.setText(R.string.text_chat);
                type = String.valueOf(Const.TYPE_STORE);
            }

            image = IMAGE_URL + order.getStoreImage();
            call = order.getPickupAddresses().get(0).getUserDetails().getCountryPhoneCode() + order.getPickupAddresses().get(0).getUserDetails().getPhone();
        }

        String orderNumber = getResources().getString(R.string.text_order_number) + " " + "#" + order.getOrderUniqueId();
        tvOrderNumber.setText(orderNumber);

        tvCustomerName.setText(name);
        GlideApp.with(ActiveDeliveryActivity.this)
                .load(image)
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                .into(ivCustomerImage);
        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
            llCart.setVisibility(order.getCourierItemsImages().isEmpty() && order.getOrderDetails().isEmpty() ? View.GONE : View.VISIBLE);
        } else {
            llCart.setVisibility(order.getOrderDetails().isEmpty() ? View.GONE : View.VISIBLE);
        }

        ivContactLessDelivery.setVisibility(order.isAllowContactlessDelivery() ? View.VISIBLE : View.GONE);

        intRVAddress();
    }

    @SuppressLint("NotifyDataSetChanged")
    private void intRVAddress() {
        if (addressAdapter == null) {
            addressesList = new ArrayList<>();
            addressesList.addAll(order.getPickupAddresses());
            addressesList.addAll(order.getDestinationAddresses());
            addressAdapter = new DeliveryAddressAdapter(this, addressesList);
            rvAddress.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvAddress.setNestedScrollingEnabled(false);
            rvAddress.setAdapter(addressAdapter);
        }

        if (order != null) {
            if (order.getStatusTime() != null && !order.getStatusTime().isEmpty()) {
                for (int i = 1; i < addressesList.size(); i++) {
                    for (Status status : order.getStatusTime()) {
                        if (status.getStopNo() == i) {
                            try {
                                Date date = parseContent.webFormat.parse(status.getDate());
                                if (date != null) {
                                    String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                                    addressesList.get(i).setArrivedTime(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
                                }
                                break;
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }

            if (!isLoadDataFirstTime && order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY) {
                addressAdapter.setReachedAddressPosition(isOrderPickedUp(order.getDeliveryStatus()), order.getArrivedAtStopNo() - 1);
            } else {
                addressAdapter.setReachedAddressPosition(isOrderPickedUp(order.getDeliveryStatus()), order.getArrivedAtStopNo());
            }
        }
        addressAdapter.notifyDataSetChanged();
    }

    private void updateUiCancelOrder(boolean isEnable) {
        if (isEnable) {
            setToolbarRightIcon(R.drawable.ic_cancel, view -> getCancellationReasons());
        } else {
            if (order.getDeliveryType() == Const.DeliveryType.COURIER && TextUtils.isEmpty(order.getDestinationAddresses().get(0).getNote()) && TextUtils.isEmpty(order.getPickupAddresses().get(0).getNote())) {
                setToolbarRightIcon(-1, this);
            } else if (order.getDeliveryType() == Const.DeliveryType.STORE && TextUtils.isEmpty(order.getDestinationAddresses().get(0).getNote())) {
                setToolbarRightIcon(-1, this);
            } else {
                setToolbarRightIcon(R.drawable.ic_notepad, view -> openOrderNoteDialog());
            }
        }
    }

    private void getCancellationReasons() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CancellationReasonsResponse> responseCall = apiInterface.getCancellationReasons(map);
        responseCall.enqueue(new Callback<CancellationReasonsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CancellationReasonsResponse> call, @NonNull Response<CancellationReasonsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response) && response.body() != null) {
                    openCancelOrderDialog(response.body().getReasons());
                } else {
                    openCancelOrderDialog(new ArrayList<>());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CancellationReasonsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
                openCancelOrderDialog(new ArrayList<>());
            }
        });
    }

    private void openCancelOrderDialog(ArrayList<String> cancellationReason) {
        if (orderCancelDialog != null && orderCancelDialog.isShowing()) {
            return;
        }

        orderCancelDialog = new BottomSheetDialog(this);
        orderCancelDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        orderCancelDialog.setContentView(R.layout.dialog_cancel_order);

        final CancellationReasonAdapter cancellationReasonAdapter;
        final RecyclerView rvCancellationReason;

        rvCancellationReason = orderCancelDialog.findViewById(R.id.rvCancellationReason);

        if (cancellationReason.isEmpty()) {
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_one));
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_two));
        }
        cancellationReason.add(getString(R.string.text_others));

        cancellationReasonAdapter = new CancellationReasonAdapter(cancellationReason) {
            @Override
            public void onReasonSelected(int position) {
                currentPosition = position;
            }
        };
        rvCancellationReason.setAdapter(cancellationReasonAdapter);

        orderCancelDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
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
                rejectOrCancelDeliveryOrder(Const.ProviderStatus.DELIVERY_MAN_CANCELLED, true);
                orderCancelDialog.dismiss();
            } else {
                Utils.showToast(getResources().getString(R.string.msg_plz_give_valid_reason), ActiveDeliveryActivity.this);
            }
        });
        orderCancelDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> {
            orderCancelDialog.dismiss();
            cancelReason = "";
        });
        WindowManager.LayoutParams params = orderCancelDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        orderCancelDialog.setCancelable(false);
        orderCancelDialog.show();
    }

    private List<Double> getLocationAsPerStatus(int orderStatus) {
        if (orderStatus == Const.ProviderStatus.DELIVERY_MAN_ACCEPTED
                || orderStatus == Const.ProviderStatus.DELIVERY_MAN_COMING
                || orderStatus == Const.ProviderStatus.DELIVERY_MAN_ARRIVED
                || orderStatus == Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY) {
            return order.getPickupAddresses().get(0).getLocation();
        } else {
            if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                if (order.getArrivedAtStopNo() > 1) {
                    return order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getLocation();
                } else {
                    return order.getDestinationAddresses().get(0).getLocation();
                }
            } else {
                return order.getDestinationAddresses().get(0).getLocation();
            }
        }
    }

    /**
     * this method is used to open Google Map app whit given LatLng
     */
    private void goToGoogleMapApp(List<Double> locationList) {
        Uri gmmIntentUri = Uri.parse("google.navigation:q=" + locationList.get(0) + "," + locationList.get(1));
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        if (mapIntent.resolveActivity(getPackageManager()) != null) {
            startActivity(mapIntent);
        } else {
            Utils.showToast(getResources().getString(R.string.msg_google_app_not_installed), this);
        }
    }

    /**
     * this method is used to open Waze Map app whit given LatLng
     */
    private void goToWazeMapApp(List<Double> locationList) {
        try {
            String url = "waze://?ll=" + locationList.get(0) + "," + locationList.get(1) + "&navigate=yes";
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            startActivity(intent);
        } catch (ActivityNotFoundException ex) {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.waze"));
            startActivity(intent);
            Utils.showToast(getResources().getString(R.string.waze_map_msg), this);
        }
    }

    public void openPhotoMapDialog() {
        //Do the stuff that requires permission...
        if (mapDialog != null && mapDialog.isShowing()) {
            return;
        }
        mapDialog = new CustomPhotoDialog(this, getResources().getString(R.string.text_choose_map), getResources().getString(R.string.text_google_map), getResources().getString(R.string.text_waze_map)) {
            @Override
            public void clickedOnCamera() {
                goToGoogleMapApp(getLocationAsPerStatus(orderStatus));
                dismiss();
            }

            @Override
            public void clickedOnGallery() {
                goToWazeMapApp(getLocationAsPerStatus(orderStatus));
                dismiss();
            }
        };
        mapDialog.show();

    }

    public void openOrderNoteDialog() {
        if (noteDialog != null && noteDialog.isShowing()) {
            return;
        }

        StringBuilder note = new StringBuilder();
        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
            if (!TextUtils.isEmpty(order.getPickupAddresses().get(0).getNote())) {
                note.append(getResources().getString(R.string.text_pickup)).append(":\n").append(order.getPickupAddresses().get(0).getNote()).append("\n\n");
            }

            if (order.getDestinationAddresses().size() > 1) {
                for (int i = 0; i < order.getDestinationAddresses().size(); i++) {
                    if (!TextUtils.isEmpty(order.getDestinationAddresses().get(i).getNote())) {
                        note.append(String.format("%s %s", getString(R.string.text_delviery), i + 1)).append(":\n").append(order.getDestinationAddresses().get(i).getNote()).append("\n\n");
                    }
                }
            } else {
                if (!TextUtils.isEmpty(order.getDestinationAddresses().get(0).getNote())) {
                    note.append(getResources().getString(R.string.text_delviery)).append(":\n").append(order.getDestinationAddresses().get(0).getNote());
                }
            }
        } else {
            note = new StringBuilder(order.getDestinationAddresses().get(0).getNote());
        }
        noteDialog = new CustomDialogAlert(this, getResources().getString(R.string.txt_note), note.toString(), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
            }
        };
        noteDialog.show();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case TAKE_PHOTO_FROM_CAMERA:
                    onCaptureImageResult();
                    break;
                case CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE:
                    handleCrop(resultCode, data);
                    break;
                case REQUEST_CHECK_SETTINGS:
                    moveCameraFirstMyLocation(true);
                    break;
                default:
                    break;
            }
        }
    }

    private void openCartDetailDialog() {
        if (cartDetailDialog != null && cartDetailDialog.isShowing()) {
            return;
        }

        cartDetailDialog = new BottomSheetDialog(this);
        cartDetailDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        cartDetailDialog.setContentView(R.layout.dialog_cart_detail);
        CustomFontTextView tvOrderNumber = cartDetailDialog.findViewById(R.id.tvOrderNumber);
        String orderNumber = getResources().getString(R.string.text_order_number) + " " + "#" + order.getOrderUniqueId();
        tvOrderNumber.setText(orderNumber);
        RecyclerView rcvCourierImage = cartDetailDialog.findViewById(R.id.rcvCourierImage);
        RecyclerView rcvOrderProductItem = cartDetailDialog.findViewById(R.id.rcvOrderProductItem);
        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
            if (order.getCourierItemsImages() != null && !order.getCourierItemsImages().isEmpty()) {
                rcvCourierImage.setVisibility(View.VISIBLE);
                rcvCourierImage.setLayoutManager(new GridLayoutManager(this, 3));
                CourierItemDetailAdapter courierItemDetailAdapter = new CourierItemDetailAdapter(ActiveDeliveryActivity.this, order.getCourierItemsImages());
                rcvCourierImage.setAdapter(courierItemDetailAdapter);
            } else {
                rcvCourierImage.setVisibility(View.GONE);
            }
        }

        if (order.getOrderDetails() != null && !order.getOrderDetails().isEmpty()) {
            rcvOrderProductItem.setVisibility(View.VISIBLE);
            rcvOrderProductItem.setLayoutManager(new LinearLayoutManager(this));
            OrderDetailsAdapter itemAdapter = new OrderDetailsAdapter(this, order.getOrderDetails(), order.getCurrency(), false);
            rcvOrderProductItem.setAdapter(itemAdapter);
            itemAdapter.setDeliveryType(order.getDeliveryType());
        } else {
            rcvOrderProductItem.setVisibility(View.GONE);
        }

        cartDetailDialog.findViewById(R.id.btnDone).setOnClickListener(v -> cartDetailDialog.dismiss());

        if (cartDetailDialog instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) cartDetailDialog;
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }

        WindowManager.LayoutParams params = cartDetailDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        cartDetailDialog.setCancelable(false);
        cartDetailDialog.show();
    }

    protected void openDeliveryOrderItemConfirm() {
        if (orderItemConfirmDialog != null && orderItemConfirmDialog.isShowing()) {
            return;
        }
        if (order.getArrivedAtStopNo() != 0) {
            setOrderStatus(orderStatus);
            return;
        }
        orderItemConfirmDialog = new CustomDialogAlert(this, this.getResources().getString(R.string.text_order_item_confirm), this.getResources().getString(R.string.msg_order_item_confirm), this.getResources().getString(R.string.text_confirm)) {
            @Override
            public void onClickLeftButton() {
                dismiss();

            }

            @Override
            public void onClickRightButton() {
                dismiss();
                openPickupDeliveryDialog();
            }
        };
        orderItemConfirmDialog.show();
    }

    @Override
    public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
        int visible = View.GONE;
        for (DataSnapshot snapshot : dataSnapshot.getChildren()) {
            Message chatMessage = snapshot.getValue(Message.class);
            if (chatMessage != null) {
                if (!chatMessage.isIs_read() && chatMessage.getSender_type() == Const.PROVIDER_CHAT_ID) {
                    visible = View.VISIBLE;
                    break;
                }
            }
        }
        ivHaveMessage.setVisibility(visible);
    }

    @Override
    public void onCancelled(@NonNull DatabaseError databaseError) {

    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = imageHelper.createImageFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            picUri = FileProvider.getUriForFile(this, getPackageName(), file);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        } else {
            picUri = Uri.fromFile(file);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, picUri);
        startActivityForResult(intent, TAKE_PHOTO_FROM_CAMERA);
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        CropImage.activity(sourceUri).setGuidelines(com.theartofdev.edmodo.cropper.CropImageView.Guidelines.ON).start(this);
    }

    /**
     * This method is used for handel result after captured placeholder from camera .
     */
    private void onCaptureImageResult() {
        beginCrop(picUri);
    }

    /**
     * This method is used for  handel crop result after crop the placeholder.
     */
    private void handleCrop(int resultCode, Intent result) {
        CropImage.ActivityResult activityResult = CropImage.getActivityResult(result);
        if (resultCode == RESULT_OK) {
            picUri = activityResult.getUri();
            currentPhotoPath = picUri.getPath();
            new ImageCompression(this).setImageCompressionListener(compressionImagePath -> currentPhotoPath = compressionImagePath).execute(currentPhotoPath);
            GlideApp.with(ActiveDeliveryActivity.this).load(picUri).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).into(uploadImageView);
        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), this);
        }
    }

    private void goWithCameraAndStoragePermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else {
            takePhotoFromCamera();
        }
    }

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                ActivityCompat.requestPermissions(ActiveDeliveryActivity.this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
                closedPermissionDialog();
            }

        };
        closedPermissionDialog.show();
    }

    private void closedPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            closedPermissionDialog.dismiss();
            closedPermissionDialog = null;
        }
    }

    public void checkPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
        } else {
            takePhotoFromCamera();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE) {
                goWithCameraAndStoragePermission(grantResults);
            }
        }
    }

    private void openUploadImageDialog(int orderStatus) {
        if (uploadImageDialog != null && uploadImageDialog.isShowing()) {
            return;
        }

        uploadImageDialog = new BottomSheetDialog(this);
        uploadImageDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        uploadImageDialog.setContentView(R.layout.dialog_document_upload);
        uploadImageView = uploadImageDialog.findViewById(R.id.ivDialogDocumentImage);
        CustomFontTextViewTitle tvDocumentTitle = uploadImageDialog.findViewById(R.id.tvDialogAlertTitle);
        uploadImageDialog.findViewById(R.id.tilNumberId).setVisibility(View.GONE);
        uploadImageDialog.findViewById(R.id.tilExpireDate).setVisibility(View.GONE);
        uploadImageDialog.findViewById(R.id.llDocumentInfo).setVisibility(View.GONE);

        tvDocumentTitle.setText(getResources().getString(R.string.text_upload_item_image));
        GlideApp.with(ActiveDeliveryActivity.this).load(picUri).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).into(uploadImageView);
        uploadImageDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            if (TextUtils.isEmpty(currentPhotoPath)) {
                Utils.showToast(getResources().getString(R.string.msg_plz_select_document_image), ActiveDeliveryActivity.this);
            } else {
                uploadImageDialog.dismiss();
                setOrderStatus(orderStatus);
            }
        });

        uploadImageDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> uploadImageDialog.dismiss());
        uploadImageView.setOnClickListener(view -> checkPermission());
        WindowManager.LayoutParams params = uploadImageDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        uploadImageDialog.getWindow().setAttributes(params);
        uploadImageDialog.setCancelable(false);
        uploadImageDialog.show();
    }

    private void gotToChatActivity(int chat_type, String title, String receiver_id) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(Const.Params.ORDER_ID, order.getOrder_id());
        intent.putExtra(Const.Params.TYPE, String.valueOf(chat_type));
        intent.putExtra(Const.TITLE, title);
        intent.putExtra(Const.RECEIVER_ID, receiver_id);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void openDialogCourierItemImage(int position) {
        Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_item_image);
        llDotsDialog = dialog.findViewById(R.id.llDotsDialog);
        imageViewPagerDialog = dialog.findViewById(R.id.dialogImageViewPager);
        dialog.findViewById(R.id.ivClose).setOnClickListener(v -> dialog.dismiss());
        addBottomDotsDialog(position);
        CourierItemAdapter courierItemAdapter = new CourierItemAdapter(this, order.getCourierItemsImages(), R.layout.item_image_full);
        imageViewPagerDialog.setAdapter(courierItemAdapter);
        imageViewPagerDialog.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                dotColorChangeDialog(position);
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        imageViewPagerDialog.setCurrentItem(position);
        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.show();
    }

    private void addBottomDotsDialog(int currentPage) {
        if (order.getCourierItemsImages().size() > 1) {
            TextView[] dots = new TextView[order.getCourierItemsImages().size()];

            llDotsDialog.removeAllViews();
            for (int i = 0; i < dots.length; i++) {
                dots[i] = new TextView(this);
                dots[i].setText(Html.fromHtml("&#8226;"));
                dots[i].setTextSize(35);
                dots[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));
                llDotsDialog.addView(dots[i]);
            }

            if (dots.length > 0) {
                dots[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
            }
        }
    }

    private void dotColorChangeDialog(int currentPage) {
        if (llDotsDialog.getChildCount() > 0) {
            for (int i = 0; i < llDotsDialog.getChildCount(); i++) {
                TextView textView = (TextView) llDotsDialog.getChildAt(i);
                textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));

            }
            TextView textView = (TextView) llDotsDialog.getChildAt(currentPage);
            textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
        }
    }

    private class OrderStatusReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            goToHomeActivity();
        }
    }
}