package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.widget.TextView;

import androidx.viewpager.widget.ViewPager;

import com.dropo.store.R;
import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.fragment.WalletHistoryFragment;
import com.dropo.store.fragment.WalletTransactionFragment;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Utilities;

import com.google.android.material.tabs.TabLayout;

public class WalletTransactionActivity extends BaseActivity {

    private TabLayout orderHistoryTabsLayout;
    private ViewPagerAdapter viewPagerAdapter;
    private ViewPager viewPager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_transaction);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(WalletTransactionActivity.this);
            onBackPressed();
        });
        toolbar.setElevation(getResources().getDimension(R.dimen.dimen_app_tab_elevation));
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_history));
        orderHistoryTabsLayout = findViewById(R.id.transTabsLayout);
        orderHistoryTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
        viewPager = findViewById(R.id.transViewpager);
        initTabLayout();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    private void initTabLayout() {
        viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());
        viewPagerAdapter.addFragment(new WalletHistoryFragment(), getResources().getString(R.string.text_wallet_history));
        viewPagerAdapter.addFragment(new WalletTransactionFragment(), getResources().getString(R.string.text_wallet_transaction));
        viewPager.setAdapter(viewPagerAdapter);
        orderHistoryTabsLayout.setupWithViewPager(viewPager);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}