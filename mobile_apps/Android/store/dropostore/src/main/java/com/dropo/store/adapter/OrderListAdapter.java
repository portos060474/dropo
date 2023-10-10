package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.HomeActivity;
import com.dropo.store.component.NearestProviderDialog;
import com.dropo.store.component.VehicleDialog;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.datamodel.ProviderDetail;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.TwilioCallHelper;
import com.dropo.store.utils.Utilities;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

public class OrderListAdapter extends RecyclerView.Adapter<OrderListAdapter.ViewHolder> {

    private final HomeActivity homeActivity;
    private final ParseContent parseContent;
    private final boolean isOrderListFragment;
    private final SimpleDateFormat dateFormat;
    private final SimpleDateFormat timeFormat;
    private ArrayList<Order> orderList;

    public OrderListAdapter(HomeActivity homeActivity, ArrayList<Order> orderList, boolean isOrderListFragment) {
        this.homeActivity = homeActivity;
        this.orderList = orderList;
        this.isOrderListFragment = isOrderListFragment;
        parseContent = ParseContent.getInstance();
        dateFormat = new SimpleDateFormat(Constant.DATE_FORMAT, Locale.US);
        timeFormat = new SimpleDateFormat(Constant.TIME_FORMAT_AM, Locale.US);
    }

    public ArrayList<Order> getOrderList() {
        return orderList;
    }

