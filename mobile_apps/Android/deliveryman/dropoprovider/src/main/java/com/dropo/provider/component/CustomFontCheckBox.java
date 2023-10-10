package com.dropo.provider.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.util.AttributeSet;

import androidx.core.content.res.ResourcesCompat;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;


public class CustomFontCheckBox extends androidx.appcompat.widget.AppCompatCheckBox {

    public static final String TAG = "CustomFontTextView";
    private Typeface typeface;

    public CustomFontCheckBox(Context context) {
        super(context);
    }

    public CustomFontCheckBox(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context, attrs);
        initColor(context);
    }

    public CustomFontCheckBox(Context context, AttributeSet attrs, int defStyle) {
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