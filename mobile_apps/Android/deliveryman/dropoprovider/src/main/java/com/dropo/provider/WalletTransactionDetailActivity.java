package com.dropo.provider;

import android.os.Bundle;
import android.view.View;

import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.WalletRequestDetail;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;

import java.text.ParseException;
import java.util.Date;

public class WalletTransactionDetailActivity extends BaseAppCompatActivity {

    private CustomFontTextView tvTransactionDate, tvTransactionTime;
    private CustomFontTextViewTitle tvWalletRequestAmount, tvApproveByAdmin, tvTotalWalletAmount, tvMode, tvWithdrawalID;
    private WalletRequestDetail walletRequestDetail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_trans_detail);
        initToolBar();
        initViewById();
        setViewListener();
        getExtraData();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        tvTotalWalletAmount = findViewById(R.id.tvTotalWalletAmount);
        tvWalletRequestAmount = findViewById(R.id.tvWalletRequestAmount);
        tvApproveByAdmin = findViewById(R.id.tvApproveByAdmin);
        tvWithdrawalID = findViewById(R.id.tvWithdrawalID);
        tvTransactionDate = findViewById(R.id.tvTransactionDate);
        tvTransactionTime = findViewById(R.id.tvTransactionTime);
        tvMode = findViewById(R.id.tvMode);
    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {

    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            walletRequestDetail = getIntent().getExtras().getParcelable(Const.BUNDLE);
            setTitleOnToolBar(walletSate(walletRequestDetail.getWalletStatus()));
            tvApproveByAdmin.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(walletRequestDetail.getApprovedRequestedWalletAmount()), walletRequestDetail.getAdminCurrencyCode()));
            if (Const.Wallet.WALLET_STATUS_COMPLETED == walletRequestDetail.getWalletStatus()) {
                tvTotalWalletAmount.setText(parseContent.decimalTwoDigitFormat.format(walletRequestDetail.getAfterTotalWalletAmount()));
            } else {
                tvTotalWalletAmount.setText(String.format("%s %s", walletRequestDetail.getTotalWalletAmount(), walletRequestDetail.getAdminCurrencyCode()));
            }
            String amount = parseContent.decimalTwoDigitFormat.format(walletRequestDetail.getWalletStatus() == Const.Wallet.WALLET_STATUS_COMPLETED || walletRequestDetail.getWalletStatus() == Const.Wallet.WALLET_STATUS_TRANSFERRED ? walletRequestDetail.getApprovedRequestedWalletAmount() : walletRequestDetail.getRequestedWalletAmount()) + " " + walletRequestDetail.getAdminCurrencyCode();
            tvWalletRequestAmount.setText(amount);
            tvWithdrawalID.setText(String.format("%s %s", getResources().getString(R.string.text_id), walletRequestDetail.getUniqueId()));
            try {
                Date date = ParseContent.getInstance().webFormat.parse(walletRequestDetail.getCreatedAt());
                if (date != null) {
                    tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                    tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
                }
            } catch (ParseException e) {
                AppLog.handleException(WalletDetailActivity.class.getName(), e);
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
            case Const.Wallet.WALLET_STATUS_CREATED:
                comment = getResources().getString(R.string.text_wallet_status_created);
                break;
            case Const.Wallet.WALLET_STATUS_ACCEPTED:
                comment = getResources().getString(R.string.text_wallet_status_accepted);
                break;
            case Const.Wallet.WALLET_STATUS_TRANSFERRED:
                comment = getResources().getString(R.string.text_wallet_status_transferred);
                break;
            case Const.Wallet.WALLET_STATUS_COMPLETED:
                comment = getResources().getString(R.string.text_wallet_status_completed);
                break;
            case Const.Wallet.WALLET_STATUS_CANCELLED:
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