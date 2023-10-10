package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.DayTime;
import com.dropo.utils.AppColor;

import java.util.ArrayList;

public class TimeSlotAdapter extends RecyclerView.Adapter<TimeSlotAdapter.TimeSlotViewHolder> {
    private int selectedPosition = 0;
    private ArrayList<DayTime> dayTimes;
    private Context context;

    @SuppressLint("NotifyDataSetChanged")
    public void setDayTimes(ArrayList<DayTime> dayTimes, int selectedPosition) {
        this.dayTimes = dayTimes;
        this.selectedPosition = selectedPosition;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public TimeSlotViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_time_slot, parent, false);
        return new TimeSlotViewHolder(view);
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onBindViewHolder(@NonNull TimeSlotViewHolder holder, int position) {
        if (selectedPosition == position) {
            Drawable drawable = ResourcesCompat.getDrawable(context.getResources(), R.drawable.selector_round_rect_shape_blue, null);
            if (drawable != null) {
                drawable.setTint(ResourcesCompat.getColor(context.getResources(), AppColor.isDarkTheme(context) ? R.color.color_app_bg_light : R.color.color_app_bg_dark, null));
            }
            holder.tvTimeSlot.setBackground(drawable);
            holder.tvTimeSlot.setTextColor(ResourcesCompat.getColor(context.getResources(), AppColor.isDarkTheme(context) ? R.color.color_app_bg_dark : R.color.color_app_bg_light, null));
        } else {
            holder.tvTimeSlot.setBackgroundColor(ResourcesCompat.getColor(context.getResources(), AppColor.isDarkTheme(context) ? R.color.color_app_bg_dark : R.color.color_app_bg_light, null));
            holder.tvTimeSlot.setTextColor(AppColor.getThemeTextColor(context));
        }
        holder.tvTimeSlot.setOnClickListener(v -> {
            selectedPosition = holder.getAbsoluteAdapterPosition();
            notifyDataSetChanged();
        });
        DayTime dayTime = dayTimes.get(position);
        holder.tvTimeSlot.setText(String.format("%s - %s", dayTime.getStoreOpenTime(), dayTime.getStoreCloseTime()));
    }

    @Override
    public int getItemCount() {
        return dayTimes == null ? 0 : dayTimes.size();
    }

    public DayTime getSelectedTime() {
        if (selectedPosition != -1 && dayTimes != null && !dayTimes.isEmpty()) {
            return dayTimes.get(selectedPosition);
        } else {
            return null;
        }
    }

    public int getSelectedPosition() {
        return selectedPosition;
    }

    public void resetSelection() {
        selectedPosition = 0;
    }

    protected static class TimeSlotViewHolder extends RecyclerView.ViewHolder {
        TextView tvTimeSlot;

        public TimeSlotViewHolder(@NonNull View itemView) {
            super(itemView);
            tvTimeSlot = itemView.findViewById(R.id.tvTimeSlot);
        }
    }
}