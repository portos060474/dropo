package com.dropo.store;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.StateSet;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.activity.ComponentActivity;
import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.core.view.ViewCompat;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.dropo.store.R;
import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.component.DialogVerifyPayment;
import com.dropo.store.fragment.PayPalFragment;
import com.dropo.store.fragment.PayStackFragment;
import com.dropo.store.fragment.StripeFragment;
import com.dropo.store.models.datamodel.Card;
import com.dropo.store.models.datamodel.PaymentGateway;
import com.dropo.store.models.responsemodel.PaymentGatewayResponse;
import com.dropo.store.models.responsemodel.PaymentResponse;
import com.dropo.store.models.responsemodel.WalletResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;

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

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PaymentActivity extends BaseActivity {

    public static final String TAG = PaymentActivity.class.getName();
    public List<PaymentGateway> paymentGateways;
    public CustomInputEditText etWalletAmount;
    public PaymentGateway gatewayItem;
    public String stripeKeyId;
    public Card selectCard;
    private CardView ivWithdrawal;
    private CustomTextView tvWalletAmount, tvAddWalletAmount;
    private ViewPagerAdapter viewPagerAdapter;
    private TabLayout tabLayout;
    private ViewPager viewPager;
    private Stripe stripe;
    private TextView tvTagPayment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Utilities.hideSoftKeyboard(PaymentActivity.this);
                onBackPressed();
            }
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_payments));
        ivWithdrawal = findViewById(R.id.ivWithdrawal);
        tvWalletAmount = findViewById(R.id.tvWalletAmount);
        tvTagPayment = findViewById(R.id.tvTagPayment);
        ivWithdrawal.setOnClickListener(this);
        tabLayout = findViewById(R.id.paymentTabsLayout);
        viewPager = findViewById(R.id.paymentViewpager);
        tvAddWalletAmount = findViewById(R.id.tvAddWalletAmount);
        etWalletAmount = findViewById(R.id.etWalletAmount);
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

                // do somethings
            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {
                // do somethings

            }
        });
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
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(true, R.drawable.ic_history_time);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);

        if (item.getItemId() == R.id.ivEditMenu) {
            goToWalletTransaction();
        }

        return true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ivWithdrawal:
                goToWithdrawalActivity();
                break;
            case R.id.tvAddWalletAmount:
                selectPaymentGatewayForAddWalletAmount();
                break;

            default:
                // do with default
                break;
        }
    }

    private void goToWalletTransaction() {
        Intent intent = new Intent(this, WalletTransactionActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void goToWithdrawalActivity() {
        Intent intent = new Intent(this, WithdrawalActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void initTabLayout(ViewPager viewPager) {
        if (!paymentGateways.isEmpty()) {
            viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());

            for (PaymentGateway paymentGateway : paymentGateways) {
                if (TextUtils.equals(paymentGateway.getId(), Constant.Payment.STRIPE)) {
                    tvTagPayment.setText(paymentGateway.getName());
                    viewPagerAdapter.addFragment(new StripeFragment(), paymentGateway.getName());
                    stripeKeyId = paymentGateway.getPaymentKeyId();
                    initStripePayment();
                }
                if (TextUtils.equals(paymentGateway.getId(), Constant.Payment.PAYSTACK)) {
                    viewPagerAdapter.addFragment(new PayStackFragment(), paymentGateway.getName());
                }
                if (TextUtils.equals(paymentGateway.getId(), Constant.Payment.PAY_PAL)) {
                    tvTagPayment.setText(paymentGateway.getName());
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
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.USER_ID, preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(Constant.CITY_ID, preferenceHelper.getCityId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<PaymentGatewayResponse> responseCall = apiInterface.getPaymentGateway(map);
        responseCall.enqueue(new Callback<PaymentGatewayResponse>() {
            @Override
            public void onResponse(Call<PaymentGatewayResponse> call, Response<PaymentGatewayResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        paymentGateways = new ArrayList<>();
                        if (response.body().getPaymentGateway() != null) {
                            paymentGateways.addAll(response.body().getPaymentGateway());
                        }
                        if (paymentGateways.size() > 1) {
                            tvTagPayment.setVisibility(View.GONE);
                            tabLayout.setVisibility(View.VISIBLE);
                        }
                        initTabLayout(viewPager);
                        setWalletAmount(response.body().getWalletAmount(), response.body().getWalletCurrencyCode());
                    } else {
                        ParseContent.getInstance().showErrorMessage(PaymentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(Call<PaymentGatewayResponse> call, Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
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

    private void selectPaymentGatewayForAddWalletAmount() {


        if (gatewayItem != null) {
            if (etWalletAmount.getVisibility() == View.GONE) {
                updateUiForWallet(true);
            } else {

                if (!Utilities.isDecimalAndGraterThenZero(etWalletAmount.getText().toString())) {
                    Utilities.showToast(this, getResources().getString(R.string.msg_plz_enter_valid_amount));
                    return;
                }
                switch (gatewayItem.getId()) {
                    case Constant.Payment.STRIPE:
                        StripeFragment stripeFragment = (StripeFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                        stripeFragment.addWalletAmount();
                        break;
                    case Constant.Payment.PAYSTACK:
                        PayStackFragment paystackFragment = (PayStackFragment) viewPagerAdapter.getItem(tabLayout.getSelectedTabPosition());
                        paystackFragment.addWalletAmount();
                    case Constant.Payment.PAY_PAL:

                        break;
                    case Constant.Payment.PAY_U_MONEY:
                        break;
                    case Constant.Payment.CASH:
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_other_payment_gateway));
                        break;
                    default:
                        // do with default
                        break;
                }
            }
        }
    }


    private void setWalletAmount(double amount, String currency) {
        tvWalletAmount.setText(parseContent.decimalTwoDigitFormat.format(amount) + " " + currency);
    }


    private void updateUiForWallet(boolean isUpdate) {
        if (isUpdate) {
            tvWalletAmount.setVisibility(View.GONE);
            etWalletAmount.setVisibility(View.VISIBLE);
            etWalletAmount.requestFocus();
            tvAddWalletAmount.setText(getResources().getString(R.string.text_submit));
        } else {
            etWalletAmount.getText().clear();
            etWalletAmount.setVisibility(View.GONE);
            tvWalletAmount.setVisibility(View.VISIBLE);
            tvAddWalletAmount.setText(getResources().getString(R.string.text_add));
        }

    }

    /**
     * this method called a webservice to get client secret and initiate payment Intent for
     * delivery order or add wallet
     */
    public void createStripePaymentIntent() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        try {
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            map.put(Constant.USER_ID, preferenceHelper.getStoreId());
            map.put(Constant.TYPE, Constant.Type.STORE);
            map.put(Constant.PAYMENT_ID, gatewayItem.getId());
            map.put(Constant.AMOUNT, Double.parseDouble(etWalletAmount.getText().toString()));
            Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).getStripPaymentIntentWallet(map);
            call.enqueue(new Callback<PaymentResponse>() {
                @Override
                public void onResponse(Call<PaymentResponse> call, Response<PaymentResponse> response) {
                    if (parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            if (gatewayItem.getId().equals(Constant.Payment.STRIPE)) {
                                ConfirmPaymentIntentParams paymentIntentParams = ConfirmPaymentIntentParams.createWithPaymentMethodId(response.body().getPaymentMethod(), response.body().getClientSecret());
                                stripe.confirmPayment((ComponentActivity) PaymentActivity.this, paymentIntentParams);
                            } else if (gatewayItem.getId().equals(Constant.Payment.PAYSTACK)) {
                                Utilities.hideCustomProgressDialog();
                                updateUiForWallet(false);
                                setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                                ParseContent.getInstance().showMessage(PaymentActivity.this, response.body().getStatusPhrase());
                            } else {
                                ParseContent.getInstance().showErrorMessage(PaymentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                            }
                        } else {
                            Utilities.hideCustomProgressDialog();
                            if (TextUtils.isEmpty(response.body().getRequiredParam())) {
                                if (!TextUtils.isEmpty(response.body().getError())) {
                                    Utilities.showToast(PaymentActivity.this, response.body().getError());
                                } else {
                                    ParseContent.getInstance().showErrorMessage(PaymentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                                }
                            } else {
                                openVerificationDialog(response.body().getRequiredParam(), response.body().getReference());
                            }
                        }
                    }

                }

                @Override
                public void onFailure(Call<PaymentResponse> call, Throwable t) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.handleThrowable(TAG, t);
                }
            });
        } catch (NumberFormatException e) {

            etWalletAmount.setError(getResources().getString(R.string.msg_enter_valid_amount));
        }
    }

    /**
     * this method called a webservice for  add wallet amount
     */
    public void addWalletAmount(String paymentId, String paymentIntentId) {
        try {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            map.put(Constant.USER_ID, preferenceHelper.getStoreId());
            map.put(Constant.TYPE, Constant.Type.STORE);
            map.put(Constant.PAYMENT_ID, paymentId);
            map.put(Constant.PAYMENT_INTENT_ID, paymentIntentId);
            map.put(Constant.WALLET, Double.valueOf(etWalletAmount.getText().toString()));
            map.put(Constant.LAST_FOUR, selectCard.getLastFour());
            Utilities.showCustomProgressDialog(this, false);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<WalletResponse> responseCall = apiInterface.getAddWalletAmount(map);
            responseCall.enqueue(new Callback<WalletResponse>() {
                @Override
                public void onResponse(Call<WalletResponse> call, Response<WalletResponse> response) {
                    if (parseContent.isSuccessful(response)) {
                        Utilities.hideCustomProgressDialog();
                        if (response.body().isSuccess()) {
                            updateUiForWallet(false);
                            setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                            ParseContent.getInstance().showMessage(PaymentActivity.this, response.body().getStatusPhrase());
                        } else {
                            ParseContent.getInstance().showErrorMessage(PaymentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }

                @Override
                public void onFailure(Call<WalletResponse> call, Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });

        } catch (NumberFormatException e) {

            etWalletAmount.setError(getResources().getString(R.string.msg_enter_valid_amount));
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (stripe != null) {
            stripe.onPaymentResult(requestCode, data, new ApiResultCallback<PaymentIntentResult>() {
                @Override
                public void onSuccess(@NonNull PaymentIntentResult result) {
                    Utilities.hideCustomProgressDialog();
                    final PaymentIntent paymentIntent = result.getIntent();
                    final PaymentIntent.Status status = paymentIntent.getStatus();
                    if (status == PaymentIntent.Status.Succeeded || status == PaymentIntent.Status.RequiresCapture) {
                        addWalletAmount(gatewayItem.getId(), paymentIntent.getId());
                    } else if (status == PaymentIntent.Status.Canceled) {
                        Utilities.hideCustomProgressDialog();
                        Utilities.showToast(PaymentActivity.this, getString(R.string.error_payment_cancel));
                    } else if (status == PaymentIntent.Status.Processing) {
                        Utilities.hideCustomProgressDialog();
                        Utilities.showToast(PaymentActivity.this, getString(R.string.error_payment_processing));
                    } else if (status == PaymentIntent.Status.RequiresPaymentMethod) {
                        Utilities.hideCustomProgressDialog();
                        Utilities.showToast(PaymentActivity.this, getString(R.string.error_payment_auth));
                    } else if (status == PaymentIntent.Status.RequiresAction || status == PaymentIntent.Status.RequiresConfirmation) {
                        Utilities.hideCustomProgressDialog();
                        Utilities.showToast(PaymentActivity.this, getString(R.string.error_payment_action));
                    } else {
                        Utilities.hideCustomProgressDialog();
                    }

                }

                @Override
                public void onError(@NonNull Exception e) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.showToast(PaymentActivity.this, e.getMessage());
                }
            });
        }
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
                updateUiForWallet(false);
            }
        };
        verifyDialog.show();
    }

    private void sendPayStackRequiredDetails(HashMap<String, Object> map) {
        map.put(Constant.USER_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.TYPE, Constant.TYPE_STORE);
        map.put(Constant.PAYMENT_ID, gatewayItem.getId());
        map.put(Constant.AMOUNT, Double.parseDouble(etWalletAmount.getText().toString()));

        Utilities.showCustomProgressDialog(this, false);
        Call<PaymentResponse> call = ApiClient.getClient().create(ApiInterface.class).sendPayStackRequiredDetails(map);
        call.enqueue(new Callback<PaymentResponse>() {
            @Override
            public void onResponse(Call<PaymentResponse> call, Response<PaymentResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        Utilities.hideCustomProgressDialog();
                        updateUiForWallet(false);
                        setWalletAmount(response.body().getWallet(), response.body().getWalletCurrencyCode());
                        ParseContent.getInstance().showMessage(PaymentActivity.this, response.body().getStatusPhrase());
                    } else {
                        if (TextUtils.isEmpty(response.body().getRequiredParam())) {
                            if (!TextUtils.isEmpty(response.body().getError())) {
                                Utilities.showToast(PaymentActivity.this, response.body().getError());
                            } else if (!TextUtils.isEmpty(response.body().getErrorMessage())) {
                                Utilities.showToast(PaymentActivity.this, response.body().getErrorMessage());
                            } else {
                                ParseContent.getInstance().showErrorMessage(PaymentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                            }
                        } else {
                            openVerificationDialog(response.body().getRequiredParam(), response.body().getReference());
                        }
                    }
                }

            }

            @Override
            public void onFailure(Call<PaymentResponse> call, Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}
