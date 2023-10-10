package com.dropo.store.persistentroomdata.callback;


import androidx.annotation.MainThread;

import com.dropo.store.persistentroomdata.Notification;

public interface NotificationInsertCallBack {

    @MainThread
    void onNotificationInsert(Notification notification);

}
