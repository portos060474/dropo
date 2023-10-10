package com.dropo.persistentroomdata.notification.callback;

import androidx.annotation.MainThread;

import com.dropo.persistentroomdata.notification.Notification;

import java.util.List;

public interface NotificationLoadCallBack {
    @MainThread
    void onNotificationLoad(List<Notification> notifications);

    @MainThread
    void onDataNotAvailable();
}
