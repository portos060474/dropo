package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.BaseActivity;
import com.dropo.store.HomeActivity;
import com.dropo.store.OrderDetailActivity;
import com.dropo.store.RegisterLoginActivity;
import com.dropo.store.adapter.OrderListAdapter;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.responsemodel.OrderResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrderListFragment extends BaseFragment implements BaseActivity.OrderListener {

    private final ArrayList<Order> orderListNormal = new ArrayList<>();
    private final ArrayList<Order> orderListSchedule = new ArrayList<>();
    private OrderListAdapter orderListAdapter;
    private RecyclerView rcOrderList;
    private LinearLayout llEmpty;
    private TabLayout orderTabsLayout;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_list_order, container, false);
        rcOrderList = view.findViewById(R.id.recyclerView);
        rcOrderList.setLayoutManager(new LinearLayoutManager(activity));
        orderListAdapter = new OrderListAdapter(activity, orderListNormal, true);
        rcOrderList.setAdapter(orderListAdapter);
        llEmpty = view.findViewById(R.id.ivEmpty);
        orderTabsLayout = view.findViewById(R.id.providersTab);
        CustomTextView text = view.findViewById(R.id.tvEmptyText);
        text.setText(activity.getResources().getString(R.string.text_no_order));
        swipeLayoutSetup();
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        activity.toolbar.setElevation(0);
        orderTabsLayout.setSelectedTabIndicatorColor(AppColor.COLOR_THEME);
        orderTabsLayout.addTab(orderTabsLayout.newTab().setText(getResources().getString(R.string.text_asps)));
        orderTabsLayout.addTab(orderTabsLayout.newTab().setText(getResources().getString(R.string.text_schedule)));
        orderTabsLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                orderListAdapter.setOrderList(tab.getPosition() == 1 ? orderListSchedule : orderListNormal);
                orderListAdapter.notifyDataSetChanged();
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
    public void onStart() {
        super.onStart();
        activity.startSchedule();
        activity.setOrderListener(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        activity.stopSchedule();
        activity.setOrderListener(null);
    }

    private void swipeLayoutSetup() {
        activity.mainSwipeLayout.setEnabled(true);
        activity.mainSwipeLayout.setOnRefreshListener(this::getOrderList);
    }

    /**
     * this method call a webservice for get order or delivery list
     */
    public void getOrderList() {
        HashMap<String, Object> map = new HashMap<>();
        activity = (HomeActivity) getActivity();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(getContext()).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(getContext()).getServerToken());
        Call<OrderResponse> call = ApiClient.getClient().create(ApiInterface.class).getOrderList(map);

        call.enqueue(new Callback<OrderResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<OrderResponse> call, @NonNull Response<OrderResponse> response) {
                activity.mainSwipeLayout.setRefreshing(false);
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        if (response.body().getVehicles() != null) {
                            CurrentBooking.getInstance().setVehicleDetails(response.body().getVehicles());
                        }
                        if (response.body().getAdminVehicles() != null) {
                            CurrentBooking.getInstance().setAdminVehicleDetails(response.body().getAdminVehicles());
                        }
                        PreferenceHelper.getPreferenceHelper(activity).putCurrency(response.body().getCurrency());
                        orderListNormal.clear();
                        orderListSchedule.clear();
                        for (Order order : response.body().getOrderList()) {
                            if (order.isIsScheduleOrder()) {
                                orderListSchedule.add(order);
                            } else {
                                orderListNormal.add(order);
                            }
                        }
                        orderListAdapter.notifyDataSetChanged();
                    } else {
                        orderListNormal.clear();
                        orderListSchedule.clear();
                        orderListAdapter.notifyDataSetChanged();
                    }

                    if (response.body().getOrderList() == null || response.body().getOrderList().isEmpty()) {
                        llEmpty.setVisibility(View.VISIBLE);
                        rcOrderList.setVisibility(View.GONE);
                    } else {
                        llEmpty.setVisibility(View.GONE);
                        rcOrderList.setVisibility(View.VISIBLE);
                    }

                    if (response.body().getErrorCode() == Constant.INVALID_TOKEN || response.body().getErrorCode() == Constant.STORE_DATA_NOT_FOUND) {
                        PreferenceHelper.getPreferenceHelper(activity).logout();
                        Intent intent = new Intent(activity, RegisterLoginActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                        activity.startActivity(intent);
                        activity.finish();
                    }
                    Utilities.hideCustomProgressDialog();
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(OrderListFragment.class.getSimpleName(), t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void goToOrderDetailActivity(int position) {
        Intent intent = new Intent(activity, OrderDetailActivity.class);
        intent.putExtra(Constant.ORDER_DETAIL, orderTabsLayout.getSelectedTabPosition() == 1 ? orderListSchedule.get(position) : orderListNormal.get(position));
        startActivity(intent);
        activity.overridePendingTransition(R.anim.enter, R.anim.exit);
    }

    @Override
    public void onOrderReceive() {
        Utilities.showCustomProgressDialog(activity, false);
        getOrderList();
    }
}