package com.dropo;

import static com.dropo.utils.Const.REQUEST_CHECK_SETTINGS;
import static com.dropo.utils.Const.REQUEST_FAVOURITE_ADDRESS;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.LinearInterpolator;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.adapter.PlaceAutocompleteAdapter;
import com.dropo.animation.ResizeAnimation;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomEventMapView;
import com.dropo.component.CustomFontAutoCompleteView;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Address;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.responsemodels.DeliveryStoreResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.LocationHelper;
import com.dropo.utils.ScheduleHelper;
import com.dropo.utils.Utils;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.libraries.places.api.model.RectangularBounds;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.Calendar;
import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DeliveryLocationActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived, OnMapReadyCallback {
    private PlaceAutocompleteAdapter autocompleteAdapter;
    private LocationHelper locationHelper;
    private CustomFontAutoCompleteView acDeliveryAddress;
    private LinearLayout llScheduleDate;
    private ImageView ivTargetLocation, ivFullScreen;
    private CustomFontTextView cbAsps, cbScheduleOrder;
    private LinearLayout tvNoDeliveryFound;
    private CustomFontEditTextView tvScheduleDate, tvScheduleTime;
    private GoogleMap googleMap;
    private LatLng deliveryLatLng;
    private CustomFontButton btnDone;
    private CustomEventMapView mapView;
    private FrameLayout mapFrameLayout;
    private ScrollView llDeliveryOrder;
    private CustomDialogAlert customDialogEnable;
    private CustomDialogAlert exitDialog;
    private boolean isMapTouched = true;
    private CustomFontTextViewTitle tvSaveFavAddress;
    private Address saveAddress;
    private CustomFontEditTextView etFlatNo;
    private CustomFontEditTextView etStreetNo;
    private CustomFontEditTextView etLandmark;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_delivery_location);
        initToolBar();
        setTitleOnToolBar(getString(R.string.text_delivery_location));
        if (isCurrentLogin()) {
            setToolbarRightIcon2(R.drawable.fav_address, this);
        }
        initViewById();
        setViewListener();
        mapView.onCreate(savedInstanceState);
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        initPlaceAutoComplete();
        updateUiForOrderSelect(currentBooking.isFutureOrder());
        checkLocationPermission(true, null);

        tvSaveFavAddress.setVisibility(isCurrentLogin() ? View.VISIBLE : View.GONE);
        if (!currentBooking.getDestinationAddresses().isEmpty()) {
            etFlatNo.setText(currentBooking.getDestinationAddresses().get(0).getFlatNo());
            etStreetNo.setText(currentBooking.getDestinationAddresses().get(0).getStreet());
            etLandmark.setText(currentBooking.getDestinationAddresses().get(0).getLandmark());
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
        locationHelper.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
        locationHelper.onStop();
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

    private void initPlaceAutoComplete() {
        if (autocompleteAdapter == null) {
            acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
            autocompleteAdapter = new PlaceAutocompleteAdapter(this);
            acDeliveryAddress.setAdapter(autocompleteAdapter);
            acDeliveryAddress.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {
                    getGeocodeDataFromAddress(acDeliveryAddress.getText().toString());
                }
            });
        }


    }

    private void setPlaceFilter(String countryCode) {
        if (autocompleteAdapter != null && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            autocompleteAdapter.setPlaceFilter(countryCode);
            locationHelper.getLastLocation(location -> {
                if (location != null) {
                    LatLng latLng = new LatLng(location.getLatitude(), location.getLongitude());
                    RectangularBounds latLngBounds = RectangularBounds.newInstance(latLng, latLng);
                    autocompleteAdapter.setBounds(latLngBounds);
                }
            });
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {

        mapView = findViewById(R.id.mapView);
        tvSaveFavAddress = findViewById(R.id.tvSaveFavAddress);
        acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
        llScheduleDate = findViewById(R.id.llScheduleDate);
        cbScheduleOrder = findViewById(R.id.cbScheduleOrder);
        cbAsps = findViewById(R.id.cbAsps);
        cbScheduleOrder.setTag(false);
        cbAsps.setTag(true);
        tvScheduleDate = findViewById(R.id.tvScheduleDate);
        tvScheduleTime = findViewById(R.id.tvScheduleTime);
        ivTargetLocation = findViewById(R.id.ivTargetLocation);
        mapFrameLayout = findViewById(R.id.mapFrameLayout);
        llDeliveryOrder = findViewById(R.id.llDeliveryOrder);
        ivFullScreen = findViewById(R.id.ivFullScreen);
        btnDone = findViewById(R.id.btnDone);
        tvNoDeliveryFound = findViewById(R.id.tvNoDeliveryFound);
        etFlatNo = findViewById(R.id.etFlatNo);
        etStreetNo = findViewById(R.id.etStreetNo);
        etLandmark = findViewById(R.id.etLandmark);


    }

    @Override
    protected void setViewListener() {
        mapView.getMapAsync(this);
        cbAsps.setOnClickListener(this);
        cbScheduleOrder.setOnClickListener(this);
        tvScheduleDate.setOnClickListener(this);
        tvScheduleTime.setOnClickListener(this);
        ivTargetLocation.setOnClickListener(this);
        ivFullScreen.setOnClickListener(this);
        btnDone.setOnClickListener(this);
        tvSaveFavAddress.setOnClickListener(this);

    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    private void updateUiForOrderSelect(boolean isUpdate) {
        if (isUpdate) {
            cbScheduleOrder.setTag(true);
            cbScheduleOrder.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeColorDrawable(R.drawable.ic_schedule, this), null, null, null);
            cbScheduleOrder.setTextColor(AppColor.COLOR_THEME);
            llScheduleDate.setVisibility(View.VISIBLE);
            cbAsps.setTag(false);
            cbAsps.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeModeDrawable(R.drawable.ic_asps, this), null, null, null);
            cbAsps.setTextColor(AppColor.getThemeTextColor(this));
            if (!TextUtils.isEmpty(currentBooking.getSchedule().getScheduleDate())) {
                tvScheduleDate.setText(currentBooking.getSchedule().getScheduleDate());
            } else {
                tvScheduleDate.setText(getResources().getString(R.string.text_schedule_a_date));
            }
            if (!TextUtils.isEmpty(currentBooking.getSchedule().getScheduleTime())) {
                tvScheduleTime.setText(currentBooking.getSchedule().getScheduleTime());
            } else {
                tvScheduleTime.setText(getResources().getString(R.string.text_set_time));
            }

        } else {
            cbAsps.setTextColor(AppColor.COLOR_THEME);
            cbAsps.setTag(true);
            cbAsps.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeColorDrawable(R.drawable.ic_asps, this), null, null, null);
            cbScheduleOrder.setTag(false);
            cbScheduleOrder.setTextColor(AppColor.getThemeTextColor(this));
            cbScheduleOrder.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeModeDrawable(R.drawable.ic_schedule, this), null, null, null);
            llScheduleDate.setVisibility(View.GONE);
            currentBooking.setSchedule(null);
        }

    }

    @Override
    public void onLocationChanged(Location location) {
        if (CurrentBooking.getInstance().getCurrentLatLng() != null && googleMap != null && googleMap.getCameraPosition().target.latitude == 0.0 && googleMap.getCameraPosition().target.longitude == 0.0) {
            moveCameraFirstMyLocation(false, CurrentBooking.getInstance().getCurrentLatLng());
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.cbAsps:
                updateUiForOrderSelect(false);
                break;
            case R.id.tvSaveFavAddress:
                if (saveAddress == null || acDeliveryAddress.getText().toString().isEmpty()) {
                    Utils.showToast(getString(R.string.msg_valid_address), this);
                } else {
                    saveAddress.setLandmark(etLandmark.getText().toString());
                    saveAddress.setFlat_no(etFlatNo.getText().toString());
                    saveAddress.setStreet(etStreetNo.getText().toString());
                    showAddFavouriteAddressTitle();
                }
                break;
            case R.id.cbScheduleOrder:
                if (CurrentBooking.getInstance().getTimeZone() != null) {
                    ScheduleHelper scheduleHelper = new ScheduleHelper(CurrentBooking.getInstance().getTimeZone());
                    currentBooking.setSchedule(scheduleHelper);
                    updateUiForOrderSelect(currentBooking.isFutureOrder());
                } else {
                    cbScheduleOrder.setTag(false);
                    Toast.makeText(this, "Please set your location first.", Toast.LENGTH_SHORT).show();
                }
                break;
            case R.id.ivTargetLocation:
                checkLocationPermission(true, null);
                break;
            case R.id.ivFullScreen:
                expandMap();
                break;
            case R.id.btnDone:
                if (currentBooking.getDestinationAddresses().isEmpty()) {
                    Addresses addresses = new Addresses();
                    currentBooking.setDestinationAddresses(addresses);
                }
                currentBooking.getDestinationAddresses().get(0).setFlatNo(etFlatNo.getText().toString());
                currentBooking.getDestinationAddresses().get(0).setStreet(etStreetNo.getText().toString());
                currentBooking.getDestinationAddresses().get(0).setLandmark(etLandmark.getText().toString());

                if (!CurrentBooking.getInstance().getDeliveryStoreList().isEmpty()) {
                    if (llScheduleDate.getVisibility() == View.VISIBLE) {
                        if (currentBooking.isFutureOrder() && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleDate()) && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleTime())) {
                            if (isTaskRoot()) {
                                goToHomeActivity();
                            } else {
                                setResult(RESULT_OK);
                                finishAfterTransition();
                            }
                        } else {
                            if (TextUtils.isEmpty(tvScheduleDate.getText().toString().trim())) {
                                Utils.showToast(getString(R.string.msg_plz_select_schedule_date), this);
                            } else {
                                Utils.showToast(getString(R.string.msg_plz_select_schedule_time), this);
                            }
                        }
                    } else {
                        if (isTaskRoot()) {
                            goToHomeActivity();
                        } else {
                            setResult(RESULT_OK);
                            finishAfterTransition();
                        }
                    }
                } else {
                    Utils.showToast(getResources().getString(R.string.msg_plz_enter_valid_place_address), this);
                }

                break;
            case R.id.tvScheduleDate:
                openDatePicker();
                break;
            case R.id.tvScheduleTime:
                openTimePicker();
                break;
            case R.id.ivToolbarRightIcon2:
                Intent intent = new Intent(this, FavouriteAddressActivity.class);
                intent.putExtra(Const.Params.ADDRESS, true);
                startActivityForResult(intent, Const.REQUEST_FAVOURITE_ADDRESS);
                overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                break;
            default:
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_CHECK_SETTINGS:
                switch (resultCode) {
                    case Activity.RESULT_OK:
                        locationHelper.onStop();
                        new Handler().postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                locationHelper.onStart();
                            }
                        }, 1000);
                        break;
                    default:
                        break;
                }
                break;
            case REQUEST_FAVOURITE_ADDRESS:
                if (resultCode == Activity.RESULT_OK) {
                    if (data.getExtras() != null) {
                        Address address = data.getExtras().getParcelable(Const.Params.ADDRESS);
                        etStreetNo.setText(address.getStreet());
                        etLandmark.setText(address.getLandmark());
                        etFlatNo.setText(address.getFlat_no());
                        moveCameraFirstMyLocation(false, new LatLng(Double.parseDouble(address.getLatitude()), Double.parseDouble(address.getLongitude())));
                    }
                }
                break;
        }
    }

    /**
     * This method is used to setUpMap option which help to load map as per option
     */
    private void setUpMap() {

        this.googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        this.googleMap.getUiSettings().setMapToolbarEnabled(false);
        this.googleMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
        this.googleMap.setOnMarkerClickListener(new GoogleMap.OnMarkerClickListener() {
            final boolean doNotMoveCameraToCenterMarker = true;

            public boolean onMarkerClick(Marker marker) {
                return doNotMoveCameraToCenterMarker;
            }
        });
        this.googleMap.setOnCameraIdleListener(new GoogleMap.OnCameraIdleListener() {
            @Override
            public void onCameraIdle() {
                if (isMapTouched) {
                    deliveryLatLng = googleMap.getCameraPosition().target;
                    if (deliveryLatLng.latitude != 0.0 && deliveryLatLng.longitude != 0.0) {
                        getGeocodeDataFromLocation(deliveryLatLng);
                    }
                }
                isMapTouched = true;
            }
        });
    }

    private void showAddFavouriteAddressTitle() {
        BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_add_address_title);

        CustomFontEditTextView etAddressTitle = dialog.findViewById(R.id.etAddressTitle);

        dialog.findViewById(R.id.btnClose).setOnClickListener(v -> dialog.dismiss());
        dialog.findViewById(R.id.btnAdd).setOnClickListener(v -> {
            String msg = null;
            etAddressTitle.setError(null);
            if (TextUtils.isEmpty(etAddressTitle.getText().toString().trim())) {
                msg = getString(R.string.msg_please_enter_title);
                etAddressTitle.setError(msg);
                etAddressTitle.requestFocus();
            } else {
                saveAddress.setAddressName(etAddressTitle.getText().toString());
                setSaveFavAddress(saveAddress);
                dialog.dismiss();
            }
        });

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        BottomSheetBehavior<?> behavior = dialog.getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        dialog.setCancelable(false);
        dialog.show();
    }

    private void setSaveFavAddress(Address address) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.ID, preferenceHelper.getUserId());
        map.put(Const.Params.LATITUDE, address.getLatitude());
        map.put(Const.Params.LONGITUDE, address.getLongitude());
        map.put(Const.Params.ADDRESS, address.getAddress());
        map.put(Const.Params.ADDRESS_NAME, address.getAddressName());
        map.put(Const.Params.LANDMARK, address.getLandmark());
        map.put(Const.Params.STREET, address.getStreet());
        map.put(Const.Params.FLAT_NO, address.getFlat_no());
        map.put(Const.Params.COUNTRY, address.getCountry());
        map.put(Const.Params.COUNTRY_CODE, address.getCountryCode());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.saveFavAddress(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(Call<IsSuccessResponse> call, Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showToast(getString(R.string.msg_favourite_address_added_successfully), DeliveryLocationActivity.this);
                    } else {
                        Utils.showToast(getString(R.string.msg_favourite_address_failed), DeliveryLocationActivity.this);
                    }
                }
                Utils.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(Call<IsSuccessResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.CURRENT_ORDER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
    }

    /***
     * this method is used to move camera on map at current position and a isCameraMove is
     * used to decide when is move or not
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng == null) {
            locationHelper.setLocationSettingRequest(DeliveryLocationActivity.this, REQUEST_CHECK_SETTINGS, o -> {
                locationHelper.getLastLocation(location -> {
                    if (location != null) {
                        LatLng latLng1 = new LatLng(location.getLatitude(), location.getLongitude());
                        CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng1).zoom(17).build();
                        if (isAnimate) {
                            googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                        } else {
                            googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                        }
                    }
                });
            }, () -> {

            });
        } else {
            CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng).zoom(17).build();
            if (isAnimate) {
                googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            } else {
                googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            }
        }

    }

    private void setDeliveryAddress(String deliveryAddress) {
        acDeliveryAddress.setFocusable(false);
        acDeliveryAddress.setFocusableInTouchMode(false);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            acDeliveryAddress.setText(deliveryAddress, false);
        } else {
            acDeliveryAddress.setText(deliveryAddress);
        }
        acDeliveryAddress.setFocusable(true);
        acDeliveryAddress.setFocusableInTouchMode(true);
    }

    private void checkLocationPermission(boolean isAnimateLocation, LatLng latLng) {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
        } else {
            moveCameraFirstMyLocation(isAnimateLocation, latLng);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            switch (requestCode) {
                case Const.PERMISSION_FOR_LOCATION:
                    goWithLocationPermission(grantResults);
                    break;
                default:
                    //do with default
                    break;
            }
        }
    }

    private void goWithLocationPermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            //Do the stuff that requires permission...
            moveCameraFirstMyLocation(true, null);
        } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) && ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_FINE_LOCATION)) {
                openPermissionDialog();
            } else {
                closePermissionDialog();
            }
        }
    }

    private void openPermissionDialog() {
        if (customDialogEnable != null && customDialogEnable.isShowing()) {
            return;
        }
        customDialogEnable = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_permission_location), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closePermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                ActivityCompat.requestPermissions(DeliveryLocationActivity.this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
                closePermissionDialog();
            }

        };
        customDialogEnable.show();
    }

    private void closePermissionDialog() {
        if (customDialogEnable != null && customDialogEnable.isShowing()) {
            customDialogEnable.dismiss();
            customDialogEnable = null;

        }
    }

    /**
     * this method called webservice for get location from address which is provided by Google
     *
     * @param address address on map
     */
    private void getGeocodeDataFromAddress(String address) {

        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put(Const.Google.ADDRESS, address);
        hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null) {
                    LatLng latLng = new LatLng(Double.valueOf(map.get(Const.Google.LAT)), Double.valueOf(map.get(Const.Google.LNG)));
                    if (latLng != null) {
                        isMapTouched = false;
                        CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng).zoom(17).build();
                        googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                        getDeliveryStoreInCity(map.get(Const.Google.COUNTRY), map.get(Const.Google.COUNTRY_CODE), map.get(Const.Google.LOCALITY), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1), latLng, acDeliveryAddress.getText().toString(), map.get(Const.Params.CITY_CODE));

                        if (saveAddress == null) {
                            saveAddress = new Address();
                        }
                        saveAddress.setCountry(map.get(Const.Google.COUNTRY));
                        saveAddress.setCityCode(map.get(Const.Google.COUNTRY_CODE));
                        saveAddress.setCity(map.get(Const.Google.LOCALITY));
                        saveAddress.setSubAdminArea(map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2));
                        saveAddress.setAdminArea(map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1));
                        saveAddress.setLatitude(map.get(Const.Google.LAT));
                        saveAddress.setLongitude(map.get(Const.Google.LNG));
                        saveAddress.setAddress(map.get(Const.Google.FORMATTED_ADDRESS));
                        saveAddress.setCityCode(map.get(Const.Params.CITY_CODE));
                    }
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.DELIVERY_LOCATION_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });


    }

    /**
     * this method called webservice for get Data from LatLng which is provided by Google
     *
     * @param latLng on map
     */
    private void getGeocodeDataFromLocation(final LatLng latLng) {
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put(Const.Google.LAT_LNG, latLng.latitude + "," + latLng.longitude);
        hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null && !map.isEmpty()) {
                    LatLng latLng = new LatLng(Double.valueOf(map.get(Const.Google.LAT)), Double.valueOf(map.get(Const.Google.LNG)));
                    setDeliveryAddress(map.get(Const.Google.FORMATTED_ADDRESS));
                    getDeliveryStoreInCity(map.get(Const.Google.COUNTRY), map.get(Const.Google.COUNTRY_CODE), map.get(Const.Google.LOCALITY), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1), latLng, map.get(Const.Google.FORMATTED_ADDRESS), map.get(Const.Params.CITY_CODE));
                    setPlaceFilter(map.get(Const.Google.COUNTRY_CODE));

                    if (saveAddress == null) {
                        saveAddress = new Address();
                    }
                    saveAddress.setCountry(map.get(Const.Google.COUNTRY));
                    saveAddress.setCityCode(map.get(Const.Google.COUNTRY_CODE));
                    saveAddress.setCity(map.get(Const.Google.LOCALITY));
                    saveAddress.setSubAdminArea(map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2));
                    saveAddress.setAdminArea(map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1));
                    saveAddress.setLatitude(map.get(Const.Google.LAT));
                    saveAddress.setLongitude(map.get(Const.Google.LNG));
                    saveAddress.setAddress(map.get(Const.Google.FORMATTED_ADDRESS));
                    saveAddress.setCityCode(map.get(Const.Params.CITY_CODE));
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.DELIVERY_LOCATION_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });


    }

    @Override
    public void onBackPressed() {
        if ((ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED)
                || CurrentBooking.getInstance().getDeliveryStoreList().isEmpty()) {
            openExitDialog();
        } else {
            if (currentBooking.getSchedule() != null && (TextUtils.isEmpty(currentBooking.getSchedule().getScheduleDate()) || TextUtils.isEmpty(currentBooking.getSchedule().getScheduleTime()))) {
                currentBooking.setSchedule(null);
                if (currentBooking.isTableBooking()) {
                    currentBooking.setTableBookingType(0);
                    currentBooking.setBookingFee(0);
                    currentBooking.setNumberOfPerson(0);
                    currentBooking.setTableNumber(0);
                }
            }
            if (isTaskRoot()) {
                goToHomeActivity();
            } else {
                super.onBackPressed();
            }
        }

    }

    protected void openExitDialog() {
        if (exitDialog != null && exitDialog.isShowing()) {
            return;
        }
        exitDialog = new CustomDialogAlert(this, this.getResources().getString(R.string.text_exit), this.getResources().getString(R.string.msg_are_you_sure), this.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();

            }

            @Override
            public void onClickRightButton() {
                dismiss();
                CurrentBooking.getInstance().setBookCityId("");
                finishAffinity();
            }
        };
        exitDialog.show();
    }

    /**
     * this method expand and collapse  map view from particular size
     */
    private void expandMap() {
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int[] loc = new int[2];
        int[] loc2 = new int[2];
        btnDone.getLocationOnScreen(loc);
        mapView.getLocationOnScreen(loc2);
        int viewDistance = loc[1] - loc2[1];
        ResizeAnimation resizeAnimation;
        if (mapFrameLayout.getLayoutParams().height == getResources().getDimensionPixelSize(R.dimen.dimen_map_size_small)) {
            resizeAnimation = new ResizeAnimation(mapFrameLayout, viewDistance, getResources().getDimensionPixelSize(R.dimen.dimen_map_size_small));
            resizeAnimation.setInterpolator(new LinearInterpolator());
            resizeAnimation.setDuration(300);
        } else {
            resizeAnimation = new ResizeAnimation(mapFrameLayout, getResources().getDimensionPixelSize(R.dimen.dimen_map_size_small), viewDistance);
            resizeAnimation.setInterpolator(new LinearInterpolator());
            resizeAnimation.setDuration(300);
        }
        mapFrameLayout.startAnimation(resizeAnimation);
    }

    /**
     * this method used to called webservice for get Delivery type according to param
     *
     * @param country      country name in string
     * @param countryCode  country code (91) in string
     * @param city         city name in string
     * @param subAdminArea subAdminArea in string
     * @param adminArea    adminArea in string
     * @param cityLatLng   location of city
     */
    private void getDeliveryStoreInCity(String country, String countryCode, String city, String subAdminArea, String adminArea, final LatLng cityLatLng, final String address, String cityCode) {
        final CurrentBooking currentBooking = CurrentBooking.getInstance();
        currentBooking.setCurrentAddress(address);
        currentBooking.setCurrentLatLng(cityLatLng);
        preferenceHelper.putPreviousSaveLatitude(String.valueOf(cityLatLng.latitude));
        preferenceHelper.putPreviousSaveLongitude(String.valueOf(cityLatLng.longitude));

        if (!TextUtils.equals(currentBooking.getCurrentCity(), city) || TextUtils.isEmpty(currentBooking.getBookCityId())) {
            currentBooking.setCurrentCity(city);
            Utils.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
            map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
            map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
            map.put(Const.Params.COUNTRY, country);
            map.put(Const.Params.COUNTRY_CODE_2, countryCode);
            map.put(Const.Params.COUNTRY_CODE, countryCode);
            map.put(Const.Params.LATITUDE, cityLatLng.latitude);
            map.put(Const.Params.LONGITUDE, cityLatLng.longitude);
            map.put(Const.Params.CITY_CODE, cityCode);
            int count = 0;
            if (TextUtils.isEmpty(city)) {
                map.put(Const.Params.CITY1, "");
            } else {
                map.put(Const.Params.CITY1, city);
                count++;
            }
            if (TextUtils.isEmpty(subAdminArea)) {
                map.put(Const.Params.CITY2, "");
            } else {
                map.put(Const.Params.CITY2, subAdminArea);
                count++;
            }
            if (TextUtils.isEmpty(adminArea)) {
                map.put(Const.Params.CITY3, "");
            } else {
                map.put(Const.Params.CITY3, adminArea);
                count++;
            }
            if (count == 0) {
                Utils.showToast(getResources().getString(R.string.msg_not_get_proper_address), this);
            }
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<DeliveryStoreResponse> responseCall = apiInterface.getDeliveryStoreList(map);
            responseCall.enqueue(new Callback<DeliveryStoreResponse>() {
                @Override
                public void onResponse(Call<DeliveryStoreResponse> call, Response<DeliveryStoreResponse> response) {
                    if (parseContent.parseDeliveryStore(response)) {
                        llDeliveryOrder.setVisibility(View.VISIBLE);
                        tvNoDeliveryFound.setVisibility(View.GONE);
                        btnDone.setVisibility(View.VISIBLE);
                        mapFrameLayout.setVisibility(View.VISIBLE);
                    } else {
                        llDeliveryOrder.setVisibility(View.GONE);
                        tvNoDeliveryFound.setVisibility(View.VISIBLE);
                        btnDone.setVisibility(View.GONE);
                        mapFrameLayout.setVisibility(View.GONE);
                    }
                }

                @Override
                public void onFailure(Call<DeliveryStoreResponse> call, Throwable t) {
                    AppLog.handleThrowable(Const.Tag.DELIVERY_LOCATION_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        } else {
            Utils.hideCustomProgressDialog();
        }
    }

    private void openDatePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openDatePicker(this, new ScheduleHelper.DateListener() {
                @Override
                public void onDateSet(Calendar calendar) {
                    tvScheduleDate.setText(currentBooking.getSchedule().getScheduleDate());
                }
            }, 0, false);
        }


    }

    private void openTimePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openTimePicker(this, new ScheduleHelper.TimeListener() {
                @Override
                public void onTimeSet(Calendar calendar) {
                    tvScheduleTime.setText(currentBooking.getSchedule().getScheduleTime());
                }
            }, 0);
        }
    }
}
