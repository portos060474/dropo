package com.dropo;

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
import android.widget.FrameLayout;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.res.ResourcesCompat;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontTextView;
import com.dropo.interfaces.OnSingleClickListener;
import com.dropo.models.datamodels.AppLanguage;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.models.singleton.OrderEdit;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.persistentroomdata.notification.NotificationRepository;
import com.dropo.user.BuildConfig;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FontsOverride;
import com.dropo.utils.GlideApp;
import com.dropo.utils.LanguageHelper;
import com.dropo.utils.NetworkHelper;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.ServerConfig;
import com.dropo.utils.Utils;
import com.facebook.login.LoginManager;
import com.google.firebase.auth.FirebaseAuth;

import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class BaseAppCompatActivity extends AppCompatActivity implements View.OnClickListener {
    public final String TAG = this.getClass().getSimpleName();

    private final AppReceiver appReceiver = new AppReceiver();
    public Toolbar toolbar;
    public PreferenceHelper preferenceHelper;
    public ParseContent parseContent;
    public ImageView ivToolbarBack, ivToolbarRightIcon3, ivToolbarRightIcon1, ivToolbarRightIcon2;
    public CustomFontTextView tvToolbarRightBtn;
    public FrameLayout flCart;
    public CustomFontTextView tvTitleToolbar;
    public CurrentBooking currentBooking;
    public FirebaseAuth mAuth;
    private ActionBar actionBar;
    private CustomDialogAlert customDialogEnableInternet;
    private CustomDialogAlert customDialogAdmin;
    private NetworkListener networkListener;
    private OrderStatusListener orderStatusListener;
    private NetworkHelper networkHelper;
    private ImageView ivToolbarProfile;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        preferenceHelper = PreferenceHelper.getInstance(this);
        AppColor.onActivityCreateSetTheme(this);
        ApiClient.restoreState(savedInstanceState);
        CurrentBooking.restoreState(savedInstanceState);
        OrderEdit.restoreState(savedInstanceState);
        FontsOverride.setDefaultFont(this, "MONOSPACE", "fonts/ClanPro-News.otf");
        parseContent = ParseContent.getInstance();
        parseContent.setContext(this);
        currentBooking = CurrentBooking.getInstance();
        mAuth = FirebaseAuth.getInstance();

        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Const.Action.ACTION_ADMIN_APPROVED);
        intentFilter.addAction(Const.Action.ACTION_ADMIN_DECLINE);
        intentFilter.addAction(Const.Action.ACTION_ORDER_STATUS);
        intentFilter.addAction(Const.Action.ACTION_LOGIN_AT_ANOTHER_DEVICE);
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
    protected void onDestroy() {
        unregisterReceiver(appReceiver);
        super.onDestroy();
    }

    protected void initToolBar() {
        toolbar = findViewById(R.id.appToolbar);
        tvTitleToolbar = toolbar.findViewById(R.id.tvToolbarTitle);
        ivToolbarProfile = toolbar.findViewById(R.id.ivToolbarProfile);
        ivToolbarRightIcon1 = toolbar.findViewById(R.id.ivToolbarRightIcon1);
        ivToolbarRightIcon2 = toolbar.findViewById(R.id.ivToolbarRightIcon2);
        ivToolbarRightIcon3 = toolbar.findViewById(R.id.ivToolbarRightIcon3);
        tvToolbarRightBtn = toolbar.findViewById(R.id.tvToolbarRightBtn);
        flCart = toolbar.findViewById(R.id.flCart);
        ivToolbarBack = findViewById(R.id.ivToolbarBack);
        setSupportActionBar(toolbar);
        actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayShowTitleEnabled(false);
            actionBar.setDisplayHomeAsUpEnabled(false);
        }
        ivToolbarBack.setOnClickListener(view -> onBackNavigation());
        ivToolbarBack.setImageDrawable(AppColor.getThemeModeDrawable(R.drawable.ic_left_arrow, BaseAppCompatActivity.this));
    }

    public void setTitleOnToolBar(String title) {
        if (tvTitleToolbar != null) {
            tvTitleToolbar.setText(title);
        }
    }

    protected void setToolbarProfile(boolean isVisible, View.OnClickListener onClickListener) {
        if (isVisible) {
            ivToolbarProfile.setVisibility(View.VISIBLE);
            if (isCurrentLogin()) {
                GlideApp.with(this).load(ServerConfig.IMAGE_URL + preferenceHelper.getProfilePic()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.man_user, null)).fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.man_user, null)).into(ivToolbarProfile);
            } else {
                ivToolbarProfile.setImageResource(R.drawable.man_user);
            }
            ivToolbarProfile.setOnClickListener(new OnSingleClickListener() {
                @Override
                public void onSingleClick(View v) {
                    onClickListener.onClick(v);
                }
            });
            ivToolbarBack.setVisibility(View.GONE);
        } else {
            ivToolbarProfile.setVisibility(View.GONE);
        }
    }

    public void setToolbarRightIcon3(int drawableResourcesId, View.OnClickListener onClickListener) {
        if (ivToolbarRightIcon3 != null) {
            if (drawableResourcesId <= 0) {
                ivToolbarRightIcon3.setVisibility(View.GONE);
            } else {
                ivToolbarRightIcon3.setVisibility(View.VISIBLE);
                Drawable drawable = AppCompatResources.getDrawable(this, drawableResourcesId);
                if (drawable != null) {
                    drawable.setTint(AppColor.COLOR_THEME);
                    ivToolbarRightIcon3.setImageDrawable(drawable);
                    ivToolbarRightIcon3.setOnClickListener(onClickListener);
                }
            }

        }
    }

    public void setToolbarRightIcon1(int drawableResourcesId, View.OnClickListener onClickListener) {
        Drawable drawable = AppCompatResources.getDrawable(this, drawableResourcesId);
        if (drawable != null) {
            drawable.setTint(AppColor.COLOR_THEME);
            ivToolbarRightIcon1.setImageDrawable(drawable);
            ivToolbarRightIcon1.setOnClickListener(onClickListener);
        }
    }

    public void setToolbarRightIcon2(int drawableResourcesId, View.OnClickListener onClickListener) {
        if (drawableResourcesId <= 0) {
            ivToolbarRightIcon2.setVisibility(View.GONE);
        } else {
            Drawable drawable = AppCompatResources.getDrawable(this, drawableResourcesId);
            if (drawable != null) {
                ivToolbarRightIcon2.setVisibility(View.VISIBLE);
                drawable.setTint(AppColor.COLOR_THEME);
                ivToolbarRightIcon2.setImageDrawable(drawable);
                ivToolbarRightIcon2.setOnClickListener(onClickListener);
            }
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


    public void goToLoginActivityForResult(AppCompatActivity activity, boolean isFromCheckout) {
        Intent loginIntent = new Intent(activity, LoginActivity.class);
        loginIntent.putExtra(Const.IS_FROM_CHECKOUT, isFromCheckout);
        activity.startActivityForResult(loginIntent, Const.LOGIN_REQUEST);
    }

    public void goToAccountActivity() {
        Intent accountIntent = new Intent(this, AccountActivity.class);
        startActivity(accountIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToHomeActivity() {
        Intent homeIntent = new Intent(this, HomeActivity.class);
        homeIntent.setAction(this.getIntent().getAction());
        homeIntent.setData(this.getIntent().getData());
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToSplashActivity() {
        Intent intent = new Intent(this, SplashScreenActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finishAffinity();
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToMandatoryDeliveryLocationActivity() {
        Intent intent = new Intent(this, DeliveryLocationActivity.class);
        intent.setAction(this.getIntent().getAction());
        intent.setData(this.getIntent().getData());
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }


    public void goToDocumentActivity(boolean isApplicationStart) {
        Intent intent = new Intent(this, DocumentActivity.class);
        intent.putExtra(Const.Tag.DOCUMENT_ACTIVITY, isApplicationStart);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void goToDocumentActivityForResult(AppCompatActivity activity, boolean isApplicationStart, boolean isFromCheckOut) {
        Intent intent = new Intent(this, DocumentActivity.class);
        intent.putExtra(Const.Tag.DOCUMENT_ACTIVITY, isApplicationStart);
        intent.putExtra(Const.IS_FROM_CHECKOUT, isFromCheckOut);
        activity.startActivityForResult(intent, Const.DOCUMENT_REQUEST);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    protected void openInternetDialog(final AppCompatActivity activity) {
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

    protected void goToCartActivity() {
        Intent intent = new Intent(this, CartActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    protected void openAdminApprovedDialog() {
        if (!this.isFinishing()) {
            if (customDialogAdmin != null && customDialogAdmin.isShowing()) {
                return;
            }
            customDialogAdmin = new CustomDialogAlert(this, getResources().getString(R.string.text_alert), getResources().getString(R.string.msg_not_approved_by_admin), getResources().getString(R.string.text_email)) {
                @Override
                public void onClickLeftButton() {
                    dismiss();
                    logOut(false);
                }

                @Override
                public void onClickRightButton() {
                    contactUsWithAdmin();
                }
            };
            customDialogAdmin.show();
            customDialogAdmin.setNegativeButtonIcon(R.drawable.ic_logout_stroke);
        }
    }

    protected void closedAdminApprovedDialog() {
        if (customDialogAdmin != null && customDialogAdmin.isShowing()) {
            customDialogAdmin.dismiss();
        }
    }

    public void setOrderStatusListener(OrderStatusListener orderStatusListener) {
        this.orderStatusListener = orderStatusListener;
    }

    public void setNetworkListener(NetworkListener networkListener) {
        this.networkListener = networkListener;
        networkHelper.setNetworkAvailableListener(networkListener);
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
     * this method will help to logout in our app it will called logout service from web
     */
    public void logOut(boolean isForServer) {
        Utils.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.logOut(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        preferenceHelper.putAndroidId(Utils.generateRandomString());
                        preferenceHelper.clearVerification();
                        preferenceHelper.logout();
                        LoginManager.getInstance().logOut();
                        NotificationRepository.getInstance(BaseAppCompatActivity.this).clearNotification();
                        currentBooking.clearCurrentBookingModel();
                        mAuth.signOut();

                        if (isForServer) {
                            goToSplashActivity();
                        } else {
                            goToHomeActivity();
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

    public boolean isCurrentLogin() {
        return !TextUtils.isEmpty(preferenceHelper.getUserId());
    }

    public HashMap<String, Object> getCommonParam() {
        HashMap<String, Object> map = new HashMap<>();
        if (isCurrentLogin()) {
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
            map.put(Const.Params.CART_UNIQUE_TOKEN, "");
        } else {
            map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
            map.put(Const.Params.USER_ID, "");
        }
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        return map;
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

    public int getLangIndxex(String language, List<AppLanguage> langs, boolean isCheckVisibility) {
        int lang = 0;
        if (langs != null && !langs.isEmpty()) {
            for (int j = 0; j < langs.size(); j++) {
                if (isCheckVisibility) {
                    if (TextUtils.equals(language, langs.
                            get(j).getCode()) && langs.
                            get(j).isVisible()) {
                        lang = j;
                        break;
                    }
                } else {
                    if (TextUtils.equals(language, langs.
                            get(j).getCode())) {
                        lang = j;
                        break;
                    }
                }
            }
        }
        return lang;
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        ApiClient.saveState(outState);
        CurrentBooking.saveState(outState);
        OrderEdit.saveState(outState);
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

    public void handleDeepLinkIntent(Intent intent) {
        Uri data = intent.getData();
        if (Objects.equals(getIntent().getAction(), Intent.ACTION_VIEW) && data != null) {
            String path = data.getQueryParameter(Const.Query.PAGE);
            if (TextUtils.isEmpty(path)) {
                path = data.getLastPathSegment();
            }
            if (path.equals(Const.Path.STORE)) {
                String storeId = data.getQueryParameter(Const.Query.STORE_ID);
                String tableId = data.getQueryParameter(Const.Query.TABLE_ID);
                goToStoreProductActivityFromDeepLink(storeId, tableId);
            }
            getIntent().setData(new Intent().getData());
        }
    }

    public void goToStoreProductActivityFromDeepLink(String storeId, String tableId) {
        Intent intent = new Intent(this, StoreProductActivity.class);
        intent.putExtra(Const.STORE_DETAIL, storeId);
        intent.putExtra(Const.IS_STORE_CAN_CREATE_GROUP, CurrentBooking.getInstance().isStoreCanCreateGroup());
        intent.putExtra(Const.TABLE_DETAIL, tableId);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void clearQROrderData() {
        if (preferenceHelper.getIsRegisterQRUser()) {
            preferenceHelper.putUserId("");
            preferenceHelper.putSessionToken("");
            preferenceHelper.putIsRegisterQRUser(false);
        }
        preferenceHelper.putIsFromQRCode(false);
    }

    public interface NetworkListener {
        void onNetworkChange(boolean isEnable);
    }

    public interface OrderStatusListener {
        void onOrderStatus();
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
                        closedAdminApprovedDialog();
                        goToHomeActivity();
                        break;
                    case Const.Action.ACTION_ADMIN_DECLINE:
                        openAdminApprovedDialog();
                        break;
                    case Const.Action.ACTION_ORDER_STATUS:
                        if (orderStatusListener != null) {
                            orderStatusListener.onOrderStatus();
                        }
                        break;
                    case Const.Action.ACTION_LOGIN_AT_ANOTHER_DEVICE:
                        goToLoginActivityForResult(BaseAppCompatActivity.this, false);
                        break;
                }
            }
        }
    }
}