package com.dropo.store.component;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;


import com.dropo.store.R;
import com.google.android.material.bottomsheet.BottomSheetDialog;

public abstract class CustomPhotoDialog extends BottomSheetDialog implements View.OnClickListener {

    public CustomPhotoDialog(Context context) {
        super(context);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_select_picture);
        findViewById(R.id.btnNegative).setOnClickListener(view -> dismiss());
        findViewById(R.id.tvCamera).setOnClickListener(this);
        findViewById(R.id.tvGallery).setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
    }

    @Override
    public void onClick(View v) {
        if (R.id.tvGallery == v.getId()) {
            dismiss();
            gallery();
        } else if (R.id.tvCamera == v.getId()) {
            dismiss();
            camera();
        }
    }

    public abstract void gallery();

    public abstract void camera();
}