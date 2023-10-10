package com.dropo;

import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;

import com.dropo.models.datamodels.WalletHistory;
import com.dropo.parser.ParseContent;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Date;

public class WalletDetailActivity extends BaseAppCompatActivity {

    private TextView tvTransactionDate, tvDescription, tvTransactionTime, tvWithdrawalID, tvTagCurrentRate, tvAmountTag;
    private TextView tvAmount, tvCurrentRate, tvTotalWalletAmount;
    private WalletHistory walletHistory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_detail);
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
        tvAmount = findViewById(R.id.tvAmount);
        tvWithdrawalID = findViewById(R.id.tvWithdrawalID);
        tvTransactionDate = findViewById(R.id.tvTransactionDate);
        tvTransactionTime = findViewById(R.id.tvTransactionTime);
        tvCurrentRate = findViewById(R.id.tvCurrentRate);
        tvDescription = findViewById(R.id.tvDescription);
        tvTagCurrentRate = findViewById(R.id.tvTagCurrentRate);
        tvAmountTag = findViewById(R.id.tvAmountTag);
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
            walletHistory = getIntent().getExtras().getParcelable(Const.BUNDLE);
            setTitleOnToolBar(walletComment(walletHistory.getWalletCommentId()));

            walletStatus(walletHistory.getWalletStatus());
            tvWithdrawalID.setText(String.format("%s %s", getResources().getString(R.string.text_id), walletHistory.getUniqueId()));
            try {
                Date date = ParseContent.getInstance().webFormat.parse(walletHistory.getCreatedAt());
                if (date != null) {
                    tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                    tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
                }
            } catch (ParseException e) {
                AppLog.handleException(WalletDetailActivity.class.getName(), e);
            }
            tvDescription.setText(walletHistory.getWalletDescription());
            if (walletHistory.getCurrentRate() == 1.0) {
                tvTagCurrentRate.setVisibility(View.GONE);
                tvCurrentRate.setVisibility(View.GONE);
            } else {
                tvTagCurrentRate.setVisibility(View.VISIBLE);
                tvCurrentRate.setVisibility(View.VISIBLE);
                DecimalFormat decimalTwoDigitFormat = new DecimalFormat("0.0000");
                tvCurrentRate.setText(String.format("%s%s (%s%s)", "1", walletHistory.getFromCurrencyCode(), decimalTwoDigitFormat.format(walletHistory.getCurrentRate()), walletHistory.getToCurrencyCode()));
            }
        }
    }

    private void walletStatus(int id) {
        switch (id) {
            case Const.Wallet.ADD_WALLET_AMOUNT:
            case Const.Wallet.ORDER_REFUND_AMOUNT:
            case Const.Wallet.ORDER_PROFIT_AMOUNT:
                tvAmount.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_wallet_added, null));
                tvAmountTag.setText(getResources().getString(R.string.text_added_amount));
                tvAmount.setText(String.format("+%s %s", parseContent.decimalTwoDigitFormat.format(walletHistory.getAddedWallet()), walletHistory.getToCurrencyCode()));
                tvTotalWalletAmount.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(walletHistory.getTotalWalletAmount()), walletHistory.getToCurrencyCode()));
                break;
            case Const.Wallet.REMOVE_WALLET_AMOUNT:
            case Const.Wallet.ORDER_CHARGE_AMOUNT:
            case Const.Wallet.ORDER_CANCELLATION_CHARGE_AMOUNT:
            case Const.Wallet.REQUEST_CHARGE_AMOUNT:
            case Const.Wallet.ORDER_PROFIT_DEDUCT_AMOUNT:
                tvAmount.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_wallet_deduct, null));
                tvAmountTag.setText(getResources().getString(R.string.text_deducted_amount));
                tvAmount.setText(String.format("-%s %s", parseContent.decimalTwoDigitFormat.format(walletHistory.getAddedWallet()), walletHistory.getFromCurrencyCode()));
                tvTotalWalletAmount.setText(String.format("%s %s", parseContent.decimalTwoDigitFormat.format(walletHistory.getTotalWalletAmount()), walletHistory.getFromCurrencyCode()));
                break;
        }
    }

    private String walletComment(int id) {
        String comment;
        switch (id) {
            case Const.Wallet.ADDED_BY_ADMIN:
                comment = getResources().getString(R.string.text_wallet_status_added_by_admin);
                break;
            case Const.Wallet.ADDED_BY_CARD:
                comment = getResources().getString(R.string.text_wallet_status_added_by_card);
                break;
            case Const.Wallet.ADDED_BY_REFERRAL:
                comment = getResources().getString(R.string.text_wallet_status_added_by_referral);
                break;
            case Const.Wallet.ORDER_REFUND:
                comment = getResources().getString(R.string.text_wallet_status_order_refund);
                break;
            case Const.Wallet.ORDER_PROFIT:
                comment = getResources().getString(R.string.text_wallet_status_order_profit);
                break;
            case Const.Wallet.ORDER_CANCELLATION_CHARGE:
                comment = getResources().getString(R.string.text_wallet_status_order_cancellation_charge);
                break;
            case Const.Wallet.ORDER_CHARGED:
                comment = getResources().getString(R.string.text_wallet_status_order_charged);
                break;
            case Const.Wallet.WALLET_REQUEST_CHARGE:
                comment = getResources().getString(R.string.text_wallet_status_wallet_request_charge);
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