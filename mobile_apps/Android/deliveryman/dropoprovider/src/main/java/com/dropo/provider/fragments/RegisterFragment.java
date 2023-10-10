package com.dropo.provider.fragments;

import static android.app.Activity.RESULT_OK;
import static com.dropo.provider.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.provider.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.location.Address;
import android.location.Geocoder;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.InputType;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.fragment.app.Fragment;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.provider.LoginActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomCityDialog;
import com.dropo.provider.component.CustomCountryDialog;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomPhotoDialog;
import com.dropo.provider.models.datamodels.Cities;
import com.dropo.provider.models.datamodels.Countries;
import com.dropo.provider.models.responsemodels.CityResponse;
import com.dropo.provider.models.responsemodels.CountriesResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OtpResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.models.validations.Validator;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.FieldValidation;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.ImageCompression;
import com.dropo.provider.utils.ImageHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.textfield.TextInputLayout;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class RegisterFragment extends Fragment implements View.OnClickListener, TextView.OnEditorActionListener {
    private final String TAG = this.getClass().getSimpleName();

    private ImageView ivRegisterProfileImage;
    private CustomFontEditTextView etRegisterLastName, etRegisterFirstName, etRegisterEmail, etRegisterPassword, etRegisterAddress, etRegisterMobileNumber, etSelectCountry, etSelectCity, etRegisterCountryCode, etRegisterZipCode, etRegisterPasswordRetype;
    private CardView ivRegisterProfileImageSelect;
    private CustomFontButton btnRegister;
    private String countryId, cityId;
    private Uri picUri;
    private LinearLayout llReferral;
    private ImageHelper imageHelper;
    private TextInputLayout tilRegisterAddress;
    private ArrayList<Countries> countryList;
    private ArrayList<Cities> cityList;
    private LoginActivity loginActivity;
    private CustomDialogAlert closedPermissionDialog;
    private CustomFontTextView tvReferralApply;
    private CustomFontEditTextView etReferralCode;
    private ImageView ivSuccess;
    private String referralCode = "", socialId = "";
    private CustomCityDialog customCityDialog;
    private CustomCountryDialog customCountryDialog;
    private TextInputLayout tilPassword, tilEmail, tilPhone, tilCity, tilSelectCountry, tilFirstName, tilLastName, tilRetypePassword;
    private LinearLayout llSocialLogin;
    private CheckBox cbTcPolicy;
    private CustomFontTextView tvPolicy;
    private String currentPhotoPath;
    private String otpEmailVerification, otpSmsVerification;
    private CustomDialogVerification customDialogVerification;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        loginActivity = (LoginActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_register, container, false);
        ivRegisterProfileImage = view.findViewById(R.id.ivRegisterProfileImage);
        ivRegisterProfileImageSelect = view.findViewById(R.id.ivProfileImageSelect);
        etRegisterLastName = view.findViewById(R.id.etRegisterLastName);
        etRegisterEmail = view.findViewById(R.id.etRegisterEmail);
        etRegisterPassword = view.findViewById(R.id.etRegisterPassword);
        etRegisterFirstName = view.findViewById(R.id.etRegisterFirstName);
        etRegisterAddress = view.findViewById(R.id.etRegisterAddress);
        etRegisterMobileNumber = view.findViewById(R.id.etRegisterMobileNumber);
        etSelectCountry = view.findViewById(R.id.etSelectCountry);
        etSelectCity = view.findViewById(R.id.etSelectCity);
        btnRegister = view.findViewById(R.id.btnRegister);
        etRegisterCountryCode = view.findViewById(R.id.etRegisterCountryCode);
        etRegisterZipCode = view.findViewById(R.id.etRegisterZipCode);
        tilRegisterAddress = view.findViewById(R.id.tilRegisterAddress);
        etRegisterPasswordRetype = view.findViewById(R.id.etRegisterPasswordRetype);
        etReferralCode = view.findViewById(R.id.etReferralCode);
        tvReferralApply = view.findViewById(R.id.tvReferralApply);
        ivSuccess = view.findViewById(R.id.ivSuccess);
        llReferral = view.findViewById(R.id.llReferral);
        tilPassword = view.findViewById(R.id.tilPassword);
        tilCity = view.findViewById(R.id.tilCity);
        tilSelectCountry = view.findViewById(R.id.tilSelectCountry);
        tilFirstName = view.findViewById(R.id.tilFirstName);
        tilLastName = view.findViewById(R.id.tilLastName);
        tilEmail = view.findViewById(R.id.tilEmail);
        tilPhone = view.findViewById(R.id.tilPhone);
        tilRetypePassword = view.findViewById(R.id.tilRetypePassword);
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        cbTcPolicy = view.findViewById(R.id.cbTcPolicy);
        tvPolicy = view.findViewById(R.id.tvPolicy);
        loginActivity.initGoogleLogin(view);
        loginActivity.initFBLogin(view);
        loginActivity.initTwitterLogin(view);
        TextView btnLoginNow = view.findViewById(R.id.btnLoginNow);
        btnLoginNow.setOnClickListener(this);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        updateUiForOptionalFiled(loginActivity.preferenceHelper.getIsShowOptionalFieldInRegister());
        checkSocialLoginISOn(loginActivity.preferenceHelper.getIsLoginBySocial());
        imageHelper = new ImageHelper(loginActivity);
        tvReferralApply.setOnClickListener(this);
        btnRegister.setOnClickListener(this);
        etSelectCountry.setOnClickListener(this);
        etSelectCity.setOnClickListener(this);
        ivRegisterProfileImageSelect.setOnClickListener(this);
        etRegisterZipCode.setOnEditorActionListener(this);
        Utils.errorListener(tilFirstName);
        Utils.errorListener(tilLastName);
        Utils.errorListener(tilEmail);
        Utils.errorListener(tilPhone);
        Utils.errorListener(tilPassword);
        Utils.errorListener(tilSelectCountry);
        Utils.errorListener(tilCity);
        FieldValidation.setMaxPhoneNumberInputLength(loginActivity, etRegisterMobileNumber);
        String link = loginActivity.getResources().getString(R.string.text_link_sign_up_privacy) + " " + "<a href=\"" + loginActivity.preferenceHelper.getTermsANdConditions() + "\"" + ">" + getResources().getString(R.string.text_t_and_c) + "</a>" + " " + loginActivity.getResources().getString(R.string.text_and) + " " + "<a href=\"" + loginActivity.preferenceHelper.getPolicy() + "\"" + ">" + getResources().getString(R.string.text_policy) + "</a>";
        tvPolicy.setText(Utils.fromHtml(link));
        tvPolicy.setMovementMethod(LinkMovementMethod.getInstance());
        countryList = new ArrayList<>();
        getCountries();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case TAKE_PHOTO_FROM_CAMERA:
                    onCaptureImageResult();
                    break;
                case CHOOSE_PHOTO_FROM_GALLERY:
                    onSelectFromGalleryResult(data);
                    break;
                case CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE:
                    handleCrop(resultCode, data);
                    break;
                default:
                    break;
            }
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnRegister) {
            checkValidationForRegister();
        } else if (id == R.id.ivProfileImageSelect) {
            checkPermission();
        } else if (id == R.id.etSelectCountry) {
            if (countryList != null) {
                openCountryCodeDialog();
            }
        } else if (id == R.id.etSelectCity) {
            if (cityList != null) {
                openCityNameDialog();
            } else {
                Utils.showToast(getResources().getString(R.string.msg_select_your_country_first), loginActivity);
            }
        } else if (id == R.id.tvReferralApply) {
            if (TextUtils.isEmpty(etReferralCode.getText().toString().trim())) {
                Utils.showToast(loginActivity.getResources().getString(R.string.msg_plz_enter_valid_referral), loginActivity);
            } else {
                if (TextUtils.isEmpty(countryId)) {
                    Utils.showToast(loginActivity.getResources().getString(R.string.msg_select_your_country_first), loginActivity);
                } else {
                    checkReferralCode();
                }
            }
        } else if (id == R.id.btnLoginNow) {
            loginActivity.setViewPagerPage(0);
        }
    }


    public void openPhotoSelectDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(loginActivity, loginActivity.getResources().getString(R.string.text_set_profile_photos)) {
            @Override
            public void clickedOnCamera() {
                takePhotoFromCamera();
                dismiss();
            }

            @Override
            public void clickedOnGallery() {
                choosePhotoFromGallery();
                dismiss();
            }
        };
        customPhotoDialog.show();
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = imageHelper.createImageFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            picUri = FileProvider.getUriForFile(loginActivity, loginActivity.getPackageName(), file);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        } else {
            picUri = Uri.fromFile(file);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, picUri);
        startActivityForResult(intent, TAKE_PHOTO_FROM_CAMERA);
    }

    private void choosePhotoFromGallery() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(intent, CHOOSE_PHOTO_FROM_GALLERY);
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        CropImage.activity(sourceUri).setGuidelines(com.theartofdev.edmodo.cropper.CropImageView.Guidelines.ON).start(loginActivity, this);
    }

    /**
     * This method is used for handel result after select placeholder from gallery .
     */

    private void onSelectFromGalleryResult(Intent data) {
        if (data != null) {
            picUri = data.getData();
            beginCrop(picUri);
        }
    }

    /**
     * This method is used for handel result after captured placeholder from camera .
     */
    private void onCaptureImageResult() {
        beginCrop(picUri);
    }

    /**
     * This method is used for  handel crop result after crop the placeholder.
     */
    private void handleCrop(int resultCode, Intent result) {
        CropImage.ActivityResult activityResult = CropImage.getActivityResult(result);
        if (resultCode == RESULT_OK) {
            picUri = activityResult.getUri();
            currentPhotoPath = picUri.getPath();
            new ImageCompression(loginActivity).setImageCompressionListener(compressionImagePath -> {
                currentPhotoPath = compressionImagePath;
                GlideApp.with(loginActivity).load(picUri).into(ivRegisterProfileImage);
            }).execute(currentPhotoPath);

        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), loginActivity);
        }
    }

    /**
     * this method call a webservice for register a provider
     */
    private void register() {
        HashMap<String, RequestBody> registerMap = new HashMap<>();
        registerMap.put(Const.Params.FIRST_NAME, ApiClient.makeTextRequestBody(etRegisterFirstName.getText().toString()));
        registerMap.put(Const.Params.LAST_NAME, ApiClient.makeTextRequestBody(etRegisterLastName.getText().toString()));
        registerMap.put(Const.Params.EMAIL, ApiClient.makeTextRequestBody(etRegisterEmail.getText().toString()));
        registerMap.put(Const.Params.ADDRESS, ApiClient.makeTextRequestBody(etRegisterAddress.getText().toString()));
        registerMap.put(Const.Params.PHONE, ApiClient.makeTextRequestBody(etRegisterMobileNumber.getText().toString()));
        registerMap.put(Const.Params.CITY_ID, ApiClient.makeTextRequestBody(cityId));
        registerMap.put(Const.Params.COUNTRY_ID, ApiClient.makeTextRequestBody(countryId));
        registerMap.put(Const.Params.DEVICE_TOKEN, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getDeviceToken()));
        registerMap.put(Const.Params.ZIP_CODE, ApiClient.makeTextRequestBody(etRegisterZipCode.getText().toString()));
        registerMap.put(Const.Params.COUNTRY_PHONE_CODE, ApiClient.makeTextRequestBody(etRegisterCountryCode.getText().toString()));
        registerMap.put(Const.Params.APP_VERSION, ApiClient.makeTextRequestBody(loginActivity.getAppVersion()));
        registerMap.put(Const.Params.IS_PHONE_NUMBER_VERIFIED, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getIsPhoneNumberVerified()));
        registerMap.put(Const.Params.IS_EMAIL_VERIFIED, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getIsEmailVerified()));
        registerMap.put(Const.Params.DEVICE_TYPE, ApiClient.makeTextRequestBody(Const.ANDROID));
        registerMap.put(Const.Params.REFERRAL_CODE, ApiClient.makeTextRequestBody(referralCode));
        registerMap.put(Const.Params.SOCIAL_ID, ApiClient.makeTextRequestBody(socialId));
        if (TextUtils.isEmpty(socialId)) {
            registerMap.put(Const.Params.PASS_WORD, ApiClient.makeTextRequestBody(etRegisterPassword.getText().toString()));
            registerMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.MANUAL));
        } else {
            registerMap.put(Const.Params.PASS_WORD, ApiClient.makeTextRequestBody(""));
            registerMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.SOCIAL));
        }

        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProviderDataResponse> register;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            register = apiInterface.register(null, registerMap);
        } else {
            register = apiInterface.register(ApiClient.makeMultipartRequestBody(currentPhotoPath, Const.Params.IMAGE_URL), registerMap);
        }

        register.enqueue(new Callback<ProviderDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProviderDataResponse> call, @NonNull Response<ProviderDataResponse> response) {

                if (loginActivity.parseContent.isSuccessful(response)) {
                    if (loginActivity.parseContent.parseUserStorageData(response)) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), loginActivity);
                        loginActivity.goToHomeActivity();
                    } else {
                        loginActivity.preferenceHelper.clearVerification();
                    }
                } else {
                    loginActivity.preferenceHelper.clearVerification();
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProviderDataResponse> call, @NonNull Throwable t) {
                loginActivity.preferenceHelper.clearVerification();
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });


    }

    protected boolean isValidate() {
        String msg = null;
        Validator emailValidation = FieldValidation.isEmailValid(loginActivity, etRegisterEmail.getText().toString().trim());
        Validator passwordValidation = FieldValidation.isPasswordValid(loginActivity, etRegisterPassword.getText().toString().trim());

        if (TextUtils.isEmpty(etRegisterFirstName.getText().toString().trim())) {
            msg = loginActivity.getString(R.string.msg_please_enter_valid_name);
            tilFirstName.setError(msg);
            etRegisterFirstName.requestFocus();
        } else if (TextUtils.isEmpty(etRegisterLastName.getText().toString().trim())) {
            msg = loginActivity.getString(R.string.msg_please_enter_valid_name);
            tilLastName.setError(msg);
            etRegisterLastName.requestFocus();
        } else if (!emailValidation.isValid()) {
            msg = emailValidation.getErrorMsg();
            tilEmail.setError(msg);
            etRegisterEmail.requestFocus();
        } else if (tilPassword.getVisibility() == View.VISIBLE && !passwordValidation.isValid()) {
            msg = passwordValidation.getErrorMsg();
            tilPassword.setError(msg);
            etRegisterPassword.requestFocus();
        } else if (TextUtils.isEmpty(etSelectCountry.getText().toString().trim())) {
            msg = loginActivity.getString(R.string.msg_please_select_country);
            tilSelectCountry.setError(msg);
            etSelectCountry.requestFocus();
        } else if (TextUtils.isEmpty(etSelectCity.getText().toString().trim())) {
            msg = loginActivity.getString(R.string.msg_please_select_city);
            tilCity.setError(msg);
            etSelectCity.requestFocus();
        } else if (!FieldValidation.isValidPhoneNumber(loginActivity, etRegisterMobileNumber.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(loginActivity);
            tilPhone.setError(msg);
            etRegisterMobileNumber.requestFocus();
        } else if (!cbTcPolicy.isChecked()) {
            msg = getResources().getString(R.string.msg_plz_accept_tc);
            Utils.showToast(msg, loginActivity);
        } else if (loginActivity.preferenceHelper.getIsProfilePictureRequired() && picUri == null) {
            msg = getResources().getString(R.string.msg_plz_upload_profile_pic);
            Utils.showToast(msg, loginActivity);
        }

        return TextUtils.isEmpty(msg);
    }

    private void openCountryCodeDialog() {
        if (customCountryDialog != null && customCountryDialog.isShowing()) {
            return;
        }

        customCountryDialog = new CustomCountryDialog(loginActivity, countryList) {
            @Override
            public void onSelect(Countries countries) {
                setCountry(countries);
                Utils.hideSoftKeyboard(loginActivity);
                dismiss();
            }
        };

        customCountryDialog.show();
    }


    private void openCityNameDialog() {
        if (customCityDialog != null && customCityDialog.isShowing()) {
            return;
        }

        customCityDialog = new CustomCityDialog(loginActivity, cityList) {
            @Override
            public void onSelect(Cities cities) {
                cityId = cities.getId();
                etSelectCity.setText(cities.getCityName());
                Utils.hideSoftKeyboard(loginActivity);
                etSelectCity.setError(null);
                etRegisterMobileNumber.requestFocus();
                dismiss();
            }
        };
        customCityDialog.show();
    }

    /**
     * this method call a webservice for get country list
     */
    private void getCountries() {
        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CountriesResponse> countriesItemCall = apiInterface.getCountries();
        countriesItemCall.enqueue(new Callback<CountriesResponse>() {
            @Override
            public void onResponse(@NonNull Call<CountriesResponse> call, @NonNull Response<CountriesResponse> response) {
                countryList = loginActivity.parseContent.parseCountries(response);
                loginActivity.locationHelper.getLastLocation(location -> {
                    if (location != null) {
                        new GetCityAsyncTask(location.getLatitude(), location.getLongitude()).execute();
                    } else {
                        if (!countryList.isEmpty()) {
                            setCountry(countryList.get(0));
                        }
                    }
                });
            }

            @Override
            public void onFailure(@NonNull Call<CountriesResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call a webservice for get city list
     */
    private void getCities(String countryId) {
        Utils.showCustomProgressDialog(loginActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.COUNTRY_ID, countryId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CityResponse> cityResponseCall = apiInterface.getCities(map);
        cityResponseCall.enqueue(new Callback<CityResponse>() {
            @Override
            public void onResponse(@NonNull Call<CityResponse> call, @NonNull Response<CityResponse> response) {
                cityList = loginActivity.parseContent.parseCities(response);
            }

            @Override
            public void onFailure(@NonNull Call<CityResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void updateUiForOptionalFiled(boolean isUpdate) {
        if (isUpdate) {
            tilRegisterAddress.setVisibility(View.VISIBLE);
        } else {
            tilRegisterAddress.setVisibility(View.GONE);
            etRegisterMobileNumber.setImeOptions(EditorInfo.IME_ACTION_DONE);
            etRegisterMobileNumber.setOnEditorActionListener(this);
        }
    }

    private void checkValidationForRegister() {
        if (isValidate()) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.TYPE, String.valueOf(Const.TYPE_PROVIDER));

            switch (loginActivity.checkWitchOtpValidationON()) {
                case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                    map.put(Const.Params.EMAIL, etRegisterEmail.getText().toString());
                    map.put(Const.Params.PHONE, etRegisterMobileNumber.getText().toString());
                    map.put(Const.Params.COUNTRY_PHONE_CODE, etRegisterCountryCode.getText().toString());
                    getOtpVerify(map);
                    break;
                case Const.SMS_VERIFICATION_ON:
                    map.put(Const.Params.PHONE, etRegisterMobileNumber.getText().toString());
                    map.put(Const.Params.COUNTRY_PHONE_CODE, etRegisterCountryCode.getText().toString());
                    getOtpVerify(map);
                    break;
                case Const.EMAIL_VERIFICATION_ON:
                    map.put(Const.Params.EMAIL, etRegisterEmail.getText().toString());
                    getOtpVerify(map);
                    break;
                default:
                    register();
                    break;
            }
        }
    }

    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        int id = textView.getId();
        if (id == R.id.etRegisterZipCode) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                checkValidationForRegister();
                return true;
            }
        } else if (id == R.id.etRegisterMobileNumber) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                checkValidationForRegister();
                return true;
            }
        }

        return false;
    }

    /**
     * this method call a webservice for get OTP of email or mobile
     *
     * @param jsonObject jsonObject
     */
    private void getOtpVerify(HashMap<String, Object> jsonObject) {
        Utils.showCustomProgressDialog(loginActivity, false);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OtpResponse> otpResponseCall = apiInterface.getOtpVerify(jsonObject);
        otpResponseCall.enqueue(new Callback<OtpResponse>() {
            @Override
            public void onResponse(@NonNull Call<OtpResponse> call, @NonNull Response<OtpResponse> response) {
                Utils.hideCustomProgressDialog();
                if (loginActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        otpEmailVerification = response.body().getOtpForEmail();
                        otpSmsVerification = response.body().getOtpForSms();
                        switch (loginActivity.checkWitchOtpValidationON()) {
                            case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                                openOTPVerifyDialog(jsonObject, getResources().getString(R.string.text_email_otp), getResources().getString(R.string.text_phone_otp), true);
                                break;
                            case Const.SMS_VERIFICATION_ON:
                                openOTPVerifyDialog(jsonObject, "", getResources().getString(R.string.text_phone_otp), false);
                                break;
                            case Const.EMAIL_VERIFICATION_ON:
                                openOTPVerifyDialog(jsonObject, "", getResources().getString(R.string.text_email_otp), false);
                                break;
                            default:
                                break;
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), loginActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OtpResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openOTPVerifyDialog(HashMap<String, Object> jsonObject, String editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }
        customDialogVerification = new CustomDialogVerification(loginActivity, getResources().getString(R.string.text_verify_detail), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, true) {
            @Override
            protected void resendOtp() {
                getOtpVerify(jsonObject);
            }

            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                switch (loginActivity.checkWitchOtpValidationON()) {
                    case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextOne.getText().toString(), otpEmailVerification)) {
                            if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                                loginActivity.preferenceHelper.putIsEmailVerified(true);
                                loginActivity.preferenceHelper.putIsPhoneNumberVerified(true);
                                register();
                            } else {
                                etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                            }
                        } else {
                            etDialogEditTextOne.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    case Const.SMS_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                            loginActivity.preferenceHelper.putIsPhoneNumberVerified(true);
                            register();
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                        }
                        break;
                    case Const.EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpEmailVerification)) {
                            loginActivity.preferenceHelper.putIsEmailVerified(true);
                            register();
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    default:
                        break;
                }
            }
        };

        customDialogVerification.show();
    }

    private void checkCountryCode(String country) {
        int countryListSize = countryList.size();
        for (int i = 0; i < countryListSize; i++) {
            if (countryList.get(i).getCountryName().toUpperCase().startsWith(country.toUpperCase())) {
                setCountry(countryList.get(i));
                return;
            }
        }
        if (!countryList.isEmpty()) {
            setCountry(countryList.get(0));
        }
    }

    private void setCountry(Countries country) {
        if (!countryList.isEmpty() && !TextUtils.equals(countryId, country.getId())) {
            countryId = country.getId();
            etSelectCity.getText().clear();
            getCities(countryId);
            etRegisterCountryCode.setText(country.getCountryPhoneCode());
            etSelectCountry.setText(country.getCountryName());
            etSelectCountry.setError(null);
            etReferralCode.setEnabled(true);
            etReferralCode.getText().clear();
            ivSuccess.setVisibility(View.GONE);
            if (loginActivity.preferenceHelper.getIsReferralOn() && country.isReferralProvider()) {
                llReferral.setVisibility(View.VISIBLE);
            } else {
                llReferral.setVisibility(View.GONE);
            }
        }
    }

    public void clearError() {
        if (etRegisterFirstName != null) {
            etRegisterLastName.setError(null);
            etRegisterFirstName.setError(null);
            etRegisterEmail.setError(null);
            etRegisterPassword.setError(null);
            etRegisterAddress.setError(null);
            etRegisterMobileNumber.setError(null);
            etSelectCountry.setError(null);
            etSelectCity.setError(null);
            etRegisterCountryCode.setError(null);
            etRegisterZipCode.setError(null);
        }
    }

    /**
     * this method will make decision according to permission result
     *
     * @param grantResults set result from system or OS
     */
    private void goWithCameraAndStoragePermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(loginActivity, android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(loginActivity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else {
            openPhotoSelectDialog();
        }
    }

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(loginActivity, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                requestPermissions(new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
                closedPermissionDialog();
            }
        };
        closedPermissionDialog.show();
    }

    private void closedPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            closedPermissionDialog.dismiss();
            closedPermissionDialog = null;
        }
    }

    public void checkPermission() {
        if (ContextCompat.checkSelfPermission(loginActivity, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(loginActivity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
        } else {
            openPhotoSelectDialog();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE) {
                goWithCameraAndStoragePermission(grantResults);
            }
        }
    }

    /**
     * this method call a webservice for check referral code enter by user
     */
    private void checkReferralCode() {
        Utils.showCustomProgressDialog(loginActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.REFERRAL_CODE, etReferralCode.getText().toString().trim());
        map.put(Const.Params.COUNTRY_ID, countryId);
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.getCheckReferral(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (loginActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        tvReferralApply.setVisibility(View.GONE);
                        ivSuccess.setVisibility(View.VISIBLE);
                        etReferralCode.setEnabled(false);
                        referralCode = etReferralCode.getText().toString();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), loginActivity);
                        etReferralCode.getText().clear();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void updateUiForSocialLogin(String email, String socialId, String firstName, String lastName, Uri profileUri) {
        if (!TextUtils.isEmpty(email)) {
            etRegisterEmail.setText(email);
            etRegisterEmail.setEnabled(false);
            etRegisterEmail.setFocusableInTouchMode(false);
            loginActivity.preferenceHelper.putIsEmailVerified(true);
        }
        this.socialId = socialId;
        etRegisterFirstName.setText(firstName);
        etRegisterLastName.setText(lastName);
        picUri = profileUri;
        etRegisterPassword.setVisibility(View.GONE);
        etRegisterPasswordRetype.setVisibility(View.GONE);
        tilPassword.setVisibility(View.GONE);
        tilRetypePassword.setVisibility(View.GONE);

        if (picUri != null) {
            Utils.showCustomProgressDialog(loginActivity, false);
            GlideApp.with(loginActivity.getApplicationContext()).asBitmap().load(picUri.toString()).diskCacheStrategy(DiskCacheStrategy.ALL).placeholder(R.drawable.man_user).listener(new RequestListener<Bitmap>() {
                @Override
                public boolean onLoadFailed(GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                    AppLog.handleException(getClass().getSimpleName(), e);
                    Utils.showToast(e.getMessage(), loginActivity);
                    Utils.hideCustomProgressDialog();
                    return true;
                }

                @Override
                public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                    currentPhotoPath = getImageFile(resource).getPath();
                    ivRegisterProfileImage.setImageBitmap(resource);
                    Utils.hideCustomProgressDialog();
                    return true;
                }
            }).into(ivRegisterProfileImage);
        }
    }

    private File getImageFile(Bitmap bitmap) {
        File imageFile = new File(loginActivity.getFilesDir(), "name.jpg");

        OutputStream os;
        try {
            os = new FileOutputStream(imageFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
            os.flush();
            os.close();
        } catch (Exception e) {
            AppLog.handleException(getClass().getSimpleName(), e);
        }
        return imageFile;
    }

    private void checkSocialLoginISOn(boolean isSocialLogin) {
        if (isSocialLogin) {
            llSocialLogin.setVisibility(View.VISIBLE);
        } else {
            llSocialLogin.setVisibility(View.GONE);
        }
    }

    /**
     * this class will help to get current city or county according current location
     */
    @SuppressLint("StaticFieldLeak")
    private class GetCityAsyncTask extends AsyncTask<String, Void, Address> {

        double lat, lng;

        public GetCityAsyncTask(double lat, double lng) {
            this.lat = lat;
            this.lng = lng;
        }

        @Override
        protected Address doInBackground(String... params) {
            Geocoder geocoder = new Geocoder(loginActivity, new Locale("en_US"));
            try {
                List<Address> addressList = geocoder.getFromLocation(lat, lng, 1);
                if (addressList != null && !addressList.isEmpty()) {
                    return addressList.get(0);
                }

            } catch (IOException e) {
                AppLog.handleException(RegisterFragment.class.getName(), e);
                publishProgress();
            }

            return null;
        }

        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);
            if (!countryList.isEmpty()) {
                setCountry(countryList.get(0));
            }
        }

        @Override
        protected void onPostExecute(Address address) {
            String countryName, cityName;
            if (address != null) {
                countryName = address.getCountryName();
                checkCountryCode(countryName);
                if (address.getLocality() != null) {
                    cityName = address.getLocality();
                } else if (address.getSubAdminArea() != null) {
                    cityName = address.getSubAdminArea();
                } else {
                    cityName = address.getAdminArea();
                }
            }
        }
    }
}