package com.dropo.provider.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.models.datamodels.OrderProductItem;
import com.dropo.provider.models.datamodels.OrderProducts;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.SectionedRecyclerViewAdapter;

import java.util.List;
import java.util.Locale;

public class HistoryDetailAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final List<OrderProducts> orderList;
    private final ParseContent parseContent;
    private Context context;

    public HistoryDetailAdapter(List<OrderProducts> orderList) {
        this.orderList = orderList;
        parseContent = ParseContent.getInstance();
    }

    @Override
    public int getSectionCount() {
        return orderList.size();
    }

    @Override
    public int getItemCount(int section) {
        return orderList.get(section).getItems().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {

    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        OrderHistoryDetailHolder orderHistoryDetailHolder = (OrderHistoryDetailHolder) holder;
        List<OrderProductItem> cartProductItemList = orderList.get(section).getItems();
        OrderProductItem cartProductItems = cartProductItemList.get(relativePosition);
        orderHistoryDetailHolder.tvOderItemName.setText(cartProductItems.getItemName());
        orderHistoryDetailHolder.tvDetail.setText(cartProductItems.getDetails());
        orderHistoryDetailHolder.tvOrderQuantity.setText(String.format(Locale.getDefault(), "%s %d", context.getResources().getString(R.string.text_qty_c), cartProductItems.getQuantity()));
        orderHistoryDetailHolder.tvOrderItemPrice.setText(String.format("%s%s", CurrentOrder.getInstance().getCurrency(), parseContent.decimalTwoDigitFormat.format(cartProductItems.getTotalItemAndSpecificationPrice())));
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view;
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_divider, parent, false);
                return new OrderViewHolder(view);
            case VIEW_TYPE_ITEM:
                view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_history_detail_item, parent, false);
                return new OrderHistoryDetailHolder(view);
            default:
                break;
        }
        return null;
    }

    protected static class OrderViewHolder extends RecyclerView.ViewHolder {
        public OrderViewHolder(View itemView) {
            super(itemView);
        }
    }

    protected static class OrderHistoryDetailHolder extends RecyclerView.ViewHolder {
        TextView tvOderItemName, tvOrderQuantity, tvOrderItemPrice, tvDetail;

        public OrderHistoryDetailHolder(View itemView) {
            super(itemView);
            tvOderItemName = itemView.findViewById(R.id.tvOderItemName);
            tvOrderQuantity = itemView.findViewById(R.id.tvOrderQuantity);
            tvOrderItemPrice = itemView.findViewById(R.id.tvOrderItemPrice);
            tvDetail = itemView.findViewById(R.id.tvDetail);
        }
    }
}