package com.dropo.component;

import android.content.Context;
import android.os.CountDownTimer;
import android.text.InputType;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.Locale;
import java.util.concurrent.TimeUnit;

public abstract class CustomDialogVerification extends BottomSheetDialog implements View.OnClickListener, TextView.OnEditorActionListener {

    private final CustomFontEditTextView etDialogEditTextOne;
    private final CustomFontEditTextView etDialogEditTextTwo;
    private final TextView tvDialogEdiTextMessage;
    private final TextView tvDialogEditTextTitle;
    private final Button btnDialogEditTextRight;
    private final ImageView btnDialogEditTextLeft;
    private final TextInputLayout dialogItlOne;
    private final TextInputLayout dialogItlTwo;
    private final int resendTime = Const.RESENT_CODE_SECONDS;//second

    private final TextView tvResendIn;
    private final TextView tvResend;
    private final LinearLayout llResentOtp;
    private boolean isCountDownTimerStart = false;
    private CountDownTimer resendTimer;

    public CustomDialogVerification(Context context, String titleDialog, String messageDialog, String titleRightButton,
                                    String editTextOneHint, String editTextTwoHint, boolean isEdiTextOneIsVisible,
                                    int editTextOneInputType, int editTextTwoInputType, boolean isOtpDialog) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_custom_verification);
        tvDialogEdiTextMessage = findViewById(R.id.tvDialogAlertMessage);
        tvDialogEditTextTitle = findViewById(R.id.tvDialogAlertTitle);
        btnDialogEditTextLeft = findViewById(R.id.btnDialogAlertLeft);
        btnDialogEditTextRight = findViewById(R.id.btnDialogAlertRight);
        etDialogEditTextOne = findViewById(R.id.etDialogEditTextOne);
        etDialogEditTextTwo = findViewById(R.id.etDialogEditTextTwo);
        dialogItlOne = findViewById(R.id.dialogItlOne);
        dialogItlTwo = findViewById(R.id.dialogItlTwo);
        btnDialogEditTextLeft.setOnClickListener(this);
        btnDialogEditTextRight.setOnClickListener(this);

        tvDialogEditTextTitle.setText(titleDialog);
        tvDialogEdiTextMessage.setText(messageDialog);
        btnDialogEditTextRight.setText(titleRightButton);
        etDialogEditTextTwo.setInputType(editTextTwoInputType);
        etDialogEditTextOne.setInputType(editTextOneInputType);
        etDialogEditTextTwo.setOnEditorActionListener(this);
        dialogItlOne.setHint(editTextOneHint);
        dialogItlTwo.setHint(editTextTwoHint);
        if (editTextTwoInputType == InputType.TYPE_TEXT_VARIATION_PASSWORD) {
            dialogItlTwo.setEndIconMode(TextInputLayout.END_ICON_PASSWORD_TOGGLE);
        }
        if (isEdiTextOneIsVisible) {
            etDialogEditTextOne.setVisibility(View.VISIBLE);
            dialogItlOne.setVisibility(View.VISIBLE);
        }
        if (editTextOneInputType == InputType.TYPE_CLASS_PHONE) {
            FieldValidation.setMaxPhoneNumberInputLength(context, etDialogEditTextOne);
        }
        if (editTextTwoInputType == InputType.TYPE_CLASS_PHONE) {
            FieldValidation.setMaxPhoneNumberInputLength(context, etDialogEditTextTwo);
        }
        tvResendIn = findViewById(R.id.tvResendIn);
        tvResend = findViewById(R.id.tvResend);
        tvResend.setOnClickListener(this);
        llResentOtp = findViewById(R.id.llResentOtp);
        if (isOtpDialog) {
            llResentOtp.setVisibility(View.VISIBLE);
            startTimer(resendTime);
        } else {
            llResentOtp.setVisibility(View.GONE);
        }

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        setCancelable(false);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnDialogAlertLeft) {
            onClickLeftButton();
        } else if (id == R.id.btnDialogAlertRight) {
            onClickRightButton(etDialogEditTextOne, etDialogEditTextTwo);
        } else if (id == R.id.tvResend) {
            if (!isCountDownTimerStart) {
                resendOtp();
                startTimer(resendTime);
            }
        }
    }

    public abstract void onClickLeftButton();

    public abstract void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo);

    public abstract void resendOtp();


    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etDialogEditTextTwo) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                onClickRightButton(etDialogEditTextOne, etDialogEditTextTwo);
                return true;
            }
        }

        return false;
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
        tvResend.setTextColor(AppColor.getThemeTextColor(getContext()));
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
}