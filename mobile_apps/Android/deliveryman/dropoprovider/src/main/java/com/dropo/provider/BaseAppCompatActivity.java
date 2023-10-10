package com.dropo.provider;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.res.ResourcesCompat;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.bumptech.glide.load.resource.bitmap.CircleCrop;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogDeliveryRequest;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.FontsOverride;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.LanguageHelper;
import com.dropo.provider.utils.NetworkHelper;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.SoundHelper;
import com.dropo.provider.utils.Utils;
import com.google.firebase.auth.FirebaseAuth;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class BaseAppCompatActivity extends AppCompatActivity implements View.OnClickListener {

    private static CustomDialogDeliveryRequest deliveryRequest;
    private final AppReceiver appReceiver = new AppReceiver();
    public Toolbar toolbar;
    public PreferenceHelper preferenceHelper;
    public ParseContent parseContent;
    public CustomFontTextViewTitle tvTitleToolbar;
    public CurrentOrder currentOrder;
    /**
     * FireBase Authentication
     */
    public FirebaseAuth mAuth;
    protected String TAG = this.getClass().getSimpleName();
    private ImageView ivToolbarBack;
    private ImageView ivToolbarRightIcon;
    private ActionBar actionBar;
    private CustomDialogAlert customDialogEnableInternet;
    private NetworkListener networkListener;
    private OrderListener orderListener;
    private NetworkHelper networkHelper;
    private ImageView ivToolbarProfile, ivToolbarMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        CurrentOrder.restoreState(savedInstanceState);
        ApiClient.restoreState(savedInstanceState);
        FontsOverride.setDefaultFont(this, "MONOSPACE", "fonts/ClanPro-News.otf");
        preferenceHelper = PreferenceHelper.getInstance(this);
        AppColor.onActivityCreateSetTheme(this);
        parseContent = ParseContent.getInstance();
        SoundHelper.getInstance(this);
        parseContent.setContext(this);
        currentOrder = CurrentOrder.getInstance();
        mAuth = FirebaseAuth.getInstance();

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Const.Action.ACTION_ADMIN_APPROVED);
        intentFilter.addAction(Const.Action.ACTION_ADMIN_DECLINE);
        intentFilter.addAction(Const.Action.ACTION_ORDER_STATUS);
        intentFilter.addAction(Const.Action.ACTION_NEW_ORDER);
        intentFilter.addAction(Const.Action.ACTION_STORE_CANCELED_REQUEST);
        networkHelper = NetworkHelper.getInstance();
        networkHelper.initConnectivityManager(this);

        registerReceiver(appReceiver, intentFilter);
        setNetworkListener(isEnable -> {
            if (isEnable) {
                closedEnableDialogInternet();
            } else {
                openInternetDialog(BaseAppCompatActivity.this);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        LanguageHelper.wrapper(this, PreferenceHelper.getInstance(this).getLanguageCode());
    }

    @Override
    protected void onDestroy() {
        unregisterReceiver(appReceiver);
        closedDeliveryRequestDialog();
        super.onDestroy();
    }

    protected void initToolBar() {
        toolbar = findViewById(R.id.appToolbar);
        ivToolbarProfile = toolbar.findViewById(R.id.ivToolbarProfile);
        ivToolbarMenu = toolbar.findViewById(R.id.ivToolbarMenu);
        tvTitleToolbar = toolbar.findViewById(R.id.tvToolbarTitle);
        ivToolbarRightIcon = toolbar.findViewById(R.id.ivToolbarRightIcon);
        ivToolbarBack = findViewById(R.id.ivToolbarBack);
        setSupportActionBar(toolbar);
        actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayShowTitleEnabled(false);
            actionBar.setDisplayHomeAsUpEnabled(false);
        }
        ivToolbarBack.setOnClickListener(view -> onBackNavigation());
    }

    public void setTitleOnToolBar(String title) {
        if (tvTitleToolbar != null) {
            tvTitleToolbar.setText(title);
        }
    }

    protected void IsToolbarNavigationVisible(boolean isVisible) {
        if (isVisible) {
            ivToolbarBack.setVisibility(View.VISIBLE);
            ivToolbarProfile.setVisibility(View.GONE);
            ivToolbarMenu.setVisibility(View.GONE);
        } else {
            ivToolbarBack.setVisibility(View.GONE);
        }
    }

    public void setToolbarRightIcon(int drawableResourcesId, View.OnClickListener onClickListener) {
        if (ivToolbarRightIcon != null) {
            if (drawableResourcesId > 0) {
                Drawable drawable = AppCompatResources.getDrawable(this, drawableResourcesId);
                drawable.setTint(AppColor.COLOR_THEME);
                ivToolbarRightIcon.setImageDrawable(drawable);
                ivToolbarRightIcon.setOnClickListener(onClickListener);
                ivToolbarRightIcon.setVisibility(View.VISIBLE);
            } else {
                ivToolbarRightIcon.setVisibility(View.GONE);
            }
        }
    }

    protected void setToolbarMenuIcon(boolean isVisible, boolean isSetAsProfileIcon, View.OnClickListener onClickListener) {
        if (isVisible) {
            if (isSetAsProfileIcon) {
                ivToolbarMenu.setVisibility(View.GONE);
                ivToolbarProfile.setVisibility(View.VISIBLE);
                GlideApp.with(this).load(preferenceHelper.getProfilePic()).transform(new CircleCrop()).placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.man_user, null)).fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.man_user, null)).into(ivToolbarProfile);
                ivToolbarProfile.setOnClickListener(onClickListener);
            } else {
                ivToolbarProfile.setVisibility(View.GONE);
                ivToolbarMenu.setVisibility(View.VISIBLE);
                ivToolbarMenu.setOnClickListener(onClickListener);
            }
            ivToolbarBack.setVisibility(View.GONE);
        } else {
            ivToolbarProfile.setVisibility(View.GONE);
            ivToolbarMenu.setVisibility(View.GONE);
        }
    }

    public void hideSoftKeyboard(AppCompatActivity activity) {
        View view = activity.getCurrentFocus();
        if (view != null) {
            InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    /**
     * this method will help you to check all data filed is valid or not
     *
     * @return true if is valid otherwise false
     */
    protected abstract boolean isValidate();

    /**
     * method used to manage all view address
     */
    protected abstract void initViewById();

    /**
     * method used to manage all interface or listener
     */
    protected abstract void setViewListener();

    /**
     * method used to manage toolbar beck navigation button
     */
    protected abstract void onBackNavigation();

    protected void openInternetDialog(final Activity activity) {
        runOnUiThread(() -> {
            if (!isFinishing()) {
                if (customDialogEnableInternet != null && customDialogEnableInternet.isShowing()) {
                    return;
                }

                customDialogEnableInternet = new CustomDialogAlert(activity, getString(R.string.text_internet), getString(R.string.msg_internet_enable), getString(R.string.text_ok)) {

                    @Override
                    public void onClickLeftButton() {
                        closedEnableDialogInternet();
                        activity.finishAffinity();
                    }

                    @Override
                    public void onClickRightButton() {
                        activity.startActivityForResult(new Intent(Settings.ACTION_SETTINGS), Const.ACTION_SETTINGS);
                    }

                };
                customDialogEnableInternet.show();
            }
        });
    }

    protected void closedEnableDialogInternet() {
        if (customDialogEnableInternet != null && customDialogEnableInternet.isShowing()) {
            customDialogEnableInternet.dismiss();
            customDialogEnableInternet = null;
        }
    }

    public void goToLoginActivity() {
        Intent loginIntent = new Intent(this, LoginActivity.class);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(loginIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToSplashActivity() {
        Intent loginIntent = new Intent(this, SplashScreenActivity.class);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(loginIntent);
        finishAffinity();
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToHomeActivity() {
        Intent homeIntent = new Intent(this, HomeActivity.class);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToDocumentActivity(boolean isApplicationStart) {
        Intent intent = new Intent(this, DocumentActivity.class);
        intent.putExtra(Const.APP_START, isApplicationStart);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToVehicleDetailActivity(boolean isApplicationStart) {
        Intent intent = new Intent(this, VehicleDetailActivity.class);
        intent.putExtra(Const.APP_START, isApplicationStart);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    protected void setNetworkListener(NetworkListener networkListener) {
        this.networkListener = networkListener;
        networkHelper.setNetworkAvailableListener(networkListener);
    }

    public void setOrderListener(OrderListener orderListener) {
        this.orderListener = orderListener;
    }

    public void closedDeliveryRequestDialog() {
        if (deliveryRequest != null && deliveryRequest.isShowing()) {
            deliveryRequest.dismiss();
        }

    }

    private void openDeliveryRequestDialog(Intent intent) {
        if (!this.isFinishing() && !TextUtils.isEmpty(preferenceHelper.getSessionToken())) {
            Bundle bundle = intent.getBundleExtra(Const.Params.NEW_ORDER);
            if (deliveryRequest != null && deliveryRequest.isShowing()) {
                deliveryRequest.notifyDataSetChange(bundle.getString(Const.Params.PUSH_DATA1));
                return;
            }
            if (Integer.parseInt(bundle.getString(Const.Params.PUSH_DATA2)) > 0) {
                deliveryRequest = new CustomDialogDeliveryRequest(this, bundle.getString(Const.Params.PUSH_DATA1), bundle.getString(Const.Params.PUSH_DATA2));
                deliveryRequest.show();
            }
        }
    }

    public String getAppVersion() {
        return BuildConfig.VERSION_NAME;
    }

    public int checkWitchOtpValidationON() {
        if (checkEmailVerification() && checkPhoneNumberVerification()) {
            return Const.SMS_AND_EMAIL_VERIFICATION_ON;
        } else if (checkPhoneNumberVerification()) {
            return Const.SMS_VERIFICATION_ON;
        } else if (checkEmailVerification()) {
            return Const.EMAIL_VERIFICATION_ON;
        }
        return 0;
    }

    private boolean checkEmailVerification() {
        return preferenceHelper.getIsMailVerification() && !preferenceHelper.getIsEmailVerified();
    }

    private boolean checkPhoneNumberVerification() {
        return preferenceHelper.getIsSmsVerification() && !preferenceHelper.getIsPhoneNumberVerified();
    }

    /**
     * this method used to send email to admin email id
     */
    public void contactUsWithAdmin() {
        Uri gmmIntentUri = Uri.parse("mailto:" + preferenceHelper.getAdminContactEmail() + "?subject=" + "Request to Admin " + "&body=" + "Hello sir");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.gm");
        if (mapIntent.resolveActivity(getPackageManager()) != null) {
            startActivity(mapIntent);
        } else {
            Utils.showToast(getResources().getString(R.string.msg_google_mail_app_not_installed), this);
        }
    }

    /**
     * this method call webservice for logout from app
     */
    public void logOut(boolean isForServer) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, this.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, this.preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.logOut(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.logout();
                        if (isForServer) {
                            goToSplashActivity();
                        } else {
                            goToLoginActivity();
                        }

                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), BaseAppCompatActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(BaseAppCompatActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void restartApp() {
        startActivity(new Intent(this, SplashScreenActivity.class));
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(LanguageHelper.wrapper(newBase, PreferenceHelper.getInstance(newBase).getLanguageCode()));
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

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        CurrentOrder.saveState(outState);
        ApiClient.saveState(outState);
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

    public interface OrderListener {
        void onOrderReceive();
    }

    public interface NetworkListener {
        void onNetworkChange(boolean isEnable);
    }

    public class AppReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(final Context context, final Intent intent) {
            if (intent != null) {
                switch (intent.getAction()) {
                    case Const.Action.NETWORK_ACTION:
                        if (networkListener != null) {
                            networkListener.onNetworkChange(Utils.isInternetConnected(context));
                        }
                        break;
                    case Const.Action.ACTION_ADMIN_APPROVED:
                        preferenceHelper.putIsApproved(true);
                        goToHomeActivity();
                        break;
                    case Const.Action.ACTION_ADMIN_DECLINE:
                        preferenceHelper.putIsApproved(false);
                        goToHomeActivity();
                        break;
                    case Const.Action.ACTION_NEW_ORDER:
                        openDeliveryRequestDialog(intent);
                        break;
                    case Const.Action.ACTION_STORE_CANCELED_REQUEST:
                        closedDeliveryRequestDialog();
                        if (orderListener != null) {
                            orderListener.onOrderReceive();
                        }
                        break;
                    case Const.Action.ACTION_ORDER_STATUS:
                        if (orderListener != null) {
                            orderListener.onOrderReceive();
                        }
                        break;
                }
            }
        }
    }
}