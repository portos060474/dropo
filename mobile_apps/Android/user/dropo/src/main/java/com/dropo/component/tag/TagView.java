package com.dropo.component.tag;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.RectF;
import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;
import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewParent;

import androidx.annotation.IntDef;
import androidx.core.view.MotionEventCompat;

import com.dropo.user.R;
import com.dropo.component.tag.drawable.RotateDrawable;
import com.dropo.component.tag.utils.MeasureUtils;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


public class TagView extends View {

    public final static int INVALID_VALUE = -1;

    public final static int SHAPE_ROUND_RECT = 101;
    public final static int SHAPE_ARC = 102;
    public final static int SHAPE_RECT = 103;
    public final static int MODE_NORMAL = 201;
    public final static int MODE_EDIT = 202;
    public final static int MODE_CHANGE = 203;
    public final static int MODE_SINGLE_CHOICE = 204;
    public final static int MODE_MULTI_CHOICE = 205;
    public final static int MODE_ICON_CHECK_INVISIBLE = 206;
    public final static int MODE_ICON_CHECK_CHANGE = 207;
    private int mTagShape = SHAPE_ROUND_RECT;
    private int mTagMode = MODE_NORMAL;
    private Paint mPaint;
    private int mBgColor = Color.WHITE;
    private int mBorderColor = Color.parseColor("#ff333333");
    private int mTextColor = Color.parseColor("#ff666666");
    private int mBgColorChecked = Color.WHITE;
    private int mBorderColorChecked = Color.parseColor("#ff333333");
    private int mTextColorChecked = Color.parseColor("#ff666666");
    private int mScrimColor = Color.argb(0x66, 0xc0, 0xc0, 0xc0);
    private float mTextSize;
    private int mFontLen;
    private int mFontH;
    private int mFontLenChecked;
    private float mBaseLineDistance;
    private float mBorderWidth;
    private float mRadius;
    private String mText;
    private String mTextChecked;
    private String mShowText;
    private int mHorizontalPadding;
    private int mVerticalPadding;
    private RectF mRect;
    private Drawable mDecorateIcon;
    private Drawable mDecorateIconChange;
    private int mIconGravity = Gravity.LEFT;
    private int mIconPadding = 0;
    private int mIconSize = 0;
    private boolean mIsChecked = false;
    private boolean mIsAutoToggleCheck = false;
    private boolean mIsPressed = false;
    private boolean mIsPressFeedback = false;
    private OnTagClickListener mTagClickListener;
    private OnTagLongClickListener mTagLongClickListener;
    private OnTagCheckListener mTagCheckListener;

    public TagView(Context context) {
        super(context);
        _init(context, null);
    }

    public TagView(Context context, String text) {
        this(context);
        mText = text;
    }


    public TagView(Context context, AttributeSet attrs) {
        super(context, attrs);
        _init(context, attrs);
    }

