package com.dropo.component;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.PorterDuff;
import android.graphics.drawable.LayerDrawable;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatRatingBar;

import com.dropo.user.R;
import com.dropo.utils.AppColor;

public class CustomRatingBar extends AppCompatRatingBar {

    public CustomRatingBar(Context context) {
        super(context);
    }

    public CustomRatingBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        initColor(context, attrs);
    }

    public CustomRatingBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initColor(context, attrs);
    }

    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomRatingBar);
        int textColor = typedArray.getInteger(R.styleable.CustomRatingBar_appRatingBarColor, -1);
        typedArray.recycle();
        if (textColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            LayerDrawable stars = (LayerDrawable) getProgressDrawable();
            stars.getDrawable(1).setColorFilter(AppColor.COLOR_THEME, PorterDuff.Mode.SRC_ATOP);
            stars.getDrawable(2).setColorFilter(AppColor.COLOR_THEME, PorterDuff.Mode.SRC_ATOP);
        }
    }
}