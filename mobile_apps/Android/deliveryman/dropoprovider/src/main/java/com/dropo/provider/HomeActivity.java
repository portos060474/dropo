package com.dropo.provider;

import static com.dropo.provider.utils.Const.REQUEST_CHECK_SETTINGS;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.text.InputType;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.SwitchCompat;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.adapter.DrawerAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.component.CustomImageView;
import com.dropo.provider.fragments.HistoryFragment;
import com.dropo.provider.fragments.HomeFragment;
import com.dropo.provider.fragments.UserFragment;
import com.dropo.provider.models.datamodels.Provider;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OtpResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.service.EdeliveryUpdateLocationAndOrderService;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.FontsOverride;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.SoundHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseUser;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HomeActivity extends BaseAppCompatActivity {

    private CustomDialogVerification customDialogVerification;
    private BottomSheetDialog dialogEmailOrPhoneVerification;
    private CustomFontEditTextView etDialogEditTextOne, etDialogEditTextTwo;
    private String phone, email;
    private CustomDialogAlert exitDialog, customDialogEnable;
    private DrawerAdapter drawerAdapter;
    private FrameLayout containFrame;
    private DrawerLayout drawerLayout;
    private String otpEmailVerification, otpSmsVerification;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FontsOverride.setDefaultFont(this, "MONOSPACE", "fonts/ClanPro-News.otf");
        setContentView(R.layout.activity_home);
        initToolBar();
        initViewById();
        setViewListener();
        IsToolbarNavigationVisible(false);
        initMenuDrawer(findViewById(R.id.rcvDrawer), findViewById(R.id.drawerLayout), toolbar);
        updateToolbarTransparent(true);
        goToHomeFragment();
        SoundHelper.getInstance(this).stopWhenNewOrderSound(this);
        getProviderDetail();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        containFrame = findViewById(R.id.contain_frame);
    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {

    }

    public void addFragment(Fragment fragment, boolean addToBackStack, boolean isAnimate, String tag) {
        FragmentManager manager = getSupportFragmentManager();
        FragmentTransaction ft = manager.beginTransaction();
        if (isAnimate) {
            ft.setCustomAnimations(R.anim.slide_in_right, R.anim.slide_out_left, R.anim.slide_in_left, R.anim.slide_out_right);
        }
        if (addToBackStack) {
            ft.addToBackStack(tag);
        }
        ft.replace(R.id.contain_frame, fragment, tag);
        ft.commitAllowingStateLoss();
    }

    private void goToHomeFragment() {
        if (getSupportFragmentManager().findFragmentByTag(Const.Tag.HOME_FRAGMENT) == null) {
            updateToolbarTransparent(true);
            HomeFragment homeFragment = new HomeFragment();
            addFragment(homeFragment, false, false, Const.Tag.HOME_FRAGMENT);
        }
    }

    private void goToHistoryFragment() {
        if (getSupportFragmentManager().findFragmentByTag(Const.Tag.HISTORY_FRAGMENT) == null) {
            updateToolbarTransparent(false);
            HistoryFragment orderHistoryFragment = new HistoryFragment();
            addFragment(orderHistoryFragment, false, true, Const.Tag.HISTORY_FRAGMENT);
        }
    }

    private void goToUserFragment() {
        if (getSupportFragmentManager().findFragmentByTag(Const.Tag.USER_FRAGMENT) == null) {
            updateToolbarTransparent(false);
            UserFragment userFragment = new UserFragment();
            addFragment(userFragment, false, true, Const.Tag.USER_FRAGMENT);
        }
    }

    public void startUpdateLocationAndOrderService() {
        Intent intent = new Intent(this, EdeliveryUpdateLocationAndOrderService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }

    public void stopUpdateLocationAndOrderService() {
        stopService(new Intent(this, EdeliveryUpdateLocationAndOrderService.class));
    }

    @Override
    public void onClick(View view) {

    }

    @Override
    public void onBackPressed() {
        openExitDialog();
    }

    private void checkDocumentUploadAndApproved(Provider provider) {
        if (preferenceHelper.getIsApproved()) {
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsProviderAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else if (provider.getVehicleIds().isEmpty() && !preferenceHelper.getIsProviderAllVehicleDocumentsUpload()) {
                goToVehicleDetailActivity(true);
            } else {
                if (currentOrder.getAvailableOrders() == 0) {
                    openEmailOrPhoneConfirmationDialog(getResources().getString(R.string.text_confirm_details), getResources().getString(R.string.msg_plz_confirm_your_detail), getResources().getString(R.string.text_send));
                }
            }
        } else {
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsProviderAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else if (provider.getVehicleIds().isEmpty() && !preferenceHelper.getIsProviderAllVehicleDocumentsUpload()) {
                goToVehicleDetailActivity(true);
            }
        }
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
                                break;
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HomeActivity.this);
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

    /**
     * this method open dialog which is help to verify OTP witch is send to email or mobile
     *
     * @param map                  map
     * @param editTextOneHint      set hint text in edittext one
     * @param ediTextTwoHint       set hint text in edittext two
     * @param isEditTextOneVisible set true edittext one visible
     */
    private void openEmailOrPhoneOTPVerifyDialog(HashMap<String, Object> map, String editTextOneHint, String ediTextTwoHint, boolean isEditTextOneVisible) {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }
        customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_account), getResources().getString(R.string.msg_verify_detail), getResources().getString(R.string.text_ok), editTextOneHint, ediTextTwoHint, isEditTextOneVisible, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, false) {
            @Override
            protected void resendOtp() {
                getOtpVerify(map);
            }

            @Override
            public void onClickLeftButton() {
                dismiss();
                logOut(false);
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                HashMap<String, Object> map = new HashMap<>();
                map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
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
        };
        ((ImageView) customDialogVerification.findViewById(R.id.btnDialogAlertLeft)).setImageResource(R.drawable.ic_logout_stroke);
        customDialogVerification.show();
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
        CustomFontTextViewTitle tvDialogEditTextTitle;
        CustomImageView btnDialogEditTextLeft;
        CustomFontButton btnDialogEditTextRight;
        TextInputLayout dialogItlOne;
        LinearLayout llConfirmationPhone;
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
        etRegisterCountryCode.setText(preferenceHelper.getPhoneCountyCode());

        llConfirmationPhone = dialogEmailOrPhoneVerification.findViewById(R.id.llConfirmationPhone);
        dialogItlOne = dialogEmailOrPhoneVerification.findViewById(R.id.dialogItlOne);

        btnDialogEditTextLeft.setOnClickListener(this);
        btnDialogEditTextRight.setOnClickListener(this);

        tvDialogEditTextTitle.setText(titleDialog);
        tvDialogEdiTextMessage.setText(messageDialog);
        btnDialogEditTextRight.setText(titleRightButton);


        btnDialogEditTextRight.setOnClickListener(view -> {
            HashMap<String, Object> map = new HashMap<>();

            map.put(Const.Params.ID, preferenceHelper.getProviderId());
            map.put(Const.Params.TYPE, String.valueOf(Const.TYPE_PROVIDER));
            switch (checkWitchOtpValidationON()) {
                case Const.SMS_AND_EMAIL_VERIFICATION_ON:
                    if (Patterns.EMAIL_ADDRESS.matcher(etDialogEditTextOne.getText().toString()).matches()) {
                        if (etDialogEditTextTwo.getText().toString().trim().length() > preferenceHelper.getMaxPhoneNumberLength() || etDialogEditTextTwo.getText().toString().trim().length() < preferenceHelper.getMinPhoneNumberLength()) {

                            etDialogEditTextTwo.setError(getResources().getString(R.string.msg_please_enter_valid_mobile_number) + " " + "" + preferenceHelper.getMinPhoneNumberLength() + getResources().getString(R.string.text_or) + preferenceHelper.getMaxPhoneNumberLength() + " " + getResources().getString(R.string.text_digits));
                        } else {
                            map.put(Const.Params.EMAIL, etDialogEditTextOne.getText().toString());
                            map.put(Const.Params.PHONE, etDialogEditTextTwo.getText().toString());
                            map.put(Const.Params.COUNTRY_PHONE_CODE, preferenceHelper.getPhoneCountyCode());
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
                    if (etDialogEditTextTwo.getText().toString().trim().length() > preferenceHelper.getMaxPhoneNumberLength() || etDialogEditTextTwo.getText().toString().trim().length() < preferenceHelper.getMinPhoneNumberLength()) {

                        etDialogEditTextTwo.setError(getResources().getString(R.string.msg_please_enter_valid_mobile_number) + " " + "" + preferenceHelper.getMinPhoneNumberLength() + getResources().getString(R.string.text_or) + preferenceHelper.getMaxPhoneNumberLength() + " " + getResources().getString(R.string.text_digits));
                    } else {
                        map.put(Const.Params.PHONE, etDialogEditTextTwo.getText().toString());
                        map.put(Const.Params.COUNTRY_PHONE_CODE, preferenceHelper.getPhoneCountyCode());
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
                finish();
            }
        };
        exitDialog.show();
    }

    /**
     * this method called a webservice for get provider detail
     */
    public void getProviderDetail() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.APP_VERSION, getAppVersion());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProviderDataResponse> responseCall = apiInterface.getProviderDetail(map);
        responseCall.enqueue(new Callback<ProviderDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProviderDataResponse> call, @NonNull Response<ProviderDataResponse> response) {
                if (parseContent.parseUserStorageData(response)) {
                    CurrentOrder.getInstance().setCurrency(response.body().getCurrency());
                    checkDocumentUploadAndApproved(response.body().getProvider());
                    HomeFragment homeFragment = (HomeFragment) getSupportFragmentManager().findFragmentByTag(TAG);
                    if (homeFragment != null) {
                        homeFragment.updateUiWhenApprovedByAdmin();
                    }
                }

            }

            @Override
            public void onFailure(@NonNull Call<ProviderDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(HomeActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
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

    private void goToEarningActivity() {
        Intent intent = new Intent(this, EarningActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case REQUEST_CHECK_SETTINGS:
                HomeFragment homeFragment = (HomeFragment) getSupportFragmentManager().findFragmentByTag(TAG);
                if (resultCode == Activity.RESULT_OK) {
                    if (homeFragment != null) {
                        homeFragment.moveCameraFirstMyLocation();
                    }
                }
                break;

            case Const.ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE:
                if (Activity.RESULT_CANCELED == resultCode) {
                    checkDisplayOverAppPermission();
                }
                break;
        }
    }

    public void checkDisplayOverAppPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                CustomDialogAlert customDialogEnableGps = new CustomDialogAlert(this, getString(R.string.text_permission_requried), getString(R.string.msg_app_overlay_permission), getString(R.string.text_yes)) {

                    @Override
                    public void onClickLeftButton() {
                        dismiss();
                    }

                    @Override
                    public void onClickRightButton() {
                        dismiss();
                        Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + getPackageName()));
                        startActivityForResult(intent, Const.ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE);
                    }
                };
                customDialogEnableGps.show();
            }
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        preferenceHelper.putIsHomeScreenVisible(true);
        signInAnonymously();
    }

    @Override
    protected void onStop() {
        super.onStop();
        preferenceHelper.putIsHomeScreenVisible(false);
    }

    protected void initMenuDrawer(RecyclerView drawerList, DrawerLayout drawerLayout, Toolbar screenToolbar) {
        this.drawerLayout = drawerLayout;
        SwitchCompat switchDarkMode = findViewById(R.id.switchDarkMode);
        switchDarkMode.setChecked(AppColor.isDarkTheme(this));
        switchDarkMode.setOnCheckedChangeListener((compoundButton, checked) -> {
            if (checked) {
                PreferenceHelper.getInstance(this).putTheme(AppColor.APP_THEME_DARK);
            } else {
                PreferenceHelper.getInstance(this).putTheme(AppColor.APP_THEME_LIGHT);
            }
            drawerLayout.closeDrawer(GravityCompat.START);
            this.recreate();

        });

        drawerAdapter = new DrawerAdapter(this) {
            @Override
            public void onDrawerItemClick(int position) {
                drawerLayout.setTag(position);
                drawerLayout.closeDrawer(GravityCompat.START);
            }
        };
        drawerList.setAdapter(drawerAdapter);
        drawerLayout.setTag(-1);
        drawerLayout.addDrawerListener(new DrawerLayout.DrawerListener() {
            @Override
            public void onDrawerSlide(@NonNull View drawerView, float slideOffset) {

            }

            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onDrawerOpened(@NonNull View drawerView) {
                drawerAdapter.notifyDataSetChanged();
            }

            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onDrawerClosed(@NonNull View drawerView) {
                switch ((int) drawerLayout.getTag()) {
                    case 0:
                        goToHomeFragment();
                        break;
                    case 1:
                        goToEarningActivity();
                        break;
                    case 2:
                        goToHistoryFragment();
                        break;
                    case 3:
                        goToUserFragment();
                        break;
                    default:
                        break;
                }
                drawerLayout.setTag(-1);
                drawerAdapter.notifyDataSetChanged();
            }

            @Override
            public void onDrawerStateChanged(int newState) {

            }
        });

        ActionBarDrawerToggle actionbarDrawerToggle = new ActionBarDrawerToggle(this, drawerLayout, screenToolbar, 0, 0);
        actionbarDrawerToggle.setDrawerIndicatorEnabled(false);
        actionbarDrawerToggle.setDrawerSlideAnimationEnabled(false);
        actionbarDrawerToggle.setToolbarNavigationClickListener(v -> drawerLayout.openDrawer(GravityCompat.START));
        drawerLayout.addDrawerListener(actionbarDrawerToggle);
        actionbarDrawerToggle.syncState();
    }


    private void updateToolbarTransparent(boolean isTransparent) {
        FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) containFrame.getLayoutParams();
        if (isTransparent) {
            layoutParams.topMargin = 0;
            tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_bg_dark, getTheme()));
            toolbar.setBackgroundColor(Color.TRANSPARENT);
            setToolbarMenuIcon(true, true, view -> drawerLayout.openDrawer(GravityCompat.START));
        } else {
            tvTitleToolbar.setTextColor(AppColor.getThemeTextColor(this));
            setToolbarMenuIcon(true, false, view -> drawerLayout.openDrawer(GravityCompat.START));
            layoutParams.topMargin = getResources().getDimensionPixelSize(R.dimen.app_toolbar_size);
            toolbar.setBackgroundColor(AppColor.getThemeBgColor(this));
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
            HomeFragment homeFragment = (HomeFragment) getSupportFragmentManager().findFragmentByTag(TAG);
            if (homeFragment != null) {
                homeFragment.closePermissionDialog();
            }
        } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) && ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_FINE_LOCATION)) {
                closedPermissionDialog();
                ActivityCompat.requestPermissions(HomeActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
            } else {
                openPermissionDialog();
            }
        }
    }

    private void closedPermissionDialog() {
        if (customDialogEnable != null && customDialogEnable.isShowing()) {
            customDialogEnable.dismiss();
            customDialogEnable = null;

        }
    }

    private void openPermissionDialog() {
        if (customDialogEnable != null && customDialogEnable.isShowing()) {
            return;
        }
        customDialogEnable = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_permission_location), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
                finishAffinity();
            }

            @Override
            public void onClickRightButton() {
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                Uri uri = Uri.fromParts("package", getPackageName(), null);
                intent.setData(uri);
                startActivityForResult(intent, Const.PERMISSION_FOR_LOCATION);
                closedPermissionDialog();
            }
        };
        if (!isFinishing()) {
            customDialogEnable.show();
        }
    }

    private void signInAnonymously() {
        FirebaseUser currentUser = mAuth.getCurrentUser();
        if (currentUser == null) {
            if (!TextUtils.isEmpty(preferenceHelper.getFireBaseUserToken())) {
                mAuth.signInWithCustomToken(preferenceHelper.getFireBaseUserToken()).addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
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