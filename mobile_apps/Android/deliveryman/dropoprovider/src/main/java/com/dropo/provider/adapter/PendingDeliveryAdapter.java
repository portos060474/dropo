package com.dropo.provider.adapter;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.AvailableDeliveryActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.Addresses;
import com.dropo.provider.models.datamodels.AvailableOrder;
import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.Utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

public class PendingDeliveryAdapter extends RecyclerView.Adapter<PendingDeliveryAdapter.PendingDeliveryHolder> {

    private final ArrayList<AvailableOrder> pendingOrderList;
    private final AvailableDeliveryActivity availableDeliveryActivity;

    private final ParseContent parseContent;
    private Context context;

    public PendingDeliveryAdapter(AvailableDeliveryActivity availableDeliveryActivity, ArrayList<AvailableOrder> pendingOrderList) {
        this.pendingOrderList = pendingOrderList;
        this.parseContent = ParseContent.getInstance();
        this.availableDeliveryActivity = availableDeliveryActivity;
    }

    @NonNull
    @Override
    public PendingDeliveryHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_delivery, parent, false);
        return new PendingDeliveryHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull PendingDeliveryHolder holder, int position) {
        Order order = pendingOrderList.get(position).getOrderList().get(0);
        try {
            if (TextUtils.isEmpty(order.getEstimatedTimeForReadyOrder())) {
                holder.tvDeliveryDate.setVisibility(View.GONE);
            } else {
                Date date = parseContent.webFormat.parse(order.getEstimatedTimeForReadyOrder());
                if (date != null) {
                    holder.tvDeliveryDate.setText(String.format("%s %s", context.getResources().getString(R.string.text_pick_up_order_after), parseContent.dateTimeFormat.format(date)));
                    holder.tvDeliveryDate.setVisibility(View.VISIBLE);
                }
            }

            if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                holder.tvCustomerName.setText(context.getResources().getString(R.string.text_courier));
            } else {
                holder.tvCustomerName.setText(order.getStoreName());
            }

            ArrayList<Addresses> addressesList = new ArrayList<>();
            addressesList.addAll(order.getPickupAddresses());
            addressesList.addAll(order.getDestinationAddresses());
            DeliveryAddressAdapter addressAdapter = new DeliveryAddressAdapter(context, addressesList);
            holder.rvAddress.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false));
            holder.rvAddress.setNestedScrollingEnabled(false);
            holder.rvAddress.setAdapter(addressAdapter);

            holder.tvDeliveryStatus.setText(getStringDeliveryStatus(order.getDeliveryStatus()));
            holder.tvDeliveryStatus.setTextColor(Utils.setStatusColor(context, Const.COLOR_STATUS_PREFIX, order.getDeliveryStatus()));
            String orderNumber = context.getResources().getString(R.string.text_order_number) + " " + "#" + order.getOrderUniqueId();

            holder.tvOrderNumber.setText(orderNumber);
            GlideApp.with(availableDeliveryActivity).load(IMAGE_URL + order.getStoreImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(availableDeliveryActivity.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(availableDeliveryActivity.getResources(), R.drawable.placeholder, null)).into(holder.ivCustomerImage);

            holder.ivContactLessDelivery.setVisibility(order.isAllowContactlessDelivery() ? View.VISIBLE : View.GONE);
        } catch (ParseException e) {
            AppLog.handleException(PendingDeliveryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return pendingOrderList.size();
    }

    private String getStringDeliveryStatus(int status) {
        String message = "";
        if (status == Const.ProviderStatus.DELIVERY_MAN_NEW_DELIVERY) {
            message = availableDeliveryActivity.getResources().getString(R.string.msg_new_delivery);
        }
        return message;
    }

    protected static class PendingDeliveryHolder extends RecyclerView.ViewHolder {
        ImageView ivCustomerImage, ivContactLessDelivery;
        CustomFontTextView tvDeliveryDate, tvDeliveryStatus, tvOrderNumber;
        CustomFontTextViewTitle tvCustomerName;
        RecyclerView rvAddress;

        public PendingDeliveryHolder(View itemView) {
            super(itemView);
            ivContactLessDelivery = itemView.findViewById(R.id.ivContactLessDelivery);
            ivCustomerImage = itemView.findViewById(R.id.ivCustomerImage);
            tvCustomerName = itemView.findViewById(R.id.tvCustomerName);
            tvDeliveryDate = itemView.findViewById(R.id.tvDeliveryDate);
            tvDeliveryStatus = itemView.findViewById(R.id.tvDeliveryStatus);
            tvOrderNumber = itemView.findViewById(R.id.tvOrderNumber);
            rvAddress = itemView.findViewById(R.id.rvAddress);
        }
    }
}