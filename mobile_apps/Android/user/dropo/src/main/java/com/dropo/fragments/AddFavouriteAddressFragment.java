package com.dropo.fragments;

import static com.dropo.utils.Const.REQUEST_CHECK_SETTINGS;

import android.annotation.SuppressLint;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;

import com.dropo.FavouriteAddressActivity;
import com.dropo.user.R;
import com.dropo.adapter.PlaceAutocompleteAdapter;
import com.dropo.component.CustomEventMapView;
import com.dropo.component.CustomFontAutoCompleteView;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Address;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.LocationHelper;
import com.dropo.utils.PreferenceHelper;
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
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.HashMap;
import java.util.Objects;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddFavouriteAddressFragment extends BottomSheetDialogFragment implements LocationHelper.OnLocationReceived, OnMapReadyCallback, View.OnClickListener {

    private PlaceAutocompleteAdapter autocompleteAdapter;
    private LocationHelper locationHelper;
    private CustomFontAutoCompleteView acDeliveryAddress;
    private GoogleMap googleMap;
    private CustomFontButton btnDone;
    private CustomEventMapView mapView;
    private boolean isMapTouched = true;
    private ImageView ivTargetLocation;
    private Address saveAddress;
    private FavouriteAddressActivity favouriteAddressActivity;

    private CustomFontTextViewTitle tvDialogAlertTitle;
    private CustomFontEditTextView etAddressTitle;
    private CustomFontEditTextView etFlatNo;
    private CustomFontEditTextView etStreetNo;
    private CustomFontEditTextView etLandmark;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        favouriteAddressActivity = (FavouriteAddressActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_add_favourite_address, container, false);
        mapView = view.findViewById(R.id.mapView);
        acDeliveryAddress = view.findViewById(R.id.acDeliveryAddress);
        ivTargetLocation = view.findViewById(R.id.ivTargetLocation);
        btnDone = view.findViewById(R.id.btnDone);
        etAddressTitle = view.findViewById(R.id.etAddressTitle);
        acDeliveryAddress = view.findViewById(R.id.acDeliveryAddress);
        tvDialogAlertTitle = view.findViewById(R.id.tvDialogAlertTitle);

        etFlatNo = view.findViewById(R.id.etFlatNo);
        etStreetNo = view.findViewById(R.id.etStreetNo);
        etLandmark = view.findViewById(R.id.etLandmark);

        view.findViewById(R.id.btnClosed).setOnClickListener(view1 -> {
            favouriteAddressActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            dismiss();
        });
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog bottomSheetDialog = (BottomSheetDialog) getDialog();
            bottomSheetDialog.getBehavior().setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        mapView.getMapAsync(this);
        btnDone.setOnClickListener(this);
        ivTargetLocation.setOnClickListener(this);
        mapView.onCreate(savedInstanceState);
        locationHelper = new LocationHelper(getContext());
        locationHelper.setLocationReceivedLister(this);
        initPlaceAutoComplete();

        if (getArguments() != null) {
            Address address = getArguments().getParcelable(Const.Params.ADDRESS);
            if (address != null) {
                address.setId(address.getId());
                etAddressTitle.setText(address.getAddressName());
                etFlatNo.setText(address.getFlat_no());
                etStreetNo.setText(address.getStreet());
                etLandmark.setText(address.getLandmark());
                tvDialogAlertTitle.setText(getString(R.string.text_update_favourite_address));
                btnDone.setText(getString(R.string.text_update));
            }
        }
    }


    @Override
    public void onResume() {
        super.onResume();
        mapView.onResume();
    }

    @Override
    public void onStart() {
        super.onStart();
        locationHelper.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();
        locationHelper.onStop();
    }

    @Override
    public void onPause() {
        mapView.onPause();
        super.onPause();

    }

    @Override
    public void onDestroy() {
        mapView.onDestroy();
        favouriteAddressActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
        super.onDestroy();
    }


    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnDone) {
            if (saveAddress == null || acDeliveryAddress.getText().toString().isEmpty()) {
                Utils.showToast(getString(R.string.msg_valid_address), getContext());
            } else {
                saveAddress.setAddressName(etAddressTitle.getText().toString().isEmpty() ?
                        getString(R.string.text_other) : etAddressTitle.getText().toString());
                saveAddress.setFlat_no(Objects.requireNonNull(etFlatNo.getText()).toString());
                saveAddress.setStreet(Objects.requireNonNull(etStreetNo.getText()).toString());
                saveAddress.setLandmark(Objects.requireNonNull(etLandmark.getText()).toString());

                saveDeliveryAddress(saveAddress,
                        getArguments() != null && getArguments().getParcelable(Const.Params.ADDRESS) != null);
            }
        } else if (id == R.id.ivTargetLocation) {
            locationHelper.setLocationSettingRequest(favouriteAddressActivity, REQUEST_CHECK_SETTINGS, o -> checkLocationPermission(true, null), () -> {
            });
        }
    }

    private void saveDeliveryAddress(Address address, boolean isUpdate) {
        Utils.showCustomProgressDialog(getContext(), false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(requireContext()).getSessionToken());
        map.put(Const.Params.USER_ID, PreferenceHelper.getInstance(requireContext()).getUserId());
        if (isUpdate) {
            map.put(Const.Params.ADDRESS_ID, address.getId());
        }
        map.put(Const.Params.LATITUDE, address.getLatitude());
        map.put(Const.Params.LONGITUDE, address.getLongitude());
        map.put(Const.Params.ADDRESS_NAME, address.getAddressName());
        map.put(Const.Params.ADDRESS, address.getAddress());
        map.put(Const.Params.LANDMARK, address.getLandmark());
        map.put(Const.Params.STREET, address.getStreet());
        map.put(Const.Params.FLAT_NO, address.getFlat_no());
        map.put(Const.Params.COUNTRY, address.getCountry());
        map.put(Const.Params.COUNTRY_CODE, address.getCountryCode());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.saveFavAddress(map);
        if (isUpdate) {
            responseCall = apiInterface.updateFavAddress(map);
        }
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        AddFavouriteAddressFragment.this.dismiss();
                        favouriteAddressActivity.loadAddress();
                        if (isUpdate) {
                            Utils.showToast(getString(R.string.msg_favourite_address_updated_successfully), favouriteAddressActivity);
                        } else {
                            Utils.showToast(getString(R.string.msg_favourite_address_added_successfully), favouriteAddressActivity);
                        }
                    } else {
                        Utils.showToast(getString(R.string.msg_favourite_address_failed), favouriteAddressActivity);
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


    @Override
    public void onLocationChanged(Location location) {
        if (location != null && googleMap != null && googleMap.getCameraPosition().target.latitude == 0.0 && googleMap.getCameraPosition().target.longitude == 0.0) {
            checkLocationPermission(false, new LatLng(location.getLatitude(), location.getLongitude()));
        }
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
    }

    private void initPlaceAutoComplete() {
        if (autocompleteAdapter == null) {
            autocompleteAdapter = new PlaceAutocompleteAdapter(getContext());
            acDeliveryAddress.setAdapter(autocompleteAdapter);
            acDeliveryAddress.setOnItemClickListener((adapterView, view, i, l) -> getGeocodeDataFromAddress(acDeliveryAddress.getText().toString()));
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
        hashMap.put(Const.Google.KEY, PreferenceHelper.getInstance(requireContext()).getGoogleKey());
        Utils.showCustomProgressDialog(getContext(), false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utils.hideCustomProgressDialog();
                HashMap<String, String> map = ParseContent.getInstance().parsGoogleGeocode(response);
                if (map != null) {
                    LatLng latLng = new LatLng(Double.parseDouble(map.get(Const.Google.LAT)), Double.parseDouble(map.get(Const.Google.LNG)));
                    if (latLng != null) {
                        isMapTouched = false;
                        CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng).zoom(17).build();
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
                    }
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
        hashMap.put(Const.Google.KEY, PreferenceHelper.getInstance(requireContext()).getGoogleKey());
        Utils.showCustomProgressDialog(getContext(), false);
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                Utils.hideCustomProgressDialog();
                HashMap<String, String> map = ParseContent.getInstance().parsGoogleGeocode(response);
                if (map != null) {
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
                    setPlaceFilter(map.get(Const.Google.COUNTRY_CODE));
                    setDeliveryAddress(map.get(Const.Google.FORMATTED_ADDRESS));
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
                if (googleMap.getCameraPosition().target.latitude != 0.0 && googleMap.getCameraPosition().target.longitude != 0.0) {
                    getGeocodeDataFromLocation(googleMap.getCameraPosition().target);
                }
            }
            isMapTouched = true;
        });
        locationHelper.setLocationSettingRequest(favouriteAddressActivity, REQUEST_CHECK_SETTINGS, o -> checkLocationPermission(true, null), () -> {
        });
    }

    private void checkLocationPermission(boolean isAnimateLocation, LatLng latLng) {
        if (ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
        } else if (getArguments() != null && getArguments().getParcelable(Const.Params.ADDRESS) != null) {
            saveAddress = getArguments().getParcelable(Const.Params.ADDRESS);
            //etAddressTitle.setText(saveAddress.getAddressTitle());
            moveCameraFirstMyLocation(isAnimateLocation, new LatLng(Double.parseDouble(saveAddress.getLatitude()), Double.parseDouble(saveAddress.getLongitude())));
        } else {
            moveCameraFirstMyLocation(isAnimateLocation, latLng);
        }
    }

    /***
     * this method is used to move camera on map at current position and a isCameraMove is
     * used to decide when is move or not
     */
    public void moveCameraFirstMyLocation(final boolean isAnimate, LatLng latLng) {
        if (latLng == null) {
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
        } else {
            CameraPosition cameraPosition = new CameraPosition.Builder().target(latLng).zoom(17).build();
            if (isAnimate) {
                googleMap.animateCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            } else {
                googleMap.moveCamera(CameraUpdateFactory.newCameraPosition(cameraPosition));
            }
        }

    }

    private void setPlaceFilter(String countryCode) {
        if (autocompleteAdapter != null && ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
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

    private void setDeliveryAddress(String deliveryAddress) {
        acDeliveryAddress.setFocusable(false);
        acDeliveryAddress.setFocusableInTouchMode(false);
        acDeliveryAddress.setText(deliveryAddress, false);
        acDeliveryAddress.setFocusable(true);
        acDeliveryAddress.setFocusableInTouchMode(true);
    }
}