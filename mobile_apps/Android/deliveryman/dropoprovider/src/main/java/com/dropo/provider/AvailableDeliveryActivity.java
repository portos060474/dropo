package com.dropo.provider;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.View;

import androidx.viewpager.widget.ViewPager;

import com.dropo.provider.adapter.ViewPagerAdapter;
import com.dropo.provider.component.BadgeTabLayout;
import com.dropo.provider.fragments.ActiveFragmentDelivery;
import com.dropo.provider.fragments.PendingFragmentDelivery;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.google.android.material.tabs.TabLayout;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class AvailableDeliveryActivity extends BaseAppCompatActivity {

    private BadgeTabLayout tabLayout;
    private ViewPager viewPager;
    private ViewPagerAdapter adapter;
    private ScheduledExecutorService updateLocationAndOrderSchedule;
    private boolean isScheduledStart;
    private Handler handler;
    private PendingFragmentDelivery pendingFragmentDelivery;
    private ActiveFragmentDelivery activeFragmentDelivery;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_available_delivery);
        initToolBar();
        initViewById();
        setViewListener();
        setTitleOnToolBar(getResources().getString(R.string.text_available_deliveries));
        setupViewPager(viewPager);
        closedDeliveryRequestDialog();
        initHandler();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        tabLayout = findViewById(R.id.deliveryTabsLayout);
        viewPager = findViewById(R.id.deliveryViewpager);
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
    public void onClick(View view) {

    }

    private void setupViewPager(ViewPager viewPager) {
        adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFragment(new PendingFragmentDelivery(), getString(R.string.text_pending_deliveries));
        adapter.addFragment(new ActiveFragmentDelivery(), getString(R.string.text_active_deliveries));
        viewPager.setAdapter(adapter);
        tabLayout.setupWithViewPager(viewPager);
        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                if (tab.getPosition() == 0) {
                    pendingFragmentDelivery = (PendingFragmentDelivery) adapter.getItem(0);
                    pendingFragmentDelivery.getOrders();
                } else {
                    activeFragmentDelivery = (ActiveFragmentDelivery) adapter.getItem(1);
                    activeFragmentDelivery.getActiveOrders();
                }
            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });

        tabLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
    }

    public void updateDeliveryCount(int tabPosition, int count) {
        if (tabLayout != null) {
            BadgeTabLayout.Builder builder = tabLayout.with(tabPosition);
            if (count == 0) {
                builder.badge(false);
            } else {
                builder.badge(true);
                builder.badgeCount(count);
            }
            builder.build();
        }
    }

    @Override
    public void onBackPressed() {
        goToNewHomeActivity();
    }

    public void goToActiveDeliveryActivity(String orderId, boolean isBringChange) {
        Intent intent = new Intent(this, ActiveDeliveryActivity.class);
        intent.putExtra(Const.Params.ORDER_ID, orderId);
        intent.putExtra(Const.Params.IS_BRING_CHANGE, isBringChange);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToNewHomeActivity() {
        Intent homeIntent = new Intent(this, HomeActivity.class);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void startSchedule() {
        if (!isScheduledStart) {
            Runnable runnable = () -> {
                Message message = handler.obtainMessage();
                handler.sendMessage(message);
            };
            updateLocationAndOrderSchedule = Executors.newSingleThreadScheduledExecutor();
            updateLocationAndOrderSchedule.scheduleWithFixedDelay(runnable, 0, Const.AVAILABLE_DELIVER_SCHEDULED_SECONDS, TimeUnit.SECONDS);
            isScheduledStart = true;
        }
    }

    public void stopSchedule() {
        if (isScheduledStart) {
            updateLocationAndOrderSchedule.shutdown(); // Disable new tasks from being submitted
            // Wait a while for existing tasks to terminate
            try {
                if (!updateLocationAndOrderSchedule.awaitTermination(60, TimeUnit.SECONDS)) {
                    updateLocationAndOrderSchedule.shutdownNow(); // Cancel currently executing
                    // tasks
                    // Wait a while for tasks to respond to being cancelled
                    updateLocationAndOrderSchedule.awaitTermination(60, TimeUnit.SECONDS);
                }
            } catch (InterruptedException e) {
                AppLog.handleException(AvailableDeliveryActivity.class.getName(), e);
                // (Re-)Cancel if current thread also interrupted
                updateLocationAndOrderSchedule.shutdownNow();
                // Preserve interrupt status
                Thread.currentThread().interrupt();
            }
            isScheduledStart = false;
        }

    }

    /**
     * This handler receive a message from  requestStatusScheduledService and update provider
     * location and order status
     */
    private void initHandler() {
        handler = new Handler(Looper.myLooper()) {
            @Override
            public void handleMessage(Message msg) {
                if (tabLayout.getSelectedTabPosition() == 0) {
                    pendingFragmentDelivery = (PendingFragmentDelivery) adapter.getItem(0);
                    pendingFragmentDelivery.getOrders();
                } else {
                    activeFragmentDelivery = (ActiveFragmentDelivery) adapter.getItem(1);
                    activeFragmentDelivery.getActiveOrders();
                }
            }
        };
    }
}