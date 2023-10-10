package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.SpecificationGroupItemActivity;
import com.dropo.store.models.datamodel.Specifications;


import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SpecificationGroupItemAdapter extends RecyclerView.Adapter<SpecificationGroupItemAdapter.GroupViewHolder> {

    private final ArrayList<String> specificationIds;
    private final List<Specifications> specificationsList;
    private final SpecificationGroupItemActivity groupItemActivity;
    private boolean isEdited;

    public SpecificationGroupItemAdapter(List<Specifications> specificationsList, SpecificationGroupItemActivity groupItemActivity) {
        this.specificationsList = specificationsList;
        this.groupItemActivity = groupItemActivity;
        specificationIds = new ArrayList<>();
        Collections.sort(this.specificationsList);
    }

    @SuppressLint("NotifyDataSetChanged")
    public void notifyDataChange() {
        Collections.sort(specificationsList);
        notifyDataSetChanged();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setEdited(boolean edited) {
        isEdited = edited;
        notifyDataSetChanged();
    }

    public ArrayList<String> getSpecificationIds() {
        return specificationIds;
    }

    @NonNull
    @Override
    public GroupViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new GroupViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_specification_group_item, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull GroupViewHolder holder, int position) {
        Specifications specifications = specificationsList.get(position);
        holder.tvSequenceNumber.setText(String.valueOf(specifications.getSequenceNumber()));
        holder.tvSpecificationName.setText(specifications.getName());
        holder.tvSpecificationName.setTag(specifications.getNameList());
        holder.ivSpecificationRemove.setVisibility(isEdited ? View.VISIBLE : View.GONE);
        holder.tvSpecificationPrice.setText(specifications.getPrice() > 0 ? groupItemActivity.preferenceHelper.getCurrency() + specifications.getPrice() : "");
    }

    @Override
    public int getItemCount() {
        return specificationsList != null ? specificationsList.size() : 0;
    }

    protected class GroupViewHolder extends RecyclerView.ViewHolder {
        TextView tvSpecificationName, tvSpecificationPrice, tvSequenceNumber;
        ImageView ivSpecificationRemove;

        @SuppressLint("NotifyDataSetChanged")
        public GroupViewHolder(View itemView) {
            super(itemView);
            tvSequenceNumber = itemView.findViewById(R.id.tvSequenceNumber);
            tvSpecificationName = itemView.findViewById(R.id.tvSpecificationName);
            ivSpecificationRemove = itemView.findViewById(R.id.ivSpecificationRemove);
            tvSpecificationPrice = itemView.findViewById(R.id.tvSpecificationPrice);
            ivSpecificationRemove.setOnClickListener(view -> {
                specificationIds.add(specificationsList.get(getAbsoluteAdapterPosition()).getId());
                specificationsList.remove(getAbsoluteAdapterPosition());
                notifyDataSetChanged();
            });

            itemView.setOnClickListener(v -> groupItemActivity.addORUpdateSpecificationDialog(getAbsoluteAdapterPosition(), tvSpecificationName, true));
        }
    }
}