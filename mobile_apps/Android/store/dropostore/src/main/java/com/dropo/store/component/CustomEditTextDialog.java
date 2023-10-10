package com.dropo.store.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.text.InputType;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.models.responsemodel.OTPResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomImageView;
import com.dropo.store.widgets.CustomInputEditText;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * A Dialog class to display dialog with editText which is use in forgot password and otp verification
 */
public abstract class CustomEditTextDialog extends BottomSheetDialog implements View.OnClickListener {

    private final int otpVerification;
    private final Context context;
    private final String title;
    private final int resendTime = Constant.RESENT_CODE_SECONDS;//second
    public CustomInputEditText etSMSOtp, etEmailOtp;
    public TextInputLayout textInputLayoutSMSOtp, textInputLayoutEmailOtp;
    public String message, textBtnOk;
    private HashMap<String, Object> map;
    private TextView tvResendIn;
    private TextView tvResend;
    private LinearLayout llResentOtp;
    private Boolean isConfirmDetailDialog;
    private boolean isCountDownTimerStart = false;
    private CountDownTimer resendTimer;
    private CustomImageView btnNegative;

    public CustomEditTextDialog(Context context, boolean isConfirmDetailDialog, String title, String message, String textBtnOk, int otpVerification) {
        super(context);
        this.message = message;
        this.otpVerification = otpVerification;
        this.context = context;
        this.textBtnOk = textBtnOk;
        this.title = title;
        this.isConfirmDetailDialog = isConfirmDetailDialog;
    }

    public CustomEditTextDialog(Context context, boolean isConfirmDetailDialog, String title, String message, String textBtnOk, int otpVerification, HashMap<String, Object> map) {
        super(context);
        this.message = message;
        this.otpVerification = otpVerification;
        this.context = context;
        this.textBtnOk = textBtnOk;
        this.title = title;
        this.map = map;
        this.isConfirmDetailDialog = isConfirmDetailDialog;
    }

    @SuppressLint("UseCompatLoadingForDrawables")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Button btnPositive;
        TextView tvTitle;
        TextView tvDialogTitle;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_edittext);

        tvTitle = findViewById(R.id.tvMessage);
        btnPositive = findViewById(R.id.btnPositive);
        etEmailOtp = findViewById(R.id.etEmailOtp);
        etSMSOtp = findViewById(R.id.etSMSOtp);
        tvDialogTitle = findViewById(R.id.tvDialogTitle);
        textInputLayoutEmailOtp = findViewById(R.id.textInputLayoutEmailOtp);
        textInputLayoutSMSOtp = findViewById(R.id.textInputLayoutSMSOtp);
        btnNegative = findViewById(R.id.btnNegative);
        if (btnNegative != null && isConfirmDetailDialog) {
            btnNegative.setImageDrawable(context.getResources().getDrawable(R.drawable.ic_logout));
        }

        if (!TextUtils.isEmpty(title)) {
            tvDialogTitle.setVisibility(View.VISIBLE);
            tvDialogTitle.setText(title);
        }

        if (otpVerification == 0) {
            textInputLayoutEmailOtp.setVisibility(View.VISIBLE);
            etEmailOtp.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            textInputLayoutSMSOtp.setVisibility(View.GONE);
        } else if (otpVerification == 1) {
            etEmailOtp.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_NUMBER_VARIATION_PASSWORD);
            textInputLayoutEmailOtp.setVisibility(View.VISIBLE);
            textInputLayoutSMSOtp.setVisibility(View.GONE);
        } else if (otpVerification == 2) {
            textInputLayoutSMSOtp.setVisibility(View.VISIBLE);
            textInputLayoutEmailOtp.setVisibility(View.GONE);
        } else if (otpVerification == 3) {
            etEmailOtp.setInputType(InputType.TYPE_CLASS_NUMBER);
            etSMSOtp.setInputType(InputType.TYPE_CLASS_NUMBER);
            textInputLayoutSMSOtp.setVisibility(View.VISIBLE);
            textInputLayoutEmailOtp.setVisibility(View.VISIBLE);
        } else if (otpVerification == 4) {
            etEmailOtp.setInputType(InputType.TYPE_CLASS_NUMBER);
            textInputLayoutEmailOtp.setVisibility(View.VISIBLE);
            textInputLayoutSMSOtp.setVisibility(View.GONE);
        } else {
            textInputLayoutEmailOtp.setVisibility(View.VISIBLE);
            textInputLayoutEmailOtp.setHint(context.getResources().getString(R.string.text_email));
            etEmailOtp.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            textInputLayoutSMSOtp.setVisibility(View.GONE);
        }

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;

        btnPositive.setOnClickListener(this);
        btnNegative.setOnClickListener(this);
        tvResendIn = findViewById(R.id.tvResendIn);
        tvResend = findViewById(R.id.tvResend);
        tvResend.setOnClickListener(this);
        llResentOtp = findViewById(R.id.llResentOtp);
        if (map != null && !map.isEmpty()) {
            llResentOtp.setVisibility(View.VISIBLE);
            startTimer(resendTime);
        } else {
            llResentOtp.setVisibility(View.GONE);
        }

        tvTitle.setText(message);
        btnPositive.setText(textBtnOk);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() != R.id.tvResend) {
            btnOnClick(v.getId(), etSMSOtp, etEmailOtp);
        } else {
            if (!isCountDownTimerStart) {
                getOtp(map);
                startTimer(resendTime);
            }
        }
    }

    public abstract void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmailOtp);

    public abstract void resetOtpId(String otpId);

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

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        stopTimer();
    }

    private void getOtp(HashMap<String, Object> map) {
        Call<OTPResponse> otpResponseCall = ApiClient.getClient().create(ApiInterface.class).getStoreOtp(map);
        otpResponseCall.enqueue(new Callback<OTPResponse>() {
            @Override
            public void onResponse(@NonNull Call<OTPResponse> call, @NonNull Response<OTPResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        resetOtpId(response.body().getOtpId());
                    } else {
                        ParseContent.getInstance().showErrorMessage(getContext(), response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), getContext());
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(this.getClass().getSimpleName(), t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}