package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.dropo.store.R;
import com.dropo.store.HistoryActivity;
import com.dropo.store.HistoryDetailActivity;
import com.dropo.store.models.datamodel.OrderData;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PinnedHeaderItemDecoration;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TreeSet;

public class HistoryAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements PinnedHeaderItemDecoration.PinnedHeaderAdapter, Filterable {

    public static final String TAG = "TripHistoryAdapter";
    private static final int TYPE_ITEM = 0;
    private static final int TYPE_SEPARATOR = 1;
    private final ArrayList<OrderData> orderLists;
    private List<OrderData> filterList;
    private final TreeSet<Integer> separatorsSet;
    private final ParseContent parseContent;
    private final SimpleDateFormat dateFormat;
    private final HistoryActivity historyActivity;
    private final Context context;

    public HistoryAdapter(HistoryActivity historyActivity, ArrayList<OrderData> orderLists, TreeSet<Integer> separatorsSet, Context context) {
        this.historyActivity = historyActivity;
        this.orderLists = orderLists;
        this.filterList = orderLists;
        this.separatorsSet = separatorsSet;
        parseContent = ParseContent.getInstance();
        dateFormat = parseContent.dateFormat;
        this.context = context;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == TYPE_ITEM) {
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_history, parent, false);
            return new ViewHolderHistory(v);
        } else if (viewType == TYPE_SEPARATOR) {
            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_history_section, parent, false);
            return new ViewHolderSeparator(v);
        }
        return null;
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        OrderData orderData = filterList.get(position);
        if (holder instanceof ViewHolderHistory) {
            ViewHolderHistory viewHolder = (ViewHolderHistory) holder;
            viewHolder.tvOrderNo.setText(String.valueOf(orderData.getUniqueId()));
            UserDetail userDetails = orderData.getUserDetail();
            if (userDetails != null) {
                viewHolder.tvClientName.setText(userDetails.getName());
                Glide.with(historyActivity).load(IMAGE_URL + userDetails.getImageUrl()).placeholder(R.drawable.placeholder).dontAnimate().fallback(R.drawable.placeholder).into(viewHolder.ivClientHistory);
            }
            if (orderData.getOrderStatus() != Constant.DELIVERY_MAN_COMPLETE_DELIVERY) {
                viewHolder.ivCanceled.setVisibility(View.VISIBLE);
                viewHolder.ivClientHistory.setColorFilter(ResourcesCompat.getColor(context.getResources(), R.color.color_app_transparent_white, null));
            } else {
                viewHolder.ivCanceled.setVisibility(View.GONE);
                viewHolder.ivClientHistory.setColorFilter(ResourcesCompat.getColor(context.getResources(), android.R.color.transparent, null));
            }
            viewHolder.tvOrderPrice.setText(PreferenceHelper.getPreferenceHelper(context).getCurrency().
                    concat(parseContent.decimalTwoDigitFormat.format(orderData.getTotal())));
            try {
                viewHolder.tvOrderTime.setText(parseContent.timeFormat_am.format(parseContent.webFormat.parse(orderData.getCompletedAt())).toUpperCase());
            } catch (ParseException e) {
                Utilities.handleThrowable(TAG, e);
            }
        } else {
            ViewHolderSeparator viewHolderSeparator = (ViewHolderSeparator) holder;
            Date getDate;
            Date currentDate = new Date();
            String date = dateFormat.format(currentDate);
            if (orderData.getCompletedAt().equals(date)) {
                viewHolderSeparator.tvSection.setText(historyActivity.getResources().getString(R.string.text_today));
            } else if (orderData.getCompletedAt().equals(getYesterdayDateString())) {
                viewHolderSeparator.tvSection.setText(historyActivity.getResources().getString(R.string.text_yesterday));
            } else {
                try {
                    getDate = dateFormat.parse(orderData.getCompletedAt());
                    if (getDate != null) {
                        String daySuffix = Utilities.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(getDate)));
                        viewHolderSeparator.tvSection.setText(String.format("%s %s", daySuffix, parseContent.dateFormatMonth.format(getDate)));
                    }
                } catch (ParseException e) {
                    Utilities.handleException(TAG, e);
                }
            }
        }
    }

    @Override
    public int getItemCount() {
        return filterList.size();
    }

    @Override
    public int getItemViewType(int position) {
        return separatorsSet.contains(position) ? TYPE_SEPARATOR : TYPE_ITEM;
    }

    private String getYesterdayDateString() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        return dateFormat.format(cal.getTime());
    }

    private void gotoHistoryDetailsActivity(String orderId) {
        Intent historyDetailsIntent = new Intent(historyActivity, HistoryDetailActivity.class);
        historyDetailsIntent.putExtra(Constant.ORDER_ID, orderId);
        historyActivity.startActivity(historyDetailsIntent);
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == TYPE_SEPARATOR;
    }

    @Override
    public Filter getFilter() {
        return filter;
    }

    private final Filter filter = new Filter() {
        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String charString = constraint.toString();
            if (charString.isEmpty()) {
                filterList = orderLists;
            } else {
                List<OrderData> filteredList = new ArrayList<>();
                for (OrderData row : orderLists) {
                    if (row.getUserDetail() != null
                            && row.getUserDetail().getName().toLowerCase().contains(charString.toLowerCase())) {
                        filteredList.add(row);
                    }
                }

                filterList = filteredList;
            }

            FilterResults filterResults = new FilterResults();
            filterResults.values = filterList;
            return filterResults;
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            filterList = (List<OrderData>) results.values;
            notifyDataSetChanged();
        }
    };

    private class ViewHolderHistory extends RecyclerView.ViewHolder implements View.OnClickListener {
        private final TextView tvOrderTime;
        private final TextView tvOrderNo;
        private final TextView tvClientName;
        private final TextView tvOrderPrice;
        private final ImageView ivClientHistory;
        private final ImageView ivCanceled;
        LinearLayout layoutHistory;

        ViewHolderHistory(View iteamView) {
            super(iteamView);
            tvClientName = iteamView.findViewById(R.id.tvClientName);
            tvOrderPrice = iteamView.findViewById(R.id.tvOrderPrice);
            tvOrderTime = iteamView.findViewById(R.id.tvOrderTime);
            ivClientHistory = iteamView.findViewById(R.id.ivClientHistory);
            layoutHistory = iteamView.findViewById(R.id.layoutHistory);
            layoutHistory.setOnClickListener(this);
            tvOrderNo = iteamView.findViewById(R.id.tvOrderNo);
            ivCanceled = iteamView.findViewById(R.id.ivCanceled);
        }

        @Override
        public void onClick(View view) {
            if (view.getId() == R.id.layoutHistory) {
                int position = getAbsoluteAdapterPosition();
                gotoHistoryDetailsActivity(filterList.get(position).getId());
            }
        }
    }

    private static class ViewHolderSeparator extends RecyclerView.ViewHolder {
        private final CustomTextView tvSection;

        public ViewHolderSeparator(View itemView) {
            super(itemView);
            tvSection = itemView.findViewById(R.id.tvSection);
        }
    }
}