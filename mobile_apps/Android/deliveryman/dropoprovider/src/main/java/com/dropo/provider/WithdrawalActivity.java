package com.dropo.provider;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;

import androidx.annotation.NonNull;

import com.dropo.provider.adapter.BankSpinnerAdapter;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.fragments.AddBankDetailFragment;
import com.dropo.provider.models.datamodels.BankDetail;
import com.dropo.provider.models.datamodels.PaymentGateway;
import com.dropo.provider.models.datamodels.Withdrawal;
import com.dropo.provider.models.responsemodels.BankDetailResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;

import java.util.ArrayList;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WithdrawalActivity extends BaseAppCompatActivity {

    public ArrayList<PaymentGateway> paymentGateways = new ArrayList<>();
    private ArrayList<BankDetail> bankDetailArrayList;
    private RadioButton rbBankAccount;
    private RadioGroup radioGroup2;
    private CustomFontEditTextView etAmount, etDescription;
    private Spinner spinnerBank;
    private CustomFontTextView tvAddBankAccount;
    private BankSpinnerAdapter bankSpinnerAdapter;
    private LinearLayout llSelectBank;
    private boolean isPaymentModeCash;
    private CustomFontButton btnWithdrawal;
    private BankDetail bankDetail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_withdrawal);
        bankDetailArrayList = new ArrayList<>();
        if (getIntent().getParcelableArrayListExtra(Const.BUNDLE) != null) {
            paymentGateways.addAll(getIntent().getParcelableArrayListExtra(Const.BUNDLE));
        }
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_withdrawal));
        initViewById();
        setViewListener();
        initSpinnerBank();
        getBankDetail();
    }

    @Override
    protected boolean isValidate() {
        String msg = null;

        if (!Utils.isDecimalAndGraterThenZero(etAmount.getText().toString())) {
            msg = (getResources().getString(R.string.msg_plz_enter_valid_amount));
            etAmount.setError(msg);
            etAmount.requestFocus();
        } else if (TextUtils.isEmpty(etDescription.getText().toString())) {
            msg = (getResources().getString(R.string.msg_enter_description));
            etDescription.setError(msg);
            etDescription.requestFocus();
        } else if (isPaymentModeCash) {
            return true;
        } else if (bankDetail == null) {
            msg = getResources().getString(R.string.msg_plz_add_bank_detail);
            Utils.showToast(msg, WithdrawalActivity.this);
        }
        return TextUtils.isEmpty(msg);
    }

    @Override
    protected void initViewById() {
        rbBankAccount = findViewById(R.id.rbBankAccount);
        radioGroup2 = findViewById(R.id.radioGroup2);
        etAmount = findViewById(R.id.etAmount);
        etDescription = findViewById(R.id.etDescription);
        spinnerBank = findViewById(R.id.spinnerBank);
        llSelectBank = findViewById(R.id.llSelectBank);
        btnWithdrawal = findViewById(R.id.btnWithdrawal);
        tvAddBankAccount = findViewById(R.id.tvAddBankAccount);
    }

    @Override
    protected void setViewListener() {
        radioGroup2.setOnCheckedChangeListener((radioGroup, checkedId) -> {
            if (checkedId == R.id.rbBankAccount) {
                isPaymentModeCash = false;
                llSelectBank.setVisibility(View.VISIBLE);
            } else if (checkedId == R.id.rbCash) {
                isPaymentModeCash = true;
                llSelectBank.setVisibility(View.GONE);
            }
        });
        rbBankAccount.setChecked(true);
        btnWithdrawal.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btnWithdrawal) {
            if (isValidate()) {
                createWithdrawalRequest();
            }
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
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
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        bankDetailArrayList.clear();
                        bankDetailArrayList.addAll(response.body().getBankDetail());
                        bankSpinnerAdapter.notifyDataSetChanged();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), WithdrawalActivity.this);
                    }
                    updateUiBankAccount(bankDetailArrayList.isEmpty());
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initSpinnerBank() {
        bankSpinnerAdapter = new BankSpinnerAdapter(this, bankDetailArrayList);
        spinnerBank.setAdapter(bankSpinnerAdapter);
        spinnerBank.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                bankDetail = bankDetailArrayList.get(position);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
    }

    private void createWithdrawalRequest() {
        Utils.showCustomProgressDialog(this, false);
        final Withdrawal withdrawal = new Withdrawal();
        withdrawal.setProviderId(preferenceHelper.getProviderId());
        withdrawal.setServerToken(preferenceHelper.getSessionToken());
        withdrawal.setBankDetail(bankDetail);
        withdrawal.setIsPaymentModeCash(isPaymentModeCash);
        withdrawal.setDescriptionForRequestWalletAmount(etDescription.getText().toString().trim());
        withdrawal.setType(Const.TYPE_PROVIDER);
        withdrawal.setRequestedWalletAmount(Double.parseDouble(etAmount.getText().toString()));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.createWithdrawalRequest(ApiClient.makeGSONRequestBody(withdrawal));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        onBackPressed();
                        Utils.showMessageToast(response.body().getStatusPhrase(), WithdrawalActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), WithdrawalActivity.this);
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

    private void updateUiBankAccount(boolean isUpdate) {
        if (isUpdate) {
            spinnerBank.setVisibility(View.GONE);
            tvAddBankAccount.setVisibility(View.VISIBLE);
            tvAddBankAccount.setOnClickListener(v -> {
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
            });
        } else {
            spinnerBank.setVisibility(View.VISIBLE);
            tvAddBankAccount.setVisibility(View.GONE);
            tvAddBankAccount.setOnClickListener(null);
        }
    }
}