package com.dropo.provider;

import android.os.Bundle;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import com.dropo.provider.adapter.ViewPagerAdapter;
import com.dropo.provider.fragments.WalletHistoryFragment;
import com.dropo.provider.fragments.WalletTransactionFragment;
import com.dropo.provider.utils.AppColor;
import com.google.android.material.tabs.TabLayout;

public class WalletTransactionActivity extends BaseAppCompatActivity {

    private TabLayout orderHistoryTabsLayout;
    private ViewPagerAdapter viewPagerAdapter;
    private ViewPager viewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_transection);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_history));
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
        toolbar.setElevation(getResources().getDimension(R.dimen.dimen_app_tab_elevation));
        orderHistoryTabsLayout = findViewById(R.id.transTabsLayout);
        viewPager = findViewById(R.id.transViewpager);
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
        viewPagerAdapter.addFragment(new WalletHistoryFragment(), getResources().getString(R.string.text_wallet_history));
        viewPagerAdapter.addFragment(new WalletTransactionFragment(), getResources().getString(R.string.text_wallet_transaction));
        viewPager.setAdapter(viewPagerAdapter);
        orderHistoryTabsLayout.setupWithViewPager(viewPager);
        orderHistoryTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}