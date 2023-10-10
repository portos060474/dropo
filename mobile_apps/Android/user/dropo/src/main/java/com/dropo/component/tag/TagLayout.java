package com.dropo.component.tag;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.SparseBooleanArray;
import android.view.View;
import android.view.ViewGroup;

import androidx.core.content.ContextCompat;

import com.dropo.user.R;
import com.dropo.component.tag.utils.ColorsFactory;
import com.dropo.component.tag.utils.MeasureUtils;
import com.dropo.utils.AppColor;

import java.util.ArrayList;
import java.util.List;


public class TagLayout extends ViewGroup {

    private final List<TagView> mTagViews = new ArrayList<>();
    private final SparseBooleanArray mCheckSparseArray = new SparseBooleanArray();
    private Paint mPaint;
    private int mBgColor;
    private int mBorderColor;
    private float mBorderWidth;
    private float mRadius;
    private int mVerticalInterval;
    private int mHorizontalInterval;
    private RectF mRect;
    private int mAvailableWidth;
    private int mTagBgColor;
    private int mTagBorderColor;
    private int mTagTextColor;
    private int mTagBgColorCheck;
    private int mTagBorderColorCheck;
    private int mTagTextColorCheck;
    private float mTagBorderWidth;
    private float mTagTextSize;
    private float mTagRadius;
    private int mTagHorizontalPadding;
    private int mTagVerticalPadding;
    private TagView.OnTagClickListener mTagClickListener;
    private TagView.OnTagLongClickListener mTagLongClickListener;
    private TagView.OnTagCheckListener mTagCheckListener;
    private TagView.OnTagCheckListener mInsideTagCheckListener;
    private int mTagShape;
    private int mFitTagNum;
    private int mIconPadding;
    private boolean mIsPressFeedback;
    private int mTagMode;
    private TagView mFitTagView;
    private TagEditView mFitTagEditView;
    private boolean mEnableRandomColor;
    private boolean mIsHorizontalReverse;


    public TagLayout(Context context) {
        this(context, null);
    }

    public TagLayout(Context context, AttributeSet attrs) {
        this(context, attrs, -1);
    }

