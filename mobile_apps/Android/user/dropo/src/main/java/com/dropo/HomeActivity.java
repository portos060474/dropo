package com.dropo;

import static com.dropo.utils.Const.LOGIN_REQUEST;
import static com.dropo.utils.Const.REQUEST_CHECK_SETTINGS;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Point;
import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Patterns;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.AdsAdapter;
import com.dropo.adapter.DeliveryStoreAdapter;
import com.dropo.adapter.OffersAdapter;
import com.dropo.adapter.StoreAdapter;
import com.dropo.animation.AlphaInAnimationAdapter;
import com.dropo.animation.ScaleInAnimationAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomDialogVerification;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.DialogStoreFilter;
import com.dropo.component.DialogTableBooking;
import com.dropo.component.tag.TagLayout;
import com.dropo.fragments.PromoFragment;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.Ads;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.Deliveries;
import com.dropo.models.datamodels.PromoCodes;
import com.dropo.models.datamodels.RemoveFavourite;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.StoreClosedResult;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.DeliveryOffersResponse;
import com.dropo.models.responsemodels.DeliveryStoreResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OtpResponse;
import com.dropo.models.responsemodels.SetFavouriteResponse;
import com.dropo.models.responsemodels.StoreResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.FontsOverride;
import com.dropo.utils.LocationHelper;
import com.dropo.utils.Utils;
import com.facebook.shimmer.ShimmerFrameLayout;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HomeActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived, DialogStoreFilter.FilterListener {

    private final ArrayList<Store> storeListOriginal = new ArrayList<>();
    private final ArrayList<PromoCodes> deliveryOffersList = new ArrayList<>();
    private final ArrayList<String> storeTags = new ArrayList<>();
    private LocationHelper locationHelper;
    private CustomDialogVerification customDialogVerification;
    private Dialog dialogEmailOrPhoneVerification;
    private CustomFontEditTextView etDialogEditTextOne, etDialogEditTextTwo;
    private String phone, email;
    private CustomDialogAlert exitDialog;
    private Location currentLocation;
    private RecyclerView rcvStoreCategory;
    private DeliveryStoreAdapter deliveryStoreAdapter;
    private ConstraintLayout noDeliveries;
    private View ivStoreEmpty;
    private StoreAdapter storeAdapter;
    private RecyclerView rcvStore, rcvAdsStore, rcvOffers;
    private AdsAdapter storeAdsAdapter;
    private NestedScrollView nsvStores;
    private DialogStoreFilter dialogStoreFilter;
    private Deliveries deliveries;
    private DialogStoreFilter.FilterPreference filterPreference;
    private LinearLayout llStoreAds, llDeliveries, llStore, llDeliveryOffers;
    private ShimmerFrameLayout shimmerHome;
    private TextInputLayout tilStoreSearch;
    private ImageView ivStoreSearch;
    private TextView tvStore;
    private EditText etStoreSearch;
    private int storeTotalPage = 1;
    private int storeCurrentPage = 1;
    private LinearLayout btnGotoCart;
    private TextView tvCartCount;
    private boolean isLoadStore;
    private OffersAdapter offersAdapter;
    private PromoFragment promoFragment;
    private TagLayout tagStore;
    private String otpEmailVerification, otpSmsVerification;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FontsOverride.setDefaultFont(this, "MONOSPACE", "fonts/ClanPro-News.otf");
        setContentView(R.layout.activity_home);
        initToolBar();
        initViewById();
        setViewListener();
        initLocationHelper();
        getUserDetail();
        FirebaseMessaging.getInstance().subscribeToTopic("5ed4a2c87f2c283bacd04308");
        initRcvStore();
        loadLocationAddress();
    }

    private void loadLocationAddress() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locationHelper.setLocationSettingRequest(HomeActivity.this, REQUEST_CHECK_SETTINGS, o -> {
                locationHelper.getLastLocation(location -> {
                    currentLocation = location;
                    if (currentLocation != null) {
                        currentBooking.setCurrentLatLng(new LatLng(currentLocation.getLatitude(), currentLocation.getLongitude()));
                        loadDeliveryDataAsParLocation(currentLocation);
                    }
                });
            }, () -> {

            });
        } else {
            Location location = getLocationFromLatLng(preferenceHelper.getPreviousSaveLatitude(), preferenceHelper.getPreviousSaveLongitude());
            if (location != null) {
                loadDeliveryDataAsParLocation(location);
            }
        }
    }

    private void initLocationHelper() {
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        locationHelper.onStart();
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        clearQRCartDataIfAvailable(null);
        getUserDetail();
        getCart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setToolbarProfile(true, this);
        if (deliveries != null && deliveries.getDeliveryType() != Const.DeliveryType.COURIER && isLoadStore) {
            updateTabs(deliveries);
            if (currentBooking.getCurrentLatLng() != null) {
                getStoreList(CurrentBooking.getInstance().getBookCityId(), deliveries.getId(), true, false);
            }
            setCartItem();
        }
        isLoadStore = true;
        clearQRCartDataIfAvailable(null);
    }

    @Override
    public void onStop() {
        super.onStop();
        locationHelper.onStop();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_CHECK_SETTINGS:
                switch (resultCode) {
                    case Activity.RESULT_OK:
                        Utils.showCustomProgressDialog(HomeActivity.this, false);
                        break;
                    case Activity.RESULT_CANCELED:
                        break;
                    default:
                        break;
                }
                break;
            case LOGIN_REQUEST:
                getUserDetail();
                break;
            case Const.REQUEST_DELIVERY_LOCATION:
                if (resultCode == RESULT_OK) {
                    isLoadStore = false;
                    if (currentBooking.getCurrentLatLng() != null) {
                        if (deliveries != null && deliveries.getDeliveryType() != Const.DeliveryType.COURIER) {
                            updateTabs(deliveries);
                            getStoreList(CurrentBooking.getInstance().getBookCityId(), deliveries.getId(), true, false);
                        }
                        if (deliveries != null) {
                            getDeliveryOffers(deliveries.getId(), currentBooking.getBookCityId());
                        }
                        initRcvDeliveryStore();
                        setAddressOnToolbar(currentBooking.getCurrentAddress());
                    }
                }
                break;
        }

        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if (result != null) {
            if (result.getContents() != null) {
                Uri link = Uri.parse(result.getContents());
                String path = link.getQueryParameter(Const.Query.PAGE);
                try {
                    if (TextUtils.isEmpty(path)) {
                        path = link.getLastPathSegment();
                    }
                    if (path.equals(Const.Path.STORE)) {
                        String storeId = link.getQueryParameter(Const.Query.STORE_ID);
                        String tableId = link.getQueryParameter(Const.Query.TABLE_ID);
                        goToStoreProductActivityFromDeepLink(storeId, tableId);
                    }
                    getIntent().setData(new Intent().getData());
                } catch (Exception e) {
                    Utils.showToast(getString(R.string.msg_invalid_qr_code), this);
                }
            }
        }
    }


    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvStoreCategory = findViewById(R.id.rcvDeliveryStore);
        noDeliveries = findViewById(R.id.clEmpty);
        ivStoreEmpty = findViewById(R.id.ivStoreEmpty);
        rcvStore = findViewById(R.id.rcvStore);
        tagStore = findViewById(R.id.tagStore);
        rcvAdsStore = findViewById(R.id.rcvAdsStore);
        nsvStores = findViewById(R.id.nsvStores);
        findViewById(R.id.ivStoreFilter).setOnClickListener(this);
        findViewById(R.id.btnSearchLocation).setOnClickListener(this);
        llStoreAds = findViewById(R.id.llStoreAds);
        llDeliveries = findViewById(R.id.llDeliveries);
        shimmerHome = findViewById(R.id.shimmerHome);
        shimmerHome.startShimmer();
        shimmerHome.setVisibility(View.VISIBLE);
        tilStoreSearch = findViewById(R.id.tilStoreSearch);
        ivStoreSearch = findViewById(R.id.ivStoreSearch);
        tvStore = findViewById(R.id.tvStore);
        etStoreSearch = findViewById(R.id.etStoreSearch);
        llStore = findViewById(R.id.llStore);
        btnGotoCart = findViewById(R.id.btnGotoCart);
        btnGotoCart.getBackground().setTint(AppColor.COLOR_THEME);
        tvCartCount = findViewById(R.id.tvCartCount);
        llDeliveryOffers = findViewById(R.id.llOffers);
        rcvOffers = findViewById(R.id.rcvOffers);
    }

    @Override
    protected void setViewListener() {
        btnGotoCart.setOnClickListener(this);
        tvTitleToolbar.setOnClickListener(this);
        ivStoreSearch.setOnClickListener(this);
        etStoreSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                onStoreSearchFilter(charSequence.toString(), getResources().getString(R.string.text_store));

            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
        etStoreSearch.setOnFocusChangeListener((v, hasFocus) -> {
            if (hasFocus) {
                btnGotoCart.setVisibility(View.GONE);
            } else {
                setCartItem();
            }
        });
    }

    @Override
    protected void onBackNavigation() {
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivStoreFilter) {
            openStoreFilter();
        } else if (id == R.id.ivToolbarProfile) {
            if (isCurrentLogin()) {
                goToAccountActivity();
            } else {
                goToLoginActivityForResult(this, false);
            }
        } else if (id == R.id.tvToolbarTitle || id == R.id.btnSearchLocation) {
            goToDeliveryLocationActivity();
        } else if (id == R.id.ivStoreSearch) {
            if (tilStoreSearch.getVisibility() == View.GONE) {
                focusedOnStore();
                tilStoreSearch.setVisibility(View.VISIBLE);
                tvStore.setVisibility(View.GONE);
                ivStoreSearch.setImageDrawable(AppColor.getThemeColorDrawable(R.drawable.ic_cross, this));
                etStoreSearch.requestFocus();
                etStoreSearch.postDelayed(() -> {
                    InputMethodManager keyboard = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                    keyboard.showSoftInput(etStoreSearch, 0);
                }, 200);
            } else {
                Utils.hideSoftKeyboard(this);
                tilStoreSearch.setVisibility(View.GONE);
                tvStore.setVisibility(View.VISIBLE);
                ivStoreSearch.setImageDrawable(AppColor.getThemeColorDrawable(R.drawable.ic_search, this));
                etStoreSearch.getText().clear();
            }
        } else if (id == R.id.btnGotoCart) {
            goToCartActivity();
        }

    }

    @Override
    public void onBackPressed() {
        openExitDialog();
    }

    private void checkDocumentUploadAndApproved() {
        if (preferenceHelper.getIsApproved()) {
            closedAdminApprovedDialog();
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else {
                if (currentBooking.isHaveOrders()) {
                    openEmailOrPhoneConfirmationDialog(getResources().getString(R.string.text_confirm_detail), getResources().getString(R.string.msg_plz_confirm_your_detail), getResources().getString(R.string.text_send));
                }
            }
        } else {
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else {
                openAdminApprovedDialog();
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
                finish();
            }
        };

        exitDialog.show();
    }

    /**
     * this method called webservice for get OTP for mobile or email
     *
     * @param map map
     */
    private void getOtpVerify(HashMap<String, Object> map) {
        Utils.showCustomProgressDialog(this, false);
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OtpResponse> otpResponseCall = apiInterface.getOtpVerify(map);
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
                                openEmailOrPhoneOTPVerifyDialog(map, getResources().getString(R.string.text_email_otp), getResources().getString(R.string.text_phone_otp), true);
                                break;
                            case Const.SMS_VERIFICATION_ON:
                                openEmailOrPhoneOTPVerifyDialog(map, "", getResources().getString(R.string.text_phone_otp), false);
                                break;
                            case Const.EMAIL_VERIFICATION_ON:
                                openEmailOrPhoneOTPVerifyDialog(map, "", getResources().getString(R.string.text_email_otp), false);
                                break;
                            default:
                                break;
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
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

    /**
     * this method open dialog which confirm user email or mobile detail
     *
     * @param titleDialog      set dialog title
     * @param messageDialog    set dialog message
     * @param titleRightButton set dialog right button text
     */
    private void openEmailOrPhoneConfirmationDialog(String titleDialog, String messageDialog, String titleRightButton) {
        CustomFontTextView tvDialogEdiTextMessage;
        Button btnDialogEditTextRight;
        TextView tvDialogEditTextTitle;
        TextInputLayout dialogItlOne;
        LinearLayout llConfirmationPhone;
        ImageView btnDialogEditTextLeft;
        CustomFontEditTextView etRegisterCountryCode;

        if (customDialogVerification != null && customDialogVerification.isShowing() || dialogEmailOrPhoneVerification != null && dialogEmailOrPhoneVerification.isShowing()) {
            return;
        }
        dialogEmailOrPhoneVerification = new BottomSheetDialog(this);
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
                        if (FieldValidation.isValidPhoneNumber(HomeActivity.this, etDialogEditTextTwo.getText().toString())) {
                            etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(HomeActivity.this));
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
                    if (FieldValidation.isValidPhoneNumber(HomeActivity.this, etDialogEditTextTwo.getText().toString())) {
                        etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(HomeActivity.this));
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
    private void openEmailOrPhoneOTPVerifyDialog(HashMap<String, Object> jsonObject, String editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_account), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, true) {
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
                        break;
                }
            }

            @Override
            public void resendOtp() {
                getOtpVerify(jsonObject);
            }
        };
        ((ImageView) customDialogVerification.findViewById(R.id.btnDialogAlertLeft)).setImageResource(R.drawable.ic_logout_stroke);
        customDialogVerification.show();
    }

    /**
     * this method called a webservice for get user detail
     */
    private void getUserDetail() {
        if (isCurrentLogin()) {
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
                        checkDocumentUploadAndApproved();
                        signInAnonymously();
                    }
                }

                @Override
                public void onFailure(@NonNull Call<UserDataResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(HomeActivity.class.getName(), t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
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
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.putIsEmailVerified(response.body().isSuccess());
                        preferenceHelper.putIsPhoneNumberVerified(response.body().isSuccess());
                        preferenceHelper.putEmail(email);
                        preferenceHelper.putPhoneNumber(phone);
                        Utils.showMessageToast(response.body().getStatusPhrase(), HomeActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
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

    private void loadDeliveryDataAsParLocation(Location currentLocation) {
        if (TextUtils.isEmpty(currentBooking.getBookCityId()) || currentBooking.isLanguageChanged()) {
            currentBooking.setLanguageChanged(false);
            getCart();
            if (currentLocation != null) {
                getGeocodeDataFromLocation(currentLocation);
            } else {
                Utils.hideCustomProgressDialog();
            }
        } else {
            Utils.hideCustomProgressDialog();
            setAddressOnToolbar(currentBooking.getCurrentAddress());
            initRcvDeliveryStore();
            if (Objects.equals(getIntent().getAction(), Intent.ACTION_VIEW)) {
                handleDeepLinkIntent(getIntent());
            }
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        new Handler(Looper.myLooper()).postDelayed(() -> {
            if (currentLocation == null) {
                currentLocation = location;
                if (currentLocation != null) {
                    locationHelper.onStop();
                    loadLocationAddress();
                }
            }
        }, 200);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_LOCATION) {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    locationHelper.onStop();
                    locationHelper.onStart();
                }
            }
        }
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
        currentBooking.setCurrentAddress(address);
        currentBooking.setCurrentLatLng(cityLatLng);
        preferenceHelper.putPreviousSaveLatitude(String.valueOf(cityLatLng.latitude));
        preferenceHelper.putPreviousSaveLongitude(String.valueOf(cityLatLng.longitude));
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        map.put(Const.Params.COUNTRY, country);
        map.put(Const.Params.COUNTRY_CODE, countryCode);
        map.put(Const.Params.COUNTRY_CODE_2, countryCode);
        map.put(Const.Params.CITY_CODE, cityCode);
        map.put(Const.Params.LATITUDE, cityLatLng.latitude);
        map.put(Const.Params.LONGITUDE, cityLatLng.longitude);
        if (TextUtils.isEmpty(city)) {
            map.put(Const.Params.CITY1, "");
        } else {
            map.put(Const.Params.CITY1, city);
        }
        if (TextUtils.isEmpty(subAdminArea)) {
            map.put(Const.Params.CITY2, "");
        } else {
            map.put(Const.Params.CITY2, subAdminArea);
        }
        if (TextUtils.isEmpty(adminArea)) {
            map.put(Const.Params.CITY3, "");
        } else {
            map.put(Const.Params.CITY3, adminArea);
        }
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DeliveryStoreResponse> responseCall = apiInterface.getDeliveryStoreList(map);
        responseCall.enqueue(new Callback<DeliveryStoreResponse>() {
            @Override
            public void onResponse(@NonNull Call<DeliveryStoreResponse> call, @NonNull Response<DeliveryStoreResponse> response) {
                parseContent.parseDeliveryStore(response);
                initRcvDeliveryStore();
                if (Objects.equals(getIntent().getAction(), Intent.ACTION_VIEW)) {
                    handleDeepLinkIntent(getIntent());
                }
            }

            @Override
            public void onFailure(@NonNull Call<DeliveryStoreResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.HOME_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called webservice for get Data from LatLng which is provided by Google
     *
     * @param location on map
     */
    private void getGeocodeDataFromLocation(Location location) {
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put(Const.Google.LAT_LNG, location.getLatitude() + "," + location.getLongitude());
        hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
        Call<ResponseBody> bodyCall = apiInterface.getGoogleGeocode(hashMap);
        bodyCall.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsGoogleGeocode(response);
                if (map != null && !map.isEmpty()) {
                    LatLng latLng = new LatLng(Double.parseDouble(map.get(Const.Google.LAT)), Double.parseDouble(map.get(Const.Google.LNG)));
                    if (latLng != null) {
                        setAddressOnToolbar(map.get(Const.Google.FORMATTED_ADDRESS));
                        getDeliveryStoreInCity(map.get(Const.Google.COUNTRY), map.get(Const.Google.COUNTRY_CODE), map.get(Const.Google.LOCALITY), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2), map.get(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1), latLng, map.get(Const.Google.FORMATTED_ADDRESS), map.get(Const.Params.CITY_CODE));
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

    private void getCart() {
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CartResponse> orderCall = apiInterface.getCart(getCommonParam());
        orderCall.enqueue(new Callback<CartResponse>() {
            @Override
            public void onResponse(@NonNull Call<CartResponse> call, @NonNull Response<CartResponse> response) {
                parseContent.parseCart(response);
                setCartItem();
                if (response.body() != null) {
                    clearQRCartDataIfAvailable(response.body().getCartId());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.HOME_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setAddressOnToolbar(String address) {
        String colorLabel = "#" + Integer.toHexString(AppColor.COLOR_THEME & 0x00ffffff);
        String colorText = "#" + Integer.toHexString(AppColor.getThemeTextColor(this) & 0x00ffffff);
        String input = "<font color=" + colorLabel + ">" + getResources().getString(CurrentBooking.getInstance().isFutureOrder() ? R.string.text_schedule_type : R.string.text_asap_type) + " -- " + "</font>" + "<font " + "color=" + colorText + ">" + address + "</font>";
        tvTitleToolbar.setText(Utils.fromHtml(input));
    }

    public void goToCourierOrderActivity() {
        Intent intent = new Intent(this, CreateCourierOrderActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private Location getLocationFromLatLng(String latitude, String longitude) {
        if (TextUtils.isEmpty(latitude) || TextUtils.isEmpty(longitude)) {
            return null;
        } else {
            Location location = new Location("previous_location");
            location.setLatitude(Double.parseDouble(latitude));
            location.setLongitude(Double.parseDouble(longitude));
            return location;
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvDeliveryStore() {
        updateUiList();
        if (deliveryStoreAdapter != null) {
            deliveryStoreAdapter.notifyDataSetChanged();
        } else {
            deliveryStoreAdapter = new DeliveryStoreAdapter(this, currentBooking.getDeliveryStoreList()) {
                @Override
                public void onSelect(int position) {
                    Deliveries deliveriesStore = currentBooking.getDeliveryStoreList().get(position);
                    if (deliveries != null && deliveries.getId().equals(deliveriesStore.getId()) && deliveriesStore.getDeliveryType() == Const.DeliveryType.STORE) {
                        return;
                    }

                    CurrentBooking.getInstance().setSelectedDeliveryId(deliveriesStore.getId());
                    CurrentBooking.getInstance().setStoreCanCreateGroup(deliveriesStore.isStoreCanCreateGroup());
                    if (deliveriesStore.getDeliveryType() == Const.DeliveryType.COURIER) {
                        if (isCurrentLogin()) {
                            goToCourierOrderActivity();
                        } else {
                            Utils.showToast(getResources().getString(R.string.text_need_login_for_courier), HomeActivity.this);
                        }

                    } else {
                        deliveries = deliveriesStore;
                        getDeliveryOffers(deliveries.getId(), currentBooking.getBookCityId());
                        updateTabs(deliveries);
                        getStoreList(CurrentBooking.getInstance().getBookCityId(), deliveries.getId(), true, true);
                    }
                }
            };
            deliveryStoreAdapter.setHasStableIds(true);
            AlphaInAnimationAdapter animationAdapter = new AlphaInAnimationAdapter(deliveryStoreAdapter);
            animationAdapter.setHasStableIds(true);
            ScaleInAnimationAdapter scaleInAnimationAdapter = new ScaleInAnimationAdapter(animationAdapter);
            scaleInAnimationAdapter.setHasStableIds(true);
            rcvStoreCategory.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
            rcvStoreCategory.setAdapter(scaleInAnimationAdapter);
        }

        for (int i = 0; i < currentBooking.getDeliveryStoreList().size(); i++) {
            if (currentBooking.getDeliveryStoreList().get(i).getDeliveryType() == Const.DeliveryType.STORE) {
                deliveryStoreAdapter.setSelectedCategory(i);
                llDeliveries.setVisibility(View.VISIBLE);
                break;
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvOffers() {
        if (offersAdapter != null) {
            offersAdapter.notifyDataSetChanged();
        } else {
            offersAdapter = new OffersAdapter(this, deliveryOffersList) {
                @Override
                public void onSelect(int position) {
                    if (promoFragment != null && promoFragment.isVisible()) {
                        return;
                    }
                    promoFragment = new PromoFragment();
                    Bundle bundle = new Bundle();
                    bundle.putString(Const.Params.PROMO_ID, deliveryOffersList.get(position).getId());
                    promoFragment.setArguments(bundle);
                    promoFragment.setCancelable(false);
                    promoFragment.show(getSupportFragmentManager(), promoFragment.getTag());
                }
            };
            AlphaInAnimationAdapter animationAdapter = new AlphaInAnimationAdapter(offersAdapter);
            ScaleInAnimationAdapter scaleInAnimationAdapter = new ScaleInAnimationAdapter(animationAdapter);
            rcvOffers.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
            rcvOffers.setAdapter(scaleInAnimationAdapter);
        }
    }

    private void initRcvStore() {
        GridLayoutManager gridLayoutManager = new GridLayoutManager(this, 2, RecyclerView.VERTICAL, false);
        rcvStore.setLayoutManager(gridLayoutManager);
        storeAdapter = new StoreAdapter(this, storeListOriginal) {
            @Override
            public void onSelected(View view, int position) {
                if (position < 0) {
                    return;
                }
                Store store = storeAdapter.getStoreArrayList().get(position);
                currentBooking.setStoreClosed(store.isStoreClosed());
                if (tagStore.getCheckedTags().contains(getString(R.string.store_filter_book_a_table))) {
                    if (!currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
                        openClearCartDialog();
                    } else {
                        openTableBooking(store);
                    }
                } else {
                    currentBooking.setTableBookingType(0);
                    currentBooking.setBookingFee(0);
                    currentBooking.setNumberOfPerson(0);
                    currentBooking.setDeliveryType(0);
                    currentBooking.setTableNumber(0);
                    if (filterPreference != null && TextUtils.equals(storeAdapter.getFilterBy(), getResources().getString(R.string.text_item)) && !TextUtils.isEmpty(filterPreference.getSearchItemName())) {
                        goToStoreProductActivity(store, filterPreference.getSearchItemName());
                    } else {
                        goToStoreProductActivity(store, null);
                    }
                }
            }

            @Override
            public void setFavourites(int position, boolean isFavourite) {
                if (isFavourite) {
                    removeAsFavoriteStore(storeAdapter.getStoreArrayList().get(position));
                } else {
                    setFavoriteStore(storeAdapter.getStoreArrayList().get(position));
                }
            }
        };
        AlphaInAnimationAdapter animationAdapter = new AlphaInAnimationAdapter(storeAdapter);
        rcvStore.setAdapter(new ScaleInAnimationAdapter(animationAdapter));
        nsvStores.setOnScrollChangeListener((NestedScrollView.OnScrollChangeListener) (v, scrollX, scrollY, oldScrollX, oldScrollY) -> {
            if (v.getChildAt(v.getChildCount() - 1) != null) {
                if ((scrollY >= (v.getChildAt(v.getChildCount() - 1).getMeasuredHeight() - v.getMeasuredHeight())) && scrollY > oldScrollY) {
                    int visibleItemCount = gridLayoutManager.getChildCount();
                    int totalItemCount = gridLayoutManager.getItemCount();
                    int pastVisibleItems = gridLayoutManager.findFirstVisibleItemPosition();
                    if ((visibleItemCount + pastVisibleItems) >= totalItemCount) {
                        getStoreList(CurrentBooking.getInstance().getBookCityId(), deliveries.getId(), false, false);
                    }
                }
            }
        });

        storeTags.add(getString(R.string.store_filter_delivery));
        storeTags.add(getString(R.string.store_filter_takeaway));
        storeTags.add(getString(R.string.store_filter_book_a_table));
        tagStore.setTags(storeTags);
        tagStore.setTagCheckListener((position, text, isChecked) -> {
            if (isChecked) {
                if (text.equals(getString(R.string.store_filter_takeaway))) {
                    ArrayList<Store> pickupStore = new ArrayList<>();
                    for (Store store : storeListOriginal) {
                        if (store.isProvidePickupDelivery()) {
                            pickupStore.add(store);
                        }
                    }
                    onStoreFilter(pickupStore);
                } else if (text.equals(getString(R.string.store_filter_book_a_table))) {
                    ArrayList<Store> tableBookStore = new ArrayList<>();
                    for (Store store : storeListOriginal) {
                        if (store.isTableReservation() || store.isTableReservationWithOrder()) {
                            tableBookStore.add(store);
                        }
                    }
                    onStoreFilter(tableBookStore);
                } else {
                    onStoreFilter(new ArrayList<>(storeListOriginal));
                }
            } else {
                onStoreFilter(new ArrayList<>(storeListOriginal));
            }
        });
    }

    private void updateTabs(Deliveries deliveries) {
        tagStore.deleteCheckedTags();
        tagStore.setTags(storeTags);
        if (!deliveries.isProvideTableBooking()) {
            tagStore.deleteTag(storeTags.indexOf(getString(R.string.store_filter_book_a_table)));
            setQRCode(false);
        } else {
            setQRCode(true);
            tagStore.setTags(storeTags);
        }
    }

    private void setQRCode(boolean isEnable) {
        if (isEnable) {
            setToolbarRightIcon3(R.drawable.ic_qr_code_scanner, view -> {
                new IntentIntegrator(this).setPrompt(getString(R.string.text_qr_code_guide)).initiateScan();
            });
        } else {
            if (ivToolbarRightIcon3 != null) {
                ivToolbarRightIcon3.setImageDrawable(null);
                ivToolbarRightIcon3.setOnClickListener(null);
            }
        }
    }

    private void openClearCartDialog() {
        final CustomDialogAlert dialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_other_store_item_in_cart), getResources().getString(R.string.text_ok)) {
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

    private void clearQRCartDataIfAvailable(String cartId) {
        if (currentBooking.getCartId() == null && cartId == null) {
            return;
        }
        if (preferenceHelper.getIsFromQRCode()) {
            if (currentBooking.getCartId() == null) {
                currentBooking.setCartId(cartId);
            }
            clearCart();
            clearQROrderData();
        }
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
                        setCartItem();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
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

    private void openTableBooking(Store store) {
        DialogTableBooking dialogTableBooking = new DialogTableBooking(this, preferenceHelper, parseContent, store, null, this.currentBooking.getServerTime()) {
            @Override
            public void doWithEnable(Store store, int tableBookingType) {
                dismiss();
                currentBooking.setCartCurrency(currentBooking.getCurrency());
                if (tableBookingType == Const.TableBookingType.BOOK_AT_REST) {
                    addItemInServerCart(store);
                } else {
                    goToStoreProductActivity(store, null);
                }
            }
        };
        dialogTableBooking.show();
    }

    private void updateUiList() {
        if (currentBooking.getDeliveryStoreList().isEmpty()) {
            noDeliveries.setVisibility(View.VISIBLE);
            btnGotoCart.setVisibility(View.GONE);
            nsvStores.setVisibility(View.GONE);
        } else {
            noDeliveries.setVisibility(View.GONE);
            setCartItem();
            nsvStores.setVisibility(View.VISIBLE);
        }
        shimmerHome.setVisibility(View.GONE);
        shimmerHome.stopShimmer();
    }

    private void goToStoreProductActivity(Store store, String filter) {
        Intent intent = new Intent(this, StoreProductActivity.class);
        intent.putExtra(Const.SELECTED_STORE, store);
        intent.putExtra(Const.IS_STORE_CAN_CREATE_GROUP, CurrentBooking.getInstance().isStoreCanCreateGroup());
        intent.putExtra(Const.STORE_INDEX, getLangIndxex(preferenceHelper.getLanguageCode(), store.getLang(), true));
        intent.putExtra(Const.FILTER, filter);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToStoreProductActivity(Store store) {
        StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(this, store.getStoreTime(), this.currentBooking.getServerTime(), CurrentBooking.getInstance().getTimeZone(), false, null);
        store.setStoreClosed(storeClosedResult.isStoreClosed());
        store.setReOpenTime(storeClosedResult.getReOpenAt());
        if (this.currentBooking.getCurrentLatLng() != null && store.getLocation() != null && !store.getLocation().isEmpty() && store.getLocation().get(0) != 0 && store.getLocation().get(1) != 0) {
            store.setDistance(Utils.distanceTo(this.currentBooking.getCurrentLatLng(), new LatLng(store.getLocation().get(0), store.getLocation().get(1)), true));
        }
        store.setCurrency(CurrentBooking.getInstance().getCurrency());
        if (deliveries != null) {
            store.setTags(Utils.getStoreTagFromTagId(store.getFamousProductsTagIds(), deliveries.getFamousProductsTags()));
        }
        store.setPriceRattingTag(Utils.getStringPrice(store.getPriceRating(), store.getCurrency()));

        store.setFavourite(CurrentBooking.getInstance().getFavourite().contains(store.getId()));

        boolean isStoreCanCreateGroup = false;
        for (Deliveries deliveries : this.currentBooking.getDeliveryStoreList()) {
            if (store.getStoreDeliveryTypeId().equals(deliveries.getId())) {
                isStoreCanCreateGroup = deliveries.isStoreCanCreateGroup();
            }
        }

        Intent intent = new Intent(this, StoreProductActivity.class);
        intent.putExtra(Const.SELECTED_STORE, store);
        intent.putExtra(Const.STORE_INDEX, this.getLangIndxex(this.preferenceHelper.getLanguageCode(), store.getLang(), true));
        intent.putExtra(Const.IS_STORE_CAN_CREATE_GROUP, isStoreCanCreateGroup);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void removeAsFavoriteStore(final Store storeData) {
        Utils.showCustomProgressDialog(this, false);
        final ArrayList<String> store = new ArrayList<>();
        store.add(storeData.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SetFavouriteResponse> call = apiInterface.removeAsFavouriteStore(ApiClient.makeGSONRequestBody(new RemoveFavourite(preferenceHelper.getSessionToken(), preferenceHelper.getUserId(), store)));
        call.enqueue(new Callback<SetFavouriteResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<SetFavouriteResponse> call, @NonNull Response<SetFavouriteResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.getFavourite().clear();
                        currentBooking.setFavourite(response.body().getFavouriteStores());
                    }
                    storeAdapter.notifyDataSetChanged();
                }

            }

            @Override
            public void onFailure(@NonNull Call<SetFavouriteResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setFavoriteStore(final Store storeData) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.STORE_ID, storeData.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SetFavouriteResponse> call = apiInterface.setFavouriteStore(map);
        call.enqueue(new Callback<SetFavouriteResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<SetFavouriteResponse> call, @NonNull Response<SetFavouriteResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.getFavourite().clear();
                        currentBooking.setFavourite(response.body().getFavouriteStores());
                    }
                    storeAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onFailure(@NonNull Call<SetFavouriteResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call a webservice for get Store list in city
     *
     * @param cityId          cityId in string
     * @param deliveryStoreId id in string
     */
    private void getStoreList(String cityId, String deliveryStoreId, boolean isRest, boolean isCategorySelect) {
        if (isRest) {
            storeTotalPage = 1;
            storeCurrentPage = 1;
        }

        if (storeCurrentPage <= storeTotalPage) {
            Utils.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.CITY_ID, cityId);
            map.put(Const.Params.STORE_DELIVERY_ID, deliveryStoreId);
            map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
            map.put(Const.Params.PAGE, storeCurrentPage);
            map.put(Const.Params.PER_PAGE, Const.STORE_PER_PAGE);
            map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
            map.put(Const.Params.LATITUDE, currentBooking.getCurrentLatLng().latitude);
            map.put(Const.Params.LONGITUDE, currentBooking.getCurrentLatLng().longitude);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<StoreResponse> responseCall = apiInterface.getSelectedStoreList(map);
            responseCall.enqueue(new Callback<StoreResponse>() {
                @SuppressLint("NotifyDataSetChanged")
                @Override
                public void onResponse(@NonNull Call<StoreResponse> call, @NonNull Response<StoreResponse> response) {
                    if (parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            if (isRest) {
                                storeListOriginal.clear();
                            }

                            double totalPage = Math.ceil(response.body().getStoresResult().getCount() / (double) Const.STORE_PER_PAGE);
                            storeTotalPage = totalPage > 0 ? (int) totalPage : 1;

                            if (response.body().getStoresResult() != null && response.body().getStoresResult().getStoreList() != null) {
                                if (!response.body().getStoresResult().getStoreList().isEmpty()) {
                                    storeCurrentPage++;
                                }
                                for (Store store : response.body().getStoresResult().getStoreList()) {
                                    StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(HomeActivity.this, store.getStoreTime(), response.body().getServerTime(), CurrentBooking.getInstance().getTimeZone(), false, null);
                                    store.setStoreClosed(storeClosedResult.isStoreClosed());
                                    store.setReOpenTime(storeClosedResult.getReOpenAt());
                                    if (currentBooking.getCurrentLatLng() != null && store.getLocation() != null && !store.getLocation().isEmpty() && store.getLocation().get(0) != 0 && store.getLocation().get(1) != 0) {
                                        store.setDistance(distanceTo(currentBooking.getCurrentLatLng(), new LatLng(store.getLocation().get(0), store.getLocation().get(1)), true));
                                    }
                                    store.setCurrency(CurrentBooking.getInstance().getCurrency());
                                    if (deliveries != null) {
                                        store.setTags(Utils.getStoreTagFromTagId(store.getFamousProductsTagIds(), deliveries.getFamousProductsTags()));
                                    }
                                    store.setPriceRattingTag(Utils.getStringPrice(store.getPriceRating(), store.getCurrency()));
                                    if (currentBooking.isFutureOrder()) {
                                        if (store.isTakingScheduleOrder()) {
                                            storeListOriginal.add(store);
                                        }
                                    } else {
                                        storeListOriginal.add(store);
                                    }
                                }
                                initRcvStoreAds((response.body().getAds()));
                                llStoreAds.setVisibility(response.body().getAds() != null && !response.body().getAds().isEmpty() ? View.VISIBLE : View.GONE);
                                if (storeAdapter != null) {
                                    if (tagStore.getCheckedTags().contains(getString(R.string.store_filter_book_a_table))) {
                                        ArrayList<Store> tableBookStore = new ArrayList<>();
                                        for (Store store : storeListOriginal) {
                                            if (store.isTableReservation() || store.isTableReservationWithOrder()) {
                                                tableBookStore.add(store);
                                            }
                                        }
                                        storeAdapter.setStoreArrayList(tableBookStore);
                                    } else {
                                        //tagStore.setTags(storeTags); // reset tags.
                                        storeAdapter.setStoreArrayList(storeListOriginal);
                                    }
                                    storeAdapter.setFilterBy(getResources().getString(R.string.text_store));
                                    storeAdapter.notifyDataSetChanged();

                                    if (isCategorySelect) {
                                        new Handler().postDelayed(() -> scrollToView(nsvStores, rcvStore), 300);
                                    }
                                }
                            }
                        } else {
                            storeListOriginal.clear();
                            llStoreAds.setVisibility(View.GONE);
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
                        }
                        if (storeListOriginal.isEmpty()) {
                            llStore.setVisibility(View.GONE);
                            ivStoreEmpty.setVisibility(View.VISIBLE);
                        } else {
                            llStore.setVisibility(View.VISIBLE);
                            ivStoreEmpty.setVisibility(View.GONE);
                        }
                    }
                    Utils.hideCustomProgressDialog();
                }

                @Override
                public void onFailure(@NonNull Call<StoreResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
    }

    private void scrollToView(final NestedScrollView scrollViewParent, final View view) {
        // Get deepChild Offset
        Point childOffset = new Point();
        getDeepChildOffset(scrollViewParent, view.getParent(), view, childOffset);
        // Scroll to child.
        scrollViewParent.smoothScrollTo(0, childOffset.y);
    }

    private void getDeepChildOffset(final ViewGroup mainParent, final ViewParent parent, final View child, final Point accumulatedOffset) {
        ViewGroup parentGroup = (ViewGroup) parent;
        accumulatedOffset.x += child.getLeft();
        accumulatedOffset.y += child.getTop();
        if (parentGroup.equals(mainParent)) {
            return;
        }
        getDeepChildOffset(mainParent, parentGroup.getParent(), parentGroup, accumulatedOffset);
    }

    private void getDeliveryOffers(String deliveryStoreId, String cityId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.DELIVERY_ID, deliveryStoreId);
        map.put(Const.Params.CITY_ID, cityId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DeliveryOffersResponse> responseCall = apiInterface.getDeliveryOffers(map);
        responseCall.enqueue(new Callback<DeliveryOffersResponse>() {
            @Override
            public void onResponse(@NonNull Call<DeliveryOffersResponse> call, @NonNull Response<DeliveryOffersResponse> response) {
                deliveryOffersList.clear();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.setPromoApply(response.body().isPromoAvailable());
                        if (response.body().isPromoAvailable()) {
                            deliveryOffersList.addAll(response.body().getPromoCodes());
                        }
                    }
                }
                initRcvOffers();
                if (deliveryOffersList.isEmpty()) {
                    llDeliveryOffers.setVisibility(View.GONE);
                } else {
                    llDeliveryOffers.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onFailure(@NonNull Call<DeliveryOffersResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });

    }

    private double distanceTo(LatLng start, LatLng stop, boolean isUnitKM) {
        if (start != null & stop != null) {
            Location locationFrom = new Location("");
            locationFrom.setLatitude(start.latitude);
            locationFrom.setLongitude(start.longitude);

            Location locationTo = new Location("");
            locationTo.setLatitude(stop.latitude);
            locationTo.setLongitude(stop.longitude);
            if (isUnitKM) {
                return locationFrom.distanceTo(locationTo) * 0.001; // Km
            } else {
                return locationFrom.distanceTo(locationTo) * 0.000621371; // mile
            }

        } else {
            return 0;
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvStoreAds(List<Ads> ads) {
        if (storeAdsAdapter != null) {
            storeAdsAdapter.notifyDataSetChanged();
        } else {
            storeAdsAdapter = new AdsAdapter(this, ads) {
                @Override
                public void onAddClick(Ads ads) {
                    if (ads.isAdsRedirectToStore() && ads.getStore() != null) {
                        goToStoreProductActivity(ads.getStore());
                    }
                }
            };
            AlphaInAnimationAdapter animationAdapter = new AlphaInAnimationAdapter(storeAdsAdapter);
            rcvAdsStore.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
            rcvAdsStore.setAdapter(new ScaleInAnimationAdapter(animationAdapter));
        }
    }

    private void openStoreFilter() {
        if (dialogStoreFilter != null && dialogStoreFilter.isShowing()) {
            return;
        }
        if (deliveries != null) {
            dialogStoreFilter = new DialogStoreFilter(this, deliveries, storeListOriginal, this, filterPreference);
            dialogStoreFilter.setOnDismissListener(dialogInterface -> {
                getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            });
            dialogStoreFilter.show();
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onStoreFilter(ArrayList<Store> storeListFiltered) {
        storeAdapter.setStoreArrayList(storeListFiltered);
        storeAdapter.notifyDataSetChanged();
        focusedOnStore();
    }

    @Override
    public void onStoreSearchFilter(String filter, String filterBy) {
        if (storeAdapter != null) {
            if (!TextUtils.isEmpty(filterBy)) {
                storeAdapter.setFilterBy(filterBy);
            }
            storeAdapter.getFilter().filter(filter.trim());
        }
    }

    @Override
    public void onResetFilter() {
        updateTabs(deliveries);
        getStoreList(CurrentBooking.getInstance().getBookCityId(), deliveries.getId(), true, false);
    }

    @Override
    public void saveStoreFilterPreference(DialogStoreFilter.FilterPreference filterPreference) {
        this.filterPreference = filterPreference;
    }

    private void focusedOnStore() {
        nsvStores.post(() -> nsvStores.smoothScrollTo(0, nsvStores.getBottom() - findViewById(R.id.tvStoreLabel).getBottom() - findViewById(R.id.div1).getBottom()));
    }

    private void goToDeliveryLocationActivity() {
        Intent intent = new Intent(this, DeliveryLocationActivity.class);
        startActivityForResult(intent, Const.REQUEST_DELIVERY_LOCATION);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void setCartItem() {
        int cartCount = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        if (cartCount > 0) {
            tvCartCount.setText(String.valueOf(cartCount));
            btnGotoCart.setVisibility(View.VISIBLE);
        } else {
            btnGotoCart.setVisibility(View.GONE);
        }
    }

    private void goToCheckoutActivity() {
        Intent intent = new Intent(this, CheckoutActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void addItemInServerCart(Store store) {
        Utils.showCustomProgressDialog(this, false);
        currentBooking.setDeliveryLatLng(currentBooking.getCurrentLatLng());
        currentBooking.setDeliveryAddress(currentBooking.getCurrentAddress());
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
        cartOrder.setProducts(new ArrayList<>());
        currentBooking.setTaxIncluded(store.isTaxIncluded());
        currentBooking.setUseItemTax(store.isUseItemTax());
        currentBooking.setTaxesDetails(store.getTaxDetails());
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(new ArrayList<>());

        if (currentBooking.getDestinationAddresses().isEmpty() || !TextUtils.equals(currentBooking.getDestinationAddresses().get(0).getAddress(), currentBooking.getDeliveryAddress())) {
            Addresses addresses = new Addresses();
            addresses.setAddress(currentBooking.getDeliveryAddress());
            addresses.setCity(currentBooking.getCity1());
            addresses.setAddressType(Const.Type.DESTINATION);
            addresses.setNote("");
            addresses.setUserType(Const.Type.USER);
            ArrayList<Double> location = new ArrayList<>();
            location.add(currentBooking.getDeliveryLatLng().latitude);
            location.add(currentBooking.getDeliveryLatLng().longitude);
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(isCurrentLogin() ? preferenceHelper.getEmail() : "");
            cartUserDetail.setCountryPhoneCode(isCurrentLogin() ? preferenceHelper.getCountryCode() : "");
            cartUserDetail.setName(isCurrentLogin() ? preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName() : "");
            cartUserDetail.setPhone(isCurrentLogin() ? preferenceHelper.getPhoneNumber() : "");
            cartUserDetail.setImageUrl(isCurrentLogin() ? preferenceHelper.getProfilePic() : "");
            addresses.setUserDetails(cartUserDetail);
            currentBooking.setDestinationAddresses(addresses);
        }

        if (currentBooking.getPickupAddresses().isEmpty()) {
            Addresses addresses = new Addresses();
            addresses.setAddress(store.getAddress());
            addresses.setCity("");
            addresses.setAddressType(Const.Type.PICKUP);
            addresses.setNote("");
            addresses.setUserType(Const.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(store.getLocation().get(0));
            location.add(store.getLocation().get(1));
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(store.getEmail());
            cartUserDetail.setCountryPhoneCode(store.getCountryPhoneCode());
            cartUserDetail.setName(store.getName());
            cartUserDetail.setPhone(store.getPhone());
            cartUserDetail.setImageUrl(store.getImageUrl());
            addresses.setUserDetails(cartUserDetail);
            currentBooking.setPickupAddresses(addresses);
        }

        cartOrder.setDestinationAddresses(currentBooking.getDestinationAddresses());
        cartOrder.setPickupAddresses(currentBooking.getPickupAddresses());

        double cartOrderTotalPrice = 0, totalCartAmountWithoutTax = 0, cartOrderTotalTaxPrice = 0;
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
                        currentBooking.setCartId(response.body().getCartId());
                        currentBooking.setCartCityId(response.body().getCityId());
                        goToCheckoutActivity();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
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

    private void signInAnonymously() {
        FirebaseUser currentUser = mAuth.getCurrentUser();
        if (currentUser == null) {
            if (!TextUtils.isEmpty(preferenceHelper.getFirebaseUserToken())) {
                mAuth.signInWithCustomToken(preferenceHelper.getFirebaseUserToken()).addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            FirebaseUser user = mAuth.getCurrentUser();
                        } else {
                            Utils.showToast("Authentication failed.", HomeActivity.this);
                        }
                    }
                });
            }
        }
    }
}