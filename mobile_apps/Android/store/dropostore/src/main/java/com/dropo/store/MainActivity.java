package com.dropo.store;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.responsemodel.AppSettingResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.ServerConfig;
import com.dropo.store.utils.Utilities;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MainActivity extends BaseActivity implements BaseActivity.NetworkListener {

    private ParseContent parseContent;
    private CustomAlterDialog notificationPermissionDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ServerConfig.setURL(this);
        ApiClient.setStoreId(preferenceHelper.getStoreId());
        ApiClient.setServerToken(preferenceHelper.getServerToken());
        ApiClient.setSubStoreId(preferenceHelper.getSubStoreId());
        parseContent = ParseContent.getInstance();
        parseContent.setContext(this);
        if (!Utilities.checkInternet(this)) {
            showInternetDialog(this);
            setNetworkListener(this);
        }
        saveAndroidId();
        requestNotificationPermission();
    }

    /**
     * request notification permission
     */
    private void requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED) {
                checkAppKey();
            } else {
                requestNotificationPermissionLauncher.launch(android.Manifest.permission.POST_NOTIFICATIONS);
            }
        } else {
            checkAppKey();
        }
    }

    /**
     * notification permission deny explanation dialog
     */
    private void showDenyNotificationPermissionDialog() {
        if (notificationPermissionDialog != null && notificationPermissionDialog.isShowing()) {
            return;
        }

        notificationPermissionDialog = new CustomAlterDialog(this, getString(R.string.text_attention), getString(R.string.msg_reason_for_notification_permission), true, getString(R.string.text_re_try)) {
            @Override
            public void btnOnClick(int btnId) {
                closedNotificationPermissionDialog();
                if (btnId == R.id.btnPositive) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                        requestNotificationPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS);
                    }
                } else {
                    checkAppKey();
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


    private void checkAppKey() {
        if (checkPlayServices()) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.TYPE, Constant.TYPE_STORE);
            map.put(Constant.DEVICE_TYPE, Constant.ANDROID);
            Call<AppSettingResponse> call = ApiClient.getClient().create(ApiInterface.class).getAppSettingDetail(map);
            call.enqueue(new Callback<AppSettingResponse>() {
                @Override
                public void onResponse(@NonNull Call<AppSettingResponse> call, @NonNull Response<AppSettingResponse> response) {
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            if (parseContent.parseAppSettingDetails(response)) {
                                if (PreferenceHelper.getPreferenceHelper(MainActivity.this).isForceUpdate() && checkVersionCode(response.body().getVersionCode())) {
                                    openUpdateAppDialog(response.body().isIsForceUpdate());
                                } else {
                                    goToActivity();
                                }
                            }
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<AppSettingResponse> call, @NonNull Throwable t) {
                    Utilities.hideCustomProgressDialog();
                }
            });
        }
    }

    private void gotoRegister() {
        Intent intent = new Intent(MainActivity.this, RegisterLoginActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.enter, R.anim.exit);
        finish();
    }

    private void gotoHome() {
        startActivity(new Intent(MainActivity.this, HomeActivity.class));
        overridePendingTransition(R.anim.enter, R.anim.exit);
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    /**
     * this method will check that is our app is updated or not ,according to admin app version
     * code
     *
     * @param code code
     */
    private boolean checkVersionCode(String code) {
        try {
            return getPackageManager().getPackageInfo(getPackageName(), 0).versionCode < Integer.parseInt(code);
        } catch (PackageManager.NameNotFoundException e) {
            Utilities.handleException(MainActivity.class.getName(), e);
        }
        return false;
    }

    private void goToActivity() {
        if (!TextUtils.isEmpty(PreferenceHelper.getPreferenceHelper(MainActivity.this).getStoreId())) {
            gotoHome();
        } else {
            gotoRegister();
        }
    }

    void openUpdateAppDialog(final boolean isForceUpdate) {
        CustomAlterDialog customAlterDialog = new CustomAlterDialog(this, this.getResources().getString(R.string.text_update_app), this.getResources().getString(R.string.msg_new_app_update_available), true, this.getResources().getString(R.string.text_update)) {
            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    final String appPackageName = getPackageName();
                    try {
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + appPackageName)));
                    } catch (android.content.ActivityNotFoundException anfe) {
                        Utilities.handleException(MainActivity.class.getName(), anfe);
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play" + ".google" + ".com/store/apps/details?id=" + appPackageName)));
                    }
                    dismiss();
                    finishAffinity();
                } else {
                    if (isForceUpdate) {
                        finishAffinity();
                    } else {
                        goToActivity();
                    }
                    dismiss();
                }
            }
        };

        customAlterDialog.show();
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

    private void saveAndroidId() {
        if (TextUtils.isEmpty(PreferenceHelper.getPreferenceHelper(this).getAndroidId())) {
            PreferenceHelper.getPreferenceHelper(this).putAndroidId(Utilities.generateRandomString());
        }
    }

    @Override
    public void onNetworkChange(boolean isEnable) {
        if (isEnable) {
            checkAppKey();
        }
    }


    /**
     * request notification permission launcher
     */
    private final ActivityResultLauncher<String> requestNotificationPermissionLauncher =
            registerForActivityResult(new ActivityResultContracts.RequestPermission(), isGranted -> {
                if (isGranted) {
                    checkAppKey();
                } else if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this, android.Manifest.permission.POST_NOTIFICATIONS)) {
                    showDenyNotificationPermissionDialog();
                } else {
                    checkAppKey();
                }
            });
}