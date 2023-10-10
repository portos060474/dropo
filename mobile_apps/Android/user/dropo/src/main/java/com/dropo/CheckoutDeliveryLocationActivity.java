package com.dropo;

import static com.dropo.utils.Const.REQUEST_CHECK_SETTINGS;
import static com.dropo.utils.Const.REQUEST_FAVOURITE_ADDRESS;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.adapter.PlaceAutocompleteAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomEventMapView;
import com.dropo.component.CustomFontAutoCompleteView;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Address;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.LocationHelper;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CheckoutDeliveryLocationActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived, OnMapReadyCallback {

    private PlaceAutocompleteAdapter autocompleteAdapter;
    private LocationHelper locationHelper;
    private CustomFontAutoCompleteView acDeliveryAddress;
    private ImageView ivTargetLocation;
    private GoogleMap googleMap;
    private LatLng deliveryLatLng;
    private CustomFontButton btnDeliveryHere;
    private CustomEventMapView mapView;
    private String deliveryAddress;
    private boolean isMapTouched = true;
    private CustomDialogAlert customDialogEnable;
    private int requestCode;
    private CustomFontEditTextView etFlatNo;
    private CustomFontEditTextView etStreetNo;
    private CustomFontEditTextView etLandmark;
    private CustomFontEditTextView etCustomerName, etCustomerCountryCode, etCustomerMobile, etDeliveryAddressNote;

    private CustomFontTextViewTitle tvSaveFavAddress;
    private Address saveAddress;

    private View llUserDetails, llExtraAddressDetails;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout_delivery_location);
        initToolBar();
        setTitleOnToolBar(getString(R.string.text_delivery_location));
        setToolbarRightIcon2(R.drawable.fav_address, this);
        initViewById();
        setViewListener();
        mapView.onCreate(savedInstanceState);
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        initPlaceAutoComplete();
        tvSaveFavAddress.setVisibility(isCurrentLogin() ? View.VISIBLE : View.GONE);
        if (getIntent().getExtras() != null) {
            requestCode = getIntent().getExtras().getInt(Const.REQUEST_CODE, Const.DELIVERY_LIST_CODE);
            deliveryLatLng = getIntent().getExtras().getParcelable(Const.Params.LOCATION);
            acDeliveryAddress.setText(getIntent().getExtras().getString(Const.Params.ADDRESS), false);
            etCustomerName.setText(getIntent().getExtras().getString(Const.Params.NAME));
            etCustomerCountryCode.setText(getIntent().getExtras().getString(Const.Params.COUNTRY_PHONE_CODE));
            etCustomerMobile.setText(getIntent().getExtras().getString(Const.Params.PHONE));
            etDeliveryAddressNote.setText(getIntent().getExtras().getString(Const.Params.NOTE_FOR_DELIVERYMAN));

            if (!currentBooking.getDestinationAddresses().isEmpty()) {
                etFlatNo.setText(currentBooking.getDestinationAddresses().get(0).getFlatNo());
                etStreetNo.setText(currentBooking.getDestinationAddresses().get(0).getStreet());
                etLandmark.setText(currentBooking.getDestinationAddresses().get(0).getLandmark());
            }

            if (requestCode == Const.REQUEST_CODE_COURIER_ADDRESS) {
                llUserDetails.setVisibility(View.GONE);
                llExtraAddressDetails.setVisibility(View.GONE);
            }

            getGeocodeDataFromAddress(acDeliveryAddress.getText().toString());
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
        acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
        autocompleteAdapter = new PlaceAutocompleteAdapter(this);
        acDeliveryAddress.setAdapter(autocompleteAdapter);
        acDeliveryAddress.setOnItemClickListener((adapterView, view, i, l) -> getGeocodeDataFromAddress(acDeliveryAddress.getText().toString()));
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
        String msg = null;
        clearError();
        if (TextUtils.isEmpty(etCustomerName.getText().toString().trim())) {
            msg = getString(R.string.msg_please_enter_valid_name);
            etCustomerName.setError(msg);
            etCustomerName.requestFocus();
        } else if (FieldValidation.isValidPhoneNumber(this, etCustomerMobile.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(this);
            etCustomerMobile.setError(msg);
            etCustomerMobile.requestFocus();
        } else if (TextUtils.isEmpty(acDeliveryAddress.getText().toString()) && !currentBooking.isTableBooking()) {
            msg = getString(R.string.msg_plz_enter_valid_place_address);
            acDeliveryAddress.setError(msg);
            acDeliveryAddress.requestFocus();
        }
        return TextUtils.isEmpty(msg);
    }

    private void clearError() {
        etCustomerName.setError(null);
        etCustomerMobile.setError(null);
        acDeliveryAddress.setError(null);
    }

    @Override
    protected void initViewById() {
        mapView = findViewById(R.id.mapView);
        acDeliveryAddress = findViewById(R.id.acDeliveryAddress);
        etFlatNo = findViewById(R.id.etFlatNo);
        etStreetNo = findViewById(R.id.etStreetNo);
        etLandmark = findViewById(R.id.etLandmark);
        ivTargetLocation = findViewById(R.id.ivTargetLocation);
        btnDeliveryHere = findViewById(R.id.btnDeliveryHere);
        etCustomerName = findViewById(R.id.etCustomerName);
        etCustomerCountryCode = findViewById(R.id.etCustomerCountryCode);
        etCustomerMobile = findViewById(R.id.etCustomerMobile);
        FieldValidation.setMaxPhoneNumberInputLength(this, etCustomerMobile);
        etDeliveryAddressNote = findViewById(R.id.etDeliveryAddressNote);
        tvSaveFavAddress = findViewById(R.id.tvSaveFavAddress);
        llUserDetails = findViewById(R.id.llUserDetails);
        llExtraAddressDetails = findViewById(R.id.llExtraAddressDetails);
    }

    @Override
    protected void setViewListener() {
        mapView.getMapAsync(this);

        ivTargetLocation.setOnClickListener(this);
        btnDeliveryHere.setOnClickListener(this);
        tvSaveFavAddress.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onLocationChanged(Location location) {
        if (autocompleteAdapter.getBounds() == null) {
            setPlaceFilter(currentBooking.getCountryCode());
        }
        if (location != null && googleMap != null && googleMap.getCameraPosition().target.latitude == 0.0 && googleMap.getCameraPosition().target.longitude == 0.0) {
            moveCameraFirstMyLocation(true, new LatLng(location.getLatitude(), location.getLongitude()));
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivTargetLocation) {
            checkLocationPermission(true);
        } else if (id == R.id.btnDeliveryHere) {
            if (requestCode == Const.DELIVERY_LIST_CODE && isValidate()) {
                if (!TextUtils.equals(currentBooking.getDeliveryAddress(), acDeliveryAddress.getText().toString())) {
                    changeDeliveryAddressAvailable(deliveryLatLng, deliveryAddress);
                } else {
                    proceedWithData();
                }
            } else if (requestCode == Const.REQUEST_CODE_COURIER_ADDRESS) {
                proceedWithData();
            }
        } else if (id == R.id.tvSaveFavAddress) {
            if (saveAddress == null || acDeliveryAddress.getText().toString().isEmpty()) {
                Utils.showToast(getString(R.string.msg_valid_address), this);
            } else {
                saveAddress.setLandmark(etLandmark.getText().toString());
                saveAddress.setFlat_no(etFlatNo.getText().toString());
                saveAddress.setStreet(etStreetNo.getText().toString());
                showAddFavouriteAddressTitle();
            }
        } else if (id == R.id.ivToolbarRightIcon2) {
            Intent intent = new Intent(this, FavouriteAddressActivity.class);
            intent.putExtra(Const.Params.ADDRESS, true);
            startActivityForResult(intent, Const.REQUEST_FAVOURITE_ADDRESS);
            overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_CHECK_SETTINGS:
                if (resultCode == Activity.RESULT_OK) {
                    checkLocationPermission(false);
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
            default:
                break;
        }
    }

    /**
     * This method is used to setUpMap option which help to load map as per option
     */
    @SuppressLint("PotentialBehaviorOverride")
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

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
        if (deliveryLatLng != null) {
            CameraPosition cameraPosition = new CameraPosition.Builder().target(deliveryLatLng).zoom(17).build();
            googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
        } else {
            moveCameraFirstMyLocation(true, null);
        }
    }

    /***
     * this method is used to move camera on map at current position and a isCameraMove is
     * used to decide when is move or not
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng == null) {
            locationHelper.setLocationSettingRequest(CheckoutDeliveryLocationActivity.this, REQUEST_CHECK_SETTINGS, o -> {
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

    private void proceedWithData() {
        if (currentBooking.getDestinationAddresses().isEmpty()) {
            Addresses addresses = new Addresses();
            currentBooking.setDestinationAddresses(addresses);
        }
        currentBooking.getDestinationAddresses().get(0).setFlatNo(etFlatNo.getText().toString());
        currentBooking.getDestinationAddresses().get(0).setStreet(etStreetNo.getText().toString());
        currentBooking.getDestinationAddresses().get(0).setLandmark(etLandmark.getText().toString());

        Intent intent = new Intent();
        intent.putExtra(Const.Params.ADDRESS, deliveryAddress);
        intent.putExtra(Const.Params.LOCATION, deliveryLatLng);
        intent.putExtra(Const.Params.NAME, etCustomerName.getText().toString());
        intent.putExtra(Const.Params.COUNTRY_PHONE_CODE, etCustomerCountryCode.getText().toString());
        intent.putExtra(Const.Params.PHONE, etCustomerMobile.getText().toString());
        intent.putExtra(Const.Params.NOTE_FOR_DELIVERYMAN, etDeliveryAddressNote.getText().toString());
        setResult(Activity.RESULT_OK, intent);
        finish();
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
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put(Const.Google.ADDRESS, address);
        hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());

        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utils.hideCustomProgressDialog();
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null) {
                    deliveryLatLng = new LatLng(Double.parseDouble(map.get(Const.Google.LAT)), Double.parseDouble(map.get(Const.Google.LNG)));
                    isMapTouched = false;
                    CameraPosition cameraPosition = new CameraPosition.Builder().target(deliveryLatLng).zoom(17).build();
                    googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));

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

                    deliveryAddress = acDeliveryAddress.getText().toString();
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
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
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utils.hideCustomProgressDialog();
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null) {
                    deliveryLatLng = latLng;
                    deliveryAddress = map.get(Const.Google.FORMATTED_ADDRESS);
                    setDeliveryAddress(map.get(Const.Google.FORMATTED_ADDRESS));
                    setPlaceFilter(map.get(Const.Google.COUNTRY_CODE));
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.DELIVERY_LOCATION_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        setResult(Activity.RESULT_CANCELED);
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    /**
     * this method used to called webservice for get Delivery type according to param
     *
     * @param cityLatLng location of city
     */
    private void changeDeliveryAddressAvailable(final LatLng cityLatLng, final String address) {
        final Addresses addresses = new Addresses();

        HashMap<String, Object> map = new HashMap<>();
        addresses.setAddress(address);
        addresses.setCity(currentBooking.getCity1());
        addresses.setAddressType(Const.Type.DESTINATION);
        addresses.setNote("");
        addresses.setUserType(Const.Type.USER);
        ArrayList<Double> location = new ArrayList<>();
        location.add(cityLatLng.latitude);
        location.add(cityLatLng.longitude);
        addresses.setLocation(location);
        addresses.setLandmark(Objects.requireNonNull(etLandmark.getText()).toString());
        addresses.setStreet(Objects.requireNonNull(etStreetNo.getText()).toString());
        addresses.setFlatNo(Objects.requireNonNull(etFlatNo.getText()).toString());
        CartUserDetail cartUserDetail = new CartUserDetail();
        cartUserDetail.setEmail(preferenceHelper.getEmail());
        cartUserDetail.setCountryPhoneCode(preferenceHelper.getCountryPhoneCode());
        cartUserDetail.setName(preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName());
        cartUserDetail.setPhone(preferenceHelper.getPhoneNumber());
        addresses.setUserDetails(cartUserDetail);
        ArrayList<Addresses> addresses1 = new ArrayList<>();
        addresses1.add(addresses);
        map.put(Const.Params.DESTINATION_ADDRESSES, addresses1);
        map.put(Const.Params.CART_ID, currentBooking.getCartId());
        Utils.showCustomProgressDialog(this, false);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.changeDeliveryAddress(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.setDeliveryAddress(address);
                        currentBooking.setDeliveryLatLng(cityLatLng);
                        currentBooking.setDestinationAddresses(addresses);
                        proceedWithData();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutDeliveryLocationActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.DELIVERY_LOCATION_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
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
            String msg;
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
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showToast(getString(R.string.msg_favourite_address_added_successfully), CheckoutDeliveryLocationActivity.this);
                    } else {
                        Utils.showToast(getString(R.string.msg_favourite_address_failed), CheckoutDeliveryLocationActivity.this);
                    }
                }
                Utils.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CURRENT_ORDER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void checkLocationPermission(boolean isAnimateLocation) {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
        } else {
            moveCameraFirstMyLocation(isAnimateLocation, null);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_LOCATION) {
                goWithLocationPermission(grantResults);
            }
        }
    }

    private void goWithLocationPermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            //Do the stuff that requires permission...
            moveCameraFirstMyLocation(true, null);
        } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
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
                ActivityCompat.requestPermissions(CheckoutDeliveryLocationActivity.this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
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
}