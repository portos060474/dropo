package com.dropo.provider;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.adapter.BankDetailAdapter;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFloatingButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.fragments.AddBankDetailFragment;
import com.dropo.provider.models.datamodels.BankDetail;
import com.dropo.provider.models.datamodels.PaymentGateway;
import com.dropo.provider.models.responsemodels.BankDetailResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.PaymentGatewayResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class BankDetailActivity extends BaseAppCompatActivity {

    public ArrayList<PaymentGateway> paymentGateways = new ArrayList<>();
    private RecyclerView rcvBankDetail;
    private BankDetailAdapter bankDetailAdapter;
    private ArrayList<BankDetail> bankDetails;
    private CustomFloatingButton floatingBtnAddBankDetail;
    private View llEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bank_details_view);
        bankDetails = new ArrayList<>();
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_bank_detail));
        initViewById();
        setViewListener();
        initRcvBank();
        getBankDetail();
        getPaymentGateWays();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == Const.REQUEST_UPDATE_BANK_DETAIL) {
                getBankDetail();
            }
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvBankDetail = findViewById(R.id.rcvBankDetail);
        floatingBtnAddBankDetail = findViewById(R.id.floatingBtnAddBankDetail);
        llEmpty = findViewById(R.id.llEmpty);
    }

    @Override
    protected void setViewListener() {
        floatingBtnAddBankDetail.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.floatingBtnAddBankDetail) {
            goToAddBankDetailFragment();
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
    public void getBankDetail() {
        Utils.showCustomProgressDialog(this, false);
        final BankDetail bankDetail = new BankDetail();
        bankDetail.setBankHolderId(preferenceHelper.getProviderId());
        bankDetail.setBankHolderType(Const.TYPE_PROVIDER);
        bankDetail.setServerToken(preferenceHelper.getSessionToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<BankDetailResponse> responseCall = apiInterface.getBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<BankDetailResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        bankDetails.clear();
                        bankDetails.addAll(response.body().getBankDetail());
                        bankDetailAdapter.notifyDataSetChanged();
                    }
                    llEmpty.setVisibility(bankDetails.isEmpty() ? View.VISIBLE : View.GONE);
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void goToAddBankDetailFragment() {
        AddBankDetailFragment addBankDetailFragment = new AddBankDetailFragment();
        Bundle bundle = new Bundle();
        for (PaymentGateway paymentGateway : paymentGateways) {
            if (paymentGateway.getId().equals(Const.Payment.STRIPE)) {
                bundle.putParcelable(Const.PAYMENT, paymentGateway);
                break;
            } else if (paymentGateway.getId().equals(Const.Payment.PAYSTACK)) {
                bundle.putParcelable(Const.PAYMENT, paymentGateway);
                break;
            }
        }
        addBankDetailFragment.setArguments(bundle);
        addBankDetailFragment.show(getSupportFragmentManager(), addBankDetailFragment.getTag());
    }

    public void openVerifyAccountDialog(final BankDetail bankDetail) {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            CustomDialogVerification customDialogVerification = new CustomDialogVerification(this, getResources().getString(R.string.text_verify_account), getResources().getString(R.string.msg_enter_password_which_used_in_register), getResources().getString(R.string.text_ok), "", getResources().getString(R.string.text_password), false, InputType.TYPE_CLASS_TEXT, InputType.TYPE_TEXT_VARIATION_PASSWORD, false) {
                @Override
                protected void resendOtp() {

                }

                @Override
                public void onClickLeftButton() {
                    dismiss();

                }

                @Override
                public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                    if (!etDialogEditTextTwo.getText().toString().isEmpty()) {
                        bankDetail.setPassword(etDialogEditTextTwo.getText().toString());
                        deleteBankDetail(bankDetail);
                        dismiss();
                    } else {
                        etDialogEditTextTwo.setError(getString(R.string.msg_enter_password));
                    }
                }
            };
            customDialogVerification.show();
        } else {
            bankDetail.setPassword("");
            deleteBankDetail(bankDetail);
        }
    }

    private void deleteBankDetail(BankDetail bankDetail) {
        Utils.showCustomProgressDialog(this, false);
        bankDetail.setBankDetailId(bankDetail.getId());
        bankDetail.setBankHolderId(preferenceHelper.getProviderId());
        bankDetail.setBankHolderType(Const.TYPE_PROVIDER);
        bankDetail.setSocialId(preferenceHelper.getSocialId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<BankDetailResponse> responseCall = apiInterface.deleteBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<BankDetailResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        bankDetails.clear();
                        bankDetails.addAll(response.body().getBankDetail());
                        bankDetailAdapter.notifyDataSetChanged();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), BankDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void selectBankDetail(final BankDetail bankDetail) {
        Utils.showCustomProgressDialog(this, false);
        bankDetail.setBankDetailId(bankDetail.getId());
        bankDetail.setBankHolderId(preferenceHelper.getProviderId());
        bankDetail.setBankHolderType(Const.TYPE_PROVIDER);
        bankDetail.setSocialId(preferenceHelper.getSocialId());
        bankDetail.setServerToken(preferenceHelper.getSessionToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.selectBankDetail(ApiClient.makeGSONRequestBody(bankDetail));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        for (BankDetail detail : bankDetails) {
                            detail.setSelected(false);
                        }
                        bankDetail.setSelected(true);
                        bankDetailAdapter.notifyDataSetChanged();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), BankDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

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
                        floatingBtnAddBankDetail.setEnabled(true);
                        paymentGateways.clear();
                        if (response.body().getPaymentGateway() != null) {
                            paymentGateways.addAll(response.body().getPaymentGateway());
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), BankDetailActivity.this);
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
}