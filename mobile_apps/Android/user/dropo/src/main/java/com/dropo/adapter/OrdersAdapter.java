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
import com.dropo.models.datamodels.Order;
import com.dropo.parser.ParseContent;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrdersAdapter extends RecyclerView.Adapter<OrdersAdapter.OrderHolder> implements Filterable {

    private final ArrayList<Order> orderArrayList;
    private final Context context;
    private final OrdersActivity.OrderSelectListener orderSelectListener;
    private List<Order> filterList;

    public OrdersAdapter(Context context, ArrayList<Order> orderArrayList, @NonNull OrdersActivity.OrderSelectListener orderSelectListener) {
        this.orderArrayList = orderArrayList;
        this.filterList = orderArrayList;
        this.context = context;
        this.orderSelectListener = orderSelectListener;
    }

    @NonNull
    @Override
    public OrderHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_ordres, parent, false);
        return new OrderHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull OrderHolder holder, int position) {
        Order order = filterList.get(position);
        if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
            if (order.getDestinationAddresses() != null
                    && !order.getDestinationAddresses().isEmpty()
                    && order.getDestinationAddresses().get(0).getUserDetails() != null) {
                holder.tvStoreName.setText(order.getDestinationAddresses().get(0).getUserDetails().getName());
            } else {
                holder.tvStoreName.setText(context.getString(R.string.text_minus));
            }
            holder.tvOrderStatus.setText(getStringCourierStatus(order.getDeliveryStatus()));
            holder.tvOrderStatus.setTextColor(Utils.setStatusColor(context, Const.COLOR_STATUS_PREFIX, order.getOrderStatus(), order.isOrderChange()));
            holder.tvOrderType.setVisibility(View.VISIBLE);
        } else {
            int status = Math.max(order.getDeliveryStatus(), order.getOrderStatus());
            holder.tvStoreName.setText(order.getStoreName());
            if (order.isOrderChange()) {
                holder.itemView.setBackgroundColor(context.getResources().getColor(R.color.color_app_edit_order));
            }
            holder.tvOrderStatus.setText(getStringOrderStatus(status, order.isOrderChange()));
            holder.tvOrderStatus.setTextColor(Utils.setStatusColor(context, Const.COLOR_STATUS_PREFIX, status, order.isOrderChange()));
            holder.tvOrderType.setVisibility(View.GONE);
        }
        String orderNumber = context.getResources().getString(R.string.text_order_number) + " " + "#" + order.getUniqueId();
        holder.tvOrderNumber.setText(orderNumber);
        try {
            Date date = ParseContent.getInstance().webFormat.parse(order.getCreatedAt());
            if (date != null) {
                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(ParseContent.getInstance().day.format(date))) + " " + ParseContent.getInstance().dateFormatMonth.format(date);
                holder.tvOrderDate.setText(String.format("%s, %s", dateString, ParseContent.getInstance().timeFormat_am.format(date)));
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        holder.divHistory.setVisibility(getItemCount() - 1 == position ? View.GONE : View.VISIBLE);
    }

    @Override
    public int getItemCount() {
        return filterList == null ? 0 : filterList.size();
    }

    private String getStringOrderStatus(int status, boolean isOrderChange) {
        String message;
        switch (status) {
            case Const.OrderStatus.WAITING_FOR_ACCEPT_STORE:
                if (isOrderChange) {
                    message = context.getResources().getString(R.string.msg_wait_for_orde_confirmation);
                } else {
                    message = context.getResources().getString(R.string.msg_wait_for_accept_order_by_store);
                }
                break;
            case Const.OrderStatus.STORE_ORDER_ACCEPTED:
                message = context.getResources().getString(R.string.msg_store_accepted);
                break;
            case Const.OrderStatus.STORE_ORDER_REJECTED:
                message = context.getResources().getString(R.string.msg_store_rejected);
                break;
            case Const.OrderStatus.STORE_ORDER_PREPARING:
                message = context.getResources().getString(R.string.msg_store_prepare_order);
                break;
            case Const.OrderStatus.STORE_ORDER_READY:
            case Const.OrderStatus.DELIVERY_MAN_NOT_FOUND:
            case Const.OrderStatus.DELIVERY_MAN_REJECTED:
            case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
            case Const.OrderStatus.WAITING_FOR_DELIVERY_MEN:
            case Const.OrderStatus.STORE_CANCELLED_REQUEST:
                message = context.getResources().getString(R.string.msg_store_ready_order);
                break;
            case Const.OrderStatus.DELIVERY_MAN_ACCEPTED:
            case Const.OrderStatus.DELIVERY_MAN_COMING:
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED:
            case Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                message = context.getResources().getString(R.string.msg_delivery_man_picked_order);
                break;
            case Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                message = context.getResources().getString(R.string.msg_delivery_man_started_delivery);
                break;
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                message = context.getResources().getString(R.string.msg_delivery_man_arrived_at_destination);
                break;
            case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                message = context.getResources().getString(R.string.msg_delivery_man_complete_delivery);
                break;
            case Const.OrderStatus.TABLE_BOOKING_ARRIVED:
                message = context.getResources().getString(R.string.msg_table_booking_arrived);
                break;
            default:
                message = context.getResources().getString(R.string.text_unknown);
                break;
        }
        return message;
    }

    private String getStringCourierStatus(int status) {
        String message;
        switch (status) {
            case Const.OrderStatus.WAITING_FOR_DELIVERY_MEN:
            case Const.OrderStatus.DELIVERY_MAN_REJECTED:
            case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
            case Const.OrderStatus.DELIVERY_MAN_NOT_FOUND:
                message = context.getResources().getString(R.string.msg_wating_for_accept_courier);
                break;
            case Const.OrderStatus.DELIVERY_MAN_ACCEPTED:
            case Const.OrderStatus.DELIVERY_MAN_COMING:
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED:
                message = context.getResources().getString(R.string.msg_courier_accepted);
                break;
            case Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER:
                message = context.getResources().getString(R.string.msg_delivery_man_picked_courier);
                break;
            case Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                message = context.getResources().getString(R.string.msg_delivery_man_started_delivery_courier);
                break;
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                message = context.getResources().getString(R.string.msg_delivery_man_arrived_at_destination_courier);
                break;
            case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                message = context.getResources().getString(R.string.msg_delivery_man_complete_courier_delivery);
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
                    filterList = orderArrayList;
                } else {
                    List<Order> filteredList = new ArrayList<>();
                    for (Order order : orderArrayList) {
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
                filterList = (List<Order>) results.values;
                notifyDataSetChanged();
            }
        };
    }

    public List<Order> getItemList() {
        return filterList;
    }

    protected class OrderHolder extends RecyclerView.ViewHolder {
        private final TextView tvOrderNumber, tvOrderType;
        private final TextView tvOrderStatus, tvOrderDate, tvStoreName;
        private final View divHistory;

        public OrderHolder(View itemView) {
            super(itemView);
            tvOrderStatus = itemView.findViewById(R.id.tvOrderStatus);
            tvOrderType = itemView.findViewById(R.id.tvOrderType);
            tvOrderDate = itemView.findViewById(R.id.tvOrderDate);
            tvOrderNumber = itemView.findViewById(R.id.tvOrderNumber);
            divHistory = itemView.findViewById(R.id.divHistory);
            itemView.setOnClickListener(view -> orderSelectListener.onOrderSelect(getAbsoluteAdapterPosition()));
            tvStoreName = itemView.findViewById(R.id.tvStoreName);
        }
    }
}