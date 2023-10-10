package com.dropo.provider.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.parser.ParseContent;

import java.util.List;

public class OrderDayEarningAdaptor extends RecyclerView.Adapter<OrderDayEarningAdaptor.OrderDayView> {

    private final List<Object> orderPaymentsItemList;
    private final Context context;
    private final ParseContent parseContent;

    public OrderDayEarningAdaptor(Context context, List<Object> orderPaymentsItemList) {
        this.orderPaymentsItemList = orderPaymentsItemList;
        this.context = context;
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
        OrderPayment orderPayment = (OrderPayment) orderPaymentsItemList.get(position);
        holder.tvOderNumber.setText(String.valueOf(orderPayment.getOrderUniqueId()));
        holder.tvTotal.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotal()));
        holder.tvServiceFees.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotalDeliveryPrice()));
        holder.tvProfit.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getTotalProviderIncome()));
        holder.tvPaid.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getProviderPaidOrderPayment()));
        holder.tvCash.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getProviderHaveCashPayment()));
        holder.tvEarn.setText(parseContent.decimalTwoDigitFormat.format(orderPayment.getPayToProvider()));
        if (orderPayment.isPaymentModeCash()) {
            holder.tvPayBy.setText(context.getResources().getString(R.string.text_cash));
        } else {
            holder.tvPayBy.setText(context.getResources().getString(R.string.text_card));
        }
    }

    @Override
    public int getItemCount() {
        return orderPaymentsItemList.size();
    }

    protected static class OrderDayView extends RecyclerView.ViewHolder {
        CustomFontTextView tvOderNumber, tvPayBy, tvTotal, tvServiceFees, tvProfit, tvPaid, tvCash, tvEarn;

        public OrderDayView(View itemView) {
            super(itemView);
            tvOderNumber = itemView.findViewById(R.id.tvOderNumber);
            tvPayBy = itemView.findViewById(R.id.tvPayBy);
            tvTotal = itemView.findViewById(R.id.tvTotal);
            tvServiceFees = itemView.findViewById(R.id.tvServiceFees);
            tvProfit = itemView.findViewById(R.id.tvProfit);
            tvPaid = itemView.findViewById(R.id.tvPaid);
            tvCash = itemView.findViewById(R.id.tvCash);
            tvEarn = itemView.findViewById(R.id.tvEarn);
        }
    }
}