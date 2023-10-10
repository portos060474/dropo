package com.dropo.provider.component;

import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.dropo.provider.R;
import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class CustomPhotoDialog extends BottomSheetDialog implements View.OnClickListener {

    private final CustomFontTextView tvCamera;
    private final CustomFontTextView tvGallery;
    private final TextView tvPhotoDialogTitle;

    public CustomPhotoDialog(Context context, String title) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_choose_picture);
        tvPhotoDialogTitle = findViewById(R.id.tvPhotoDialogTitle);
        tvPhotoDialogTitle.setText(title);
        tvCamera = findViewById(R.id.tvCamera);
        tvGallery = findViewById(R.id.tvGallery);
        tvGallery.setOnClickListener(this);
        tvCamera.setOnClickListener(this);

        findViewById(R.id.btnNegative).setOnClickListener(view -> dismiss());
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
    }

    public CustomPhotoDialog(Context context, String title, String textOne, String textTwo) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_choose_picture);
        tvPhotoDialogTitle = findViewById(R.id.tvPhotoDialogTitle);
        tvPhotoDialogTitle.setText(title);
        tvCamera = findViewById(R.id.tvCamera);
        tvGallery = findViewById(R.id.tvGallery);
        tvCamera.setText(textOne);
        tvGallery.setText(textTwo);
        tvGallery.setOnClickListener(this);
        tvCamera.setOnClickListener(this);
        tvGallery.setCompoundDrawablesRelativeWithIntrinsicBounds(null, null, null, null);
        tvCamera.setCompoundDrawablesRelativeWithIntrinsicBounds(null, null, null, null);
        findViewById(R.id.btnNegative).setOnClickListener(view -> dismiss());
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.tvCamera) {
            clickedOnCamera();
        } else if (id == R.id.tvGallery) {
            clickedOnGallery();
        }
    }

    public abstract void clickedOnCamera();

    public abstract void clickedOnGallery();
}