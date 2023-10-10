package com.dropo.store.component;

import android.content.Context;
import android.os.CountDownTimer;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.models.responsemodel.ForgotPasswordOTPVerificationResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogForgotPasswordOTPVerification extends BottomSheetDialog implements View.OnClickListener {

    private final CustomInputEditText etOtp;
    private final TextInputLayout textInputLayoutOtp;
    private final TextView tvResendIn;
    private final String sendTo;
    private final Context context;
    private final int resendTime = 60;//second
    private final boolean isEmail;
    private final TextView tvDialogAlertMessage;
    private final TextView tvResend;
    private boolean isCountDownTimerStart = false;
    private CountDownTimer resendTimer;

    public DialogForgotPasswordOTPVerification(Context context, String sendTo, boolean isEmail) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_forgot_password_otp_verification);
        this.sendTo = sendTo;
        this.context = context;
        this.isEmail = isEmail;
        etOtp = findViewById(R.id.etOtp);
        textInputLayoutOtp = findViewById(R.id.textInputLayoutOtp);
        textInputLayoutOtp.setHint(context.getString(isEmail ? R.string.text_email_otp : R.string.text_sms_otp));
        tvResendIn = findViewById(R.id.tvResendIn);
        tvResend = findViewById(R.id.tvResend);
        tvResend.setOnClickListener(this);
        findViewById(R.id.btnNegative).setOnClickListener(v -> dismiss());
        findViewById(R.id.btnPositive).setOnClickListener(v -> {
            if (etOtp.getText().toString().trim().length() == 6) {
                forgotPasswordOTPVerification(etOtp.getText().toString(), isEmail);
            } else {
                Utilities.showToast(context, context.getResources().getString(R.string.please_enter_otp));
            }
        });
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
        startTimer(resendTime);
        tvDialogAlertMessage = findViewById(R.id.tvDialogAlertMessage);
        tvDialogAlertMessage.setText(context.getResources().getString(isEmail ? R.string.msg_enter_verification_code_email : R.string.msg_enter_verification_code_phone));
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

    private void forgotPassword(String sendTo) {
        HashMap<String, Object> map = new HashMap<>();
        Utilities.showProgressDialog(context);
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(isEmail ? Constant.EMAIL : Constant.PHONE, sendTo);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.forgotPassword(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        startTimer(resendTime);
                        Utilities.showToast(context, context.getResources().getString(R.string.text_resent_code));
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(DialogResetPassword.class.getSimpleName(), t);
                Utilities.removeProgressDialog();
            }
        });
    }

    private void forgotPasswordOTPVerification(String otp, boolean isEmail) {
        HashMap<String, Object> map = new HashMap<>();
        Utilities.showProgressDialog(context);
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(isEmail ? Constant.EMAIL : Constant.PHONE, sendTo);
        map.put(Constant.OTP, otp);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ForgotPasswordOTPVerificationResponse> responseCall = apiInterface.verifyForgotPasswordOTP(map);
        responseCall.enqueue(new Callback<ForgotPasswordOTPVerificationResponse>() {
            @Override
            public void onResponse(@NonNull Call<ForgotPasswordOTPVerificationResponse> call, @NonNull Response<ForgotPasswordOTPVerificationResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        dismiss();
                        ForgotPasswordOTPVerificationResponse verificationResponse = response.body();
                        optVerifySuccessfully(verificationResponse.getId(), verificationResponse.getServerToken());
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ForgotPasswordOTPVerificationResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(DialogResetPassword.class.getSimpleName(), t);
                Utilities.removeProgressDialog();
            }
        });
    }

    private void stopTimer() {
        if (isCountDownTimerStart) {
            isCountDownTimerStart = false;
            resendTimer.cancel();
            resendTimer = null;
        }
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
                forgotPassword(sendTo);
            }
        }
    }
}