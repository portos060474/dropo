package com.dropo.store.widgets;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;

import com.dropo.store.utils.FontCache;

public class CustomEditText extends androidx.appcompat.widget.AppCompatEditText {
    public static final String TAG = "CustomEditText";

    public CustomEditText(Context context) {
        super(context);
    }

    public CustomEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
    }

    public CustomEditText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }
}