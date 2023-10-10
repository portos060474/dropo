package com.dropo.provider.component;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.util.AttributeSet;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.provider.R;
import com.google.android.material.tabs.TabLayout;

public class BadgeTabLayout extends TabLayout {
    private final SparseArray<Builder> mTabBuilders = new SparseArray<>();

    public BadgeTabLayout(Context context) {
        super(context);
    }

    public BadgeTabLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public BadgeTabLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    private static Drawable getDrawableCompat(Context context, int drawableRes) {
        Drawable drawable = null;
        try {
            if (android.os.Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
                drawable = context.getResources().getDrawable(drawableRes);
            } else {
                drawable = context.getResources().getDrawable(drawableRes, context.getTheme());
            }
        } catch (NullPointerException ex) {
            ex.printStackTrace();
        }
        return drawable;
    }

    /**
     * This format must follow User's badge policy.
     *
     * @param value of current badge
     * @return corresponding badge number. TextView need to be passed by a String/CharSequence
     */
    private static String formatBadgeNumber(int value) {
        if (value < 0) {
            return "-" + formatBadgeNumber(-value);
        }

        if (value <= 10) {
            // equivalent to String#valueOf(int);
            return Integer.toString(value);
        }

        // my own policy
        return "10+";
    }

    public Builder with(int position) {
        Tab tab = getTabAt(position);
        return with(tab);
    }

    /**
     * Apply a builder for this tab.
     *
     * @param tab for which we create a new builder or retrieve its builder if existed.
     * @return the required Builder.
     */
    public Builder with(Tab tab) {
        if (tab == null) {
            throw new IllegalArgumentException("Tab must not be null");
        }

        Builder builder = mTabBuilders.get(tab.getPosition());
        if (builder == null) {
            builder = new Builder(this, tab);
            mTabBuilders.put(tab.getPosition(), builder);
        }

        return builder;
    }

    public static final class Builder {

        /**
         * This badge widget must not support this value.
         */
        private static final int INVALID_NUMBER = Integer.MIN_VALUE;

        @Nullable
        final View mView;
        final Context mContext;
        final TabLayout.Tab mTab;
        @Nullable
        TextView mBadgeTextView;
        @Nullable
        TextView mTitleText;
        Integer mIconColorFilter;
        int mBadgeCount = Integer.MIN_VALUE;

        boolean mHasBadge = false;

        /**
         * This construct take a TabLayout parent to have its context and other attributes sets. And
         * the tab whose icon will be updated.
         *
         * @param parent
         * @param tab
         */
        private Builder(TabLayout parent, @NonNull TabLayout.Tab tab) {
            super();
            this.mContext = parent.getContext();
            this.mTab = tab;
            // initialize current tab's custom view.
            if (tab.getCustomView() != null) {
                this.mView = tab.getCustomView();
            } else {
                this.mView = LayoutInflater.from(parent.getContext()).inflate(R.layout.tab_layout_custom, parent, false);
            }

            if (mView != null) {
                this.mTitleText = mView.findViewById(R.id.tab_title);
                this.mBadgeTextView = mView.findViewById(R.id.tab_badge);
                this.mTitleText.setTextColor(parent.getTabTextColors());
                this.mTitleText.setText(tab.getText());
            }

            if (this.mBadgeTextView != null) {
                this.mHasBadge = mBadgeTextView.getVisibility() == View.VISIBLE;
                try {
                    this.mBadgeCount = Integer.parseInt(mBadgeTextView.getText().toString());
                } catch (NumberFormatException er) {
                    er.printStackTrace();
                    this.mBadgeCount = INVALID_NUMBER;
                }
            }


        }

        /**
         * The related Tab is about to have a badge
         *
         * @return this builder
         */
        public Builder hasBadge() {
            mHasBadge = true;
            return this;
        }

        /**
         * The related Tab is not about to have a badge
         *
         * @return this builder
         */
        public Builder noBadge() {
            mHasBadge = false;
            return this;
        }

        /**
         * Dynamically set the availability of tab's badge
         *
         * @param hasBadge
         * @return this builder
         */
        // This method is used for DEBUG purpose only
        /*hide*/
        public Builder badge(boolean hasBadge) {
            mHasBadge = hasBadge;
            return this;
        }

        /**
         * increase current badge by 1
         *
         * @return this builder
         */
        public Builder increase() {
            mBadgeCount = mBadgeTextView == null ? INVALID_NUMBER : Integer.parseInt(mBadgeTextView.getText().toString()) + 1;
            return this;
        }

        /**
         * decrease current badge by 1
         *
         * @return
         */
        public Builder decrease() {
            mBadgeCount = mBadgeTextView == null ? INVALID_NUMBER : Integer.parseInt(mBadgeTextView.getText().toString()) - 1;
            return this;
        }

        /**
         * set badge count
         *
         * @param count expected badge number
         * @return this builder
         */
        public Builder badgeCount(int count) {
            mBadgeCount = count;
            return this;
        }

        /**
         * Build the current Tab icon's custom view
         */
        public void build() {
            if (mView == null) {
                return;
            }

            // update badge counter
            if (mBadgeTextView != null) {
                mBadgeTextView.setText(formatBadgeNumber(mBadgeCount));

                if (mHasBadge) {
                    mBadgeTextView.setVisibility(View.VISIBLE);
                } else {
                    // set to View#INVISIBLE to not screw up the layout
                    mBadgeTextView.setVisibility(View.GONE);
                }
            }


            mTab.setCustomView(mView);
        }
    }
}