package com.dropo.store.component;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatRadioButton;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.FontCache;

public class CustomFontRadioButton extends AppCompatRadioButton {

    public static final String TAG = "CustomFontTextView";

    public CustomFontRadioButton(Context context) {
        super(context);
    }

    public CustomFontRadioButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor(context);
    }

    public CustomFontRadioButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }

    private void initColor(Context context) {
        int uncheckedColor = ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_light, null);
        setCheckBoxColor(uncheckedColor, AppColor.COLOR_THEME);
    }

    public void setCheckBoxColor(int uncheckedColor, int checkedColor) {
        ColorStateList colorStateList = new ColorStateList(new int[][]{new int[]{-android.R.attr.state_checked}, // unchecked
                new int[]{android.R.attr.state_checked}  // checked
        }, new int[]{uncheckedColor, checkedColor});
        setButtonTintList(colorStateList);
    }
}