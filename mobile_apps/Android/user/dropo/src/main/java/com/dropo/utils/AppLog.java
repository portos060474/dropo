package com.dropo.utils;

import com.dropo.user.BuildConfig;

public class AppLog {

    public static final boolean isDebug = BuildConfig.DEBUG;

    public static void Log(String tag, String message) {
        if (isDebug) {
            android.util.Log.d(tag, message + "");
        }
    }

    public static void handleException(String tag, Exception e) {
        if (isDebug) {
            if (e != null) {
                android.util.Log.d(tag, e + "");
            }
        }
    }

    public static void handleThrowable(String tag, Throwable t) {
        if (isDebug) {
            if (t != null) {
                android.util.Log.d(tag, t + "");
            }
        }
    }
}