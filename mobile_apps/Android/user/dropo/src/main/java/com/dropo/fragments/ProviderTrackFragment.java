package com.dropo.fragments;

import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.animation.ValueAnimator;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.constraintlayout.widget.Group;
import androidx.core.content.res.ResourcesCompat;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.OrderDetailActivity;
import com.dropo.user.R;
import com.dropo.component.CustomEventMapView;
import com.dropo.interfaces.LatLngInterpolator;
import com.dropo.models.datamodels.Order;
import com.dropo.models.responsemodels.ActiveOrderResponse;
import com.dropo.models.responsemodels.ProviderLocationResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.TwilioCallHelper;
import com.dropo.utils.Utils;
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
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProviderTrackFragment extends BottomSheetDialogFragment implements OnMapReadyCallback, View.OnClickListener {

    public boolean isScheduleStart;
    private CustomEventMapView mapView;
    private ImageView ivRegisterProfileImage, ivCallProvider, ivTargetLocation;
    private TextView tvProviderName;
    private TextView tvOrderEstTime, tvAddress;
    private ActiveOrderResponse activeOrderResponse;
    private Order order;
    private ScheduledExecutorService schedule;
    private Handler handler;
    private ArrayList<LatLng> markerList;
    private GoogleMap googleMap;
    private LatLng destinationLatLng;
    private Marker providerMarker, destinationMarker;
    private boolean isCameraIdeal = true;
    private OrderDetailActivity orderDetailActivity;
    private Group groupHistory, groupActiveOrder;
    private TextView tvTime, tvDistance;

    public ProviderTrackFragment() {
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        orderDetailActivity = (OrderDetailActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.activity_provider_track, container, false);
        ivRegisterProfileImage = view.findViewById(R.id.ivRegisterProfileImage);
        ivCallProvider = view.findViewById(R.id.ivCallProvider);
        tvProviderName = view.findViewById(R.id.tvProviderName);
        tvOrderEstTime = view.findViewById(R.id.tvOrderEstTime);
        tvAddress = view.findViewById(R.id.tvAddress);
        mapView = view.findViewById(R.id.customEventMapView);
        ivTargetLocation = view.findViewById(R.id.ivTargetLocation);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismiss());
        groupHistory = view.findViewById(R.id.groupHistory);
        groupActiveOrder = view.findViewById(R.id.groupActiveOrder);
        tvTime = view.findViewById(R.id.tvTime);
        tvDistance = view.findViewById(R.id.tvDistance);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mapView.onCreate(savedInstanceState);
        markerList = new ArrayList<>();
        ivCallProvider.setOnClickListener(this);
        mapView.getMapAsync(this);
        ivTargetLocation.setOnClickListener(this);
        initHandler();
        loadData();
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        if (!orderDetailActivity.isShowHistory) {
            startOderScheduled();
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        if (!orderDetailActivity.isShowHistory) {
            stopOrderScheduled();
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        mapView.onSaveInstanceState(outState);
        super.onSaveInstanceState(outState);
    }

    @Override
    public void onPause() {
        mapView.onPause();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        mapView.onDestroy();
        super.onDestroy();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivCallProvider) {
            if (orderDetailActivity.preferenceHelper.getIsEnableTwilioCallMasking()) {
                if (order != null) {
                    TwilioCallHelper.callViaTwilio(orderDetailActivity, ivCallProvider, order.getId(), String.valueOf(Const.Type.PROVIDER));
                }
            } else {
                Utils.openCallChooser(orderDetailActivity, activeOrderResponse.getProvider().getPhone());
            }
        } else if (id == R.id.ivTargetLocation) {
            if (!markerList.isEmpty()) {
                setLocationBounds(false, markerList);
            }
        }
    }

    private void loadData() {
        if (orderDetailActivity.activeOrderResponse != null && !orderDetailActivity.isShowHistory) {
            activeOrderResponse = orderDetailActivity.activeOrderResponse;
            groupHistory.setVisibility(View.GONE);
            groupActiveOrder.setVisibility(View.VISIBLE);
            order = orderDetailActivity.order;
            GlideApp.with(this).load(IMAGE_URL + activeOrderResponse.getProvider().getImageUrl()).placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivRegisterProfileImage);
            tvProviderName.setText(activeOrderResponse.getProvider().getName());

            destinationLatLng = new LatLng(activeOrderResponse.getDestinationAddresses().get(0).getLocation().get(0), activeOrderResponse.getDestinationAddresses().get(0).getLocation().get(1));
            tvAddress.setText(activeOrderResponse.getDestinationAddresses().get(0).getAddress());
            tvOrderEstTime.setText(String.format("%s %s", getResources().getString(R.string.text_est_time), Utils.minuteToHoursMinutesSeconds(order.getTotalTime())));
        } else {
            groupHistory.setVisibility(View.VISIBLE);
            groupActiveOrder.setVisibility(View.GONE);
            GlideApp.with(this).load(IMAGE_URL + orderDetailActivity.historyDetailResponse.getProviderDetail().getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivRegisterProfileImage);
            tvProviderName.setText(String.format("%s %s", orderDetailActivity.historyDetailResponse.getProviderDetail().getFirstName(), orderDetailActivity.historyDetailResponse.getProviderDetail().getLastName()));
            tvTime.setText(Utils.minuteToHoursMinutesSeconds(orderDetailActivity.historyDetailResponse.getOrderPaymentDetail().getTotalTime()));
            String unit = orderDetailActivity.historyDetailResponse.getOrderPaymentDetail().isDistanceUnitMile() ? getResources().getString(R.string.unit_mile) : getResources().getString(R.string.unit_km);
            tvDistance.setText(String.format("%s%s", String.format("%s", orderDetailActivity.parseContent.decimalTwoDigitFormat.format(orderDetailActivity.historyDetailResponse.getOrderPaymentDetail().getTotalDistance())), unit));
            tvAddress.setText(orderDetailActivity.historyDetailResponse.getCartDetail().getDestinationAddresses().get(0).getAddress());
        }
    }

    public void startOderScheduled() {
        if (!isScheduleStart) {
            schedule = Executors.newSingleThreadScheduledExecutor();
            schedule.scheduleWithFixedDelay(() -> {
                Message message = handler.obtainMessage();
                handler.sendMessage(message);
            }, 0, Const.ADS_SCHEDULED_SECONDS, TimeUnit.SECONDS);
            isScheduleStart = true;
        }
    }

    public void stopOrderScheduled() {
        if (isScheduleStart) {
            schedule.shutdown(); // Disable new tasks from being submitted
            // Wait a while for existing tasks to terminate
            try {
                if (!schedule.awaitTermination(60, TimeUnit.SECONDS)) {
                    schedule.shutdownNow(); // Cancel currently executing tasks
                    // Wait a while for tasks to respond to being cancelled
                    schedule.awaitTermination(60, TimeUnit.SECONDS);
                }
            } catch (InterruptedException e) {
                AppLog.handleException(Const.Tag.PROVIDER_TRACK_ACTIVITY, e);
                // (Re-)Cancel if current thread also interrupted
                schedule.shutdownNow();
                // Preserve interrupt ProviderStatus
                Thread.currentThread().interrupt();
            }
            isScheduleStart = false;
        }
    }

    private void initHandler() {
        handler = new Handler(Looper.myLooper()) {
            @Override
            public void handleMessage(Message msg) {
                getProviderLocation();
            }
        };
    }

    private void getProviderLocation() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, activeOrderResponse.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
        map.put(Const.Params.ORDER_ID, order.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProviderLocationResponse> responseCall = apiInterface.getProviderLocation(map);
        responseCall.enqueue(new Callback<ProviderLocationResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProviderLocationResponse> call, @NonNull Response<ProviderLocationResponse> response) {
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (response.body().getProviderLocation() != null && !response.body().getProviderLocation().isEmpty()) {
                            float bearing = (float) response.body().getBearing();
                            LatLng providerLatLng = new LatLng(response.body().getProviderLocation().get(0), response.body().getProviderLocation().get(1));
                            setMarkerOnLocation(providerLatLng, destinationLatLng, response.body().getMapPinImageUrl());
                            updateCamera(bearing, providerLatLng);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProviderLocationResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        if (orderDetailActivity.isShowHistory) {
            BitmapDescriptor bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppColor.getThemeColorDrawable(R.drawable.ic_pin_delivery, orderDetailActivity)));
            destinationLatLng = new LatLng(orderDetailActivity.historyDetailResponse.getCartDetail().getDestinationAddresses().get(0).getLocation().get(0), orderDetailActivity.historyDetailResponse.getCartDetail().getDestinationAddresses().get(0).getLocation().get(1));
            destinationMarker = googleMap.addMarker(new MarkerOptions().position(destinationLatLng).title(getResources().getString(R.string.text_drop_location)).icon(bitmapDescriptor));

            googleMap.moveCamera(CameraUpdateFactory.newLatLngZoom(destinationLatLng, 17f));
        }
    }

    private void setMarkerOnLocation(LatLng providerLatLang, LatLng destLatLng, String pinUrl) {
        BitmapDescriptor bitmapDescriptor;
        boolean isBounce = false;
        if (providerLatLang != null) {
            if (providerMarker == null) {
                providerMarker = googleMap.addMarker(new MarkerOptions().position(providerLatLang).title(getResources().getString(R.string.text_provider_location)));
                providerMarker.setAnchor(0.5f, 0.5f);
                downloadVehiclePin(pinUrl);
                isBounce = true;
            } else {
                animateMarkerToGB(providerMarker, providerLatLang, new LatLngInterpolator.Linear());
            }
            markerList.add(providerLatLang);

            if (destLatLng != null) {
                if (destinationMarker == null) {
                    bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppColor.getThemeColorDrawable(R.drawable.ic_pin_delivery, orderDetailActivity)));
                    destinationMarker = googleMap.addMarker(new MarkerOptions().position(destLatLng).title(getResources().getString(R.string.text_drop_location)).icon(bitmapDescriptor));
                } else {

                    destinationMarker.setPosition(destLatLng);
                }
                markerList.add(destLatLng);
            }
            if (isBounce) {
                try {
                    setLocationBounds(false, markerList);
                } catch (Exception e) {
                    AppLog.handleException(Const.Tag.PROVIDER_TRACK_ACTIVITY, e);
                }
            }
        }
    }

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
            valueAnimator.start();
        }
    }

    private void updateCamera(float bearing, LatLng positionLatLng) {
        if (isCameraIdeal) {
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

    public void downloadVehiclePin(String pinUrl) {
        if (!TextUtils.isEmpty(pinUrl)) {
            GlideApp.with(this).asBitmap().load(IMAGE_URL + pinUrl)
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .placeholder(R.drawable.driver_car)
                    .listener(new RequestListener<Bitmap>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                            AppLog.handleException(getClass().getSimpleName(), e);
                            if (providerMarker != null) {
                                providerMarker.setIcon(BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(orderDetailActivity, R.drawable.driver_car))));
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
                providerMarker.setIcon(BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(orderDetailActivity, R.drawable.driver_car))));
            }
        }
    }
}