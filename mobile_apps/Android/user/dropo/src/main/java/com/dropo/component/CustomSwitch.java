package com.dropo.component;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.appcompat.widget.SwitchCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.graphics.ColorUtils;
import androidx.core.graphics.drawable.DrawableCompat;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.FontCache;

public class CustomSwitch extends SwitchCompat {

    public CustomSwitch(Context context) {
        super(context);
    }

    public CustomSwitch(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor(context);
    }

    public CustomSwitch(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initColor(context);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
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