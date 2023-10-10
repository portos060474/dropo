package com.dropo.provider;

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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.dropo.provider.adapter.ViewPagerAdapter;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.DialogVerifyPayment;
import com.dropo.provider.fragments.FeedbackFragment;
import com.dropo.provider.fragments.PayPalFragment;
import com.dropo.provider.fragments.PayStackFragment;
import com.dropo.provider.fragments.StripeFragment;
import com.dropo.provider.models.datamodels.Card;
import com.dropo.provider.models.datamodels.PaymentGateway;
import com.dropo.provider.models.responsemodels.PaymentGatewayResponse;
import com.dropo.provider.models.responsemodels.PaymentResponse;
import com.dropo.provider.models.responsemodels.WalletResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;
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

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PaymentActivity extends BaseAppCompatActivity {
    public static final String TAG = PaymentActivity.class.getName();

    public ArrayList<PaymentGateway> paymentGateways;
    public PaymentGateway gatewayItem;
    public String stripeKeyId;
    public Card selectCard;
    private CardView ivWithdrawal;
    private CustomFontTextView tvWalletAmount;
    private ImageView tvAddWalletAmount;
    private ViewPagerAdapter viewPagerAdapter;
    private TabLayout tabLayout;
    private ViewPager viewPager;
    private Stripe stripe;
    private Double addWalletAmount;
    private CustomDialogVerification customDialogVerification;
    private TextView tvTagPayment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);
        initToolBar();
        setToolbarRightIcon(R.drawable.ic_history, v -> goToWalletTransaction());
        setTitleOnToolBar(getResources().getString(R.string.text_payments));
        initViewById();
        setViewListener();
        getPaymentGateWays();
    }

    private void initStripePayment() {
        final PaymentAuthConfig.Stripe3ds2UiCustomization uiCustomization = new PaymentAuthConfig.Stripe3ds2UiCustomization.Builder().build();
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
        ivWithdrawal = findViewById(R.id.ivWithdrawal);
        tvWalletAmount = findViewById(R.id.tvWalletAmount);
        tabLayout = findViewById(R.id.paymentTabsLayout);
        viewPager = findViewById(R.id.paymentViewpager);
        tvAddWalletAmount = findViewById(R.id.tvAddWalletAmount);
        tvTagPayment = findViewById(R.id.tvTagPayment);
    }

    @Override
    protected void setViewListener() {
        ivWithdrawal.setOnClickListener(this);
        tvAddWalletAmount.setOnClickListener(this);
        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                setSelectedPaymentGateway(tab.getText().toString());
                Fragment paymentFragments = viewPagerAdapter.getItem(tab.getPosition());
                if (paymentFragments instanceof StripeFragment) {
                    ((StripeFragment) paymentFragments).notifyCardData();
                } else if (paymentFragments instanceof PayStackFragment) {
                    ((PayStackFragment) paymentFragments).notifyCardData();
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
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.ivWithdrawal) {
            goToWithdrawalActivity();
        } else if (id == R.id.tvAddWalletAmount) {
            openAddWalletDialog();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void goToWithdrawalActivity() {
        Intent intent = new Intent(this, WithdrawalActivity.class);
        if (paymentGateways != null) {
            intent.putParcelableArrayListExtra(Const.BUNDLE, paymentGateways);
        }
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToWalletTransaction() {
        Intent intent = new Intent(this, WalletTransactionActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void initTabLayout(ViewPager viewPager) {
        if (!paymentGateways.isEmpty()) {
            viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());

            for (PaymentGateway paymentGateway : paymentGateways) {
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.STRIPE)) {
                    viewPagerAdapter.addFragment(new StripeFragment(), paymentGateway.getName());
                    stripeKeyId = paymentGateway.getPaymentKeyId();
                    tvTagPayment.setText(paymentGateway.getName());
                    initStripePayment();
                }
                if (TextUtils.equals(paymentGateway.getId(), Const.Payment.PAYSTACK)) {
                    viewPagerAdapter.addFragment(new PayStackFragment(), paymentGateway.getName());
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

    /**
     * this method called a webservice to get All Payment Gateway witch is available from admin
     * panel
     */
    private void getPaymentGateWays() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.CITY_ID, preferenceHelper.getCityId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<PaymentGatewayResponse> responseCall = apiInterface.getPaymentGateway(map);
        responseCall.enqueue(new Callback<PaymentGatewayResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentGatewayResponse> call, @NonNull Response<PaymentGatewayResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        paymentGateways = new ArrayList<>();
                        if (response.body().getPaymentGateway() != null) {
                            paymentGateways.addAll(response.body().getPaymentGateway());
                        } else {
                            tvTagPayment.setVisibility(View.GONE);
                        }
                        if (paymentGateways.size() == 0) {
                            tvTagPayment.setVisibility(View.GONE);
                        }
                        if (paymentGateways.size() > 1) {
                            tvTagPayment.setVisibility(View.GONE);
                            tabLayout.setVisibility(View.VISIBLE);
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
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setSelectedPaymentGateway(String paymentName) {
        for (PaymentGateway gatewayItem : paymentGateways) {
            if (TextUtils.equals(gatewayItem.getName(), paymentName)) {
                this.gatewayItem = gatewayItem;
                tvTagPayment.setText(gatewayItem.getName());
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
                        PayStackFragment paystackFragment = (PayStackFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                        paystackFragment.addWalletAmount();
                        break;
                    case Const.Payment.PAY_PAL:
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
        } else {
            Utils.showToast(getResources().getString(R.string.text_select_payment_method), this);
        }
    }

    private void setWalletAmount(double amount, String currency) {
        tvWalletAmount.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(amount), currency));
    }

    /**
     * this method called a webservice to get client secret and initiate payment Intent for
     * delivery order or add wallet
     */
    public void createStripePaymentIntent() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.USER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
        map.put(Const.Params.AMOUNT, addWalletAmount);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripPaymentIntentWallet(map);
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

    /**
     * this method called a webservice for  add wallet amount
     */
    public void addWalletAmount(String paymentId, String paymentIntentId) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.PAYMENT_ID, paymentId);
        map.put(Const.Params.PAYMENT_INTENT_ID, paymentIntentId);
        map.put(Const.Params.LAST_FOUR, selectCard.getLastFour());
        map.put(Const.Params.WALLET, addWalletAmount);

        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<WalletResponse> responseCall = apiInterface.getAddWalletAmount(map);
        responseCall.enqueue(new Callback<WalletResponse>() {
            @Override
            public void onResponse(@NonNull Call<WalletResponse> call, @NonNull Response<WalletResponse> response) {
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
            public void onFailure(@NonNull Call<WalletResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
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
                        addWalletAmount(gatewayItem.getId(), paymentIntent.getId());
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
                    } else {
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

    private void openAddWalletDialog() {
        if (customDialogVerification != null && customDialogVerification.isShowing()) {
            return;
        }

        customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_add_wallet_amount), "", getResources().getString(R.string.text_submit), "", getResources().getString(R.string.text_add_amount), false, InputType.TYPE_CLASS_NUMBER, InputType.TYPE_CLASS_NUMBER, false) {
            @Override
            protected void resendOtp() {

            }

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
        map.put(Const.Params.USER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.PAYMENT_ID, gatewayItem.getId());
        map.put(Const.Params.AMOUNT, addWalletAmount);

        Utils.showCustomProgressDialog(this, false);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).sendPayStackRequiredDetails(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(@NonNull Call<PaymentResponse> call, @NonNull Response<PaymentResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                        Utils.showMessageToast(response.body().getStatusPhrase(), PaymentActivity.this);
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