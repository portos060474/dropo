package com.dropo.utils;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.TypedValue;

import androidx.annotation.AttrRes;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.user.R;

public final class AppColor {

    public final static int APP_THEME_LIGHT = 1;
    public final static int APP_THEME_DARK = 0;
    public final static int DEVICE_DEFAULT = 2;
    public static int COLOR_THEME = Color.parseColor("#a828c2");

    public static void onActivityCreateSetTheme(Activity activity) {
        switch (PreferenceHelper.getInstance(activity).getTheme()) {
            case APP_THEME_DARK:
                activity.setTheme(R.style.Theme_App_Dark);
                break;
            case APP_THEME_LIGHT:
                activity.setTheme(R.style.Theme_App_Light);
                break;
            case DEVICE_DEFAULT:
                if ((activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES) {
                    PreferenceHelper.getInstance(activity).putTheme(AppColor.APP_THEME_DARK);
                } else {
                    PreferenceHelper.getInstance(activity).putTheme(AppColor.APP_THEME_LIGHT);
                }
                break;
        }
    }

    public static boolean isDarkTheme(Context context) {
        return PreferenceHelper.getInstance(context).getTheme() == APP_THEME_DARK;
    }

    public static int getThemeTextColor(Context context) {
        return ResourcesCompat.getColor(context.getResources(), isDarkTheme(context) ? R.color.color_app_text_dark : R.color.color_app_text_light, null);
    }

    public static Drawable getThemeColorDrawable(int resId, Context context) {
        Drawable drawable = AppCompatResources.getDrawable(context, resId);
        if (drawable != null) {
            drawable.setTint(COLOR_THEME);
        }
        return drawable;
    }

    public static Drawable getThemeModeDrawable(int resId, Context context) {
        Drawable drawable = AppCompatResources.getDrawable(context, resId);
        if (drawable != null) {
            drawable.setTint(ResourcesCompat.getColor(context.getResources(), isDarkTheme(context) ? R.color.color_app_icon_dark : R.color.color_app_icon_light, null));
        }
        return drawable;
    }

    public static Drawable getDarkModeDrawable(int resId, Context context) {
        Drawable drawable = AppCompatResources.getDrawable(context, resId);
        if (drawable != null) {
            drawable.setTint(ResourcesCompat.getColor(context.getResources(), R.color.color_app_icon_dark, null));
        }
        return drawable;
    }

    public static int getThemeColor(final Context context, @AttrRes int attr) {
        final TypedValue value = new TypedValue();
        context.getTheme().resolveAttribute(attr, value, true);
        return value.data;
    }
}
