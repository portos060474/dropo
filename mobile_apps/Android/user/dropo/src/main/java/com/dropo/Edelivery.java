package com.dropo;

import android.app.Application;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;

import com.dropo.parser.ApiClient;
import com.dropo.service.FcmMessagingService;
import com.dropo.utils.PreferenceHelper;

public class Edelivery extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        ApiClient.setLanguage(PreferenceHelper.getInstance(this.getApplicationContext()).getLanguageIndex());
        ApiClient.setLanguageCode(PreferenceHelper.getInstance(this.getApplicationContext()).getLanguageCode());
        String userid = PreferenceHelper.getInstance(this.getApplicationContext()).getUserId();
        String token = PreferenceHelper.getInstance(this.getApplicationContext()).getSessionToken();
        if (!TextUtils.isEmpty(userid) && !TextUtils.isEmpty(token)) {
            ApiClient.setLoginDetail(userid, token);
        }
        registerNotificationChannels();
    }

    /**
     * register all notification channels
     */
    private void registerNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //order status notification channel
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            NotificationChannel mChannel = new NotificationChannel(FcmMessagingService.CHANNEL_ID, "Order Status", NotificationManager.IMPORTANCE_HIGH);
            mChannel.enableVibration(true);
            mChannel.enableLights(true);
            notificationManager.createNotificationChannel(mChannel);
        }
    }
}