    private void _init(Context context, AttributeSet attrs) {
        mBorderWidth = MeasureUtils.dp2px(context, 0.5f);
        mRadius = MeasureUtils.dp2px(context, 5f);
        mHorizontalPadding = (int) MeasureUtils.dp2px(context, 5f);
        mVerticalPadding = (int) MeasureUtils.dp2px(context, 5f);
        mIconPadding = (int) MeasureUtils.dp2px(context, 3f);
        mTextSize = MeasureUtils.dp2px(context, 14f);
        if (attrs != null) {
            final TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TagView);
            try {
                mTagShape = a.getInteger(R.styleable.TagView_tag_shape, TagView.SHAPE_ROUND_RECT);
                mTagMode = a.getInteger(R.styleable.TagView_tag_mode, MODE_NORMAL);
                if (mTagMode == MODE_SINGLE_CHOICE || mTagMode == MODE_ICON_CHECK_INVISIBLE || mTagMode == MODE_ICON_CHECK_CHANGE) {
                    mIsAutoToggleCheck = true;
                    mIsChecked = a.getBoolean(R.styleable.TagView_tag_checked, false);
                    mDecorateIconChange = a.getDrawable(R.styleable.TagView_tag_icon_change);
                }
                mIsAutoToggleCheck = a.getBoolean(R.styleable.TagView_tag_auto_check, mIsAutoToggleCheck);
                mIsPressFeedback = a.getBoolean(R.styleable.TagView_tag_press_feedback, mIsPressFeedback);

                mText = a.getString(R.styleable.TagView_tag_text);
                mTextChecked = a.getString(R.styleable.TagView_tag_text_check);
                mTextSize = a.getDimension(R.styleable.TagView_tag_text_size, mTextSize);
                mBgColor = a.getColor(R.styleable.TagView_tag_bg_color, Color.WHITE);
                mBorderColor = a.getColor(R.styleable.TagView_tag_border_color, Color.parseColor("#ff333333"));
                mTextColor = a.getColor(R.styleable.TagView_tag_text_color, Color.parseColor("#ff666666"));
                mBgColorChecked = a.getColor(R.styleable.TagView_tag_bg_color_check, mBgColor);
                mBorderColorChecked = a.getColor(R.styleable.TagView_tag_border_color_check, mBorderColor);
                mTextColorChecked = a.getColor(R.styleable.TagView_tag_text_color_check, mTextColor);
                mBorderWidth = a.getDimension(R.styleable.TagView_tag_border_width, mBorderWidth);
                mRadius = a.getDimension(R.styleable.TagView_tag_border_radius, mRadius);
                mHorizontalPadding = (int) a.getDimension(R.styleable.TagView_tag_horizontal_padding, mHorizontalPadding);
                mVerticalPadding = (int) a.getDimension(R.styleable.TagView_tag_vertical_padding, mVerticalPadding);
                mIconPadding = (int) a.getDimension(R.styleable.TagView_tag_icon_padding, mIconPadding);
                mDecorateIcon = a.getDrawable(R.styleable.TagView_tag_icon);
                mIconGravity = a.getInteger(R.styleable.TagView_tag_gravity, Gravity.LEFT);
            } finally {
                a.recycle();
            }
        }

        if (mTagMode == MODE_ICON_CHECK_CHANGE && mDecorateIconChange == null) {
            throw new RuntimeException("You must set the drawable by 'tag_icon_change' property in MODE_ICON_CHECK_CHANGE mode");
        }
        if (mDecorateIcon != null) {
            mDecorateIcon.setCallback(this);
        }
        if (mDecorateIconChange != null) {
            mDecorateIconChange.setColorFilter(mTextColorChecked, PorterDuff.Mode.SRC_IN);
            mDecorateIconChange.setCallback(this);
        }
        mRect = new RectF();
        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        setClickable(true);
        if (!isSaveEnabled()) {
            setSaveEnabled(true);
        }

        setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mTagClickListener != null) {
                    mTagClickListener.onTagClick(getTag() == null ? 0 : (int) getTag(), mText, mTagMode);
                }
            }
        });
        setOnLongClickListener(new OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                if (mTagLongClickListener != null) {
                    mTagLongClickListener.onTagLongClick(getTag() == null ? 0 : (int) getTag(), mText, mTagMode);
                }
                return true;
            }
        });
    }

    private int _adjustText(int maxWidth) {
        if (mPaint.getTextSize() != mTextSize) {
            mPaint.setTextSize(mTextSize);
            final Paint.FontMetrics fontMetrics = mPaint.getFontMetrics();
            mFontH = (int) (fontMetrics.descent - fontMetrics.ascent);
            mBaseLineDistance = (int) Math.ceil((fontMetrics.descent - fontMetrics.ascent) / 2 - fontMetrics.descent);
        }
        if (TextUtils.isEmpty(mText)) {
            mText = "";
        }
        mFontLen = (int) mPaint.measureText(mText);
        if (TextUtils.isEmpty(mTextChecked)) {
            mFontLenChecked = mFontLen;
        } else {
            mFontLenChecked = (int) mPaint.measureText(mTextChecked);
        }
        if ((mDecorateIcon != null || mDecorateIconChange != null) && mIconSize != mFontH) {
            mIconSize = mFontH;
        }
        int allPadding;
        if (mTagMode == MODE_ICON_CHECK_CHANGE && mIsChecked) {
            allPadding = mIconPadding + mIconSize + mHorizontalPadding * 2;
        } else if (mDecorateIcon != null) {
            allPadding = (mTagMode == MODE_ICON_CHECK_INVISIBLE && mIsChecked) ? mHorizontalPadding * 2 : mIconPadding + mIconSize + mHorizontalPadding * 2;
        } else {
            allPadding = mHorizontalPadding * 2;
        }
        String showText = (mIsChecked && !TextUtils.isEmpty(mTextChecked)) ? mTextChecked : mText;
        if (mIsChecked && mFontLenChecked + allPadding > maxWidth) {
            float pointWidth = mPaint.measureText(".");
            float maxTextWidth = maxWidth - allPadding - pointWidth * 3;
            mShowText = _clipShowText(showText, mPaint, maxTextWidth);
            mFontLenChecked = (int) mPaint.measureText(mShowText);
        } else if (!mIsChecked && mFontLen + allPadding > maxWidth) {
            float pointWidth = mPaint.measureText(".");
            float maxTextWidth = maxWidth - allPadding - pointWidth * 3;
            mShowText = _clipShowText(showText, mPaint, maxTextWidth);
            mFontLen = (int) mPaint.measureText(mShowText);
        } else {
            mShowText = showText;
        }

        return allPadding;
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

        int allPadding = _adjustText(MeasureSpec.getSize(widthMeasureSpec));
        int fontLen = mIsChecked ? mFontLenChecked : mFontLen;
        int width = (MeasureSpec.getMode(widthMeasureSpec) == MeasureSpec.EXACTLY) ? MeasureSpec.getSize(widthMeasureSpec) : allPadding + fontLen;
        int height = (MeasureSpec.getMode(heightMeasureSpec) == MeasureSpec.EXACTLY) ? MeasureSpec.getSize(heightMeasureSpec) : mVerticalPadding * 2 + mFontH;
        setMeasuredDimension(width, height);
        if (mDecorateIcon != null || mDecorateIconChange != null) {
            int top = (height - mIconSize) / 2;
            int left;
            if (mIconGravity == Gravity.RIGHT) {
                int padding = (width - mIconSize - fontLen - mIconPadding) / 2;
                left = width - padding - mIconSize;
            } else {
                left = (width - mIconSize - fontLen - mIconPadding) / 2;
            }
            if (mTagMode == MODE_ICON_CHECK_CHANGE && mIsChecked && mDecorateIconChange != null) {
                mDecorateIconChange.setBounds(left, top, mIconSize + left, mIconSize + top);
            } else if (mDecorateIcon != null) {
                mDecorateIcon.setBounds(left, top, mIconSize + left, mIconSize + top);
            }
        }
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        mRect.set(mBorderWidth, mBorderWidth, w - mBorderWidth, h - mBorderWidth);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        // 圆角
        float radius = mRadius;
        if (mTagShape == SHAPE_ARC) {
            radius = mRect.height() / 2;
        } else if (mTagShape == SHAPE_RECT) {
            radius = 0;
        }
        final boolean isChecked = (mIsPressed && mIsPressFeedback) || mIsChecked;
        mPaint.setStyle(Paint.Style.FILL);
        if (isChecked) {
            mPaint.setColor(mBgColorChecked);
        } else {
            mPaint.setColor(mBgColor);
        }
        canvas.drawRoundRect(mRect, radius, radius, mPaint);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(mBorderWidth);
        if (isChecked) {
            mPaint.setColor(mBorderColorChecked);
        } else {
            mPaint.setColor(mBorderColor);
        }
        canvas.drawRoundRect(mRect, radius, radius, mPaint);
        mPaint.setStyle(Paint.Style.FILL);
        if (isChecked) {
            mPaint.setColor(mTextColorChecked);
            int padding = (mTagMode == MODE_ICON_CHECK_INVISIBLE && mIsChecked) ? 0 : mIconSize + mIconPadding;
            int fontLen = mIsChecked ? mFontLenChecked : mFontLen;
            canvas.drawText(mShowText, mIconGravity == Gravity.RIGHT ? (getWidth() - fontLen - padding) / 2f : (getWidth() - fontLen - padding) / 2f + padding, getHeight() / 2f + mBaseLineDistance, mPaint);
        } else {
            mPaint.setColor(mTextColor);
            int padding = mDecorateIcon == null ? 0 : mIconSize + mIconPadding;
            canvas.drawText(mShowText, mIconGravity == Gravity.RIGHT ? (getWidth() - mFontLen - padding) / 2f : (getWidth() - mFontLen - padding) / 2f + padding, getHeight() / 2f + mBaseLineDistance, mPaint);
        }
        if (mTagMode == MODE_ICON_CHECK_CHANGE && mIsChecked && mDecorateIconChange != null) {
            mDecorateIconChange.draw(canvas);
        } else if (mTagMode == MODE_ICON_CHECK_INVISIBLE && mIsChecked) {
            // Don't need to draw
        } else if (mDecorateIcon != null) {
            mDecorateIcon.setColorFilter(mPaint.getColor(), PorterDuff.Mode.SRC_IN);
            mDecorateIcon.draw(canvas);
        }
        if (mIsPressed && (mIsChecked || !mIsPressFeedback)) {
            mPaint.setColor(mScrimColor);
            canvas.drawRoundRect(mRect, radius, radius, mPaint);
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        if (mDecorateIcon != null && mDecorateIcon instanceof Animatable) {
            ((Animatable) mDecorateIcon).stop();
            mDecorateIcon.setCallback(null);
        }
        if (mDecorateIconChange != null && mDecorateIconChange instanceof Animatable) {
            ((Animatable) mDecorateIconChange).stop();
            mDecorateIconChange.setCallback(null);
        }
        super.onDetachedFromWindow();
    }

    @Override
    public void invalidateDrawable(Drawable drawable) {
        if ((mDecorateIcon != null && mDecorateIcon instanceof Animatable) || (mDecorateIconChange != null && mDecorateIconChange instanceof Animatable)) {
            postInvalidate();
        } else {
            super.invalidateDrawable(drawable);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (MotionEventCompat.getActionMasked(event)) {
            case MotionEvent.ACTION_DOWN:
                mIsPressed = true;
                invalidate();
                break;
            case MotionEvent.ACTION_MOVE:
                if (mIsPressed && !_isViewUnder(event.getX(), event.getY())) {
                    mIsPressed = false;
                    invalidate();
                }
                break;
            case MotionEvent.ACTION_UP:
                if (_isViewUnder(event.getX(), event.getY())) {
                    _toggleTagCheckStatus();
                }
            case MotionEvent.ACTION_CANCEL:
                if (mIsPressed) {
                    mIsPressed = false;
                    invalidate();
                }
                break;
        }
        return super.onTouchEvent(event);
    }

    private boolean _isViewUnder(float x, float y) {
        return x >= 0 && x < getWidth() && y >= 0 && y < getHeight();
    }

    private void _toggleTagCheckStatus() {
        if (mIsAutoToggleCheck) {
            setChecked(!mIsChecked);
        }
    }

    public boolean isChecked() {
        return mIsChecked;
    }

    public void setChecked(boolean checked) {
        _setTagCheckStatus(checked);
        if (mTagCheckListener != null) {
            mTagCheckListener.onTagCheck(getTag() == null ? 0 : (int) getTag(), mText, mIsChecked);
        }
    }

    public void cleanTagCheckStatus() {
        _setTagCheckStatus(false);
    }

    private void _setTagCheckStatus(boolean isChecked) {
        if (mIsChecked == isChecked) {
            return;
        }
        mIsChecked = isChecked;
        updateView();
    }

    private String _clipShowText(String oriText, Paint paint, float maxTextWidth) {
        float tmpWidth = 0;
        StringBuilder strBuilder = new StringBuilder();
        for (int i = 0; i < oriText.length(); i++) {
            char c = oriText.charAt(i);
            float cWidth = paint.measureText(String.valueOf(c));
            if (tmpWidth + cWidth > maxTextWidth) {
                break;
            }
            strBuilder.append(c);
            tmpWidth += cWidth;
        }
        strBuilder.append("...");
        return strBuilder.toString();
    }

    public int getTagShape() {
        return mTagShape;
    }

    public void setTagShape(int tagShape) {
        mTagShape = tagShape;
        updateView();
    }

    public void setTagShapeLazy(int tagShape) {
        mTagShape = tagShape;
    }

    public int getTagMode() {
        return mTagMode;
    }

    public void setTagMode(int tagMode) {
        mTagMode = tagMode;
        if (mTagMode == MODE_CHANGE) {
            Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.ic_change);
            mDecorateIcon = new RotateDrawable(bitmap);
            mDecorateIcon.setCallback(this);
        }
        updateView();
    }

    public void setTagModeLazy(int tagMode) {
        mTagMode = tagMode;
        if (mTagMode == MODE_SINGLE_CHOICE || mTagMode == MODE_MULTI_CHOICE) {
            setPressFeedback(true);
            mIsAutoToggleCheck = true;
        } else if (mTagMode == MODE_CHANGE) {
            Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.ic_change);
            mDecorateIcon = new RotateDrawable(bitmap);
            mDecorateIcon.setCallback(this);
        }
    }

    public int getBgColor() {
        return mBgColor;
    }

    public void setBgColor(int bgColor) {
        mBgColor = bgColor;
        invalidate();
    }

    public void setBgColorLazy(int bgColor) {
        mBgColor = bgColor;
    }

    public int getBorderColor() {
        return mBorderColor;
    }

    public void setBorderColor(int borderColor) {
        mBorderColor = borderColor;
        invalidate();
    }

    public void setBorderColorLazy(int borderColor) {
        mBorderColor = borderColor;
    }

    public int getTextColor() {
        return mTextColor;
    }

    public void setTextColor(int textColor) {
        mTextColor = textColor;
        invalidate();
    }

    public void setTextColorLazy(int textColor) {
        mTextColor = textColor;
    }

    public int getBgColorChecked() {
        return mBgColorChecked;
    }

    public void setBgColorChecked(int bgColorChecked) {
        mBgColorChecked = bgColorChecked;
        invalidate();
    }

    public void setBgColorCheckedLazy(int bgColorChecked) {
        mBgColorChecked = bgColorChecked;
    }

    public int getBorderColorChecked() {
        return mBorderColorChecked;
    }

    public void setBorderColorChecked(int borderColorChecked) {
        mBorderColorChecked = borderColorChecked;
        invalidate();
    }

    public void setBorderColorCheckedLazy(int borderColorChecked) {
        mBorderColorChecked = borderColorChecked;
    }

    public int getTextColorChecked() {
        return mTextColorChecked;
    }

    public void setTextColorChecked(int textColorChecked) {
        mTextColorChecked = textColorChecked;
        if (mDecorateIconChange != null) {
            mDecorateIconChange.setColorFilter(mTextColorChecked, PorterDuff.Mode.SRC_IN);
        }
        invalidate();
    }

    public void setTextColorCheckedLazy(int textColorChecked) {
        mTextColorChecked = textColorChecked;
        if (mDecorateIconChange != null) {
            mDecorateIconChange.setColorFilter(mTextColorChecked, PorterDuff.Mode.SRC_IN);
        }
    }

    public int getScrimColor() {
        return mScrimColor;
    }

    public void setScrimColor(int scrimColor) {
        mScrimColor = scrimColor;
        invalidate();
    }

    public void setScrimColorLazy(int scrimColor) {
        mScrimColor = scrimColor;
    }

    public float getTextSize() {
        return mTextSize;
    }

    public void setTextSize(float textSize) {
        mTextSize = textSize;
        updateView();
    }

    public void setTextSizeLazy(float textSize) {
        mTextSize = textSize;
    }

    public float getBorderWidth() {
        return mBorderWidth;
    }

    public void setBorderWidth(float borderWidth) {
        mBorderWidth = borderWidth;
        invalidate();
    }

    public void setBorderWidthLazy(float borderWidth) {
        mBorderWidth = borderWidth;
    }

    public float getRadius() {
        return mRadius;
    }

    public void setRadius(float radius) {
        mRadius = radius;
        invalidate();
    }

    public void setRadiusLazy(float radius) {
        mRadius = radius;
    }

    public String getText() {
        return mText;
    }

    public void setText(String text) {
        mText = text;
        updateView();
    }

    public void setTextLazy(String text) {
        mText = text;
    }

    public String getTextChecked() {
        return mTextChecked;
    }

    public void setTextChecked(String textChecked) {
        mTextChecked = textChecked;
        updateView();
    }

    public void setTextCheckedLazy(String textChecked) {
        mTextChecked = textChecked;
    }

    public int getHorizontalPadding() {
        return mHorizontalPadding;
    }

    public void setHorizontalPadding(int horizontalPadding) {
        mHorizontalPadding = horizontalPadding;
        updateView();
    }

    public void setHorizontalPaddingLazy(int horizontalPadding) {
        mHorizontalPadding = horizontalPadding;
    }

    public int getVerticalPadding() {
        return mVerticalPadding;
    }

    public void setVerticalPadding(int verticalPadding) {
        mVerticalPadding = verticalPadding;
        updateView();
    }

    public void setVerticalPaddingLazy(int verticalPadding) {
        mVerticalPadding = verticalPadding;
    }

    public Drawable getDecorateIcon() {
        return mDecorateIcon;
    }

    public void setDecorateIcon(Drawable decorateIcon) {
        mDecorateIcon = decorateIcon;
        mDecorateIcon.setCallback(this);
        updateView();
    }

    public void setDecorateIconLazy(Drawable decorateIcon) {
        mDecorateIcon = decorateIcon;
        mDecorateIcon.setCallback(this);
    }

    public Drawable getDecorateIconChange() {
        return mDecorateIconChange;
    }

    public void setDecorateIconChange(Drawable decorateIconChange) {
        mDecorateIconChange = decorateIconChange;
        mDecorateIconChange.setColorFilter(mTextColorChecked, PorterDuff.Mode.SRC_IN);
        mDecorateIconChange.setCallback(this);
        updateView();
    }

    public void setDecorateIconChangeLazy(Drawable decorateIconChange) {
        mDecorateIconChange = decorateIconChange;
        mDecorateIconChange.setColorFilter(mTextColorChecked, PorterDuff.Mode.SRC_IN);
        mDecorateIconChange.setCallback(this);
    }

    public int getIconPadding() {
        return mIconPadding;
    }

    public void setIconPadding(int iconPadding) {
        mIconPadding = iconPadding;
        updateView();
    }

    public void setIconPaddingLazy(int iconPadding) {
        mIconPadding = iconPadding;
    }

    public boolean isAutoToggleCheck() {
        return mIsAutoToggleCheck;
    }

    public void setAutoToggleCheck(boolean autoToggleCheck) {
        mIsAutoToggleCheck = autoToggleCheck;
    }

    public boolean isPressFeedback() {
        return mIsPressFeedback;
    }

    public void setPressFeedback(boolean pressFeedback) {
        mIsPressFeedback = pressFeedback;
    }

    public void updateView() {
        requestLayout();
        invalidate();
    }

    public OnTagClickListener getTagClickListener() {
        return mTagClickListener;
    }

    public void setTagClickListener(OnTagClickListener tagClickListener) {
        mTagClickListener = tagClickListener;
    }

    public OnTagLongClickListener getTagLongClickListener() {
        return mTagLongClickListener;
    }

    public void setTagLongClickListener(OnTagLongClickListener tagLongClickListener) {
        mTagLongClickListener = tagLongClickListener;
    }

    public OnTagCheckListener getTagCheckListener() {
        return mTagCheckListener;
    }

    public void setTagCheckListener(OnTagCheckListener tagCheckListener) {
        mTagCheckListener = tagCheckListener;
    }

    @Override
    public Parcelable onSaveInstanceState() {
        Parcelable superState = super.onSaveInstanceState();
        SavedState state = new SavedState(superState);
        state.isChecked = mIsChecked;
        return state;
    }

    @Override
    public void onRestoreInstanceState(Parcelable state) {
        if (!(state instanceof SavedState)) {
            super.onRestoreInstanceState(state);
            return;
        }
        SavedState ss = (SavedState) state;
        super.onRestoreInstanceState(ss.getSuperState());
        mIsChecked = ss.isChecked;
    }


    @IntDef({SHAPE_ROUND_RECT, SHAPE_ARC, SHAPE_RECT})
    @Retention(RetentionPolicy.SOURCE)
    @Target(ElementType.PARAMETER)
    public @interface TagShape {
    }

    @IntDef({MODE_NORMAL, MODE_EDIT, MODE_CHANGE, MODE_SINGLE_CHOICE, MODE_MULTI_CHOICE, MODE_ICON_CHECK_INVISIBLE, MODE_ICON_CHECK_CHANGE})
    @Retention(RetentionPolicy.SOURCE)
    @Target(ElementType.PARAMETER)
    public @interface TagMode {
    }

    public interface OnTagClickListener {
        void onTagClick(int position, String text, @TagMode int tagMode);
    }


    public interface OnTagLongClickListener {
        void onTagLongClick(int position, String text, @TagMode int tagMode);
    }

    public interface OnTagCheckListener {
        void onTagCheck(int position, String text, boolean isChecked);
    }

    public static class SavedState extends BaseSavedState {

        @SuppressWarnings("hiding")
        public static final Creator<SavedState> CREATOR = new Creator<SavedState>() {
            public SavedState createFromParcel(Parcel in) {
                return new SavedState(in);
            }

            public SavedState[] newArray(int size) {
                return new SavedState[size];
            }
        };
        boolean isChecked;

        public SavedState(Parcelable superState) {
            super(superState);
        }

        private SavedState(Parcel in) {
            super(in);
            isChecked = in.readInt() == 1;
        }

        @Override
        public void writeToParcel(Parcel out, int flags) {
            super.writeToParcel(out, flags);
            out.writeInt(isChecked ? 1 : 0);
        }
    }
}
