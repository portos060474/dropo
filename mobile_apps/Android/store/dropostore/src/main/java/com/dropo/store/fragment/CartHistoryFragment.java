package com.dropo.store.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.section.OrderDetailsSection;
import com.dropo.store.utils.PinnedHeaderItemDecoration;


public class CartHistoryFragment extends BaseHistoryFragment {

    private RecyclerView rcvOrderProductItem;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_cart_history, container, false);
        rcvOrderProductItem = view.findViewById(R.id.rcvOrderProductItem);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        rcvOrderProductItem.setLayoutManager(new LinearLayoutManager(activity));

        OrderDetailsSection orderDetailsSection = new OrderDetailsSection(activity.detailsResponse.getOrder().getCartDetail().getOrderDetails(), activity);
        rcvOrderProductItem.setAdapter(orderDetailsSection);
        rcvOrderProductItem.addItemDecoration(new PinnedHeaderItemDecoration());
    }
}