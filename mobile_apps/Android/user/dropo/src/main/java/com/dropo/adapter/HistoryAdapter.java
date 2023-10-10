package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.OrdersActivity;
import com.dropo.user.R;
import com.dropo.models.datamodels.OrderHistory;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HistoryAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements Filterable {

    private final ArrayList<OrderHistory> orderHistoryArrayList;
    private List<OrderHistory> filterList;
    private final ParseContent parseContent;
    private final Context context;
    private final OrdersActivity.OrderSelectListener orderSelectListener;

    public HistoryAdapter(Context context, ArrayList<OrderHistory> orderHistoryArrayList, @NonNull OrdersActivity.OrderSelectListener orderSelectListener) {
        parseContent = ParseContent.getInstance();
        this.orderHistoryArrayList = orderHistoryArrayList;
        this.filterList = orderHistoryArrayList;
        this.context = context;
        this.orderSelectListener = orderSelectListener;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new OrderHistoryHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_hsitory, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        try {
            OrderHistory orderHistory = filterList.get(position);
            OrderHistoryHolder orderHistoryHolder = (OrderHistoryHolder) holder;

            Date date = parseContent.webFormat.parse(orderHistory.getCreatedAt());
            if (date != null) {
                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                orderHistoryHolder.tvHistoryOrderTime.setText(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
            }
            ((OrderHistoryHolder) holder).tvHistoryOrderStatus.setTextColor(Utils.setStatusColor(context, Const.COLOR_STATUS_PREFIX, orderHistory.getOrderStatus(), false));
            orderHistoryHolder.tvHistoryOrderStatus.setText(getStringOrderStatus(orderHistory.getOrderStatus()));

            String orderNumber = context.getResources().getString(R.string.text_order_number) + " " + "#" + orderHistory.getUniqueId();
            orderHistoryHolder.tvHistoryOrderNumber.setText(orderNumber);

            if (getItemCount() - 1 == position) {
                orderHistoryHolder.divHistory.setVisibility(View.GONE);
            } else {
                orderHistoryHolder.divHistory.setVisibility(View.VISIBLE);
            }
            if (orderHistory.getDeliveryType() == Const.DeliveryType.COURIER) {
                if (orderHistory.getDestinationAddresses() != null
                        && !orderHistory.getDestinationAddresses().isEmpty()
                        && orderHistory.getDestinationAddresses().get(0).getUserDetails() != null) {
                    orderHistoryHolder.tvStoreName.setText(orderHistory.getDestinationAddresses().get(0).getUserDetails().getName());
                } else {
                    orderHistoryHolder.tvStoreName.setText(context.getString(R.string.text_minus));
                }
                orderHistoryHolder.tvOrderType.setVisibility(View.VISIBLE);
            } else {
                orderHistoryHolder.tvStoreName.setText(orderHistory.getStoreDetail().getName());
                orderHistoryHolder.tvOrderType.setVisibility(View.GONE);
            }
        } catch (ParseException e) {
            AppLog.handleException(HistoryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return filterList == null ? 0 : filterList.size();
    }

    private String getStringOrderStatus(int status) {
        String message;
        switch (status) {
            case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                message = context.getResources().getString(R.string.msg_delivery_man_complete_delivery);
                break;
            case Const.OrderStatus.ORDER_CANCELED_BY_USER:
                message = context.getResources().getString(R.string.text_cancel_order);
                break;
            case Const.OrderStatus.STORE_ORDER_REJECTED:
                message = context.getResources().getString(R.string.msg_store_rejected);
                break;
            case Const.OrderStatus.STORE_ORDER_CANCELLED:
                message = context.getResources().getString(R.string.text_canceled_by_store);
                break;
            case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
                message = context.getResources().getString(R.string.text_canceled_by_deliveryman);
                break;
            default:
                message = context.getResources().getString(R.string.text_unknown);
                break;
        }
        return message;
    }

    @Override
    public Filter getFilter() {
        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence constraint) {
                String charString = constraint.toString();
                if (charString.isEmpty()) {
                    filterList = orderHistoryArrayList;
                } else {
                    List<OrderHistory> filteredList = new ArrayList<>();
                    for (OrderHistory order : orderHistoryArrayList) {
                        if (String.valueOf(order.getDeliveryType()).equalsIgnoreCase(charString)) {
                            filteredList.add(order);
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
                filterList = (List<OrderHistory>) results.values;
                notifyDataSetChanged();
            }
        };
    }

    public List<OrderHistory> getItemList() {
        return filterList;
    }

    protected class OrderHistoryHolder extends RecyclerView.ViewHolder {
        TextView tvHistoryOrderTime, tvHistoryOrderStatus, tvOrderType;
        TextView tvHistoryOrderNumber, tvStoreName;
        View divHistory;

        public OrderHistoryHolder(View itemView) {
            super(itemView);
            tvHistoryOrderTime = itemView.findViewById(R.id.tvHistoryOrderTime);
            tvOrderType = itemView.findViewById(R.id.tvOrderType);
            tvHistoryOrderStatus = itemView.findViewById(R.id.tvHistoryOrderStatus);
            tvHistoryOrderNumber = itemView.findViewById(R.id.tvHistoryOrderNumber);
            divHistory = itemView.findViewById(R.id.divHistory);
            tvStoreName = itemView.findViewById(R.id.tvStoreName);
            itemView.setOnClickListener(view -> orderSelectListener.onOrderSelect(getAbsoluteAdapterPosition()));
        }
    }
}