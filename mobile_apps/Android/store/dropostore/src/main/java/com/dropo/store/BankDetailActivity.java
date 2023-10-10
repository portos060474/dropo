package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.BankDetailAdapter;
import com.dropo.store.models.datamodel.BankDetail;
import com.dropo.store.models.datamodel.PaymentGateway;
import com.dropo.store.models.responsemodel.BankDetailResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.PaymentGatewayResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class BankDetailActivity extends BaseActivity {

    public static final String TAG = BankDetailActivity.class.getName();
    public ArrayList<PaymentGateway> paymentGateways = new ArrayList<>();
    private RecyclerView rcvBankDetail;
    private BankDetailAdapter bankDetailAdapter;
    private ArrayList<BankDetail> bankDetails;
    private FloatingActionButton floatingBtnAddBankDetail;
    private BottomSheetDialog dialog;
    private EditText etVerifyPassword;
    private LinearLayout ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bank_detail);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_bank_detail));
        bankDetails = new ArrayList<>();
        rcvBankDetail = findViewById(R.id.rcvBankDetail);
        ivEmpty = findViewById(R.id.ivEmpty);
        floatingBtnAddBankDetail = findViewById(R.id.floatingBtnAddBankDetail);
        floatingBtnAddBankDetail.setOnClickListener(this);
        initRcvBank();
        getBankDetail();
        floatingBtnAddBankDetail.setEnabled(false);
        getPaymentGateWays();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.floatingBtnAddBankDetail) {
            goToAddBankDetailActivity();
        }
    }

    private void initRcvBank() {
        rcvBankDetail.setLayoutManager(new LinearLayoutManager(this));
        bankDetailAdapter = new BankDetailAdapter(this, bankDetails);
        rcvBankDetail.setAdapter(bankDetailAdapter);
    }

    /**
     * this method  call webservice for get bank detail
     */
    private void getBankDetail() {
        Utilities.showCustomProgressDialog(this, false);
        final BankDetail bankDetail = new BankDetail();
        bankDetail.setBankHolderId(preferenceHelper.getStoreId());
        bankDetail.setBankHolderType(Constant.TYPE_STORE);
        bankDetail.setServerToken(preferenceHelper.getServerToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<BankDetailResponse> responseCall = apiInterface.getBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<BankDetailResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        bankDetails.clear();
                        bankDetails.addAll(response.body().getBankDetail());
                        bankDetailAdapter.notifyDataSetChanged();
                    }
                    ivEmpty.setVisibility(bankDetails.isEmpty() ? View.VISIBLE : View.GONE);
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == Constant.REQUEST_UPDATE_BANK_DETAIL) {
                getBankDetail();
            }
        }
    }

    public void goToAddBankDetailActivity() {
        Intent intent = new Intent(this, AddBankDetailActivity.class);
        for (PaymentGateway paymentGateway : paymentGateways) {
            if (paymentGateway.getId().equals(Constant.Payment.STRIPE)) {
                intent.putExtra(Constant.BUNDLE, paymentGateway);
                break;
            } else if (paymentGateway.getId().equals(Constant.Payment.PAYSTACK)) {
                intent.putExtra(Constant.BUNDLE, paymentGateway);
                break;
            }
        }
        startActivityForResult(intent, Constant.REQUEST_UPDATE_BANK_DETAIL);
    }

    public void showVerificationDialog(final BankDetail bankDetail) {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId()) && dialog == null) {
            dialog = new BottomSheetDialog(this);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setContentView(R.layout.dialog_account_verification);
            etVerifyPassword = dialog.findViewById(R.id.etCurrentPassword);

            dialog.findViewById(R.id.btnPositive).setOnClickListener(v -> {
                if (!TextUtils.isEmpty(etVerifyPassword.getText().toString())) {
                    bankDetail.setPassword(etVerifyPassword.getText().toString());
                    deleteBankDetail(bankDetail);
                    dialog.dismiss();
                } else {
                    etVerifyPassword.setError(getString(R.string.msg_empty_password));
                }
            });
            dialog.findViewById(R.id.btnNegative).setOnClickListener(v -> dialog.dismiss());
            dialog.setOnDismissListener(dialog1 -> dialog = null);
            WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
            params.width = WindowManager.LayoutParams.MATCH_PARENT;
            dialog.show();
        } else {
            bankDetail.setPassword("");
            deleteBankDetail(bankDetail);
        }
    }

    private void deleteBankDetail(BankDetail bankDetail) {
        Utilities.showCustomProgressDialog(this, false);
        bankDetail.setBankDetailId(bankDetail.getId());
        bankDetail.setBankHolderId(preferenceHelper.getStoreId());
        bankDetail.setBankHolderType(Constant.TYPE_STORE);
        bankDetail.setSocialId(preferenceHelper.getSocialId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<BankDetailResponse> responseCall = apiInterface.deleteBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<BankDetailResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        bankDetails.clear();
                        bankDetails.addAll(response.body().getBankDetail());
                        bankDetailAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(BankDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void selectBankDetail(final BankDetail bankDetail) {
        Utilities.showCustomProgressDialog(this, false);
        bankDetail.setBankDetailId(bankDetail.getId());
        bankDetail.setBankHolderId(preferenceHelper.getStoreId());
        bankDetail.setBankHolderType(Constant.TYPE_STORE);
        bankDetail.setSocialId(preferenceHelper.getSocialId());
        bankDetail.setServerToken(preferenceHelper.getServerToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.selectBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        for (BankDetail detail : bankDetails) {
                            detail.setSelected(false);
                        }
                        bankDetail.setSelected(true);
                        bankDetailAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(BankDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(BankDetailActivity.class.getSimpleName(), t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

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
            public void onResponse(@NonNull Call<PaymentGatewayResponse> call, @NonNull Response<PaymentGatewayResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        floatingBtnAddBankDetail.setEnabled(true);
                        paymentGateways.clear();
                        if (response.body().getPaymentGateway() != null) {
                            paymentGateways.addAll(response.body().getPaymentGateway());
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(BankDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<PaymentGatewayResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}