package com.dropo.store.section;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.utils.PinnedHeaderItemDecoration;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;

import java.util.ArrayList;

public class OrderDetailsSection extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> implements PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final ArrayList<OrderDetails> orderDetailsList;
    private final Context context;

    public OrderDetailsSection(ArrayList<OrderDetails> orderDetailsList, Context context) {
        this.orderDetailsList = orderDetailsList;
        this.context = context;
    }

    @Override
    public int getSectionCount() {
        return orderDetailsList.size();
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

        ChildRecyclerViewAdapter childRecyclerViewAdapter = new ChildRecyclerViewAdapter(context, orderDetailsList.get(section).getItems());
        itemFooterSpecification.recyclerView.setAdapter(childRecyclerViewAdapter);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new ItemHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_item_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemFooterSpecification(LayoutInflater.from(parent.getContext()).inflate(R.layout.include_recyclerview, parent, false));
        }

        return null;
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == VIEW_TYPE_HEADER;
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