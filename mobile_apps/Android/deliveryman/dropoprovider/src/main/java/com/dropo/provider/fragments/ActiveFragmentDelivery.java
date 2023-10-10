package com.dropo.provider.fragments;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.provider.AvailableDeliveryActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.ActiveDeliveryAdapter;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.AvailableOrder;
import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.models.responsemodels.AvailableOrdersResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ActiveFragmentDelivery extends Fragment implements View.OnClickListener {
    private final String TAG = this.getClass().getSimpleName();

    public SwipeRefreshLayout srlActiveDelivery;
    public ArrayList<AvailableOrder> activeOrderList;
    private RecyclerView rcvActiveDelivery;
    private ActiveDeliveryAdapter activeDeliveryAdapter;
    private LinearLayout ivEmpty;
    private OrderStatusReceiver orderStatusReceiver;
    private AvailableDeliveryActivity availableDeliveryActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        availableDeliveryActivity = (AvailableDeliveryActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_active_delivery, container, false);
        rcvActiveDelivery = view.findViewById(R.id.rcvActiveDelivery);
        srlActiveDelivery = view.findViewById(R.id.srlActiveDelivery);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        getActiveOrders();
        orderStatusReceiver = new OrderStatusReceiver();
        activeOrderList = new ArrayList<>();
        srlActiveDelivery.setOnRefreshListener(this::getActiveOrders);
        availableDeliveryActivity.setColorSwipeToRefresh(srlActiveDelivery);
        initRcvActiveDelivery();
    }

    @Override
    public void onStart() {
        super.onStart();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Const.Action.ACTION_ORDER_STATUS);
        intentFilter.addAction(Const.Action.ACTION_STORE_CANCELED_REQUEST);
        availableDeliveryActivity.registerReceiver(orderStatusReceiver, intentFilter);
    }

    @Override
    public void onStop() {
        super.onStop();
        availableDeliveryActivity.unregisterReceiver(orderStatusReceiver);
    }

    public void getActiveOrders() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, availableDeliveryActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, availableDeliveryActivity.preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AvailableOrdersResponse> orderResponseCall = apiInterface.getActiveOrders(map);
        orderResponseCall.enqueue(new Callback<AvailableOrdersResponse>() {
            @Override
            public void onResponse(@NonNull Call<AvailableOrdersResponse> call, @NonNull Response<AvailableOrdersResponse> response) {
                activeOrderList.clear();
                activeOrderList.addAll(availableDeliveryActivity.parseContent.parseOrders(response));
                updateUiList();
                initRcvActiveDelivery();
                availableDeliveryActivity.updateDeliveryCount(1, activeOrderList.size());
                srlActiveDelivery.setRefreshing(false);
            }

            @Override
            public void onFailure(@NonNull Call<AvailableOrdersResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onClick(View view) {

    }

    @SuppressLint("NotifyDataSetChanged")
    public void initRcvActiveDelivery() {
        if (activeDeliveryAdapter != null) {
            activeDeliveryAdapter.notifyDataSetChanged();
        } else {
            activeDeliveryAdapter = new ActiveDeliveryAdapter(availableDeliveryActivity, activeOrderList);
            rcvActiveDelivery.setLayoutManager(new LinearLayoutManager(availableDeliveryActivity));
            rcvActiveDelivery.setAdapter(activeDeliveryAdapter);
            rcvActiveDelivery.addOnItemTouchListener(new RecyclerTouchListener(availableDeliveryActivity, rcvActiveDelivery, new ClickListener() {
                @Override
                public void onClick(View view, int position) {
                    AvailableOrder availableOrder = activeOrderList.get(position);
                    Order order = availableOrder.getOrderList().get(0);
                    switch (order.getDeliveryStatus()) {
                        case Const.ProviderStatus.DELIVERY_MAN_ACCEPTED:
                        case Const.ProviderStatus.DELIVERY_MAN_ARRIVED:
                        case Const.ProviderStatus.DELIVERY_MAN_COMING:
                        case Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER:
                        case Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                        case Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                        case Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                            availableDeliveryActivity.goToActiveDeliveryActivity(availableOrder.getId(), order.isBringChange());
                            break;
                        default:
                            Utils.showToast(availableDeliveryActivity.getResources().getString(R.string.text_delivery_status) + "" + " " + order.getDeliveryStatus(), availableDeliveryActivity);
                            break;
                    }
                }

                @Override
                public void onLongClick(View view, int position) {

                }
            }));
        }
    }

    private void updateUiList() {
        if (activeOrderList.isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvActiveDelivery.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvActiveDelivery.setVisibility(View.VISIBLE);
        }
    }

    private class OrderStatusReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {

            Utils.showCustomProgressDialog(availableDeliveryActivity, false);
            getActiveOrders();
        }
    }
}