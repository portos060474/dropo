package com.dropo.store;

import static com.dropo.store.utils.Constant.REQUEST_CHECK_SETTINGS;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.text.TextUtils;
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
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
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

import java.util.HashMap;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StoreLocationActivity extends BaseActivity implements LocationHelper.OnLocationReceived, OnMapReadyCallback {

    private LocationHelper locationHelper;
    private CustomFontAutoCompleteView acDeliveryAddress;
    private GoogleMap googleMap;
    private CustomEventMapView mapView;
    private LatLng storeLatLng;
    private boolean isMapTouched = true;
    private PlaceAutocompleteAdapter autocompleteAdapter;
    private LatLng latLngOfMyLocation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_location);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_store_location));
        mapView = findViewById(R.id.mapView);
        acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
        ImageView ivTargetLocation = findViewById(R.id.ivTargetLocation);
        ImageView ivClearDeliveryAddressTextMap = findViewById(R.id.ivClearDeliveryAddressTextMap);
        CustomButton btnDone = findViewById(R.id.btnDone);
        mapView.getMapAsync(this);
        ivTargetLocation.setOnClickListener(this);
        ivClearDeliveryAddressTextMap.setOnClickListener(this);
        btnDone.setOnClickListener(this);

        mapView.onCreate(savedInstanceState);
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        initPlaceAutoComplete();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, R.drawable.ic_filter);
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

    @Override
    public void onLocationChanged(Location location) {
        if (latLngOfMyLocation == null) {
            locationHelper.onStop();
            checkLocationPermission(null);
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivTargetLocation) {
            locationHelper.setLocationSettingRequest(this, REQUEST_CHECK_SETTINGS, o -> checkLocationPermission(null), () -> checkLocationPermission(null));
        } else if (id == R.id.ivClearDeliveryAddressTextMap) {
            acDeliveryAddress.getText().clear();
        } else if (id == R.id.btnDone) {
            if (!TextUtils.isEmpty(acDeliveryAddress.getText().toString()) && storeLatLng != null) {
                Intent intent = new Intent();
                intent.putExtra(Constant.LATITUDE, storeLatLng.latitude);
                intent.putExtra(Constant.LONGITUDE, storeLatLng.longitude);
                intent.putExtra(Constant.ADDRESS, acDeliveryAddress.getText().toString());
                setResult(Activity.RESULT_OK, intent);
                finish();
            } else {
                Utilities.showToast(this, getResources().getString(R.string.text_select_address_or_location));
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CHECK_SETTINGS) {
            if (resultCode == Activity.RESULT_OK) {
                checkLocationPermission(null);
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
                LatLng location = googleMap.getCameraPosition().target;
                if (location.latitude != 0.0 && location.longitude != 0.0) {
                    if (latLngOfMyLocation == null || distanceBetweenTwoLatLng(latLngOfMyLocation, location) > 10 || TextUtils.isEmpty(acDeliveryAddress.getText().toString().trim())) {
                        getGeocodeDataFromLocation(location);
                    }
                }
            }
            isMapTouched = true;
        });
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
    }

    /***
     * this method is used to move camera on map at current position and a isCameraMove is
     * used to decide when is move or not
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng == null) {
            locationHelper.setLocationSettingRequest(this, REQUEST_CHECK_SETTINGS, o -> {
                locationHelper.getLastLocation(location -> {
                    if (location != null) {
                        latLngOfMyLocation = new LatLng(location.getLatitude(), location.getLongitude());
                        CameraPosition cameraPosition = new CameraPosition.Builder().target(latLngOfMyLocation).zoom(17).build();
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
        acDeliveryAddress.setText(deliveryAddress, false);
        acDeliveryAddress.setFocusable(true);
        acDeliveryAddress.setFocusableInTouchMode(true);
    }

    /**
     * this method called webservice for get location from storeAddress which is provided by Google
     *
     * @param address storeAddress on map
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
                    storeLatLng = new LatLng(Double.parseDouble(map.get(Constant.Google.LAT)), Double.parseDouble(map.get(Constant.Google.LNG)));
                    isMapTouched = false;
                    moveCameraFirstMyLocation(true, storeLatLng);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called webservice for get Data from LatLng which is provided by Google
     *
     * @param latLng on map
     */
    private void getGeocodeDataFromLocation(LatLng latLng) {
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
                    storeLatLng = new LatLng(Double.parseDouble(map.get(Constant.Google.LAT)), Double.parseDouble(map.get(Constant.Google.LNG)));
                    setDeliveryAddress(map.get(Constant.Google.FORMATTED_ADDRESS));
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
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

    private void checkLocationPermission(LatLng latLng) {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Constant.PERMISSION_FOR_LOCATION);
        } else {
            moveCameraFirstMyLocation(true, latLng);
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

    private double distanceBetweenTwoLatLng(LatLng oldLatLng, LatLng newLatLng) {
        if (oldLatLng == null || newLatLng == null) {
            return 0.0;
        } else {
            Location location = new Location("location");
            location.setLatitude(oldLatLng.latitude);
            location.setLongitude(oldLatLng.longitude);
            Location locationNew = new Location("locationNew");
            locationNew.setLatitude(newLatLng.latitude);
            locationNew.setLongitude(newLatLng.longitude);
            return location.distanceTo(locationNew);
        }
    }
}