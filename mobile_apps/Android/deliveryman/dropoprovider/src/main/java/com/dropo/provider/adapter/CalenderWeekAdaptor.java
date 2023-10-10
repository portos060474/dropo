package com.dropo.provider.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.SparseBooleanArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.models.datamodels.WeekData;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppColor;

import java.util.ArrayList;
import java.util.Date;

public class CalenderWeekAdaptor extends RecyclerView.Adapter<CalenderWeekAdaptor.WeekDayView> {

    private final ArrayList<WeekData> weekData;
    private final Context context;
    private final ParseContent parseContent;
    public SparseBooleanArray selectedItems;
    private WeekData date = null;

    public CalenderWeekAdaptor(Context context, ArrayList<WeekData> weekData) {
        this.weekData = weekData;
        this.context = context;
        parseContent = ParseContent.getInstance();
        selectedItems = new SparseBooleanArray();
    }

    @NonNull
    @Override
    public WeekDayView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_week_date, parent, false);
        return new WeekDayView(view);
    }

    @Override
    public void onBindViewHolder(WeekDayView holder, int position) {
        ArrayList<Date> dates = weekData.get(position).getParticularDate();
        String date1 = parseContent.dateFormat3.format(dates.get(0));
        String date2 = parseContent.dateFormat3.format(dates.get(1));
        holder.tvWeekStart.setText(date1);
        holder.tvWeekEnd.setText(date2);
        if (selectedItems.get(position, false)) {
            if (AppColor.isDarkTheme(context)) {
                holder.itemView.setBackgroundColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_tag_dark, null));
            } else {
                holder.itemView.setBackgroundColor(ResourcesCompat.getColor(context.getResources(), R.color.color_app_tag_light, null));
            }
        } else {
            holder.itemView.setBackgroundColor(ResourcesCompat.getColor(context.getResources(), android.R.color.transparent, null));
        }
    }

    @Override
    public int getItemCount() {
        return weekData.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void toggleSelection(int pos) {
        selectedItems.clear();
        selectedItems.put(pos, true);
        date = weekData.get(pos);
        notifyDataSetChanged();
    }

    public WeekData getDate() {
        return date;
    }

    protected static class WeekDayView extends RecyclerView.ViewHolder {
        CustomFontTextView tvWeekStart, tvWeekEnd;

        public WeekDayView(View itemView) {
            super(itemView);
            tvWeekStart = itemView.findViewById(R.id.tvWeekStart);
            tvWeekEnd = itemView.findViewById(R.id.tvWeekEnd);
        }
    }
}