package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.widget.TextView;

import com.dropo.store.models.datamodel.WalletRequestDetail;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;

import java.text.ParseException;
import java.util.Date;

public class WalletTransactionDetailActivity extends BaseActivity {

    private TextView tvTransactionDate, tvWithdrawalID, tvTransactionTime;
    private TextView tvWalletRequestAmount, tvApproveByAdmin, tvTotalWalletAmount, tvMode;
    private WalletRequestDetail walletRequestDetail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_trans_detail);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(WalletTransactionDetailActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_wallet_transaction_detail));
        tvTotalWalletAmount = findViewById(R.id.tvTotalWalletAmount);
        tvWalletRequestAmount = findViewById(R.id.tvWalletRequestAmount);
        tvApproveByAdmin = findViewById(R.id.tvApproveByAdmin);
        tvMode = findViewById(R.id.tvMode);
        tvWithdrawalID = findViewById(R.id.tvWithdrawalID);
        tvTransactionDate = findViewById(R.id.tvTransactionDate);
        tvTransactionTime = findViewById(R.id.tvTransactionTime);
        getExtraData();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            walletRequestDetail = getIntent().getExtras().getParcelable(Constant.BUNDLE);
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(walletSate(walletRequestDetail.getWalletStatus()));
            tvApproveByAdmin.setText(String.format("%s %s", ParseContent.getInstance().decimalTwoDigitFormat.format(walletRequestDetail.getApprovedRequestedWalletAmount()), walletRequestDetail.getAdminCurrencyCode()));

            if (Constant.Wallet.WALLET_STATUS_COMPLETED == walletRequestDetail.getWalletStatus()) {
                tvTotalWalletAmount.setText(parseContent.decimalTwoDigitFormat.format(walletRequestDetail.getAfterTotalWalletAmount()));
            } else {
                tvTotalWalletAmount.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(walletRequestDetail.getTotalWalletAmount()), walletRequestDetail.getAdminCurrencyCode()));
            }
            String amount = ParseContent.getInstance().decimalTwoDigitFormat.format(walletRequestDetail.getWalletStatus() == Constant.Wallet.WALLET_STATUS_COMPLETED || walletRequestDetail.getWalletStatus() == Constant.Wallet.WALLET_STATUS_TRANSFERRED ? walletRequestDetail.getApprovedRequestedWalletAmount() : walletRequestDetail.getRequestedWalletAmount()) + " " + walletRequestDetail.getAdminCurrencyCode();
            tvWalletRequestAmount.setText(amount);
            tvWithdrawalID.setText(String.format("%s %s", getResources().getString(R.string.text_id), walletRequestDetail.getUniqueId()));
            try {
                Date date = ParseContent.getInstance().webFormat.parse(walletRequestDetail.getCreatedAt());
                if (date != null) {
                    tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                    tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
                }
            } catch (ParseException e) {
                Utilities.handleException(WalletDetailActivity.class.getName(), e);
            }
            if (walletRequestDetail.isPaymentModeCash()) {
                tvMode.setText(getResources().getString(R.string.text_cash_payment));
            } else {
                tvMode.setText(getResources().getString(R.string.text_bank_payment));
            }
        }
    }

    private String walletSate(int id) {
        String comment;
        switch (id) {
            case Constant.Wallet.WALLET_STATUS_CREATED:
                comment = getResources().getString(R.string.text_wallet_status_created);
                break;
            case Constant.Wallet.WALLET_STATUS_ACCEPTED:
                comment = getResources().getString(R.string.text_wallet_status_accepted);
                break;
            case Constant.Wallet.WALLET_STATUS_TRANSFERRED:
                comment = getResources().getString(R.string.text_wallet_status_transferred);
                break;
            case Constant.Wallet.WALLET_STATUS_COMPLETED:
                comment = getResources().getString(R.string.text_wallet_status_completed);
                break;
            case Constant.Wallet.WALLET_STATUS_CANCELLED:
                comment = getResources().getString(R.string.text_wallet_status_cancelled);
                break;
            default:
                comment = "NA";
                break;
        }
        return comment;
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}