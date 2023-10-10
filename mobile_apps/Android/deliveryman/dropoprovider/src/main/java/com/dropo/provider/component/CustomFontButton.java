package com.dropo.provider.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;

public class CustomFontButton extends androidx.appcompat.widget.AppCompatButton {

    public static final String TAG = "CustomFontButton";
    private Typeface typeface;

    public CustomFontButton(Context context) {
        super(context);
    }

    public CustomFontButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
        initColor();
    }

    public CustomFontButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context, attrs);
        initColor();
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
                typeface = Typeface.createFromAsset(ctx.getAssets(), "fonts/ClanPro-News.otf");
            }
        } catch (Exception e) {
            AppLog.handleException(TAG, e);
            return;
        }

        setTypeface(typeface);
    }

    private void initColor() {
        customDrawable(AppColor.COLOR_THEME);
    }

    private void customDrawable(int colorCode) {
        if (getBackground() instanceof GradientDrawable) {
            GradientDrawable gradientDrawable = (GradientDrawable) getBackground();
            gradientDrawable.setColor(colorCode);
            setBackground(gradientDrawable);
        }
    }
}