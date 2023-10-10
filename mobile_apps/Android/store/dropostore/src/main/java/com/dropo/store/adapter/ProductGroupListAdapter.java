package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.ProductGroup;


import java.util.Collections;
import java.util.List;

public abstract class ProductGroupListAdapter extends RecyclerView.Adapter<ProductGroupListAdapter.ViewHolder> {

    private final List<ProductGroup> productGroups;
    private boolean isDelete;

    public ProductGroupListAdapter(List<ProductGroup> productGroups, boolean isDelete) {
        this.productGroups = productGroups;
        this.isDelete = isDelete;
        Collections.sort(this.productGroups);
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setIsDelete(boolean isDelete) {
        this.isDelete = isDelete;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_product_group, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvGroupNme.setText(String.format("%s (%s)", productGroups.get(position).getName(),  productGroups.get(position).getProductIds().size()));

        holder.ivDelete.setVisibility(isDelete ? View.VISIBLE : View.GONE);
        holder.ivNext.setVisibility(isDelete ? View.GONE : View.VISIBLE);
    }

    @Override
    public int getItemCount() {
        return productGroups.size();
    }

    public abstract void onSelect(int position);

    public abstract void onDelete(String productGroupId, int position);

    protected class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvGroupNme;
        LinearLayout llGroup;
        ImageView ivNext, ivDelete;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            tvGroupNme = itemView.findViewById(R.id.tvGroupNme);
            llGroup = itemView.findViewById(R.id.llGroup);
            ivNext = itemView.findViewById(R.id.ivNext);
            ivDelete = itemView.findViewById(R.id.ivDelete);

            llGroup.setOnClickListener(v -> {
                if (isDelete) {
                    onDelete(productGroups.get(getAbsoluteAdapterPosition()).getId(), getAbsoluteAdapterPosition());
                } else {
                    onSelect(getAbsoluteAdapterPosition());
                }
            });
        }
    }
}