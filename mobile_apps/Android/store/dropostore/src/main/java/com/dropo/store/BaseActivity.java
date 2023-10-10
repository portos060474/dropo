package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.ContextCompat;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.store.R;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomNewOrderDialog;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.models.singleton.CurrentProduct;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.models.singleton.UpdateOrder;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FontsOverride;
import com.dropo.store.utils.LanguageHelper;
import com.dropo.store.utils.NetworkHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.firebase.auth.FirebaseAuth;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * The type Base activity.
 */
public class BaseActivity extends AppCompatActivity implements View.OnClickListener {
    @SuppressLint("StaticFieldLeak")
    private static CustomNewOrderDialog customNewOrderDialog;
    private final AppReceiver appReceiver = new AppReceiver();
    /**
     * The Image name.
     */
    public String imageName;
    /**
     * The Date.
     */
    public Date date;
    /**
     * The Simple date format.
     */
    public SimpleDateFormat simpleDateFormat;
    /**
     * The Is editable.
     */
    public boolean isEditable;
    /**
     * The Preference helper.
     */
    public PreferenceHelper preferenceHelper;
    /**
     * The Parse content.
     */
    public ParseContent parseContent;
    /**
     * The Logout dialog.
     */
    public CustomAlterDialog logoutDialog;
    /**
     * The Toolbar.
     */
    public Toolbar toolbar;
    /**
     * The Menu.
     */
    protected Menu menu;
    String TAG = this.getClass().getSimpleName();
    private CustomAlterDialog storeApproveDialog;
    private NetworkListener networkListener;
    private OrderListener orderListener;
    private NetworkHelper networkHelper;

