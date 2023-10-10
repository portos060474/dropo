package com.dropo.store;

import static com.dropo.store.utils.Constant.REQUEST_CHECK_SETTINGS;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.store.adapter.PlaceAutocompleteAdapter;
import com.dropo.store.component.CustomFontAutoCompleteView;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.LocationHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomEventMapView;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.CameraPosition;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.libraries.places.api.model.RectangularBounds;

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CheckoutDeliveryLocationActivity extends BaseActivity implements LocationHelper.OnLocationReceived, OnMapReadyCallback {

    private PlaceAutocompleteAdapter autocompleteAdapter;
    private LocationHelper locationHelper;
    private CustomFontAutoCompleteView acDeliveryAddress;
    private ImageView ivTargetLocation, ivClearText;
    private GoogleMap googleMap;
    private LatLng deliveryLatLng;
    private CustomButton btnDone;
    private CustomEventMapView mapView;
    private String deliveryAddress;
    private boolean isMapTouched = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout_delivery_location);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_delivery_location));
        mapView = findViewById(R.id.mapView);
        acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
        ivTargetLocation = findViewById(R.id.ivTargetLocation);
        ivClearText = findViewById(R.id.ivClearDeliveryAddressTextMap);
        ivClearText.setVisibility(View.GONE);
        btnDone = findViewById(R.id.btnDone);
        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);
        ivTargetLocation.setOnClickListener(this);
        ivClearText.setOnClickListener(this);
        btnDone.setOnClickListener(this);
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        initPlaceAutoComplete();
        if (TextUtils.isEmpty(CurrentBooking.getInstance().getDeliveryAddress())) {
            acDeliveryAddress.setText(CurrentBooking.getInstance().getDeliveryAddress(), false);
        }
        acDeliveryAddress.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 0) {
                    ivClearText.setVisibility(View.VISIBLE);
                } else {
                    ivClearText.setVisibility(View.GONE);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, R.drawable.filter_store);
        setToolbarSaveIcon(false);
        return true;
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

    @Override
    public void onLocationChanged(Location location) {
        if (CurrentBooking.getInstance().getDeliveryLatLng() != null) {
            CameraPosition cameraPosition = new CameraPosition.Builder().target(CurrentBooking.getInstance().getDeliveryLatLng()).zoom(17).build();
            googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
        } else {
            checkLocationPermission(false, null);
        }
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
    }

    private void initPlaceAutoComplete() {
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

    private void setPlaceFilter(String countryCode) {
        if (autocompleteAdapter != null) {
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
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivTargetLocation) {
            locationHelper.setLocationSettingRequest(this, REQUEST_CHECK_SETTINGS, o -> checkLocationPermission(true, null), () -> checkLocationPermission(true, null));
        } else if (id == R.id.ivClearDeliveryAddressTextMap) {
            acDeliveryAddress.getText().clear();
        } else if (id == R.id.btnDone) {
            if (!TextUtils.isEmpty(acDeliveryAddress.getText().toString()) && deliveryLatLng != null) {
                changeDeliveryAddressAvailable(deliveryLatLng, deliveryAddress);
            } else {
                Utilities.showToast(this, getResources().getString(R.string.msg_plz_enter_valid_delivery_address));
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CHECK_SETTINGS) {
            if (resultCode == Activity.RESULT_OK) {
                checkLocationPermission(false, null);
            }
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

            public boolean onMarkerClick(@NonNull Marker marker) {
                return doNotMoveCameraToCenterMarker;
            }
        });

        this.googleMap.setOnCameraIdleListener(() -> {
            if (isMapTouched) {
                deliveryLatLng = googleMap.getCameraPosition().target;
                if (deliveryLatLng.latitude != 0.0 && deliveryLatLng.longitude != 0.0) {
                    getGeocodeDataFromLocation(deliveryLatLng);
                }
            }
            isMapTouched = true;
        });
    }

    /***
     * this method is used to move camera on map at current position and a isCameraMove is
     * used to decide when is move or not
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng == null) {
            locationHelper.getLastLocation(location -> {
                if (location != null) {
                    LatLng latLngOfMyLocation = new LatLng(location.getLatitude(), location.getLongitude());
                    CameraPosition cameraPosition = new CameraPosition.Builder().target(latLngOfMyLocation).zoom(17).build();
                    if (isAnimate) {
                        googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                    } else {
                        googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
                    }
                }
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
        acDeliveryAddress.setText(deliveryAddress, false);
        acDeliveryAddress.setFocusable(true);
        acDeliveryAddress.setFocusableInTouchMode(true);
    }

    /**
     * this method called webservice for get location from address which is provided by Google
     *
     * @param address address on map
     */
    private void getGeocodeDataFromAddress(final String address) {
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put(Constant.Google.ADDRESS, address);
        hashMap.put(Constant.Google.KEY, preferenceHelper.getGoogleKey());
        Utilities.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Constant.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utilities.hideCustomProgressDialog();
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null) {
                    deliveryLatLng = new LatLng(Double.parseDouble(map.get(Constant.Google.LAT)), Double.parseDouble(map.get(Constant.Google.LNG)));
                    isMapTouched = false;
                    moveCameraFirstMyLocation(true, deliveryLatLng);
                    deliveryAddress = acDeliveryAddress.getText().toString();
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                Utilities.handleThrowable("DELIVERY_LOCATION_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
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
        hashMap.put(Constant.Google.LAT_LNG, latLng.latitude + "," + latLng.longitude);
        hashMap.put(Constant.Google.KEY, preferenceHelper.getGoogleKey());
        Utilities.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Constant.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utilities.hideCustomProgressDialog();
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null) {
                    deliveryLatLng = latLng;
                    deliveryAddress = map.get(Constant.Google.FORMATTED_ADDRESS);
                    setDeliveryAddress(map.get(Constant.Google.FORMATTED_ADDRESS));
                    setPlaceFilter(map.get(Constant.Google.COUNTRY_CODE));
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                Utilities.handleThrowable("DELIVERY_LOCATION_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        setResult(Activity.RESULT_CANCELED);
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);

    }

    private void checkLocationPermission(boolean isAnimateLocation, LatLng latLng) {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Constant.PERMISSION_FOR_LOCATION);
        } else {
            //Do the stuff that requires permission...
            moveCameraFirstMyLocation(isAnimateLocation, latLng);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Constant.PERMISSION_FOR_LOCATION) {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //Do the stuff that requires permission...
                    moveCameraFirstMyLocation(true, null);
                }
            }
        }
    }

    /**
     * this method used to called webservice for get Delivery type according to param
     *
     * @param cityLatLng location of city
     */
    private void changeDeliveryAddressAvailable(final LatLng cityLatLng, final String address) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.LATITUDE, cityLatLng.latitude);
        map.put(Constant.LONGITUDE, cityLatLng.longitude);

        Call<IsSuccessResponse> responseCall = ApiClient.getClient().create(ApiInterface.class).changeDeliveryAddressStore(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        CurrentBooking.getInstance().setDeliveryAddress(address);
                        CurrentBooking.getInstance().setDeliveryLatLng(cityLatLng);
                        setResult(Activity.RESULT_OK);
                        finish();
                    } else {
                        ParseContent.getInstance().showErrorMessage(CheckoutDeliveryLocationActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("DELIVERY_LOCATION_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();

            }
        });
    }
}