    public TagLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        _init(context, attrs, defStyleAttr);
    }

    private void _init(Context context, AttributeSet attrs, int defStyleAttr) {
        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mRect = new RectF();
        mTagTextSize = MeasureUtils.sp2px(context, 13.0f);

        final TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TagLayout);
        try {
            mTagMode = a.getInteger(R.styleable.TagLayout_tag_layout_mode, TagView.MODE_NORMAL);
            mTagShape = a.getInteger(R.styleable.TagLayout_tag_layout_shape, TagView.SHAPE_ROUND_RECT);
            mIsPressFeedback = a.getBoolean(R.styleable.TagLayout_tag_layout_press_feedback, false);
            mEnableRandomColor = a.getBoolean(R.styleable.TagLayout_tag_layout_random_color, false);
            mFitTagNum = a.getInteger(R.styleable.TagLayout_tag_layout_fit_num, TagView.INVALID_VALUE);
            mBgColor = a.getColor(R.styleable.TagLayout_tag_layout_bg_color, Color.WHITE);
            mBorderColor = a.getColor(R.styleable.TagLayout_tag_layout_border_color, Color.WHITE);
            mBorderWidth = a.getDimension(R.styleable.TagLayout_tag_layout_border_width, MeasureUtils.dp2px(context, 0.5f));
            mRadius = a.getDimension(R.styleable.TagLayout_tag_layout_border_radius, MeasureUtils.dp2px(context, 5f));
            mHorizontalInterval = (int) a.getDimension(R.styleable.TagLayout_tag_layout_horizontal_interval, MeasureUtils.dp2px(context, 5f));
            mVerticalInterval = (int) a.getDimension(R.styleable.TagLayout_tag_layout_vertical_interval, MeasureUtils.dp2px(context, 5f));

            mTagBgColor = a.getColor(R.styleable.TagLayout_tag_view_bg_color, Color.WHITE);
            mTagBorderColor = a.getColor(R.styleable.TagLayout_tag_view_border_color, Color.parseColor("#ff333333"));
            mTagTextColor = a.getColor(R.styleable.TagLayout_tag_view_text_color, Color.parseColor("#ff666666"));
            if (mIsPressFeedback || mTagMode == TagView.MODE_SINGLE_CHOICE || mTagMode == TagView.MODE_MULTI_CHOICE || mTagMode == TagView.MODE_NORMAL) {
                mTagBgColorCheck = AppColor.COLOR_THEME;
                mTagBorderColorCheck = AppColor.COLOR_THEME;
                mTagTextColorCheck = a.getColor(R.styleable.TagLayout_tag_view_text_color_check, Color.WHITE);
            } else {
                mTagBgColorCheck = AppColor.COLOR_THEME;
                mTagBorderColorCheck = a.getColor(R.styleable.TagLayout_tag_view_border_color_check, mTagBorderColor);
                mTagTextColorCheck = a.getColor(R.styleable.TagLayout_tag_view_text_color_check, mTagTextColor);
            }
            mTagBorderWidth = a.getDimension(R.styleable.TagLayout_tag_view_border_width, MeasureUtils.dp2px(context, 0.5f));
            mTagTextSize = a.getDimension(R.styleable.TagLayout_tag_view_text_size, mTagTextSize);
            mTagRadius = a.getDimension(R.styleable.TagLayout_tag_view_border_radius, MeasureUtils.dp2px(context, 5f));
            mTagHorizontalPadding = (int) a.getDimension(R.styleable.TagLayout_tag_view_horizontal_padding, MeasureUtils.dp2px(context, 5f));
            mTagVerticalPadding = (int) a.getDimension(R.styleable.TagLayout_tag_view_vertical_padding, MeasureUtils.dp2px(context, 5f));
            mIconPadding = (int) a.getDimension(R.styleable.TagLayout_tag_view_icon_padding, MeasureUtils.dp2px(context, 3f));
            mIsHorizontalReverse = a.getBoolean(R.styleable.TagLayout_tag_layout_horizontal_reverse, false);
        } finally {
            a.recycle();
        }
        setWillNotDraw(false);
        setPadding(mHorizontalInterval, mVerticalInterval, mHorizontalInterval, mVerticalInterval);
        if (mTagMode == TagView.MODE_CHANGE) {
            mFitTagView = _initTagView("换一换", TagView.MODE_CHANGE);
            addView(mFitTagView);
        } else if (mTagMode == TagView.MODE_EDIT) {
            _initTagEditView();
            addView(mFitTagEditView);
        } else if (mTagMode == TagView.MODE_SINGLE_CHOICE || mTagMode == TagView.MODE_MULTI_CHOICE) {
            mIsPressFeedback = false;
            mInsideTagCheckListener = new TagView.OnTagCheckListener() {
                @Override
                public void onTagCheck(int position, String text, boolean isChecked) {
                    if (mTagCheckListener != null) {
                        mTagCheckListener.onTagCheck(position, text, isChecked);
                    }
                    for (int i = 0; i < mTagViews.size(); i++) {
                        if (mTagViews.get(i).getText().equals(text)) {
                            mCheckSparseArray.put(i, isChecked);
                        } else if (mTagMode == TagView.MODE_SINGLE_CHOICE && mCheckSparseArray.get(i)) {
                            mTagViews.get(i).cleanTagCheckStatus();
                            mCheckSparseArray.put(i, false);
                        }
                    }
                }
            };
        }
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        int widthSpecSize = MeasureSpec.getSize(widthMeasureSpec);
        int heightSpecSize = MeasureSpec.getSize(heightMeasureSpec);
        int heightSpecMode = MeasureSpec.getMode(heightMeasureSpec);
        mAvailableWidth = widthSpecSize - getPaddingLeft() - getPaddingRight();
        measureChildren(widthMeasureSpec, heightMeasureSpec);
        int childCount = getChildCount();
        int tmpWidth = 0;
        int measureHeight = 0;
        int maxLineHeight = 0;
        for (int i = 0; i < childCount; i++) {
            View child = getChildAt(i);
            if (maxLineHeight == 0) {
                maxLineHeight = child.getMeasuredHeight();
            } else {
                maxLineHeight = Math.max(maxLineHeight, child.getMeasuredHeight());
            }
            tmpWidth += child.getMeasuredWidth() + mHorizontalInterval;
            if (tmpWidth - mHorizontalInterval > mAvailableWidth) {
                measureHeight += maxLineHeight + mVerticalInterval;
                tmpWidth = child.getMeasuredWidth() + mHorizontalInterval;
                maxLineHeight = child.getMeasuredHeight();
            }
        }
        measureHeight += maxLineHeight;

        if (childCount == 0) {
            setMeasuredDimension(0, 0);
        } else if (heightSpecMode == MeasureSpec.UNSPECIFIED || heightSpecMode == MeasureSpec.AT_MOST) {
            setMeasuredDimension(widthSpecSize, measureHeight + getPaddingTop() + getPaddingBottom());
        } else {
            setMeasuredDimension(widthSpecSize, heightSpecSize);
        }
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        int childCount = getChildCount();
        if (childCount <= 0) {
            return;
        }

        mAvailableWidth = getMeasuredWidth() - getPaddingLeft() - getPaddingRight();
        int curTop = getPaddingTop();
        int curLeft;
        final int maxRight = mAvailableWidth + getPaddingLeft();
        if (mIsHorizontalReverse) {
            curLeft = maxRight;
        } else {
            curLeft = getPaddingLeft();
        }
        int maxHeight = 0;
        for (int i = 0; i < childCount; i++) {
            View child = getChildAt(i);

            if (maxHeight == 0) {
                maxHeight = child.getMeasuredHeight();
            } else {
                maxHeight = Math.max(maxHeight, child.getMeasuredHeight());
            }

            int width = child.getMeasuredWidth();
            int height = child.getMeasuredHeight();
            if (mIsHorizontalReverse) {
                curLeft -= width;
                if (getPaddingLeft() > curLeft) {
                    curLeft = maxRight - width;
                    curLeft = Math.max(curLeft, getPaddingLeft());
                    curTop += maxHeight + mVerticalInterval;
                    maxHeight = child.getMeasuredHeight();
                }
                child.layout(curLeft, curTop, curLeft + width, curTop + height);
                curLeft -= mHorizontalInterval;
            } else {
                if (width + curLeft > maxRight) {
                    curLeft = getPaddingLeft();
                    curTop += maxHeight + mVerticalInterval;
                    maxHeight = child.getMeasuredHeight();
                }
                child.layout(curLeft, curTop, curLeft + width, curTop + height);
                curLeft += width + mHorizontalInterval;
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

        mPaint.setStyle(Paint.Style.FILL);
        mPaint.setColor(mBgColor);
        canvas.drawRoundRect(mRect, mRadius, mRadius, mPaint);
        mPaint.setStyle(Paint.Style.STROKE);
        mPaint.setStrokeWidth(mBorderWidth);
        mPaint.setColor(mBorderColor);
        canvas.drawRoundRect(mRect, mRadius, mRadius, mPaint);
    }

    public int getBgColor() {
        return mBgColor;
    }

    public void setBgColor(int bgColor) {
        mBgColor = bgColor;
    }

    public int getBorderColor() {
        return mBorderColor;
    }

    public void setBorderColor(int borderColor) {
        mBorderColor = borderColor;
    }

    public float getBorderWidth() {
        return mBorderWidth;
    }

    public void setBorderWidth(float borderWidth) {
        mBorderWidth = MeasureUtils.dp2px(getContext(), borderWidth);
    }

    public float getRadius() {
        return mRadius;
    }

    public void setRadius(float radius) {
        mRadius = radius;
    }

    public int getVerticalInterval() {
        return mVerticalInterval;
    }

    public void setVerticalInterval(int verticalInterval) {
        mVerticalInterval = verticalInterval;
    }

    public int getHorizontalInterval() {
        return mHorizontalInterval;
    }

    public void setHorizontalInterval(int horizontalInterval) {
        mHorizontalInterval = horizontalInterval;
    }

    protected int getAvailableWidth() {
        return mAvailableWidth;
    }

    public int getFitTagNum() {
        return mFitTagNum;
    }

    public void setFitTagNum(int fitTagNum) {
        mFitTagNum = fitTagNum;
    }

    private void _initTagEditView() {
        mFitTagEditView = new TagEditView(getContext());
        if (mEnableRandomColor) {
            int[] color = ColorsFactory.provideColor();
            mFitTagEditView.setBorderColor(color[0]);
            mFitTagEditView.setTextColor(color[1]);
        } else {
            mFitTagEditView = new TagEditView(getContext());
            mFitTagEditView.setBorderColor(mTagBorderColor);
            mFitTagEditView.setTextColor(mTagTextColor);
        }
        mFitTagEditView.setBorderWidth(mTagBorderWidth);
        mFitTagEditView.setRadius(mTagRadius);
        mFitTagEditView.setHorizontalPadding(mTagHorizontalPadding);
        mFitTagEditView.setVerticalPadding(mTagVerticalPadding);
        mFitTagEditView.setTextSize(MeasureUtils.px2sp(getContext(), mTagTextSize));
        mFitTagEditView.updateView();
    }

    private TagView _initTagView(String text, @TagView.TagMode int tagMode) {
        TagView tagView = new TagView(getContext(), text);
        if (mEnableRandomColor) {
            _setTagRandomColors(tagView);
        } else {
            tagView.setBgColorLazy(mTagBgColor);
            tagView.setBorderColorLazy(mTagBorderColor);
            tagView.setTextColorLazy(mTagTextColor);
            tagView.setBgColorCheckedLazy(mTagBgColorCheck);
            tagView.setBorderColorCheckedLazy(mTagBorderColorCheck);
            tagView.setTextColorCheckedLazy(mTagTextColorCheck);
        }
        tagView.setBorderWidthLazy(mTagBorderWidth);
        tagView.setRadiusLazy(mTagRadius);
        tagView.setTextSizeLazy(mTagTextSize);
        tagView.setHorizontalPaddingLazy(mTagHorizontalPadding);
        tagView.setVerticalPaddingLazy(mTagVerticalPadding);
        tagView.setPressFeedback(mIsPressFeedback);
        tagView.setTagClickListener(mTagClickListener);
        tagView.setTagLongClickListener(mTagLongClickListener);
        tagView.setTagCheckListener(mInsideTagCheckListener);
        tagView.setTagShapeLazy(mTagShape);
        tagView.setTagModeLazy(tagMode);
        tagView.setIconPaddingLazy(mIconPadding);
        tagView.updateView();
        mTagViews.add(tagView);
        tagView.setTag(mTagViews.size() - 1);
        return tagView;
    }

    private void _setTagRandomColors(TagView tagView) {
        int[] color = ColorsFactory.provideColor();
        if (mIsPressFeedback) {
            tagView.setTextColorLazy(color[1]);
            tagView.setBgColorLazy(Color.WHITE);
            tagView.setBgColorCheckedLazy(color[0]);
            tagView.setBorderColorCheckedLazy(color[0]);
            tagView.setTextColorCheckedLazy(Color.WHITE);
        } else {
            tagView.setBgColorLazy(color[1]);
            tagView.setTextColorLazy(mTagTextColor);
            tagView.setBgColorCheckedLazy(color[1]);
            tagView.setBorderColorCheckedLazy(color[0]);
            tagView.setTextColorCheckedLazy(mTagTextColor);
        }
        tagView.setBorderColorLazy(color[0]);
    }

    public int getTagBgColor() {
        return mTagBgColor;
    }

    public void setTagBgColor(int tagBgColor) {
        mTagBgColor = tagBgColor;
    }

    public int getTagBorderColor() {
        return mTagBorderColor;
    }

    public void setTagBorderColor(int tagBorderColor) {
        mTagBorderColor = tagBorderColor;
    }

    public int getTagTextColor() {
        return mTagTextColor;
    }

    public void setTagTextColor(int tagTextColor) {
        mTagTextColor = tagTextColor;
    }

    public float getTagBorderWidth() {
        return mTagBorderWidth;
    }

    public void setTagBorderWidth(float tagBorderWidth) {
        mTagBorderWidth = MeasureUtils.dp2px(getContext(), tagBorderWidth);
        if (mFitTagView != null) {
            mFitTagView.setBorderWidth(mTagBorderWidth);
        }
    }

    public float getTagTextSize() {
        return mTagTextSize;
    }

    public void setTagTextSize(float tagTextSize) {
        mTagTextSize = tagTextSize;
        if (mFitTagView != null) {
            mFitTagView.setTextSize(tagTextSize);
        }
    }

    public float getTagRadius() {
        return mTagRadius;
    }

    public void setTagRadius(float tagRadius) {
        mTagRadius = tagRadius;
        if (mFitTagView != null) {
            mFitTagView.setRadius(mTagRadius);
        }
    }

    public int getTagHorizontalPadding() {
        return mTagHorizontalPadding;
    }

    public void setTagHorizontalPadding(int tagHorizontalPadding) {
        mTagHorizontalPadding = tagHorizontalPadding;
        if (mFitTagView != null) {
            mFitTagView.setHorizontalPadding(mTagHorizontalPadding);
        }
    }

    public int getTagVerticalPadding() {
        return mTagVerticalPadding;
    }

    public void setTagVerticalPadding(int tagVerticalPadding) {
        mTagVerticalPadding = tagVerticalPadding;
        if (mFitTagView != null) {
            mFitTagView.setVerticalPadding(mTagVerticalPadding);
        }
    }

    public boolean isPressFeedback() {
        return mIsPressFeedback;
    }

    public void setPressFeedback(boolean pressFeedback) {
        mIsPressFeedback = pressFeedback;
        if (mFitTagView != null) {
            mFitTagView.setPressFeedback(mIsPressFeedback);
        }
    }

    public TagView.OnTagClickListener getTagClickListener() {
        return mTagClickListener;
    }

    public void setTagClickListener(TagView.OnTagClickListener tagClickListener) {
        mTagClickListener = tagClickListener;
        for (TagView tagView : mTagViews) {
            tagView.setTagClickListener(mTagClickListener);
        }
    }

    public TagView.OnTagLongClickListener getTagLongClickListener() {
        return mTagLongClickListener;
    }

    public void setTagLongClickListener(TagView.OnTagLongClickListener tagLongClickListener) {
        mTagLongClickListener = tagLongClickListener;
        for (TagView tagView : mTagViews) {
            tagView.setTagLongClickListener(mTagLongClickListener);
        }
    }

    public TagView.OnTagCheckListener getTagCheckListener() {
        return mTagCheckListener;
    }

    public void setTagCheckListener(TagView.OnTagCheckListener tagCheckListener) {
        mTagCheckListener = tagCheckListener;
    }

    public void setTagShape(@TagView.TagShape int tagShape) {
        mTagShape = tagShape;
    }

    public void setEnableRandomColor(boolean enableRandomColor) {
        mEnableRandomColor = enableRandomColor;
    }

    public void setIconPadding(int padding) {
        mIconPadding = padding;
        if (mFitTagView != null) {
            mFitTagView.setIconPadding(mIconPadding);
        }
    }


    public void addTag(String text) {
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            addView(_initTagView(text, TagView.MODE_NORMAL), getChildCount() - 1);
        } else {
            addView(_initTagView(text, mTagMode));
        }
    }

    public void addTagWithIcon(String text, int iconResId) {
        TagView tagView;
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            tagView = _initTagView(text, TagView.MODE_NORMAL);
        } else {
            tagView = _initTagView(text, mTagMode);
        }
        tagView.setDecorateIcon(ContextCompat.getDrawable(getContext(), iconResId));
        tagView.setIconPadding(mIconPadding);
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            addView(tagView, getChildCount() - 1);
        } else {
            addView(tagView);
        }
    }


    private void _refreshPositionTag(int startPos) {
        for (int i = startPos; i < mTagViews.size(); i++) {
            mTagViews.get(i).setTag(i);
        }
    }


    public void deleteTag(int position) {
        if (position < 0 || position >= getChildCount()) {
            return;
        }
        int pos = mTagMode == TagView.MODE_CHANGE ? position + 1 : position;
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            if (position == getChildCount() - 1) {
                return;
            }
            mTagViews.remove(pos);
        } else {
            mTagViews.remove(position);
        }
        removeViewAt(position);
        _refreshPositionTag(position);
    }


    public void addTags(String... textList) {
        for (String text : textList) {
            addTag(text);
        }
    }


    public void addTags(List<String> textList) {
        for (String text : textList) {
            addTag(text);
        }
    }


    public void cleanTags() {
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            removeViews(0, getChildCount() - 1);
            mTagViews.clear();
            mCheckSparseArray.clear();
            mTagViews.add(mFitTagView);
        } else {
            removeAllViews();
            mTagViews.clear();
        }
        postInvalidate();
    }


    public void setTags(String... textList) {
        cleanTags();
        addTags(textList);
    }


    public void setTags(List<String> textList) {
        cleanTags();
        addTags(textList);
    }


    public void updateTags(String... textList) {
        int startPos = 0;
        int minSize;
        if (mTagMode == TagView.MODE_CHANGE || (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null)) {
            startPos = 1;
            minSize = Math.min(textList.length, mTagViews.size() - 1);
        } else {
            minSize = Math.min(textList.length, mTagViews.size());
        }
        for (int i = 0; i < minSize; i++) {
            mTagViews.get(i + startPos).setText(textList[i]);
        }
        if (mEnableRandomColor) {
            startPos = 0;
            if (mTagMode == TagView.MODE_EDIT) {
                startPos = 1;
            }
            for (int i = startPos; i < mTagViews.size(); i++) {
                _setTagRandomColors(mTagViews.get(i));
            }
            postInvalidate();
        }
    }


    public void updateTags(List<String> textList) {
        //updateTags((String[]) textList.toArray());
    }

    public List<String> getCheckedTags() {
        List<String> checkTags = new ArrayList<>();
        for (int i = 0; i < mCheckSparseArray.size(); i++) {
            if (mCheckSparseArray.valueAt(i)) {
                checkTags.add(mTagViews.get(mCheckSparseArray.keyAt(i)).getText());
            }
        }
        return checkTags;
    }

    public List<Integer> getCheckedTagsPosition() {
        List<Integer> checkTags = new ArrayList<>();
        for (int i = 0; i < mCheckSparseArray.size(); i++) {
            if (mCheckSparseArray.valueAt(i)) {
                checkTags.add(mCheckSparseArray.keyAt(i));
            }
        }
        return checkTags;
    }


    public void setCheckTag(String text) {
        if (mTagMode == TagView.MODE_SINGLE_CHOICE) {
            for (TagView tagView : mTagViews) {
                if (tagView.getText().equals(text)) {
                    tagView.setChecked(true);
                }
            }
        }
    }

    public void setCheckTag(int... indexs) {
        if (mTagMode == TagView.MODE_SINGLE_CHOICE) {
            for (int i : indexs) {
                if (mTagViews.get(i) != null) {
                    mTagViews.get(i).setChecked(true);
                }
            }
        }
    }

    public void deleteCheckedTags() {
        for (int i = mCheckSparseArray.size() - 1; i >= 0; i--) {
            if (mCheckSparseArray.valueAt(i)) {
                deleteTag(mCheckSparseArray.keyAt(i));
                mCheckSparseArray.delete(mCheckSparseArray.keyAt(i));
            }
        }
    }


    public void exitEditMode() {
        if (mTagMode == TagView.MODE_EDIT && mFitTagEditView != null) {
            mFitTagEditView.exitEditMode();
            removeViewAt(getChildCount() - 1);
            mFitTagEditView = null;
        }
    }


    public void entryEditMode() {
        if (mTagMode == TagView.MODE_NORMAL || mTagMode == TagView.MODE_EDIT) {
            mTagMode = TagView.MODE_EDIT;
            _initTagEditView();
            addView(mFitTagEditView);
        }
    }

    public void setCheckTag(ArrayList<Integer> checkTags) {
        for (int i : checkTags) {
            if (mTagViews.get(i) != null) {
                mTagViews.get(i).setChecked(true);
            }
        }
    }

    public void setTagMode(int mTagMode) {
        this.mTagMode = mTagMode;
        postInvalidate();
    }
}
