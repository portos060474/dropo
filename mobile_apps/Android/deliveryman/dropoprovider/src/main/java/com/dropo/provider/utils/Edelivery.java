package com.dropo.provider.utils;

import android.app.Application;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.ContentResolver;
import android.content.Context;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import com.dropo.provider.R;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.service.EdeliveryUpdateLocationAndOrderService;
import com.dropo.provider.service.FcmMessagingService;

public class Edelivery extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        ApiClient.setLanguage(PreferenceHelper.getInstance(this.getApplicationContext()).getLanguageIndex());
        ApiClient.setLanguageCode(PreferenceHelper.getInstance(this.getApplicationContext()).getLanguageCode());
        String providerId = PreferenceHelper.getInstance(this.getApplicationContext()).getProviderId();
        String token = PreferenceHelper.getInstance(this.getApplicationContext()).getSessionToken();
        if (!TextUtils.isEmpty(providerId) && !TextUtils.isEmpty(token)) {
            ApiClient.setLoginDetail(providerId, token);
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
            NotificationChannel mChannel = new NotificationChannel(FcmMessagingService.CHANNEL_ID, "Order Status", NotificationManager.IMPORTANCE_DEFAULT);
            mChannel.enableVibration(true);
            mChannel.enableLights(true);
            notificationManager.createNotificationChannel(mChannel);

            //new order notification channel
            AudioAttributes audioAttributes = new AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .build();

            Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + getPackageName() + "/" + R.raw.request_sound);
            NotificationChannel mChannel2 = new NotificationChannel(FcmMessagingService.CHANNEL_ID_NEW_ORDER, "New Order", NotificationManager.IMPORTANCE_HIGH);
            mChannel2.enableVibration(true);
            mChannel2.enableLights(true);
            mChannel2.setSound(soundUri, audioAttributes);
            notificationManager.createNotificationChannel(mChannel2);

            //update location service notification channel
            NotificationChannel mChannel3 = new NotificationChannel(EdeliveryUpdateLocationAndOrderService.CHANNEL_ID_UPDATE_SERVICE, "Location Service", NotificationManager.IMPORTANCE_DEFAULT);
            notificationManager.createNotificationChannel(mChannel3);
        }
    }
}
