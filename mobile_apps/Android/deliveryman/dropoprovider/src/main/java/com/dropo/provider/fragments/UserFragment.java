package com.dropo.provider.fragments;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.BankDetailActivity;
import com.dropo.provider.BuildConfig;
import com.dropo.provider.HelpActivity;
import com.dropo.provider.NotificationActivity;
import com.dropo.provider.PaymentActivity;
import com.dropo.provider.ProfileActivity;
import com.dropo.provider.R;
import com.dropo.provider.SettingActivity;
import com.dropo.provider.adapter.UserMenuAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.ServerDialog;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.interfaces.TripleTapListener;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.ServerConfig;

public class UserFragment extends BaseFragments {

    private RecyclerView rcvUserMenu;
    private CustomFontTextView tvAppVersion;
    private CustomDialogAlert logoutDialog;
    private Spinner spinnerLanguage;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        homeActivity.setToolbarRightIcon(-1, null);
        homeActivity.setTitleOnToolBar(homeActivity.getResources().getString(R.string.text_user));
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user, container, false);
        rcvUserMenu = view.findViewById(R.id.rcvUserMenu);
        tvAppVersion = view.findViewById(R.id.tvAppVersion);
        spinnerLanguage = view.findViewById(R.id.spinnerLanguage);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initRcvUserMenu();
        setAppVersion();
        initLanguageSpinner();
    }

    @Override
    public void onClick(View view) {

    }

    private void initRcvUserMenu() {
        UserMenuAdapter userMenuAdapter = new UserMenuAdapter(homeActivity);
        rcvUserMenu.setLayoutManager(new LinearLayoutManager(homeActivity));
        rcvUserMenu.setAdapter(userMenuAdapter);
        rcvUserMenu.addOnItemTouchListener(new RecyclerTouchListener(homeActivity, rcvUserMenu, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                switch (position) {
                    case 0:
                        goToProfileActivity();
                        break;
                    case 1:
                        goToBankDetailActivity();
                        break;
                    case 2:
                        homeActivity.goToDocumentActivity(false);
                        break;
                    case 3:
                        goToSettingActivity();
                        break;
                    case 4:
                        goToPaymentsActivity();
                        break;
                    case 5:
                        homeActivity.goToVehicleDetailActivity(false);
                        break;
                    case 6:
                        goToNotificationActivity();
                        break;
                    case 7:
                        goToHelpActivity();
                        break;
                    case 8:
                        openLogoutDialog();
                        break;
                    default:
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

        logoutDialog = new CustomDialogAlert(homeActivity, homeActivity.getResources().getString(R.string.text_log_out), homeActivity.getResources().getString(R.string.msg_are_you_sure), homeActivity.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                homeActivity.logOut(false);
                dismiss();
            }
        };
        logoutDialog.show();
    }

    @SuppressLint("ClickableViewAccessibility")
    private void setAppVersion() {
        tvAppVersion.setText(String.format("%s %s", homeActivity.getResources().getString(R.string.text_app_version), homeActivity.getAppVersion()));

        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.elluminati.edelivery.provider")) {
            tvAppVersion.setOnTouchListener(new TripleTapListener() {
                @Override
                protected void onTripleTap() {
                    showServerDialog();
                }
            });
        }
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(homeActivity) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getInstance(homeActivity).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getInstance(homeActivity).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getInstance(homeActivity).putImageUrl(ServerConfig.IMAGE_URL);
                homeActivity.logOut(true);
            }
        };
        serverDialog.show();
    }

    private void goToProfileActivity() {
        Intent intent = new Intent(homeActivity, ProfileActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToBankDetailActivity() {
        Intent intent = new Intent(homeActivity, BankDetailActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToSettingActivity() {
        Intent intent = new Intent(homeActivity, SettingActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToPaymentsActivity() {
        Intent intent = new Intent(homeActivity, PaymentActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToHelpActivity() {
        Intent intent = new Intent(homeActivity, HelpActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToNotificationActivity() {
        Intent intent = new Intent(homeActivity, NotificationActivity.class);
        startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void initLanguageSpinner() {
        TypedArray array = this.getResources().obtainTypedArray(R.array.language_code);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(homeActivity, R.array.language_name, R.layout.spiner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spiner_view_small);
        spinnerLanguage.setAdapter(adapter);

        spinnerLanguage.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String languageCode = array.getString(i);
                if (!TextUtils.equals(homeActivity.preferenceHelper.getLanguageCode(), languageCode)) {
                    homeActivity.preferenceHelper.putLanguageIndex(i);
                    homeActivity.preferenceHelper.putLanguageCode(languageCode);
                    homeActivity.finishAffinity();
                    homeActivity.restartApp();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        int size = array.length();
        for (int i = 0; i < size; i++) {
            if (TextUtils.equals(homeActivity.preferenceHelper.getLanguageCode(), array.getString(i))) {
                spinnerLanguage.setSelection(i);
                break;
            }
        }
    }
}