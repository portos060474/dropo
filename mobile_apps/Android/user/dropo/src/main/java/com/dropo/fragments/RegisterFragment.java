package com.dropo.fragments;

import static android.app.Activity.RESULT_OK;
import static com.dropo.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.DialogInterface;
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
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.LoginActivity;
import com.dropo.user.R;
import com.dropo.component.CustomCountryDialog;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomDialogVerification;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontCheckBox;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomPhotoDialog;
import com.dropo.models.datamodels.Country;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OtpResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.validations.Validator;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageCompression;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
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

public class RegisterFragment extends BottomSheetDialogFragment implements View.OnClickListener {

    public ArrayList<Country> countryList;
    private ImageView ivRegisterProfileImage, ivSuccess;
    private FrameLayout ivRegisterProfileImageSelect;
    private CustomFontEditTextView etRegisterLastName, etRegisterFirstName, etRegisterEmail, etRegisterPassword, etRegisterAddress, etRegisterMobileNumber, etSelectCountry, etSelectCountryPhCode, etSelectCity, etRegisterPasswordRetype;
    private CustomFontButton btnRegister;
    private Country country;
    private Uri picUri;
    private ImageHelper imageHelper;
    private TextInputLayout tilRegisterAddress;
    private CustomFontTextView tvReferralApply;
    private CustomFontEditTextView etReferralCode;
    private String referralCode = "", socialId = "";
    private LinearLayout llReferral;
    private LoginActivity loginActivity;
    private CustomDialogAlert closedPermissionDialog;
    private CustomCountryDialog customCountryDialog;
    private TextInputLayout tilPassword, tilRetypePassword;
    private LinearLayout llSocialLogin;
    private CustomFontCheckBox cbTcPolicy;
    private CustomFontTextView tvPolicy;
    private String currentPhotoPath;
    private CustomDialogVerification customDialogVerification;
    private String otpEmailVerification, otpSmsVerification;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        loginActivity = (LoginActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = LayoutInflater.from(loginActivity).inflate(R.layout.fragment_register, container, false);
        ivRegisterProfileImage = view.findViewById(R.id.ivRegisterProfileImage);
        ivRegisterProfileImageSelect = view.findViewById(R.id.ivRegisterProfileImageSelect);
        etRegisterLastName = view.findViewById(R.id.etRegisterLastName);
        etRegisterEmail = view.findViewById(R.id.etRegisterEmail);
        etRegisterPassword = view.findViewById(R.id.etRegisterPassword);
        etRegisterFirstName = view.findViewById(R.id.etRegisterFirstName);
        etRegisterAddress = view.findViewById(R.id.etRegisterAddress);
        etRegisterMobileNumber = view.findViewById(R.id.etRegisterMobileNumber);
        FieldValidation.setMaxPhoneNumberInputLength(loginActivity, etRegisterMobileNumber);
        etSelectCountry = view.findViewById(R.id.etSelectCountry);
        etSelectCity = view.findViewById(R.id.etSelectCity);
        etSelectCountryPhCode = view.findViewById(R.id.etSelectCountryPhCode);
        btnRegister = view.findViewById(R.id.btnRegister);
        tilRegisterAddress = view.findViewById(R.id.tilRegisterAddress);
        etReferralCode = view.findViewById(R.id.etReferralCode);
        tvReferralApply = view.findViewById(R.id.tvReferralApply);
        ivSuccess = view.findViewById(R.id.ivSuccess);
        etRegisterPasswordRetype = view.findViewById(R.id.etRegisterPasswordRetype);
        llReferral = view.findViewById(R.id.llReferral);
        tilPassword = view.findViewById(R.id.tilPassword);
        tilRetypePassword = view.findViewById(R.id.tilRetypePassword);
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        cbTcPolicy = view.findViewById(R.id.cbTcPolicy);
        tvPolicy = view.findViewById(R.id.tvPolicy);
        loginActivity.initFBLogin(view);
        loginActivity.initGoogleLogin(view);
        loginActivity.initTwitterLogin(view);
        TextView btnLoginNow = view.findViewById(R.id.btnLoginNow);
        btnLoginNow.setOnClickListener(this);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        updateUiForOptionalFiled(loginActivity.preferenceHelper.getIsShowOptionalFieldInRegister());
        checkSocialLoginISOn(loginActivity.preferenceHelper.getIsLoginBySocial());
        imageHelper = new ImageHelper(loginActivity);
        tvReferralApply.setOnClickListener(this);
        btnRegister.setOnClickListener(this);
        etSelectCountry.setOnClickListener(this);
        ivRegisterProfileImageSelect.setOnClickListener(this);
        String link = loginActivity.getResources().getString(R.string.text_link_sign_up_privacy) + " " + "<a href=\"" + loginActivity.preferenceHelper.getTermsANdConditions() + "\"" + ">" + getResources().getString(R.string.text_t_and_c) + "</a>" + " " + loginActivity.getResources().getString(R.string.text_and) + " " + "<a href=\"" + loginActivity.preferenceHelper.getPolicy() + "\"" + ">" + getResources().getString(R.string.text_policy) + "</a>";
        tvPolicy.setText(Utils.fromHtml(link));
        tvPolicy.setMovementMethod(LinkMovementMethod.getInstance());
        countryList = new ArrayList<>();
        getCountries();
        if (loginActivity.preferenceHelper.getIsReferralOn()) {
            llReferral.setVisibility(View.VISIBLE);
        } else {
            llReferral.setVisibility(View.GONE);
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
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
                    // result
                    break;
            }
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnRegister) {
            checkValidationForRegister();
        } else if (id == R.id.ivRegisterProfileImageSelect) {
            checkPermission();
        } else if (id == R.id.etSelectCountry) {
            if (countryList != null) {
                openCountryCodeDialog();
            }
        } else if (id == R.id.tvReferralApply) {
            if (TextUtils.isEmpty(etReferralCode.getText().toString().trim())) {
                Utils.showToast(loginActivity.getResources().getString(R.string.msg_plz_enter_valid_referral), loginActivity);
            } else {
                if (country == null) {
                    Utils.showToast(loginActivity.getResources().getString(R.string.msg_select_your_country_first), loginActivity);
                } else {
                    checkReferralCode();
                }
            }
        } else if (id == R.id.btnLoginNow) {
            loginActivity.swipeLoginAndRegister(true);
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
            new ImageCompression(loginActivity).setImageCompressionListener(new ImageCompression.ImageCompressionListener() {
                @Override
                public void onImageCompression(String compressionImagePath) {
                    currentPhotoPath = compressionImagePath;
                    GlideApp.with(loginActivity).load(picUri).into(ivRegisterProfileImage);
                }
            }).execute(currentPhotoPath);

        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), loginActivity);
        }
    }

    /**
     * this method call a webservice for register a user
     */
    private void register() {
        HashMap<String, RequestBody> registerMap = new HashMap<>();
        registerMap.put(Const.Params.FIRST_NAME, ApiClient.makeTextRequestBody(etRegisterFirstName.getText().toString()));
        registerMap.put(Const.Params.LAST_NAME, ApiClient.makeTextRequestBody(etRegisterLastName.getText().toString()));
        registerMap.put(Const.Params.EMAIL, ApiClient.makeTextRequestBody(etRegisterEmail.getText().toString()));
        registerMap.put(Const.Params.ADDRESS, ApiClient.makeTextRequestBody(etRegisterAddress.getText().toString()));
        registerMap.put(Const.Params.PHONE, ApiClient.makeTextRequestBody(etRegisterMobileNumber.getText().toString()));
        registerMap.put(Const.Params.CITY, ApiClient.makeTextRequestBody(etSelectCity.getText().toString().trim()));

        registerMap.put(Const.Params.DEVICE_TOKEN, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getDeviceToken()));

        registerMap.put(Const.Params.REFERRAL_CODE, ApiClient.makeTextRequestBody(referralCode));
        registerMap.put(Const.Params.APP_VERSION, ApiClient.makeTextRequestBody(loginActivity.getAppVersion()));
        registerMap.put(Const.Params.IS_PHONE_NUMBER_VERIFIED, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getIsPhoneNumberVerified()));
        registerMap.put(Const.Params.IS_EMAIL_VERIFIED, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getIsEmailVerified()));
        registerMap.put(Const.Params.DEVICE_TYPE, ApiClient.makeTextRequestBody(Const.ANDROID));
        registerMap.put(Const.Params.SOCIAL_ID, ApiClient.makeTextRequestBody(socialId));
        registerMap.put(Const.Params.CART_UNIQUE_TOKEN, ApiClient.makeTextRequestBody(loginActivity.preferenceHelper.getAndroidId()));

        if (TextUtils.isEmpty(socialId)) {
            registerMap.put(Const.Params.PASS_WORD, ApiClient.makeTextRequestBody(etRegisterPassword.getText().toString()));
            registerMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.MANUAL));
        } else {
            registerMap.put(Const.Params.PASS_WORD, ApiClient.makeTextRequestBody(""));
            registerMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.SOCIAL));
        }

        registerMap.put(Const.Params.COUNTRY_PHONE_CODE, ApiClient.makeTextRequestBody(country.getCallingCode()));
        registerMap.put(Const.Params.COUNTRY_CODE, ApiClient.makeTextRequestBody(country.getCode()));
        registerMap.put(Const.Params.CURRENCY, ApiClient.makeTextRequestBody(country.getCurrencies().get(0)));
        registerMap.put(Const.Params.COUNTRY_NAME, ApiClient.makeTextRequestBody(etSelectCountry.getText().toString()));

        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<UserDataResponse> register;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            register = apiInterface.register(null, registerMap);
        } else {
            register = apiInterface.register(ApiClient.makeMultipartRequestBody(loginActivity, currentPhotoPath, Const.Params.IMAGE_URL), registerMap);
        }
        register.enqueue(new Callback<UserDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<UserDataResponse> call, @NonNull Response<UserDataResponse> response) {
                if (loginActivity.parseContent.isSuccessful(response)) {
                    if (loginActivity.parseContent.parseUserStorageData(response)) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), loginActivity);
                        if (loginActivity.getCallingActivity() == null) {
                            loginActivity.goToHomeActivity();
                        } else {
                            loginActivity.setResult(Activity.RESULT_OK);
                            loginActivity.onBackPressed();
                        }
                    } else {
                        loginActivity.preferenceHelper.clearVerification();
                    }
                } else {
                    loginActivity.preferenceHelper.clearVerification();
                }
            }

            @Override
            public void onFailure(@NonNull Call<UserDataResponse> call, @NonNull Throwable t) {
                loginActivity.preferenceHelper.clearVerification();
                AppLog.handleThrowable(Const.Tag.REGISTER_FRAGMENT, t);
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
            etRegisterFirstName.setError(msg);
            etRegisterFirstName.requestFocus();
        } else if (TextUtils.isEmpty(etRegisterLastName.getText().toString().trim())) {
            msg = loginActivity.getString(R.string.msg_please_enter_valid_name);
            etRegisterLastName.setError(msg);
            etRegisterLastName.requestFocus();
        } else if (!emailValidation.isValid()) {
            msg = emailValidation.getErrorMsg();
            etRegisterEmail.setError(msg);
            etRegisterEmail.requestFocus();
        } else if (etRegisterPassword.getVisibility() == View.VISIBLE && !passwordValidation.isValid()) {
            msg = passwordValidation.getErrorMsg();
            etRegisterPassword.setError(msg, null);
            etRegisterPassword.requestFocus();
        } else if (country == null) {
            msg = loginActivity.getString(R.string.msg_please_select_country);
            etSelectCountry.setError(msg);
            etSelectCountry.requestFocus();
        } else if (FieldValidation.isValidPhoneNumber(loginActivity, etRegisterMobileNumber.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(loginActivity);
            etRegisterMobileNumber.setError(msg);
            etRegisterMobileNumber.requestFocus();
        } else if (!cbTcPolicy.isChecked()) {
            msg = getResources().getString(R.string.msg_plz_accept_tc);
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
            public void onSelect(Country country) {
                setCountry(country);
                dismiss();
            }
        };
        customCountryDialog.show();
    }

    /**
     * this method call a webservice for get country list
     */
    private void getCountries() {
        ArrayList<Country> countriesMain = loginActivity.parseContent.getRawCountryCodeList();
        ArrayList<Country> countriesModify = new ArrayList<>();
        for (Country countries : countriesMain) {
            for (String callingCode : countries.getCallingCodes()) {
                countries.setCallingCode(callingCode);
                countriesModify.add(countries);
            }
        }
        countryList = countriesModify;
        loginActivity.locationHelper.getLastLocation(location -> {
            if (location != null) {
                new GetCityAsyncTask(location.getLatitude(), location.getLongitude()).execute();
            } else {
                setCountry(countryList.get(0));
            }
        });
    }

    private void updateUiForOptionalFiled(boolean isUpdate) {
        if (isUpdate) {
            tilRegisterAddress.setVisibility(View.VISIBLE);
        } else {
            tilRegisterAddress.setVisibility(View.GONE);
            etRegisterMobileNumber.setImeOptions(EditorInfo.IME_ACTION_DONE);
        }
    }

    private void checkValidationForRegister() {
        if (isValidate()) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.TYPE, String.valueOf(Const.Type.USER));

            switch (loginActivity.checkWitchOtpValidationON()) {
                case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                    map.put(Const.Params.EMAIL, etRegisterEmail.getText().toString());
                    map.put(Const.Params.PHONE, etRegisterMobileNumber.getText().toString());
                    map.put(Const.Params.COUNTRY_PHONE_CODE, country.getCallingCode());
                    getOtpVerify(map);
                    break;
                case Const.SMS_VERIFICATION_ON:
                    map.put(Const.Params.PHONE, etRegisterMobileNumber.getText().toString());
                    map.put(Const.Params.COUNTRY_PHONE_CODE, country.getCallingCode());
                    getOtpVerify(map);
                    break;
                case Const.EMAIL_VERIFICATION_ON:
                    map.put(Const.Params.EMAIL, etRegisterEmail.getText().toString());
                    getOtpVerify(map);
                    break;
                default:
                    // do with default
                    register();
                    break;
            }
        }
    }

    /**
     * this method call a webservice for get OTP of email or mobile
     *
     * @param map map
     */
    private void getOtpVerify(HashMap<String, Object> map) {
        Utils.showCustomProgressDialog(loginActivity, false);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OtpResponse> otpResponseCall = apiInterface.getOtpVerify(map);
        otpResponseCall.enqueue(new Callback<OtpResponse>() {
            @Override
            public void onResponse(@NonNull Call<OtpResponse> call, @NonNull Response<OtpResponse> response) {
                if (loginActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        otpEmailVerification = response.body().getOtpForEmail();
                        otpSmsVerification = response.body().getOtpForSms();
                        switch (loginActivity.checkWitchOtpValidationON()) {
                            case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                                openOTPVerifyDialog(map, getResources().getString(R.string.text_email_otp), getResources().getString(R.string.text_phone_otp), true);
                                break;
                            case Const.SMS_VERIFICATION_ON:
                                openOTPVerifyDialog(map, "", getResources().getString(R.string.text_phone_otp), false);
                                break;
                            case Const.EMAIL_VERIFICATION_ON:
                                openOTPVerifyDialog(map, "", getResources().getString(R.string.text_email_otp), false);
                                break;
                            default:
                                // do with default
                                break;
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), loginActivity);
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

    private void openOTPVerifyDialog(HashMap<String, Object> map, String editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }
        customDialogVerification = new CustomDialogVerification(loginActivity, getResources().getString(R.string.text_verify_detail), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, true) {
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

            @Override
            public void resendOtp() {
                getOtpVerify(map);
            }
        };
        customDialogVerification.show();
    }

    /**
     * this method call a webservice for check referral code enter by user
     */
    private void checkReferralCode() {
        Utils.showCustomProgressDialog(loginActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.REFERRAL_CODE, etReferralCode.getText().toString().trim());
        map.put(Const.Params.COUNTRY_ID, "");
        map.put(Const.Params.COUNTRY_CODE, country.getCode());
        map.put(Const.Params.TYPE, Const.Type.USER);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.getCheckReferral(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (loginActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
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
                AppLog.handleThrowable(Const.Tag.REGISTER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void checkCountryCode(String country) {
        int countryListSize = countryList.size();
        for (int i = 0; i < countryListSize; i++) {
            if (countryList.get(i).getName().toUpperCase().startsWith(country.toUpperCase())) {
                setCountry(countryList.get(i));
                return;
            }
        }
        setCountry(countryList.get(0));
    }

    private void setCountry(Country country) {
        if (!countryList.isEmpty() && (this.country == null || !TextUtils.equals(this.country.getCode(), country.getCode()))) {
            this.country = country;
            etSelectCountry.setText(country.getName());
            etSelectCountryPhCode.setText(country.getCallingCode());
            etRegisterMobileNumber.getText().clear();
            etSelectCountry.setError(null);
            etReferralCode.setEnabled(true);
            etReferralCode.getText().clear();
            ivSuccess.setVisibility(View.GONE);
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
        if (ContextCompat.checkSelfPermission(loginActivity, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(loginActivity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
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

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        if (loginActivity != null && loginActivity.loginFragment == null && !loginActivity.isFinishing()) {
            loginActivity.onBackPressed();
        }
    }

    /**
     * this class will help to get current cityName or county according current location
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
            setCountry(countryList.get(0));
        }

        @Override
        protected void onPostExecute(Address address) {
            String countryName;
            if (address != null) {
                countryName = address.getCountryName();
                checkCountryCode(countryName);
            }
        }
    }
}