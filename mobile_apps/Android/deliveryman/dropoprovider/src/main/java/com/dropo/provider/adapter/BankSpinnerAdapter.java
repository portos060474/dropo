package com.dropo.provider.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.provider.R;
import com.dropo.provider.WithdrawalActivity;
import com.dropo.provider.models.datamodels.BankDetail;

import java.util.List;

public class BankSpinnerAdapter extends ArrayAdapter {

    private final LayoutInflater inflater;
    private final List<BankDetail> bankDetails;

    public BankSpinnerAdapter(@NonNull WithdrawalActivity withdrawalActivity, @NonNull List<BankDetail> bankDetails) {
        super(withdrawalActivity, 0, bankDetails);
        this.bankDetails = bankDetails;
        inflater = (LayoutInflater) withdrawalActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @Override
    public View getDropDownView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        return getDropDownCustomView(position, parent);
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        return getCustomView(position, parent);
    }

    private View getCustomView(int position, ViewGroup parent) {
        View view = inflater.inflate(R.layout.spinner_view_big, parent, false);
        BankDetail bankDetail = bankDetails.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(bankDetail.getAccountNumber());
        return view;
    }

    private View getDropDownCustomView(int position, ViewGroup parent) {
        View view = inflater.inflate(R.layout.item_spiner_view_big, parent, false);
        BankDetail bankDetail = bankDetails.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(bankDetail.getAccountNumber());
        return view;
    }
}
