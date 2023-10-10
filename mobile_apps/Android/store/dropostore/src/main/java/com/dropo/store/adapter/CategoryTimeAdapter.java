package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.CategoryTimeActivity;
import com.dropo.store.models.datamodel.CategoryDayTime;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class CategoryTimeAdapter extends RecyclerView.Adapter<CategoryTimeAdapter.ViewHolder> implements View.OnClickListener {

    private final CategoryTimeActivity categoryTimeActivity;
    private ArrayList<CategoryDayTime> categoryTimeList;

    public CategoryTimeAdapter(ArrayList<CategoryDayTime> categoryTimeList, CategoryTimeActivity categoryTimeActivity) {
        this.categoryTimeList = categoryTimeList;
        this.categoryTimeActivity = categoryTimeActivity;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(categoryTimeActivity).inflate(R.layout.adapter_add_new_time, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        CategoryDayTime categoryDayTime = categoryTimeList.get(position);
        holder.tvFromTime.setText(categoryDayTime.getCategoryOpenTime());
        holder.tvToTime.setText(categoryDayTime.getCategoryCloseTime());
        holder.ivBullet.setTag(position);
    }

    @Override
    public int getItemCount() {
        return categoryTimeList.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onClick(View view) {
        if (categoryTimeActivity.isEditable) {
            if (view.getId() == R.id.ivBullet) {
                ImageView imageView = (ImageView) view;
                int position = (int) imageView.getTag();
                categoryTimeActivity.deleteSpecificTime(categoryTimeList.get(position));
                notifyDataSetChanged();
            }
        }
    }

    public void setCategoryTimeList(ArrayList<CategoryDayTime> categoryShowTimeList) {
        categoryTimeList = categoryShowTimeList;
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvFromTime, tvToTime;
        ImageView ivBullet;

        public ViewHolder(View itemView) {
            super(itemView);
            tvFromTime = itemView.findViewById(R.id.tvFromTime);
            tvToTime = itemView.findViewById(R.id.tvToTime);
            ivBullet = itemView.findViewById(R.id.ivBullet);
            ivBullet.setOnClickListener(CategoryTimeAdapter.this);
        }
    }
}