package com.dropo.store;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.models.datamodel.Addresses;
import com.dropo.store.models.datamodel.CartOrder;
import com.dropo.store.models.datamodel.CartProductItems;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.models.responsemodel.AddCartResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomCheckBox;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;


public class CheckoutActivity extends BaseActivity {

    public static final String TAG = CheckoutActivity.class.getName();
    private CustomInputEditText etCustomerFistName, etCustomerMobile, etCustomerDeliveryAddress, etFlatNo,
            etStreetNo, etLandmark, etDeliveryAddressNote, etCustomerLastName, etCustomerEmail, etCustomerCountryCode;
    private CustomButton btnInvoice;
    private CustomTextView tvPromoCodeApply;
    private ImageView ivDeliveryLocation;
    private CustomCheckBox cbSelfDelivery;
    private TextInputLayout tilNote;
    private LinearLayout llSelfDelivery, llDestinationAddress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_out);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(CheckoutActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_checkout));
        llDestinationAddress = findViewById(R.id.llDestinationAddress);
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
        cbSelfDelivery = findViewById(R.id.cbSelfDelivery);
        cbSelfDelivery.setOnCheckedChangeListener((buttonView, isChecked) -> {
            ivDeliveryLocation.setEnabled(!isChecked);
            etCustomerDeliveryAddress.setEnabled(!isChecked);
            etDeliveryAddressNote.getText().clear();
            etDeliveryAddressNote.setVisibility(isChecked ? View.GONE : View.VISIBLE);
            tilNote.setVisibility(isChecked ? View.GONE : View.VISIBLE);
            llDestinationAddress.setVisibility(isChecked ? View.GONE : View.VISIBLE);
            llDestinationAddress.setVisibility(isChecked ? View.GONE : View.VISIBLE);
        });
        etCustomerCountryCode = findViewById(R.id.etCustomerCountryCode);
        llSelfDelivery = findViewById(R.id.llSelfDelivery);
        btnInvoice.setOnClickListener(this);
        tvPromoCodeApply.setOnClickListener(this);
        ivDeliveryLocation.setOnClickListener(this);
        etCustomerDeliveryAddress.setOnClickListener(this);
        FieldValidation.setMaxPhoneNumberInputLength(this, etCustomerMobile);
        etCustomerCountryCode.setText(preferenceHelper.getCountryPhoneCode());
        llSelfDelivery.setVisibility(preferenceHelper.getIsProvidePickupDelivery() ? View.VISIBLE : View.GONE);
        tilNote = findViewById(R.id.tilNote);
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
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnInvoice) {
            if (isValidate()) {
                addItemInServerCart();
            }
        } else if (id == R.id.ivDeliveryLocation || id == R.id.etCustomerDeliveryAddress) {
            goToCheckoutDeliveryLocationActivity();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == Constant.DELIVERY_LIST_CODE) {
                if (CurrentBooking.getInstance().getDeliveryLatLng() != null) {
                    etCustomerDeliveryAddress.setText(CurrentBooking.getInstance().getDeliveryAddress());
                }
            }
        }
    }

    private void goToCheckoutDeliveryLocationActivity() {
        Intent intent = new Intent(this, CheckoutDeliveryLocationActivity.class);
        startActivityForResult(intent, Constant.DELIVERY_LIST_CODE);
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
        } else if (!cbSelfDelivery.isChecked() && (TextUtils.isEmpty(etCustomerDeliveryAddress.getText().toString().trim()) || CurrentBooking.getInstance().getDeliveryLatLng() == null)) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_delivery_address);
            Utilities.showToast(this, msg);
        }
        return TextUtils.isEmpty(msg);
    }

    /**
     * this method called webservice for add product in cart
     */
    private void addItemInServerCart() {
        Utilities.showCustomProgressDialog(this, false);

        CartOrder cartOrder = new CartOrder();
        cartOrder.setServerToken(preferenceHelper.getServerToken());
        cartOrder.setUserId("");
        cartOrder.setUserType(Constant.Type.STORE);
        cartOrder.setStoreId(preferenceHelper.getStoreId());
        cartOrder.setProducts(CurrentBooking.getInstance().getCartProductList());
        cartOrder.setAndroidId(preferenceHelper.getAndroidId());
        cartOrder.setUseItemTax(preferenceHelper.getIsUseItemTax());
        cartOrder.setTaxIncluded(preferenceHelper.getTaxIncluded());
        if (!TextUtils.isEmpty(preferenceHelper.getCartId())) {
            cartOrder.setCartId(preferenceHelper.getCartId());
        }

        // set destination address
        Addresses addresses = new Addresses();
        addresses.setCity(CurrentBooking.getInstance().getCity1());
        addresses.setAddressType(Constant.Type.DESTINATION);
        addresses.setNote(etDeliveryAddressNote.getText().toString());
        addresses.setUserType(Constant.Type.USER);
        addresses.setFlat_no(etFlatNo.getText().toString().trim());
        addresses.setStreet(etStreetNo.getText().toString().trim());
        addresses.setLandmark(etLandmark.getText().toString().trim());

        if (!cbSelfDelivery.isChecked()) {
            addresses.setAddress(CurrentBooking.getInstance().getDeliveryAddress());
            ArrayList<Double> location = new ArrayList<>();
            location.add(CurrentBooking.getInstance().getDeliveryLatLng().latitude);
            location.add(CurrentBooking.getInstance().getDeliveryLatLng().longitude);
            addresses.setLocation(location);
        } else {
            addresses.setAddress("self pickup");
            ArrayList<Double> location = new ArrayList<>();
            location.add(Double.valueOf(preferenceHelper.getLatitude()));
            location.add(Double.valueOf(preferenceHelper.getLongitude()));
            addresses.setLocation(location);
            addresses.setLocation(location);
        }

        UserDetail cartUserDetail = new UserDetail();
        cartUserDetail.setEmail(etCustomerEmail.getText().toString());
        cartUserDetail.setCountryPhoneCode(etCustomerCountryCode.getText().toString());
        cartUserDetail.setName(etCustomerFistName.getText().toString() + " " + etCustomerLastName.getText().toString());
        cartUserDetail.setPhone(etCustomerMobile.getText().toString());
        addresses.setUserDetails(cartUserDetail);
        CurrentBooking.getInstance().setDestinationAddresses(addresses);

        Addresses addresses1 = new Addresses();
        addresses1.setAddress(preferenceHelper.getAddress());
        addresses1.setCity("");
        addresses1.setAddressType(Constant.Type.PICKUP);
        addresses1.setNote("");
        addresses1.setUserType(Constant.Type.STORE);
        ArrayList<Double> location = new ArrayList<>();
        location.add(Double.valueOf(preferenceHelper.getLatitude()));
        location.add(Double.valueOf(preferenceHelper.getLongitude()));
        addresses1.setLocation(location);
        UserDetail cartUserDetail1 = new UserDetail();
        cartUserDetail1.setEmail(preferenceHelper.getEmail());
        cartUserDetail1.setCountryPhoneCode(preferenceHelper.getCountryPhoneCode());
        cartUserDetail1.setName(preferenceHelper.getName());
        cartUserDetail1.setImageUrl(preferenceHelper.getProfilePic());
        cartUserDetail1.setPhone(preferenceHelper.getPhone());
        addresses1.setUserDetails(cartUserDetail1);
        CurrentBooking.getInstance().setPickupAddresses(addresses1);

        cartOrder.setDestinationAddresses(CurrentBooking.getInstance().getDestinationAddresses());
        cartOrder.setPickupAddresses(CurrentBooking.getInstance().getPickupAddresses());

        double totalCartPrice = 0, totalCartTaxPrice = 0;
        for (CartProducts products : CurrentBooking.getInstance().getCartProductList()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            for (CartProductItems cartProductItems : products.getItems()) {
                totalTaxPrice = totalTaxPrice + cartProductItems.getTotalItemTax();
                totalItemPrice = totalItemPrice + cartProductItems.getTotalItemAndSpecificationPrice();
            }
            products.setTotalItemTax(totalTaxPrice);
            products.setTotalProductItemPrice(totalItemPrice);
            totalCartPrice = totalCartPrice + totalItemPrice;
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;
        }
        cartOrder.setCartOrderTotalPrice(totalCartPrice);
        cartOrder.setCartOrderTotalTaxPrice(totalCartTaxPrice);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.putCartId(response.body().getCartId());
                        CurrentBooking.getInstance().setCartCityId(response.body().getCityId());
                        CurrentBooking.getInstance().setCurrency(preferenceHelper.getCurrency());
                        goToOrderInvoiceActivity(response.body().getUserId());
                    } else {
                        if (response.body().getErrorCode() == Constant.TAXES_DETAILS_CHANGED) {
                            CurrentBooking.getInstance().clearCart();
                            goToHomeActivity();
                        } else {
                            ParseContent.getInstance().showErrorMessage(CheckoutActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
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

    private void goToOrderInvoiceActivity(String userId) {
        Intent intent = new Intent(this, OrderInvoiceActivity.class);
        intent.putExtra(Constant.IS_USER_PICK_UP_ORDER, cbSelfDelivery.isChecked());
        intent.putExtra(Constant.USER_ID, userId);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }
}