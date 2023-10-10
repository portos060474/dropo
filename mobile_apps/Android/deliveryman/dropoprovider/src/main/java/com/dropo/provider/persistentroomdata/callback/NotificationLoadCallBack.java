package com.dropo.provider.persistentroomdata.callback;


import androidx.annotation.MainThread;

import com.dropo.provider.persistentroomdata.Notification;

import java.util.List;

/**
 * Created by Ravi Bhalodi on 02,July,2020 in Elluminati
 */
public interface NotificationLoadCallBack {
    @MainThread
    void onNotificationLoad(List<Notification> notifications);

    @MainThread
    void onDataNotAvailable();
}
