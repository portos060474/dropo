package com.dropo.provider.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;

public class CustomFontTextViewTitle extends androidx.appcompat.widget.AppCompatTextView {

    public static final String TAG = "CustomFontTextViewTitle";
    private Typeface typeface;

    public CustomFontTextViewTitle(Context context) {
        super(context);
    }

    public CustomFontTextViewTitle(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
        initColor(context, attrs);
    }

    public CustomFontTextViewTitle(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context, attrs);
        initColor(context, attrs);
    }

    private void setCustomFont(Context ctx, AttributeSet attrs) {
        @SuppressLint("CustomViewStyleable")
        TypedArray a = ctx.obtainStyledAttributes(attrs, R.styleable.app);
        setCustomFont(ctx);
        a.recycle();
    }

    private void setCustomFont(Context ctx) {
        try {
            if (typeface == null) {
                typeface = Typeface.createFromAsset(ctx.getAssets(), "fonts/ClanPro-Medium.otf");
            }

        } catch (Exception e) {
            AppLog.handleException(TAG, e);
            return;
        }

        setTypeface(typeface);
    }

    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomFontTextViewTitle);
        int textColor = typedArray.getInteger(R.styleable.CustomFontTextViewTitle_appTextColorTitle, -1);
        typedArray.recycle();
        if (textColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            setTextColor(AppColor.COLOR_THEME);
        }
    }
}