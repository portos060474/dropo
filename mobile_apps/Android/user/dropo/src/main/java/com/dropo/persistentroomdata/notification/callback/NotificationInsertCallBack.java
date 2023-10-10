package com.dropo.persistentroomdata.notification.callback;

import androidx.annotation.MainThread;

import com.dropo.persistentroomdata.notification.Notification;

public interface NotificationInsertCallBack {

    @MainThread
    void onNotificationInsert(Notification notification);

}
