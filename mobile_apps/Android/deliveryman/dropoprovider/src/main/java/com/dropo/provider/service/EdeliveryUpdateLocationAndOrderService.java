package com.dropo.provider.service;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.PendingIntent;
import android.app.Service;
import android.app.TaskStackBuilder;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.BitmapFactory;
import android.location.Location;
import android.os.Build;
import android.os.HandlerThread;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.DisplayMetrics;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.dropo.provider.HomeActivity;
import com.dropo.provider.R;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;

import java.util.HashMap;
import java.util.Locale;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class EdeliveryUpdateLocationAndOrderService extends Service {
    public static final String TAG = "LocationAndOrderService";
    public static final String CHANNEL_ID_UPDATE_SERVICE = "channel_update_service";

    private static final Long INTERVAL = 10000L; // millisecond
    private static final Long FASTEST_INTERVAL = 9000L; // millisecond
    private static final Float DISPLACEMENT = 5f; // millisecond

    private final LocationRequest locationRequest = LocationRequest.create()
            .setInterval(INTERVAL)
            .setFastestInterval(FASTEST_INTERVAL)
            .setSmallestDisplacement(DISPLACEMENT)
            .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);

    private Location currentLocation, lastLocation;
    private PreferenceHelper preferenceHelper;

    private final LocationCallback locationCallback = new LocationCallback() {
        @Override
        public void onLocationResult(@NonNull LocationResult locationResult) {
            super.onLocationResult(locationResult);
            currentLocation = locationResult.getLastLocation();
            if (!TextUtils.isEmpty(preferenceHelper.getSessionToken()) && preferenceHelper.getIsProviderOnline()) {
                if (currentLocation != null && Utils.isInternetConnected(EdeliveryUpdateLocationAndOrderService.this)) {
                    updateProviderLocation();
                }
            }
        }
    };

    private FusedLocationProviderClient fusedLocationProviderClient;

    @Override
    public void onCreate() {
        super.onCreate();
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(EdeliveryUpdateLocationAndOrderService.this);
        startForeground(Const.FOREGROUND_NOTIFICATION_ID, getNotification(getResources().getString(R.string.app_name)));
        preferenceHelper = PreferenceHelper.getInstance(this);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null) {
            checkPermission();
            fusedLocationProviderClient.getLastLocation().addOnSuccessListener(location -> {
                if (location != null) {
                    currentLocation = location;
                }
            });
        }
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        removeLocationListener();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void updateProviderLocation() {
        if (currentLocation != null) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
            map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
            map.put(Const.Params.LONGITUDE, currentLocation.getLongitude());
            map.put(Const.Params.LATITUDE, currentLocation.getLatitude());
            if (lastLocation != null) {
                map.put(Const.Params.BEARING, lastLocation.bearingTo(currentLocation));
            } else {
                map.put(Const.Params.BEARING, 0);
            }
            setLastLocation(currentLocation);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = apiInterface.updateProviderLocation(map);
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    setLastLocation(currentLocation);
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(TAG, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
    }

    private void checkPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            addLocationListener();
        }
    }

    @SuppressLint("MissingPermission")
    private void addLocationListener() {
        HandlerThread handlerThread = new HandlerThread("Request Location Update");
        fusedLocationProviderClient.requestLocationUpdates(locationRequest, locationCallback, handlerThread.getLooper());
    }

    private void removeLocationListener() {
        fusedLocationProviderClient.removeLocationUpdates(locationCallback);
    }

    /**
     * this method get Notification object which help to notify user as foreground service
     *
     * @param notificationDetails notificationDetails
     */
    private Notification getNotification(String notificationDetails) {
        Intent notificationIntent = new Intent(getApplicationContext(), HomeActivity.class);
        TaskStackBuilder stackBuilder = TaskStackBuilder.create(this);
        stackBuilder.addParentStack(HomeActivity.class);
        stackBuilder.addNextIntent(notificationIntent);
        PendingIntent notificationPendingIntent = stackBuilder.getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        Notification.Builder builder = new Notification.Builder(this);
        Configuration conf = getResources().getConfiguration();
        conf.locale = new Locale(PreferenceHelper.getInstance(this).getLanguageCode());
        DisplayMetrics metrics = new DisplayMetrics();
        Resources resources = new Resources(getAssets(), metrics, conf);
        builder.setSmallIcon(getNotificationIcon())
                .setLargeIcon(BitmapFactory.decodeResource(getResources(), getNotificationIcon()))
                .setContentTitle(notificationDetails)
                .setContentText(resources.getString(R.string.msg_service))
                .setContentIntent(notificationPendingIntent)
                .setAutoCancel(false)
                .setOngoing(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId(CHANNEL_ID_UPDATE_SERVICE); // Channel ID
        }

        return builder.build();
    }

    private int getNotificationIcon() {
        return R.drawable.ic_stat_provider;
    }

    private void setLastLocation(Location location) {
        if (lastLocation == null) {
            lastLocation = new Location("lastLocation");
        }
        lastLocation.set(location);
    }
}