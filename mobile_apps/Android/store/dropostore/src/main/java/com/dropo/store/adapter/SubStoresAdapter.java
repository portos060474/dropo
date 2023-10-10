package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.SubStore;


import java.util.List;

public abstract class SubStoresAdapter extends RecyclerView.Adapter<SubStoresAdapter.SubStoreHolder> {

    private List<SubStore> subStoreList;

    @SuppressLint("NotifyDataSetChanged")
    public void setSubStoreList(List<SubStore> subStoreList) {
        this.subStoreList = subStoreList;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public SubStoreHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new SubStoreHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_sub_store, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull final SubStoreHolder holder, final int position) {
        SubStore subStore = subStoreList.get(position);
        holder.tvSubStoreName.setText(subStore.getName());
        holder.tvSubStoreEmail.setText(subStore.getEmail());
        holder.tvSubStorePhone.setText(subStore.getPhone());
        holder.tvSubStoreName.setCompoundDrawablesRelativeWithIntrinsicBounds(0, 0, subStore.isIsApproved() ? R.drawable.ic_dot_green : R.drawable.ic_dot_red, 0);
    }

    @Override
    public int getItemCount() {
        return subStoreList == null ? 0 : subStoreList.size();
    }

    public abstract void onStoreSelect(SubStore subStore);

    protected class SubStoreHolder extends RecyclerView.ViewHolder {
        TextView tvSubStoreName, tvSubStoreEmail, tvSubStorePhone;

        public SubStoreHolder(@NonNull View itemView) {
            super(itemView);
            tvSubStoreName = itemView.findViewById(R.id.tvSubStoreName);
            tvSubStoreEmail = itemView.findViewById(R.id.tvSubStoreEmail);
            tvSubStorePhone = itemView.findViewById(R.id.tvSubStorePhone);
            itemView.setOnClickListener(v -> onStoreSelect(subStoreList.get(getAbsoluteAdapterPosition())));
        }
    }
}