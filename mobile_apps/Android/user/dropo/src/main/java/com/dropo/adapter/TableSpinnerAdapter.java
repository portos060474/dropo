package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.user.R;

import java.util.List;

public class TableSpinnerAdapter extends ArrayAdapter<String> {
    private final LayoutInflater inflater;
    private final List<String> strings;

    public TableSpinnerAdapter(@NonNull Context withdrawalActivity, @NonNull List<String> strings) {
        super(withdrawalActivity, 0, strings);
        this.strings = strings;
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
        View view = inflater.inflate(R.layout.item_spinner, parent, false);
        String tableName = strings.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(tableName);
        return view;
    }

    private View getDropDownCustomView(int position, ViewGroup parent) {
        View view = inflater.inflate(R.layout.item_spinner_dropdown, parent, false);
        String tableName = strings.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(tableName);
        return view;
    }
}