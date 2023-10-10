package com.dropo.provider.utils;

import android.content.Context;


import com.dropo.provider.BuildConfig;
import com.dropo.provider.parser.ApiClient;

public class ServerConfig {

    public static String BASE_URL = BuildConfig.BASE_URL;
    public static String USER_PANEL_URL = BuildConfig.USER_PANEL_URL;
    public static String IMAGE_URL = BuildConfig.IMAGE_URL;

    public static void setURL(Context context) {
        BASE_URL = PreferenceHelper.getInstance(context).getBaseUrl();
        USER_PANEL_URL = PreferenceHelper.getInstance(context).getUserPanelUrl();
        IMAGE_URL = PreferenceHelper.getInstance(context).getImageUrl();
        new ApiClient().changeAllApiBaseUrl(BASE_URL);
    }
}