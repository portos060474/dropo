package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.viewpager.widget.PagerAdapter;

import com.dropo.OrderDetailActivity;
import com.dropo.user.R;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;

import java.util.ArrayList;
import java.util.List;

public class CourierItemAdapter extends PagerAdapter {

    private final List<String> stringList;
    private final OrderDetailActivity activity;
    private final int id;
    private final ImageHelper imageHelper;

    public CourierItemAdapter(OrderDetailActivity orderDetailActivity, ArrayList<String> courierItemsImages, int item_image_full) {
        this.stringList = courierItemsImages;
        this.activity = orderDetailActivity;
        this.id = item_image_full;
        imageHelper = new ImageHelper(activity);
    }

    @NonNull
    @Override
    public Object instantiateItem(ViewGroup container, final int position) {
        View view = LayoutInflater.from(container.getContext()).inflate(id, container, false);
        if (PreferenceHelper.getInstance(activity).getIsLoadProductImage()) {
            GlideApp.with(activity)
                    .load(imageHelper.getImageUrlAccordingSize(stringList.get(position), (ImageView) view))
                    .addListener(imageHelper.registerGlideLoadFiledListener((ImageView) view, stringList.get(position)))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null))
                    .into((ImageView) view);
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
        return stringList.size();
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view == object;
    }
}
