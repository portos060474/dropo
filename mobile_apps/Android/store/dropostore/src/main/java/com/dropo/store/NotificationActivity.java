package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.viewpager.widget.ViewPager;

import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.fragment.MassNotificationFragment;
import com.dropo.store.fragment.OrderNotificationFragment;
import com.dropo.store.utils.AppColor;
import com.google.android.material.tabs.TabLayout;

public class NotificationActivity extends BaseActivity {

    public ViewPager notificationViewpager;
    public ViewPagerAdapter adapter;
    private TabLayout notificationTabsLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notification);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_notification));
        notificationTabsLayout = findViewById(R.id.notificationTabsLayout);
        notificationViewpager = findViewById(R.id.notificationViewpager);
        initTabLayout();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public void onClick(View view) {

    }

    private void initTabLayout() {
        adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFragment(new OrderNotificationFragment(), getResources().getString(R.string.text_order_notification));
        adapter.addFragment(new MassNotificationFragment(), getResources().getString(R.string.text_mass_notification));
        notificationViewpager.setAdapter(adapter);
        notificationTabsLayout.setupWithViewPager(notificationViewpager);
        notificationTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}