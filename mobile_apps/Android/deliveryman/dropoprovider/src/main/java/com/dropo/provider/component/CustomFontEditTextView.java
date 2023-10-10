package com.dropo.provider.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppLog;
import com.google.android.material.textfield.TextInputEditText;

public class CustomFontEditTextView extends TextInputEditText {

    public static final String TAG = "CustomFontEditTextView";
    private Typeface typeface;

    public CustomFontEditTextView(Context context) {
        super(context);
    }

    public CustomFontEditTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
    }

    public CustomFontEditTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context, attrs);
    }

    private void setCustomFont(Context ctx, AttributeSet attrs) {
        @SuppressLint("CustomViewStyleable")
        TypedArray a = ctx.obtainStyledAttributes(attrs, R.styleable.app);
        setCustomFont(ctx);
        a.recycle();
    }

    private void setCustomFont(Context context) {
        try {
            if (typeface == null) {
                typeface = Typeface.createFromAsset(context.getAssets(), "fonts/ClanPro-News.otf");
            }
        } catch (Exception e) {
            AppLog.handleException(TAG, e);
            return;
        }
        setTypeface(typeface);
    }
}