package com.dropo.fragments;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomSwitch;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ParseContent;

public class CashFragment extends BasePaymentFragments {

    private CustomFontTextView tvPayMessage;
    private View llBringChange;
    private CustomSwitch swBringChange;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_cash, container, false);
        tvPayMessage = view.findViewById(R.id.tvPayCashMessage);
        llBringChange = view.findViewById(R.id.llBringChange);
        swBringChange = view.findViewById(R.id.swBringChange);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (paymentActivity.preferenceHelper.getIsAllowBringChangeOption()
                && !paymentActivity.preferenceHelper.getIsFromQRCode()) {
            llBringChange.setVisibility(View.VISIBLE);
        } else {
            llBringChange.setVisibility(View.GONE);
        }

        if (paymentActivity.isShowBringChange) {
            llBringChange.setVisibility(View.GONE);
        }

        swBringChange.setOnCheckedChangeListener((buttonView, isChecked) -> paymentActivity.isBringChange = isChecked);

        paymentActivity.isBringChange = swBringChange.isChecked();
    }

    @Override
    public void onClick(View view) {
    }

    @SuppressLint("StringFormatInvalid")
    public void setPayCashMessage(double payAmount) {
        if (tvPayMessage != null) {
            if (payAmount > 0) {
                if (paymentActivity.preferenceHelper.getIsFromQRCode()) {
                    tvPayMessage.setText(paymentActivity.getResources().getString(R.string.text_pay_cash_qr_amount,
                            CurrentBooking.getInstance().getCurrency() + ParseContent.getInstance().decimalTwoDigitFormat.format(payAmount)));
                } else {
                    tvPayMessage.setText(paymentActivity.getResources().getString(R.string.text_pay_cash_amount,
                            CurrentBooking.getInstance().getCurrency() + ParseContent.getInstance().decimalTwoDigitFormat.format(payAmount)));
                }
            } else {
                tvPayMessage.setText(paymentActivity.getResources().getString(R.string.text_no_pay_cash_amount));
            }
        }
    }
}