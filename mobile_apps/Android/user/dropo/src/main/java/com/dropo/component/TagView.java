package com.dropo.component;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class TagView extends RelativeLayout {
    //use dp and sp, not px

    //----------------- separator TagView-----------------//
    public static final float DEFAULT_LINE_MARGIN = 5;
    public static final float DEFAULT_TAG_MARGIN = 5;
    public static final float DEFAULT_TAG_TEXT_PADDING_LEFT = 8;
    public static final float DEFAULT_TAG_TEXT_PADDING_TOP = 5;
    public static final float DEFAULT_TAG_TEXT_PADDING_RIGHT = 8;
    public static final float DEFAULT_TAG_TEXT_PADDING_BOTTOM = 5;
    public static final float LAYOUT_WIDTH_OFFSET = 2;

    private final Context context;
    /**
     * view size param
     */
    private final int mWidth;
    /**
     * tag list
     */
    private List<String> mTags = new ArrayList<>();
    private List<String> previousSelectedTag;
    /**
     * System Service
     */
    private LayoutInflater mInflater;
    /**
     * listeners
     */
    private OnTagClickListener mClickListener;
    /**
     * layout initialize flag
     */
    private boolean mInitialized = false;

    /**
     * custom layout param
     */
    private int lineMargin;
    private int tagMargin;
    private int textPaddingLeft;
    private int textPaddingRight;
    private int textPaddingTop;
    private int textPaddingBottom;


    /**
     * constructor
     *
     * @param ctx ctx
     */
    public TagView(Context ctx) {
        super(ctx, null);
        context = ctx;
        mWidth = getMaxWidth(context);
        initialize(ctx, null, 0);
    }

    /**
     * constructor
     *
     * @param ctx   ctx
     * @param attrs attrs
     */
    public TagView(Context ctx, AttributeSet attrs) {
        super(ctx, attrs);
        context = ctx;
        mWidth = getMaxWidth(context);
        initialize(ctx, attrs, 0);
    }

    /**
     * constructor
     *
     * @param ctx      ctx
     * @param attrs    attrs
     * @param defStyle defStyle
     */
    public TagView(Context ctx, AttributeSet attrs, int defStyle) {
        super(ctx, attrs, defStyle);
        context = ctx;
        mWidth = getMaxWidth(context);
        initialize(ctx, attrs, defStyle);
    }

    /**
     * initalize instance
     *
     * @param ctx      ctx
     * @param attrs    attrs
     * @param defStyle defStyle
     */
    private void initialize(Context ctx, AttributeSet attrs, int defStyle) {
        mInflater = (LayoutInflater) ctx.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        ViewTreeObserver mViewTreeObserber = getViewTreeObserver();
        mViewTreeObserber.addOnGlobalLayoutListener(() -> {
            if (!mInitialized) {
                mInitialized = true;
                drawTags();
                if (previousSelectedTag != null && !previousSelectedTag.isEmpty()) {
                    initSelectedTags(previousSelectedTag);
                }
            }
        });

        // get AttributeSet
        TypedArray typeArray = ctx.obtainStyledAttributes(attrs, R.styleable.TagView, defStyle, defStyle);
        this.lineMargin = (int) typeArray.getDimension(R.styleable.TagView_lineMargin, Utils.dipToPx(this.getContext(), DEFAULT_LINE_MARGIN));
        this.tagMargin = (int) typeArray.getDimension(R.styleable.TagView_tagMargin, Utils.dipToPx(this.getContext(), DEFAULT_TAG_MARGIN));
        this.textPaddingLeft = (int) typeArray.getDimension(R.styleable.TagView_textPaddingLeft, Utils.dipToPx(this.getContext(), DEFAULT_TAG_TEXT_PADDING_LEFT));
        this.textPaddingRight = (int) typeArray.getDimension(R.styleable.TagView_textPaddingRight, Utils.dipToPx(this.getContext(), DEFAULT_TAG_TEXT_PADDING_RIGHT));
        this.textPaddingTop = (int) typeArray.getDimension(R.styleable.TagView_textPaddingTop, Utils.dipToPx(this.getContext(), DEFAULT_TAG_TEXT_PADDING_TOP));
        this.textPaddingBottom = (int) typeArray.getDimension(R.styleable.TagView_textPaddingBottom, Utils.dipToPx(this.getContext(), DEFAULT_TAG_TEXT_PADDING_BOTTOM));
        typeArray.recycle();
    }

    /**
     * onSizeChanged
     *
     * @param w         w
     * @param h         h
     * @param oldWidth  oldWidth
     * @param oldHeight oldHeight
     */
    @Override
    protected void onSizeChanged(int w, int h, int oldWidth, int oldHeight) {
        super.onSizeChanged(w, h, oldWidth, oldHeight);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawTags();
    }

    /**
     * tag draw
     */
    private void drawTags() {
        if (!mInitialized) {
            return;
        }

        // clear all tag
        removeAllViews();

        // layout padding left & layout padding right
        int total = getPaddingLeft() + getPaddingRight();

        int listIndex = 1;// List Index
        int indexBottom = 1;// The Tag to add below
        int indexHeader = 1;// The header tag of this line
        String tagPre = null;
        for (String item : mTags) {
            final int position = listIndex - 1;

            // inflate tag layout
            View tagLayout = mInflater.inflate(R.layout.item_tag, null);
            tagLayout.setId(listIndex);

            // tag text
            TextView tagView = tagLayout.findViewById(R.id.tv_tag_item_contain);
            tagView.setText(item);
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) tagView.getLayoutParams();
            params.setMargins(textPaddingLeft, textPaddingTop, textPaddingRight, textPaddingBottom);
            tagView.setLayoutParams(params);

            tagLayout.setOnClickListener(v -> {
                if (mClickListener != null) {
                    mClickListener.onTagClick(v, position);
                }
            });

            tagLayout.setOnLongClickListener(v -> true);

            // calculate　of tag layout width
            float tagWidth = tagView.getPaint().measureText(item) + textPaddingLeft + textPaddingRight;
            // tagView padding (left & right)

            LayoutParams tagParams = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);

            //add margin of each line
            tagParams.bottomMargin = lineMargin;

            if (mWidth - tagWidth <= total + tagWidth + Utils.dipToPx(this.getContext(), LAYOUT_WIDTH_OFFSET)) {
                //need to add in new line
                if (tagPre != null) {
                    tagParams.addRule(RelativeLayout.BELOW, indexBottom);
                }
                // initialize total param (layout padding left & layout padding right)
                total = getPaddingLeft() + getPaddingRight();
                indexBottom = listIndex;
                indexHeader = listIndex;
            } else {
                //no need to new line
                tagParams.addRule(RelativeLayout.ALIGN_TOP, indexHeader);
                //not header of the line
                if (listIndex != indexHeader) {
                    tagParams.addRule(RelativeLayout.RIGHT_OF, listIndex - 1);
                    tagParams.leftMargin = tagMargin;
                    total += tagMargin;
                    if (tagPre != null && tagPre.length() < item.length()) {
                        indexBottom = listIndex;
                    }
                }
            }
            total += tagWidth;
            addView(tagLayout, tagParams);
            tagPre = item;
            listIndex++;
        }
    }


    //public methods
    //----------------- separator  -----------------//

    /**
     * @param tag tag
     */
    public void addTag(String tag) {
        mTags.add(tag);
        drawTags();
    }

    public void addTags(List<String> tags) {
        if (tags == null) {
            return;
        }
        mTags = new ArrayList<>();
        if (tags.isEmpty()) {
            drawTags();
        }
        mTags.addAll(tags);
        drawTags();
    }

    public void addTags(String[] tags) {
        if (tags == null) {
            return;
        }
        Collections.addAll(mTags, tags);
        drawTags();
    }


    /**
     * get tag list
     *
     * @return mTags TagObject List
     */
    public List<String> getTags() {
        return mTags;
    }

    /**
     * remove tag
     *
     * @param position position
     */
    public void remove(int position) {
        if (position < mTags.size()) {
            mTags.remove(position);
            drawTags();
        }
    }

    /**
     * remove all views
     */
    public void removeAll() {
        mTags.clear(); //clear all of tags
        removeAllViews();
    }

    public int getLineMargin() {
        return lineMargin;
    }

    public void setLineMargin(float lineMargin) {
        this.lineMargin = Utils.dipToPx(getContext(), lineMargin);
    }

    public int getTagMargin() {
        return tagMargin;
    }

    public void setTagMargin(float tagMargin) {
        this.tagMargin = Utils.dipToPx(getContext(), tagMargin);
    }

    public int getTextPaddingLeft() {
        return textPaddingLeft;
    }

    public void setTextPaddingLeft(float textPaddingLeft) {
        this.textPaddingLeft = Utils.dipToPx(getContext(), textPaddingLeft);
    }

    public int getTextPaddingRight() {
        return textPaddingRight;
    }

    public void setTextPaddingRight(float textPaddingRight) {
        this.textPaddingRight = Utils.dipToPx(getContext(), textPaddingRight);
    }

    public int getTextPaddingTop() {
        return textPaddingTop;
    }

    public void setTextPaddingTop(float textPaddingTop) {
        this.textPaddingTop = Utils.dipToPx(getContext(), textPaddingTop);
    }

    public int getTextPaddingBottom() {
        return textPaddingBottom;
    }

    public void setTextPaddingBottom(float textPaddingBottom) {
        this.textPaddingBottom = Utils.dipToPx(getContext(), textPaddingBottom);
    }

    /**
     * setter for OnTagSelectListener
     *
     * @param clickListener clickListener
     */
    public void setOnTagClickListener(OnTagClickListener clickListener) {
        mClickListener = clickListener;
    }

    private int getMaxWidth(Context context) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        return displayMetrics.widthPixels;
    }

    public void clearSelected() {
        if (getChildCount() > 1) {
            for (int i = 0; i < getChildCount(); i++) {
                LinearLayout linearLayout = (LinearLayout) getChildAt(i);
                CustomFontTextView textView = (CustomFontTextView) linearLayout.getChildAt(0);
                textView.setBackground(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_stroke, context.getTheme()));
                textView.setTextColor(AppColor.getThemeTextColor(getContext()));
            }
        }
    }

    private void initSelectedTags(List<String> selectedTag) {
        if (getChildCount() > 1) {
            for (int i = 0; i < getChildCount(); i++) {
                LinearLayout linearLayout = (LinearLayout) getChildAt(i);
                CustomFontTextView textView = (CustomFontTextView) linearLayout.getChildAt(0);
                if (selectedTag.contains(textView.getText().toString())) {
                    textView.setBackground(getDrawableWithColor(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_fill, null), AppColor.COLOR_THEME));
                    textView.setTextColor(ResourcesCompat.getColor(getContext().getResources(), R.color.color_white, context.getTheme()));
                }
            }
        }

    }

    public void setSelect(View v, boolean isSelect) {
        if (isSelect) {
            LinearLayout linearLayout = (LinearLayout) v;
            CustomFontTextView textView = (CustomFontTextView) linearLayout.getChildAt(0);
            textView.setBackground(getDrawableWithColor(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_fill, null), AppColor.COLOR_THEME));
            textView.setTextColor(ResourcesCompat.getColor(getContext().getResources(), R.color.color_white, context.getTheme()));
        } else {
            LinearLayout linearLayout = (LinearLayout) v;
            CustomFontTextView textView = (CustomFontTextView) linearLayout.getChildAt(0);
            textView.setBackground(ResourcesCompat.getDrawable(getContext().getResources(), R.drawable.shape_filter_button_stroke, context.getTheme()));
            textView.setTextColor(AppColor.getThemeTextColor(getContext()));
        }
    }

    private Drawable getDrawableWithColor(Drawable drawable, int colorCode) {
        if (drawable instanceof GradientDrawable) {
            GradientDrawable gradientDrawable = (GradientDrawable) drawable;
            gradientDrawable.setColor(colorCode);
        }
        return drawable;
    }

    public void setPreviousSelectedTag(List<String> previousSelectedTag) {
        this.previousSelectedTag = previousSelectedTag;
    }

    public interface OnTagClickListener {
        void onTagClick(View v, int position);
    }
}