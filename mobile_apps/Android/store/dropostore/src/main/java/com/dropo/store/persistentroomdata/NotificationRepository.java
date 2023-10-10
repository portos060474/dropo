package com.dropo.store.persistentroomdata;

import android.content.Context;

import com.dropo.store.persistentroomdata.callback.NotificationInsertCallBack;
import com.dropo.store.persistentroomdata.callback.NotificationLoadCallBack;

import java.util.List;

public class NotificationRepository {

    private static NotificationRepository INSTANCE;
    private final AppExecutors appExecutors;
    private final NotificationDatabase notificationDatabase;

    private NotificationRepository(Context context) {
        appExecutors = new AppExecutors();
        notificationDatabase = NotificationDatabase.getInstance(context);
    }

    public static NotificationRepository getInstance(Context context) {
        if (INSTANCE == null) {
            INSTANCE = new NotificationRepository(context);
        }
        return INSTANCE;
    }


    public void getNotification(int notificationType, NotificationLoadCallBack notificationLoadCallBack) {
        // request the addresses on the I/O thread
        appExecutors.diskIO().execute(() -> {
            final List<Notification> notifications = notificationDatabase.notificationDao().getAllNotification(notificationType);
            // notify on the main thread
            appExecutors.mainThread().execute(() -> {
                if (notificationLoadCallBack == null) {
                    return;
                }
                if (notifications == null) {
                    notificationLoadCallBack.onDataNotAvailable();
                } else {
                    notificationLoadCallBack.onNotificationLoad(notifications);
                }
            });
        });
    }

    public void insertNotification(Notification notification, NotificationInsertCallBack notificationInsertCallBack) {
        // request the addresses on the I/O thread
        appExecutors.diskIO().execute(() -> {
            notificationDatabase.notificationDao().insert(notification);
            // notify on the main thread
            appExecutors.mainThread().execute(() -> {
                if (notificationInsertCallBack == null) {
                    return;
                }
                notificationInsertCallBack.onNotificationInsert(notification);
            });
        });
    }

    public void clearNotification() {
        appExecutors.diskIO().execute(() -> notificationDatabase.notificationDao().deleteAllNotification());
    }
}
