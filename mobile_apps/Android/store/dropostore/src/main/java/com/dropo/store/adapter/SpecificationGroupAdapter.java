package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.SpecificationGroupActivity;
import com.dropo.store.models.datamodel.SpecificationGroup;
import com.dropo.store.widgets.CustomFontTextViewTitle;


import java.util.List;

public class SpecificationGroupAdapter extends RecyclerView.Adapter<SpecificationGroupAdapter.GroupViewHolder> {

    private final List<SpecificationGroup> specificationGroupList;
    private final SpecificationGroupActivity specificationGroupActivity;
    private boolean isEdited;

    public SpecificationGroupAdapter(List<SpecificationGroup> specificationGroupList, SpecificationGroupActivity specificationGroupActivity) {
        this.specificationGroupList = specificationGroupList;
        this.specificationGroupActivity = specificationGroupActivity;
    }

    @NonNull
    @Override
    public GroupViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new GroupViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_specification_group, parent, false));
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setEdited(boolean edited) {
        isEdited = edited;
        notifyDataSetChanged();
    }

    @Override
    public void onBindViewHolder(@NonNull final GroupViewHolder holder, final int position) {
        holder.tvSpecificationGroupName.setText(specificationGroupList.get(position).getName());
        holder.tvSpecificationGroupName.setTag(specificationGroupList.get(position).getNameList());
        holder.ivSpecGroupRemove.setVisibility(isEdited ? View.VISIBLE : View.GONE);
        holder.tvSequenceNumber.setText(String.format("%s.", specificationGroupList.get(position).getSequenceNumber()));
    }

    @Override
    public int getItemCount() {
        return specificationGroupList.size();
    }

    protected class GroupViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvSpecificationGroupName, tvSequenceNumber;
        ImageView ivSpecGroupRemove;

        public GroupViewHolder(View itemView) {
            super(itemView);
            tvSpecificationGroupName = itemView.findViewById(R.id.tvSpecificationGroupName);
            ivSpecGroupRemove = itemView.findViewById(R.id.ivSpecGroupRemove);
            tvSequenceNumber = itemView.findViewById(R.id.tvSequenceNumber);
            ivSpecGroupRemove.setOnClickListener(view -> specificationGroupActivity.deleteSpecificationGroup(getAbsoluteAdapterPosition()));
            itemView.setOnClickListener(view -> {
                if (isEdited) {
                    specificationGroupActivity.updateSpecification(getAbsoluteAdapterPosition(), tvSpecificationGroupName, tvSequenceNumber);
                } else {
                    specificationGroupActivity.goToSpecificationGroupItemActivity(getAbsoluteAdapterPosition());
                }
            });
        }
    }
}