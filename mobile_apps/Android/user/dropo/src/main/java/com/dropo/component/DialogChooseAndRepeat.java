package com.dropo.component;

import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;

import com.dropo.user.R;
import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class DialogChooseAndRepeat extends BottomSheetDialog implements View.OnClickListener {

    private final TextView tvMessage;
    private final View btnClose;
    private final Button btnIWllChoose, btnRepeatLast;

    public DialogChooseAndRepeat(Context context, String message) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_choose_and_repeat);
        tvMessage = findViewById(R.id.tvMessage);
        btnClose = findViewById(R.id.btnClose);
        btnIWllChoose = findViewById(R.id.btnIWllChoose);
        btnRepeatLast = findViewById(R.id.btnRepeatLast);

        btnClose.setOnClickListener(this);
        btnIWllChoose.setOnClickListener(this);
        btnRepeatLast.setOnClickListener(this);

        tvMessage.setText(String.format(context.getString(R.string.text_customization) + " : %s", message));

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnClose) {
            dismiss();
        } else if (id == R.id.btnIWllChoose) {
            onClickIWllChooseButton();
        } else if (id == R.id.btnRepeatLast) {
            onClickRepeatLastButton();
        }
    }

    public abstract void onClickIWllChooseButton();

    public abstract void onClickRepeatLastButton();
}