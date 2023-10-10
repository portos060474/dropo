package com.dropo.provider.fragments;

import static com.dropo.provider.utils.Const.REQUEST_CHECK_SETTINGS;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ValueAnimator;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.provider.AvailableDeliveryActivity;
import com.dropo.provider.BaseAppCompatActivity;
import com.dropo.provider.HomeActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.interfaces.LatLngInterpolator;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.LocationHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.tasks.OnSuccessListener;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HomeFragment extends BaseFragments implements LocationHelper.OnLocationReceived, OnMapReadyCallback, BaseAppCompatActivity.OrderListener {
    private final String TAG = this.getClass().getSimpleName();

    public TextView tvAvailableDelivers, tvOfflineView;
    public LocationHelper locationHelper;
    private Location currentLocation;
    private LinearLayout llAvailableDelivery, llNotApproved;
    private MapView mapView;
    private GoogleMap googleMap;
    private Marker myLocationMarker;
    private LatLng currentLatLng;
    private ImageView ivTargetLocation;
    private SwitchCompat switchAcceptJob, switchGoOffline;
    private CustomFontTextView tvOnlineStatus;
    private boolean isCameraIdeal, isShowDisclosure = false;
    private CustomDialogAlert locationDisclosureDialog;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        homeActivity.setToolbarRightIcon(-1, null);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_home, container, false);
        mapView = view.findViewById(R.id.homeMapView);
        ivTargetLocation = view.findViewById(R.id.ivTargetLocation);
        tvAvailableDelivers = view.findViewById(R.id.tvAvailableDelivers);
        switchAcceptJob = view.findViewById(R.id.switchAcceptJob);
        switchGoOffline = view.findViewById(R.id.switchGoOffline);
        tvOnlineStatus = view.findViewById(R.id.tvOnlineStatus);
        llAvailableDelivery = view.findViewById(R.id.llAvailableDelivery);
        tvOfflineView = view.findViewById(R.id.tvOfflineView);
        llNotApproved = view.findViewById(R.id.llNotApproved);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initLocationHelper();
        homeActivity.setTitleOnToolBar(getString(R.string.app_name));
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);
        switchGoOffline.setOnClickListener(this);
        switchAcceptJob.setOnClickListener(this);
        ivTargetLocation.setOnClickListener(this);
        llAvailableDelivery.setOnClickListener(this);
        updateUiWhenApprovedByAdmin();
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
        moveCameraFirstMyLocation();
        startServiceIfProviderOnline();
    }

    private void setUpMap() {
        this.googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        this.googleMap.getUiSettings().setMapToolbarEnabled(false);
        this.googleMap.getUiSettings().setCompassEnabled(false);
        this.googleMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        mapView.onSaveInstanceState(outState);
        super.onSaveInstanceState(outState);
    }

    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
        homeActivity.setOrderListener(this);
        getRequestCount();
    }

    @Override
    public void onPause() {
        mapView.onPause();
        homeActivity.setOrderListener(null);
        super.onPause();
    }

    @Override
    public void onStart() {
        super.onStart();
        checkPermission();
    }

    @Override
    public void onStop() {
        super.onStop();
        locationHelper.onStop();
    }

    @Override
    public void onDestroy() {
        mapView.onDestroy();
        super.onDestroy();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivTargetLocation) {
            locationHelper.setLocationSettingRequest(homeActivity, REQUEST_CHECK_SETTINGS, (OnSuccessListener) o -> moveCameraFirstMyLocation(), this::moveCameraFirstMyLocation);
        } else if (id == R.id.switchGoOffline) {
            setProviderOnlineStatus();
        } else if (id == R.id.llAvailableDelivery) {
            goToAvailableDelivery();
        } else if (id == R.id.switchAcceptJob) {
            setProviderAcceptJobStatus();
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        if (googleMap != null && googleMap.getCameraPosition().target.latitude == 0 && googleMap.getCameraPosition().target.longitude == 0) {
            moveCameraFirstMyLocation();
        }
        currentLocation = location;
        currentLatLng = new LatLng(location.getLatitude(), location.getLongitude());
        setMarkerOnLocation(currentLatLng);
    }

    private void initLocationHelper() {
        locationHelper = new LocationHelper(homeActivity);
        locationHelper.setLocationReceivedLister(this);
    }

    public void checkPermission() {
        if (ContextCompat.checkSelfPermission(homeActivity, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(homeActivity, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            if (locationDisclosureDialog == null || !locationDisclosureDialog.isShowing() && !isShowDisclosure) {
                isShowDisclosure = true;
                locationDisclosureDialog = new CustomDialogAlert(requireContext(), getString(R.string.title_alert_location_disclosure), getString(R.string.msg_alert_location_disclosure), getString(R.string.btn_allow_location)) {
                    @Override
                    public void onClickLeftButton() {
                        homeActivity.finishAffinity();
                    }

                    @Override
                    public void onClickRightButton() {
                        closePermissionDialog();
                        ActivityCompat.requestPermissions(homeActivity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
                    }
                };
                locationDisclosureDialog.show();
            } else {
                ActivityCompat.requestPermissions(homeActivity, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
            }
        } else {
            locationHelper.onStart();
        }
    }

    public void moveCameraFirstMyLocation() {
        locationHelper.getLastLocation(location -> {
            currentLocation = location;
            if (currentLocation != null) {
                currentLatLng = new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude());
                CameraPosition cameraPosition = new CameraPosition.Builder().target(currentLatLng).zoom(17).build();
                googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                isCameraIdeal = false;
                setMarkerOnLocation(currentLatLng);
                isCameraIdeal = true;
            }
        });
    }

    private void updateCamera(float bearing, LatLng positionLatLng) {
        if (isCameraIdeal) {
            isCameraIdeal = false;
            CameraPosition oldPos = googleMap.getCameraPosition();

            CameraPosition pos = CameraPosition.builder(oldPos).bearing(bearing).target(positionLatLng).zoom(17).build();
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

    private void setMarkerOnLocation(LatLng latLng) {
        if (myLocationMarker == null) {
            myLocationMarker = googleMap.addMarker(new MarkerOptions().position(latLng).title(homeActivity.getResources().getString(R.string.text_my_location)));
            myLocationMarker.setAnchor(0.5f, 0.5f);
            homeActivity.parseContent.downloadVehiclePin(homeActivity, myLocationMarker);
        } else {
            animateMarkerToGB(myLocationMarker, latLng, new LatLngInterpolator.Linear());
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
                    float bearing = getBearing(startPosition, new LatLng(finalPosition.latitude, finalPosition.longitude));
                    bearing = Float.isNaN(bearing) ? 0 : bearing;
                    if (getDistanceBetweenTwoLatLng(startPosition, finalPosition) > LocationHelper.DISPLACEMENT) {
                        updateCamera(bearing, newPosition);
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
        Location endlocation = new Location("end");
        endlocation.setLatitude(endLatLang.latitude);
        endlocation.setLongitude(endLatLang.longitude);
        startLocation.setLatitude(startLatLng.latitude);
        startLocation.setLongitude(startLatLng.longitude);
        return startLocation.distanceTo(endlocation);
    }

    private void changeProviderOnlineStatus(boolean isOnline, boolean isActiveJob) {
        Utils.showCustomProgressDialog(homeActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, homeActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, homeActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.IS_ONLINE, isOnline);
        map.put(Const.Params.IS_ACTIVE_FOR_JOB, isActiveJob);


        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.changeProviderOnlineStatus(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (homeActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        homeActivity.preferenceHelper.putIsProviderOnline(response.body().isOnline());
                        homeActivity.preferenceHelper.putIsProviderActiveForJob(response.body().isActiveForJob());
                        updateUiOnlineOrActiveJobStatus(homeActivity.preferenceHelper.getIsProviderOnline());
                        startServiceIfProviderOnline();
                    } else {
                        updateUiOnlineOrActiveJobStatus(homeActivity.preferenceHelper.getIsProviderOnline());
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), homeActivity);
                    }
                    Utils.hideCustomProgressDialog();
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
                updateUiOnlineOrActiveJobStatus(homeActivity.preferenceHelper.getIsProviderOnline());
            }
        });
    }

    private void setProviderOnlineStatus() {
        changeProviderOnlineStatus(!homeActivity.preferenceHelper.getIsProviderOnline(), false);
    }

    private void setProviderAcceptJobStatus() {
        changeProviderOnlineStatus(homeActivity.preferenceHelper.getIsProviderOnline(), !homeActivity.preferenceHelper.getIsProviderActiveForJob());
    }

    private void goToAvailableDelivery() {
        Intent intent = new Intent(homeActivity, AvailableDeliveryActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void startServiceIfProviderOnline() {
        if (homeActivity.preferenceHelper.getIsProviderOnline()) {
            homeActivity.checkDisplayOverAppPermission();
            homeActivity.startUpdateLocationAndOrderService();
        } else {
            homeActivity.stopUpdateLocationAndOrderService();
        }
    }

    private void updateUiOnlineOrActiveJobStatus(boolean isOnline) {
        if (isOnline) {
            switchGoOffline.setEnabled(true);
            switchGoOffline.setChecked(true);
            tvOnlineStatus.setText(homeActivity.getResources().getString(R.string.text_go_offline));
            switchAcceptJob.setEnabled(true);
            tvOfflineView.setVisibility(View.GONE);
        } else {
            switchGoOffline.setEnabled(true);
            switchGoOffline.setChecked(false);
            tvOnlineStatus.setText(homeActivity.getResources().getString(R.string.text_go_online));
            switchAcceptJob.setEnabled(false);
            tvOfflineView.setVisibility(View.VISIBLE);
        }
        switchAcceptJob.setChecked(homeActivity.preferenceHelper.getIsProviderActiveForJob());
    }

    public void updateUiWhenApprovedByAdmin() {
        if (homeActivity.preferenceHelper.getIsApproved()) {
            llNotApproved.setVisibility(View.GONE);
            updateUiOnlineOrActiveJobStatus(homeActivity.preferenceHelper.getIsProviderOnline());
            llAvailableDelivery.setClickable(true);
        } else {
            llNotApproved.setVisibility(View.VISIBLE);
            tvOfflineView.setVisibility(View.GONE);
            switchGoOffline.setEnabled(false);
            switchAcceptJob.setEnabled(false);
            llAvailableDelivery.setClickable(false);
            homeActivity.preferenceHelper.putIsProviderOnline(false);
        }
    }

    @Override
    public void onOrderReceive() {
        homeActivity.getProviderDetail();
        getRequestCount();
    }

    private void getRequestCount() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, homeActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, homeActivity.preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.getRequestCount(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (homeActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        homeActivity.currentOrder.setAvailableOrders(response.body().getRequestCount());
                        tvAvailableDelivers.setText(String.valueOf(homeActivity.currentOrder.getAvailableOrders()));
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), homeActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(HomeActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void closePermissionDialog() {
        if (locationDisclosureDialog != null) {
            locationDisclosureDialog.dismiss();
        }
    }
}