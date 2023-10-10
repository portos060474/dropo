package com.dropo.store.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.store.R;
import com.dropo.store.BaseActivity;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;


import java.util.List;

public class CancellationSpinnerAdapter extends ArrayAdapter<Integer> {
    private final LayoutInflater inflater;
    private final List<Integer> status;

    public CancellationSpinnerAdapter(@NonNull BaseActivity activity, @NonNull List<Integer> status) {
        super(activity, 0, status);
        this.status = status;
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
        Integer status = this.status.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(Utilities.setStatusCode(view.getContext(), Constant.CANCELLATION_STATUS_TEXT_PREFIX, status, false));
        return view;
    }

    private View getDropDownCustomView(int position, ViewGroup parent) {
        View view = inflater.inflate(R.layout.item_spinner_view_big, parent, false);
        Integer status = this.status.get(position);
        TextView tvBankName = view.findViewById(android.R.id.text1);
        tvBankName.setText(Utilities.setStatusCode(view.getContext(), Constant.CANCELLATION_STATUS_TEXT_PREFIX, status, false));
        return view;
    }
}
