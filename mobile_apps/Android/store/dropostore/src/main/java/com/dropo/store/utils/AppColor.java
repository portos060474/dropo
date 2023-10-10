package com.dropo.store.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.Drawable;

import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.R;

public final class AppColor {
    public final static int APP_THEME_LIGHT = 1;
    public final static int APP_THEME_DARK = 0;
    public final static int DEVICE_DEFAULT = 2;
    public static int COLOR_THEME = Color.parseColor("#5daa1e");

    public static void onActivityCreateSetTheme(Activity activity) {
        switch (PreferenceHelper.getPreferenceHelper(activity).getTheme()) {
            case APP_THEME_DARK:
                activity.setTheme(R.style.Theme_App_Dark);
                break;
            case APP_THEME_LIGHT:
                activity.setTheme(R.style.Theme_App_Light);
                break;
            case DEVICE_DEFAULT:
                if ((activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES) {
                    PreferenceHelper.getPreferenceHelper(activity).putTheme(AppColor.APP_THEME_DARK);
                } else {
                    PreferenceHelper.getPreferenceHelper(activity).putTheme(AppColor.APP_THEME_LIGHT);
                }
                break;
        }
    }

    public static boolean isDarkTheme(Context context) {
        return PreferenceHelper.getPreferenceHelper(context).getTheme() == AppColor.APP_THEME_DARK;
    }

    public static int getThemeTextColor(Context context) {
        return ResourcesCompat.getColor(context.getResources(), AppColor.isDarkTheme(context) ? R.color.color_app_text_dark : R.color.color_app_text_light, null);
    }

    public static Drawable getThemeColorDrawable(int resId, Context context) {
        Drawable drawable = AppCompatResources.getDrawable(context, resId);
        drawable.setTint(AppColor.COLOR_THEME);
        return drawable;
    }
}