    private CustomAlterDialog customAlterDialog;
    /**
     * FireBase Authentication
     */
    public FirebaseAuth mAuth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppColor.onActivityCreateSetTheme(this);
        CurrentBooking.restoreState(savedInstanceState);
        UpdateOrder.restoreState(savedInstanceState);
        Language.restoreState(savedInstanceState);
        CurrentProduct.restoreState(savedInstanceState);
        ApiClient.restoreState(savedInstanceState);
        SubStoreAccess.restoreState(savedInstanceState);
        FontsOverride.setDefaultFont(this, "MONOSPACE", "fonts/ClanPro-News.otf");
        preferenceHelper = PreferenceHelper.getPreferenceHelper(this);
        parseContent = ParseContent.getInstance();
        parseContent.setContext(this);
        mAuth = FirebaseAuth.getInstance();
        simpleDateFormat = new SimpleDateFormat("yyyy_MM_dd_hh_mm_ss_SSS", Locale.ENGLISH);
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Constant.Action.ACTION_NEW_ORDER_ACTION);
        intentFilter.addAction(Constant.Action.ACTION_STORE_APPROVED);
        intentFilter.addAction(Constant.Action.ACTION_STORE_DECLINED);
        intentFilter.addAction(Constant.Action.ACTION_ORDER_STATUS_ACTION);
        networkHelper = NetworkHelper.getInstance();
        networkHelper.initConnectivityManager(this);
        registerReceiver(appReceiver, intentFilter);
        setNetworkListener(isEnable -> {
            if (Utilities.checkInternet(BaseActivity.this)) {
                removeInternetDialog();
            } else {
                Utilities.removeProgressDialog();
                Utilities.hideCustomProgressDialog();
                showInternetDialog(BaseActivity.this);
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!Utilities.checkInternet(this)) {
            showInternetDialog(this);
        }
    }

    @Override
    protected void onDestroy() {
        unregisterReceiver(appReceiver);
        super.onDestroy();
    }

    public void showInternetDialog(final Activity activity) {
        runOnUiThread(() -> {
            if (customAlterDialog != null && customAlterDialog.isShowing()) {
                return;
            }
            if (!isFinishing()) {
                customAlterDialog = new CustomAlterDialog(activity, activity.getResources().getString(R.string.text_internet), activity.getResources().getString(R.string.text_no_internet), true, activity.getResources().getString(R.string.text_ok)) {
                    @Override
                    public void btnOnClick(int btnId) {
                        if (btnId == R.id.btnPositive) {
                            Intent intent = new Intent(Settings.ACTION_SETTINGS);
                            activity.startActivity(intent);
                        } else {
                            activity.finishAffinity();
                            removeInternetDialog();
                        }
                    }
                };
                customAlterDialog.setCancelable(false);
                customAlterDialog.show();
            }
        });
    }

    public void removeInternetDialog() {
        if (customAlterDialog != null && customAlterDialog.isShowing()) {
            customAlterDialog.dismiss();
            customAlterDialog = null;
        }
    }

    /**
     * Sets toolbar.
     *
     * @param toolbar      the toolbar
     * @param drawableId   the drawable id
     * @param toolbarColor the toolbar color
     */
    protected void setToolbar(Toolbar toolbar, int drawableId, int toolbarColor) {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        if (drawableId > 0) {
            toolbar.setNavigationIcon(drawableId);
        }
        if (toolbarColor > 0) {
            if (AppColor.isDarkTheme(this)) {
                findViewById(R.id.toolbarMain).setBackgroundColor(ContextCompat.getColor(this, R.color.color_app_bg_dark));
            } else {
                findViewById(R.id.toolbarMain).setBackgroundColor(ContextCompat.getColor(this, R.color.color_app_bg_light));
            }
        }
    }

    /**
     * Sets toolbar edit icon.
     *
     * @param isVisible the is visible
     * @param drawable  the drawable
     */
    public void setToolbarEditIcon(boolean isVisible, int drawable) {
        if (menu != null) {
            MenuItem menuItemEdit = menu.findItem(R.id.ivEditMenu);
            menuItemEdit.getIcon().setTint(AppColor.COLOR_THEME);
            menuItemEdit.setVisible(isVisible);
            if (isVisible && drawable != 0) {
                menuItemEdit.setIcon(drawable);
                menuItemEdit.getIcon().setTint(AppColor.COLOR_THEME);
            }
        }
    }

    /**
     * Sets toolbar save icon.
     *
     * @param isVisible the is visible
     */
    protected void setToolbarSaveIcon(boolean isVisible) {
        MenuItem menuItemSave = menu.findItem(R.id.ivSaveMenu);
        menuItemSave.getIcon().setTint(AppColor.COLOR_THEME);
        menuItemSave.setVisible(isVisible);
    }

    @Override
    public void onClick(View v) {

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu, menu);
        this.menu = menu;
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            super.onBackPressed();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * this method call webservice for update product
     *
     * @param product   the product
     * @param isChecked the is checked
     * @return update product call
     */
    public Call<IsSuccessResponse> getUpdateProductCall(Product product, boolean isChecked) {
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getServerToken()));
        map.put(Constant.NAME, ApiClient.makeTextRequestBody(product.getName()));
        map.put(Constant.DETAILS, ApiClient.makeTextRequestBody(product.getDetails()));
        map.put(Constant.IS_VISIBLE_IN_STORE, ApiClient.makeTextRequestBody(String.valueOf(isChecked)));
        map.put(Constant.PRODUCT_ID, ApiClient.makeTextRequestBody(String.valueOf(product.getId())));

        return ApiClient.getClient().create(ApiInterface.class).updateProduct(map);
    }

    /**
     * Sets network listener.
     *
     * @param networkListener the network listener
     */
    public void setNetworkListener(NetworkListener networkListener) {
        this.networkListener = networkListener;
        networkHelper.setNetworkAvailableListener(networkListener);
    }

    /**
     * this method call a web service for logout from app
     */
    public void openLogoutDialog() {

        if (logoutDialog != null && logoutDialog.isShowing()) {
            return;
        }
        logoutDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_log_out), getResources().getString(R.string.msg_lagout), true, getResources().getString(R.string.text_yes)) {

            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    logout(logoutDialog);
                } else {
                    dismiss();
                }
            }
        };
        logoutDialog.setCancelable(false);
        logoutDialog.show();
    }

    /**
     * Logout.
     *
     * @param dialog the dialog
     */
    public void logout(final Dialog dialog) {
        Utilities.showProgressDialog(BaseActivity.this);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(BaseActivity.this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(BaseActivity.this).getServerToken());
        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).logout(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (dialog != null && dialog.isShowing()) {
                        dialog.dismiss();
                    }
                    if (response.body().isSuccess()) {
                        mAuth.signOut();
                        gotoMainActivity();
                    } else {
                        ParseContent.getInstance().showErrorMessage(BaseActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), BaseActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void logoutForServer() {
        Utilities.showProgressDialog(BaseActivity.this);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(BaseActivity.this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(BaseActivity.this).getServerToken());
        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).logout(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        mAuth.signOut();
                        gotoSplashActivity();
                    } else {
                        ParseContent.getInstance().showErrorMessage(BaseActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), BaseActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * Goto main activity.
     */
    public void gotoMainActivity() {
        PreferenceHelper.getPreferenceHelper(this).logout();
        Intent intent = new Intent(this, RegisterLoginActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    public void gotoSplashActivity() {
        PreferenceHelper.getPreferenceHelper(this).logout();
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finishAffinity();
    }

    /**
     * Go to document activity.
     *
     * @param isApplicationStart the is application start
     */
    public void goToDocumentActivity(boolean isApplicationStart) {
        Intent intent = new Intent(this, DocumentActivity.class);
        intent.putExtra(Constant.DOCUMENT_ACTIVITY, isApplicationStart);
        startActivity(intent);
    }

    /**
     * Go to earning activity.
     */
    public void goToEarningActivity() {
        Intent intent = new Intent(this, EarningActivity.class);
        startActivity(intent);
    }

    /**
     * this method will send email to selected email id
     *
     * @param email the email
     */
    protected void contactUsWithEmail(String email) {
        Uri gmmIntentUri = Uri.parse("mailto:" + email + "?subject=" + "Request to Admin" + "&body=" + "Hello sir");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.gm");
        if (mapIntent.resolveActivity(getPackageManager()) != null) {
            startActivity(mapIntent);
        } else {
            Utilities.showToast(this, getString(R.string.text_google_mail_app_not_installed));
        }
    }


    /**
     * Gets common param.
     *
     * @param ordersItemId the orders item id
     * @return the common param
     */
    protected HashMap<String, Object> getCommonParam(String ordersItemId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.ORDER_ID, ordersItemId);
        return map;
    }

    /**
     * Check witch otp validation on int.
     *
     * @return the int
     */
    public int checkWitchOtpValidationON() {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {

            return Constant.SMS_AND_EMAIL_VERIFICATION_ON;

        } else if (checkPhoneNumberVerification()) {
            return Constant.SMS_VERIFICATION_ON;
        } else if (checkEmailVerification()) {
            return Constant.EMAIL_VERIFICATION_ON;
        }
        return -1;
    }

    private boolean checkEmailVerification() {
        return preferenceHelper.getIsVerifyEmail() && !preferenceHelper.isEmailVerified();
    }

    private boolean checkPhoneNumberVerification() {
        return preferenceHelper.getIsVerifyPhone() && !preferenceHelper.isPhoneNumberVerified();
    }

    /**
     * Open store approve dialog.
     */
    public void openStoreApproveDialog() {
        if (!this.isFinishing()) {
            if (storeApproveDialog != null && storeApproveDialog.isShowing()) {
                return;
            }
            storeApproveDialog = new CustomAlterDialog(this, getString(R.string.text_admin_alert), getString(R.string.text_under_review), true, getString(R.string.text_email)) {
                @Override
                public void btnOnClick(int btnId) {
                    if (btnId == R.id.btnPositive) {
                        contactUsWithEmail(preferenceHelper.getAdminContactEmail());
                    } else {
                        logout(storeApproveDialog);
                    }
                }
            };
            storeApproveDialog.setCancelable(false);
            storeApproveDialog.show();
            storeApproveDialog.setNegativeButtonIcon(R.drawable.ic_logout_2);
        }
    }

    /**
     * Closed admin approved dialog.
     */
    public void closedAdminApprovedDialog() {
        if (storeApproveDialog != null && storeApproveDialog.isShowing()) {
            storeApproveDialog.dismiss();
        }
    }

    /**
     * Go to home activity.
     */
    public void goToHomeActivity() {
        Intent homeIntent = new Intent(this, HomeActivity.class);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(LanguageHelper.wrapper(newBase, PreferenceHelper.getPreferenceHelper(newBase).getLanguageCode()));
    }

    @Override
    public void applyOverrideConfiguration(Configuration overrideConfiguration) {
        if (overrideConfiguration != null) {
            int uiMode = overrideConfiguration.uiMode;
            overrideConfiguration.setTo(getBaseContext().getResources().getConfiguration());
            overrideConfiguration.uiMode = uiMode;
        }
        super.applyOverrideConfiguration(overrideConfiguration);
    }

    /**
     * Restart app.
     */
    public void restartApp() {
        startActivity(new Intent(this, MainActivity.class));
    }

    /**
     * Sets order listener.
     *
     * @param orderListener the order listener
     */
    public void setOrderListener(OrderListener orderListener) {
        this.orderListener = orderListener;
    }

    /**
     * Gets version code.
     *
     * @return the version code
     */
    public String getVersionCode() {
        try {
            PackageInfo pInfo = getPackageManager().getPackageInfo(getPackageName(), 0);
            return pInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        CurrentBooking.saveState(outState);
        UpdateOrder.saveState(outState);
        Language.saveState(outState);
        CurrentProduct.saveState(outState);
        ApiClient.saveState(outState);
        SubStoreAccess.saveState(outState);
        super.onSaveInstanceState(outState);
    }

    public void setColorSwipeToRefresh(SwipeRefreshLayout colorSwipeToRefresh) {
        if (AppColor.isDarkTheme(this)) {
            colorSwipeToRefresh.setColorSchemeResources(R.color.color_app_bg_light);
            colorSwipeToRefresh.setProgressBackgroundColorSchemeResource(R.color.color_app_tag_dark);
        } else {
            colorSwipeToRefresh.setColorSchemeResources(R.color.color_app_bg_dark);
            colorSwipeToRefresh.setProgressBackgroundColorSchemeResource(R.color.color_app_tag_light);
        }
    }

    /**
     * The interface Network listener.
     */
    public interface NetworkListener {
        /**
         * On network change.
         *
         * @param isEnable the is enable
         */
        void onNetworkChange(boolean isEnable);
    }

    /**
     * The interface Order listener.
     */
    public interface OrderListener {
        /**
         * On order receive.
         */
        void onOrderReceive();
    }

    /**
     * The type App receiver.
     */
    public class AppReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(final Context context, final Intent intent) {
            if (intent != null) {
                switch (intent.getAction()) {
                    case Constant.Action.ACTION_STORE_APPROVED:
                        preferenceHelper.putIsApproved(true);
                        closedAdminApprovedDialog();
                        goToHomeActivity();
                        break;
                    case Constant.Action.ACTION_STORE_DECLINED:
                        preferenceHelper.putIsApproved(false);
                        openStoreApproveDialog();
                        break;
                    case Constant.Action.NETWORK_ACTION:
                        if (networkListener != null) {
                            networkListener.onNetworkChange(Utilities.checkInternet(context));
                        }
                        break;
                    case Constant.Action.ACTION_NEW_ORDER_ACTION:
                        if (!BaseActivity.this.isFinishing() && !TextUtils.isEmpty(preferenceHelper.getServerToken())) {
                            if (customNewOrderDialog != null && customNewOrderDialog.isShowing()) {
                                customNewOrderDialog.notifyDataSetChange(intent.getStringExtra(Constant.PUSH_DATA));
                                return;
                            }
                            customNewOrderDialog = new CustomNewOrderDialog(BaseActivity.this, intent.getStringExtra(Constant.PUSH_DATA));
                            customNewOrderDialog.show();
                        }
                        break;
                    case Constant.Action.ACTION_ORDER_CANCEL:

                        if (!BaseActivity.this.isFinishing() && !TextUtils.isEmpty(preferenceHelper.getServerToken())) {
                            if (customNewOrderDialog != null && customNewOrderDialog.isShowing()) {
                                customNewOrderDialog.dismiss();
                            }

                        }
                        if (orderListener != null) {
                            orderListener.onOrderReceive();
                        }
                        break;
                    case Constant.Action.ACTION_ORDER_STATUS_ACTION:
                        if (orderListener != null) {
                            orderListener.onOrderReceive();
                        }

                        break;
                    default:
                        break;
                }
            }
        }
    }
}