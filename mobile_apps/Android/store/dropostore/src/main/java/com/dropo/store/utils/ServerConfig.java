package com.dropo.store.utils;

import android.content.Context;

import com.dropo.store.BuildConfig;
import com.dropo.store.parse.ApiClient;



public class ServerConfig {

    public static String BASE_URL = BuildConfig.BASE_URL;
    public static String USER_PANEL_URL = BuildConfig.USER_PANEL_URL;
    public static String IMAGE_URL = BuildConfig.IMAGE_URL;

    public static void setURL(Context context) {
        BASE_URL = PreferenceHelper.getPreferenceHelper(context).getBaseUrl();
        USER_PANEL_URL = PreferenceHelper.getPreferenceHelper(context).getUserPanelUrl();
        IMAGE_URL = PreferenceHelper.getPreferenceHelper(context).getImageUrl();
        new ApiClient().changeAllApiBaseUrl(BASE_URL);
    }
}