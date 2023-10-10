package com.dropo.component;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;

import androidx.appcompat.widget.AppCompatButton;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.FontCache;

public class CustomFontButton extends AppCompatButton {

    public CustomFontButton(Context context) {
        super(context);
    }

    public CustomFontButton(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initAttrs(context, attrs);
        initColor();
    }

    public CustomFontButton(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initAttrs(context, attrs);
        initColor();
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }

    void initAttrs(Context context, AttributeSet attrs) {
        if (attrs != null) {
            TypedArray attributeArray = context.obtainStyledAttributes(attrs, R.styleable.CustomView);

            Drawable drawableLeft;
            Drawable drawableRight;
            Drawable drawableBottom;
            Drawable drawableTop;
            drawableLeft = attributeArray.getDrawable(R.styleable.CustomView_drawableLeftCompat);
            drawableRight = attributeArray.getDrawable(R.styleable.CustomView_drawableRightCompat);
            drawableBottom = attributeArray.getDrawable(R.styleable.CustomView_drawableBottomCompat);
            drawableTop = attributeArray.getDrawable(R.styleable.CustomView_drawableTopCompat);
            setCompoundDrawablesWithIntrinsicBounds(drawableLeft, drawableTop, drawableRight, drawableBottom);
            attributeArray.recycle();
        }
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