package com.dropo.store.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.utils.AppColor;
import com.dropo.store.widgets.CustomFontTextViewTitle;


import java.util.ArrayList;

public class StoreDayAdapter extends RecyclerView.Adapter<StoreDayAdapter.StoreDayHolder> {

    private final ArrayList<String> stringArrayList;
    private final Context context;
    private int selected = -1;

    public StoreDayAdapter(Context context, ArrayList<String> stringArrayList) {
        this.stringArrayList = stringArrayList;
        this.context = context;
    }

    @NonNull
    @Override
    public StoreDayHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_day, parent, false);
        return new StoreDayHolder(view);
    }

    @Override
    public void onBindViewHolder(StoreDayHolder holder, int position) {
        holder.tvDay.setText(stringArrayList.get(position));
        if (selected == position) {
            holder.tvDay.setTextColor(AppColor.COLOR_THEME);
        } else {
            holder.tvDay.setTextColor(AppColor.getThemeTextColor(context));
        }
    }

    @Override
    public int getItemCount() {
        return stringArrayList.size();
    }

    public int getSelected() {
        return selected;
    }

    public void setSelected(int selected) {
        this.selected = selected;
    }

    protected static class StoreDayHolder extends RecyclerView.ViewHolder {
        private final CustomFontTextViewTitle tvDay;

        public StoreDayHolder(View itemView) {
            super(itemView);
            tvDay = itemView.findViewById(R.id.tvDay);
        }
    }
}