package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.viewpager.widget.PagerAdapter;

import com.dropo.store.R;
import com.dropo.store.utils.GlideApp;


import java.util.List;

public abstract class ProductItemItemAdapter extends PagerAdapter {

    private final List<String> stringList;
    private final Context context;
    private final int id;
    private final boolean isItemClick;

    public ProductItemItemAdapter(Context context, List<String> stringList, int layoutId, boolean isItemClick) {
        this.stringList = stringList;
        this.context = context;
        this.id = layoutId;
        this.isItemClick = isItemClick;
    }

    @NonNull
    @Override
    public Object instantiateItem(ViewGroup container, final int position) {
        View view = LayoutInflater.from(container.getContext()).inflate(id, container, false);
        if (stringList.isEmpty()) {
            GlideApp.with(context)
                    .load(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into((ImageView) view);
        } else {
            GlideApp.with(context)
                    .load(IMAGE_URL + stringList.get(position))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into((ImageView) view);
            if (isItemClick) {
                view.setOnClickListener(view1 -> onItemClick(position));
            }
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
        if (stringList.isEmpty()) {
            return 1; // show default image
        } else {
            return stringList.size();
        }
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view == object;
    }

    public abstract void onItemClick(int position);
}