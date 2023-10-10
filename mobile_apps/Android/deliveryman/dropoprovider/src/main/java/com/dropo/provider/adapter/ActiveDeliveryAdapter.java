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
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.Utils;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

public class ActiveDeliveryAdapter extends RecyclerView.Adapter<ActiveDeliveryAdapter.ActiveDeliveryHolder> {

    private final ArrayList<AvailableOrder> activeOrderList;
    private final AvailableDeliveryActivity availableDeliveryActivity;

    private final ParseContent parseContent;
    private Context context;

    public ActiveDeliveryAdapter(AvailableDeliveryActivity availableDeliveryActivity, ArrayList<AvailableOrder> activeOrderList) {
        this.activeOrderList = activeOrderList;
        this.parseContent = ParseContent.getInstance();
        this.availableDeliveryActivity = availableDeliveryActivity;
    }

    @NonNull
    @Override
    public ActiveDeliveryHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_delivery, parent, false);
        return new ActiveDeliveryHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ActiveDeliveryHolder holder, int position) {
        Order order = activeOrderList.get(position).getOrderList().get(0);

        try {
            if (!TextUtils.isEmpty(order.getEstimatedTimeForReadyOrder()) && (order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_ACCEPTED || order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_COMING || order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_ARRIVED)) {
                Date date = parseContent.webFormat.parse(order.getEstimatedTimeForReadyOrder());
                if (date != null) {
                    holder.tvDeliveryDate.setText(String.format("%s %s", context.getResources().getString(R.string.text_pick_up_order_after), parseContent.dateTimeFormat.format(date)));
                    holder.tvDeliveryDate.setVisibility(View.VISIBLE);
                }
            } else {
                holder.tvDeliveryDate.setVisibility(View.GONE);
            }

            String image, name;
            if (isOrderPickedUp(order.getDeliveryStatus())) {
                UserDetail userDetail;
                ArrayList<Addresses> addressesList = new ArrayList<>();
                if (order.getDeliveryStatus() == Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY) {
                    userDetail = order.getDestinationAddresses().get(order.getArrivedAtStopNo()).getUserDetails();
                    addressesList.add(order.getDestinationAddresses().get(order.getArrivedAtStopNo()));
                } else {
                    if (order.getArrivedAtStopNo() != 0) {
                        userDetail = order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1).getUserDetails();
                        addressesList.add(order.getDestinationAddresses().get(order.getArrivedAtStopNo() - 1));
                    } else {
                        userDetail = order.getDestinationAddresses().get(0).getUserDetails();
                        addressesList.add(order.getDestinationAddresses().get(0));
                    }
                }
                name = userDetail.getName();
                image = IMAGE_URL + userDetail.getImageUrl();
                DeliveryAddressAdapter addressAdapter = new DeliveryAddressAdapter(context, addressesList);
                holder.rvAddress.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false));
                holder.rvAddress.setNestedScrollingEnabled(false);
                holder.rvAddress.setAdapter(addressAdapter);
                addressAdapter.setShowPickupPin(false);
            } else {
                if (order.getDeliveryType() == Const.DeliveryType.COURIER) {
                    name = order.getPickupAddresses().get(0).getUserDetails().getName();
                } else {
                    name = order.getStoreName();
                }
                image = IMAGE_URL + order.getStoreImageUrl();
                ArrayList<Addresses> addressesList = new ArrayList<>();
                addressesList.addAll(order.getPickupAddresses());
                addressesList.addAll(order.getDestinationAddresses());
                DeliveryAddressAdapter addressAdapter = new DeliveryAddressAdapter(context, addressesList);
                holder.rvAddress.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false));
                holder.rvAddress.setNestedScrollingEnabled(false);
                holder.rvAddress.setAdapter(addressAdapter);
            }

            holder.tvCustomerName.setText(name);
            holder.tvDeliveryStatus.setText(getStringDeliveryStatus(order.getDeliveryStatus()));
            holder.tvDeliveryStatus.setTextColor(Utils.setStatusColor(context, Const.COLOR_STATUS_PREFIX, order.getDeliveryStatus()));
            String orderNumber = context.getResources().getString(R.string.text_order_number) + " " + "#" + order.getOrderUniqueId();
            holder.tvOrderNumber.setText(orderNumber);
            GlideApp.with(availableDeliveryActivity)
                    .load(image)
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(availableDeliveryActivity.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(availableDeliveryActivity.getResources(), R.drawable.placeholder, null))
                    .into(holder.ivCustomerImage);

            holder.ivContactLessDelivery.setVisibility(order.isAllowContactlessDelivery() ? View.VISIBLE : View.GONE);
        } catch (ParseException e) {
            AppLog.handleException(ActiveDeliveryAdapter.class.getName(), e);
        }
    }

    @Override
    public int getItemCount() {
        return activeOrderList.size();
    }

    private String getStringDeliveryStatus(int status) {
        String message = "";
        switch (status) {
            case Const.ProviderStatus.DELIVERY_MAN_ACCEPTED:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_accepted);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_COMING:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_coming);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_arrived);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_picked_order);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_started_delivery);
                break;
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                message = availableDeliveryActivity.getResources().getString(R.string.msg_delivery_man_arrived_at_destination);
                break;
            default:
                break;
        }
        return message;
    }

    private boolean isOrderPickedUp(int orderStatus) {
        switch (orderStatus) {
            case Const.ProviderStatus.DELIVERY_MAN_ACCEPTED:
            case Const.ProviderStatus.DELIVERY_MAN_COMING:
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED:
                return false;
            case Const.ProviderStatus.DELIVERY_MAN_PICKED_ORDER:
            case Const.ProviderStatus.DELIVERY_MAN_STARTED_DELIVERY:
            case Const.ProviderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                return true;
            default:
                break;
        }
        return false;
    }

    protected static class ActiveDeliveryHolder extends RecyclerView.ViewHolder {
        ImageView ivCustomerImage, ivContactLessDelivery;
        CustomFontTextViewTitle tvCustomerName;
        CustomFontTextView tvDeliveryDate, tvDeliveryStatus, tvOrderNumber;
        RecyclerView rvAddress;

        public ActiveDeliveryHolder(View itemView) {
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
