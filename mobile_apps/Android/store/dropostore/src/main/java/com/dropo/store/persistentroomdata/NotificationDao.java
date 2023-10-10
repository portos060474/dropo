package com.dropo.store.persistentroomdata;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

@Dao
public interface NotificationDao {
    @Query("SELECT * FROM notification WHERE notification_type = :notificationType")
    List<Notification> getAllNotification(int notificationType);

    @Insert
    void insert(Notification notification);

    @Delete
    void delete(Notification notification);

    @Update
    void update(Notification notification);

    @Query("DELETE FROM notification")
    void deleteAllNotification();
}
