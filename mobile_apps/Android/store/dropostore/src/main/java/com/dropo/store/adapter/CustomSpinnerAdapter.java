package com.dropo.store.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.SpinnerItem;


import java.util.List;

public class CustomSpinnerAdapter extends ArrayAdapter<SpinnerItem> {

    private final LayoutInflater inflater;
    private final List<SpinnerItem> list;

    public CustomSpinnerAdapter(@NonNull Activity activity, @NonNull List<SpinnerItem> list) {
        super(activity, 0, list);
        this.list = list;
        inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
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
        SpinnerItem spinnerItem = list.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(spinnerItem.getValue());
        return view;
    }

    private View getDropDownCustomView(int position, ViewGroup parent) {
        View view = inflater.inflate(R.layout.item_spinner_view_big, parent, false);
        SpinnerItem spinnerItem = list.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(spinnerItem.getValue());
        return view;
    }
}