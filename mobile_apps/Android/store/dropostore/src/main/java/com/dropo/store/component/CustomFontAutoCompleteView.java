package com.dropo.store.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;

import com.dropo.store.R;
import com.dropo.store.utils.FontCache;


public class CustomFontAutoCompleteView extends androidx.appcompat.widget.AppCompatAutoCompleteTextView {

    public static final String TAG = "CustomFontEditTextView";

    public CustomFontAutoCompleteView(Context context) {
        super(context);
    }

    public CustomFontAutoCompleteView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setCustomFont(context);
        initAttrs(context, attrs);
    }

    public CustomFontAutoCompleteView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setCustomFont(context);
        initAttrs(context, attrs);
    }

    private void setCustomFont(Context ctx) {
        Typeface typeface = FontCache.INSTANCE.get("fonts/ClanPro-News.otf", ctx);
        setTypeface(typeface);
    }

    void initAttrs(Context context, AttributeSet attrs) {
        if (attrs != null) {
            @SuppressLint("CustomViewStyleable")
            TypedArray attributeArray = context.obtainStyledAttributes(attrs, R.styleable.CustomView);

            Drawable drawableLeft;
            Drawable drawableRight;
            Drawable drawableBottom;
            Drawable drawableTop;
            drawableLeft = attributeArray.getDrawable(R.styleable.CustomView_drawableLeftCompat);
            drawableRight = attributeArray.getDrawable(R.styleable.CustomView_drawableRightCompat);
            drawableBottom = attributeArray.getDrawable(R.styleable.CustomView_drawableBottomCompat);
            drawableTop = attributeArray.getDrawable(R.styleable.CustomView_drawableTopCompat);
            setCompoundDrawablesRelativeWithIntrinsicBounds(drawableLeft, drawableTop, drawableRight, drawableBottom);
            attributeArray.recycle();
        }
    }
}