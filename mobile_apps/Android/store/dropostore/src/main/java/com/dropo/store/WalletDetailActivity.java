package com.dropo.store;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.models.datamodel.WalletHistory;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.Date;

public class WalletDetailActivity extends BaseActivity {

    private TextView tvTransactionDate, tvDescription, tvTransactionTime, tvWithdrawalID, tvTagCurrentRate, tvAmountTag;
    private TextView tvAmount, tvCurrentRate, tvTotalWalletAmount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_detail);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(WalletDetailActivity.this);
            onBackPressed();
        });

        tvTotalWalletAmount = findViewById(R.id.tvTotalWalletAmount);
        tvAmount = findViewById(R.id.tvAmount);
        tvWithdrawalID = findViewById(R.id.tvWithdrawalID);
        tvTransactionDate = findViewById(R.id.tvTransactionDate);
        tvTransactionTime = findViewById(R.id.tvTransactionTime);
        tvCurrentRate = findViewById(R.id.tvCurrentRate);
        tvDescription = findViewById(R.id.tvDescription);
        tvTagCurrentRate = findViewById(R.id.tvTagCurrentRate);
        tvAmountTag = findViewById(R.id.tvAmountTag);
        getExtraData();
    }

    @SuppressLint("SetTextI18n")
    private void walletStatus(int id) {
        switch (id) {
            case Constant.Wallet.ADD_WALLET_AMOUNT:
                tvAmount.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_wallet_added, null));
                tvAmountTag.setText(getResources().getString(R.string.text_added_amount));
                break;
            case Constant.Wallet.REMOVE_WALLET_AMOUNT:
                tvAmount.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_wallet_deduct, null));
                tvAmountTag.setText(getResources().getString(R.string.text_deducted_amount));
                break;
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    @SuppressLint("SetTextI18n")
    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            WalletHistory walletHistory = getIntent().getExtras().getParcelable(Constant.BUNDLE);
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(walletComment(walletHistory.getWalletCommentId()));
            walletStatus(walletHistory.getWalletStatus());
            tvWithdrawalID.setText(getResources().getString(R.string.text_id) + " " + walletHistory.getUniqueId());
            try {
                Date date = ParseContent.getInstance().webFormat.parse(walletHistory.getCreatedAt());
                if (date != null) {
                    tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                    tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
                }
            } catch (ParseException e) {
                Utilities.handleException(WalletDetailActivity.class.getName(), e);
            }

            tvDescription.setText(walletHistory.getWalletDescription());

            if (walletHistory.getCurrentRate() == 1.0) {
                tvTagCurrentRate.setVisibility(View.GONE);
                tvCurrentRate.setVisibility(View.GONE);
            } else {
                DecimalFormat decimalTwoDigitFormat = new DecimalFormat("0.0000");
                tvTagCurrentRate.setVisibility(View.VISIBLE);
                tvCurrentRate.setVisibility(View.VISIBLE);
                tvCurrentRate.setText("1" + walletHistory.getFromCurrencyCode() + " (" + decimalTwoDigitFormat.format(walletHistory.getCurrentRate()) + walletHistory.getToCurrencyCode() + ")");
            }
            tvAmount.setText("+" + parseContent.decimalTwoDigitFormat.format(walletHistory.getAddedWallet()) + " " + walletHistory.getToCurrencyCode());
            tvTotalWalletAmount.setText(parseContent.decimalTwoDigitFormat.format(walletHistory.getTotalWalletAmount()) + " " + walletHistory.getToCurrencyCode());
        }
    }

    private String walletComment(int id) {
        String comment;
        switch (id) {
            case Constant.Wallet.ADDED_BY_ADMIN:
                comment = getResources().getString(R.string.text_wallet_status_added_by_admin);
                break;
            case Constant.Wallet.ADDED_BY_CARD:
                comment = getResources().getString(R.string.text_wallet_status_added_by_card);
                break;
            case Constant.Wallet.ADDED_BY_REFERRAL:
                comment = getResources().getString(R.string.text_wallet_status_added_by_referral);
                break;
            case Constant.Wallet.ORDER_REFUND:
                comment = getResources().getString(R.string.text_wallet_status_order_refund);
                break;
            case Constant.Wallet.ORDER_PROFIT:
                comment = getResources().getString(R.string.text_wallet_status_order_profit);
                break;
            case Constant.Wallet.ORDER_CANCELLATION_CHARGE:
                comment = getResources().getString(R.string.text_wallet_status_order_cancellation_charge);
                break;
            case Constant.Wallet.ORDER_CHARGED:
                comment = getResources().getString(R.string.text_wallet_status_order_charged);
                break;
            case Constant.Wallet.WALLET_REQUEST_CHARGE:
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