package com.dropo.component;

import android.content.Context;
import android.os.CountDownTimer;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.user.R;
import com.dropo.models.responsemodels.ForgotPasswordOTPVerificationResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogForgotPasswordOTPVerification extends BottomSheetDialog implements View.OnClickListener {

    private final CustomFontEditTextView etOtp;
    private final TextInputLayout textInputLayoutOtp;
    private final TextView tvResendIn;
    private final String phone;
    private final Context context;
    private final int resendTime = Const.RESENT_CODE_SECONDS;//second
    private final TextView tvResend;
    private boolean isCountDownTimerStart = false;
    private CountDownTimer resendTimer;

    public DialogForgotPasswordOTPVerification(Context context, String phone) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_forgot_password_otp_verification);
        this.phone = phone;
        this.context = context;
        etOtp = findViewById(R.id.etOtp);
        textInputLayoutOtp = findViewById(R.id.textInputLayoutOtp);
        textInputLayoutOtp.setHint(context.getString(R.string.text_phone_otp));
        tvResendIn = findViewById(R.id.tvResendIn);
        tvResend = findViewById(R.id.tvResend);
        tvResend.setOnClickListener(this);
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(v -> dismiss());
        findViewById(R.id.btnPositive).setOnClickListener(v -> {
            if (etOtp.getText().toString().trim().length() == 6) {
                forgotPasswordOTPVerification(etOtp.getText().toString());
            } else {
                Utils.showToast(context.getResources().getString(R.string.please_enter_otp), context);
            }
        });
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
        startTimer(resendTime);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
    }

    private void stopTimer() {
        if (isCountDownTimerStart) {
            isCountDownTimerStart = false;
            resendTimer.cancel();
            resendTimer = null;
        }
    }

    private void startTimer(int seconds) {
        tvResend.setText(getContext().getString(R.string.text_resend_code_in));
        tvResend.setTextColor(AppColor.getThemeTextColor(context));
        if (!isCountDownTimerStart && seconds > 0) {
            isCountDownTimerStart = true;
            long milliSecond = 1000;
            long millisUntilFinished = seconds * milliSecond;
            resendTimer = new CountDownTimer(millisUntilFinished, milliSecond) {
                @Override
                public void onTick(long millisUntilFinished) {
                    String time = String.format(Locale.US, "%02d:%02d", TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished) - TimeUnit.HOURS.toMinutes(TimeUnit.MILLISECONDS.toHours(millisUntilFinished)), TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) - TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished)));
                    tvResendIn.setText(time);
                }

                @Override
                public void onFinish() {
                    stopTimer();
                    tvResendIn.setText("");
                    tvResend.setText(getContext().getString(R.string.text_resend_code));
                    tvResend.setTextColor(AppColor.COLOR_THEME);
                }
            }.start();
        }
    }

    public abstract void optVerifySuccessfully(String id, String serverToken);

    private void forgotPassword(String phone) {
        HashMap<String, Object> map = new HashMap<>();
        Utils.showCustomProgressDialog(context, false);
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.PHONE, phone);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.forgotPassword(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        startTimer(resendTime);
                        Utils.showToast(context.getResources().getString(R.string.text_resent_code), context);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.LOG_IN_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void forgotPasswordOTPVerification(String otp) {
        HashMap<String, Object> map = new HashMap<>();
        Utils.showCustomProgressDialog(context, false);
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.PHONE, phone);
        map.put(Const.Params.OTP, otp);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ForgotPasswordOTPVerificationResponse> responseCall = apiInterface.verifyForgotPasswordOTP(map);
        responseCall.enqueue(new Callback<ForgotPasswordOTPVerificationResponse>() {
            @Override
            public void onResponse(@NonNull Call<ForgotPasswordOTPVerificationResponse> call, @NonNull Response<ForgotPasswordOTPVerificationResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        dismiss();
                        ForgotPasswordOTPVerificationResponse verificationResponse = response.body();
                        optVerifySuccessfully(verificationResponse.getId(), verificationResponse.getServerToken());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ForgotPasswordOTPVerificationResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.LOG_IN_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onDetachedFromWindow() {
        stopTimer();
        super.onDetachedFromWindow();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.tvResend) {
            if (!isCountDownTimerStart) {
                forgotPassword(phone);
            }
        }
    }
}