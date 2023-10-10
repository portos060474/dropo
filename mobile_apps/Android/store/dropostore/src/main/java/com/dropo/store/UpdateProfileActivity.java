package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomEditTextDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.StoreData;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.OTPResponse;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageCompression;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputEditText;
import com.makeramen.roundedimageview.RoundedImageView;

import org.json.JSONArray;

import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class UpdateProfileActivity extends BaseActivity {

    private final String TAG = "UpdateProfileActivity";
    private EditText etName, etEmail, etNewPassword, etConfirmNewPassword, etMobileNo, etVerifyPassword;
    private Uri uri;
    private RoundedImageView ivProfile;
    private TextView tvCountryCode;
    private BottomSheetDialog dialog;
    private CustomTextView tvChangePassword;
    private LinearLayout llChangePassword;
    private CustomEditTextDialog accountVerifyDialog;
    private ScrollView scrollView;
    private ImageHelper imageHelper;
    private String currentPhotoPath;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private String otpId;
    private CustomAlterDialog customDialogConfirmation;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_profile);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_profile));
        etName = findViewById(R.id.etName);
        etEmail = findViewById(R.id.etEmail);
        etNewPassword = findViewById(R.id.etNewPassword);
        etConfirmNewPassword = findViewById(R.id.etConfirmNewPassword);
        etMobileNo = findViewById(R.id.etMobileNo);

        tvCountryCode = findViewById(R.id.tvCountryCode);
        scrollView = findViewById(R.id.scrollView);
        ivProfile = findViewById(R.id.ivProfile);
        llChangePassword = findViewById(R.id.llChangePassword);
        tvChangePassword = findViewById(R.id.tvChangePassword);
        tvChangePassword.setOnClickListener(this);
        findViewById(R.id.ivProfileImageSelect).setOnClickListener(this);
        imageHelper = new ImageHelper(this);
        etName.setOnClickListener(this);
        findViewById(R.id.tvDeleteAccount).setOnClickListener(this);
        TextView tvReferralCode = findViewById(R.id.tvReferralCode);
        tvReferralCode.setText(String.format("%s %s", getString(R.string.msg_share_referral), preferenceHelper.getReferralCode()));
        findViewById(R.id.cvReferral).setOnClickListener(this);

        setEnableView(false);
        getStoreData();
        updateUiForSocial();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.etName) {
            addMultiLanguageDetail(etName.getHint().toString(), (List<String>) etName.getTag(), detailList -> {
                etName.setTag(detailList);
                etName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
            });
        } else if (id == R.id.ivProfileImageSelect) {
            if (isEditable) showPhotoSelectionDialog();
        } else if (id == R.id.btnRegister) {
            validate();
        } else if (id == R.id.tvChangePassword) {
            if (llChangePassword.getVisibility() == View.VISIBLE) {
                llChangePassword.setVisibility(View.GONE);
            } else {
                llChangePassword.setVisibility(View.VISIBLE);
                scrollView.post(() -> scrollView.fullScroll(View.FOCUS_DOWN));
            }
        } else if (id == R.id.cvReferral) {
            shareAppAndReferral();
        } else if (id == R.id.tvDeleteAccount) {
            openDeleteAccountConfirmationDialog();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(true, R.drawable.ic_edit);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ivEditMenu) {
            if (!isEditable) {
                isEditable = true;
                setEnableView(true);
                setToolbarEditIcon(false, R.drawable.ic_edit);
                setToolbarSaveIcon(true);
            }
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            validate();
        }
        return super.onOptionsItemSelected(item);
    }

    private void setEnableView(boolean isEnable) {
        etName.setEnabled(isEnable);
        etEmail.setEnabled(isEnable);
        etMobileNo.setEnabled(isEnable);
        etNewPassword.setEnabled(isEnable);
        etConfirmNewPassword.setEnabled(isEnable);
        tvCountryCode.setEnabled(isEnable);
        tvChangePassword.setClickable(isEnable);
        etMobileNo.setFocusableInTouchMode(isEnable);

        etNewPassword.setFocusableInTouchMode(isEnable);
        etConfirmNewPassword.setFocusableInTouchMode(isEnable);
        tvCountryCode.setFocusableInTouchMode(isEnable);

        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            etEmail.setEnabled(isEnable);
            etEmail.setFocusableInTouchMode(isEnable);
        } else {
            etEmail.setEnabled(false);
            etEmail.setFocusableInTouchMode(false);
        }
    }

    /**
     * this method call webservice for get Store Detail data
     */
    private void getStoreData() {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        Call<StoreDataResponse> call = ApiClient.getClient().create(ApiInterface.class).getStoreDate(map);

        call.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.putIsStoreCanCreateGroup(response.body().getStoreDetail().getDeliveryDetails().isStoreCanCreateGroup());
                        setStoreData(response.body().getStoreDetail());
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateProfileActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), UpdateProfileActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void openDeleteAccountConfirmationDialog() {
        if (!this.isFinishing()) {
            if (customDialogConfirmation != null && customDialogConfirmation.isShowing()) {
                return;
            }

            customDialogConfirmation = new CustomAlterDialog(this, getString(R.string.text_delete_account), getString(R.string.msg_are_you_sure_delete_account), true, getString(R.string.text_yes)) {
                @Override
                public void btnOnClick(int btnId) {
                    if (btnId == R.id.btnNegative) {
                        closeDeleteAccountConfirmationDialog();
                    } else if (btnId == R.id.btnPositive) {
                        closeDeleteAccountConfirmationDialog();
                        showVerificationDialog(true);
                    }
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
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SOCIAL_ID, preferenceHelper.getSocialId());
        map.put(Constant.PASS_WORD, etVerifyPassword.getText().toString());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteAccount(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            mAuth.signOut();
                            gotoMainActivity();
                        } else {
                            parseContent.showErrorMessage(UpdateProfileActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void setStoreData(StoreData storeData) {
        if (storeData != null) {
            etName.setText(storeData.getName());
            etName.setTag(storeData.getNameList());
            etEmail.setText(storeData.getEmail());
            etMobileNo.setText(storeData.getPhone());
            tvCountryCode.setText(storeData.getCountryPhoneCode());
            GlideApp.with(this)
                    .load(IMAGE_URL + storeData.getImageUrl())
                    .fallback(R.drawable.man_user)
                    .error(R.drawable.man_user)
                    .into(ivProfile);
            FieldValidation.setMaxPhoneNumberInputLength(this, etMobileNo);
        }
    }

    private void validate() {
        if (TextUtils.isEmpty(etName.getText().toString())) {
            etName.setError(this.getResources().getString(R.string.msg_empty_name));
        } else if (TextUtils.isEmpty(etEmail.getText().toString())) {
            etEmail.setError(this.getResources().getString(R.string.msg_empty_email));
        } else if (!Patterns.EMAIL_ADDRESS.matcher(etEmail.getText().toString()).matches()) {
            etEmail.setError(this.getResources().getString(R.string.msg_valid_email));
        } else if (TextUtils.isEmpty(etMobileNo.getText().toString())) {
            etMobileNo.setError(this.getResources().getString(R.string.msg_empty_mobileNo));
        } else if (!FieldValidation.isValidPhoneNumber(this, etMobileNo.getText().toString())) {
            String msg = FieldValidation.getPhoneNumberValidationMessage(this);
            etMobileNo.setError(msg);
            etMobileNo.requestFocus();
        } else if (tvChangePassword.getVisibility() == View.VISIBLE && !TextUtils.isEmpty(etNewPassword.getText().toString().trim()) && etNewPassword.getText().toString().trim().length() < 6) {
            etNewPassword.setError(getString(R.string.msg_password_length));
            etNewPassword.requestFocus();
        } else if (tvChangePassword.getVisibility() == View.VISIBLE && !etNewPassword.getText().toString().trim().equalsIgnoreCase(etConfirmNewPassword.getText().toString().trim())) {
            etConfirmNewPassword.setError(getString(R.string.msg_mismatch_password));
        } else {
            checkForOtp();
        }
    }

    private void checkForOtp() {
        if (checkProfileWitchOtpValidationON() != -1) {
            getOtp();
        } else {
            showVerificationDialog(false);
        }
    }

    /**
     * this method will manage which otp validation is on from admin panel
     *
     * @return get code according for validation
     */
    private int checkProfileWitchOtpValidationON() {
        if (checkEmailVerificationON() && checkPhoneNumberVerificationON()) {
            return Constant.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerificationON()) {
            return Constant.SMS_VERIFICATION_ON;
        } else if (checkEmailVerificationON()) {
            return Constant.EMAIL_VERIFICATION_ON;
        }
        return -1;
    }

    private boolean checkPhoneNumberVerificationON() {
        return preferenceHelper.getIsVerifyPhone() && !TextUtils.equals(etMobileNo.getText().toString(), preferenceHelper.getPhone());
    }

    private boolean checkEmailVerificationON() {
        return preferenceHelper.getIsVerifyEmail() && !TextUtils.equals(etEmail.getText().toString(), preferenceHelper.getEmail());
    }

    /**
     * this method called webservice for get OTP for mobile or email
     */
    private void getOtp() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.ID, preferenceHelper.getStoreId());
        switch (checkProfileWitchOtpValidationON()) {
            case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                map.put(Constant.EMAIL, etEmail.getText().toString());
                map.put(Constant.PHONE, etMobileNo.getText().toString());
                break;
            case Constant.SMS_VERIFICATION_ON:
                map.put(Constant.PHONE, etMobileNo.getText().toString());
                break;
            case Constant.EMAIL_VERIFICATION_ON:
                map.put(Constant.EMAIL, etEmail.getText().toString());
                break;
            default:
                // do with default
                break;
        }
        map.put(Constant.TYPE, String.valueOf(Constant.Type.STORE));
        map.put(Constant.COUNTRY_CODE, preferenceHelper.getCountryPhoneCode());

        Call<OTPResponse> otpResponseCall = ApiClient.getClient().create(ApiInterface.class).getStoreOtp(map);
        otpResponseCall.enqueue(new Callback<OTPResponse>() {
            @Override
            public void onResponse(@NonNull Call<OTPResponse> call, @NonNull Response<OTPResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        otpId = response.body().getOtpId();
                        openAccountVerifyDialog(map);
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateProfileActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), UpdateProfileActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> cal, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void openAccountVerifyDialog(HashMap<String, Object> map) {
        if (accountVerifyDialog != null && accountVerifyDialog.isShowing()) {
            return;
        }
        final int otpType = checkProfileWitchOtpValidationON();
        if (otpType != -1) {
            String message = null;

            switch (otpType) {
                case Constant.EMAIL_VERIFICATION_ON:
                    message = getString(R.string.text_verify_email);
                    break;
                case Constant.SMS_VERIFICATION_ON:
                    message = getString(R.string.text_verify_sms);
                    break;
                case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                    message = getString(R.string.text_verify_email_sms);
                    break;
                default:
                    break;
            }

            accountVerifyDialog = new CustomEditTextDialog(this, false, getString(R.string.text_verify_details), message, getString(R.string.text_ok), otpType, map) {

                @Override
                public void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmailOtp) {
                    if (btnId == R.id.btnPositive) {
                        switch (otpType) {
                            case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else if (TextUtils.isEmpty(etEmailOtp.getText())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString(), etSMSOtp.getText().toString(), otpId);
                                }
                                break;
                            case Constant.SMS_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(null, etSMSOtp.getText().toString(), otpId);
                                }
                                break;
                            case Constant.EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etEmailOtp.getText())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString(), null, otpId);
                                }
                                break;
                        }
                    } else {
                        dismiss();
                        finish();
                    }
                }

                @Override
                public void resetOtpId(String otpId) {
                    UpdateProfileActivity.this.otpId = otpId;
                }
            };
            accountVerifyDialog.setCancelable(false);
            accountVerifyDialog.show();
        }

    }

    /**
     * this method call a webservice for set OTP verification result
     */
    private void verifyStoreOtp(String emailOTP, String smsOTP, String otpId) {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        if (!TextUtils.isEmpty(emailOTP)) {
            map.put(Constant.EMAIL_OTP, emailOTP);
        }
        if (!TextUtils.isEmpty(smsOTP)) {
            map.put(Constant.SMS_OTP, smsOTP);
        }
        map.put(Constant.OTP_ID, otpId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OTPResponse> getStoreOtpResponse = apiInterface.storeOtpVerification(map);
        getStoreOtpResponse.enqueue(new Callback<OTPResponse>() {
            @Override
            public void onResponse(@NonNull Call<OTPResponse> call, @NonNull Response<OTPResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        if (accountVerifyDialog != null && accountVerifyDialog.isShowing()) {
                            accountVerifyDialog.dismiss();
                        }
                        showVerificationDialog(false);
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateProfileActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), UpdateProfileActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void showVerificationDialog(boolean isForAccountDelete) {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            if (dialog == null) {
                dialog = new BottomSheetDialog(this);
                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
                dialog.setContentView(R.layout.dialog_account_verification);
                etVerifyPassword = dialog.findViewById(R.id.etCurrentPassword);

                dialog.findViewById(R.id.btnPositive).setOnClickListener(v -> {
                    if (!TextUtils.isEmpty(etVerifyPassword.getText().toString())) {
                        if (dialog != null && dialog.isShowing()) {
                            dialog.dismiss();
                        }
                        if (isForAccountDelete) {
                            deleteAccount();
                        } else {
                            updateProfile();
                        }
                    } else {
                        etVerifyPassword.setError(getString(R.string.msg_empty_password));
                    }
                });

                dialog.findViewById(R.id.btnNegative).setOnClickListener(v -> {
                    if (dialog != null && dialog.isShowing()) {
                        dialog.dismiss();
                    }
                });

                dialog.setOnDismissListener(dialog1 -> dialog = null);
                WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
                params.width = WindowManager.LayoutParams.MATCH_PARENT;
                dialog.show();
            }
        } else {
            if (isForAccountDelete) {
                deleteAccount();
            } else {
                updateProfile();
            }
        }
    }

    /**
     * this method call a webservice for update profile data
     */
    private void updateProfile() {
        Utilities.showProgressDialog(this);
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getServerToken()));
        map.put(Constant.NAME, ApiClient.makeTextRequestBody(new JSONArray((List<String>) etName.getTag())));
        map.put(Constant.EMAIL, ApiClient.makeTextRequestBody(etEmail.getText().toString().trim().toLowerCase()));
        map.put(Constant.PHONE, ApiClient.makeTextRequestBody(etMobileNo.getText().toString().trim()));

        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            map.put(Constant.CURRENT_PASS_WORD, ApiClient.makeTextRequestBody(etVerifyPassword.getText().toString()));
            map.put(Constant.NEW_PASS_WORD, ApiClient.makeTextRequestBody(etNewPassword.getText().toString()));
            map.put(Constant.SOCIAL_ID, ApiClient.makeTextRequestBody(""));
            map.put(Constant.LOGIN_BY, ApiClient.makeTextRequestBody(Constant.MANUAL));

        } else {
            map.put(Constant.CURRENT_PASS_WORD, ApiClient.makeTextRequestBody(""));
            map.put(Constant.NEW_PASS_WORD, ApiClient.makeTextRequestBody(""));
            map.put(Constant.SOCIAL_ID, ApiClient.makeTextRequestBody(preferenceHelper.getSocialId()));
            map.put(Constant.LOGIN_BY, ApiClient.makeTextRequestBody(Constant.SOCIAL));
        }
        map.put(Constant.IS_PHONE_NUMBER_VERIFIED, ApiClient.makeTextRequestBody(String.valueOf(preferenceHelper.isPhoneNumberVerified())));
        map.put(Constant.IS_EMAIL_VERIFIED, ApiClient.makeTextRequestBody(String.valueOf(preferenceHelper.isEmailVerified())));

        Call<StoreDataResponse> call = ApiClient.getClient().create(ApiInterface.class)
                .updateProfile(map, ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL));
        call.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        parseContent.parseStoreData(response.body(), false);
                        setEnableView(false);
                        isEditable = false;
                        ParseContent.getInstance().showMessage(UpdateProfileActivity.this, response.body().getStatusPhrase());
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateProfileActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), UpdateProfileActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void showPhotoSelectionDialog() {
        new CustomPhotoDialog(this) {
            @Override
            public void gallery() {
                choosePhotoFromGallery();
            }

            @Override
            public void camera() {
                takePhotoFromCameraPermission();
            }
        }.show();
    }

    private void choosePhotoFromGallery() {
        if (ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_CHOOSE_PHOTO);
        } else {
            Intent galleryIntent = new Intent();
            galleryIntent.setType("image/*");
            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(galleryIntent, Constant.PERMISSION_CHOOSE_PHOTO);
        }
    }

    private void takePhotoFromCameraPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_TAKE_PHOTO);
        } else {
            takePhotoFromCamera();
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        uri = imageHelper.createTakePictureUri();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        startActivityForResult(intent, Constant.PERMISSION_TAKE_PHOTO);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case Constant.PERMISSION_CHOOSE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        choosePhotoFromGallery();
                    }
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        takePhotoFromCameraPermission();
                    }
                }
                break;

            default:
                break;
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {

                case Constant.PERMISSION_CHOOSE_PHOTO:
                    if (data != null) {
                        uri = data.getData();
                        setImage(uri);
                    }
                    break;

                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        setImage(uri);
                    }
                    break;
                default:
                    break;
            }
        }
    }

    private void setImage(final Uri uri) {
        currentPhotoPath = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), uri).getPath();
        new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
            currentPhotoPath = compressionImagePath;
            GlideApp.with(UpdateProfileActivity.this).load(uri).error(R.drawable.icon_default_profile).into(ivProfile);
        }).execute(currentPhotoPath);
    }

    private void updateUiForSocial() {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            tvChangePassword.setVisibility(View.VISIBLE);
        } else {
            tvChangePassword.setVisibility(View.GONE);
        }
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, true);
        addDetailInMultiLanguageDialog.show();
    }

    private void shareAppAndReferral() {
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(Intent.EXTRA_TEXT, getResources().getString(R.string.msg_use_referral_code) + " " + preferenceHelper.getReferralCode());
        startActivity(Intent.createChooser(sharingIntent, getResources().getString(R.string.msg_share_referral)));
    }
}