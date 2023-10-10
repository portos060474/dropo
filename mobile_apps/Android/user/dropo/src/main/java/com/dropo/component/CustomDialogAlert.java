package com.dropo.component;

import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;


import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class CustomDialogAlert extends BottomSheetDialog implements View.OnClickListener {

    private final TextView tvDialogEdiTextMessage;
    private final TextView tvDialogEditTextTitle;
    private final ImageView btnDialogEditTextLeft;
    public Button btnDialogEditTextRight;

    public CustomDialogAlert(Context context, String title, String message, String titleRightButton) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_custom_alert);
        tvDialogEdiTextMessage = findViewById(R.id.tvDialogAlertMessage);
        tvDialogEditTextTitle = findViewById(R.id.tvDialogAlertTitle);
        btnDialogEditTextLeft = findViewById(R.id.btnDialogAlertLeft);
        btnDialogEditTextRight = findViewById(R.id.btnDialogAlertRight);


        btnDialogEditTextLeft.setOnClickListener(this);
        btnDialogEditTextRight.setOnClickListener(this);

        tvDialogEditTextTitle.setText(title);
        tvDialogEdiTextMessage.setText(message);
        btnDialogEditTextRight.setText(titleRightButton);

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnDialogAlertLeft) {
            onClickLeftButton();
        } else if (id == R.id.btnDialogAlertRight) {
            onClickRightButton();
        }
    }

    public abstract void onClickLeftButton();

    public abstract void onClickRightButton();

    public void setNegativeButtonIcon(int resId) {
        btnDialogEditTextLeft.setImageResource(resId);
        btnDialogEditTextLeft.getDrawable().setTint(AppColor.COLOR_THEME);
    }
}