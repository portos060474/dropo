package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
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
import com.dropo.store.DeliveryDetailActivity;
import com.dropo.store.adapter.OrderListAdapter;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.responsemodel.OrderResponse;
import com.dropo.store.models.responsemodel.OrderStatusResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.RecyclerOnItemListener;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DeliveriesListFragment extends BaseFragment implements RecyclerOnItemListener.OnItemClickListener, BaseActivity.OrderListener {

    private final String TAG = "DeliveriesListFragment";

    private final ArrayList<Order> deliveryList = new ArrayList<>();
    private OrderListAdapter orderListAdapter;
    private LinearLayout llEmpty;
    private RecyclerView rcOrderList;

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        activity.toolbar.setElevation(getResources().getDimensionPixelSize(R.dimen.dimen_app_toolbar_elevation));
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_list_deliverys, container, false);
        rcOrderList = view.findViewById(R.id.recyclerView);
        rcOrderList.setLayoutManager(new LinearLayoutManager(activity));
        rcOrderList.addOnItemTouchListener(new RecyclerOnItemListener(activity, this));
        orderListAdapter = new OrderListAdapter(activity, deliveryList, false);
        rcOrderList.setAdapter(orderListAdapter);
        llEmpty = view.findViewById(R.id.ivEmpty);
        CustomTextView text = view.findViewById(R.id.tvEmptyText);
        text.setText(activity.getResources().getString(R.string.text_no_delivery));
        swipeLayoutSetup();
        return view;
    }

    private void swipeLayoutSetup() {
        activity.mainSwipeLayout.setEnabled(true);
        activity.mainSwipeLayout.setOnRefreshListener(this::getDeliveryList);
    }

    @Override
    public void onResume() {
        super.onResume();
        activity.mainSwipeLayout.setRefreshing(true);
        getDeliveryList();
    }

    @Override
    public void onStart() {
        super.onStart();
        activity.setOrderListener(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        activity.setOrderListener(null);
    }

    /**
     * this method call a webservice for get order or delivery list
     */
    public void getDeliveryList() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(activity).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(activity).getServerToken());

        Call<OrderResponse> call = ApiClient.getClient().create(ApiInterface.class).getDeliveryList(map);
        call.enqueue(new Callback<OrderResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<OrderResponse> call, @NonNull Response<OrderResponse> response) {
                activity.mainSwipeLayout.setRefreshing(false);
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        deliveryList.clear();
                        deliveryList.addAll(response.body().getDeliveryList());
                        if (response.body().getVehicles() != null) {
                            CurrentBooking.getInstance().setVehicleDetails(response.body().getVehicles());
                        }
                        if (response.body().getAdminVehicles() != null) {
                            CurrentBooking.getInstance().setAdminVehicleDetails(response.body().getAdminVehicles());
                        }
                        orderListAdapter.notifyDataSetChanged();
                    } else {
                        deliveryList.clear();
                        orderListAdapter.notifyDataSetChanged();
                    }

                    if (response.body().getDeliveryList() == null || response.body().getDeliveryList().isEmpty()) {
                        llEmpty.setVisibility(View.VISIBLE);
                        rcOrderList.setVisibility(View.GONE);
                    } else {
                        llEmpty.setVisibility(View.GONE);
                        rcOrderList.setVisibility(View.VISIBLE);
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void gotoDeliveryDetails(int position) {
        Intent intent = new Intent(activity, DeliveryDetailActivity.class);
        intent.putExtra(Constant.ORDER_DETAIL, deliveryList.get(position));
        startActivity(intent);
        activity.overridePendingTransition(R.anim.enter, R.anim.exit);
    }

    /**
     * this method call webservice for create order pickup request to delivery man
     *
     * @param orderId   orderId
     * @param vehicleId vehicleId
     */
    public void assignDeliveryMan(String orderId, String vehicleId, String providerId) {
        Utilities.showProgressDialog(activity);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(activity).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(activity).getServerToken());
        map.put(Constant.ORDER_ID, orderId);
        map.put(Constant.VEHICLE_ID, vehicleId);
        if (!TextUtils.isEmpty(providerId)) {
            map.put(Constant.PROVIDER_ID, providerId);
        }
        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).assignProvider(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        getDeliveryList();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onItemClick(View view, int position) {

    }

    @Override
    public void onOrderReceive() {
        activity.mainSwipeLayout.setRefreshing(true);
        getDeliveryList();
    }
}