package com.dropo.store.widgets;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

import com.dropo.store.utils.AppColor;

public class CustomImageView extends androidx.appcompat.widget.AppCompatImageView {

    public static final String TAG = "CustomTextView";

    public CustomImageView(Context context) {
        super(context);
    }

    public CustomImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initColor();
    }

    public CustomImageView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initColor();
    }


    private void initColor() {
        customDrawable(AppColor.COLOR_THEME);
    }

    private void customDrawable(int colorCode) {
        if (getDrawable() != null) {
            Drawable drawable = getDrawable();
            drawable.setTint(colorCode);
            setImageDrawable(drawable);
        }
    }
}
