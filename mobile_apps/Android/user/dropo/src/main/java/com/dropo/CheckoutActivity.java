package com.dropo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.InvoiceAdapter;
import com.dropo.adapter.TableSpinnerAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomDialogVerification;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontCheckBox;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.component.CustomImageView;
import com.dropo.component.tag.TagLayout;
import com.dropo.fragments.PromoFragment;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.StoreClosedResult;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.models.datamodels.Table;
import com.dropo.models.datamodels.TableSettings;
import com.dropo.models.datamodels.TaxesDetail;
import com.dropo.models.datamodels.UnavailableItems;
import com.dropo.models.datamodels.Vehicle;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.InvoiceResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OtpResponse;
import com.dropo.models.responsemodels.TableBookingSettingsResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.models.validations.Validator;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.ScheduleHelper;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CheckoutActivity extends BaseAppCompatActivity implements TextView.OnEditorActionListener {

    private final List<StoreTime> storeTimes = new ArrayList<>();
    private final List<StoreTime> storeDeliveryTimes = new ArrayList<>();
    private final List<TaxesDetail> taxesDetails = new ArrayList<>();
    private CustomFontEditTextView etCustomerName, etCustomerLastName, etEmail, etCustomerMobile, etCustomerDeliveryAddress, etDeliveryAddressNote, etPromoCode, etCustomerCountryCode;
    private CustomFontButton btnPlaceOrder, btnQRPlaceOrder;
    private CustomFontTextViewTitle tvInvoiceOderTotal;
    private CustomFontTextView tvPromoCodeApply, tvReopenAt;
    private int totalItemCount = 0;
    private int totalSpecificationCount = 0;
    private double totalItemPriceWithQuantity = 0;
    private double totalSpecificationPriceWithQuantity = 0;
    private RecyclerView rcvInvoice;
    private CustomDialogVerification customDialogVerification;
    private Dialog dialogEmailOrPhoneVerification;
    private CustomFontEditTextView etDialogEditTextOne, etDialogEditTextTwo;
    private String phone, email;
    private ImageView ivFreeShipping;
    private EditText tvScheduleDate, tvScheduleTime, tvTableDate, tvTableTime;
    private LinearLayout llContactLess, llScheduleDate;
    private String serverTime;
    private CustomFontCheckBox cbSelfDelivery;
    private CustomFontCheckBox cbContactLess;
    private TextView cbAsps, cbScheduleOrder, cbTableBooking;
    private LinearLayout llSelfPickupDelivery;
    private CustomDialogAlert deliveryPriceConfirm;
    private String deliveryPriceStrings;
    private LinearLayout llTip, llDeliveryOrder, llTableBooking;
    private TextView ivConfirmDetail;
    private EditText etTipAmount;
    private double deliveryDistance;
    private int deliveryTime;
    private Store store;
    private View tvViewOffer;
    private TextInputLayout tilAddress, tilNote, tilCustomerLastName, tilEmail;
    private TagLayout tlTips;
    private TextInputLayout tilTipAmount;
    private FrameLayout flPromoCode;
    private LinearLayout llPromoCode;
    private TableSettings tableSettings;
    private Spinner spinnerNumberOfPeople, spinnerTableNumber;
    private TableSpinnerAdapter tableAdapter;
    private String otpEmailVerification, otpSmsVerification;
    private CustomDialogAlert unavailableCartItemsDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_checkout));
        initViewById();
        setViewListener();
        loadCheckOutData();
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
        } else if (TextUtils.isEmpty(etCustomerDeliveryAddress.getText().toString()) && !currentBooking.isTableBooking()) {
            msg = getString(R.string.msg_plz_enter_valid_place_address);
            etCustomerDeliveryAddress.setError(msg);
            etCustomerDeliveryAddress.requestFocus();
        } else if (currentBooking.isTableBooking() && tableAdapter != null && spinnerTableNumber.getSelectedItem() == null) {
            msg = getString(R.string.error_no_table_available_for_people);
            Utils.showToast(msg, CheckoutActivity.this);
        }
        return TextUtils.isEmpty(msg);
    }

    private boolean isValidateQRData() {
        String msg = null;
        Validator emailValidation = FieldValidation.isEmailValid(this, etEmail.getText().toString().trim());

        if (TextUtils.isEmpty(etCustomerName.getText().toString().trim())) {
            msg = getString(R.string.msg_please_enter_valid_name);
        } else if (FieldValidation.isValidPhoneNumber(this, etCustomerMobile.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(this);
        } else if (!etEmail.getText().toString().isEmpty() && !emailValidation.isValid()) {
            msg = getString(R.string.msg_please_enter_valid_email);
        }
        if (msg != null) {
            Utils.showToast(msg, this);
        }
        return TextUtils.isEmpty(msg);
    }

    private void clearError() {
        etCustomerName.setError(null);
        etCustomerMobile.setError(null);
        etCustomerLastName.setError(null);
        etCustomerDeliveryAddress.setError(null);
    }

    @Override
    protected void initViewById() {
        etCustomerName = findViewById(R.id.etCustomerName);
        etCustomerLastName = findViewById(R.id.etCustomerLastName);
        etEmail = findViewById(R.id.etEmail);
        tilCustomerLastName = findViewById(R.id.tilCustomerLastName);
        tilEmail = findViewById(R.id.tilEmail);
        etCustomerMobile = findViewById(R.id.etCustomerMobile);
        FieldValidation.setMaxPhoneNumberInputLength(this, etCustomerMobile);
        etCustomerDeliveryAddress = findViewById(R.id.etCustomerDeliveryAddress);
        etDeliveryAddressNote = findViewById(R.id.etDeliveryAddressNote);
        btnPlaceOrder = findViewById(R.id.btnPlaceOrder);
        btnQRPlaceOrder = findViewById(R.id.btnQRPlaceOrder);
        tvInvoiceOderTotal = findViewById(R.id.tvInvoiceOderTotal);
        rcvInvoice = findViewById(R.id.rcvInvoice);
        etPromoCode = findViewById(R.id.etPromoCode);
        tvPromoCodeApply = findViewById(R.id.tvPromoCodeApply);
        tvReopenAt = findViewById(R.id.tvReopenAt);
        ivFreeShipping = findViewById(R.id.ivFreeShipping);
        cbSelfDelivery = findViewById(R.id.cbSelfDelivery);
        llContactLess = findViewById(R.id.llContactLess);
        llScheduleDate = findViewById(R.id.llScheduleDate);
        tvScheduleDate = findViewById(R.id.tvScheduleDate);
        tvScheduleTime = findViewById(R.id.tvScheduleTime);
        etCustomerCountryCode = findViewById(R.id.etCustomerCountryCode);
        ivConfirmDetail = findViewById(R.id.ivConfirmDetail);
        cbScheduleOrder = findViewById(R.id.cbScheduleOrder);
        cbScheduleOrder.setTag(false);
        tvTableDate = findViewById(R.id.tvTableDate);
        tvTableTime = findViewById(R.id.tvTableTime);
        cbAsps = findViewById(R.id.cbAsps);
        cbTableBooking = findViewById(R.id.cbTableBooking);
        spinnerNumberOfPeople = findViewById(R.id.spinnerNumberOfPeople);
        spinnerTableNumber = findViewById(R.id.spinnerTableNumber);
        cbAsps.setTag(true);
        cbContactLess = findViewById(R.id.cbContactLess);
        FieldValidation.setMaxPhoneNumberInputLength(this, etCustomerMobile);
        llSelfPickupDelivery = findViewById(R.id.llSelfPickupDelivery);
        setEnableFiled(false);
        llTip = findViewById(R.id.llTip);
        llDeliveryOrder = findViewById(R.id.llDeliveryOrder);
        llTableBooking = findViewById(R.id.llTableBooking);
        tlTips = findViewById(R.id.tlTips);
        tilTipAmount = findViewById(R.id.tilTipAmount);
        etTipAmount = findViewById(R.id.etTipAmount);
        tvViewOffer = findViewById(R.id.tvViewOffer);
        tilAddress = findViewById(R.id.tilAddress);
        tilNote = findViewById(R.id.tilNote);
        flPromoCode = findViewById(R.id.flPromoCode);
        llPromoCode = findViewById(R.id.llPromoCode);
        if (currentBooking.isTableBooking()) {
            tilAddress.setVisibility(View.GONE);
            llTip.setVisibility(View.GONE);
            llTableBooking.setVisibility(View.VISIBLE);
            llDeliveryOrder.setVisibility(View.GONE);
            cbTableBooking.setTextColor(AppColor.COLOR_THEME);
            cbTableBooking.setTag(true);
            cbTableBooking.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeColorDrawable(R.drawable.ic_table_reservation, this), null, null, null);
            ArrayList<String> numberOfPeoples = new ArrayList<String>();
            numberOfPeoples.add("1");
            numberOfPeoples.add("2");
            numberOfPeoples.add("3");
            numberOfPeoples.add("4");
            numberOfPeoples.add("5");
            numberOfPeoples.add("6");
            numberOfPeoples.add("7");
            numberOfPeoples.add("8");
            numberOfPeoples.add("9");
            numberOfPeoples.add("10");
            TableSpinnerAdapter adapter = new TableSpinnerAdapter(this, numberOfPeoples);
            spinnerNumberOfPeople.setAdapter(adapter);
            spinnerNumberOfPeople.setSelection(numberOfPeoples.indexOf(String.valueOf(currentBooking.getNumberOfPerson())), false);
            spinnerNumberOfPeople.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    int people = Integer.parseInt(numberOfPeoples.get(position));
                    ArrayList<String> tablesNumber = new ArrayList<>();
                    for (Table table : tableSettings.getTableList()) {
                        if (people >= table.getTableMinPerson() && people <= table.getTableMaxPerson() && table.isIsUserCanBook() && table.isBusiness()) {
                            tablesNumber.add(table.getTableNo());
                        }
                    }
                    if (tablesNumber.isEmpty()) {
                        Utils.showToast(getString(R.string.error_no_table_available_for_people), CheckoutActivity.this);
                        tableAdapter.clear();
                        findViewById(R.id.tvTable).setVisibility(View.GONE);
                        tableAdapter.notifyDataSetChanged();
                    } else {
                        currentBooking.setNumberOfPerson(Integer.parseInt(numberOfPeoples.get(position)));
                        tableAdapter.clear();
                        findViewById(R.id.tvTable).setVisibility(View.VISIBLE);
                        tableAdapter.addAll(tablesNumber);
                        tableAdapter.notifyDataSetChanged();
                        spinnerTableNumber.setSelection(0);
                    }
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });
            if (currentBooking.isTableBooking()) {
                if (currentBooking.isBookTableForFuture()) {
                    if (currentBooking.getSchedule() != null) {
                        tvTableDate.setText(currentBooking.getSchedule().getScheduleDate());
                        tvTableTime.setText(currentBooking.getSchedule().getScheduleTime());
                    }
                } else {
                    tvTableDate.setText(currentBooking.getSchedule().dateFormat.format(new Date()));
                    String time = Calendar.getInstance().get(Calendar.HOUR_OF_DAY) + ":" + Calendar.getInstance().get(Calendar.MINUTE);
                    tvTableTime.setText(time);
                }
            }
        } else {
            if (currentBooking.isFutureOrder()) {
                currentBooking.getSchedule().removeScheduleTime("");
                tvTableTime.setText("");
            }
            llTableBooking.setVisibility(View.GONE);
        }
    }

    @Override
    protected void setViewListener() {
        tvPromoCodeApply.setEnabled(isCurrentLogin());
        etPromoCode.setEnabled(isCurrentLogin());
        btnPlaceOrder.setOnClickListener(this);
        btnQRPlaceOrder.setOnClickListener(this);
        tvViewOffer.setOnClickListener(this);
        tvPromoCodeApply.setOnClickListener(this);
        etPromoCode.setOnEditorActionListener(this);
        tvScheduleDate.setOnClickListener(this);
        tvScheduleTime.setOnClickListener(this);
        tvTableDate.setOnClickListener(this);
        tvTableTime.setOnClickListener(this);
        cbSelfDelivery.setOnCheckedChangeListener((buttonView, isChecked) -> checkIsPickUpDeliveryByUser(isChecked));
        ivConfirmDetail.setOnClickListener(this);
        cbAsps.setOnClickListener(this);
        cbScheduleOrder.setOnClickListener(this);

        etTipAmount.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                if (!etTipAmount.getText().toString().trim().isEmpty()) {
                    if (etTipAmount.getText().toString().equals("5")) {
                        tlTips.setCheckTag(1);
                    } else if (etTipAmount.getText().toString().equals("10")) {
                        tlTips.setCheckTag(2);
                    } else if (etTipAmount.getText().toString().equals("15")) {
                        tlTips.setCheckTag(3);
                    }
                    getDeliveryInvoice(deliveryTime, deliveryDistance, Double.parseDouble(etTipAmount.getText().toString()));
                    Utils.hideSoftKeyboard(CheckoutActivity.this);
                    etTipAmount.clearFocus();
                } else {
                    etTipAmount.setError(getString(R.string.error_enter_tip_amount));
                }
                return true;
            }
            return false;
        });
    }

    private void setEnableFiled(boolean isEnable) {
        etCustomerName.setFocusableInTouchMode(isEnable);
        etCustomerCountryCode.setFocusableInTouchMode(isEnable);
        etCustomerMobile.setFocusableInTouchMode(isEnable);
        etDeliveryAddressNote.setFocusableInTouchMode(isEnable);
        etCustomerLastName.setFocusableInTouchMode(isEnable);
        etEmail.setFocusableInTouchMode(isEnable);

        etCustomerName.setEnabled(isEnable);
        etCustomerLastName.setEnabled(isEnable);
        etCustomerCountryCode.setEnabled(isEnable);
        etCustomerMobile.setEnabled(isEnable);
        etDeliveryAddressNote.setEnabled(isEnable);
        etEmail.setEnabled(isEnable);
        etCustomerDeliveryAddress.setEnabled(!cbSelfDelivery.isChecked() && isEnable);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.cbAsps) {
            updateUiForOrderSelect(false);
            if (!TextUtils.isEmpty(serverTime)) {
                updateUIWhenStoreClosed(Utils.checkStoreOpenAndClosed(CheckoutActivity.this, storeTimes, serverTime, currentBooking.getTimeZone(), false, null));
            }
        } else if (id == R.id.cbScheduleOrder) {
            ScheduleHelper scheduleHelper = new ScheduleHelper(CurrentBooking.getInstance().getTimeZone());
            currentBooking.setSchedule(scheduleHelper);
            updateUiForOrderSelect(currentBooking.isFutureOrder());
        } else if (id == R.id.btnPlaceOrder) {
            if (preferenceHelper.getIsRegisterQRUser()) {
                preferenceHelper.putIsRegisterQRUser(false);
                preferenceHelper.logout();
            }
            goToPlaceOrder();
        } else if (id == R.id.btnQRPlaceOrder) {
            if (isValidateQRData()) {
                registerUserWithoutCredentials();
            }
        } else if (id == R.id.tvPromoCodeApply) {
            if (TextUtils.isEmpty(etPromoCode.getText().toString().trim())) {
                Utils.showToast(getResources().getString(R.string.msg_plz_enter_valid_promo_code), this);
            } else {
                promoApply(etPromoCode.getText().toString().trim());
            }
        } else if (id == R.id.tvScheduleDate || id == R.id.tvTableDate) {
            openDatePicker();
        } else if (id == R.id.tvScheduleTime || id == R.id.tvTableTime) {
            openTimePicker();
        } else if (id == R.id.tvViewOffer) {
            PromoFragment promoFragment = new PromoFragment();
            Bundle bundle = new Bundle();
            bundle.putString(Const.STORE_DETAIL, CurrentBooking.getInstance().getSelectedStoreId());
            promoFragment.setArguments(bundle);
            promoFragment.show(getSupportFragmentManager(), promoFragment.getTag());
        } else if (id == R.id.ivConfirmDetail) {
            if (cbSelfDelivery.isChecked() || preferenceHelper.getIsFromQRCode()) {
                showEditDeliveryDialog();
            } else {
                goToCheckoutDeliveryLocationActivity();
            }
        }
    }

    private void loadCheckOutData() {
        if (isCurrentLogin()) {
            etCustomerName.setText(String.format("%s %s", preferenceHelper.getFirstName(), preferenceHelper.getLastName()));
            if (preferenceHelper.getIsFromQRCode()) {
                etCustomerName.setText(preferenceHelper.getFirstName());
                etCustomerLastName.setText(preferenceHelper.getLastName());
            }
            etCustomerMobile.setText(preferenceHelper.getPhoneNumber());
            etEmail.setText(preferenceHelper.getEmail());
            if (currentBooking.isTableBooking()) {
                btnPlaceOrder.setText(getString(R.string.btn_complete_reservation));
            } else {
                btnPlaceOrder.setText(getResources().getString(R.string.text_place_order));
            }
        } else {
            btnPlaceOrder.setText(getResources().getString(R.string.text_login));
        }
        if (currentBooking.getPickupAddresses() != null && !currentBooking.getPickupAddresses().isEmpty()) {
            etCustomerCountryCode.setText(currentBooking.getPickupAddresses().get(0).getUserDetails().getCountryPhoneCode());
        }
        etCustomerDeliveryAddress.setText(currentBooking.getDeliveryAddress());
        if (currentBooking.isPromoApply()) {
            flPromoCode.setVisibility(View.VISIBLE);
            llPromoCode.setVisibility(View.VISIBLE);
        }

        calculateItemsTaxes();

        if (currentBooking.isTableBooking()) {
            getBookingSettings();
        } else {
            checkIsPickUpDeliveryByUser(cbSelfDelivery.isChecked());
        }

        if (preferenceHelper.getIsFromQRCode()) {
            cbScheduleOrder.setVisibility(View.GONE);
            llSelfPickupDelivery.setVisibility(View.GONE);
            tilAddress.setVisibility(View.GONE);
            tilNote.setVisibility(View.GONE);

            ((CustomFontTextViewTitle) findViewById(R.id.tag2)).setText(getString(R.string.text_user_details));
            btnQRPlaceOrder.setVisibility(isCurrentLogin() ? View.GONE : View.VISIBLE);
            tilCustomerLastName.setVisibility(View.VISIBLE);
            tilEmail.setVisibility(View.VISIBLE);
        } else {
            tilCustomerLastName.setVisibility(View.GONE);
            tilEmail.setVisibility(View.GONE);
        }
    }

    /**
     * Used to calculate cart item taxes
     */
    private void calculateItemsTaxes() {
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                if (currentBooking.isUseItemTax()) {
                    for (TaxesDetail taxesDetail : cartProductItems.getTaxesDetails()) {
                        if (taxesDetails.isEmpty()) {
                            taxesDetail.setTaxAmount(taxesDetail.getTax());
                            taxesDetails.add(taxesDetail);
                        } else {
                            boolean isAlreadyAdded = false;
                            for (TaxesDetail detail : taxesDetails) {
                                if (detail.getId().equals(taxesDetail.getId())) {
                                    isAlreadyAdded = true;
                                    detail.setTaxAmount(detail.getTaxAmount() + taxesDetail.getTax());
                                }
                            }
                            if (!isAlreadyAdded) {
                                taxesDetail.setTaxAmount(taxesDetail.getTax());
                                taxesDetails.add(taxesDetail);
                            }
                        }
                    }
                } else {
                    if (currentBooking != null && currentBooking.getTaxesDetails() != null) {
                        for (TaxesDetail taxesDetail : currentBooking.getTaxesDetails()) {
                            if (taxesDetails.isEmpty()) {
                                taxesDetail.setTaxAmount(taxesDetail.getTax());
                                taxesDetails.add(taxesDetail);
                            } else {
                                boolean isAlreadyAdded = false;
                                for (TaxesDetail detail : taxesDetails) {
                                    if (detail.getId().equals(taxesDetail.getId())) {
                                        isAlreadyAdded = true;
                                        detail.setTaxAmount(detail.getTaxAmount() + taxesDetail.getTax());
                                    }
                                }
                                if (!isAlreadyAdded) {
                                    taxesDetail.setTaxAmount(taxesDetail.getTax());
                                    taxesDetails.add(taxesDetail);
                                }
                            }
                        }
                    }
                }
                totalItemPriceWithQuantity = totalItemPriceWithQuantity + (cartProductItems.getItemPrice() * cartProductItems.getQuantity());
                totalSpecificationPriceWithQuantity = totalSpecificationPriceWithQuantity + (cartProductItems.getTotalSpecificationPrice() * cartProductItems.getQuantity());
                totalItemCount = totalItemCount + cartProductItems.getQuantity();
                for (Specifications specifications : cartProductItems.getSpecifications()) {
                    totalSpecificationCount = totalSpecificationCount + specifications.getList().size();
                }
            }
        }
    }

    private void checkIsPickUpDeliveryByUser(boolean isChecked) {
        if (isChecked) {
            etDeliveryAddressNote.getText().clear();
        }
        etDeliveryAddressNote.setVisibility(isChecked ? View.GONE : View.VISIBLE);
        etCustomerDeliveryAddress.setEnabled(!isChecked && etCustomerName.isEnabled());
        if (!currentBooking.getDestinationAddresses().isEmpty() && !isChecked && !currentBooking.isTableBooking()) {
            getDistanceMatrix();
        } else {
            getDeliveryInvoice(0, 0, 0);
        }
        if (currentBooking.isTableBooking()) {
            tilAddress.setVisibility(View.GONE);
            ivConfirmDetail.setVisibility(View.GONE);
            tilNote.setVisibility(View.VISIBLE);
            tilNote.setHint(getString(R.string.hint_special_request_note));
            ((CustomFontTextViewTitle) findViewById(R.id.tag2)).setText(getString(R.string.text_reservation_details));
            setEnableFiled(true);
        } else {
            tilAddress.setVisibility(isChecked ? View.GONE : View.VISIBLE);
            tilNote.setVisibility(isChecked ? View.GONE : View.VISIBLE);
        }
    }

    /**
     * this method called a webservice for get distance and time witch is provided by Google
     */
    private void getDistanceMatrix() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, String> hashMap = new HashMap<>();
        String origins = currentBooking.getPickupAddresses().get(0).getLocation().get(0) + "," + currentBooking.getPickupAddresses().get(0).getLocation().get(1);
        hashMap.put(Const.Google.ORIGINS, origins);
        String destination = currentBooking.getDeliveryLatLng().latitude + "," + currentBooking.getDeliveryLatLng().longitude;
        hashMap.put(Const.Google.DESTINATIONS, destination);
        hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());

        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> call = apiInterface.getGoogleDistanceMatrix(hashMap);
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsDistanceMatrix(response);
                if (map != null && !map.isEmpty()) {
                    String distance = map.get(Const.Google.DISTANCE);
                    String timeSecond = map.get(Const.Google.DURATION);
                    deliveryDistance = Double.parseDouble(distance);
                    deliveryTime = Integer.parseInt(timeSecond);
                    getDeliveryInvoice(deliveryTime, deliveryDistance, 0);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CHECKOUT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called a webservice to get delivery invoice or bill
     */
    private void getDeliveryInvoice(int timeSeconds, double tripDistance, double tipAmount) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.IS_USER_PICK_UP_ORDER, cbSelfDelivery.isChecked());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.ORDER_TYPE, Const.Type.USER);
        map.put(Const.Params.STORE_ID, currentBooking.getSelectedStoreId());
        map.put(Const.Params.TOTAL_ITEM_COUNT, totalItemCount);
        map.put(Const.Params.TOTAL_CART_PRICE, currentBooking.getTotalCartAmount());
        map.put(Const.Params.TOTAL_ITEM_PRICE, totalItemPriceWithQuantity);
        map.put(Const.Params.TOTAL_SPECIFICATION_PRICE, totalSpecificationPriceWithQuantity);
        map.put(Const.Params.TOTAL_DISTANCE, tripDistance);
        map.put(Const.Params.TOTAL_TIME, timeSeconds);
        map.put(Const.Params.TOTAL_SPECIFICATION_COUNT, totalSpecificationCount);
        map.put(Const.Params.TIP_AMOUNT, tipAmount);
        map.put(Const.Params.IS_USE_ITEM_TAX, currentBooking.isUseItemTax());
        map.put(Const.Params.IS_TAX_INCLUDED, currentBooking.isTaxIncluded());
        map.put(Const.Params.TOTAL_CART_AMOUNT_WITHOUT_TAX, currentBooking.getTotalCartAmountWithoutTax());
        map.put(Const.Params.TAX_DETAILS, taxesDetails);
        if (currentBooking.isTableBooking()) {
            map.put(Const.Params.TABLE_NO, currentBooking.getTableNumber());
            map.put(Const.Params.NO_OF_PERSONS, currentBooking.getNumberOfPerson());
            map.put(Const.Params.DELIVERY_TYPE, currentBooking.getDeliveryType());
            map.put(Const.Params.BOOKING_TYPE, currentBooking.getTableBookingType());
            map.put(Const.Params.BOOKING_FEES, currentBooking.getBookingFee());
        }
        if (isCurrentLogin()) {
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        } else {
            map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> responseCall = apiInterface.getDeliveryInvoice(map);
        responseCall.enqueue(new Callback<InvoiceResponse>() {
            @SuppressLint("StringFormatInvalid")
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull final Response<InvoiceResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (Objects.requireNonNull(response.body()).isSuccess()) {
                        store = response.body().getStore();
                        List<Vehicle> vehicleList = response.body().getVehicleList();
                        if (vehicleList != null && !vehicleList.isEmpty()) {
                            deliveryPriceStrings = getResources().getString(R.string.msg_delivery_price_confrim, vehicleList.get(0).getVehicleName());
                        } else {
                            deliveryPriceStrings = "";
                        }

                        setInvoiceData(response);
                        updateUiTip(response.body().isAllowUserToGiveTip() && !cbSelfDelivery.isChecked() && !currentBooking.isTableBooking(), response.body().getTipType(), tipAmount);
                        Utils.showMessageToast(response.body().getStatusPhrase(), CheckoutActivity.this);
                        storeTimes.clear();
                        storeTimes.addAll(response.body().getStore().getStoreTime());
                        serverTime = response.body().getServerTime();

                        if (!currentBooking.isTableBooking()) {
                            storeDeliveryTimes.clear();
                            storeDeliveryTimes.addAll(response.body().getStore().getStoreDeliveryTime());
                        }

                        if (response.body().getOrderPayment().isStorePayDeliveryFees() && !cbSelfDelivery.isChecked()) {
                            ivFreeShipping.setVisibility(View.VISIBLE);
                        } else {
                            ivFreeShipping.setVisibility(View.GONE);
                        }

                        if (!preferenceHelper.getIsFromQRCode() && cbSelfDelivery.isEnabled()) {
                            llSelfPickupDelivery.setVisibility(store.isProvidePickupDelivery() ? View.VISIBLE : View.GONE);
                            if (store.isProvidePickupDelivery() && !store.isProvideDelivery()) {
                                cbSelfDelivery.setChecked(true);
                                cbSelfDelivery.setEnabled(false);
                            }
                        }

                        if (response.body().isAllowContaclLessDelivery() && !store.isProvidePickupDelivery()) {
                            llContactLess.setVisibility(View.VISIBLE);
                        } else {
                            llContactLess.setVisibility(View.GONE);
                        }
                        // check store provide schedule order or schedule slot other wise hide
                        // schedule button
                        if (store.isTakingScheduleOrder() || (currentBooking.isTableBooking() && currentBooking.isBookTableForFuture())) {
                            updateUiForOrderSelect(currentBooking.isFutureOrder());
                            if (!preferenceHelper.getIsFromQRCode()) {
                                cbScheduleOrder.setVisibility(View.VISIBLE);
                            }
                            StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(CheckoutActivity.this, storeTimes, serverTime, currentBooking.getTimeZone(), currentBooking.isFutureOrder(), currentBooking.isFutureOrder() ? currentBooking.getSchedule().getScheduleCalendar() : null);
                            updateUIWhenStoreClosed(storeClosedResult);
                        } else {
                            updateUiForOrderSelect(false);
                            currentBooking.setSchedule(null);
                            cbScheduleOrder.setVisibility(View.GONE);
                            updateUIWhenStoreClosed(Utils.checkStoreOpenAndClosed(CheckoutActivity.this, storeTimes, serverTime, currentBooking.getTimeZone(), false, null));
                        }
                        if (!TextUtils.isEmpty(etPromoCode.getText())) {
                            promoApply(etPromoCode.getText().toString());
                        }

                        if (response.body().getUnavailableItems() != null && !response.body().getUnavailableItems().isEmpty()) {
                            showUnavailableCartItemsDialog(response.body().getUnavailableItems(), response.body().getUnavailableProducts());
                        }
                    } else {
                        btnPlaceOrder.setVisibility(View.GONE);
                        if (Const.MINIMUM_ORDER_AMOUNT == response.body().getErrorCode()) {
                            String message = getResources().getString(R.string.msg_minimum_order_amount) + " " + currentBooking.getCartCurrency() + response.body().getMinOrderPrice();
                            CustomDialogAlert customDialogAlert = new CustomDialogAlert(CheckoutActivity.this, getResources().getString(R.string.text_alert), message, getResources().getString(R.string.text_ok)) {
                                @Override
                                public void onClickLeftButton() {

                                }

                                @Override
                                public void onClickRightButton() {
                                    dismiss();
                                    CheckoutActivity.this.onBackPressed();
                                }
                            };
                            customDialogAlert.show();
                        } else if (Const.STORE_DELIVERY_RADIUS == response.body().getErrorCode()) {
                            String message = getResources().getString(R.string.msg_no_delivery_on_address);
                            CustomDialogAlert customDialogAlert = new CustomDialogAlert(CheckoutActivity.this, getResources().getString(R.string.text_attention), message, getResources().getString(R.string.text_i_ll_pickup)) {
                                @Override
                                public void onClickLeftButton() {
                                    dismiss();
                                    setEnableFiled(true);
                                }

                                @Override
                                public void onClickRightButton() {
                                    dismiss();
                                    cbSelfDelivery.setChecked(true);

                                }
                            };
                            customDialogAlert.show();
                            customDialogAlert.btnDialogEditTextRight.setVisibility(View.GONE);
                        } else if (Const.TAXES_DETAILS_CHANGED == response.body().getErrorCode()) {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                            clearCart();
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CHECKOUT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * Unavailable item dialog
     */
    private void showUnavailableCartItemsDialog(List<UnavailableItems> unavailableItemsList, List<UnavailableItems> unavailableProductsList) {
        if (unavailableCartItemsDialog != null && unavailableCartItemsDialog.isShowing() && !isFinishing()) {
            return;
        }

        StringBuilder message = new StringBuilder();
        message.append(getString(R.string.text_following_items_are_not_available)).append("\n\n");
        for (int i = 0; i < unavailableItemsList.size(); i++) {
            if (unavailableItemsList.size() - 1 == i) {
                message.append(unavailableItemsList.get(i).getItemName());
            } else {
                message.append(unavailableItemsList.get(i).getItemName()).append(", ");
            }
        }

        unavailableCartItemsDialog = new CustomDialogAlert(this, getString(R.string.text_alert), message.toString(), getString(R.string.text_remove_and_continue)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                removeUnavailableItemsFromCart(unavailableProductsList);
            }
        };

        unavailableCartItemsDialog.show();
    }

    /**
     * remove unavailable items from cart
     */
    private void removeUnavailableItemsFromCart(List<UnavailableItems> unavailableProductsList) {
        List<String> productIds = new ArrayList<>();

        for (UnavailableItems unavailableItems : unavailableProductsList) {
            if (!productIds.contains(unavailableItems.getProductId())) {
                productIds.add(unavailableItems.getProductId());
            }
        }

        for (Iterator<CartProducts> iterator = currentBooking.getCartProductWithSelectedSpecificationList().iterator(); iterator.hasNext(); ) {
            CartProducts fruit = iterator.next();
            if (productIds.contains(fruit.getProductId())) {
                iterator.remove();
            }
        }

        calculateItemsTaxes();

        if (currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
            clearCart();
        } else {
            addItemInServerCart(false);
        }
    }

    private void updateUIWhenStoreClosed(StoreClosedResult storeClosedResult) {
        if (storeClosedResult.isStoreClosed()) {
            btnPlaceOrder.setVisibility(View.GONE);
            tvReopenAt.setVisibility(View.VISIBLE);
            tvReopenAt.setText(storeClosedResult.getReOpenAt());
        } else {
            btnPlaceOrder.setVisibility(View.VISIBLE);
            tvReopenAt.setVisibility(View.GONE);
        }
    }

    @Override
    public void onBackPressed() {
        if (currentBooking.isTableBooking()) {
            openClearCartDialog();
        } else {
            super.onBackPressed();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        }
    }

    private void setInvoiceData(Response<InvoiceResponse> response) {
        OrderPayment orderPayment = response.body().getOrderPayment();
        orderPayment.setTaxIncluded(response.body().isTaxIncluded());
        String currency = currentBooking.getCartCurrency();

        rcvInvoice.setLayoutManager(new LinearLayoutManager(this));
        rcvInvoice.setNestedScrollingEnabled(false);
        rcvInvoice.setAdapter(new InvoiceAdapter(parseContent.parseInvoice(orderPayment, currentBooking.getCartCurrency(), true)));
        currentBooking.setTotalInvoiceAmount(orderPayment.getUserPayPayment());
        tvInvoiceOderTotal.setText(String.format("%s%s", currency, parseContent.decimalTwoDigitFormat.format(currentBooking.getTotalInvoiceAmount())));
    }

    /**
     * this method called a webservice when promo code is apply
     *
     * @param promoCode set by user
     */
    private void promoApply(String promoCode) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.ORDER_PAYMENT_ID, currentBooking.getOrderPaymentId());
        map.put(Const.Params.PROMO_CODE_NAME, promoCode);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> responseCall = apiInterface.applyPromoCode(map);
        responseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull Response<InvoiceResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        setInvoiceData(response);
                        Utils.showMessageToast(response.body().getStatusPhrase(), CheckoutActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CHECKOUT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etPromoCode) {
            if (i == EditorInfo.IME_ACTION_DONE) {
                if (TextUtils.isEmpty(etPromoCode.getText().toString().trim())) {
                    Utils.showToast(getResources().getString(R.string.msg_plz_enter_valid_promo_code), this);
                } else {
                    promoApply(etPromoCode.getText().toString().trim());
                }
                return true;
            }
        }

        return false;
    }

    private void registerUserWithoutCredentials() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.STORE_ID, store.getId());
        map.put(Const.Params.FIRST_NAME, etCustomerName.getText().toString().trim());
        map.put(Const.Params.LAST_NAME, etCustomerLastName.getText().toString().trim());
        map.put(Const.Params.COUNTRY_PHONE_CODE, etCustomerCountryCode.getText().toString().trim());
        map.put(Const.Params.PHONE, etCustomerMobile.getText().toString().trim());
        map.put(Const.Params.EMAIL, etEmail.getText().toString().trim());
        map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<UserDataResponse> responseCall = apiInterface.registerUserWithoutCredentials(map);
        responseCall.enqueue(new Callback<UserDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<UserDataResponse> call, @NonNull Response<UserDataResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.parseUserStorageData(response)) {
                    preferenceHelper.putIsRegisterQRUser(true);
                    goToPaymentActivity(true);
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<UserDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void showEditDeliveryDialog() {
        BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_edit_delivery_details);

        CustomFontTextViewTitle tvDialogAlertTitle = dialog.findViewById(R.id.tvDialogAlertTitle);
        CustomFontEditTextView etCustomerName = dialog.findViewById(R.id.etCustomerName);
        CustomFontEditTextView etCustomerCountryCode = dialog.findViewById(R.id.etCustomerCountryCode);
        CustomFontEditTextView etCustomerMobile = dialog.findViewById(R.id.etCustomerMobile);
        CustomFontEditTextView etCustomerLastName = dialog.findViewById(R.id.etCustomerLastName);
        CustomFontEditTextView etEmail = dialog.findViewById(R.id.etEmail);

        View cvLastName = dialog.findViewById(R.id.cvLastName);
        View cvEmail = dialog.findViewById(R.id.cvEmail);

        etCustomerName.setText(this.etCustomerName.getText().toString());
        etCustomerCountryCode.setText(this.etCustomerCountryCode.getText().toString());
        etCustomerMobile.setText(this.etCustomerMobile.getText().toString());

        if (preferenceHelper.getIsFromQRCode()) {
            etCustomerName.setHint(getString(R.string.text_first_name));
            tvDialogAlertTitle.setText(getString(R.string.text_user_details));

            etCustomerLastName.setText(this.etCustomerLastName.getText().toString());
            etEmail.setText(this.etEmail.getText().toString());
        } else {
            cvLastName.setVisibility(View.GONE);
            cvEmail.setVisibility(View.GONE);
        }

        dialog.findViewById(R.id.btnClose).setOnClickListener(v -> dialog.dismiss());
        dialog.findViewById(R.id.btnUpdate).setOnClickListener(v -> {
            String msg;
            etCustomerName.setError(null);
            etCustomerMobile.setError(null);
            etCustomerLastName.setError(null);
            etEmail.setError(null);

            if (!preferenceHelper.getIsFromQRCode()) {
                if (TextUtils.isEmpty(etCustomerName.getText().toString().trim())) {
                    msg = getString(R.string.msg_please_enter_valid_name);
                    etCustomerName.setError(msg);
                    etCustomerName.requestFocus();
                } else if (FieldValidation.isValidPhoneNumber(CheckoutActivity.this, etCustomerMobile.getText().toString())) {
                    msg = FieldValidation.getPhoneNumberValidationMessage(CheckoutActivity.this);
                    etCustomerMobile.setError(msg);
                    etCustomerMobile.requestFocus();
                } else {
                    this.etCustomerName.setText(etCustomerName.getText().toString());
                    this.etCustomerCountryCode.setText(etCustomerCountryCode.getText().toString());
                    this.etCustomerMobile.setText(etCustomerMobile.getText().toString());
                    dialog.dismiss();
                }
            } else {
                Validator emailValidation = FieldValidation.isEmailValid(this, etEmail.getText().toString().trim());

                if (TextUtils.isEmpty(etCustomerName.getText().toString().trim())) {
                    msg = getString(R.string.msg_please_enter_valid_name);
                    etCustomerName.setError(msg);
                    etCustomerName.requestFocus();
                } else if (TextUtils.isEmpty(etCustomerLastName.getText().toString().trim())) {
                    msg = getString(R.string.msg_please_enter_valid_name);
                    etCustomerLastName.setError(msg);
                    etCustomerLastName.requestFocus();
                } else if (FieldValidation.isValidPhoneNumber(CheckoutActivity.this, etCustomerMobile.getText().toString())) {
                    msg = FieldValidation.getPhoneNumberValidationMessage(CheckoutActivity.this);
                    etCustomerMobile.setError(msg);
                    etCustomerMobile.requestFocus();
                } else if (!etEmail.getText().toString().isEmpty()
                        && !emailValidation.isValid()) {
                    msg = getString(R.string.msg_please_enter_valid_email);
                    etEmail.setError(msg);
                    etEmail.requestFocus();
                } else {
                    this.etCustomerName.setText(etCustomerName.getText().toString());
                    this.etCustomerLastName.setText(etCustomerLastName.getText().toString());
                    this.etCustomerCountryCode.setText(etCustomerCountryCode.getText().toString());
                    this.etCustomerMobile.setText(etCustomerMobile.getText().toString());
                    this.etEmail.setText(etEmail.getText().toString());
                    dialog.dismiss();
                }
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

    private void goToCheckoutDeliveryLocationActivity() {
        Intent intent = new Intent(this, CheckoutDeliveryLocationActivity.class);
        intent.putExtra(Const.REQUEST_CODE, Const.DELIVERY_LIST_CODE);
        intent.putExtra(Const.Params.ADDRESS, currentBooking.getDeliveryAddress());
        intent.putExtra(Const.Params.LOCATION, currentBooking.getDeliveryLatLng());
        intent.putExtra(Const.Params.NAME, etCustomerName.getText().toString());
        intent.putExtra(Const.Params.COUNTRY_PHONE_CODE, etCustomerCountryCode.getText().toString());
        intent.putExtra(Const.Params.PHONE, etCustomerMobile.getText().toString());
        intent.putExtra(Const.Params.NOTE_FOR_DELIVERYMAN, etDeliveryAddressNote.getText().toString());
        startActivityForResult(intent, Const.DELIVERY_LIST_CODE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case Const.DELIVERY_LIST_CODE:
                    if (!currentBooking.getDestinationAddresses().isEmpty()) {
                        etCustomerDeliveryAddress.setText(currentBooking.getDeliveryAddress());
                        etCustomerName.setText(data.getExtras().getString(Const.Params.NAME));
                        etCustomerCountryCode.setText(data.getExtras().getString(Const.Params.COUNTRY_PHONE_CODE));
                        etCustomerMobile.setText(data.getExtras().getString(Const.Params.PHONE));
                        etDeliveryAddressNote.setText(data.getExtras().getString(Const.Params.NOTE_FOR_DELIVERYMAN));

                        if (isValidate()) {
                            setEnableFiled(false);
                            etPromoCode.requestFocus();
                            addItemInServerCart(false);
                        }
                    }
                    break;
                case Const.LOGIN_REQUEST:
                case Const.DOCUMENT_REQUEST:
                    if (currentBooking.isTableBooking()) {
                        btnPlaceOrder.setText(getString(R.string.btn_complete_reservation));
                    } else {
                        btnPlaceOrder.setText(getResources().getString(R.string.text_place_order));
                    }
                    if (preferenceHelper.getIsFromQRCode() && isCurrentLogin()) {
                        btnQRPlaceOrder.setVisibility(View.GONE);
                    }
                    tvPromoCodeApply.setEnabled(isCurrentLogin());
                    etPromoCode.setEnabled(isCurrentLogin());
                    getUserDetail();
                    break;
                default:
                    // do with default
                    break;
            }
        }
    }

    /**
     * this method called a webservice for get user detail
     */
    private void getUserDetail() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.APP_VERSION, getAppVersion());
        map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<UserDataResponse> responseCall = apiInterface.getUserDetail(map);
        responseCall.enqueue(new Callback<UserDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<UserDataResponse> call, @NonNull Response<UserDataResponse> response) {
                if (parseContent.parseUserStorageData(response)) {
                    etCustomerName.setText(String.format("%s %s", preferenceHelper.getFirstName(), preferenceHelper.getLastName()));
                    etCustomerMobile.setText(preferenceHelper.getPhoneNumber());
                    etEmail.setText(preferenceHelper.getEmail());
                    addItemInServerCart(false);
                    checkDocumentUploadAndApproved();
                }
            }

            @Override
            public void onFailure(@NonNull Call<UserDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(CheckoutActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void checkDocumentUploadAndApproved() {
        if (preferenceHelper.getIsApproved()) {
            closedAdminApprovedDialog();
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivityForResult(this, true, true);
            } else {
                if (currentBooking.isHaveOrders()) {
                    openEmailOrPhoneConfirmationDialog(getResources().getString(R.string.text_confirm_detail), getResources().getString(R.string.msg_plz_confirm_your_detail), getResources().getString(R.string.text_ok));
                }
            }
        } else {
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivityForResult(this, true, true);
            } else {
                openAdminApprovedDialog();
            }
        }
    }

    /**
     * this method open dialog which confirm user email or mobile detail
     *
     * @param titleDialog      set dialog title
     * @param messageDialog    set dialog message
     * @param titleRightButton set dialog right button text
     */
    private void openEmailOrPhoneConfirmationDialog(String titleDialog, String messageDialog, String titleRightButton) {
        CustomFontTextView tvDialogEdiTextMessage;

        CustomFontButton btnDialogEditTextRight;
        CustomImageView btnDialogEditTextLeft;
        TextInputLayout dialogItlOne;
        LinearLayout llConfirmationPhone;
        CustomFontEditTextView etRegisterCountryCode;
        CustomFontTextViewTitle tvDialogEditTextTitle;

        if (customDialogVerification != null && customDialogVerification.isShowing() || dialogEmailOrPhoneVerification != null && dialogEmailOrPhoneVerification.isShowing()) {
            return;
        }
        dialogEmailOrPhoneVerification = new Dialog(this);
        dialogEmailOrPhoneVerification.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialogEmailOrPhoneVerification.setContentView(R.layout.dialog_confrimation_email_or_phone);

        tvDialogEdiTextMessage = dialogEmailOrPhoneVerification.findViewById(R.id.tvDialogAlertMessage);
        tvDialogEditTextTitle = dialogEmailOrPhoneVerification.findViewById(R.id.tvDialogAlertTitle);
        btnDialogEditTextLeft = dialogEmailOrPhoneVerification.findViewById(R.id.btnDialogAlertLeft);
        btnDialogEditTextRight = dialogEmailOrPhoneVerification.findViewById(R.id.btnDialogAlertRight);
        etDialogEditTextOne = dialogEmailOrPhoneVerification.findViewById(R.id.etDialogEditTextOne);
        etDialogEditTextTwo = dialogEmailOrPhoneVerification.findViewById(R.id.etDialogEditTextTwo);
        etRegisterCountryCode = dialogEmailOrPhoneVerification.findViewById(R.id.etRegisterCountryCode);
        etDialogEditTextOne.setText(preferenceHelper.getEmail());
        etDialogEditTextTwo.setText(preferenceHelper.getPhoneNumber());
        etRegisterCountryCode.setText(preferenceHelper.getCountryPhoneCode());

        llConfirmationPhone = dialogEmailOrPhoneVerification.findViewById(R.id.llConfirmationPhone);
        dialogItlOne = dialogEmailOrPhoneVerification.findViewById(R.id.dialogItlOne);

        btnDialogEditTextLeft.setOnClickListener(this);
        btnDialogEditTextRight.setOnClickListener(this);

        tvDialogEditTextTitle.setText(titleDialog);
        tvDialogEdiTextMessage.setText(messageDialog);
        btnDialogEditTextRight.setText(titleRightButton);

        btnDialogEditTextRight.setOnClickListener(view -> {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.ID, preferenceHelper.getUserId());
            map.put(Const.Params.TYPE, String.valueOf(Const.Type.USER));
            switch (checkWitchOtpValidationON()) {
                case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                    if (Patterns.EMAIL_ADDRESS.matcher(etDialogEditTextOne.getText().toString()).matches()) {
                        if (FieldValidation.isValidPhoneNumber(CheckoutActivity.this, etDialogEditTextTwo.getText().toString())) {
                            etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(CheckoutActivity.this));
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_error_mobile_number));
                            etDialogEditTextTwo.requestFocus();
                        } else {
                            map.put(Const.Params.EMAIL, etDialogEditTextOne.getText().toString());
                            map.put(Const.Params.PHONE, etDialogEditTextTwo.getText().toString());
                            map.put(Const.Params.COUNTRY_PHONE_CODE, preferenceHelper.getCountryPhoneCode());
                            dialogEmailOrPhoneVerification.dismiss();
                            email = etDialogEditTextOne.getText().toString();
                            phone = etDialogEditTextTwo.getText().toString();
                            getOtpVerify(map);
                        }
                    } else {
                        etDialogEditTextOne.setError(getResources().getString(R.string.msg_please_enter_valid_email));
                    }
                    break;
                case Const.SMS_VERIFICATION_ON:
                    if (FieldValidation.isValidPhoneNumber(CheckoutActivity.this, etDialogEditTextTwo.getText().toString())) {
                        etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(CheckoutActivity.this));
                        etDialogEditTextTwo.setError(getResources().getString(R.string.msg_error_mobile_number));
                        etDialogEditTextTwo.requestFocus();
                    } else {
                        map.put(Const.Params.PHONE, etDialogEditTextTwo.getText().toString());
                        map.put(Const.Params.COUNTRY_PHONE_CODE, preferenceHelper.getCountryPhoneCode());
                        dialogEmailOrPhoneVerification.dismiss();
                        phone = etDialogEditTextTwo.getText().toString();
                        getOtpVerify(map);
                    }
                    break;
                case Const.EMAIL_VERIFICATION_ON:
                    if (Patterns.EMAIL_ADDRESS.matcher(etDialogEditTextOne.getText().toString()).matches()) {
                        map.put(Const.Params.EMAIL, etDialogEditTextOne.getText().toString());
                        dialogEmailOrPhoneVerification.dismiss();
                        email = etDialogEditTextOne.getText().toString();
                        getOtpVerify(map);
                    } else {
                        etDialogEditTextOne.setError(getResources().getString(R.string.msg_please_enter_valid_email));
                    }
                    break;
                default:
                    break;
            }

        });
        btnDialogEditTextLeft.setOnClickListener(view -> {
            logOut(false);
            dialogEmailOrPhoneVerification.dismiss();
        });
        WindowManager.LayoutParams params = dialogEmailOrPhoneVerification.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialogEmailOrPhoneVerification.setCancelable(false);

        switch (checkWitchOtpValidationON()) {
            case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                etDialogEditTextOne.setVisibility(View.VISIBLE);
                dialogItlOne.setVisibility(View.VISIBLE);
                llConfirmationPhone.setVisibility(View.VISIBLE);
                dialogEmailOrPhoneVerification.show();
                break;
            case Const.EMAIL_VERIFICATION_ON:
                etDialogEditTextOne.setVisibility(View.VISIBLE);
                dialogItlOne.setVisibility(View.VISIBLE);
                llConfirmationPhone.setVisibility(View.GONE);
                dialogEmailOrPhoneVerification.show();
                break;
            case Const.SMS_VERIFICATION_ON:
                etDialogEditTextOne.setVisibility(View.GONE);
                dialogItlOne.setVisibility(View.GONE);
                llConfirmationPhone.setVisibility(View.VISIBLE);
                dialogEmailOrPhoneVerification.show();
                break;
            default:
                etDialogEditTextOne.setVisibility(View.GONE);
                dialogItlOne.setVisibility(View.GONE);
                llConfirmationPhone.setVisibility(View.GONE);
                break;
        }
    }

    /**
     * this method open dialog which is help to verify OTP witch is send to email or mobile
     *
     * @param editTextOneHint      set hint text in edittext one
     * @param ediTextTwoHint       set hint text in edittext two
     * @param isEditTextOneVisible set true edittext one visible
     */
    private void openEmailOrPhoneOTPVerifyDialog(HashMap<String, Object> jsonObject, String
            editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {

        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_detail), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, true) {
            @Override
            public void onClickLeftButton() {
                customDialogVerification.dismiss();
                logOut(false);
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                HashMap<String, Object> map = new HashMap<>();
                map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
                map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());

                switch (checkWitchOtpValidationON()) {
                    case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextOne.getText().toString(), otpEmailVerification)) {
                            if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                                map.put(Const.Params.IS_PHONE_NUMBER_VERIFIED, true);
                                map.put(Const.Params.IS_EMAIL_VERIFIED, true);
                                map.put(Const.Params.EMAIL, email);
                                map.put(Const.Params.PHONE, phone);
                                customDialogVerification.dismiss();
                                setOTPVerification(map);
                            } else {
                                etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                            }

                        } else {
                            etDialogEditTextOne.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    case Const.SMS_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                            map.put(Const.Params.IS_PHONE_NUMBER_VERIFIED, true);
                            map.put(Const.Params.PHONE, phone);
                            customDialogVerification.dismiss();
                            setOTPVerification(map);
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                        }
                        break;
                    case Const.EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpEmailVerification)) {
                            map.put(Const.Params.IS_EMAIL_VERIFIED, true);
                            map.put(Const.Params.EMAIL, email);
                            customDialogVerification.dismiss();
                            setOTPVerification(map);
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    default:
                        // do with default
                        break;
                }
            }

            @Override
            public void resendOtp() {
                getOtpVerify(jsonObject);
            }
        };
        customDialogVerification.show();
    }

    /**
     * this method called a webservice for set otp verification result in web
     */
    private void setOTPVerification(HashMap<String, Object> jsonObject) {
        Utils.showCustomProgressDialog(this, false);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.setOtpVerification(jsonObject);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        preferenceHelper.putIsEmailVerified(response.body().isSuccess());
                        preferenceHelper.putIsPhoneNumberVerified(response.body().isSuccess());
                        preferenceHelper.putEmail(email);
                        preferenceHelper.putPhoneNumber(phone);
                        Utils.showMessageToast(response.body().getStatusPhrase(), CheckoutActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(CheckoutActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called webservice for get OTP for mobile or email
     *
     * @param jsonObject jsonObject
     */
    private void getOtpVerify(HashMap<String, Object> jsonObject) {
        Utils.showCustomProgressDialog(this, false);
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OtpResponse> otpResponseCall = apiInterface.getOtpVerify(jsonObject);
        otpResponseCall.enqueue(new Callback<OtpResponse>() {
            @Override
            public void onResponse(@NonNull Call<OtpResponse> call, @NonNull Response<OtpResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        otpEmailVerification = response.body().getOtpForEmail();
                        otpSmsVerification = response.body().getOtpForSms();
                        switch (checkWitchOtpValidationON()) {
                            case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                                openEmailOrPhoneOTPVerifyDialog(jsonObject, getResources().getString(R.string.text_email_otp), getResources().getString(R.string.text_phone_otp), true);
                                break;
                            case Const.SMS_VERIFICATION_ON:
                                openEmailOrPhoneOTPVerifyDialog(jsonObject, "", getResources().getString(R.string.text_phone_otp), false);
                                break;
                            case Const.EMAIL_VERIFICATION_ON:
                                openEmailOrPhoneOTPVerifyDialog(jsonObject, "", getResources().getString(R.string.text_email_otp), false);
                                break;
                            default:
                                // do with default
                                break;
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OtpResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.REGISTER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void updateUiForOrderSelect(boolean isUpdate) {
        if (isUpdate) {
            cbScheduleOrder.setTag(true);
            cbScheduleOrder.setTextColor(AppColor.COLOR_THEME);
            cbScheduleOrder.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeColorDrawable(R.drawable.ic_schedule, this), null, null, null);
            llScheduleDate.setVisibility(View.VISIBLE);
            cbAsps.setTag(false);
            cbAsps.setTextColor(AppColor.getThemeTextColor(this));
            cbAsps.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeModeDrawable(R.drawable.ic_asps, this), null, null, null);
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

    /**
     * this method called a webservice for add item in cart
     */
    private void addItemInServerCart(boolean isCalledBooking) {
        Utils.showCustomProgressDialog(this, false);

        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setServerToken(preferenceHelper.getSessionToken());
        cartOrder.setStoreId(currentBooking.getSelectedStoreId());
        cartOrder.setProducts(currentBooking.getCartProductWithSelectedSpecificationList());
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(currentBooking.getTaxesDetails());
        ArrayList<Addresses> destinationAddresses = new ArrayList<>();
        Addresses addresses = new Addresses();
        addresses.setAddress(currentBooking.getDeliveryAddress());
        addresses.setCity(currentBooking.getCity1());
        addresses.setAddressType(Const.Type.DESTINATION);
        addresses.setNote(etDeliveryAddressNote.getText().toString());
        addresses.setUserType(Const.Type.USER);
        ArrayList<Double> location = new ArrayList<>();
        location.add(currentBooking.getDeliveryLatLng().latitude);
        location.add(currentBooking.getDeliveryLatLng().longitude);
        addresses.setLocation(location);
        CartUserDetail cartUserDetail = new CartUserDetail();
        cartUserDetail.setEmail(preferenceHelper.getEmail());
        cartUserDetail.setCountryPhoneCode(etCustomerCountryCode.getText().toString());
        cartUserDetail.setName(etCustomerName.getText().toString());
        cartUserDetail.setPhone(etCustomerMobile.getText().toString());
        cartUserDetail.setImageUrl(preferenceHelper.getProfilePic());
        addresses.setUserDetails(cartUserDetail);
        if (!currentBooking.getDestinationAddresses().isEmpty()) {
            addresses.setFlatNo(currentBooking.getDestinationAddresses().get(0).getFlatNo());
            addresses.setStreet(currentBooking.getDestinationAddresses().get(0).getStreet());
            addresses.setLandmark(currentBooking.getDestinationAddresses().get(0).getLandmark());
        }
        destinationAddresses.add(addresses);

        cartOrder.setDestinationAddresses(destinationAddresses);
        cartOrder.setPickupAddresses(currentBooking.getPickupAddresses());

        double cartOrderTotalPrice = 0, totalCartAmountWithoutTax = 0, cartOrderTotalTaxPrice = 0;
        for (CartProducts products : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartOrderTotalPrice = cartOrderTotalPrice + products.getTotalProductItemPrice();
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + products.getTotalProductItemPrice();
            if (currentBooking.isTaxIncluded()) {
                cartOrderTotalPrice = cartOrderTotalPrice - products.getTotalItemTax();
            }
            cartOrderTotalTaxPrice = cartOrderTotalTaxPrice + products.getTotalItemTax();
        }
        cartOrder.setCartOrderTotalPrice(cartOrderTotalPrice);
        cartOrder.setCartOrderTotalTaxPrice(cartOrderTotalTaxPrice);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);

        cartOrder.setTableNo(currentBooking.getTableNumber());
        cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
        cartOrder.setBookingType(currentBooking.getTableBookingType());
        cartOrder.setDeliveryType(currentBooking.getDeliveryType());

        if (currentBooking.isTableBooking() && currentBooking.getSchedule() != null) {
            cartOrder.setOrderStartAt(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli());
            cartOrder.setOrderStartAt2(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli());
            cartOrder.setTableId(currentBooking.getTableId());
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (isCalledBooking) {
                            goToPaymentActivity(true);
                        } else {
                            currentBooking.setCartId(response.body().getCartId());
                            currentBooking.setCartCityId(response.body().getCityId());
                            checkIsPickUpDeliveryByUser(cbSelfDelivery.isChecked());
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddCartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void goToPlaceOrder() {
        if (isCurrentLogin()) {
            boolean isValid = preferenceHelper.getIsFromQRCode() ? isValidateQRData() : isValidate();
            if (isValid) {
                if (!etCustomerName.isEnabled() || currentBooking.isTableBooking()) {
                    if ((boolean) cbScheduleOrder.getTag() && currentBooking.isFutureOrder() || (currentBooking.isTableBooking() && currentBooking.isBookTableForFuture())) {
                        if (currentBooking.getSchedule() != null && currentBooking.getSchedule().isValidScheduleTime(store.getScheduleOrderCreateAfterMinute()) && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleDate()) && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleTime())) {
                            if (currentBooking.isTableBooking()) {
                                addItemInServerCart(true);
                            } else {
                                goToPaymentActivity(true);
                            }
                        } else {
                            if (TextUtils.isEmpty(tvScheduleDate.getText().toString().trim())) {
                                Utils.showToast(getResources().getString(R.string.msg_plz_select_schedule_date), CheckoutActivity.this);
                            } else {
                                Utils.showToast(getResources().getString(R.string.msg_plz_select_schedule_time), CheckoutActivity.this);
                            }
                        }
                    } else {
                        goToPaymentActivity(true);
                    }
                } else {
                    Utils.showToast(getResources().getString(R.string.msg_plz_confirm_user_detail), this);
                }
            }
        } else {
            goToLoginActivityForResult(CheckoutActivity.this, true);
        }
    }

    private void goToPaymentActivity(final boolean isPayNowInvisible) {
        currentBooking.setAllowContactLessDelivery(cbContactLess.isChecked());
        final Intent homeIntent = new Intent(CheckoutActivity.this, PaymentActivity.class);
        homeIntent.putExtra(Const.Tag.PAYMENT_ACTIVITY, isPayNowInvisible);
        homeIntent.putExtra(Const.Params.IS_BRING_CHANGE, cbSelfDelivery.isChecked());
        homeIntent.putExtra(Const.Params.DELIVERY_TYPE, currentBooking.isTableBooking() || preferenceHelper.getIsFromQRCode()
                ? currentBooking.getDeliveryType() : Const.DeliveryType.STORE);
        if (TextUtils.isEmpty(deliveryPriceStrings) || cbSelfDelivery.isChecked() || currentBooking.isTableBooking()) {
            startActivity(homeIntent);
            overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        } else {
            if (deliveryPriceConfirm != null && deliveryPriceConfirm.isShowing()) {
                return;
            }
            deliveryPriceConfirm = new CustomDialogAlert(this, getString(R.string.text_confirm_delivery_price), deliveryPriceStrings, getString(R.string.text_ok)) {

                @Override
                public void onClickLeftButton() {
                    dismiss();
                }

                @Override
                public void onClickRightButton() {
                    dismiss();
                    startActivity(homeIntent);
                    overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
                }

            };
            deliveryPriceConfirm.show();
        }
    }

    private void openDatePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openDatePicker(this, new ScheduleHelper.DateListener() {
                @Override
                public void onDateSet(Calendar calendar) {
                    if (currentBooking.isTableBooking()) {
                        tvTableDate.setText(currentBooking.getSchedule().getScheduleDate());
                        currentBooking.getSchedule().removeScheduleTime("");
                        tvTableTime.setText("");
                    } else {
                        tvScheduleDate.setText(currentBooking.getSchedule().getScheduleDate());
                    }
                    StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(CheckoutActivity.this, storeTimes, serverTime, currentBooking.getTimeZone(), currentBooking.isFutureOrder(), currentBooking.isFutureOrder() ? currentBooking.getSchedule().getScheduleCalendar() : null);
                    updateUIWhenStoreClosed(storeClosedResult);
                }
            }, tableSettings != null ? tableSettings.getReservationMaxDays() : 0, store.getScheduleOrderCreateAfterMinute(), currentBooking.isTableBooking());
        }
    }

    private void openTimePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openSlotPicker(this, new ScheduleHelper.TimeListener() {
                @Override
                public void onTimeSet(Calendar calendar) {
                    if (currentBooking.isTableBooking()) {
                        tvTableTime.setText(currentBooking.getSchedule().getScheduleTime());
                    } else {
                        tvScheduleTime.setText(currentBooking.getSchedule().getScheduleTime());
                    }
                    StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(CheckoutActivity.this, storeTimes, serverTime, currentBooking.getTimeZone(), currentBooking.isFutureOrder(), currentBooking.isFutureOrder() ? currentBooking.getSchedule().getScheduleCalendar() : null);
                    updateUIWhenStoreClosed(storeClosedResult);
                }
            }, storeDeliveryTimes, currentBooking.isTableBooking(), store.getScheduleOrderCreateAfterMinute());
        }
    }

    private void updateUiTip(boolean isTip, int tipType, double tipAmount) {
        if (isTip) {
            llTip.setVisibility(View.VISIBLE);
            llTip.setTag(tipType);
            if (tipAmount == 0 && tlTips.getCheckedTags().size() == 0) {
                tlTips.cleanTags();
                tlTips.addTag(getString(R.string.text_no_tip));
                if (tipType == Const.Type.ABSOLUTE) {
                    tlTips.addTag(String.format("%s5", currentBooking.getCurrency()));
                    tlTips.addTag(String.format("%s10", currentBooking.getCurrency()));
                    tlTips.addTag(String.format("%s15", currentBooking.getCurrency()));
                    tlTips.addTag(currentBooking.getCurrency());
                } else {
                    tlTips.addTag(String.format("%s5", "%"));
                    tlTips.addTag(String.format("%s10", "%"));
                    tlTips.addTag(String.format("%s15", "%"));
                    tlTips.addTag("%");
                }
                tlTips.setCheckTag(getString(R.string.text_no_tip));
                tlTips.setTagCheckListener((position, text, isChecked) -> {
                    if (text.equals("%") || text.equals(currentBooking.getCurrency())) {
                        tilTipAmount.setVisibility(View.VISIBLE);
                        etTipAmount.getText().clear();
                        etTipAmount.requestFocus();
                    } else if (position == 1) {
                        tilTipAmount.setVisibility(View.GONE);
                        getDeliveryInvoice(deliveryTime, deliveryDistance, 5);
                    } else if (position == 2) {
                        tilTipAmount.setVisibility(View.GONE);
                        getDeliveryInvoice(deliveryTime, deliveryDistance, 10);
                    } else if (position == 3) {
                        tilTipAmount.setVisibility(View.GONE);
                        getDeliveryInvoice(deliveryTime, deliveryDistance, 15);
                    } else {
                        getDeliveryInvoice(deliveryTime, deliveryDistance, 0);
                        tilTipAmount.setVisibility(View.GONE);
                    }
                });
            }
        } else {
            llTip.setVisibility(View.GONE);
        }

        if (preferenceHelper.getIsFromQRCode()) {
            llTip.setVisibility(View.GONE);
        }
    }

    public void selectPromoOffer(String promoOffer) {
        etPromoCode.setText(promoOffer);
        promoApply(promoOffer);
    }

    protected void clearCart() {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        HashMap<String, Object> map = getCommonParam();
        map.put(Const.Params.CART_ID, currentBooking.getCartId());
        Call<IsSuccessResponse> responseCall = apiInterface.clearCart(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.clearCart();
                        goToHomeActivity();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CheckoutActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CART_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getBookingSettings() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.STORE_ID, currentBooking.getSelectedStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<TableBookingSettingsResponse> responseCall = apiInterface.tableBookingSettings(map);
        responseCall.enqueue(new Callback<TableBookingSettingsResponse>() {
            @Override
            public void onResponse(@NonNull Call<TableBookingSettingsResponse> call, @NonNull Response<TableBookingSettingsResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        tableSettings = response.body().getTableSettings();
                        storeDeliveryTimes.clear();
                        storeDeliveryTimes.addAll(tableSettings.getBookingTime());
                        int people = currentBooking.getNumberOfPerson();
                        ArrayList<String> tablesNumber = new ArrayList<>();
                        ArrayList<Table> tableList = new ArrayList<>();
                        for (Table table : tableSettings.getTableList()) {
                            if (people >= table.getTableMinPerson() && people <= table.getTableMaxPerson() && table.isIsUserCanBook() && table.isBusiness()) {
                                tablesNumber.add(table.getTableNo());
                                tableList.add(table);
                            }
                        }
                        tableAdapter = new TableSpinnerAdapter(CheckoutActivity.this, tablesNumber);
                        spinnerTableNumber.setAdapter(tableAdapter);
                        spinnerTableNumber.setSelection(tablesNumber.indexOf(String.valueOf(currentBooking.getTableNumber())));
                        spinnerTableNumber.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                            @Override
                            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                                currentBooking.setTableNumber(Integer.parseInt(tablesNumber.get(position)));
                                if (tableList.size() > position) {
                                    currentBooking.setTableId(tableList.get(position).getId());
                                }
                            }

                            @Override
                            public void onNothingSelected(AdapterView<?> parent) {

                            }
                        });
                        checkIsPickUpDeliveryByUser(cbSelfDelivery.isChecked());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<TableBookingSettingsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openClearCartDialog() {
        final CustomDialogAlert dialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_clear_reservation_table_process), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                clearCart();
                dismiss();
            }
        };
        dialogAlert.show();
    }
}