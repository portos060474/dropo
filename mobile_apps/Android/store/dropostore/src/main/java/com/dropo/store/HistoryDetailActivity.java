package com.dropo.store;

import android.os.Bundle;
import android.view.Menu;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.viewpager.widget.ViewPager;

import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.fragment.CartHistoryFragment;
import com.dropo.store.fragment.HistoryDetailFragment;
import com.dropo.store.fragment.HistoryInvoiceFragment;
import com.dropo.store.models.responsemodel.HistoryDetailsResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.android.material.tabs.TabLayout;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HistoryDetailActivity extends BaseActivity {

    private static final String TAG = "HISTORY_DETAILS_ACTIVITY";
    public ViewPagerAdapter adapter;
    public HistoryDetailsResponse detailsResponse;
    private ViewPager viewPager;
    private TabLayout tabLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history_detail);

        toolbar = findViewById(R.id.toolbar);

        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);

        tabLayout = findViewById(R.id.historyTabsLayout);
        viewPager = findViewById(R.id.historyViewpager);
        getDataFromIntent();
    }

    private void initTabLayout(ViewPager viewPager) {
        if (adapter == null) {
            adapter = new ViewPagerAdapter(getSupportFragmentManager());
            adapter.addFragment(new HistoryDetailFragment(), getString(R.string.text_other_detail));
            adapter.addFragment(new HistoryInvoiceFragment(), getString(R.string.text_invoice));
            if (detailsResponse.getOrder().getCartDetail().getOrderDetails() != null && !detailsResponse.getOrder().getCartDetail().getOrderDetails().isEmpty()) {
                adapter.addFragment(new CartHistoryFragment(), getString(R.string.text_cart));
            }
            viewPager.setAdapter(adapter);
            tabLayout.setupWithViewPager(viewPager);
            tabLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
            toolbar.setElevation(getResources().getDimension(R.dimen.dimen_app_toolbar_elevation));
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    private void getDataFromIntent() {
        if (getIntent() != null && getIntent().getSerializableExtra(Constant.ORDER_ID) != null) {
            getHistoryDetails(getIntent().getStringExtra(Constant.ORDER_ID));
        }
    }

    /**
     * this method call a webservice for get order history detail
     *
     * @param orderId in string
     */
    private void getHistoryDetails(String orderId) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.ORDER_ID, orderId);
        Call<HistoryDetailsResponse> call = ApiClient.getClient().create(ApiInterface.class).getHistoryDetails(map);
        call.enqueue(new Callback<HistoryDetailsResponse>() {
            @Override
            public void onResponse(@NonNull Call<HistoryDetailsResponse> call, @NonNull Response<HistoryDetailsResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        detailsResponse = response.body();
                        initTabLayout(viewPager);
                        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(String.format("%s%s", getResources().getString(R.string.text_order_no), detailsResponse.getOrder().getUniqueId()));
                    } else {
                        ParseContent.getInstance().showErrorMessage(HistoryDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), HistoryDetailActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<HistoryDetailsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}