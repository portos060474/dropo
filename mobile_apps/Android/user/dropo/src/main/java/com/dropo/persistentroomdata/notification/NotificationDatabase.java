package com.dropo.persistentroomdata.notification;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

@Database(entities = {Notification.class}, version = 1, exportSchema = false)
public abstract class NotificationDatabase extends RoomDatabase {
    private static final Object sLock = new Object();
    private static NotificationDatabase INSTANCE;

    public static NotificationDatabase getInstance(Context context) {

        synchronized (sLock) {
            if (INSTANCE == null) {
                INSTANCE = Room.databaseBuilder(context.getApplicationContext(), NotificationDatabase.class, context.getPackageName() + ".notification.db").build();
            }
            return INSTANCE;
        }
    }

    public abstract NotificationDao notificationDao();

}
