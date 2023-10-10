package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.viewpager.widget.PagerAdapter;

import com.dropo.user.R;
import com.dropo.WelcomeActivity;

public class WelcomePagerAdapter extends PagerAdapter {

    private final LayoutInflater layoutInflater;
    private final WelcomeActivity welcomeActivity;
    private final int[] image;

    public WelcomePagerAdapter(WelcomeActivity welcomeActivity, int[] image) {
        this.welcomeActivity = welcomeActivity;
        this.image = image;
        layoutInflater = (LayoutInflater) welcomeActivity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {
        View view = layoutInflater.inflate(R.layout.item_welcome, container, false);
        ImageView imageView = view.findViewById(R.id.ivWelcome);
        imageView.setImageDrawable(AppCompatResources.getDrawable(welcomeActivity, image[position]));
        container.addView(view);
        return view;
    }

    @Override
    public int getCount() {
        return image.length;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object obj) {
        return view == obj;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, @NonNull Object object) {
        View view = (View) object;
        container.removeView(view);
    }
}