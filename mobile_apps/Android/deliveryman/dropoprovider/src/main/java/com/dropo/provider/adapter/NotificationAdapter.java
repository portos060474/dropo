package com.dropo.provider.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.persistentroomdata.Notification;

import java.util.List;

public class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.NotificationViewHolder> {

    private List<Notification> notifications;

    @SuppressLint("NotifyDataSetChanged")
    public void setNotifications(List<Notification> notifications) {
        this.notifications = notifications;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public NotificationViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new NotificationViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_notification, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull NotificationViewHolder holder, int position) {
        Notification notification = notifications.get(position);
        holder.tvNotificationMsg.setText(notification.getMessage());
        holder.tvNotificationDate.setText(notification.getDate());
        holder.div.setVisibility(getItemCount() - 1 == position ? View.GONE : View.VISIBLE);
    }

    @Override
    public int getItemCount() {
        return notifications == null ? 0 : notifications.size();
    }

    protected static class NotificationViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvNotificationMsg;
        private final TextView tvNotificationDate;
        private final View div;

        public NotificationViewHolder(@NonNull View itemView) {
            super(itemView);
            tvNotificationMsg = itemView.findViewById(R.id.tvNotificationMsg);
            tvNotificationDate = itemView.findViewById(R.id.tvNotificationDate);
            div = itemView.findViewById(R.id.div);
        }
    }
}