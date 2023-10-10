package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.utils.AppColor;
import com.dropo.utils.SectionedRecyclerViewAdapter;

import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class StoreTimeAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final List<StoreTime> storeTimes;
    private final Calendar calendar1;
    private final Calendar calendar2;
    private Context context;

    public StoreTimeAdapter(List<StoreTime> storeTimes) {
        this.storeTimes = storeTimes;
        calendar1 = Calendar.getInstance();
        calendar2 = Calendar.getInstance();
    }

    @Override
    public int getSectionCount() {
        return storeTimes.size();
    }

    @Override
    public int getItemCount(int section) {
        if (storeTimes.get(section).isStoreOpenFullTime()) {
            return 1;
        } else if (!storeTimes.get(section).isStoreOpenFullTime() && !storeTimes.get(section).isStoreOpen()) {
            return 1;
        } else if (storeTimes.get(section).getDayTime().size() == 0) {
            return 1;
        } else {
            return storeTimes.get(section).getDayTime().size();
        }
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        StoreTimeViewHolderHeader holderHeader = (StoreTimeViewHolderHeader) holder;
        holderHeader.itemView.setVisibility(View.GONE);
        holderHeader.itemView.getLayoutParams().height = 0;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        StoreTimeViewHolderItem timeViewHolderItem = (StoreTimeViewHolderItem) holder;
        StoreTime storeTime = storeTimes.get(section);
        timeViewHolderItem.tvDow.setVisibility(View.INVISIBLE);
        if (calendar2.get(Calendar.DAY_OF_WEEK) - 1 == storeTime.getDay()) {
            timeViewHolderItem.tvDow.setTextColor(AppColor.getThemeTextColor(context));
            timeViewHolderItem.tvStoreTime.setTextColor(AppColor.getThemeTextColor(context));
        } else {
            timeViewHolderItem.tvDow.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
            timeViewHolderItem.tvStoreTime.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
        }
        calendar1.set(Calendar.DAY_OF_WEEK, storeTime.getDay() + 1);
        timeViewHolderItem.tvDow.setText(calendar1.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.LONG, Locale.getDefault()));

        if (storeTime.isStoreOpenFullTime()) {
            timeViewHolderItem.tvDow.setVisibility(View.VISIBLE);
            timeViewHolderItem.tvStoreTime.setText(context.getResources().getString(R.string.text_open_24_hours));
        } else if (!storeTime.isStoreOpenFullTime() && !storeTime.isStoreOpen()) {
            timeViewHolderItem.tvDow.setVisibility(View.VISIBLE);
            timeViewHolderItem.tvDow.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
            timeViewHolderItem.tvStoreTime.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
            timeViewHolderItem.tvStoreTime.setText(context.getResources().getString(R.string.text_store_closed));
        } else if (storeTimes.get(section).getDayTime().size() == 0) {
            timeViewHolderItem.tvDow.setVisibility(View.VISIBLE);
            timeViewHolderItem.tvDow.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
            timeViewHolderItem.tvStoreTime.setTextColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_label_dark, null));
            timeViewHolderItem.tvStoreTime.setText(context.getResources().getString(R.string.text_store_closed));
        } else {
            if (relativePosition == 0) {
                timeViewHolderItem.tvDow.setVisibility(View.VISIBLE);
            }
            timeViewHolderItem.tvStoreTime.setText(String.format("%s-%s", storeTime.getDayTime().get(relativePosition).getStoreOpenTime(), storeTime.getDayTime().get(relativePosition).getStoreCloseTime()));
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_time, parent, false);
        if (viewType == VIEW_TYPE_ITEM) {
            return new StoreTimeViewHolderItem(view);
        } else {
            return new StoreTimeViewHolderHeader(view);
        }
    }

    protected static class StoreTimeViewHolderHeader extends RecyclerView.ViewHolder {
        public StoreTimeViewHolderHeader(View itemView) {
            super(itemView);
        }
    }

    protected static class StoreTimeViewHolderItem extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvDow;
        CustomFontTextView tvStoreTime;

        public StoreTimeViewHolderItem(View itemView) {
            super(itemView);
            tvDow = itemView.findViewById(R.id.tvDow);
            tvStoreTime = itemView.findViewById(R.id.tvStoreTime);
        }
    }
}