package com.dropo.component;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatImageView;

import com.dropo.utils.AppColor;

public class CustomImageView extends AppCompatImageView {

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
