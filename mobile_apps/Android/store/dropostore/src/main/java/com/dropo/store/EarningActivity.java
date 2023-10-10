package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.viewpager.widget.ViewPager;

import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.fragment.DayEarningFragment;
import com.dropo.store.fragment.WeekEarningFragment;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.utils.AppColor;

import com.google.android.material.tabs.TabLayout;

public class EarningActivity extends BaseActivity {

    public ViewPager earningViewpager;
    public ViewPagerAdapter adapter;
    private TabLayout earningTabsLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_earning);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_Earn));
        earningTabsLayout = findViewById(R.id.earningTabsLayout);
        earningViewpager = findViewById(R.id.earningViewpager);
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
        adapter.addFragment(new DayEarningFragment(), getResources().getString(R.string.text_day));
        if (SubStoreAccess.getInstance().isAccess(SubStoreAccess.WEEKLY_EARNING)) {
            adapter.addFragment(new WeekEarningFragment(), getResources().getString(R.string.text_week));
        }
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