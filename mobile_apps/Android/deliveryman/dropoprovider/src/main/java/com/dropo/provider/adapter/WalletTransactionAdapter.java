package com.dropo.provider.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.fragments.WalletTransactionFragment;
import com.dropo.provider.models.datamodels.WalletRequestDetail;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

public class WalletTransactionAdapter extends RecyclerView.Adapter<WalletTransactionAdapter.WalletTransactionHolder> {

    private final ArrayList<WalletRequestDetail> walletRequestDetails;
    private final WalletTransactionFragment walletTransactionFragment;

    public WalletTransactionAdapter(WalletTransactionFragment walletTransactionFragment, ArrayList<WalletRequestDetail> walletHistoryItems) {
        this.walletRequestDetails = walletHistoryItems;
        this.walletTransactionFragment = walletTransactionFragment;
    }

    @NonNull
    @Override
    public WalletTransactionHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_wallet_transection, parent, false);
        return new WalletTransactionHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull WalletTransactionHolder holder, int position) {
        WalletRequestDetail requestDetailItem = walletRequestDetails.get(position);
        try {
            Date date = ParseContent.getInstance().webFormat.parse(requestDetailItem.getCreatedAt());
            if (date != null) {
                holder.tvTransactionDate.setText(ParseContent.getInstance().dateFormat3.format(date));
                holder.tvTransactionTime.setText(ParseContent.getInstance().timeFormat_am.format(date));
            }
            holder.tvWithdrawalId.setText(String.format("%s %s", walletTransactionFragment.getResources().getString(R.string.text_id), requestDetailItem.getUniqueId()));
            String amount = ParseContent.getInstance().decimalTwoDigitFormat.format(requestDetailItem.getWalletStatus() == Const.Wallet.WALLET_STATUS_COMPLETED || requestDetailItem.getWalletStatus() == Const.Wallet.WALLET_STATUS_TRANSFERRED ? requestDetailItem.getApprovedRequestedWalletAmount() : requestDetailItem.getRequestedWalletAmount()) + " " + requestDetailItem.getAdminCurrencyCode();

            holder.tvTransactionAmount.setText(amount);
            holder.tvTransactionState.setText(walletSate(requestDetailItem.getWalletStatus()));
            if (requestDetailItem.getWalletStatus() == Const.Wallet.WALLET_STATUS_CANCELLED || requestDetailItem.getWalletStatus() == Const.Wallet.WALLET_STATUS_TRANSFERRED || requestDetailItem.getWalletStatus() == Const.Wallet.WALLET_STATUS_COMPLETED) {
                holder.tvCancelWalletRequest.setVisibility(View.GONE);
            } else {
                holder.tvCancelWalletRequest.setVisibility(View.VISIBLE);
            }
        } catch (ParseException e) {
            AppLog.handleException(WalletHistoryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return walletRequestDetails.size();
    }

    private String walletSate(int id) {
        String comment;
        switch (id) {
            case Const.Wallet.WALLET_STATUS_CREATED:
                comment = walletTransactionFragment.getResources().getString(R.string.text_wallet_status_created);
                break;
            case Const.Wallet.WALLET_STATUS_ACCEPTED:
                comment = walletTransactionFragment.getResources().getString(R.string.text_wallet_status_accepted);
                break;
            case Const.Wallet.WALLET_STATUS_TRANSFERRED:
                comment = walletTransactionFragment.getResources().getString(R.string.text_wallet_status_transferred);
                break;
            case Const.Wallet.WALLET_STATUS_COMPLETED:
                comment = walletTransactionFragment.getResources().getString(R.string.text_wallet_status_completed);
                break;
            case Const.Wallet.WALLET_STATUS_CANCELLED:
                comment = walletTransactionFragment.getResources().getString(R.string.text_wallet_status_cancelled);
                break;
            default:
                comment = "NA";
                break;
        }
        return comment;
    }

    protected class WalletTransactionHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        CustomFontTextViewTitle tvTransactionAmount;
        CustomFontTextView tvTransactionDate, tvCancelWalletRequest, tvTransactionTime, tvTransactionState;
        LinearLayout llProduct;
        CustomFontTextViewTitle tvWithdrawalId;

        public WalletTransactionHolder(View itemView) {
            super(itemView);
            tvWithdrawalId = itemView.findViewById(R.id.tvWithdrawalID);
            tvTransactionAmount = itemView.findViewById(R.id.tvTransactionAmount);
            tvTransactionDate = itemView.findViewById(R.id.tvTransactionDate);
            tvTransactionState = itemView.findViewById(R.id.tvTransactionState);
            tvCancelWalletRequest = itemView.findViewById(R.id.tvCancelWalletRequest);
            tvTransactionTime = itemView.findViewById(R.id.tvTransactionTime);
            llProduct = itemView.findViewById(R.id.llProduct);
            tvCancelWalletRequest.setOnClickListener(this);
            llProduct.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            int id = v.getId();
            if (id == R.id.llProduct) {
                walletTransactionFragment.goToWalletTransactionActivity(walletRequestDetails.get(getAbsoluteAdapterPosition()));
            } else if (id == R.id.tvCancelWalletRequest) {
                walletTransactionFragment.openCancelWithdrawalRequestDialog(walletRequestDetails.get(getAbsoluteAdapterPosition()).getId());
            }
        }
    }
}