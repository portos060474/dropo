package com.dropo.service;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dropo.HomeActivity;
import com.dropo.LoginActivity;
import com.dropo.OrderDetailActivity;
import com.dropo.user.R;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.persistentroomdata.notification.NotificationRepository;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Date;
import java.util.HashMap;
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

    public static final String MESSAGE = "message";
    public static final String STATUS_PHRASE = "status_phrase";
    public static final String LOGIN_IN_OTHER_DEVICE = "2091";
    public static final String STORE_ACCEPTED_YOUR_ORDER = "2001";
    public static final String STORE_START_PREPARING_YOUR_ORDER = "2002";
    public static final String STORE_READY_YOUR_ORDER = "2003";
    public static final String STORE_REJECTED_YOUR_ORDER = "2004";
    public static final String STORE_CANCELLED_YOUR_ORDER = "2005";
    public static final String DELIVERY_MAN_ACCEPTED = "2081";
    public static final String DELIVERY_MAN_COMING = "2082";
    public static final String DELIVERY_MAN_ARRIVED = "2083";
    public static final String DELIVERY_MAN_PICKED_ORDER = "2084";
    public static final String DELIVERY_MAN_STARTED_DELIVERY = "2085";
    public static final String DELIVERY_MAN_ARRIVED_AT_DESTINATION = "2086";
    public static final String DELIVERY_MAN_COMPLETE_ORDER = "2087";
    public static final String STORE_UPDATED_ORDER_CART = "2088";
    public static final String ADMIN_APPROVED = "2006";
    public static final String ADMIN_DECLINE = "2007";

    private Map<String, String> data;

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        AppLog.Log("FcmMessagingService", "From:" + remoteMessage.getFrom());
        AppLog.Log("FcmMessagingService", "Data:" + remoteMessage.getData());
        data = remoteMessage.getData();
        String message = data.get(MESSAGE);
        if (!TextUtils.isEmpty(message)) {
            orderStatus(message);
        }
    }

    private void sendNotification(String message, int activityId) {
        int notificationId = 2017;
        Intent intent = null;
        switch (activityId) {
            case Const.HOME_ACTIVITY:
                intent = new Intent(this, HomeActivity.class);
                break;
            case Const.LOGIN_ACTIVITY:
                intent = new Intent(this, LoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Const.ORDER_TRACK_ACTIVITY:
                intent = new Intent(this, OrderDetailActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                intent.putExtra(Const.Params.PUSH_DATA1, data.get(Const.Params.PUSH_DATA1));
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
        if (PreferenceHelper.getInstance(this).getIsPushNotificationSoundOn()) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }
        if (notificationManager != null) {
            notificationManager.notify(notificationId, notificationBuilder.build());
        }
    }

    private int getNotificationIcon() {
        return R.drawable.ic_stat_user;
    }

    private void orderStatus(String status) {
        switch (status) {
            case LOGIN_IN_OTHER_DEVICE:
                sendNotification(getMessage(status), Const.LOGIN_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_LOGIN_AT_ANOTHER_DEVICE);
                break;
            case STORE_ACCEPTED_YOUR_ORDER:
            case STORE_START_PREPARING_YOUR_ORDER:
            case STORE_READY_YOUR_ORDER:
            case DELIVERY_MAN_PICKED_ORDER:
            case DELIVERY_MAN_STARTED_DELIVERY:
            case DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            case DELIVERY_MAN_COMPLETE_ORDER:
            case STORE_UPDATED_ORDER_CART:
                sendNotification(getMessage(status), Const.ORDER_TRACK_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ORDER_STATUS);
                saveNotification(getMessage(status), com.dropo.persistentroomdata.notification.Notification.ORDER_TYPE);
                break;
            case ADMIN_APPROVED:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ADMIN_APPROVED);
                saveNotification(getMessage(status), com.dropo.persistentroomdata.notification.Notification.ORDER_TYPE);
                break;
            case ADMIN_DECLINE:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ADMIN_DECLINE);
                saveNotification(getMessage(status), com.dropo.persistentroomdata.notification.Notification.ORDER_TYPE);
                break;
            case DELIVERY_MAN_ACCEPTED:
            case DELIVERY_MAN_COMING:
            case DELIVERY_MAN_ARRIVED:
                break;
            case STORE_REJECTED_YOUR_ORDER:
            case STORE_CANCELLED_YOUR_ORDER:
                sendNotification(getMessage(status), Const.HOME_ACTIVITY);
                sendBroadcast(Const.Action.ACTION_ORDER_STATUS);
                saveNotification(getMessage(status), com.dropo.persistentroomdata.notification.Notification.ORDER_TYPE);
                break;
            default:
                sendMassNotification(getMessage(status), Const.HOME_ACTIVITY);
                saveNotification(getMessage(status), com.dropo.persistentroomdata.notification.Notification.MASS_TYPE);
                break;
        }
    }

    private String getMessage(String code) {
        return data.get(STATUS_PHRASE) != null ? data.get(STATUS_PHRASE) : code;
    }

    private void sendBroadcast(String action) {
        sendBroadcast(new Intent(action));
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
        map.put(Const.Params.USER_ID, PreferenceHelper.getInstance(this).getUserId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.updateDeviceToken(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {

            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(FcmMessagingService.class.getSimpleName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void saveNotification(String message, int notificationType) {
        com.dropo.persistentroomdata.notification.Notification notification = new com.dropo.persistentroomdata.notification.Notification();
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
            case Const.HOME_ACTIVITY:
                intent = new Intent(this, HomeActivity.class);
                break;
            case Const.LOGIN_ACTIVITY:
                intent = new Intent(this, LoginActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Const.ORDER_TRACK_ACTIVITY:
                intent = new Intent(this, OrderDetailActivity.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                intent.putExtra(Const.Params.PUSH_DATA1, data.get(Const.Params.PUSH_DATA1));
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
        if (PreferenceHelper.getInstance(this).getIsPushNotificationSoundOn()) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }
        if (notificationManager != null) {
            notificationManager.notify(notificationId, notificationBuilder.build());
        }
    }
}