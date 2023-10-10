package com.dropo.store.persistentroomdata.callback;


import androidx.annotation.MainThread;

import com.dropo.store.persistentroomdata.Notification;

import java.util.List;

public interface NotificationLoadCallBack {
    @MainThread
    void onNotificationLoad(List<Notification> notifications);

    @MainThread
    void onDataNotAvailable();
}
