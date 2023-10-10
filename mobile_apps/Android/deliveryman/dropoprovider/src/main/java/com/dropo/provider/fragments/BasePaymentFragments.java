package com.dropo.provider.fragments;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dropo.provider.PaymentActivity;

public abstract class BasePaymentFragments extends Fragment implements View.OnClickListener {

    protected PaymentActivity paymentActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        paymentActivity = (PaymentActivity) getActivity();
    }
}