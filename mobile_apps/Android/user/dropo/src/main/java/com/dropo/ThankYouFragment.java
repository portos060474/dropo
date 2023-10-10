package com.dropo;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontTextView;
import com.dropo.user.R;
import com.dropo.utils.Const;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

public class ThankYouFragment extends BottomSheetDialogFragment {

    private CustomFontButton btnTrackYourOrder;
    private PaymentActivity paymentActivity;
    private ImageView btnDialogAlertLeft, ivThankYou;
    private CustomFontTextView tvThankYou;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        paymentActivity = (PaymentActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_thank_you, container, false);
        btnTrackYourOrder = view.findViewById(R.id.btnTrackYourOrder);
        btnDialogAlertLeft = view.findViewById(R.id.btnDialogAlertLeft);
        tvThankYou = view.findViewById(R.id.tvThankYou);
        ivThankYou = view.findViewById(R.id.ivThankYou);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
            dialog.setCancelable(false);
        }
        btnTrackYourOrder.setOnClickListener(view -> {
            dismiss();
            if (paymentActivity.preferenceHelper.getIsFromQRCode()) {
                paymentActivity.clearQROrderData();
                paymentActivity.goToHomeActivity();
            } else {
                if (paymentActivity.currentBooking.isTableBooking()) {
                    paymentActivity.goToHomeActivity();
                } else {
                    goToOrdersActivity();
                }
            }
        });
        btnDialogAlertLeft.setOnClickListener(view -> {
            dismiss();
            paymentActivity.goToHomeActivity();
        });

        if (paymentActivity.currentBooking.isTableBooking()) {
            ivThankYou.setImageResource(R.drawable.ic_table_reservation_successful);
            tvThankYou.setText(getString(R.string.msg_success_table_booking));
            btnTrackYourOrder.setText(getString(R.string.btn_book_another));
        }

        if (paymentActivity.preferenceHelper.getIsFromQRCode()) {
            btnTrackYourOrder.setText(getString(R.string.text_ok));
        }
    }

    private void goToOrdersActivity() {
        Intent intent = new Intent(paymentActivity, OrdersActivity.class);
        intent.putExtra(Const.IS_FROM_COMPLETE_ORDER, true);
        startActivity(intent);
        paymentActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }
}