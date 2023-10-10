package com.dropo.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.NotificationActivity;
import com.dropo.user.R;
import com.dropo.adapter.NotificationAdapter;
import com.dropo.persistentroomdata.notification.Notification;
import com.dropo.persistentroomdata.notification.NotificationRepository;
import com.dropo.persistentroomdata.notification.callback.NotificationLoadCallBack;

import java.util.List;

public class OrderNotificationFragment extends Fragment {

    private NotificationActivity activity;
    private RecyclerView rcvOrderNotification;
    private LinearLayout ivEmpty;
    private NotificationAdapter notificationAdapter;
    private SwipeRefreshLayout srlNotification;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (NotificationActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_order_notification, container, false);
        rcvOrderNotification = view.findViewById(R.id.rcvOrderNotification);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        srlNotification = view.findViewById(R.id.srlNotification);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        notificationAdapter = new NotificationAdapter();
        rcvOrderNotification.setAdapter(notificationAdapter);
        srlNotification.setOnRefreshListener(this::getNotification);
        activity.setColorSwipeToRefresh(srlNotification);
    }

    @Override
    public void onResume() {
        super.onResume();
        getNotification();
    }

    private void getNotification() {
        NotificationRepository.getInstance(activity).getNotification(Notification.ORDER_TYPE, new NotificationLoadCallBack() {
            @Override
            public void onNotificationLoad(List<Notification> notifications) {
                notificationAdapter.setNotifications(notifications);
                if (notifications != null && !notifications.isEmpty()) {
                    ivEmpty.setVisibility(View.GONE);
                    rcvOrderNotification.setVisibility(View.VISIBLE);
                } else {
                    ivEmpty.setVisibility(View.VISIBLE);
                    rcvOrderNotification.setVisibility(View.GONE);
                }
                srlNotification.setRefreshing(false);
            }

            @Override
            public void onDataNotAvailable() {
                srlNotification.setRefreshing(false);
            }
        });
    }
}