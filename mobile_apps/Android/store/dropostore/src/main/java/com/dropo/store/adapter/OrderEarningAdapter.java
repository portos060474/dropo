package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.EarningData;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;

import java.util.ArrayList;

public class OrderEarningAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<ArrayList<EarningData>> arrayListForEarning;

    public OrderEarningAdapter(ArrayList<ArrayList<EarningData>> arrayListForEarning) {
        this.arrayListForEarning = arrayListForEarning;
    }

    @Override
    public int getSectionCount() {
        return arrayListForEarning.size();
    }

    @Override
    public int getItemCount(int section) {
        return arrayListForEarning.get(section).size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        OrderEarningHeading heading = (OrderEarningHeading) holder;
        heading.tvEarningHeader.setText(arrayListForEarning.get(section).get(0).getTitleMain());
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        OrderEarningItem item = (OrderEarningItem) holder;
        item.tvName.setText(arrayListForEarning.get(section).get(relativePosition).getTitle());
        item.tvPrice.setText(arrayListForEarning.get(section).get(relativePosition).getPrice());
        item.tvName.setAllCaps(arrayListForEarning.size() - 1 == section);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new OrderEarningHeading(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_earning_header, parent, false));
            case VIEW_TYPE_ITEM:
                return new OrderEarningItem(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_earning_item, parent, false));
            default:
                break;
        }
        return null;
    }

    protected static class OrderEarningHeading extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvEarningHeader;

        public OrderEarningHeading(View itemView) {
            super(itemView);
            tvEarningHeader = itemView.findViewById(R.id.tvEarningHeader);
        }
    }

    protected static class OrderEarningItem extends RecyclerView.ViewHolder {
        CustomTextView tvName, tvPrice;

        public OrderEarningItem(View itemView) {
            super(itemView);
            tvName = itemView.findViewById(R.id.tvName);
            tvPrice = itemView.findViewById(R.id.tvPrice);
        }
    }
}