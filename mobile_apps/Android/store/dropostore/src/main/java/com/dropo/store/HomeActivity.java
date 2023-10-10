package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.widget.SwitchCompat;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.store.R;
import com.dropo.store.adapter.DrawerAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomEditTextDialog;
import com.dropo.store.fragment.DeliveriesListFragment;
import com.dropo.store.fragment.ItemListFragment;
import com.dropo.store.fragment.OrderListFragment;
import com.dropo.store.fragment.ProfileFragment;
import com.dropo.store.models.responsemodel.OTPResponse;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.FirebaseUser;

import java.util.HashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HomeActivity extends BaseActivity {

    public DeliveriesListFragment deliveriesListFragment;
    public OrderListFragment orderListFragment;
    public ItemListFragment itemListFragment;
    public ProfileFragment profileFragment;
    public SwipeRefreshLayout mainSwipeLayout;
    public FloatingActionButton floatingBtn;
    private TextView tvToolbarTitle;
    private CustomAlterDialog customExitDialog;
    private CustomEditTextDialog accountVerifyDialog, verifyDialog;
    private String newEmail;
    private String newPhone;
    private ScheduledExecutorService updateLocationAndOrderSchedule;
    private boolean isScheduledStart;
    private Handler handler;
    private DrawerAdapter drawerAdapter;
    private String otpId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        mainSwipeLayout = findViewById(R.id.mainSwipeLayout);
        setColorSwipeToRefresh(mainSwipeLayout);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, 0, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(null);

        tvToolbarTitle = findViewById(R.id.tvToolbarTitle);
        tvToolbarTitle.setText(getString(R.string.text_orders));

        floatingBtn = findViewById(R.id.floatingBtn);
        floatingBtn.setOnClickListener(this);
        floatingBtn.setVisibility(View.GONE);
        initMenuDrawer(findViewById(R.id.rcvDrawer), findViewById(R.id.drawerLayout), toolbar);
        initHandler();
        getStoreDetails();
    }

    private void getStoreDetails() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.APP_VERSION, getVersionCode());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<StoreDataResponse> getDetailsResponse = apiInterface.getDetails(map);
        getDetailsResponse.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        ParseContent.getInstance().parseStoreData(response.body(), false);
                        checkApproveData();
                        signInAnonymously();
                    } else {
                        parseContent.showErrorMessage(HomeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), HomeActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    protected void initMenuDrawer(RecyclerView drawerList, DrawerLayout drawerLayout, Toolbar screenToolbar) {
        SwitchCompat switchDarkMode = findViewById(R.id.switchDarkMode);
        switchDarkMode.setChecked(AppColor.isDarkTheme(this));
        switchDarkMode.setOnCheckedChangeListener((compoundButton, checked) -> {
            if (checked) {
                PreferenceHelper.getPreferenceHelper(this).putTheme(AppColor.APP_THEME_DARK);
            } else {
                PreferenceHelper.getPreferenceHelper(this).putTheme(AppColor.APP_THEME_LIGHT);
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
                        goToOrderListFragment();
                        break;
                    case 1:
                        goToDeliveriesListFragment();
                        break;
                    case 2:
                        goToItemListFragment();
                        break;
                    case 3:
                        goToProfileFragment();
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
        actionbarDrawerToggle.setHomeAsUpIndicator(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_menu_icon, getTheme()));
        drawerLayout.addDrawerListener(actionbarDrawerToggle);
        actionbarDrawerToggle.syncState();
    }

    private void checkApproveData() {
        if (preferenceHelper.isApproved()) {
            closedAdminApprovedDialog();
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else {
                if (preferenceHelper.getIsVerifyEmail() || preferenceHelper.getIsVerifyPhone()) {
                    openVerifyDialog();
                }
            }
        } else {
            if (preferenceHelper.getIsAdminDocumentMandatory() && !preferenceHelper.getIsUserAllDocumentsUpload()) {
                goToDocumentActivity(true);
            } else {
                openStoreApproveDialog();
            }
        }
    }

    /**
     * this method called webservice for get OTP for mobile or email
     */
    private void getOtp(String email, String phone) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        if (!TextUtils.isEmpty(email)) {
            map.put(Constant.EMAIL, email);
        }
        if (!TextUtils.isEmpty(phone)) {
            map.put(Constant.PHONE, phone);
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
                        ParseContent.getInstance().showErrorMessage(HomeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), HomeActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
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
                        getStoreDetails();
                    } else {
                        ParseContent.getInstance().showErrorMessage(HomeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), HomeActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void openAccountVerifyDialog(HashMap<String, Object> map) {
        if (accountVerifyDialog != null && accountVerifyDialog.isShowing()) {
            return;
        }

        final int otpType = checkWitchOtpValidationON();

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

            accountVerifyDialog = new CustomEditTextDialog(this, true, getString(R.string.text_verify_details), message, getString(R.string.text_ok), otpType, map) {

                @Override
                public void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmailOtp) {
                    if (btnId == R.id.btnPositive) {
                        switch (otpType) {
                            case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText().toString().trim())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else if (TextUtils.isEmpty(etEmailOtp.getText().toString().trim())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString().trim(), etSMSOtp.getText().toString().trim(), otpId);
                                }
                                break;
                            case Constant.SMS_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(null, etSMSOtp.getText().toString().trim(), otpId);
                                }
                                break;
                            case Constant.EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etEmailOtp.getText())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString().trim(), null, otpId);
                                }
                                break;
                        }
                    } else {
                        dismiss();
                        logout(logoutDialog);
                    }
                }

                @Override
                public void resetOtpId(String otpId) {
                    HomeActivity.this.otpId = otpId;
                }
            };
            accountVerifyDialog.setCancelable(false);
            accountVerifyDialog.show();
        }
    }

    private void openVerifyDialog() {
        if (verifyDialog != null && verifyDialog.isShowing()) {
            return;
        }

        final int otpType = checkWitchOtpValidationON();
        if (otpType != -1) {
            verifyDialog = new CustomEditTextDialog(this, true, getResources().getString(R.string.text_confirm_details), getResources().getString(R.string.text_please_confirm_details), getResources().getString(R.string.text_ok), otpType) {
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
                                    newEmail = etEmailOtp.getText().toString();
                                    newPhone = etSMSOtp.getText().toString();
                                    dismiss();
                                    getOtp(newEmail, newPhone);
                                }
                                break;
                            case Constant.SMS_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    newPhone = etSMSOtp.getText().toString();
                                    dismiss();
                                    getOtp(null, newPhone);
                                }
                                break;
                            case Constant.EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etEmailOtp.getText().toString().trim())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    newEmail = etEmailOtp.getText().toString().trim();
                                    dismiss();
                                    getOtp(newEmail, null);
                                }
                                break;
                        }
                    } else {
                        dismiss();
                        logout(logoutDialog);
                    }
                }

                @Override
                public void resetOtpId(String otpId) {

                }
            };

            verifyDialog.setCancelable(false);
            verifyDialog.show();
            verifyDialog.textInputLayoutSMSOtp.setHint(getResources().getString(R.string.text_phone));
            verifyDialog.textInputLayoutEmailOtp.setHint(getResources().getString(R.string.text_email));
            verifyDialog.etSMSOtp.setText(preferenceHelper.getPhone());
            verifyDialog.etEmailOtp.setText(preferenceHelper.getEmail());
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.floatingBtn) {
            if (orderListFragment != null && orderListFragment.isVisible() && PreferenceHelper.getPreferenceHelper(this).getIsStoreCreateOrder()) {
                goToStoreOrderProductActivity();
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, R.drawable.ic_filter);
        setToolbarSaveIcon(false);
        loadFragmentAccordingStoreAccess();
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            ItemListFragment itemListFragment = (ItemListFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.ITEM_LIST_FRAGMENT);
            if (itemListFragment != null) {
                itemListFragment.openFilterDialog();
            }
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        openExitDialog();
    }

    private void openExitDialog() {
        if (customExitDialog != null && customExitDialog.isShowing()) {
            return;
        }
        customExitDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_exit), getResources().getString(R.string.text_are_you_sure), true, getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    dismiss();
                    finish();
                } else {
                    dismiss();
                }
            }
        };
        customExitDialog.show();
    }

    /**
     * this method used to transit one fragment to other fragment
     *
     * @param fragment       fragment
     * @param addToBackStack addToBackStack
     * @param isAnimate      isAnimate
     * @param tag            tag
     */
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

    private void goToOrderListFragment() {
        if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.ORDER)) {
            if (getSupportFragmentManager().findFragmentByTag(Constant.Tag.ORDER_LIST_FRAGMENT) == null) {
                orderListFragment = new OrderListFragment();
            } else {
                orderListFragment = (OrderListFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.ORDER_LIST_FRAGMENT);
            }
            addFragment(orderListFragment, true, true, Constant.Tag.ORDER_LIST_FRAGMENT);
            setToolbarEditIcon(false, R.drawable.ic_filter);
            tvToolbarTitle.setText(getString(R.string.text_orders));
            floatingBtn.setVisibility(preferenceHelper.getIsStoreCreateOrder() ? View.VISIBLE : View.GONE);
        }
    }

    private void goToItemListFragment() {
        if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.PRODUCT)) {
            if (getSupportFragmentManager().findFragmentByTag(Constant.Tag.ITEM_LIST_FRAGMENT) == null) {
                itemListFragment = new ItemListFragment();
            } else {
                itemListFragment = (ItemListFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.ITEM_LIST_FRAGMENT);
            }

            addFragment(itemListFragment, true, true, Constant.Tag.ITEM_LIST_FRAGMENT);
            setToolbarEditIcon(true, R.drawable.filter_store);
            tvToolbarTitle.setText(getString(R.string.text_items));
            floatingBtn.setVisibility(View.GONE);
        }
    }

    private void goToDeliveriesListFragment() {
        if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.DELIVERIES)) {
            if (getSupportFragmentManager().findFragmentByTag(Constant.Tag.DELIVERIES_LIST_FRAGMENT) == null) {
                deliveriesListFragment = new DeliveriesListFragment();
            } else {
                deliveriesListFragment = (DeliveriesListFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.DELIVERIES_LIST_FRAGMENT);
            }
            addFragment(deliveriesListFragment, true, true, Constant.Tag.DELIVERIES_LIST_FRAGMENT);
            setToolbarEditIcon(false, 0);
            tvToolbarTitle.setText(getString(R.string.text_deliveries));
            floatingBtn.setVisibility(View.GONE);
        }
    }

    private void goToProfileFragment() {
        if (getSupportFragmentManager().findFragmentByTag(Constant.Tag.PROFILE_FRAGMENT) == null) {
            profileFragment = new ProfileFragment();
        } else {
            profileFragment = (ProfileFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.PROFILE_FRAGMENT);
        }
        addFragment(profileFragment, true, true, Constant.Tag.PROFILE_FRAGMENT);
        setToolbarEditIcon(false, 0);
        tvToolbarTitle.setText(getString(R.string.text_account));
        floatingBtn.setVisibility(View.GONE);
    }

    public void startSchedule() {
        if (!isScheduledStart && preferenceHelper.isApproved()) {
            Runnable runnable = () -> {
                Message message = handler.obtainMessage();
                handler.sendMessage(message);
            };
            updateLocationAndOrderSchedule = Executors.newSingleThreadScheduledExecutor();
            updateLocationAndOrderSchedule.scheduleWithFixedDelay(runnable, 0, Constant.ORDER_SCHEDULED, TimeUnit.SECONDS);
            isScheduledStart = true;
        }
    }

    public void stopSchedule() {
        if (isScheduledStart) {
            updateLocationAndOrderSchedule.shutdown(); // Disable new tasks from being submitted
            // Wait a while for existing tasks to terminate
            try {
                if (!updateLocationAndOrderSchedule.awaitTermination(60, TimeUnit.SECONDS)) {
                    updateLocationAndOrderSchedule.shutdownNow(); // Cancel currently executing
                }
            } catch (InterruptedException e) {
                Utilities.handleException(HomeActivity.class.getName(), e);
                // (Re-)Cancel if current thread also interrupted
                updateLocationAndOrderSchedule.shutdownNow();
                // Preserve interrupt status
                Thread.currentThread().interrupt();
            }
            isScheduledStart = false;
        }
    }

    /**
     * This handler receive a message from  requestStatusScheduledService and update provider
     * location and order status
     */
    @SuppressLint("HandlerLeak")
    private void initHandler() {
        handler = new Handler(Looper.myLooper()) {
            @Override
            public void handleMessage(Message msg) {
                OrderListFragment orderListFragment = (OrderListFragment) getSupportFragmentManager().findFragmentByTag(Constant.Tag.ORDER_LIST_FRAGMENT);
                if (orderListFragment != null) {
                    orderListFragment.getOrderList();
                }
            }
        };
    }

    private void goToStoreOrderProductActivity() {
        Intent intent = new Intent(this, StoreOrderProductActivity.class);
        intent.putExtra(Constant.IS_ORDER_UPDATE, false);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void loadFragmentAccordingStoreAccess() {
        if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.ORDER)) {
            goToOrderListFragment();
        } else if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.DELIVERIES)) {
            goToDeliveriesListFragment();
        } else {
            goToItemListFragment();
        }
    }

    private void signInAnonymously() {
        FirebaseUser currentUser = mAuth.getCurrentUser();
        if (currentUser == null) {
            if (!TextUtils.isEmpty(preferenceHelper.getFireBaseUserToken())) {
                mAuth.signInWithCustomToken(preferenceHelper.getFireBaseUserToken()).addOnCompleteListener(this, task -> {
                    if (task.isSuccessful()) {
                        FirebaseUser user = mAuth.getCurrentUser();
                    } else {
                        Utilities.showToast(HomeActivity.this, "Authentication failed.");
                    }
                });
            }
        }
    }
}