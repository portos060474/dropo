package com.dropo.store.widgets;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.FontCache;

public class CustomCheckBox extends androidx.appcompat.widget.AppCompatCheckBox {

    public static final String TAG = "CustomRadioButton";

    public CustomCheckBox(Context context) {
        super(context);
    }

    public CustomCheckBox(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initColor(context);
    }

    public CustomCheckBox(Context context, AttributeSet attrs, int defStyle) {
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
        setCheckBoxColor(uncheckedColor, AppColor.COLOR_THEME);
    }

    public void setCheckBoxColor(int uncheckedColor, int checkedColor) {
        ColorStateList colorStateList = new ColorStateList(new int[][]{new int[]{-android.R.attr.state_checked}, // unchecked
                new int[]{android.R.attr.state_checked}  // checked
        }, new int[]{uncheckedColor, checkedColor});
        setButtonTintList(colorStateList);
    }
}
