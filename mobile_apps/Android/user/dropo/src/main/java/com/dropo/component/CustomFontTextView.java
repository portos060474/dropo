package com.dropo.component;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;


import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.FontCache;

public class CustomFontTextView extends androidx.appcompat.widget.AppCompatTextView {

    public static final int BOLD = 1;
    public static final int NORMAL = 0;

    public CustomFontTextView(Context context) {
        super(context);
    }

    public CustomFontTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor(context, attrs);
    }

    public CustomFontTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initColor(context, attrs);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }

    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomFontTextView);
        int textColor = typedArray.getInteger(R.styleable.CustomFontTextView_appTextColor, -1);
        int textBgColor = typedArray.getInteger(R.styleable.CustomFontTextView_appBackgroundColor, -1);
        int textStrokeColor = typedArray.getInteger(R.styleable.CustomFontTextView_appBackgroundStrokeColor, -1);
        int strokeWidth = typedArray.getDimensionPixelSize(R.styleable.CustomFontTextView_appBackgroundStroke, context.getResources().getDimensionPixelSize(R.dimen.app_divider_size));
        typedArray.recycle();
        if (textColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            setTextColor(AppColor.COLOR_THEME);
        }
        if (textBgColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            customDrawable(AppColor.COLOR_THEME);
        }
        if (textStrokeColor == context.getResources().getInteger(R.integer.appThemeColor)) {
            customStrokeDrawable(AppColor.COLOR_THEME, strokeWidth);
        }
    }

    private void setDrawableThemeColor(Context context, int color, Drawable drawable) {
        if (drawable != null && color == context.getResources().getInteger(R.integer.appThemeColor)) {
            drawable.setTint(AppColor.COLOR_THEME);
        }
    }

    public void setFontStyle(Context context, int style) {
        Typeface typeface = FontCache.INSTANCE.get(style == NORMAL ? "fonts/ClanPro-News.otf" : "fonts/ClanPro-Medium.otf", context);
        setTypeface(typeface);
    }

    private void customDrawable(int colorCode) {
        if (getBackground() instanceof GradientDrawable) {
            GradientDrawable gradientDrawable = (GradientDrawable) getBackground();
            gradientDrawable.setTint(colorCode);
            setBackground(gradientDrawable);
        }
    }

    private void customStrokeDrawable(int colorCode, int stroke) {
        if (getBackground() instanceof GradientDrawable) {
            GradientDrawable gradientDrawable = (GradientDrawable) getBackground();
            gradientDrawable.setStroke(stroke, colorCode);
            setBackground(gradientDrawable);
        }
    }
}