    public void setOrderList(ArrayList<Order> orderList) {
        this.orderList = orderList;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(homeActivity).inflate( R.layout.adapter_order_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Order order = orderList.get(holder.getAbsoluteAdapterPosition());
        if (order.getUserDetail() != null) {
            if (order.getUserDetail().getImageUrl() != null) {
                GlideApp.with(homeActivity)
                        .load(IMAGE_URL + order.getUserDetail().getImageUrl())
                        .fallback(R.drawable.placeholder)
                        .dontAnimate()
                        .placeholder(R.drawable.placeholder)
                        .into(holder.ivClient);
            }
            holder.tvClientName.setText(order.getUserDetail().getName());
        }
        holder.layoutRootOrder.setTag(holder.getAbsoluteAdapterPosition());
        holder.llReassign.setTag(holder.getAbsoluteAdapterPosition());
        if (isOrderListFragment) {
            holder.llOrder.setVisibility(View.VISIBLE);
            holder.llDelivery.setVisibility(View.GONE);
            holder.tvStatus.setText(Utilities.setStatusCode(homeActivity, Constant.STATUS_TEXT_PREFIX, order.getOrderStatus(), order.isOrderChange()));
            holder.tvStatus.setTextColor(Utilities.setStatusColor(homeActivity, Constant.COLOR_STATUS_PREFIX, order.getOrderStatus(), order.isOrderChange()));
            if (order.isUserPickUpOrder()) {
                holder.ivPickupType.setImageDrawable(ResourcesCompat.getDrawable(homeActivity.getResources(), R.drawable.ic_takeway_order, homeActivity.getTheme()));
                holder.tvPickupType.setText(R.string.text_pickup_delivery);
            } else if (order.getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
                holder.llPickupType.setVisibility(View.GONE);
            } else {
                holder.ivPickupType.setImageDrawable(ResourcesCompat.getDrawable(homeActivity.getResources(), R.drawable.ic_deliveryman_order, homeActivity.getTheme()));
                holder.tvPickupType.setText(R.string.text_delivery);
            }
        } else {
            holder.llOrder.setVisibility(View.GONE);
            holder.llDelivery.setVisibility(View.VISIBLE);
            holder.tvStatus.setText(Utilities.setStatusCode(homeActivity, Constant.STATUS_TEXT_PREFIX, order.getDeliveryStatus(), order.isOrderChange()));
            holder.tvStatus.setTextColor(Utilities.setStatusColor(homeActivity, Constant.COLOR_STATUS_PREFIX, order.getDeliveryStatus(), order.isOrderChange()));
            if (order.getDeliveryStatus() == Constant.DELIVERY_MAN_REJECTED || order.getDeliveryStatus() == Constant.DELIVERY_MAN_CANCELLED || order.getDeliveryStatus() == Constant.DELIVERY_MAN_NOT_FOUND || order.getDeliveryStatus() == Constant.STORE_CANCELLED_REQUEST) {
                holder.llReassign.setTag(0);
                holder.llReassign.setClickable(true);
                holder.llReassign.setAlpha(1f);
                holder.llReassign.setVisibility(View.GONE);
            } else {
                holder.llReassign.setTag(1);
                holder.llReassign.setAlpha(0.3f);
                holder.llReassign.setClickable(false);
                holder.llReassign.setVisibility(View.GONE);
            }
        }

        holder.tvOrderNo.setText(String.valueOf(order.getOrderUniqueId()));
        holder.tvTotalItemPrice.setText(PreferenceHelper.getPreferenceHelper(homeActivity).getCurrency().concat(parseContent.decimalTwoDigitFormat.format(order.getTotal())));

        if (order.isIsScheduleOrder()) {
            holder.llScheduleOrder.setVisibility(View.VISIBLE);
            holder.tvOrderSchedule.setVisibility(View.VISIBLE);
            try {
                Date date = ParseContent.getInstance().webFormat.parse(order.getScheduleOrderStartAt());
                if (!TextUtils.isEmpty(order.getTimeZone())) {
                    dateFormat.setTimeZone(TimeZone.getTimeZone(order.getTimeZone()));
                    timeFormat.setTimeZone(TimeZone.getTimeZone(order.getTimeZone()));
                }

                if (date != null) {
                    String stringDate = homeActivity.getResources().getString(R.string.text_schedule_on) + " " + dateFormat.format(date) + ", " + timeFormat.format(date);

                    if (!TextUtils.isEmpty(order.getScheduleOrderStartAt2())) {
                        Date date2 = ParseContent.getInstance().webFormat.parse(order.getScheduleOrderStartAt2());
                        if (date2 != null) {
                            stringDate = stringDate + " - " + timeFormat.format(date2);
                        }
                    }
                    holder.tvOrderSchedule.setText(stringDate);
                }
            } catch (ParseException e) {
                Utilities.handleException(OrderListAdapter.class.getName(), e);
            }
        } else {
            holder.llScheduleOrder.setVisibility(View.GONE);
            holder.tvOrderSchedule.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return orderList.size();
    }

    private void openVehicleSelectDialog(final int position, final View btn) {
        final List<VehicleDetail> vehicleDetails = CurrentBooking.getInstance().getVehicleDetails();
        if (vehicleDetails.isEmpty()) {
            Utilities.showToast(homeActivity, homeActivity.getResources().getString(R.string.text_vehicle_not_found));
        } else {
            final VehicleDialog vehicleDialog = new VehicleDialog(homeActivity, vehicleDetails);
            vehicleDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> vehicleDialog.dismiss());
            vehicleDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
                if (TextUtils.isEmpty(vehicleDialog.getVehicleId())) {
                    Utilities.showToast(homeActivity, homeActivity.getResources().getString(R.string.msg_select_vehicle));
                } else {
                    if (vehicleDialog.isManualAssign()) {
                        vehicleDialog.dismiss();
                        openNearestProviderDialog(orderList.get(position).getOrderId(), vehicleDialog.getVehicleId());
                    } else {
                        btn.setVisibility(View.GONE);
                        vehicleDialog.dismiss();
                        homeActivity.deliveriesListFragment.assignDeliveryMan(orderList.get(position).getOrderId(), vehicleDialog.getVehicleId(), null);
                    }
                }
            });
            vehicleDialog.show();
        }
    }

    private void openNearestProviderDialog(final String orderId, final String vehicleId) {
        final NearestProviderDialog providerDialog = new NearestProviderDialog(homeActivity, orderId, vehicleId);
        providerDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> providerDialog.dismiss());
        providerDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            providerDialog.dismiss();
            if (providerDialog.getSelectedProvider() == null) {
                Utilities.showToast(homeActivity, homeActivity.getResources().getString(R.string.msg_select_provider));
            } else {
                homeActivity.deliveriesListFragment.assignDeliveryMan(orderId, vehicleId, providerDialog.getSelectedProvider().getId());
            }
        });
        providerDialog.show();
    }

    protected class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        private final TextView tvClientName;
        private final TextView tvTotalItemPrice;
        private final TextView tvStatus;
        private final TextView tvPickupType;
        private final ImageView ivClient;
        private final ImageView ivPickupType;
        private final LinearLayout layoutRootOrder;
        private final LinearLayout llScheduleOrder;
        private final LinearLayout llDelivery, llPickupType;
        private final LinearLayout llOrder;
        private final LinearLayout llCallUser;
        private final LinearLayout llCallDeliveryman;
        private final LinearLayout llReassign;
        private final TextView tvOrderNo;
        private final TextView tvOrderSchedule;

        ViewHolder(View itemView) {
            super(itemView);
            tvClientName = itemView.findViewById(R.id.tvClientName);
            tvTotalItemPrice = itemView.findViewById(R.id.tvTotalItemPrice);
            tvStatus = itemView.findViewById(R.id.tvStatus);
            ivClient = itemView.findViewById(R.id.ivClient);
            llReassign = itemView.findViewById(R.id.llReassign);
            llReassign.setOnClickListener(this);
            layoutRootOrder = itemView.findViewById(R.id.layout_root_order);
            layoutRootOrder.setOnClickListener(this);
            tvOrderNo = itemView.findViewById(R.id.tvOrderNo);
            llCallUser = itemView.findViewById(R.id.llCallUser);
            llCallUser.setOnClickListener(this);
            tvOrderSchedule = itemView.findViewById(R.id.tvOrderSchedule);
            llScheduleOrder = itemView.findViewById(R.id.llScheduleOrder);
            ivPickupType = itemView.findViewById(R.id.ivPickupType);
            tvPickupType = itemView.findViewById(R.id.tvPickupType);
            llDelivery = itemView.findViewById(R.id.llDelivery);
            llPickupType = itemView.findViewById(R.id.llPickupType);
            llOrder = itemView.findViewById(R.id.llOrder);
            llCallDeliveryman = itemView.findViewById(R.id.llCallDeliveryman);
            llCallDeliveryman.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            int id = v.getId();
            if (id == R.id.llReassign) {
                if (v.getTag() != null && (int) v.getTag() == 0) {
                    openVehicleSelectDialog(getAbsoluteAdapterPosition(), v);
                }
            } else if (id == R.id.layout_root_order) {
                if (isOrderListFragment) {
                    homeActivity.orderListFragment.goToOrderDetailActivity(getAbsoluteAdapterPosition());
                } else {
                    homeActivity.deliveriesListFragment.gotoDeliveryDetails(getAbsoluteAdapterPosition());
                }
            } else if (id == R.id.llCallUser) {
                if (getAbsoluteAdapterPosition() == -1) return;
                UserDetail userDetail = orderList.get(getAbsoluteAdapterPosition()).getUserDetail();
                if (userDetail != null) {
                    if (homeActivity.preferenceHelper.getIsEnableTwilioCallMasking()) {
                        TwilioCallHelper.callViaTwilio(homeActivity, llCallUser, orderList.get(getAbsoluteAdapterPosition()).getId(), String.valueOf(Constant.Type.USER));
                    } else {
                        Utilities.openCallChooser(homeActivity, userDetail.getPhone());
                    }
                }
            } else if (id == R.id.llCallDeliveryman) {
                if (getAbsoluteAdapterPosition() == -1) return;
                ProviderDetail providerDetail = orderList.get(getAbsoluteAdapterPosition()).getProviderDetail();
                if (providerDetail != null) {
                    if (homeActivity.preferenceHelper.getIsEnableTwilioCallMasking()) {
                        TwilioCallHelper.callViaTwilio(homeActivity, llCallUser, orderList.get(getAbsoluteAdapterPosition()).getId(), String.valueOf(Constant.Type.PROVIDER));
                    } else {
                        Utilities.openCallChooser(homeActivity, providerDetail.getPhone());
                    }
                }
            }
        }
    }
}