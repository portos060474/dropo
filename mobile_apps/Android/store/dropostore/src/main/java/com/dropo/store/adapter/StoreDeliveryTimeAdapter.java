package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.StoreDeliveryTimeActivity;
import com.dropo.store.models.datamodel.DayTime;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class StoreDeliveryTimeAdapter extends RecyclerView.Adapter<StoreDeliveryTimeAdapter.ViewHolder> implements View.OnClickListener {

    private final StoreDeliveryTimeActivity storeTimeActivity;
    private ArrayList<DayTime> storeTimeList;

    public StoreDeliveryTimeAdapter(ArrayList<DayTime> storeOpenTimeList, StoreDeliveryTimeActivity storeTimeActivity) {
        this.storeTimeList = storeOpenTimeList;
        this.storeTimeActivity = storeTimeActivity;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(storeTimeActivity).inflate(R.layout.adapter_add_new_time, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        DayTime storeTime = storeTimeList.get(position);
        holder.tvFromTime.setText(storeTime.getStoreOpenTime());
        holder.tvToTime.setText(storeTime.getStoreCloseTime());
        holder.ivBullet.setTag(position);
    }

    @Override
    public int getItemCount() {
        return storeTimeList.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onClick(View view) {
        if (storeTimeActivity.isEditable) {
            if (view.getId() == R.id.ivBullet) {
                ImageView imageView = (ImageView) view;
                int position = (int) imageView.getTag();
                storeTimeActivity.deleteSpecificTime(storeTimeList.get(position));
                notifyDataSetChanged();
            }
        }
    }

    public void setStoreTimeList(ArrayList<DayTime> storeOpenTimeList) {
        storeTimeList = storeOpenTimeList;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvFromTime, tvToTime;
        ImageView ivBullet;

        public ViewHolder(View itemView) {
            super(itemView);
            tvFromTime = itemView.findViewById(R.id.tvFromTime);
            tvToTime = itemView.findViewById(R.id.tvToTime);
            ivBullet = itemView.findViewById(R.id.ivBullet);
            ivBullet.setOnClickListener(StoreDeliveryTimeAdapter.this);
        }
    }
}