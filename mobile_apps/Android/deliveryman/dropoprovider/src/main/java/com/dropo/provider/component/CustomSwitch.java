package com.dropo.provider.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.core.content.res.ResourcesCompat;
import androidx.core.graphics.ColorUtils;
import androidx.core.graphics.drawable.DrawableCompat;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppColor;

public class CustomSwitch extends androidx.appcompat.widget.SwitchCompat {

    public static final String TAG = "CustomRadioButton";
    private Typeface typeface;

    public CustomSwitch(Context context) {
        super(context);
    }

    public CustomSwitch(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
        initColor(context);
    }

    public CustomSwitch(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context, attrs);
        initColor(context);
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
            return;
        }
        setTypeface(typeface);
    }

    private void initColor(Context context) {
        int uncheckedColor = ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_light, null);
        setSwitchColor(uncheckedColor, AppColor.COLOR_THEME);
    }

    public void setSwitchColor(int uncheckedColor, int checkedColor) {
        int alphaUncheckedColor = ColorUtils.setAlphaComponent(uncheckedColor, 127);
        int alphaCheckedColor = ColorUtils.setAlphaComponent(checkedColor, 127);
        int[][] states = new int[][]{new int[]{-android.R.attr.state_checked}, new int[]{android.R.attr.state_checked},};

        int[] thumbColors = new int[]{uncheckedColor, checkedColor,};

        int[] trackColors = new int[]{alphaUncheckedColor, alphaCheckedColor,};

        DrawableCompat.setTintList(DrawableCompat.wrap(getThumbDrawable()), new ColorStateList(states, thumbColors));
        DrawableCompat.setTintList(DrawableCompat.wrap(getTrackDrawable()), new ColorStateList(states, trackColors));
    }
}