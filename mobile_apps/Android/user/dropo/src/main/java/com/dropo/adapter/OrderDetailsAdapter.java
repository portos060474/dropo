package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.utils.PinnedHeaderItemDecoration;
import com.dropo.utils.SectionedRecyclerViewAdapter;

import java.util.List;

public class OrderDetailsAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> implements PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final Context context;
    private final String currency;
    private final List<CartProducts> orderDetailsItemList;
    private int deliveryType;

    public OrderDetailsAdapter(Context context, List<CartProducts> orderDetailsItemList, String currency) {
        this.orderDetailsItemList = orderDetailsItemList;
        this.context = context;
        this.currency = currency;
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
        itemHeaderHolder.tvSection.setText(orderDetailsItemList.get(section).getProductName());
        itemHeaderHolder.tvSection.setFocusable(true);
        itemHeaderHolder.tvSection.setVisibility(View.GONE);
        itemHeaderHolder.tvSection.getLayoutParams().height = 0;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemFooterSpecification itemFooterSpecification = (ItemFooterSpecification) holder;

        OrderDetailItemAdapter orderDetailItemAdapter = new OrderDetailItemAdapter(context, orderDetailsItemList.get(section).getItems(), currency, false);
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
        TextView tvSection;

        public ItemHeader(View view) {
            super(view);
            tvSection = view.findViewById(R.id.tvStoreProductName);
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