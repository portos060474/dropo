package com.dropo.provider.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.dropo.provider.R;

public class PayPalFragment extends BasePaymentFragments {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_pay_pal, container, false);
    }

    @Override
    public void onClick(View view) {
    }
}