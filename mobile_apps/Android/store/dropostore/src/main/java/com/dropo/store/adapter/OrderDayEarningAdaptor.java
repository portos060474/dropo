package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.widgets.CustomTextView;


import java.util.List;

public class OrderDayEarningAdaptor extends RecyclerView.Adapter<OrderDayEarningAdaptor.OrderDayView> {

    private final List<Object> orderPaymentsItemList;
    private final ParseContent parseContent;

    public OrderDayEarningAdaptor(List<Object> orderPaymentsItemList) {
        this.orderPaymentsItemList = orderPaymentsItemList;
        parseContent = ParseContent.getInstance();
    }

    @NonNull
    @Override
    public OrderDayView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_payment_and_earning, parent, false);
        return new OrderDayView(view);
    }

    @Override
    public void onBindViewHolder(OrderDayView holder, int position) {
        OrderPaymentDetail orderPayment = (OrderPaymentDetail) orderPaymentsItemList.get(position);
        holder.tvOderNumber.setText(String.valueOf(orderPayment.getOrderUniqueId()));
        holder.tvTotal.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotal()));
        holder.tvOrderFees.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotalOrderPrice()));
        holder.tvProfit.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotalStoreIncome()));
        holder.tvPaidShare.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getStoreHaveServicePayment()));
        holder.tvPaidOrder.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getStoreHaveOrderPayment()));
        holder.tvEarn.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getPayToStore()));
    }

    @Override
    public int getItemCount() {
        return orderPaymentsItemList.size();
    }


    protected static class OrderDayView extends RecyclerView.ViewHolder {
        CustomTextView tvOderNumber, tvTotal, tvProfit, tvPaidShare, tvPaidOrder, tvEarn, tvOrderFees;

        public OrderDayView(View itemView) {
            super(itemView);
            tvOderNumber = itemView.findViewById(R.id.tvOderNumber);
            tvTotal = itemView.findViewById(R.id.tvTotal);
            tvProfit = itemView.findViewById(R.id.tvProfit);
            tvPaidShare = itemView.findViewById(R.id.tvPaidShare);
            tvPaidOrder = itemView.findViewById(R.id.tvPaidOrder);
            tvEarn = itemView.findViewById(R.id.tvEarn);
            tvOrderFees = itemView.findViewById(R.id.tvOrderFees);
        }
    }
}