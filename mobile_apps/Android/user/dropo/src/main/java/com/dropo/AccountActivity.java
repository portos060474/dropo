package com.dropo;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.UserMenuAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.ServerDialog;
import com.dropo.interfaces.ClickListener;
import com.dropo.interfaces.RecyclerTouchListener;
import com.dropo.interfaces.TripleTapListener;
import com.dropo.user.BuildConfig;
import com.dropo.user.R;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.ServerConfig;

public class AccountActivity extends BaseAppCompatActivity {

    private RecyclerView rcvUserMenu;
    private CustomFontTextView tvAppVersion;
    private CustomDialogAlert logoutDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account);
        initToolBar();
        initViewById();
        setViewListener();
        initRcvUserMenu();
        setAppVersion();
    }

    private void initRcvUserMenu() {
        UserMenuAdapter userMenuAdapter = new UserMenuAdapter(this);
        rcvUserMenu.setLayoutManager(new LinearLayoutManager(this));
        rcvUserMenu.setAdapter(userMenuAdapter);
        rcvUserMenu.addOnItemTouchListener(new RecyclerTouchListener(this, rcvUserMenu, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                switch (position) {
                    case 0:
                        goToProfileActivity();
                        break;
                    case 1:
                        goToPaymentActivity(false);
                        break;
                    case 2:
                        goToDocumentActivity(false);
                        break;
                    case 3:
                        goToOrdersActivity();
                        break;
                    case 4:
                        goToSettingActivity();
                        break;
                    case 5:
                        goToFavouriteActivity();
                        break;
                    case 6:
                        goToFavouriteAddressActivity();
                        break;
                    case 7:
                        goToNotificationAddressActivity();
                        break;
                    case 8:
                        goToHelpActivity();
                        break;
                    case 9:
                        openLogoutDialog();
                        break;
                    case 10:
                        startNewActivity(AccountActivity.this, "com.elluminati.eber");
                        break;
                    default:
                        // do with default
                        break;
                }
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }

    private void openLogoutDialog() {
        if (logoutDialog != null && logoutDialog.isShowing()) {
            return;
        }
        logoutDialog = new CustomDialogAlert(this, this.getResources().getString(R.string.text_log_out), this.getResources().getString(R.string.msg_are_you_sure_to_logout), this.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                logOut(false);
                dismiss();
            }
        };
        logoutDialog.show();
    }

    @SuppressLint("ClickableViewAccessibility")
    private void setAppVersion() {
        tvAppVersion.setText(String.format("%s %s", this.getResources().getString(R.string.text_app_version), this.getAppVersion()));

        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.dropo.user")) {
            tvAppVersion.setOnTouchListener(new TripleTapListener() {
                @Override
                protected void onTripleTap() {
                    showServerDialog();
                }
            });
        }
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(this) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getInstance(AccountActivity.this).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getInstance(AccountActivity.this).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getInstance(AccountActivity.this).putImageUrl(ServerConfig.IMAGE_URL);
                logOut(true);
            }
        };
        serverDialog.show();
    }

    private void goToOrdersActivity() {
        Intent intent = new Intent(this, OrdersActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToProfileActivity() {
        Intent intent = new Intent(this, ProfileActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToSettingActivity() {
        Intent intent = new Intent(this, SettingActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToFavouriteActivity() {
        Intent intent = new Intent(this, FavouriteStoreActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToFavouriteAddressActivity() {
        Intent intent = new Intent(this, FavouriteAddressActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToNotificationAddressActivity() {
        Intent intent = new Intent(this, NotificationActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToHelpActivity() {
        Intent intent = new Intent(this, HelpActivity.class);
        startActivity(intent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToPaymentActivity(boolean isPayNowInvisible) {
        Intent homeIntent = new Intent(this, PaymentActivity.class);
        homeIntent.putExtra(Const.Tag.PAYMENT_ACTIVITY, isPayNowInvisible);
        startActivity(homeIntent);
        this.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void startNewActivity(Context context, String packageName) {
        Intent intent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        if (intent == null) {
            // Bring user to the market or let them choose an app?
            intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse("market://details?id=" + packageName));
        }
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvUserMenu = findViewById(R.id.rcvUserMenu);
        tvAppVersion = findViewById(R.id.tvAppVersion);

    }

    @Override
    protected void setViewListener() {
        setToolbarProfile(false, null);
        setTitleOnToolBar(getResources().getString(R.string.text_user));
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}