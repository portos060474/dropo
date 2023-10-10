package com.dropo.provider;

import static com.dropo.provider.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.provider.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.InputType;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomPhotoDialog;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OtpResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppColor;
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
import java.util.HashMap;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProfileActivity extends BaseAppCompatActivity {

    private ImageView ivProfileImage;
    private CustomFontEditTextView etProfileLastName, etProfileFirstName, etProfileEmail, etProfileAddress, etProfileMobileNumber, etProfileCountryCode, etProfileZipCode, etNewPassword, etConfirmPassword;
    private CardView ivProfileImageSelect;
    private Uri picUri;
    private ImageHelper imageHelper;
    private CustomFontTextView tvChangePassword;
    private TextInputLayout tilProfileAddress, tilProfileZipCode;
    private CustomDialogAlert closedPermissionDialog;
    private LinearLayout llChangePassword;
    private ScrollView scrollView;
    private CustomDialogVerification customDialogVerification, customOtpVerification;
    private String currentPhotoPath, currentPassword;
    private String otpEmailVerification, otpSmsVerification;
    private TextView tvDeleteAccount;
    private CustomDialogAlert customDialogConfirmation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_profile));
        setToolbarRightIcon(R.drawable.ic_edit, this);
        initViewById();
        setViewListener();
        setProfileData();
        imageHelper = new ImageHelper(this);
        setDataEnable(false);
        updateUiForOptionalFiled(preferenceHelper.getIsShowOptionalFieldInRegister());
        FieldValidation.setMaxPhoneNumberInputLength(this, etProfileMobileNumber);
        updateUiForSocial();
    }

    @Override
    protected boolean isValidate() {
        String msg = null;

        if (TextUtils.isEmpty(etProfileFirstName.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_please_enter_valid_name);
            etProfileFirstName.setError(msg);
            etProfileFirstName.requestFocus();
        } else if (TextUtils.isEmpty(etProfileLastName.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_please_enter_valid_name);
            etProfileLastName.setError(msg);
            etProfileLastName.requestFocus();
        } else if (!FieldValidation.isValidPhoneNumber(this, etProfileMobileNumber.getText().toString())) {
            msg = FieldValidation.getPhoneNumberValidationMessage(this);
            etProfileMobileNumber.setError(msg);
            etProfileMobileNumber.requestFocus();
        } else if (etProfileMobileNumber.getText().toString().trim().length() > preferenceHelper.getMaxPhoneNumberLength() || etProfileMobileNumber.getText().toString().trim().length() < preferenceHelper.getMinPhoneNumberLength()) {
            msg = getResources().getString(R.string.msg_please_enter_valid_mobile_number) + " " + "" + preferenceHelper.getMinPhoneNumberLength() + getResources().getString(R.string.text_or) + preferenceHelper.getMaxPhoneNumberLength() + " " + getResources().getString(R.string.text_digits);
            etProfileMobileNumber.setError(msg);
            etProfileMobileNumber.requestFocus();
        } else if (tvChangePassword.getVisibility() == View.VISIBLE && !TextUtils.isEmpty(etNewPassword.getText().toString().trim()) && etNewPassword.getText().toString().trim().length() < 6) {
            msg = getString(R.string.msg_enter_valid_password);
            etNewPassword.setError(msg);
            etNewPassword.requestFocus();
        } else if (tvChangePassword.getVisibility() == View.VISIBLE && !etNewPassword.getText().toString().trim().equalsIgnoreCase(etConfirmPassword.getText().toString().trim())) {
            msg = getString(R.string.msg_incorrect_confirm_password);
            etConfirmPassword.setError(msg);
            etConfirmPassword.requestFocus();
        } else if (!Patterns.EMAIL_ADDRESS.matcher(etProfileEmail.getText().toString().trim()).matches()) {
            msg = getResources().getString(R.string.msg_please_enter_valid_email);
            etProfileEmail.setError(msg);
            etProfileEmail.requestFocus();
        }

        return TextUtils.isEmpty(msg);
    }

    @Override
    protected void initViewById() {
        etProfileFirstName = findViewById(R.id.etProfileFirstName);
        etProfileLastName = findViewById(R.id.etProfileLastName);
        etProfileEmail = findViewById(R.id.etProfileEmail);
        etProfileAddress = findViewById(R.id.etProfileAddress);
        etProfileMobileNumber = findViewById(R.id.etProfileMobileNumber);
        etProfileCountryCode = findViewById(R.id.etProfileCountryCode);
        etProfileZipCode = findViewById(R.id.etProfileZipCode);
        ivProfileImage = findViewById(R.id.ivProfileImage);
        ivProfileImageSelect = findViewById(R.id.ivProfileImageSelect);
        etNewPassword = findViewById(R.id.etNewPassword);
        etConfirmPassword = findViewById(R.id.etConfirmPassword);
        tilProfileZipCode = findViewById(R.id.tilProfileZipCode);
        tilProfileAddress = findViewById(R.id.tilProfileAddress);
        llChangePassword = findViewById(R.id.llChangePassword);
        tvChangePassword = findViewById(R.id.tvChangePassword);
        scrollView = findViewById(R.id.scrollView);
        tvDeleteAccount = findViewById(R.id.tvDeleteAccount);
        TextView tvReferralCode = findViewById(R.id.tvReferralCode);
        tvReferralCode.setCompoundDrawablesRelativeWithIntrinsicBounds(AppColor.getThemeColorDrawable(R.drawable.ic_share_stroke, this), null, null, null);
        tvReferralCode.setText(String.format("%s %s", getString(R.string.msg_share_referral), preferenceHelper.getReferral()));
        findViewById(R.id.cvReferral).setOnClickListener(this);
    }

    private void setDataEnable(boolean isEnable) {
        etProfileFirstName.setEnabled(isEnable);
        etProfileMobileNumber.setEnabled(isEnable);
        etProfileLastName.setEnabled(isEnable);
        etProfileAddress.setEnabled(isEnable);
        etProfileCountryCode.setEnabled(false);
        etProfileZipCode.setEnabled(isEnable);
        etNewPassword.setEnabled(isEnable);
        etConfirmPassword.setEnabled(isEnable);
        tvChangePassword.setEnabled(isEnable);

        etProfileFirstName.setFocusableInTouchMode(isEnable);
        etProfileMobileNumber.setFocusableInTouchMode(isEnable);
        etProfileLastName.setFocusableInTouchMode(isEnable);
        etProfileAddress.setFocusableInTouchMode(isEnable);
        etProfileCountryCode.setFocusableInTouchMode(isEnable);
        etProfileZipCode.setFocusableInTouchMode(isEnable);
        etNewPassword.setFocusableInTouchMode(isEnable);
        etConfirmPassword.setFocusableInTouchMode(isEnable);

        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            etProfileEmail.setEnabled(isEnable);
            etProfileEmail.setFocusableInTouchMode(isEnable);
        } else {
            etProfileEmail.setEnabled(false);
            etProfileEmail.setFocusableInTouchMode(false);
        }
        if (isEnable) {
            ivProfileImageSelect.setOnClickListener(this);
        } else {
            ivProfileImageSelect.setOnClickListener(null);
        }
    }

    private void setProfileData() {
        etProfileFirstName.setText(preferenceHelper.getFirstName());
        etProfileMobileNumber.setText(preferenceHelper.getPhoneNumber());
        etProfileLastName.setText(preferenceHelper.getLastName());
        etProfileAddress.setText(preferenceHelper.getAddress());
        etProfileCountryCode.setText(preferenceHelper.getPhoneCountyCode());
        etProfileZipCode.setText(preferenceHelper.getZipCode());
        etProfileEmail.setText(preferenceHelper.getEmail());
        GlideApp.with(this)
                .load(preferenceHelper.getProfilePic())
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.man_user, null))
                .fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.man_user, null))
                .into(ivProfileImage);
    }

    @Override
    protected void setViewListener() {
        tvChangePassword.setOnClickListener(this);
        tvDeleteAccount.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        Utils.hideSoftKeyboard(this);
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivProfileImageSelect) {
            checkPermission();
        } else if (id == R.id.tvChangePassword) {
            if (llChangePassword.getVisibility() == View.VISIBLE) {
                llChangePassword.setVisibility(View.GONE);
            } else {
                llChangePassword.setVisibility(View.VISIBLE);
                scrollView.post(() -> scrollView.fullScroll(View.FOCUS_DOWN));
            }
        } else if (id == R.id.cvReferral) {
            shareAppAndReferral();
        } else if (id == R.id.ivToolbarRightIcon) {
            editProfile();
        } else if (id == R.id.tvDeleteAccount) {
            openDeleteAccountConfirmationDialog();
        }
    }

    private void openDeleteAccountConfirmationDialog() {
        if (!this.isFinishing()) {
            if (customDialogConfirmation != null && customDialogConfirmation.isShowing()) {
                return;
            }

            customDialogConfirmation = new CustomDialogAlert(this, getString(R.string.text_delete_account), getString(R.string.msg_are_you_sure_delete_account), getString(R.string.text_yes)) {
                @Override
                public void onClickLeftButton() {
                    closeDeleteAccountConfirmationDialog();
                }

                @Override
                public void onClickRightButton() {
                    closeDeleteAccountConfirmationDialog();
                    openVerifyAccountDialog(true);
                }
            };

            customDialogConfirmation.show();
        }
    }

    private void closeDeleteAccountConfirmationDialog() {
        if (customDialogConfirmation != null && customDialogConfirmation.isShowing()) {
            customDialogConfirmation.dismiss();
            customDialogConfirmation = null;
        }
    }

    private void deleteAccount() {
        Utils.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SOCIAL_ID, preferenceHelper.getSocialId());
        map.put(Const.Params.PASS_WORD, currentPassword);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteAccount(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            preferenceHelper.logout();
                            mAuth.signOut();
                            goToLoginActivity();
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProfileActivity.this);
                        }
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

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void openPhotoSelectDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(this, getResources().getString(R.string.text_set_profile_photos)) {
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
            picUri = FileProvider.getUriForFile(this, getPackageName(), file);
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
        CropImage.activity(sourceUri).setGuidelines(com.theartofdev.edmodo.cropper.CropImageView.Guidelines.ON).start(this);
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
            new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
                currentPhotoPath = compressionImagePath;
                GlideApp.with(ProfileActivity.this).load(picUri).into(ivProfileImage);
            }).execute(currentPhotoPath);

        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), this);
        }
    }

    private void goWithCameraAndStoragePermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else {
            //
            openPhotoSelectDialog();
        }
    }

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                ActivityCompat.requestPermissions(ProfileActivity.this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
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

    /**
     * this method call a webservice for updateProfile of user
     *
     * @param currentPassword set current password in string
     */
    private void updateProfile(String currentPassword) {
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getSessionToken()));
        hashMap.put(Const.Params.PROVIDER_ID, ApiClient.makeTextRequestBody(preferenceHelper.getProviderId()));
        hashMap.put(Const.Params.FIRST_NAME, ApiClient.makeTextRequestBody(etProfileFirstName.getText().toString()));
        hashMap.put(Const.Params.LAST_NAME, ApiClient.makeTextRequestBody(etProfileLastName.getText().toString()));
        hashMap.put(Const.Params.PHONE, ApiClient.makeTextRequestBody(etProfileMobileNumber.getText().toString()));

        hashMap.put(Const.Params.ADDRESS, ApiClient.makeTextRequestBody(etProfileAddress.getText().toString()));
        hashMap.put(Const.Params.ZIP_CODE, ApiClient.makeTextRequestBody(etProfileZipCode.getText().toString()));

        hashMap.put(Const.Params.EMAIL, ApiClient.makeTextRequestBody(etProfileEmail.getText().toString()));

        hashMap.put(Const.Params.IS_PHONE_NUMBER_VERIFIED, ApiClient.makeTextRequestBody(preferenceHelper.getIsPhoneNumberVerified()));
        hashMap.put(Const.Params.IS_EMAIL_VERIFIED, ApiClient.makeTextRequestBody(preferenceHelper.getIsEmailVerified()));
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            hashMap.put(Const.Params.OLD_PASS_WORD, ApiClient.makeTextRequestBody(currentPassword));
            hashMap.put(Const.Params.NEW_PASS_WORD, ApiClient.makeTextRequestBody(etNewPassword.getText().toString()));
            hashMap.put(Const.Params.SOCIAL_ID, ApiClient.makeTextRequestBody(""));
            hashMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.MANUAL));

        } else {
            hashMap.put(Const.Params.OLD_PASS_WORD, ApiClient.makeTextRequestBody(""));
            hashMap.put(Const.Params.NEW_PASS_WORD, ApiClient.makeTextRequestBody(""));
            hashMap.put(Const.Params.SOCIAL_ID, ApiClient.makeTextRequestBody(preferenceHelper.getSocialId()));
            hashMap.put(Const.Params.LOGIN_BY, ApiClient.makeTextRequestBody(Const.SOCIAL));
        }

        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProviderDataResponse> responseCall;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            responseCall = apiInterface.updateProfile(null, hashMap);
        } else {
            responseCall = apiInterface.updateProfile(ApiClient.makeMultipartRequestBody(currentPhotoPath, Const.Params.IMAGE_URL), hashMap);
        }
        responseCall.enqueue(new Callback<ProviderDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProviderDataResponse> call, @NonNull Response<ProviderDataResponse> response) {
                if (parseContent.parseUserStorageData(response)) {
                    Utils.showMessageToast(response.body().getStatusPhrase(), ProfileActivity.this);
                    onBackPressed();
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProfileActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProviderDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openVerifyAccountDialog(boolean isForAccountDelete) {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            if (customDialogVerification != null && customDialogVerification.isShowing()) {
                return;
            }
            customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_account), getResources().getString(R.string.msg_enter_password_which_used_in_register), getResources().getString(R.string.text_ok), "", getResources().getString(R.string.text_password), false, InputType.TYPE_CLASS_TEXT, InputType.TYPE_TEXT_VARIATION_PASSWORD, false) {
                @Override
                protected void resendOtp() {

                }

                @Override
                public void onClickLeftButton() {
                    dismiss();
                }

                @Override
                public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                    if (!etDialogEditTextTwo.getText().toString().isEmpty()) {
                        dismiss();
                        currentPassword = etDialogEditTextTwo.getText().toString();
                        if (isForAccountDelete) {
                            deleteAccount();
                        } else {
                            updateProfile(etDialogEditTextTwo.getText().toString());
                        }
                    } else {
                        etDialogEditTextTwo.setError(getString(R.string.msg_enter_password));
                    }
                }

            };
            customDialogVerification.show();
        } else {
            if (isForAccountDelete) {
                deleteAccount();
            } else {
                updateProfile("");
            }
        }
    }

    /**
     * this method mange edit icon toggle
     */
    private void editProfile() {
        if (!etProfileFirstName.isEnabled()) {
            setDataEnable(true);
            setToolbarRightIcon(R.drawable.ic_save, this);
        } else {
            if (isValidate()) {
                HashMap<String, Object> map = new HashMap<>();
                map.put(Const.Params.ID, preferenceHelper.getProviderId());
                map.put(Const.Params.TYPE, String.valueOf(Const.TYPE_PROVIDER));

                switch (checkProfileWitchOtpValidationON()) {
                    case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                        map.put(Const.Params.EMAIL, etProfileEmail.getText().toString());
                        map.put(Const.Params.PHONE, etProfileMobileNumber.getText().toString());
                        map.put(Const.Params.COUNTRY_PHONE_CODE, etProfileCountryCode.getText().toString());
                        getOtpVerify(map);
                        break;
                    case Const.SMS_VERIFICATION_ON:
                        map.put(Const.Params.PHONE, etProfileMobileNumber.getText().toString());
                        map.put(Const.Params.COUNTRY_PHONE_CODE, etProfileCountryCode.getText().toString());
                        getOtpVerify(map);
                        break;
                    case Const.EMAIL_VERIFICATION_ON:
                        map.put(Const.Params.EMAIL, etProfileEmail.getText().toString());
                        getOtpVerify(map);
                        break;
                    default:
                        openVerifyAccountDialog(false);
                        break;
                }
            }
        }
    }

    /**
     * this method call a webservice for get OTP of email or mobile
     *
     * @param jsonObject jsonObject
     */
    private void getOtpVerify(HashMap<String, Object> jsonObject) {
        Utils.showCustomProgressDialog(this, false);

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
                        switch (checkProfileWitchOtpValidationON()) {
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
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProfileActivity.this);
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

    private void updateUiForOptionalFiled(boolean isUpdate) {
        if (isUpdate) {
            tilProfileAddress.setVisibility(View.VISIBLE);
            tilProfileZipCode.setVisibility(View.VISIBLE);
        } else {
            tilProfileAddress.setVisibility(View.GONE);
            tilProfileZipCode.setVisibility(View.GONE);
        }
    }

    private void openOTPVerifyDialog(HashMap<String, Object> jsonObject, String editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }
        customOtpVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_detail), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, false) {
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
                switch (checkWitchOtpValidationON()) {
                    case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextOne.getText().toString(), otpEmailVerification)) {
                            if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                                preferenceHelper.putIsEmailVerified(true);
                                preferenceHelper.putIsPhoneNumberVerified(true);
                                dismiss();
                                openVerifyAccountDialog(false);
                            } else {
                                etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                            }
                        } else {
                            etDialogEditTextOne.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    case Const.SMS_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpSmsVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpSmsVerification)) {
                            preferenceHelper.putIsPhoneNumberVerified(true);
                            dismiss();
                            openVerifyAccountDialog(false);
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_sms_otp_wrong));
                        }
                        break;
                    case Const.EMAIL_VERIFICATION_ON:
                        if (!TextUtils.isEmpty(otpEmailVerification) && TextUtils.equals(etDialogEditTextTwo.getText().toString(), otpEmailVerification)) {
                            preferenceHelper.putIsEmailVerified(true);
                            dismiss();
                            openVerifyAccountDialog(false);
                        } else {
                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_email_otp_wrong));
                        }
                        break;
                    default:
                        break;
                }
            }
        };

        customOtpVerification.show();
    }

    /**
     * this method will manage which otp validation is on from admin panel
     *
     * @return get code according for validation
     */
    private int checkProfileWitchOtpValidationON() {
        if (checkEmailVerificationON() && checkPhoneNumberVerificationON()) {
            return Const.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerificationON()) {
            return Const.SMS_VERIFICATION_ON;
        } else if (checkEmailVerificationON()) {
            return Const.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }

    private boolean checkPhoneNumberVerificationON() {
        return preferenceHelper.getIsSmsVerification() && !TextUtils.equals(etProfileMobileNumber.getText().toString(), preferenceHelper.getPhoneNumber());
    }

    private boolean checkEmailVerificationON() {
        return preferenceHelper.getIsMailVerification() && !TextUtils.equals(etProfileEmail.getText().toString(), preferenceHelper.getEmail());
    }

    private void updateUiForSocial() {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            tvChangePassword.setVisibility(View.VISIBLE);
        } else {
            tvChangePassword.setVisibility(View.GONE);
        }
    }

    private void shareAppAndReferral() {
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(Intent.EXTRA_TEXT, getResources().getString(R.string.msg_use_referral_code) + " " + preferenceHelper.getReferral());
        startActivity(Intent.createChooser(sharingIntent, getResources().getString(R.string.msg_share_referral)));
    }
}