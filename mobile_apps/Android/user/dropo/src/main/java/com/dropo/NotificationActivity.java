package com.dropo;

import android.os.Bundle;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.ViewPagerAdapter;
import com.dropo.fragments.MassNotificationFragment;
import com.dropo.fragments.OrderNotificationFragment;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.google.android.material.tabs.TabLayout;

public class NotificationActivity extends BaseAppCompatActivity {

    private TabLayout notificationTabsLayout;
    private ViewPagerAdapter viewPagerAdapter;
    private ViewPager viewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notification);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_notification));
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
        notificationTabsLayout = findViewById(R.id.notificationTabsLayout);
        viewPager = findViewById(R.id.notificationViewpager);
        toolbar.setElevation(getResources().getDimension(R.dimen.dimen_app_tab_elevation));
    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {

    }

    private void initTabLayout() {
        viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());
        viewPagerAdapter.addFragment(new OrderNotificationFragment(), getResources().getString(R.string.text_order_notification));
        viewPagerAdapter.addFragment(new MassNotificationFragment(), getResources().getString(R.string.text_mass_notification));
        viewPager.setAdapter(viewPagerAdapter);
        notificationTabsLayout.setupWithViewPager(viewPager);
        notificationTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}