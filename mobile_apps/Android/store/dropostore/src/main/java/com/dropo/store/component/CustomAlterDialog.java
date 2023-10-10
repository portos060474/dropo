package com.dropo.store.component;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;

import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class CustomAlterDialog extends BottomSheetDialog implements View.OnClickListener {

    private final String message;
    private final boolean isShowNegativeButton;
    private final String title;
    private String positiveBtnText;
    private ImageView btnNegative;

    public CustomAlterDialog(Context context, String title, String message) {
        super(context);
        this.message = message;
        this.title = title;
        isShowNegativeButton = false;
    }

    public CustomAlterDialog(Context context, String title, String message, boolean isShowNegativeButton, String positiveBtnText) {
        super(context);
        this.message = message;
        this.title = title;
        this.isShowNegativeButton = isShowNegativeButton;
        this.positiveBtnText = positiveBtnText;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Button btnPositive;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_alter);

        TextView tvMessage = findViewById(R.id.tvMessage);
        TextView tvTitle = findViewById(R.id.tvTitle);
        btnPositive = findViewById(R.id.btnPositive);
        btnNegative = findViewById(R.id.btnNegative);

        tvMessage.setText(message);
        if (TextUtils.isEmpty(title)) {
            tvTitle.setVisibility(View.GONE);
        } else {
            tvTitle.setText(title);
        }

        btnPositive.setOnClickListener(this);
        btnNegative.setOnClickListener(this);

        if (!isShowNegativeButton) {
            btnNegative.setVisibility(View.GONE);
        } else {
            btnNegative.setVisibility(View.VISIBLE);
            btnPositive.setText(positiveBtnText);
        }

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
    }


    @Override
    public void onClick(View v) {
        btnOnClick(v.getId());
    }

    public abstract void btnOnClick(int btnId);

    public void setNegativeButtonIcon(int resId) {
        btnNegative.setImageResource(resId);
        btnNegative.getDrawable().setTint(AppColor.COLOR_THEME);
    }
}