package com.dropo.store.adapter;

import android.os.Build;
import android.text.Html;
import android.text.Spanned;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.BankDetailActivity;
import com.dropo.store.models.datamodel.BankDetail;
import com.dropo.store.utils.AppColor;


import java.util.List;

public class BankDetailAdapter extends RecyclerView.Adapter<BankDetailAdapter.BankItemView> {
    private final BankDetailActivity bankDetailActivity;
    private final List<BankDetail> bankDetails;
    private final String colorLabel;
    private final String colorText;

    public BankDetailAdapter(BankDetailActivity bankDetailActivity, List<BankDetail> bankDetails) {
        this.bankDetailActivity = bankDetailActivity;
        this.bankDetails = bankDetails;
        colorLabel = "#" + Integer.toHexString(ResourcesCompat.getColor(bankDetailActivity.getResources(), R.color.color_app_label_light, null) & 0x00ffffff);
        colorText = "#" + Integer.toHexString(AppColor.getThemeTextColor(bankDetailActivity) & 0x00ffffff);
    }

    @SuppressWarnings("deprecation")
    public static Spanned fromHtml(String source) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            return Html.fromHtml(source, Html.FROM_HTML_MODE_LEGACY);
        } else {
            return Html.fromHtml(source);
        }
    }

    @NonNull
    @Override
    public BankItemView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_bank_detail, parent, false);
        return new BankItemView(view);
    }

    @Override
    public void onBindViewHolder(BankItemView holder, int position) {
        BankDetail bankDetail = bankDetails.get(position);
        holder.tvBankAccountNumber.setText(fromHtml(getColoredSpanned(bankDetailActivity.getResources().getString(R.string.text_account_no), bankDetail.getAccountNumber())));
        holder.tvAccountHolderName.setText(bankDetail.getBankAccountHolderName());
        holder.tvRoutingNumber.setText(fromHtml(getColoredSpanned(bankDetailActivity.getResources().getString(R.string.text_personal_id_number), bankDetail.getRoutingNumber())));
        holder.ivSelected.setVisibility(bankDetail.isSelected() ? View.VISIBLE : View.GONE);
    }

    @Override
    public int getItemCount() {
        return bankDetails.size();
    }

    private String getColoredSpanned(String text1, String text2) {
        return "<font color=" + colorLabel + ">" + text1 + " : " + "</font>" + "<font " + "color=" + colorText + ">" + text2 + "</font>";
    }

    protected class BankItemView extends RecyclerView.ViewHolder implements View.OnClickListener {
        private final ImageView ivDeleteBankDetail;
        private final ImageView ivSelected;
        private final TextView tvBankAccountNumber;
        private final TextView tvAccountHolderName;
        private final TextView tvRoutingNumber;

        public BankItemView(View itemView) {
            super(itemView);
            tvBankAccountNumber = itemView.findViewById(R.id.tvBankAccountNumber);
            tvAccountHolderName = itemView.findViewById(R.id.tvAccountHolderName);
            ivDeleteBankDetail = itemView.findViewById(R.id.ivDeleteBankDetail);
            tvRoutingNumber = itemView.findViewById(R.id.tvRoutingNumber);
            ivSelected = itemView.findViewById(R.id.ivSelected);
            ivDeleteBankDetail.setOnClickListener(this);
            itemView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.ivDeleteBankDetail) {
                bankDetailActivity.showVerificationDialog(bankDetails.get(getAdapterPosition()));
            } else {
                bankDetailActivity.selectBankDetail(bankDetails.get(getAdapterPosition()));
            }
        }
    }
}
