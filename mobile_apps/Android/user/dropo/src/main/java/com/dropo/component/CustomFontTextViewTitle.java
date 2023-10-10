package com.dropo.component;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatTextView;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.FontCache;

public class CustomFontTextViewTitle extends AppCompatTextView {

    public CustomFontTextViewTitle(Context context) {
        super(context);
    }

    public CustomFontTextViewTitle(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor(context, attrs);
    }

    public CustomFontTextViewTitle(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initColor(context, attrs);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-Medium.otf", ctx);
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