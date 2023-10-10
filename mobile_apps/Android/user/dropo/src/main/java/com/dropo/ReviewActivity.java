package com.dropo;

import android.os.Bundle;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.ViewPagerAdapter;
import com.dropo.fragments.OverviewFragment;
import com.dropo.fragments.ReviewFragment;
import com.dropo.user.R;
import com.google.android.material.tabs.TabLayout;

public class ReviewActivity extends BaseAppCompatActivity {

    private TabLayout reviewHistoryTabsLayout;
    private ViewPagerAdapter viewPagerAdapter;
    private ViewPager viewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_review);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_orders));
        initViewById();
        setViewListener();
        initTabLayout();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        reviewHistoryTabsLayout = findViewById(R.id.reviewTabsLayout);
        viewPager = findViewById(R.id.reviewViewpager);
    }

    @Override
    protected void setViewListener() {
        reviewHistoryTabsLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }


    @Override
    public void onClick(View view) {
    }

    private void initTabLayout() {
        viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());
        viewPagerAdapter.addFragment(new OverviewFragment(), getResources().getString(R.string.text_over_view));
        viewPagerAdapter.addFragment(new ReviewFragment(), getResources().getString(R.string.text_review));
        viewPager.setAdapter(viewPagerAdapter);
        reviewHistoryTabsLayout.setupWithViewPager(viewPager);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}