package com.dropo.provider.service;

import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.dropo.provider.R;
import com.dropo.provider.HomeActivity;
import com.dropo.provider.LoginActivity;

import com.dropo.provider.SplashScreenActivity;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.persistentroomdata.NotificationRepository;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * This Class is handle a Notification which send by Google FCM server.
 */
public class FcmMessagingService extends FirebaseMessagingService {
    public static final String CHANNEL_ID = "channel_01";
    public static final String CHANNEL_ID_NEW_ORDER = "newOrder";

    public static final String MESSAGE = "message";
    public static final String STATUS_PHRASE = "status_phrase";
    public static final String LOGIN_IN_OTHER_DEVICE = "2092";
    public static final String NEW_ORDER = "2031";
    public static final String ADMIN_APPROVED = "2032";
    public static final String ADMIN_DECLINE = "2033";
    public static final String STORE_REJECTED = "2034";
    public static final String STORE_CANCELED = "2035";
    public static final String STORE_CANCELED_REQUEST = "2036";

    private Map<String, String> data;

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        Log.e("FcmMessagingService", "From:" + remoteMessage.getFrom());
        Log.e("FcmMessagingService", "Data:" + remoteMessage.getData());
        data = remoteMessage.getData();
        String message = data.get(MESSAGE);
        if (!TextUtils.isEmpty(message)) {
            oderStatus(message);
        }
    }

    private void sendNotification(String message, int activityId) {
        int notificationId = 2017;
        Intent intent = null;

        switch (activityId) {
            case Const.LOGIN_ACTIVITY:
                intent = new Intent(this, LoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Const.HOME_ACTIVITY:
                intent = new Intent(this, HomeActivity.class);
                break;
            default:
                break;
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(LoginActivity.class);
        stackBuilder.addNextIntent(intent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        final Notification.Builder notificationBuilder = new Notification.Builder(this).setPriority(Notification.PRIORITY_MAX).setContentTitle(this.getResources().getString(R.string.app_name)).setContentText(message).setAutoCancel(true).setSmallIcon(getNotificationIcon()).setContentIntent(notificationPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder.setChannelId(CHANNEL_ID); // Channel ID
        }
        notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);

        notificationManager.notify(notificationId, notificationBuilder.build());
    }

    private void sendNewOrderNotification(String message, int activityId) {
        int notificationId = 2667;
        Intent intent = null;

        switch (activityId) {
            case Const.HOME_ACTIVITY:
                intent = getPackageManager().getLaunchIntentForPackage(getPackageName());
                intent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                break;
            default:
                // do with default
                break;
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        Uri soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + getPackageName() + "/" + R.raw.request_sound);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(LoginActivity.class);
        stackBuilder.addNextIntent(intent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        final NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, CHANNEL_ID_NEW_ORDER)
                .setPriority(Notification.PRIORITY_MAX)
                .setContentTitle(this.getResources().getString(R.string.app_name))
                .setContentText(message)
                .setAutoCancel(true)
                .setSmallIcon(getNotificationIcon())
                .setSound(soundUri, AudioManager.STREAM_NOTIFICATION)
                .setContentIntent(notificationPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder.setChannelId(CHANNEL_ID_NEW_ORDER); // Channel ID
        }
        if (PreferenceHelper.getInstance(this).getIsNewOrderSoundOn() && Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }

        notificationManager.notify(notificationId, notificationBuilder.build());
    }

    private int getNotificationIcon() {
        return R.drawable.ic_stat_provider;
    }

    private void oderStatus(String status) {
        switch (status) {
            case LOGIN_IN_OTHER_DEVICE:
                sendNotification(getMessage(status), Const.LOGIN_ACTIVITY);
                break;
            case NEW_ORDER:
                sendNewOrderNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcastWithData(Const.Action.ACTION_NEW_ORDER);
                saveNotification(getMessage(status), com.dropo.provider.persistentroomdata.Notification.ORDER_TYPE);
                if (isRunning(this)) {
                    if (!PreferenceHelper.getInstance(this).getIsHomeScreenVisible()) {
                        goToHomeActivity();
                    }
                } else {
                    goToSplashScreenActivity();
                }
                break;
            case ADMIN_APPROVED:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ADMIN_APPROVED);
                saveNotification(getMessage(status), com.dropo.provider.persistentroomdata.Notification.ORDER_TYPE);

                break;
            case ADMIN_DECLINE:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ADMIN_DECLINE);
                saveNotification(getMessage(status), com.dropo.provider.persistentroomdata.Notification.ORDER_TYPE);
                break;
            case STORE_CANCELED_REQUEST:
            case STORE_CANCELED:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_STORE_CANCELED_REQUEST);
                saveNotification(getMessage(status), com.dropo.provider.persistentroomdata.Notification.ORDER_TYPE);
                break;
            default:
                sendMassNotification(getMessage(status), Const.HOME_ACTIVITY);
                saveNotification(getMessage(status), com.dropo.provider.persistentroomdata.Notification.MASS_TYPE);
                break;
        }
    }

    private String getMessage(String code) {
        return data.get(STATUS_PHRASE) != null ? data.get(STATUS_PHRASE) : code;
    }

    private void sendBroadcast(String action) {
        sendBroadcast(new Intent(action));
    }

    private void sendBroadcastWithData(String action) {
        Intent intent = new Intent(action);
        Bundle bundle = new Bundle();
        bundle.putString(Const.Params.PUSH_DATA1, data.get(Const.Params.PUSH_DATA1));
        bundle.putString(Const.Params.PUSH_DATA2, data.get(Const.Params.PUSH_DATA2));
        intent.putExtra(Const.Params.NEW_ORDER, bundle);
        sendBroadcast(intent);
    }

    @Override
    public void onNewToken(@NonNull String token) {
        super.onNewToken(token);
        PreferenceHelper.getInstance(this).putDeviceToken(token);
        if (!TextUtils.isEmpty(PreferenceHelper.getInstance(this).getSessionToken())) {
            upDeviceToken(token);
        }
    }

    private void upDeviceToken(String deviceToken) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(this).getSessionToken());
        map.put(Const.Params.DEVICE_TOKEN, deviceToken);
        map.put(Const.Params.PROVIDER_ID, PreferenceHelper.getInstance(this).getProviderId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.updateDeviceToken(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(FcmMessagingService.class.getSimpleName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void goToSplashScreenActivity() {
        Intent homeIntent = new Intent(this, SplashScreenActivity.class);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
    }

    private void goToHomeActivity() {
        Intent homeIntent = new Intent(this, HomeActivity.class);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        homeIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(homeIntent);
    }

    private boolean isRunning(Context ctx) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityManager activityManager = (ActivityManager) ctx.getSystemService(Context.ACTIVITY_SERVICE);
            List<ActivityManager.AppTask> tasks = activityManager.getAppTasks();
            for (ActivityManager.AppTask task : tasks) {
                if (task.getTaskInfo().baseActivity != null) {
                    if (ctx.getPackageName().equalsIgnoreCase(task.getTaskInfo().baseActivity.getPackageName())) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private void saveNotification(String message, int notificationType) {
        com.dropo.provider.persistentroomdata.Notification notification = new com.dropo.provider.persistentroomdata.Notification();
        notification.setMessage(message);
        notification.setNotificationType(notificationType);
        notification.setDate(ParseContent.getInstance().dateTimeFormat_am.format(new Date()));
        NotificationRepository.getInstance(this).insertNotification(notification, null);
    }

    /**
     * Generate Mass Notification
     */
    private void sendMassNotification(String message, int activityId) {
        int notificationId;
        notificationId = new Random(System.currentTimeMillis()).nextInt(100000);
        Intent intent = null;

        switch (activityId) {
            case Const.LOGIN_ACTIVITY:
                intent = new Intent(this, LoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Const.HOME_ACTIVITY:
                intent = new Intent(this, HomeActivity.class);
                break;
            default:
                break;
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(LoginActivity.class);
        stackBuilder.addNextIntent(intent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        final Notification.Builder notificationBuilder = new Notification.Builder(this)
                .setPriority(Notification.PRIORITY_MAX)
                .setContentTitle(this.getResources().getString(R.string.app_name))
                .setContentText(message)
                .setAutoCancel(true)
                .setSmallIcon(getNotificationIcon())
                .setContentIntent(notificationPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder.setChannelId(CHANNEL_ID); // Channel ID
        }
        notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);

        notificationManager.notify(notificationId, notificationBuilder.build());
    }
}