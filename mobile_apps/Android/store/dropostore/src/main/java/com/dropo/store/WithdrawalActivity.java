package com.dropo.store;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Menu;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.adapter.BankSpinnerAdapter;
import com.dropo.store.models.datamodel.BankDetail;
import com.dropo.store.models.datamodel.Withdrawal;
import com.dropo.store.models.responsemodel.BankDetailResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WithdrawalActivity extends BaseActivity {

    public static final String TAG = WithdrawalActivity.class.getName();
    private ArrayList<BankDetail> bankDetailArrayList;
    private RadioButton rbBankAccount;
    private RadioGroup radioGroup2;
    private CustomInputEditText etAmount, etDescription;
    private Spinner spinnerBank;
    private CustomTextView tvAddBankAccount;
    private BankSpinnerAdapter bankSpinnerAdapter;
    private LinearLayout llSelectBank;
    private boolean isPaymentModeCash;
    private CustomButton btnWithdrawal;
    private BankDetail bankDetail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_withdrawal);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(WithdrawalActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_withdrawal));
        rbBankAccount = findViewById(R.id.rbBankAccount);
        radioGroup2 = findViewById(R.id.radioGroup2);
        etAmount = findViewById(R.id.etAmount);
        etDescription = findViewById(R.id.etDescription);
        spinnerBank = findViewById(R.id.spinnerBank);
        llSelectBank = findViewById(R.id.llSelectBank);
        btnWithdrawal = findViewById(R.id.btnWithdrawal);
        tvAddBankAccount = findViewById(R.id.tvAddBankAccount);
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

        initSpinnerBank();
        getBankDetail();
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
        if (v.getId() == R.id.btnWithdrawal) {
            if (isValidate()) {
                createWithdrawalRequest();
            }
        }
    }

    private void initSpinnerBank() {
        bankDetailArrayList = new ArrayList<>();
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

    protected boolean isValidate() {
        String msg = null;

        if (!Utilities.isDecimalAndGraterThenZero(etAmount.getText().toString())) {
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
            Utilities.showToast(WithdrawalActivity.this, msg);
        }
        return TextUtils.isEmpty(msg);
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
            @Override
            public void onResponse(@NonNull Call<BankDetailResponse> call, @NonNull Response<BankDetailResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        bankDetailArrayList.clear();
                        bankDetailArrayList.addAll(response.body().getBankDetail());
                        bankSpinnerAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(WithdrawalActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                    updateUiBankAccount(bankDetailArrayList.isEmpty());
                }
            }

            @Override
            public void onFailure(@NonNull Call<BankDetailResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });

    }

    private void createWithdrawalRequest() {
        Utilities.showCustomProgressDialog(this, false);
        final Withdrawal withdrawal = new Withdrawal();
        withdrawal.setProviderId(preferenceHelper.getStoreId());
        withdrawal.setServerToken(preferenceHelper.getServerToken());
        withdrawal.setBankDetail(bankDetail);
        withdrawal.setIsPaymentModeCash(isPaymentModeCash);
        withdrawal.setDescriptionForRequestWalletAmount(etDescription.getText().toString().trim());
        withdrawal.setType(Constant.TYPE_STORE);
        withdrawal.setRequestedWalletAmount(Double.parseDouble(etAmount.getText().toString()));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.createWithdrawalRequest(ApiClient.makeGSONRequestBody(withdrawal));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        ParseContent.getInstance().showMessage(WithdrawalActivity.this, response.body().getStatusPhrase());
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(WithdrawalActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void updateUiBankAccount(boolean isUpdate) {
        if (isUpdate) {
            spinnerBank.setVisibility(View.GONE);
            tvAddBankAccount.setVisibility(View.VISIBLE);
            tvAddBankAccount.setOnClickListener(v -> {
                Intent intent = new Intent(WithdrawalActivity.this, AddBankDetailActivity.class);
                startActivityForResult(intent, Constant.REQUEST_UPDATE_BANK_DETAIL);
            });
        } else {
            spinnerBank.setVisibility(View.VISIBLE);
            tvAddBankAccount.setVisibility(View.GONE);
            tvAddBankAccount.setOnClickListener(null);
        }
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
}