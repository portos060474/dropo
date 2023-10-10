package com.dropo.store.widgets;

import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;

import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.FontCache;

public class CustomButton extends androidx.appcompat.widget.AppCompatButton {

    public static final String TAG = "CustomButton";

    public CustomButton(Context context) {
        super(context);
    }

    public CustomButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor();
    }

    public CustomButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initColor();
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-Medium.otf", ctx);
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
