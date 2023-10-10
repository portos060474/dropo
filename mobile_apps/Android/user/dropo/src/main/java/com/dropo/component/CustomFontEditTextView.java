package com.dropo.component;

import android.content.Context;
import android.util.AttributeSet;

import com.google.android.material.textfield.TextInputEditText;

public class CustomFontEditTextView extends TextInputEditText {
    
    public CustomFontEditTextView(Context context) {
        super(context);
    }

    public CustomFontEditTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomFontEditTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }
}