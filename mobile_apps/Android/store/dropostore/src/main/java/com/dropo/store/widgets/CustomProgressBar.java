package com.dropo.store.widgets;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.widget.ProgressBar;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;

public class CustomProgressBar extends ProgressBar {

    public static final String TAG = "CustomRatingBar";

    public CustomProgressBar(Context context) {
        super(context);
    }

    public CustomProgressBar(Context context, AttributeSet attrs) {
        super(context, attrs);
        initColor(context, attrs);
    }

    public CustomProgressBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initColor(context, attrs);
    }

    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomProgressBar);
        int textColor = typedArray.getInteger(R.styleable.CustomProgressBar_appProgressBarColor, -1);
        typedArray.recycle();
        if (textColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            setProgressTintList(ColorStateList.valueOf(AppColor.COLOR_THEME));
        }
    }
}