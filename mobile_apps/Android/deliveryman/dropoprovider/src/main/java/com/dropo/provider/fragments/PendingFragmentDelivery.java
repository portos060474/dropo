package com.dropo.provider.fragments;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.provider.AvailableDeliveryActivity;
import com.dropo.provider.BaseAppCompatActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.PendingDeliveryAdapter;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.AvailableOrder;
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

/**
 * Created by elluminati on 09-Mar-17.
 */

public class PendingFragmentDelivery extends Fragment implements BaseAppCompatActivity.OrderListener, View.OnClickListener {
    public SwipeRefreshLayout srlPendingDelivery;
    public ArrayList<AvailableOrder> pendingOrderList;
    protected String TAG = this.getClass().getSimpleName();
    private RecyclerView rcvPendingDelivery;
    private PendingDeliveryAdapter pendingDeliveryAdapter;
    private LinearLayout ivEmpty;
    private AvailableDeliveryActivity availableDeliveryActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        availableDeliveryActivity = (AvailableDeliveryActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View pendingFrag = inflater.inflate(R.layout.fragment_pending_delivery, container, false);
        rcvPendingDelivery = pendingFrag.findViewById(R.id.rcvPendingDelivery);
        srlPendingDelivery = pendingFrag.findViewById(R.id.srlPendingDelivery);
        ivEmpty = pendingFrag.findViewById(R.id.ivEmpty);
        return pendingFrag;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        getOrders();
        pendingOrderList = new ArrayList<>();
        srlPendingDelivery.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                getOrders();
            }
        });
        initRcvPendingDelivery();
        availableDeliveryActivity.setColorSwipeToRefresh(srlPendingDelivery);
    }

    @Override
    public void onStart() {
        super.onStart();
        availableDeliveryActivity.setOrderListener(this);
        availableDeliveryActivity.startSchedule();
    }

    @Override
    public void onStop() {
        super.onStop();
        availableDeliveryActivity.setOrderListener(null);
        availableDeliveryActivity.stopSchedule();
    }


    @Override
    public void onClick(View view) {
        // do somethings
    }

    public void getOrders() {
        try {

            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.PROVIDER_ID, availableDeliveryActivity.preferenceHelper.getProviderId());
            map.put(Const.Params.SERVER_TOKEN, availableDeliveryActivity.preferenceHelper.getSessionToken());
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<AvailableOrdersResponse> orderResponseCall = apiInterface.getNewOrder(map);
            orderResponseCall.enqueue(new Callback<AvailableOrdersResponse>() {
                @Override
                public void onResponse(Call<AvailableOrdersResponse> call, Response<AvailableOrdersResponse> response) {
                    pendingOrderList.clear();
                    pendingOrderList.addAll(availableDeliveryActivity.parseContent.parseOrders(response));
                    updateUiList();
                    initRcvPendingDelivery();
                    availableDeliveryActivity.updateDeliveryCount(0, pendingOrderList.size());
                    srlPendingDelivery.setRefreshing(false);
                    Utils.hideCustomProgressDialog();

                }

                @Override
                public void onFailure(Call<AvailableOrdersResponse> call, Throwable t) {
                    AppLog.handleThrowable(TAG, t);
                    Utils.hideCustomProgressDialog();
                }
            });

        }catch (Exception e){

        }

    }

    public void initRcvPendingDelivery() {
        if (pendingDeliveryAdapter != null) {
            pendingDeliveryAdapter.notifyDataSetChanged();
        } else {
            pendingDeliveryAdapter = new PendingDeliveryAdapter(availableDeliveryActivity, pendingOrderList);
            rcvPendingDelivery.setLayoutManager(new LinearLayoutManager(availableDeliveryActivity));
            rcvPendingDelivery.setAdapter(pendingDeliveryAdapter);
            rcvPendingDelivery.addItemDecoration(new DividerItemDecoration(availableDeliveryActivity, LinearLayoutManager.VERTICAL));
            rcvPendingDelivery.addOnItemTouchListener(new RecyclerTouchListener(availableDeliveryActivity, rcvPendingDelivery, new ClickListener() {
                @Override
                public void onClick(View view, int position) {
                    availableDeliveryActivity.goToActiveDeliveryActivity(pendingOrderList.get(position).getId(),
                            pendingOrderList.get(position).getOrderList().get(0).isBringChange());
                }

                @Override
                public void onLongClick(View view, int position) {
                    // do somethings

                }
            }));
        }
    }


    private void updateUiList() {
        if (pendingOrderList.isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvPendingDelivery.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvPendingDelivery.setVisibility(View.VISIBLE);
        }

    }

    @Override
    public void onOrderReceive() {
        getOrders();
        srlPendingDelivery.setRefreshing(true);
    }

}
