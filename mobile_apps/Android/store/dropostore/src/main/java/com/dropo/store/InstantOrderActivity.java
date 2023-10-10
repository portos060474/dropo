package com.dropo.store;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.component.VehicleDialog;
import com.dropo.store.models.datamodel.Addresses;
import com.dropo.store.models.datamodel.CartOrder;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.models.responsemodel.AddCartResponse;
import com.dropo.store.models.responsemodel.InvoiceResponse;
import com.dropo.store.models.responsemodel.VehiclesResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class InstantOrderActivity extends BaseActivity {
    public static final String TAG = "InstantOrderInvoiceActivity";
    private final List<VehicleDetail> vehicleDetails = new ArrayList<>();
    private CustomInputEditText etCustomerFistName, etCustomerMobile, etCustomerDeliveryAddress,
            etDeliveryAddressNote, etFlatNo, etStreetNo, etLandmark, etCustomerLastName, etCustomerEmail,
            etDeliveryPrice, etCustomerCountryCode;
    private CustomButton btnInvoice;
    private CustomTextView tvPromoCodeApply;
    private ImageView ivDeliveryLocation;
    private String vehicleId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_instant_order);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(InstantOrderActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_instant_order));
        etDeliveryPrice = findViewById(R.id.etDeliveryPrice);
        etCustomerFistName = findViewById(R.id.etCustomerFirstName);
        etCustomerLastName = findViewById(R.id.etCustomerLastName);
        etCustomerEmail = findViewById(R.id.etCustomerEmail);
        etCustomerMobile = findViewById(R.id.etCustomerMobile);
        etCustomerDeliveryAddress = findViewById(R.id.etCustomerDeliveryAddress);
        etFlatNo = findViewById(R.id.etFlatNo);
        etStreetNo = findViewById(R.id.etStreetNo);
        etLandmark = findViewById(R.id.etLandmark);
        etDeliveryAddressNote = findViewById(R.id.etDeliveryAddressNote);
        btnInvoice = findViewById(R.id.btnInvoice);
        tvPromoCodeApply = findViewById(R.id.tvPromoCodeApply);
        ivDeliveryLocation = findViewById(R.id.ivDeliveryLocation);
        etCustomerCountryCode = findViewById(R.id.etCustomerCountryCode);
        btnInvoice.setOnClickListener(this);
        tvPromoCodeApply.setOnClickListener(this);
        ivDeliveryLocation.setOnClickListener(this);
        etCustomerDeliveryAddress.setOnClickListener(this);
        FieldValidation.setMaxPhoneNumberInputLength(this, etCustomerMobile);
        etCustomerCountryCode.setText(preferenceHelper.getCountryPhoneCode());
        getDeliveryVehicleList();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    private void addEmptyCartOnServer() {
        Utilities.showCustomProgressDialog(this, false);
        CartOrder cartOrder = new CartOrder();
        cartOrder.setServerToken("");
        cartOrder.setUserId("");
        cartOrder.setUserType(Constant.Type.STORE);
        cartOrder.setStoreId(preferenceHelper.getStoreId());
        cartOrder.setProducts(new ArrayList<CartProducts>());
        cartOrder.setAndroidId(preferenceHelper.getAndroidId());
        cartOrder.setUseItemTax(preferenceHelper.getIsUseItemTax());
        cartOrder.setTaxIncluded(preferenceHelper.getTaxIncluded());
        if (!TextUtils.isEmpty(preferenceHelper.getCartId())) {
            cartOrder.setCartId(preferenceHelper.getCartId());
        }

        if (CurrentBooking.getInstance().getDestinationAddresses().isEmpty()) {
            Addresses addresses = new Addresses();
            addresses.setAddress(CurrentBooking.getInstance().getDeliveryAddress());
            addresses.setFlat_no(etFlatNo.getText().toString().trim());
            addresses.setStreet(etStreetNo.getText().toString().trim());
            addresses.setLandmark(etLandmark.getText().toString().trim());
            addresses.setCity(CurrentBooking.getInstance().getCity1());
            addresses.setAddressType(Constant.Type.DESTINATION);
            addresses.setNote(etDeliveryAddressNote.getText().toString());
            addresses.setUserType(Constant.Type.USER);
            ArrayList<Double> location = new ArrayList<>();
            location.add(CurrentBooking.getInstance().getDeliveryLatLng().latitude);
            location.add(CurrentBooking.getInstance().getDeliveryLatLng().longitude);
            addresses.setLocation(location);
            UserDetail cartUserDetail = new UserDetail();
            cartUserDetail.setEmail(etCustomerEmail.getText().toString());
            cartUserDetail.setCountryPhoneCode(etCustomerCountryCode.getText().toString());
            cartUserDetail.setName(etCustomerFistName.getText().toString() + " " + etCustomerLastName.getText().toString());
            cartUserDetail.setPhone(etCustomerMobile.getText().toString());
            addresses.setUserDetails(cartUserDetail);
            CurrentBooking.getInstance().setDestinationAddresses(addresses);
        }

        if (CurrentBooking.getInstance().getPickupAddresses().isEmpty()) {
            Addresses addresses = new Addresses();
            addresses.setAddress(preferenceHelper.getAddress());
            addresses.setCity("");
            addresses.setAddressType(Constant.Type.PICKUP);
            addresses.setNote("");
            addresses.setUserType(Constant.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(Double.valueOf(preferenceHelper.getLatitude()));
            location.add(Double.valueOf(preferenceHelper.getLongitude()));
            addresses.setLocation(location);
            UserDetail cartUserDetail = new UserDetail();
            cartUserDetail.setEmail(preferenceHelper.getEmail());
            cartUserDetail.setCountryPhoneCode(preferenceHelper.getCountryPhoneCode());
            cartUserDetail.setName(preferenceHelper.getName());
            cartUserDetail.setPhone(preferenceHelper.getPhone());
            addresses.setUserDetails(cartUserDetail);
            CurrentBooking.getInstance().setPickupAddresses(addresses);
        }
        cartOrder.setDestinationAddresses(CurrentBooking.getInstance().getDestinationAddresses());
        cartOrder.setPickupAddresses(CurrentBooking.getInstance().getPickupAddresses());

        cartOrder.setCartOrderTotalPrice(Double.parseDouble(etDeliveryPrice.getText().toString()));
        cartOrder.setCartOrderTotalTaxPrice(0);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.putCartId(response.body().getCartId());
                        CurrentBooking.getInstance().setCartCityId(response.body().getCityId());
                        CurrentBooking.getInstance().setCurrency(preferenceHelper.getCurrency());
                        getDistanceMatrix();
                    } else {
                        Utilities.hideCustomProgressDialog();
                        if (response.body().getErrorCode() == Constant.TAXES_DETAILS_CHANGED) {
                            CurrentBooking.getInstance().clearCart();
                            goToHomeActivity();
                        } else {
                            ParseContent.getInstance().showErrorMessage(InstantOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddCartResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("PRODUCT_SPE_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    protected boolean isValidate() {
        String msg = null;

        if (TextUtils.isEmpty(etCustomerFistName.getText().toString().trim())) {
            msg = getString(R.string.msg_please_enter_valid_name);
            etCustomerFistName.setError(msg);
            etCustomerFistName.requestFocus();
        } else if (TextUtils.isEmpty(etCustomerLastName.getText().toString().trim())) {
            msg = getString(R.string.msg_please_enter_valid_name);
            etCustomerLastName.setError(msg);
            etCustomerLastName.requestFocus();
        } else if (!Patterns.EMAIL_ADDRESS.matcher(etCustomerEmail.getText().toString().trim()).matches()) {
            msg = getString(R.string.msg_please_enter_valid_email);
            etCustomerEmail.setError(msg);
            etCustomerEmail.requestFocus();
        } else if (TextUtils.isEmpty(etCustomerMobile.getText().toString().trim())) {
            msg = getString(R.string.msg_please_enter_valid_mobile_number);
            etCustomerMobile.setError(msg);
            etCustomerMobile.requestFocus();
        } else if (!FieldValidation.isValidPhoneNumber(this, etCustomerMobile.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(this);
            etCustomerMobile.setError(msg);
            etCustomerMobile.requestFocus();
        } else if (!Utilities.isDecimalAndGraterThenZero(etDeliveryPrice.getText().toString().trim())) {
            msg = getString(R.string.msg_enter_valid_amount);
            etDeliveryPrice.setError(msg);
            etDeliveryPrice.requestFocus();
        } else if (TextUtils.isEmpty(etCustomerDeliveryAddress.getText().toString().trim()) || CurrentBooking.getInstance().getDeliveryLatLng() == null) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_delivery_address);
            etCustomerDeliveryAddress.setError(msg);
            etCustomerDeliveryAddress.requestFocus();
        }
        return TextUtils.isEmpty(msg);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnInvoice) {
            if (isValidate()) {
                openVehicleSelectDialog();
            }
        } else if (id == R.id.ivDeliveryLocation || id == R.id.etCustomerDeliveryAddress) {
            goToCheckoutDeliveryLocationActivity();
        }
    }

    private void goToCheckoutDeliveryLocationActivity() {
        Intent intent = new Intent(this, CheckoutDeliveryLocationActivity.class);
        startActivityForResult(intent, Constant.DELIVERY_LIST_CODE);
    }

    private void goToInstantOrderInvoiceActivity(InvoiceResponse invoiceResponse, String vehicleId) {
        Intent intent = new Intent(this, InstantOrderInvoiceActivity.class);
        intent.putExtra(Constant.INVOICE, invoiceResponse);
        intent.putExtra(Constant.VEHICLE_ID, vehicleId);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == Constant.DELIVERY_LIST_CODE) {
                if (CurrentBooking.getInstance().getStoreLatLng() != null) {
                    etCustomerDeliveryAddress.setError(null);
                    etCustomerDeliveryAddress.setText(CurrentBooking.getInstance().getDeliveryAddress());
                }
            }
        }
    }

    /**
     * this method called a webservice for get distance and time witch is provided by Google
     */
    private void getDistanceMatrix() {
        HashMap<String, String> hashMap = new HashMap<>();
        String origins = CurrentBooking.getInstance().getStoreLatLng().latitude + "," + CurrentBooking.getInstance().getStoreLatLng().longitude;
        hashMap.put(Constant.Google.ORIGINS, origins);
        String destination = CurrentBooking.getInstance().getDeliveryLatLng().latitude + "," + CurrentBooking.getInstance().getDeliveryLatLng().longitude;
        hashMap.put(Constant.Google.DESTINATIONS, destination);
        hashMap.put(Constant.Google.KEY, preferenceHelper.getGoogleKey());
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Constant.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> call = apiInterface.getGoogleDistanceMatrix(hashMap);
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsDistanceMatrix(response);
                if (map != null && !map.isEmpty()) {
                    String distance = map.get(Constant.Google.DISTANCE);
                    String timeSecond = map.get(Constant.Google.DURATION);
                    double tripDistance = Double.parseDouble(distance);
                    getDeliveryInvoice(Integer.parseInt(timeSecond), tripDistance);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                Utilities.handleThrowable("CHECKOUT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });

    }

    /**
     * this method called a webservice to get delivery invoice or bill
     */
    private void getDeliveryInvoice(int timeSeconds, double tripDistance) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, "");
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.TOTAL_ITEM_COUNT, 1);
        map.put(Constant.TOTAL_CART_PRICE, Double.valueOf(etDeliveryPrice.getText().toString()));
        map.put(Constant.TOTAL_ITEM_PRICE, Double.valueOf(etDeliveryPrice.getText().toString()));
        map.put(Constant.TOTAL_DISTANCE, tripDistance);
        map.put(Constant.TOTAL_TIME, timeSeconds);
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.VEHICLE_ID, vehicleId);
        map.put(Constant.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        map.put(Constant.TOTAL_CART_AMOUNT_WITHOUT_TAX, CurrentBooking.getInstance().getTotalCartAmountWithoutTax());
        map.put(Constant.TAX_DETAILS, new JSONArray());
        map.put(Constant.IS_TAX_INCLUDED, preferenceHelper.getTaxIncluded());
        map.put(Constant.IS_USE_ITEM_TAX, preferenceHelper.getIsUseItemTax());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> responseCall = apiInterface.getDeliveryInvoice(map);
        responseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull Response<InvoiceResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        goToInstantOrderInvoiceActivity(response.body(), vehicleId);
                    } else {
                        parseContent.showErrorMessage(InstantOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("CHECKOUT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void getDeliveryVehicleList() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<VehiclesResponse> responseCall = apiInterface.getVehiclesList(map);
        responseCall.enqueue(new Callback<VehiclesResponse>() {
            @Override
            public void onResponse(@NonNull Call<VehiclesResponse> call, @NonNull Response<VehiclesResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        vehicleDetails.clear();
                        if (preferenceHelper.getIsStoreCanCompleteOrder() || preferenceHelper.getIsStoreCanAddProvider()) {
                            vehicleDetails.addAll(response.body().getVehicles());
                        } else {
                            vehicleDetails.addAll(response.body().getAdminVehicles());
                        }
                    } else {
                        parseContent.showErrorMessage(InstantOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<VehiclesResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("CHECKOUT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void openVehicleSelectDialog() {
        if (vehicleDetails.isEmpty()) {
            Utilities.showToast(this, getResources().getString(R.string.text_vehicle_not_found));
        } else {
            final VehicleDialog vehicleDialog = new VehicleDialog(this, vehicleDetails);
            vehicleDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> vehicleDialog.dismiss());
            vehicleDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
                vehicleId = vehicleDialog.getVehicleId();
                if (TextUtils.isEmpty(vehicleId)) {
                    Utilities.showToast(InstantOrderActivity.this, getResources().getString(R.string.msg_select_vehicle));
                } else {
                    vehicleDialog.dismiss();
                    addEmptyCartOnServer();
                }
            });
            vehicleDialog.show();
            vehicleDialog.hideProviderManualAssign();
        }
    }
}