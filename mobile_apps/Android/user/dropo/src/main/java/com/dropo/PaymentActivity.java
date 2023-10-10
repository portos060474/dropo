package com.dropo;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.util.StateSet;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.ViewPagerAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomDialogVerification;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.DialogVerifyPayment;
import com.dropo.fragments.BasePaymentFragments;
import com.dropo.fragments.CashFragment;
import com.dropo.fragments.FeedbackFragment;
import com.dropo.fragments.PayPalFragment;
import com.dropo.fragments.PaystackFragment;
import com.dropo.fragments.StripeFragment;
import com.dropo.interfaces.OnSingleClickListener;
import com.dropo.models.datamodels.Card;
import com.dropo.models.datamodels.PaymentGateway;
import com.dropo.models.datamodels.UnavailableItems;
import com.dropo.models.responsemodels.CheckAvailableItemResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.PaymentGatewayResponse;
import com.dropo.models.responsemodels.PaymentResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.tabs.TabLayout;
import com.stripe.android.ApiResultCallback;
import com.stripe.android.PaymentAuthConfig;
import com.stripe.android.PaymentConfiguration;
import com.stripe.android.PaymentIntentResult;
import com.stripe.android.Stripe;
import com.stripe.android.model.ConfirmPaymentIntentParams;
import com.stripe.android.model.PaymentIntent;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PaymentActivity extends BaseAppCompatActivity {

    public List<PaymentGateway> paymentGateways;
    public PaymentGateway gatewayItem;
    public String stripeKeyId;
    public Card selectCard;
    private SwitchCompat switchIsWalletUse;
    private CustomFontTextView tvWalletAmount, tvAddWalletAmount;
    private ViewPagerAdapter viewPagerAdapter;
    private TabLayout tabLayout;
    private ViewPager viewPager;
    private LinearLayout btnPayNow;
    private CustomFontTextView tvPayMessage, tvPayTotal;
    private boolean isComingFromCheckout;
    private int deliveryType;
    private Stripe stripe;
    private boolean isPaymentForWallet;
    private CustomDialogVerification customDialogVerification;
    private Double addWalletAmount;
    private CustomFontTextView tvAddCard;
    private View llWallet;
    private CustomDialogAlert unavailableCartItemsDialog;
    public boolean isBringChange = false;
    public boolean isShowBringChange = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        restoreState(savedInstanceState);
        setContentView(R.layout.activity_payment);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_payments));
        initViewById();
        getExtraData();
        setViewListener();
        getPaymentGateWays();
        if (!preferenceHelper.getIsRegisterQRUser()) {
            setToolbarRightIcon3(R.drawable.ic_history_time, this);
        }
        if (preferenceHelper.getIsRegisterQRUser()) {
            llWallet.setVisibility(View.GONE);
        }
    }

    private void initStripePayment() {
        final PaymentAuthConfig.Stripe3ds2UiCustomization uiCustomization;
        uiCustomization = new PaymentAuthConfig.Stripe3ds2UiCustomization.Builder().build();
        PaymentAuthConfig.init(new PaymentAuthConfig.Builder().set3ds2Config(new PaymentAuthConfig.Stripe3ds2Config.Builder()
                // set a 5 minute timeout for challenge flow
                .setTimeout(5)
                // customize the UI of the challenge flow
                .setUiCustomization(uiCustomization).build()).build());

        PaymentConfiguration.init(this, stripeKeyId);
        stripe = new Stripe(this, PaymentConfiguration.getInstance(this).getPublishableKey());
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        llWallet = findViewById(R.id.llWallet);
        switchIsWalletUse = findViewById(R.id.switchIsWalletUse);
        tvWalletAmount = findViewById(R.id.tvWalletAmount);
        tvAddWalletAmount = findViewById(R.id.tvAddWalletAmount);
        tabLayout = findViewById(R.id.paymentTabsLayout);
        viewPager = findViewById(R.id.paymentViewpager);
        btnPayNow = findViewById(R.id.btnPayNow);
        tvPayTotal = findViewById(R.id.tvPayTotal);
        tvPayMessage = findViewById(R.id.tvPayMessage);
        tvAddCard = findViewById(R.id.tvAddCard);
        tvAddCard.setVisibility(View.GONE);
    }

    @Override
    protected void setViewListener() {
        tvAddCard.setOnClickListener(this);
        tvAddWalletAmount.setOnClickListener(this);
        switchIsWalletUse.setOnClickListener(this);
        btnPayNow.setOnClickListener(new OnSingleClickListener() {
            @Override
            public void onSingleClick(View v) {
                PaymentActivity.this.onClick(v);
            }
        });
        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                setSelectedPaymentGateway(tab.getText().toString());
                Fragment paymentFragments = viewPagerAdapter.getItem(tab.getPosition());
                if (paymentFragments instanceof StripeFragment) {
                    tvAddCard.setVisibility(View.VISIBLE);
                    tvAddCard.setTag(tab.getPosition());
                    ((StripeFragment) paymentFragments).notifyCardData();
                } else if (paymentFragments instanceof PaystackFragment) {
                    tvAddCard.setVisibility(View.VISIBLE);
                    tvAddCard.setTag(tab.getPosition());
                    ((PaystackFragment) paymentFragments).notifyCardData();
                } else {
                    tvAddCard.setVisibility(View.GONE);
                }
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.tvAddWalletAmount) {
            openAddWalletDialog();
        } else if (id == R.id.switchIsWalletUse) {
            toggleWalletUse();
        } else if (id == R.id.btnPayNow) {
            checkAvailableItem();
        } else if (id == R.id.ivToolbarRightIcon3) {
            goToWalletHistoryActivity();
        } else if (id == R.id.tvAddCard) {
            if (tvAddCard.getVisibility() == View.VISIBLE && viewPagerAdapter != null) {
                BasePaymentFragments stripeFragment = (BasePaymentFragments) viewPagerAdapter.getItem((Integer) tvAddCard.getTag());
                if (stripeFragment instanceof StripeFragment) {
                    ((StripeFragment) stripeFragment).openAddCardDialog();
                } else if (stripeFragment instanceof PaystackFragment) {
                    ((PaystackFragment) stripeFragment).gotoPayStackAddCard();
                }
            }
        }
    }

    /**
     * Check all items are available to place order
     */
    private void checkAvailableItem() {
        Utils.showCustomProgressDialog(this, false);

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put(Const.Params.CART_ID, currentBooking.getCartId());
        if (currentBooking.isFutureOrder()) {
            hashMap.put(Const.Params.IS_SCHEDULE_ORDER, ApiClient.makeTextRequestBody(currentBooking.isFutureOrder()));
            if (currentBooking.getSchedule().isDeliverySlotSelect()) {
                hashMap.put(Const.Params.ORDER_START_AT, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli()));
                hashMap.put(Const.Params.ORDER_START_AT2, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli()));
                if (currentBooking.isTableBooking()) {
                    hashMap.put(Const.Params.TABLE_ID, ApiClient.makeTextRequestBody(currentBooking.getTableId()));
                }
            } else {
                hashMap.put(Const.Params.ORDER_START_AT, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli()));
            }
        }

        Call<CheckAvailableItemResponse> call = ApiClient.getClient().create(ApiInterface.class).checkAvailableItem(hashMap);
        call.enqueue(new Callback<CheckAvailableItemResponse>() {
            @Override
            public void onResponse(@NonNull Call<CheckAvailableItemResponse> call, @NonNull Response<CheckAvailableItemResponse> response) {
                Utils.hideCustomProgressDialog();
                if (Objects.requireNonNull(response.body()).isSuccess()) {
                    if (response.body().getUnavailableItems() != null && response.body().getUnavailableItems().isEmpty()) {
                        checkPaymentGatewayForPayOrder();
                    } else {
                        showUnavailableCartItemsDialog(response.body().getUnavailableItems(), response.body().getUnavailableProducts());
                    }
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<CheckAvailableItemResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(TAG, t);
            }
        });
    }

    /**
     * Unavailable item dialog
     */
    private void showUnavailableCartItemsDialog(List<UnavailableItems> unavailableItemsList, List<UnavailableItems> unavailableProductsList) {
        if (unavailableCartItemsDialog != null && unavailableCartItemsDialog.isShowing() && !isFinishing()) {
            return;
        }

        StringBuilder message = new StringBuilder();
        message.append(getString(R.string.text_following_items_are_not_available)).append("\n\n");
        for (int i = 0; i < unavailableItemsList.size(); i++) {
            if (unavailableItemsList.size() - 1 == i) {
                message.append(unavailableItemsList.get(i).getItemName());
            } else {
                message.append(unavailableItemsList.get(i).getItemName()).append(", ");
            }
        }

        unavailableCartItemsDialog = new CustomDialogAlert(this, getString(R.string.text_alert), message.toString(), getString(R.string.text_go_to_home)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                goToHomeActivity();
            }
        };

        unavailableCartItemsDialog.show();
    }


    /**
     * this method called a webservice for toggleWalletUse
     */
    private void toggleWalletUse() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.IS_USE_WALLET, switchIsWalletUse.isChecked());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.toggleWalletUse(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        switchIsWalletUse.setChecked(response.body().isWalletUse());
                        setMessageAsParPayment(switchIsWalletUse.isChecked(), preferenceHelper.getWalletAmount(), currentBooking.getTotalInvoiceAmount());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                        switchIsWalletUse.setChecked(!switchIsWalletUse.isChecked());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PAYMENT_ACTIVITY, t);
                switchIsWalletUse.setChecked(!switchIsWalletUse.isChecked());
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called a webservice for  add wallet amount
     */
    public void addWalletAmount(String paymentIntentId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
        map.put(Const.Params.LAST_FOUR, selectCard.getLastFour());
        map.put(Const.Params.WALLET, addWalletAmount);
        map.put(Const.Params.PAYMENT_INTENT_ID, paymentIntentId);

        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<PaymentResponse> responseCall = apiInterface.getAddWalletAmount(map);
        responseCall.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                        Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PAYMENT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called a webservice to get client secret and initiate payment Intent for
     * delivery order or add wallet
     */
    public void createStripePaymentIntent() {
        this.isPaymentForWallet = true;
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
        if (isPaymentForWallet) {
            map.put(Const.Params.AMOUNT, addWalletAmount);
        } else {
            map.put(Const.Params.ORDER_PAYMENT_ID, currentBooking.getOrderPaymentId());
        }
        Call<PaymentResponse> call;
        if (isPaymentForWallet) {
            call = ApiClient.getClient().create(ApiInterface.class).getStripPaymentIntentWallet(map);
        } else {
            call = ApiClient.getClient().create(ApiInterface.class).getStripPaymentIntent(map);
        }
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (gatewayItem.getId().equals(Const.Payment.STRIPE)) {
                            ConfirmPaymentIntentParams paymentIntentParams = ConfirmPaymentIntentParams.createWithPaymentMethodId(response.body().getPaymentMethod(), response.body().getClientSecret());
                            stripe.confirmPayment(PaymentActivity.this, paymentIntentParams);
                        } else if (gatewayItem.getId().equals(Const.Payment.PAYSTACK)) {
                            Utils.hideCustomProgressDialog();
                            setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                            Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                        }
                    } else {
                        Utils.hideCustomProgressDialog();
                        if (TextUtils.isEmpty(response.body().getRequiredParam())) {
                            if (!TextUtils.isEmpty(response.body().getError())) {
                                Utils.showToast(response.body().getError(), PaymentActivity.this);
                            } else {
                                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                            }
                        } else {
                            openVerificationDialog(response.body().getRequiredParam(), response.body().getReference());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(PaymentActivity.class.getSimpleName(), t);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (stripe != null) {
            stripe.onPaymentResult(requestCode, data, new ApiResultCallback<PaymentIntentResult>() {
                @Override
                public void onSuccess(@NonNull PaymentIntentResult result) {
                    Utils.hideCustomProgressDialog();
                    final PaymentIntent paymentIntent = result.getIntent();
                    final PaymentIntent.Status status = paymentIntent.getStatus();
                    if (status == PaymentIntent.Status.Succeeded || status == PaymentIntent.Status.RequiresCapture) {
                        if (isPaymentForWallet) {
                            addWalletAmount(paymentIntent.getId());
                        } else {
                            createOrder(deliveryType, paymentIntent.getId(), false);
                        }
                    } else if (status == PaymentIntent.Status.Canceled) {
                        Utils.hideCustomProgressDialog();
                        Utils.showToast(getString(R.string.error_payment_cancel), PaymentActivity.this);
                    } else if (status == PaymentIntent.Status.Processing) {
                        Utils.hideCustomProgressDialog();
                        Utils.showToast(getString(R.string.error_payment_processing), PaymentActivity.this);
                    } else if (status == PaymentIntent.Status.RequiresPaymentMethod) {
                        Utils.hideCustomProgressDialog();
                        Utils.showToast(getString(R.string.error_payment_auth), PaymentActivity.this);
                    } else if (status == PaymentIntent.Status.RequiresAction || status == PaymentIntent.Status.RequiresConfirmation) {
                        Utils.hideCustomProgressDialog();
                        Utils.showToast(getString(R.string.error_payment_action), PaymentActivity.this);
                    }/* else if (status == PaymentIntent.Status.RequiresCapture) {
                        Utils.hideCustomProgressDialog();
                        Utils.showToast(
                                getString(R.string.error_payment_capture), PaymentActivity.this);
                    } */ else {
                        Utils.hideCustomProgressDialog();
                    }

                }

                @Override
                public void onError(@NonNull Exception e) {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast(e.getMessage(), PaymentActivity.this);
                }
            });
        }
    }

    /**
     * this method called a webservice to get All Payment Gateway witch is available from admin
     * panel
     */
    private void getPaymentGateWays() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.COUNTRY, currentBooking.getCountry());
        map.put(Const.Params.COUNTRY_CODE, currentBooking.getCountryCode());
        map.put(Const.Params.COUNTRY_CODE_2, currentBooking.getCountryCode2());
        map.put(Const.Params.LATITUDE, currentBooking.getPaymentLatitude());
        map.put(Const.Params.LONGITUDE, currentBooking.getPaymentLongitude());
        map.put(Const.Params.CITY1, currentBooking.getCity1());
        map.put(Const.Params.CITY2, currentBooking.getCity2());
        map.put(Const.Params.CITY3, currentBooking.getCity3());
        map.put(Const.Params.CITY_CODE, currentBooking.getCityCode());
        map.put(Const.Params.TYPE, Const.Type.USER);
        if (btnPayNow.getVisibility() == View.VISIBLE) {
            map.put(Const.Params.CITY_ID, currentBooking.getCartCityId());
        } else {
            map.put(Const.Params.CITY_ID, "");
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<PaymentGatewayResponse> responseCall = apiInterface.getPaymentGateway(map);
        responseCall.enqueue(new Callback<PaymentGatewayResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentGatewayResponse> call, @NonNull Response<PaymentGatewayResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        paymentGateways = new ArrayList<>();
                        switchIsWalletUse.setChecked(response.body().isUseWallet());
                        currentBooking.setCurrencyCode(response.body().getWalletCurrencyCode());
                        currentBooking.setCashPaymentMode(response.body().isCashPaymentMode());
                        if (currentBooking.isCashPaymentMode()) {
                            PaymentGateway paymentGateway = new PaymentGateway();
                            paymentGateway.setName(getResources().getString(R.string.text_cash));
                            paymentGateway.setId(Const.Payment.CASH);
                            paymentGateway.setPaymentModeCash(true);
                            paymentGateway.setPaymentKey("");
                            paymentGateway.setPaymentKeyId("");
                            paymentGateways.add(paymentGateway);
                        }
                        if (response.body().getPaymentGateway() != null) {
                            paymentGateways.addAll(response.body().getPaymentGateway());
                        }
                        initTabLayout(viewPager);
                        setWalletAmount(response.body().getWalletAmount(), response.body().getWalletCurrencyCode());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentGatewayResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PAYMENT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void initTabLayout(ViewPager viewPager) {
        if (!paymentGateways.isEmpty()) {
            viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());

            for (PaymentGateway paymentGateway : paymentGateways) {
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.CASH) && isComingFromCheckout) {
                    viewPagerAdapter.addFragment(new CashFragment(), getResources().getString(R.string.text_cash));
                }
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.STRIPE)) {
                    viewPagerAdapter.addFragment(new StripeFragment(), paymentGateway.getName());
                    stripeKeyId = paymentGateway.getPaymentKeyId();
                    initStripePayment();
                }
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.PAYSTACK)) {
                    viewPagerAdapter.addFragment(new PaystackFragment(), paymentGateway.getName());
                }
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.PAY_PAL)) {
                    viewPagerAdapter.addFragment(new PayPalFragment(), paymentGateway.getName());
                }
            }
            viewPager.setAdapter(viewPagerAdapter);
            tabLayout.setupWithViewPager(viewPager);
            ViewGroup tabStrip = (ViewGroup) tabLayout.getChildAt(0);
            tabLayout.setSelectedTabIndicator(null);
            for (int i = 0; i < tabStrip.getChildCount(); i++) {
                View tabView = tabStrip.getChildAt(i);
                if (tabView != null) {
                    LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) tabView.getLayoutParams();
                    layoutParams.rightMargin = getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding);
                    int paddingStart = tabView.getPaddingStart();
                    int paddingTop = tabView.getPaddingTop();
                    int paddingEnd = tabView.getPaddingEnd();
                    int paddingBottom = tabView.getPaddingBottom();
                    Drawable drawable = AppCompatResources.getDrawable(this, R.drawable.shape_custom_button);
                    drawable.setTint(AppColor.COLOR_THEME);
                    Drawable drawable2 = AppCompatResources.getDrawable(this, R.drawable.shape_custom_button_stroke);
                    StateListDrawable stateListDrawable = new StateListDrawable();
                    stateListDrawable.addState(new int[]{android.R.attr.state_selected}, drawable);
                    stateListDrawable.addState(StateSet.NOTHING, drawable2);
                    ViewCompat.setBackground(tabView, stateListDrawable);
                    ViewCompat.setPaddingRelative(tabView, paddingStart, paddingTop, paddingEnd, paddingBottom);
                }
            }
        }
    }

    private void getExtraData() {
        if (getIntent() != null) {
            isComingFromCheckout = getIntent().getExtras().getBoolean(Const.Tag.PAYMENT_ACTIVITY);
            if (isComingFromCheckout) {
                btnPayNow.setVisibility(View.VISIBLE);
                deliveryType = getIntent().getExtras().getInt(Const.Params.DELIVERY_TYPE, Const.DeliveryType.STORE);
                isShowBringChange = getIntent().getExtras().getBoolean(Const.Params.IS_BRING_CHANGE);
            } else {
                btnPayNow.setVisibility(View.GONE);
            }
        }
    }

    /**
     * this method called a webservice fro make payment for delivery order
     *
     * @param isCash isCash
     */
    private void payOrderPayment(boolean isCash) {
        isPaymentForWallet = false;
        if (gatewayItem != null) {
            Utils.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
            map.put(Const.Params.IS_PAYMENT_MODE_CASH, gatewayItem.isPaymentModeCash());
            map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
            map.put(Const.Params.ORDER_PAYMENT_ID, currentBooking.getOrderPaymentId());
            map.put(Const.Params.DELIVERY_TYPE, deliveryType);
            if (deliveryType == Const.DeliveryType.COURIER) {
                map.put(Const.Params.STORE_DELIVERY_ID, CurrentBooking.getInstance().getSelectedDeliveryId());
            }

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<PaymentResponse> responseCall = apiInterface.payOrderPayment(map);
            responseCall.enqueue(new Callback<PaymentResponse>() {
                @Override
                public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                    if (parseContent.isSuccessful(response)) {
                        if (Objects.requireNonNull(response.body()).isSuccess()) {
                            if (response.body().isPaymentPaid()) {
                                Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                                createOrder(deliveryType, "", isCash);
                            } else if (!TextUtils.isEmpty(response.body().getClientSecret()) && gatewayItem.getId().equals(Const.Payment.STRIPE)) {
                                ConfirmPaymentIntentParams paymentIntentParams = ConfirmPaymentIntentParams.createWithPaymentMethodId(response.body().getPaymentMethod(), response.body().getClientSecret());
                                stripe.confirmPayment(PaymentActivity.this, paymentIntentParams);
                            } else {
                                Utils.hideCustomProgressDialog();
                                Utils.showToast(getResources().getString(R.string.msg_payment_flied), PaymentActivity.this);
                            }
                        } else {
                            Utils.hideCustomProgressDialog();
                            if (TextUtils.isEmpty(response.body().getRequiredParam())) {
                                if (!TextUtils.isEmpty(response.body().getError())) {
                                    Utils.showToast(response.body().getError(), PaymentActivity.this);
                                } else {
                                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                                }
                            } else {
                                openVerificationDialog(response.body().getRequiredParam(), response.body().getReference());
                            }
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(Const.Tag.PAYMENT_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
    }

    /**
     * this method called a webservice for create delivery order
     */
    private void createOrder(int deliveryType, String paymentIntentId, boolean isCash) {
        Utils.showCustomProgressDialog(this, false);

        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getSessionToken()));
        hashMap.put(Const.Params.USER_ID, ApiClient.makeTextRequestBody(preferenceHelper.getUserId()));
        hashMap.put(Const.Params.CART_ID, ApiClient.makeTextRequestBody(currentBooking.getCartId()));
        hashMap.put(Const.Params.DELIVERY_TYPE, ApiClient.makeTextRequestBody(deliveryType));
        hashMap.put(Const.Params.PAYMENT_INTENT_ID, ApiClient.makeTextRequestBody(paymentIntentId));
        hashMap.put(Const.Params.ORDER_PAYMENT_ID, ApiClient.makeTextRequestBody(currentBooking.getOrderPaymentId()));
        if (isCash) {
            hashMap.put(Const.Params.IS_ALLOW_CONTACT_LESS_DELIVERY, ApiClient.makeTextRequestBody(false));
        } else {
            hashMap.put(Const.Params.IS_ALLOW_CONTACT_LESS_DELIVERY, ApiClient.makeTextRequestBody(currentBooking.isAllowContactLessDelivery()));
        }
        if (Const.DeliveryType.COURIER == deliveryType) {
            hashMap.put(Const.Params.VEHICLE_ID, ApiClient.makeTextRequestBody(currentBooking.getVehicleId()));
        }

        if (currentBooking.isFutureOrder()) {
            hashMap.put(Const.Params.IS_SCHEDULE_ORDER, ApiClient.makeTextRequestBody(currentBooking.isFutureOrder()));
            if (currentBooking.getSchedule().isDeliverySlotSelect()) {
                hashMap.put(Const.Params.ORDER_START_AT, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli()));
                hashMap.put(Const.Params.ORDER_START_AT2, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli()));
                if (currentBooking.isTableBooking()) {
                    hashMap.put(Const.Params.TABLE_ID, ApiClient.makeTextRequestBody(currentBooking.getTableId()));
                }
            } else {
                hashMap.put(Const.Params.ORDER_START_AT, ApiClient.makeTextRequestBody(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli()));
            }
        }

        hashMap.put(Const.Params.IS_BRING_CHANGE, ApiClient.makeTextRequestBody(isBringChange));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        if (Const.DeliveryType.COURIER == deliveryType) {
            responseCall = apiInterface.createOrder(hashMap, ApiClient.addMultipleImage(CurrentBooking.getInstance().getCourierItems()));
        } else {
            responseCall = apiInterface.createOrder(hashMap, null);
        }
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                        preferenceHelper.putAndroidId(Utils.generateRandomString());
                        currentBooking.clearCart();
                        currentBooking.setSchedule(null);
                        goToThankYouActivity();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PAYMENT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setSelectedPaymentGateway(String paymentName) {
        for (PaymentGateway gatewayItem : paymentGateways) {
            if (TextUtils.equals(gatewayItem.getName(), paymentName)) {
                this.gatewayItem = gatewayItem;
                return;
            }
        }
    }

    private void selectPaymentGatewayForAddWalletAmount(String amount) {
        if (gatewayItem != null) {
            if (!Utils.isDecimalAndGraterThenZero(amount)) {
                Utils.showToast(getResources().getString(R.string.msg_plz_enter_valid_amount), this);

            } else {
                addWalletAmount = Double.parseDouble(amount);
                switch (gatewayItem.getId()) {
                    case Const.Payment.STRIPE:
                        StripeFragment stripeFragment = (StripeFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                        stripeFragment.addWalletAmount();
                        break;
                    case Const.Payment.PAYSTACK:
                        PaystackFragment paystackFragment = (PaystackFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                        paystackFragment.addWalletAmount();
                        break;
                    case Const.Payment.PAY_PAL:
                       /* PayPalFragment payPalFragment = (PayPalFragment) viewPagerAdapter.getItem
                                (tabLayout.getSelectedTabPosition());
                        payPalFragment.payWithPayPal(Const.PayPal.REQUEST_CODE_WALLET_PAYMENT,
                                Double.valueOf(etWalletAmount.getText().toString()));*/
                        break;
                    case Const.Payment.PAY_U_MONEY:
                        break;
                    case Const.Payment.CASH:
                        Utils.showToast(getResources().getString(R.string.msg_plz_select_other_payment_gateway), this);
                        break;
                    default:
                        break;
                }
            }
        }
    }

    private void setWalletAmount(double amount, String currency) {
        preferenceHelper.putWalletAmount((float) amount);
        tvWalletAmount.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(amount), currency));
        switchIsWalletUse.setEnabled(amount > 0);
        setMessageAsParPayment(switchIsWalletUse.isChecked() && amount > 0, amount, currentBooking.getTotalInvoiceAmount());
    }

    private void checkPaymentGatewayForPayOrder() {
        if (gatewayItem != null) {
            switch (gatewayItem.getId()) {
                case Const.Payment.CASH:
                    payOrderPayment(true);
                    break;
                case Const.Payment.STRIPE:
                    StripeFragment stripeFragment = (StripeFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                    if (stripeFragment.cardList.isEmpty()) {
                        Utils.showToast(getResources().getString(R.string.msg_plz_add_card_first), this);
                    } else if (!selectCard.getPaymentId().equals(gatewayItem.getId())) {
                        Utils.showToast(getResources().getString(R.string.error_select_card_first), this);
                    } else {
                        payOrderPayment(false);
                    }
                    break;
                case Const.Payment.PAYSTACK:
                    PaystackFragment paystackFragment = (PaystackFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                    if (paystackFragment.cardList.isEmpty()) {
                        Utils.showToast(getResources().getString(R.string.msg_plz_add_card_first), this);
                    } else if (!selectCard.getPaymentId().equals(gatewayItem.getId())) {
                        Utils.showToast(getResources().getString(R.string.error_select_card_first), this);
                    } else {
                        payOrderPayment(false);
                    }
                    break;
                case Const.Payment.PAY_PAL:
                   /* PayPalFragment payPalFragment = (PayPalFragment) viewPagerAdapter.getItem
                            (tabLayout.getSelectedTabPosition());
                    payPalFragment.payWithPayPal(Const.PayPal.REQUEST_CODE_ORDER_PAYMENT,
                            currentBooking.getTotalInvoiceAmount());*/
                    break;
                case Const.Payment.PAY_U_MONEY:
                    break;
                default:
                    // do with default
                    break;
            }
        }
    }

    private void goToWalletHistoryActivity() {
        Intent intent = new Intent(this, WalletHistoryActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToThankYouActivity() {
        ThankYouFragment thankYouFragment = new ThankYouFragment();
        thankYouFragment.show(getSupportFragmentManager(), thankYouFragment.getTag());
    }

    @SuppressLint("StringFormatInvalid")
    private void setMessageAsParPayment(boolean isWalletUsed, double walletAmount, double totalOrderInvoiceAmount) {
        String payMessage = "", payAmount;
        double youPaid = totalOrderInvoiceAmount - walletAmount;
        double remainPay;
        if (isWalletUsed) {
            payMessage = getResources().getString(R.string.text_pay_amount_from_wallet, currentBooking.getCurrency() + parseContent.decimalTwoDigitFormat.format(youPaid > 0 ? totalOrderInvoiceAmount - youPaid : totalOrderInvoiceAmount));
            remainPay = youPaid > 0 ? youPaid : 0;
            payAmount = currentBooking.getCurrency() + parseContent.decimalTwoDigitFormat.format(remainPay);
        } else {
            remainPay = totalOrderInvoiceAmount;
            payAmount = currentBooking.getCurrency() + parseContent.decimalTwoDigitFormat.format(remainPay);
        }

        if (!TextUtils.isEmpty(payMessage) && isComingFromCheckout) {
            tvPayMessage.setText(payMessage);
            tvPayMessage.setVisibility(View.VISIBLE);
        } else {
            tvPayMessage.setVisibility(View.GONE);
        }

        tvPayTotal.setText(payAmount);

        if (tabLayout != null && tabLayout.getTabCount() > 0 && TextUtils.equals(tabLayout.getTabAt(0).getText(), getResources().getString(R.string.text_cash))) {
            CashFragment cashFragment = (CashFragment) viewPagerAdapter.getItem(0);
            cashFragment.setPayCashMessage(remainPay);
        }
    }

    private void saveState(Bundle state) {
        if (state != null) {
            state.putString("stripeKeyId", stripeKeyId);
        }
    }

    private void restoreState(Bundle state) {
        if (state != null) {
            stripeKeyId = state.getString("stripeKeyId");
        }
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        saveState(outState);
        super.onSaveInstanceState(outState);
    }

    private void openAddWalletDialog() {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_add_wallet_amount), "", getResources().getString(R.string.text_submit), "", getResources().getString(R.string.text_add_wallet_amount), false, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, false) {
            @Override
            public void onClickLeftButton() {
                customDialogVerification.dismiss();
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                if (Utils.isDecimalAndGraterThenZero(etDialogEditTextTwo.getText().toString())) {
                    selectPaymentGatewayForAddWalletAmount(etDialogEditTextTwo.getText().toString());
                    dismiss();
                } else {
                    etDialogEditTextTwo.setError(getResources().getString(R.string.msg_plz_enter_valid_amount));
                }
            }

            @Override
            public void resendOtp() {

            }
        };
        customDialogVerification.show();

        customDialogVerification.setOnDismissListener(dialog -> getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN));
    }

    private void openVerificationDialog(String requiredParam, String reference) {
        DialogVerifyPayment verifyDialog = new DialogVerifyPayment(this, requiredParam, reference) {

            @Override
            public void doWithEnable(HashMap<String, Object> map) {
                dismiss();
                sendPayStackRequiredDetails(map);
            }

            @Override
            public void doWithDisable() {
                dismiss();
            }
        };
        verifyDialog.show();
    }

    private void sendPayStackRequiredDetails(HashMap<String, Object> map) {
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
        if (isPaymentForWallet) {
            map.put(Const.Params.AMOUNT, addWalletAmount);
        } else {
            map.put(Const.Params.ORDER_PAYMENT_ID, currentBooking.getOrderPaymentId());
        }
        Utils.showCustomProgressDialog(this, false);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).sendPayStackRequiredDetails(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (isPaymentForWallet) {
                            Utils.hideCustomProgressDialog();
                            setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                            Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                        } else {
                            Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
                            createOrder(deliveryType, "", false);
                        }
                    } else {
                        if (TextUtils.isEmpty(response.body().getRequiredParam())) {
                            if (!TextUtils.isEmpty(response.body().getError())) {
                                Utils.showToast(response.body().getError(), PaymentActivity.this);
                            } else if (!TextUtils.isEmpty(response.body().getErrorMessage())) {
                                Utils.showToast(response.body().getErrorMessage(), PaymentActivity.this);
                            } else {
                                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), PaymentActivity.this);
                            }
                        } else {
                            openVerificationDialog(response.body().getRequiredParam(), response.body().getReference());
                        }
                    }
                }

            }

            @Override
            public void onFailure(@NonNull Call<PaymentResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(FeedbackFragment.class.getSimpleName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }
}