package com.dropo.provider.adapter;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.fragments.HistoryFragment;
import com.dropo.provider.models.datamodels.OrderHistory;
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.PinnedHeaderItemDecoration;
import com.dropo.provider.utils.Utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TreeSet;

public class HistoryAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final int HEADER = 1;
    private final TreeSet<Integer> separatorSet;
    private final ArrayList<OrderHistory> orderHistoryArrayList;
    private final ParseContent parseContent;
    private final HistoryFragment historyFragment;
    private Context context;

    public HistoryAdapter(HistoryFragment historyFragment, TreeSet<Integer> separatorSet, ArrayList<OrderHistory> orderHistoryArrayList) {
        parseContent = ParseContent.getInstance();
        this.orderHistoryArrayList = orderHistoryArrayList;
        this.separatorSet = separatorSet;
        this.historyFragment = historyFragment;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        if (viewType == HEADER) {
            return new OrderHistoryDateHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_product_header, parent, false));
        } else {
            return new OrderHistoryHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_hsitory, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        OrderHistory orderHistory = orderHistoryArrayList.get(position);
        try {
            String currentDate = parseContent.dateFormat.format(new Date());
            String dateCompleted = orderHistory.getCompletedAt();

            if (holder instanceof OrderHistoryDateHolder) {
                OrderHistoryDateHolder orderHistoryDateHolder = (OrderHistoryDateHolder) holder;
                if (dateCompleted.equals(currentDate)) {
                    orderHistoryDateHolder.tvHistoryDate.setText(context.getString(R.string.text_today));
                } else if (dateCompleted.equals(getYesterdayDateString())) {
                    orderHistoryDateHolder.tvHistoryDate.setText(context.getString(R.string.text_yesterday));
                } else {
                    Date date = parseContent.dateFormat.parse(orderHistory.getCompletedAt());
                    if (date != null) {
                        String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                        orderHistoryDateHolder.tvHistoryDate.setText(dateString);
                    }
                }
            } else {
                OrderHistoryHolder orderHistoryHolder = (OrderHistoryHolder) holder;

                if (orderHistory.getDeliveryType() == Const.DeliveryType.COURIER) {
                    orderHistoryHolder.tvHistoryStoreName.setText(context.getResources().getString(R.string.text_courier));
                    orderHistoryHolder.ivHistoryStoreImage.setImageResource(R.drawable.placeholder);
                } else {
                    UserDetail userDetail = orderHistory.getUserDetail();
                    if (userDetail != null) {
                        GlideApp.with(context)
                                .load(IMAGE_URL + userDetail.getImageUrl())
                                .dontAnimate()
                                .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                                .into(orderHistoryHolder.ivHistoryStoreImage);
                        orderHistoryHolder.tvHistoryStoreName.setText(userDetail.getName());
                    }
                }

                if (orderHistory.getDeliveryStatus() != Const.ProviderStatus.DELIVERY_MAN_COMPLETE_DELIVERY) {
                    orderHistoryHolder.ivCanceled.setVisibility(View.VISIBLE);
                    orderHistoryHolder.ivHistoryStoreImage.setColorFilter(ResourcesCompat.getColor(context.getResources(), R.color.color_app_transparent_white, null));
                } else {
                    orderHistoryHolder.ivCanceled.setVisibility(View.GONE);
                    orderHistoryHolder.ivHistoryStoreImage.setColorFilter(ResourcesCompat.getColor(context.getResources(), android.R.color.transparent, null));
                }
                orderHistoryHolder.tvHistoryOrderPrice.setText(String.format("%s%s", CurrentOrder.getInstance().getCurrency(), parseContent.decimalTwoDigitFormat.format(orderHistoryArrayList.get(position).getTotal())));

                String orderNumber = context.getResources().getString(R.string.text_request_number) + " " + "#" + orderHistory.getUniqueId();
                orderHistoryHolder.tvHistoryOrderNumber.setText(orderNumber);
                orderHistoryHolder.tvHistoryOrderTime.setText(parseContent.timeFormat_am.format(parseContent.webFormat.parse(orderHistory.getCompletedAt())).toUpperCase());
                orderHistoryHolder.tvProviderProfit.setText(String.format("%s : %s%s", context.getResources().getString(R.string.text_profit), CurrentOrder.getInstance().getCurrency(), parseContent.decimalTwoDigitFormat.format(orderHistoryArrayList.get(position).getProviderProfit())));
            }
        } catch (ParseException e) {
            AppLog.handleException(HistoryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return orderHistoryArrayList.size();
    }

    @Override
    public int getItemViewType(int position) {
        int ITEM = 2;
        return separatorSet.contains(position) ? HEADER : ITEM;
    }

    private String getYesterdayDateString() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        return parseContent.dateFormat.format(cal.getTime());
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == HEADER;
    }

    protected static class OrderHistoryDateHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvHistoryDate;

        public OrderHistoryDateHolder(View itemView) {
            super(itemView);
            tvHistoryDate = itemView.findViewById(R.id.tvStoreProductName);
        }
    }

    protected class OrderHistoryHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        ImageView ivHistoryStoreImage, ivCanceled;
        CustomFontTextView tvHistoryOrderTime, tvHistoryOrderNumber, tvProviderProfit;
        CustomFontTextViewTitle tvHistoryStoreName, tvHistoryOrderPrice;

        public OrderHistoryHolder(View itemView) {
            super(itemView);
            ivHistoryStoreImage = itemView.findViewById(R.id.ivHistoryStoreImage);
            tvHistoryStoreName = itemView.findViewById(R.id.tvHistoryStoreName);
            tvHistoryOrderTime = itemView.findViewById(R.id.tvHistoryOrderTime);
            tvHistoryOrderPrice = itemView.findViewById(R.id.tvHistoryOrderPrice);
            tvHistoryOrderNumber = itemView.findViewById(R.id.tvHistoryOrderNumber);
            ivCanceled = itemView.findViewById(R.id.ivCanceled);
            tvProviderProfit = itemView.findViewById(R.id.tvProviderProfit);
            itemView.findViewById(R.id.llProduct).setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            if (R.id.llProduct == view.getId()) {
                historyFragment.goToHistoryOderDetailActivity(orderHistoryArrayList.get(getAbsoluteAdapterPosition()).getId());
            }
        }
    }
}