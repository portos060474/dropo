package com.dropo.provider.utils;

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
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.text.Editable;
import android.text.Html;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.provider.LoginActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomCircularProgressView;
import com.google.android.material.textfield.TextInputLayout;

public class Utils {

    public static final String TAG = "Utils";
    private static Dialog dialog;
    private static CustomCircularProgressView ivProgressBar;

    public static void showToast(String message, Context context) {
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
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

    public static void showErrorToast(int code, String error, Context context) {
        if (Const.INVALID_TOKEN == code || Const.PROVIDER_DATA_NOT_FOUND == code) {
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

    public static void showHttpErrorToast(int code, Context context) {
        String msg;
        String errorCode = Const.HTTP_ERROR_CODE_PREFIX + code;
        try {
            msg = context.getResources().getString(context.getResources().getIdentifier(errorCode, Const.STRING, context.getPackageName()));
            showToast(msg, context);
        } catch (Resources.NotFoundException e) {
            AppLog.handleException(TAG, e);
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

    private static void goToLoginActivity(Context context) {
        Intent loginIntent = new Intent(context, LoginActivity.class);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        PreferenceHelper.getInstance(context).logout();
        context.startActivity(loginIntent);
    }

    public static String secondsToHoursMinutesSeconds(long seconds) {
        return (seconds / 3600) + " hr" + " " + (seconds % 3600) / 60 + " min";
    }

    public static String minuteToHoursMinutesSeconds(double minute) {
        long seconds = (long) (minute * 60);
        return (seconds / 3600) + " : " + (seconds % 3600) / 60;
    }

    public static void hideSoftKeyboard(AppCompatActivity activity) {
        if (activity.getCurrentFocus() != null) {
            InputMethodManager inputMethodManager = (InputMethodManager) activity.getSystemService(Activity.INPUT_METHOD_SERVICE);
            inputMethodManager.hideSoftInputFromWindow(activity.getCurrentFocus().getWindowToken(), 0);
        }
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

    public static int setStatusColor(Context context, String prefix, int index) {
        try {
            return ResourcesCompat.getColor(context.getResources(), context.getResources().getIdentifier(prefix + index, "color", context.getPackageName()), null);
        } catch (Exception e) {
            AppLog.handleException(TAG, e);
        }
        return ResourcesCompat.getColor(context.getResources(), R.color.color_status0, null);
    }

    public static void errorListener(TextInputLayout textInputLayout) {
        if (textInputLayout != null) {
            EditText editText = textInputLayout.getEditText();
            editText.addTextChangedListener(new TextWatcher() {
                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    textInputLayout.setError(null);
                }

                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                }

                @Override
                public void afterTextChanged(Editable s) {
                }
            });
        }
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