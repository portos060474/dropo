package com.dropo.component.tag;

import static com.dropo.component.tag.TagView.INVALID_VALUE;
import static com.dropo.component.tag.TagView.SHAPE_RECT;
import static com.dropo.component.tag.TagView.SHAPE_ROUND_RECT;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Paint;
import android.graphics.PathEffect;
import android.graphics.RectF;
import android.text.TextUtils;
import android.text.method.ArrowKeyMovementMethod;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.ViewParent;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;

import com.dropo.component.tag.utils.MeasureUtils;


public class TagEditView extends androidx.appcompat.widget.AppCompatTextView {

    private final PathEffect mPathEffect = new DashPathEffect(new float[]{10, 5}, 0);
    private final int mTagShape = SHAPE_ROUND_RECT;
    private Paint mBorderPaint;
    private RectF mRect;
    private float mBorderWidth;
    private float mRadius;
    private int mBorderColor;
    private int mHorizontalPadding;
    private int mVerticalPadding;

    public TagEditView(Context context) {
        super(context);
        _init(context);
    }

    public TagEditView(Context context, AttributeSet attrs) {
        super(context, attrs);
        _init(context);
    }

    private void _init(Context context) {
        mHorizontalPadding = (int) MeasureUtils.dp2px(context, 5f);
        mVerticalPadding = (int) MeasureUtils.dp2px(context, 5f);
        setPadding(mHorizontalPadding, mVerticalPadding, mHorizontalPadding, mVerticalPadding);
        mRect = new RectF();
        mBorderColor = Color.parseColor("#ff333333");
        mBorderPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mBorderPaint.setStyle(Paint.Style.STROKE);
        mBorderPaint.setColor(mBorderColor);
        mBorderWidth = MeasureUtils.dp2px(context, 0.5f);
        mRadius = MeasureUtils.dp2px(context, 5f);
        setGravity(Gravity.CENTER);
        _initEditMode();
    }

    @Override
    protected boolean getDefaultEditable() {
        return true;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        mRect.set(mBorderWidth, mBorderWidth, w - mBorderWidth, h - mBorderWidth);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        ViewParent parent = getParent();
        if (parent instanceof TagLayout) {
            int fitTagNum = ((TagLayout) getParent()).getFitTagNum();
            if (fitTagNum != INVALID_VALUE) {
                int availableWidth = ((TagLayout) getParent()).getAvailableWidth();
                int horizontalInterval = ((TagLayout) getParent()).getHorizontalInterval();
                int fitWidth = (availableWidth - (fitTagNum - 1) * horizontalInterval) / fitTagNum;
                widthMeasureSpec = MeasureSpec.makeMeasureSpec(fitWidth, MeasureSpec.EXACTLY);
            }
        }
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        float radius = mRadius;
        if (mTagShape == TagView.SHAPE_ARC) {
            radius = mRect.height() / 2;
        } else if (mTagShape == SHAPE_RECT) {
            radius = 0;
        }
        canvas.drawRoundRect(mRect, radius, radius, mBorderPaint);
        super.onDraw(canvas);
    }

    private void _initEditMode() {
        setClickable(true);
        setFocusable(true);
        setFocusableInTouchMode(true);
        setHint("添加标签");
        mBorderPaint.setPathEffect(mPathEffect);
        setHintTextColor(Color.parseColor("#ffaaaaaa"));
        setMovementMethod(ArrowKeyMovementMethod.getInstance());
        requestFocus();
        setOnEditorActionListener(new OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_NULL && (event != null && event.getKeyCode() == KeyEvent.KEYCODE_ENTER && event.getAction() == KeyEvent.ACTION_DOWN)) {
                    if (!TextUtils.isEmpty(getText())) {
                        ((TagLayout) getParent()).addTag(getText().toString());
                        setText("");
                        _closeSoftInput();
                    }
                    return true;
                }
                return false;
            }
        });
    }

    public void exitEditMode() {
        clearFocus();
        setFocusable(false);
        setFocusableInTouchMode(false);
        setHint(null);
        setMovementMethod(null);
        _closeSoftInput();
    }

    private void _closeSoftInput() {
        InputMethodManager inputMethodManager = (InputMethodManager) getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        if (inputMethodManager.isActive()) {
            inputMethodManager.hideSoftInputFromWindow(getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    public void setBorderColor(int borderColor) {
        mBorderColor = borderColor;
        mBorderPaint.setColor(mBorderColor);
    }

    public void setBorderWidth(float borderWidth) {
        mBorderWidth = borderWidth;
    }

    public void setRadius(float radius) {
        mRadius = radius;
    }

    public void setHorizontalPadding(int horizontalPadding) {
        mHorizontalPadding = horizontalPadding;
        setPadding(mHorizontalPadding, mVerticalPadding, mHorizontalPadding, mVerticalPadding);
    }

    public void setVerticalPadding(int verticalPadding) {
        mVerticalPadding = verticalPadding;
        setPadding(mHorizontalPadding, mVerticalPadding, mHorizontalPadding, mVerticalPadding);
    }

    @Override
    public void setTextColor(int color) {
        super.setTextColor(color);
        setHintTextColor(color);
    }

    public void updateView() {
        requestLayout();
        invalidate();
    }
}
