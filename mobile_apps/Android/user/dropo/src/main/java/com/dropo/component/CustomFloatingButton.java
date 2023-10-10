package com.dropo.component;

import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.util.AttributeSet;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class CustomFloatingButton extends FloatingActionButton {

    public CustomFloatingButton(Context context) {
        super(context);
    }

    public CustomFloatingButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        initColor(context, attrs);
    }

    public CustomFloatingButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initColor(context, attrs);
    }


    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomFloatingButton);
        int textColor = typedArray.getInteger(R.styleable.CustomFloatingButton_appFBBackgroundColor, -1);
        typedArray.recycle();
        if (textColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            setBackgroundTintList(ColorStateList.valueOf(AppColor.COLOR_THEME));
        }
    }
}