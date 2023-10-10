package com.dropo.store.widgets;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.dropo.store.utils.FontCache;
import com.google.android.material.textfield.TextInputEditText;

public class CustomInputEditText extends TextInputEditText {

    public static final String TAG = "CustomInputEditText";

    public CustomInputEditText(Context context) {
        super(context);
    }

    public CustomInputEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
    }

    public CustomInputEditText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }
}