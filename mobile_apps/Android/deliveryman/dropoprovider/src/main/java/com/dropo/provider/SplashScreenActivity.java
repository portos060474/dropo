package com.dropo.provider;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.models.responsemodels.AppSettingDetailResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.ServerConfig;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SplashScreenActivity extends BaseAppCompatActivity implements BaseAppCompatActivity.NetworkListener {

    private CustomDialogAlert customDialogEnable;
    private CustomDialogAlert notificationPermissionDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_splash_screen);
        ServerConfig.setURL(this);
        requestNotificationPermission();
    }

    /**
     * request notification permission
     */
    private void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
                checkIfGpsOrInternetIsEnable();
            } else {
                requestNotificationPermissionLauncher.launch(android.Manifest.permission.POST_NOTIFICATIONS);
            }
        } else {
            checkIfGpsOrInternetIsEnable();
        }
    }

    /**
     * notification permission deny explanation dialog
     */
    private void showDenyNotificationPermissionDialog() {
        if (notificationPermissionDialog != null && notificationPermissionDialog.isShowing()) {
            return;
        }

        notificationPermissionDialog = new CustomDialogAlert(this, getString(R.string.text_attention), getString(R.string.msg_reason_for_notification_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedNotificationPermissionDialog();
                checkIfGpsOrInternetIsEnable();
            }

            @Override
            public void onClickRightButton() {
                closedNotificationPermissionDialog();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    requestNotificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS);
                }
            }
        };

        notificationPermissionDialog.show();
    }

    private void closedNotificationPermissionDialog() {
        if (notificationPermissionDialog != null && notificationPermissionDialog.isShowing()) {
            notificationPermissionDialog.dismiss();
            notificationPermissionDialog = null;
        }
    }

    /**
     * method used to call a webservice for get admin setting detail for  device type
     */
    private void getSettingsDetail() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.DEVICE_TYPE, Const.ANDROID);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AppSettingDetailResponse> detailResponseCall = apiInterface.getAppSettingDetail(map);
        detailResponseCall.enqueue(new Callback<AppSettingDetailResponse>() {
            @Override
            public void onResponse(@NonNull Call<AppSettingDetailResponse> call, @NonNull Response<AppSettingDetailResponse> response) {
                if (parseContent.parseAppSettingDetail(response)) {
                    if (response.body().isOpenUpdateDialog() && checkVersionCode(response.body().getVersionCode())) {
                        openUpdateAppDialog(response.body().isForceUpdate());
                    } else {
                        goToActivity();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AppSettingDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Const.ACTION_SETTINGS) {
            checkIfGpsOrInternetIsEnable();
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {

    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {

    }

    /**
     * this method will check play service is updated
     */
    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, 12).show();
            } else {
                finish();
            }
            return false;
        }
        return true;
    }

    @Override
    public void onClick(View view) {

    }

    /**
     * this method is check that internet or GPS is ON or OFF
     */
    private void checkIfGpsOrInternetIsEnable() {
        if (!Utils.isInternetConnected(this)) {
            openInternetDialog(this);
            setNetworkListener(this);
        } else {
            closedEnableDialogInternet();
            if (checkPlayServices()) {
                getSettingsDetail();
            }
        }
    }

    /**
     * this method will check particular  permission will be granted by user or not
     */
    private void checkPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
        } else {
            checkIfGpsOrInternetIsEnable();
        }
    }

    /**
     * this method will make decision according to permission result
     *
     * @param grantResults set result from system or OS
     */
    private void goWithLocationPermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            checkIfGpsOrInternetIsEnable();
        } else if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) && ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.ACCESS_FINE_LOCATION)) {
                openPermissionDialog();
            } else {
                closedPermissionDialog();
                checkIfGpsOrInternetIsEnable();
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
                ActivityCompat.requestPermissions(SplashScreenActivity.this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Const.PERMISSION_FOR_LOCATION);
                closedPermissionDialog();
            }

        };

        if (!isFinishing()) {
            customDialogEnable.show();
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

    @Override
    public void onNetworkChange(boolean isEnable) {
        checkIfGpsOrInternetIsEnable();
    }

    void openUpdateAppDialog(final boolean isForceUpdate) {
        CustomDialogAlert customDialogAlert = new CustomDialogAlert(this, this.getResources().getString(R.string.text_update_app), this.getResources().getString(R.string.msg_new_app_update_available), this.getResources().getString(R.string.text_update)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
                if (isForceUpdate) {
                    finishAffinity();
                } else {
                    goToActivity();
                }
            }

            @Override
            public void onClickRightButton() {
                final String appPackageName = getPackageName(); // getPackageName() from Context
                // or Activity object
                try {
                    startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appPackageName)));
                } catch (android.content.ActivityNotFoundException anfe) {
                    AppLog.handleException(SplashScreenActivity.class.getName(), anfe);
                    startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google" + ".com/store/apps/details?id=" + appPackageName)));
                }
                dismiss();
                finishAffinity();
            }
        };
        if (!isFinishing()) {
            customDialogAlert.show();
        }


    }

    /**
     * this method will check that is our app is updated or not ,according to admin app version code
     */
    private boolean checkVersionCode(String code) {
        return BuildConfig.VERSION_CODE < Integer.parseInt(code);
    }

    private void goToActivity() {
        if (!TextUtils.isEmpty(preferenceHelper.getSessionToken())) {
            goToHomeActivity();
        } else {
            goToLoginActivity();
        }
    }

    /**
     * request notification permission launcher
     */
    private final ActivityResultLauncher<String> requestNotificationPermissionLauncher =
            registerForActivityResult(new ActivityResultContracts.RequestPermission(), isGranted -> {
                if (isGranted) {
                    checkIfGpsOrInternetIsEnable();
                } else if (ActivityCompat.shouldShowRequestPermissionRationale(SplashScreenActivity.this, android.Manifest.permission.POST_NOTIFICATIONS)) {
                    showDenyNotificationPermissionDialog();
                } else {
                    checkIfGpsOrInternetIsEnable();
                }
            });
}