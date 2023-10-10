package com.dropo.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.location.Location;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Build;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.LayoutDirection;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.webkit.URLUtil;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.LoginActivity;
import com.dropo.user.R;
import com.dropo.adapter.StoreAdapter;
import com.dropo.component.CustomCircularProgressView;
import com.dropo.models.datamodels.CategoryDayTime;
import com.dropo.models.datamodels.CategoryTime;
import com.dropo.models.datamodels.DayTime;
import com.dropo.models.datamodels.FamousProductsTags;
import com.dropo.models.datamodels.StoreClosedResult;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ParseContent;
import com.google.android.gms.maps.model.LatLng;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Random;
import java.util.TimeZone;

public class Utils {

    public static final String TAG = "Utils";
    private static Dialog dialog;
    private static CustomCircularProgressView ivProgressBar;
    private static final Random random = new Random();

    public static void showToast(String message, Context context) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
    }

    public static void showErrorToast(int errorCode, String error, Context context) {
        if (Const.INVALID_TOKEN == errorCode || Const.USER_DATA_NOT_FOUND == errorCode) {
            goToLoginActivity(context);
        }
        if (error != null) {
            showToast(error, context);
        }
    }

    public static void showMessageToast(String message, Context context) {
        if (message != null) {
            showToast(message, context);
        }
    }

    public static String getWelcomeTitle(int code, Context context) {
        String messageCode = Const.WELCOME_TITLE_PREFIX + code;
        try {
            return context.getResources().getString(context.getResources().getIdentifier(messageCode, Const.STRING, context.getPackageName()));
        } catch (Resources.NotFoundException e) {
            AppLog.handleException(TAG, e);
            return messageCode;
        }
    }

    public static String getWelcomeSubTitle(int code, Context context) {
        String messageCode = Const.WELCOME_SUB_TITLE_PREFIX + code;
        try {
            return context.getResources().getString(context.getResources().getIdentifier(messageCode, Const.STRING, context.getPackageName()));
        } catch (Resources.NotFoundException e) {
            AppLog.handleException(TAG, e);
            return messageCode;
        }
    }

    public static void showCustomProgressDialog(Context context, boolean isCancel) {
        if (dialog != null && dialog.isShowing()) {
            return;
        }
        if (isInternetConnected(context) && !((AppCompatActivity) context).isFinishing()) {
            dialog = new Dialog(context, R.style.AppTheme);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setContentView(R.layout.circuler_progerss_bar_two);
            dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            dialog.getWindow().setStatusBarColor(Color.TRANSPARENT);
            dialog.getWindow().setNavigationBarColor(Color.TRANSPARENT);
            ivProgressBar = dialog.findViewById(R.id.ivProgressBarTwo);
            ivProgressBar.startAnimation();
            dialog.setCancelable(isCancel);
            WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
            params.height = WindowManager.LayoutParams.MATCH_PARENT;
            dialog.getWindow().setAttributes(params);
            dialog.getWindow().setDimAmount(0);
            dialog.show();
        }
    }

    public static void showHttpErrorToast(int code, Context context) {
        String msg;
        String errorCode = Const.HTTP_ERROR_CODE_PREFIX + code;
        try {
            msg = context.getResources().getString(context.getResources().getIdentifier(errorCode, Const.STRING, context.getPackageName()));
            showToast(msg, context);
        } catch (Resources.NotFoundException e) {
            msg = errorCode;
            AppLog.handleException(TAG, e);
        }
    }

    public static void hideCustomProgressDialog() {
        try {
            if (dialog != null && ivProgressBar != null) {
                dialog.dismiss();
            }
        } catch (Exception e) {
            AppLog.handleException(TAG, e);
        }
    }

    public static boolean isInternetConnected(Context context) {
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
        return networkInfo != null && networkInfo.isConnectedOrConnecting();
    }

    public static Bitmap drawableToBitmap(Drawable drawable) {
        Bitmap bitmap;

        if (drawable instanceof BitmapDrawable) {
            BitmapDrawable bitmapDrawable = (BitmapDrawable) drawable;
            if (bitmapDrawable.getBitmap() != null) {
                return bitmapDrawable.getBitmap();
            }
        }

        if (drawable.getIntrinsicWidth() <= 0 || drawable.getIntrinsicHeight() <= 0) {
            bitmap = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888); // Single color bitmap
            // will be created of 1x1 pixel
        } else {
            bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        }

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    private static void goToLoginActivity(Context context) {
        Intent loginIntent = new Intent(context, LoginActivity.class);
        CurrentBooking.getInstance().getCartProductWithSelectedSpecificationList().clear();
        PreferenceHelper.getInstance(context).logout();
        PreferenceHelper.getInstance(context).putAndroidId(Utils.generateRandomString());
        context.startActivity(loginIntent);
    }

    public static String getDayOfMonthSuffix(final int n) {
        if (n >= 11 && n <= 13) {
            return n + "th";
        }
        switch (n % 10) {
            case 1:
                return n + "st";
            case 2:
                return n + "nd";
            case 3:
                return n + "rd";
            default:
                return n + "th";
        }
    }

    public static String getStoreTag(ArrayList<FamousProductsTags> famousProductsTagsList) {
        StringBuilder msg = new StringBuilder();
        for (int i = 0; i < famousProductsTagsList.size(); i++) {
            msg.append(famousProductsTagsList.get(i).getTag());
            if (i != famousProductsTagsList.size() - 1) {
                msg.append(", ");
            }
        }
        return msg.toString();
    }

    public static String getStoreTagFromTagId(ArrayList<String> tagIds, ArrayList<FamousProductsTags> famousProductsTagsList) {
        StringBuilder msg = new StringBuilder();
        for (int i = 0; i < tagIds.size(); i++) {
            for (FamousProductsTags famousProductsTags : famousProductsTagsList) {
                if (tagIds.get(i).equalsIgnoreCase(famousProductsTags.getTagId())) {
                    msg.append(famousProductsTags.getTag());
                    if (i != tagIds.size() - 1) {
                        msg.append(", ");
                    }
                    break;
                }
            }
        }
        return msg.toString();
    }

    public static String getStringPrice(int code, String currency) {
        StringBuilder msg = new StringBuilder();
        for (int i = 0; i < code; i++) {
            msg.append(currency);
        }
        return msg.toString();
    }

    public static String minuteToHoursMinutesSeconds(double minute) {
        long seconds = (long) (minute * 60);
        return (seconds / 3600) + " : " + (seconds % 3600) / 60;
    }

    public static String minuteToHoursMinutesSecondsWithText(double minute) {
        long seconds = (long) (minute * 60);
        return (seconds / 3600) + "hr : " + (seconds % 3600) / 60 + "min";
    }

    public static void hideSoftKeyboard(AppCompatActivity activity) {
        if (activity.getCurrentFocus() != null) {
            InputMethodManager inputMethodManager = (InputMethodManager) activity.getSystemService(Activity.INPUT_METHOD_SERVICE);
            inputMethodManager.hideSoftInputFromWindow(activity.getCurrentFocus().getWindowToken(), 0);
        }
    }

    public static void setRightBackgroundRtlView(Context context, View view) {
        if (context.getResources().getConfiguration().getLayoutDirection() == LayoutDirection.RTL) {
            view.setBackground(AppCompatResources.getDrawable(context, R.drawable.shape_round_left_black_stroke));
        } else {
            view.setBackground(AppCompatResources.getDrawable(context, R.drawable.shape_round_right_black_stroke));
        }
    }

    public static void setLeftBackgroundRtlView(Context context, View view) {
        if (context.getResources().getConfiguration().getLayoutDirection() == LayoutDirection.RTL) {
            view.setBackground(AppCompatResources.getDrawable(context, R.drawable.shape_round_right_black_stroke));
        } else {
            view.setBackground(AppCompatResources.getDrawable(context, R.drawable.shape_round_left_black_stroke));
        }
    }

    @SuppressLint("DefaultLocale")
    public static StoreClosedResult checkStoreOpenAndClosed(Context context, List<StoreTime> storeTime, String serverTime, String timeZoneString, boolean isFutureOrder, Calendar scheduleCalender) {
        StoreClosedResult storeClosedResult = new StoreClosedResult();
        storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_open));
        try {
            Calendar serverTimeCalendar = Calendar.getInstance();
            if (isFutureOrder) {
                serverTimeCalendar = (Calendar) scheduleCalender.clone();
            } else {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT_WEB, Locale.US);
                simpleDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
                serverTimeCalendar.setTime(simpleDateFormat.parse(serverTime));
            }
            String nextOpenTime = "";
            boolean isStoreClosed = false;
            boolean isDeliveryOff = false;
            int dayOfWeek = serverTimeCalendar.get(Calendar.DAY_OF_WEEK) - 1;
            if (storeTime != null && !storeTime.isEmpty()) {
                for (StoreTime timeItem : storeTime) {
                    for (DayTime dayTime : timeItem.getDayTime()) {

                        int hr = dayTime.getStoreOpenTimeMinute() / 60;
                        int min = dayTime.getStoreOpenTimeMinute() % 60;
                        dayTime.setStoreOpenTime(String.format("%02d:%02d", hr, min));
                        Calendar openCalendar = (Calendar) serverTimeCalendar.clone();
                        openCalendar.set(Calendar.HOUR_OF_DAY, hr);
                        openCalendar.set(Calendar.MINUTE, min);
                        openCalendar.set(Calendar.SECOND, 0);
                        openCalendar.set(Calendar.MILLISECOND, 0);
                        dayTime.setOpenTimeCalender(openCalendar);

                        hr = dayTime.getStoreCloseTimeMinute() / 60;
                        min = dayTime.getStoreCloseTimeMinute() % 60;
                        dayTime.setStoreCloseTime(String.format("%02d:%02d", hr, min));
                        Calendar closedCalendar = (Calendar) serverTimeCalendar.clone();
                        closedCalendar.set(Calendar.HOUR_OF_DAY, hr);
                        closedCalendar.set(Calendar.MINUTE, min);
                        closedCalendar.set(Calendar.SECOND, 0);
                        closedCalendar.set(Calendar.MILLISECOND, 0);
                        dayTime.setClosedTimeCalender(closedCalendar);
                    }
                    Collections.sort(timeItem.getDayTime());
                }
                for (StoreTime timeItem : storeTime) {
                    if (timeItem.getDay() == dayOfWeek) {
                        if (timeItem.isStoreOpenFullTime() || timeItem.isBookingOpenFullTime()) {
                            isStoreClosed = false;
                            break;
                        } else {
                            if (timeItem.isStoreOpen() || timeItem.isBookingOpen()) {
                                if (timeItem.getDayTime().isEmpty()) {
                                    isStoreClosed = true;
                                } else {
                                    for (DayTime dayTime : timeItem.getDayTime()) {
                                        if (serverTimeCalendar.after(dayTime.getOpenTimeCalender()) && serverTimeCalendar.before(dayTime.getClosedTimeCalender()) || serverTimeCalendar.compareTo(dayTime.getOpenTimeCalender()) == 0) {
                                            isStoreClosed = false;
                                            break;
                                        } else if (serverTimeCalendar.before(dayTime.getOpenTimeCalender()) && TextUtils.isEmpty(nextOpenTime)) {
                                            isStoreClosed = true;
                                            nextOpenTime = ParseContent.getInstance().timeFormat2.format(dayTime.getOpenTimeCalender().getTimeInMillis());
                                            break;
                                        } else {
                                            isStoreClosed = true;
                                        }
                                    }
                                }
                            } else {
                                isStoreClosed = true;
                                isDeliveryOff = true;
                                break;
                            }
                        }
                        break;
                    }
                }
            }

            storeClosedResult.setStoreClosed(isStoreClosed);
            if (isStoreClosed) {
                if (TextUtils.isEmpty(nextOpenTime)) {
                    String currentDate = ParseContent.getInstance().dateFormat.format(new Date());
                    if (currentDate.equals(ParseContent.getInstance().dateFormat.format(serverTimeCalendar.getTime()))) {
                        if (isDeliveryOff) {
                            storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_store_delivery_off) + " " + context.getResources().getString(R.string.text_today));
                        } else {
                            storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_store_closed_on) + " " + context.getResources().getString(R.string.text_today));
                        }
                    } else {
                        if (isDeliveryOff) {
                            storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_store_delivery_off) + " " + "" + serverTimeCalendar.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.LONG, Locale.getDefault()));
                        } else {
                            storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_store_closed_on) + " " + "" + serverTimeCalendar.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.LONG, Locale.getDefault()));
                        }
                    }
                } else {
                    storeClosedResult.setReOpenAt(context.getResources().getString(R.string.text_reopen_at) + " " + nextOpenTime);
                }
            }
        } catch (ParseException e) {
            AppLog.handleException(StoreAdapter.class.getName(), e);
        }
        return storeClosedResult;
    }

    public static boolean checkCategoryOpenAndClosed(List<CategoryTime> categoryTime, String serverTime, boolean isFutureOrder, Calendar scheduleCalender) {
        try {
            Calendar serverTimeCalendar = Calendar.getInstance();
            if (isFutureOrder) {
                serverTimeCalendar = (Calendar) scheduleCalender.clone();
            } else {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT_WEB, Locale.US);
                simpleDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
                serverTimeCalendar.setTime(Objects.requireNonNull(simpleDateFormat.parse(serverTime)));
            }

            boolean isCategoryClosed = false;

            int dayOfWeek = serverTimeCalendar.get(Calendar.DAY_OF_WEEK) - 1;
            if (categoryTime != null && !categoryTime.isEmpty()) {
                for (CategoryTime timeItem : categoryTime) {
                    for (CategoryDayTime dayTime : timeItem.getDayTime()) {

                        int hr = dayTime.getCategoryOpenTimeMinute() / 60;
                        int min = dayTime.getCategoryOpenTimeMinute() % 60;
                        dayTime.setCategoryOpenTime(String.format(Locale.getDefault(), "%02d:%02d", hr, min));
                        Calendar openCalendar = (Calendar) serverTimeCalendar.clone();
                        openCalendar.set(Calendar.HOUR_OF_DAY, hr);
                        openCalendar.set(Calendar.MINUTE, min);
                        openCalendar.set(Calendar.SECOND, 0);
                        openCalendar.set(Calendar.MILLISECOND, 0);
                        dayTime.setOpenTimeCalender(openCalendar);

                        hr = dayTime.getCategoryCloseTimeMinute() / 60;
                        min = dayTime.getCategoryCloseTimeMinute() % 60;
                        dayTime.setCategoryCloseTime(String.format(Locale.getDefault(), "%02d:%02d", hr, min));
                        Calendar closedCalendar = (Calendar) serverTimeCalendar.clone();
                        closedCalendar.set(Calendar.HOUR_OF_DAY, hr);
                        closedCalendar.set(Calendar.MINUTE, min);
                        closedCalendar.set(Calendar.SECOND, 0);
                        closedCalendar.set(Calendar.MILLISECOND, 0);
                        dayTime.setClosedTimeCalender(closedCalendar);
                    }
                    Collections.sort(timeItem.getDayTime());
                }

                for (CategoryTime timeItem : categoryTime) {
                    if (timeItem.getDay() == dayOfWeek) {
                        if (timeItem.isCategoryOpenFullTime()) {
                            isCategoryClosed = false;
                            break;
                        } else {
                            if (timeItem.isCategoryOpen()) {
                                if (timeItem.getDayTime().isEmpty()) {
                                    isCategoryClosed = true;
                                } else {
                                    for (CategoryDayTime dayTime : timeItem.getDayTime()) {
                                        if (serverTimeCalendar.after(dayTime.getOpenTimeCalender()) && serverTimeCalendar.before(dayTime.getClosedTimeCalender()) || serverTimeCalendar.compareTo(dayTime.getOpenTimeCalender()) == 0) {
                                            isCategoryClosed = false;
                                            break;
                                        } else {
                                            isCategoryClosed = true;
                                        }
                                    }
                                }
                            } else {
                                isCategoryClosed = true;
                                break;
                            }
                        }
                        break;
                    }
                }
            }

            return isCategoryClosed;
        } catch (ParseException e) {
            AppLog.handleException(TAG, e);
        }
        return false;
    }

    public static Spanned fromHtml(String html) {
        Spanned result;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            result = Html.fromHtml(html, Html.FROM_HTML_MODE_LEGACY);
        } else {
            result = Html.fromHtml(html);
        }
        return result;
    }

    public static boolean isDecimalAndGraterThenZero(String data) {
        try {
            if (Double.parseDouble(data) <= 0) {

                return false;
            }
        } catch (NumberFormatException e) {

            return false;
        }
        return true;
    }

    public static int dipToPx(Context c, float dipValue) {
        DisplayMetrics metrics = c.getResources().getDisplayMetrics();
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dipValue, metrics);
    }

    public static String generateRandomString() {
        char[] chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
        StringBuilder sb = new StringBuilder(20);
        for (int i = 0; i < 20; i++) {
            char c = chars[random.nextInt(chars.length)];
            sb.append(c);
        }
        return sb.toString();
    }

    public static void openWebPage(Context context, String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW, URLUtil.isValidUrl(url) ? Uri.parse(url) : Uri.parse("http://" + url));
        if (intent.resolveActivity(context.getPackageManager()) != null) {
            context.startActivity(intent);
        }
    }

    public static double distanceTo(LatLng start, LatLng stop, boolean isUnitKM) {
        if (start != null & stop != null) {
            Location locationFrom = new Location("");
            locationFrom.setLatitude(start.latitude);
            locationFrom.setLongitude(start.longitude);

            Location locationTo = new Location("");
            locationTo.setLatitude(stop.latitude);
            locationTo.setLongitude(stop.longitude);
            if (isUnitKM) {
                return locationFrom.distanceTo(locationTo) * 0.001; // Km
            } else {
                return locationFrom.distanceTo(locationTo) * 0.000621371; // mile
            }

        } else {
            return 0;
        }
    }

    public static String getDetailStringFromList(List<String> detailList, int index) {
        if (detailList != null) {
            if (index < detailList.size() && detailList.get(index) != null) {
                return detailList.get(index);
            } else if (!detailList.isEmpty() && detailList.get(0) != null) {
                return detailList.get(0);
            } else {
                return "";
            }
        } else {
            return "";
        }
    }

    public static int setStatusColor(Context context, String prefix, int index, boolean isOrderChange) {
        try {
            if (isOrderChange) {
                return ResourcesCompat.getColor(context.getResources(), R.color.color_status0, null);
            }
            return ResourcesCompat.getColor(context.getResources(), context.getResources().getIdentifier(prefix + index, "color", context.getPackageName()), null);

        } catch (Exception e) {
            AppLog.handleException(TAG, e);
        }
        return ResourcesCompat.getColor(context.getResources(), R.color.color_status0, null);
    }

    public static Drawable getLayerDrawableRoundIconFill(Context context, int resId) {
        Drawable drawableBg = AppCompatResources.getDrawable(context, R.drawable.shape_round);
        drawableBg.setTint(AppColor.COLOR_THEME);
        drawableBg.setAlpha(255);
        Drawable icon = AppCompatResources.getDrawable(context, resId);
        icon.setTint(Color.WHITE);
        Drawable[] layers = new Drawable[]{drawableBg, icon,};
        LayerDrawable layerDrawable = new LayerDrawable(layers);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            layerDrawable.setLayerSize(0, context.getResources().getDimensionPixelSize(R.dimen.dimen_icon_24dp), context.getResources().getDimensionPixelSize(R.dimen.dimen_icon_24dp));
            layerDrawable.setLayerSize(1, context.getResources().getDimensionPixelSize(R.dimen.dimen_icon_12dp), context.getResources().getDimensionPixelSize(R.dimen.dimen_icon_12dp));
            layerDrawable.setLayerGravity(0, Gravity.CENTER);
            layerDrawable.setLayerGravity(1, Gravity.CENTER);
        }
        return layerDrawable;
    }

    /**
     * open call chooser
     *
     * @param context context
     * @param phone   phone
     */
    public static void openCallChooser(Context context, String phone) {
        if (!TextUtils.isEmpty(phone)) {
            Intent intent = new Intent(Intent.ACTION_DIAL);
            intent.setData(Uri.parse("tel:" + phone));
            context.startActivity(Intent.createChooser(intent, context.getString(R.string.text_call_via)));
        }
    }
}