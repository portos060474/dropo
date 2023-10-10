package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.AddItemActivity;
import com.dropo.store.models.datamodel.ItemSpecification;


import java.util.ArrayList;

public class SpecificationListAdapter extends RecyclerView.Adapter<SpecificationListAdapter.ViewHolder> implements View.OnClickListener {

    private final Context context;
    private final ArrayList<ItemSpecification> itemSpecificationList;
    private boolean isOnClick;

    public SpecificationListAdapter(Context context, ArrayList<ItemSpecification> itemSpecificationList) {
        this.context = context;
        this.itemSpecificationList = itemSpecificationList;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.adapter_display_specification, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        ItemSpecification itemSpecification = itemSpecificationList.get(position);
        holder.tvSpecification.setText(itemSpecification.getName());
        if (!TextUtils.isEmpty(itemSpecification.getModifierGroupName()) && !TextUtils.isEmpty(itemSpecification.getModifierName())) {
            String displayName = String.format("%s (%s - %s)", itemSpecification.getName(),
                    itemSpecification.getModifierGroupName(), itemSpecification.getModifierName());
            holder.tvSpecification.setText(displayName);
        }
        changeBulletIcon(holder.ivBullet, ((AddItemActivity) context).isEditable);
        holder.tvSubSpecificationPrice.setVisibility(View.GONE);
        holder.tvSequenceNumber.setText(String.valueOf(itemSpecification.getSequenceNumber()));
        holder.ivBullet.setTag(position);
        holder.llSpecification.setTag(position);
    }

    @Override
    public int getItemCount() {
        return itemSpecificationList.size();
    }

    public void setClickableView(boolean isOnClick) {
        this.isOnClick = isOnClick;
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onClick(View v) {
        if (isOnClick) {
            int id = v.getId();
            if (id == R.id.ivBullet) {
                ImageView imageView = (ImageView) v;
                int position = (int) imageView.getTag();
                ((AddItemActivity) context).deleteSpecification(itemSpecificationList.get(position));
                notifyDataSetChanged();
            } else if (id == R.id.llSpecification) {
                LinearLayout llSpecification = (LinearLayout) v;
                ((AddItemActivity) context).gotoAddItemSpecification(null, (int) llSpecification.getTag());
            }
        }
    }

    private void changeBulletIcon(ImageView ivBullet, boolean boolValue) {
        if (boolValue) {
            ivBullet.setImageResource(R.drawable.ic_cross);
            ivBullet.setPadding((int) context.getResources().getDimension(R.dimen.general_small_margin), (int) context.getResources().getDimension(R.dimen.general_small_margin), (int) context.getResources().getDimension(R.dimen.general_small_margin), (int) context.getResources().getDimension(R.dimen.general_small_margin));
        } else {
            ivBullet.setImageResource(R.drawable.ic_black);
            ivBullet.setPadding((int) context.getResources().getDimension(R.dimen.general_top_margin), (int) context.getResources().getDimension(R.dimen.general_top_margin), (int) context.getResources().getDimension(R.dimen.general_top_margin), (int) context.getResources().getDimension(R.dimen.general_top_margin));
        }
    }

    protected class ViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvSpecification;
        private final TextView tvSubSpecificationPrice;
        private final TextView tvSequenceNumber;
        private final ImageView ivBullet;
        private final LinearLayout llSpecification;

        ViewHolder(View itemView) {
            super(itemView);
            tvSubSpecificationPrice = itemView.findViewById(R.id.tvSubSpecificationPrice);
            tvSpecification = itemView.findViewById(R.id.tvSpecification);
            ivBullet = itemView.findViewById(R.id.ivBullet);
            ivBullet.setOnClickListener(SpecificationListAdapter.this);
            llSpecification = itemView.findViewById(R.id.llSpecification);
            tvSequenceNumber = itemView.findViewById(R.id.tvSequenceNumber);
            llSpecification.setOnClickListener(SpecificationListAdapter.this);
        }
    }
}