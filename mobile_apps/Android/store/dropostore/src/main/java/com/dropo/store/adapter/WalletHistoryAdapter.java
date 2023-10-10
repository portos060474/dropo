package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.fragment.WalletHistoryFragment;
import com.dropo.store.models.datamodel.WalletHistory;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;


import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

public class WalletHistoryAdapter extends RecyclerView.Adapter<WalletHistoryAdapter.WalletHistoryHolder> {

    private final ArrayList<WalletHistory> walletHistories;
    private final WalletHistoryFragment walletHistoryFragment;

    public WalletHistoryAdapter(WalletHistoryFragment walletHistoryFragment, ArrayList<WalletHistory> walletHistories) {
        this.walletHistories = walletHistories;
        this.walletHistoryFragment = walletHistoryFragment;
    }

    @NonNull
    @Override
    public WalletHistoryHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_wallet_history, parent, false);
        return new WalletHistoryHolder(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(@NonNull WalletHistoryHolder holder, int position) {
        WalletHistory walletHistory = walletHistories.get(position);
        try {
            Date date = ParseContent.getInstance().webFormat.parse(walletHistory.getCreatedAt());
            if (date != null) {
                holder.tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                holder.tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
            }
            holder.tvWithdrawalId.setText(walletHistoryFragment.getResources().getString(R.string.text_id) + " " + walletHistory.getUniqueId());

            holder.tvTransactionState.setText(walletComment(walletHistory.getWalletCommentId()));

            switch (walletHistory.getWalletStatus()) {
                case Constant.Wallet.ADD_WALLET_AMOUNT:
                    holder.tvTransactionAmount.setTextColor(ResourcesCompat.getColor(walletHistoryFragment.getResources(), R.color.color_app_wallet_added, null));
                    holder.tvTransactionAmount.setText("+" + ParseContent.getInstance().decimalTwoDigitFormat.format(walletHistory.getAddedWallet()) + " " + walletHistory.getToCurrencyCode());
                    break;
                case Constant.Wallet.REMOVE_WALLET_AMOUNT:
                    holder.tvTransactionAmount.setTextColor(ResourcesCompat.getColor(walletHistoryFragment.getResources(), R.color.color_app_wallet_deduct, null));
                    holder.tvTransactionAmount.setText("-" + ParseContent.getInstance().decimalTwoDigitFormat.format(walletHistory.getAddedWallet()) + " " + walletHistory.getFromCurrencyCode());
                    break;
            }
        } catch (ParseException e) {
            Utilities.handleException(WalletHistoryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return walletHistories.size();
    }

    private String walletComment(int id) {
        String comment;
        switch (id) {
            case Constant.Wallet.ADDED_BY_ADMIN:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_added_by_admin);
                break;
            case Constant.Wallet.ADDED_BY_CARD:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_added_by_card);
                break;
            case Constant.Wallet.ADDED_BY_REFERRAL:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_added_by_referral);
                break;
            case Constant.Wallet.ORDER_REFUND:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_order_refund);
                break;
            case Constant.Wallet.ORDER_PROFIT:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_order_profit);
                break;
            case Constant.Wallet.ORDER_CANCELLATION_CHARGE:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_order_cancellation_charge);
                break;
            case Constant.Wallet.ORDER_CHARGED:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_order_charged);
                break;
            case Constant.Wallet.WALLET_REQUEST_CHARGE:
                comment = walletHistoryFragment.getResources().getString(R.string.text_wallet_status_wallet_request_charge);
                break;
            default:
                comment = "NA";
                break;
        }
        return comment;
    }

    protected static class WalletHistoryHolder extends RecyclerView.ViewHolder {
        TextView tvTransactionState, tvTransactionAmount;
        TextView tvTransactionDate, tvWithdrawalId, tvTransactionTime;

        public WalletHistoryHolder(View itemView) {
            super(itemView);
            tvWithdrawalId = itemView.findViewById(R.id.tvWithdrawalID);
            tvTransactionAmount = itemView.findViewById(R.id.tvTransactionAmount);
            tvTransactionDate = itemView.findViewById(R.id.tvTransactionDate);
            tvTransactionState = itemView.findViewById(R.id.tvTransactionState);
            tvTransactionTime = itemView.findViewById(R.id.tvTransactionTime);
        }
    }
}