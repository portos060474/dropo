package com.dropo.store.widgets;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.FontCache;


public class CustomTextView extends androidx.appcompat.widget.AppCompatTextView {

    public static final String TAG = "CustomTextView";
    public static final int BOLD = 1;
    public static final int NORMAL = 0;

    public CustomTextView(Context context) {
        super(context);
    }

    public CustomTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initAttrs(context, attrs);
        initColor(context, attrs);
    }

    public CustomTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initAttrs(context, attrs);
        initColor(context, attrs);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }

    void initAttrs(Context context, AttributeSet attrs) {
        if (attrs != null) {
            @SuppressLint("CustomViewStyleable")
            TypedArray attributeArray = context.obtainStyledAttributes(attrs, R.styleable.CustomView);
            TypedArray attributeArray2 = context.obtainStyledAttributes(attrs, R.styleable.CustomTextView);
            int drawableColor = attributeArray2.getInteger(R.styleable.CustomTextView_appDrawableColor, -1);
            Drawable drawableLeft;
            Drawable drawableRight;
            Drawable drawableBottom;
            Drawable drawableTop;
            drawableLeft = attributeArray.getDrawable(R.styleable.CustomView_drawableLeftCompat);
            drawableRight = attributeArray.getDrawable(R.styleable.CustomView_drawableRightCompat);
            drawableBottom = attributeArray.getDrawable(R.styleable.CustomView_drawableBottomCompat);
            drawableTop = attributeArray.getDrawable(R.styleable.CustomView_drawableTopCompat);

            setCompoundDrawablesRelativeWithIntrinsicBounds(drawableLeft, drawableTop, drawableRight, drawableBottom);
            Drawable[] drawables = getCompoundDrawablesRelative();
            for (Drawable drawable : drawables) {
                setDrawableThemeColor(context, drawableColor, drawable);
            }
            attributeArray.recycle();
            attributeArray2.recycle();
        }
    }

    private void initColor(Context context, AttributeSet attributes) {
        TypedArray typedArray = context.obtainStyledAttributes(attributes, R.styleable.CustomTextView);
        int textColor = typedArray.getInteger(R.styleable.CustomTextView_appTextColor, -1);
        int textBgColor = typedArray.getInteger(R.styleable.CustomTextView_appBackgroundColor, -1);
        int textStrokeColor = typedArray.getInteger(R.styleable.CustomTextView_appBackgroundStrokeColor, -1);
        int strokeWidth = typedArray.getDimensionPixelSize(R.styleable.CustomTextView_appBackgroundStroke, context.getResources().getDimensionPixelSize(R.dimen.app_divider_size));
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