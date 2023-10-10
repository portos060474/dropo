package com.dropo.store;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.TaskStackBuilder;
import android.content.ComponentCallbacks;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Build;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dropo.store.parse.ParseContent;
import com.dropo.store.persistentroomdata.NotificationRepository;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.io.FileDescriptor;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Map;
import java.util.Random;

public class FcmMessagingService extends FirebaseMessagingService {
    public static final String CHANNEL_ID = "channel_01";
    public static final String CHANNEL_ID_NEW_ORDER = "newOrder";

    public static final String MESSAGE = "message";
    public static final String STATUS_PHRASE = "status_phrase";
    public static final String PUSH_DATA1 = "push_data1";
    public static final String NEW_ORDER = "2071";
    public static final String DELIVERY_MAN_ACCEPTED = "2061";
    public static final String DELIVERY_MAN_COMING = "2062";
    public static final String DELIVERY_MAN_ARRIVED = "2063";
    public static final String DELIVERY_MAN_PICKED_ORDER = "2064";
    public static final String DELIVERY_MAN_STARTED_DELIVERY = "2065";
    public static final String DELIVERY_MAN_ARRIVED_AT_DESTINATION = "2066";
    public static final String DELIVERY_MAN_COMPLETE_DELIVERY = "2067";
    public static final String USER_CANCELLED_ORDER = "2068";
    public static final String DELIVERY_MAN_NOT_FOUND = "2069";
    public static final String NEW_SCHEDULE_ORDER = "2070";
    public static final String STORE_APPROVED = "2072";
    public static final String STORE_DECLINED = "2073";
    public static final String USER_ACCEPT_EDIT_ORDER = "2074";
    public static final String LOGIN_IN_OTHER_DEVICE = "2093";
    public static final String USER_UPDATE_ORDER_DETAIL = "2088";

    private Map<String, String> data;

    public FcmMessagingService() {

    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage) {
        Utilities.printLog("FcmMessagingService", "From:" + remoteMessage.getFrom());
        Utilities.printLog("FcmMessagingService", "Data:" + remoteMessage.getData());
        data = remoteMessage.getData();
        String message = data.get(MESSAGE);
        if (!TextUtils.isEmpty(message)) {
            sendNotification(message);
        }
    }

    @Override
    public void onMessageSent(@NonNull String s) {
        super.onMessageSent(s);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }

    @Override
    public void registerComponentCallbacks(ComponentCallbacks callback) {
        super.registerComponentCallbacks(callback);
    }

    @Override
    public void onSendError(@NonNull String s, @NonNull Exception e) {
        super.onSendError(s, e);
        e.printStackTrace();
    }

    @Override
    protected void dump(FileDescriptor fd, PrintWriter writer, String[] args) {
        super.dump(fd, writer, args);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
    }

    private void generateNotification(String message, int activityId) {
        int notificationId = 2017;
        Intent notificationIntent = null;

        switch (activityId) {
            case Constant.LOGIN_ACTIVITY:
                notificationIntent = new Intent(this, RegisterLoginActivity.class);
                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Constant.HOME_ACTIVITY:
                if (getPackageName() != null) {
                    notificationIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
                    notificationIntent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                }
                break;
            default:
                break;
        }
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(RegisterLoginActivity.class);
        stackBuilder.addNextIntent(notificationIntent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        final Notification.Builder notificationBuilder = new Notification.Builder(this).setPriority(Notification.PRIORITY_MAX).setContentTitle(this.getResources().getString(R.string.app_name)).setContentText(message).setAutoCancel(true).setSmallIcon(getNotificationIcon()).setContentIntent(notificationPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder.setChannelId(CHANNEL_ID); // Channel ID
        }
        if (PreferenceHelper.getPreferenceHelper(this).getIsPushNotificationSoundOn()) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }

        notificationManager.notify(notificationId, notificationBuilder.build());
    }

    private void generateNewOrderNotification(String message, int activityId) {
        int notificationId = 2667;
        Intent notificationIntent = null;

        switch (activityId) {
            case Constant.LOGIN_ACTIVITY:
                notificationIntent = new Intent(this, RegisterLoginActivity.class);
                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Constant.HOME_ACTIVITY:
                if (getPackageName() != null) {
                    notificationIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
                    notificationIntent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                }
                break;
            default:
                break;
        }

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(RegisterLoginActivity.class);
        stackBuilder.addNextIntent(notificationIntent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        final Notification.Builder notificationBuilder = new Notification.Builder(this)
                .setPriority(Notification.PRIORITY_MAX)
                .setContentTitle(this.getResources().getString(R.string.app_name))
                .setContentText(message)
                .setAutoCancel(true)
                .setSmallIcon(getNotificationIcon())
                .setContentIntent(notificationPendingIntent);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            notificationBuilder.setChannelId("newOrder"); // Channel ID
        }
        if (PreferenceHelper.getPreferenceHelper(this).getIsPushNotificationSoundOn() && Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }

        notificationManager.notify(notificationId, notificationBuilder.build());
    }

