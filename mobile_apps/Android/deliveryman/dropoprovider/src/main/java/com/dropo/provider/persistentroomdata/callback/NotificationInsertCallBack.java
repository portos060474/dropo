package com.dropo.provider.persistentroomdata.callback;


import androidx.annotation.MainThread;

import com.dropo.provider.persistentroomdata.Notification;

/**
 * Created by Ravi Bhalodi on 02,July,2020 in Elluminati
 */
public interface NotificationInsertCallBack {

    @MainThread
    void onNotificationInsert(Notification notification);

}
