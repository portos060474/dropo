package com.dropo.provider.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.models.datamodels.OrderProducts;
import com.dropo.provider.utils.PinnedHeaderItemDecoration;
import com.dropo.provider.utils.SectionedRecyclerViewAdapter;

import java.util.List;

public class OrderDetailsAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> implements PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final List<OrderProducts> orderDetailsItemList;
    private final Context context;
    private final String currency;
    private final boolean isImageVisible;
    private int deliveryType;

    public OrderDetailsAdapter(Context context, List<OrderProducts> orderDetailsItemList, String currency, boolean isImageVisible) {
        this.orderDetailsItemList = orderDetailsItemList;
        this.context = context;
        this.currency = currency;
        this.isImageVisible = isImageVisible;
    }

    @Override
    public int getSectionCount() {
        return orderDetailsItemList.size();
    }

    @Override
    public int getItemCount(int section) {
        return 1;
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        ItemHeader itemHeaderHolder = (ItemHeader) holder;
        itemHeaderHolder.itemView.setVisibility(View.GONE);
        RecyclerView.LayoutParams layoutParams = (RecyclerView.LayoutParams) itemHeaderHolder.itemView.getLayoutParams();
        layoutParams.height = 0;
        layoutParams.topMargin = 0;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemFooterSpecification itemFooterSpecification = (ItemFooterSpecification) holder;

        OrderDetailItemAdapter orderDetailItemAdapter = new OrderDetailItemAdapter(context, orderDetailsItemList.get(section).getItems(), currency, isImageVisible);
        itemFooterSpecification.recyclerView.setAdapter(orderDetailItemAdapter);
        orderDetailItemAdapter.setDeliveryType(deliveryType);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new ItemHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_product_header, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemFooterSpecification(LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_recyclerview, parent, false));
        }

        return null;
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == VIEW_TYPE_HEADER;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    protected static class ItemHeader extends RecyclerView.ViewHolder {
        public ItemHeader(View view) {
            super(view);
        }
    }

    protected class ItemFooterSpecification extends RecyclerView.ViewHolder {
        RecyclerView recyclerView;

        public ItemFooterSpecification(View view) {
            super(view);
            recyclerView = view.findViewById(R.id.recyclerView);
            RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);
            recyclerView.setLayoutManager(layoutManager);
        }
    }
}