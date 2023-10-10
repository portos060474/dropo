package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.viewpager.widget.PagerAdapter;

import com.dropo.ProductSpecificationActivity;
import com.dropo.user.R;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;

import java.util.List;

public class ProductItemItemAdapter extends PagerAdapter {

    private final List<String> stringList;
    private final ProductSpecificationActivity activity;
    private final int id;
    private final boolean isItemClick;
    private final ImageHelper imageHelper;
    private int itemImageWidth;
    private final int itemImageHeight;

    public ProductItemItemAdapter(ProductSpecificationActivity activity, List<String> stringList, int layoutId, boolean isItemClick) {
        this.stringList = stringList;
        this.activity = activity;
        this.id = layoutId;
        this.isItemClick = isItemClick;
        imageHelper = new ImageHelper(activity);
        int screenPadding = activity.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding);
        itemImageWidth = activity.getResources().getDisplayMetrics().widthPixels;
        itemImageWidth = (itemImageWidth - (screenPadding * 4)) / 2;
        itemImageHeight = (int) (itemImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public Object instantiateItem(ViewGroup container, final int position) {
        View view = LayoutInflater.from(container.getContext()).inflate(id, container, false);
        if (PreferenceHelper.getInstance(activity).getIsLoadProductImage()) {
            view.getLayoutParams().height = itemImageHeight;
            view.getLayoutParams().width = itemImageWidth;
            GlideApp.with(activity)
                    .load(imageHelper.getImageUrlAccordingSize(stringList.get(position), (ImageView) view))
                    .addListener(imageHelper.registerGlideLoadFiledListener((ImageView) view, stringList.get(position)))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null))
                    .into((ImageView) view);
        }
        if (isItemClick) {
            view.setOnClickListener(view1 -> {
                if (PreferenceHelper.getInstance(activity).getIsLoadProductImage()) {
                    activity.openDialogItemImage(position);
                }
            });
        }

        container.addView(view);
        return view;

    }

    @Override
    public void destroyItem(ViewGroup container, int position, @NonNull Object object) {
        View view = (View) object;
        container.removeView(view);
    }

    @Override
    public int getCount() {
        return PreferenceHelper.getInstance(activity).getIsLoadProductImage() ? stringList.size() : 1;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view == object;
    }
}