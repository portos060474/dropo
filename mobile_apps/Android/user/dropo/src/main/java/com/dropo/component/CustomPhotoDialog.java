package com.dropo.component;

import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.dropo.user.R;
import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class CustomPhotoDialog extends BottomSheetDialog implements View.OnClickListener {

    private final TextView tvCamera;
    private final TextView tvGallery;
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
        tvCamera.setCompoundDrawables(null, null, null, null);
        tvGallery.setCompoundDrawables(null, null, null, null);
        tvGallery.setOnClickListener(this);
        tvCamera.setOnClickListener(this);
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