    private void sendNotification(String message) {
        switch (message) {
            case NEW_ORDER:
                generateNewOrderNotification(getMessage(message), Constant.HOME_ACTIVITY);
                if (!TextUtils.isEmpty(data.get(PUSH_DATA1))) {
                    sendBroadcastWithData(Constant.Action.ACTION_NEW_ORDER_ACTION, data.get(PUSH_DATA1));
                }
                saveNotification(getMessage(message), com.dropo.store.persistentroomdata.Notification.ORDER_TYPE);
                break;
            case DELIVERY_MAN_ACCEPTED:
            case DELIVERY_MAN_COMING:
            case DELIVERY_MAN_ARRIVED:
            case DELIVERY_MAN_PICKED_ORDER:
            case DELIVERY_MAN_STARTED_DELIVERY:
            case DELIVERY_MAN_ARRIVED_AT_DESTINATION:
            case DELIVERY_MAN_COMPLETE_DELIVERY:
            case DELIVERY_MAN_NOT_FOUND:
            case USER_ACCEPT_EDIT_ORDER:
            case NEW_SCHEDULE_ORDER:
            case USER_UPDATE_ORDER_DETAIL:
                generateNotification(getMessage(message), Constant.HOME_ACTIVITY);
                sendBroadcast(Constant.Action.ACTION_ORDER_STATUS_ACTION);
                saveNotification(getMessage(message), com.dropo.store.persistentroomdata.Notification.ORDER_TYPE);
                break;
            case USER_CANCELLED_ORDER:
                generateNotification(getMessage(message), Constant.HOME_ACTIVITY);
                sendBroadcast(Constant.Action.ACTION_ORDER_CANCEL);
            case STORE_APPROVED:
                generateNotification(getMessage(message), Constant.HOME_ACTIVITY);
                sendBroadcast(Constant.Action.ACTION_STORE_APPROVED);
                saveNotification(getMessage(message), com.dropo.store.persistentroomdata.Notification.ORDER_TYPE);
                break;
            case STORE_DECLINED:
                generateNotification(getMessage(message), Constant.HOME_ACTIVITY);
                sendBroadcast(Constant.Action.ACTION_STORE_DECLINED);
                saveNotification(getMessage(message), com.dropo.store.persistentroomdata.Notification.ORDER_TYPE);
                break;
            case LOGIN_IN_OTHER_DEVICE:
                generateNotification(getMessage(message), Constant.LOGIN_ACTIVITY);
                break;
            default:
                generateMassNotification(getMessage(message), Constant.HOME_ACTIVITY);
                saveNotification(getMessage(message), com.dropo.store.persistentroomdata.Notification.MASS_TYPE);
                break;

        }
    }

    private String getMessage(String code) {
        return data.get(STATUS_PHRASE) != null ? data.get(STATUS_PHRASE) : code;
    }

    private void sendBroadcast(String action) {
        sendBroadcast(new Intent(action));
    }

    private void sendBroadcastWithData(String action, String pushData) {
        Intent intent = new Intent(action);
        if (!TextUtils.isEmpty(pushData)) {
            intent.putExtra(Constant.PUSH_DATA, pushData);
        }

        sendBroadcast(intent);
    }

    private int getNotificationIcon() {
        return R.drawable.ic_stat_store;
    }

    @Override
    public void onNewToken(@NonNull String token) {
        super.onNewToken(token);
        PreferenceHelper.getPreferenceHelper(getApplicationContext()).putDeviceToken(token);
        Intent intent = new Intent(Constant.DEVICE_TOKEN);
        intent.putExtra(Constant.DEVICE_TOKEN_RECEIVED, true);
        getApplicationContext().sendBroadcast(intent);
    }

    private void saveNotification(String message, int notificationType) {
        com.dropo.store.persistentroomdata.Notification notification = new com.dropo.store.persistentroomdata.Notification();
        notification.setMessage(message);
        notification.setNotificationType(notificationType);
        notification.setDate(ParseContent.getInstance().dateTimeFormat_am.format(new Date()));
        NotificationRepository.getInstance(this).insertNotification(notification, null);
    }

    /**
     * Generate Mass Notification
     */
    private void generateMassNotification(String message, int activityId) {
        int notificationId;
        notificationId = new Random(System.currentTimeMillis()).nextInt(100000);
        Intent notificationIntent = null;

        switch (activityId) {
            case Constant.LOGIN_ACTIVITY:
                notificationIntent = new Intent(this, RegisterLoginActivity.class);
                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case Constant.HOME_ACTIVITY:
                if (getPackageName() != null) {
                    notificationIntent = getPackageManager().getLaunchIntentForPackage(getPackageName());
                    notificationIntent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
                }
                break;
            default:
                break;
        }
        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(RegisterLoginActivity.class);
        stackBuilder.addNextIntent(notificationIntent);
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
        if (PreferenceHelper.getPreferenceHelper(this).getIsPushNotificationSoundOn()) {
            notificationBuilder.setDefaults(Notification.DEFAULT_SOUND | Notification.DEFAULT_LIGHTS);
        }

        notificationManager.notify(notificationId, notificationBuilder.build());
    }
}