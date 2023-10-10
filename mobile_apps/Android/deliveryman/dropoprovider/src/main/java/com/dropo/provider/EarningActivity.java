package com.dropo.provider;

import android.os.Bundle;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import com.dropo.provider.adapter.ViewPagerAdapter;
import com.dropo.provider.fragments.DayEarningFragment;
import com.dropo.provider.fragments.WeekEarningFragment;
import com.dropo.provider.utils.AppColor;
import com.google.android.material.tabs.TabLayout;

public class EarningActivity extends BaseAppCompatActivity {

    public ViewPager earningViewpager;
    public ViewPagerAdapter adapter;
    private TabLayout earningTabsLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_earning);
        initToolBar();
        initViewById();
        setViewListener();
        initTabLayout();
        setTitleOnToolBar(getResources().getString(R.string.text_Earn));
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        toolbar.setElevation(getResources().getDimension(R.dimen.dimen_app_tab_elevation));
        earningTabsLayout = findViewById(R.id.earningTabsLayout);
        earningViewpager = findViewById(R.id.earningViewpager);
    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {

    }

    private void initTabLayout() {
        adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFragment(new DayEarningFragment(), getResources().getString(R.string.text_day));
        adapter.addFragment(new WeekEarningFragment(), getResources().getString(R.string.text_week));
        earningViewpager.setAdapter(adapter);
        earningTabsLayout.setupWithViewPager(earningViewpager);
        earningTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}