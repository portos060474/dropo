package com.dropo.component;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.InputType;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import com.dropo.user.R;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;

public abstract class DialogVerifyPayment extends BottomSheetDialog implements View.OnClickListener, TextView.OnEditorActionListener {

    private final CustomFontButton btnDialogAlertRight;
    private final CustomFontTextViewTitle tvDialogTitle;
    private final CustomFontTextView tvDialogMessage;
    private final TextInputLayout tilPin;
    private final String requiredParam;
    private final String reference;
    private EditText etPin;
    private final CustomImageView btnDialogAlertLeft;

    public DialogVerifyPayment(Context context, String requiredParam, String reference) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_verify_payments);
        this.requiredParam = requiredParam;
        this.reference = reference;
        String title = "", message = "", hint = "";
        int inputType = InputType.TYPE_CLASS_TEXT;
        switch (requiredParam) {
            case Const.VerificationParam.SEND_OTP: {
                title = context.getString(R.string.please_enter_otp);
                hint = context.getString(R.string.enter_otp);
                message = context.getString(R.string.eg_123456);
                inputType = InputType.TYPE_CLASS_NUMBER;
            }
            break;
            case Const.VerificationParam.SEND_PIN: {
                title = context.getString(R.string.please_enter_pin);
                hint = context.getString(R.string.enter_pin);
                message = context.getString(R.string.eg_1234);
                inputType = InputType.TYPE_CLASS_NUMBER;
            }
            break;
            case Const.VerificationParam.SEND_ADDRESS: {
                title = context.getString(R.string.please_enter_address);
                hint = context.getString(R.string.enter_address);
                message = context.getString(R.string.enter_address);
            }
            break;
            case Const.VerificationParam.SEND_BIRTHDATE: {
                title = context.getString(R.string.please_enter_birthdate);
                hint = context.getString(R.string.enter_birthdate);
                message = context.getString(R.string.eg_dd_mm_yyyy);
            }
            break;
            case Const.VerificationParam.SEND_PHONE: {
                title = context.getString(R.string.please_enter_phone_no);
                hint = context.getString(R.string.enter_phone_number);
                message = context.getString(R.string.minimum_10_digits);
                inputType = InputType.TYPE_CLASS_PHONE;
            }
            break;
        }
        etPin = findViewById(R.id.etPin);
        btnDialogAlertRight = findViewById(R.id.btnDialogAlertRight);
        tilPin = findViewById(R.id.tilPin);
        btnDialogAlertLeft = findViewById(R.id.btnDialogAlertLeft);
        btnDialogAlertLeft.setOnClickListener(v -> {
            if (DialogVerifyPayment.this.getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(DialogVerifyPayment.this.getCurrentFocus().getWindowToken(), 0);
            }
            doWithDisable();
        });
        tvDialogTitle = findViewById(R.id.tvDialogAlertTitle);
        tvDialogTitle.setText(title);
        btnDialogAlertRight.setOnClickListener(this);
        etPin = findViewById(R.id.etPin);
        etPin.setInputType(inputType);
        tilPin.setHint(hint);
        tvDialogMessage = findViewById(R.id.tvDialogAlertMessage);
        tvDialogMessage.setText(message);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(params);
        getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        setCancelable(false);
    }

    public abstract void doWithEnable(HashMap<String, Object> map);

    private void doWithEnable(EditText editText) {
        if (!TextUtils.isEmpty(etPin.getText().toString().trim())) {
            String input = editText.getText().toString();
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.REFERENCE, reference);
            map.put(Const.Params.REQUIRED_PARAM, requiredParam);
            switch (requiredParam) {
                case Const.VerificationParam.SEND_OTP: {
                    map.put(Const.Params.OTP, input);
                }
                break;
                case Const.VerificationParam.SEND_PIN: {
                    map.put(Const.Params.PIN, input);
                }
                break;
                case Const.VerificationParam.SEND_ADDRESS: {
                    map.put(Const.Params.ADDRESS, input);
                }
                break;
                case Const.VerificationParam.SEND_BIRTHDATE: {
                    map.put(Const.Params.BIRTHDAY, input);
                }
                break;
                case Const.VerificationParam.SEND_PHONE: {
                    map.put(Const.Params.PHONE, input);
                }
            }
            doWithEnable(map);
        } else {
            Utils.showToast(getContext().getString(R.string.msg_plz_enter_valid_field), getContext());
        }
    }

    public abstract void doWithDisable();

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnDialogAlertRight) {
            doWithEnable(etPin);
        }
    }

    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
        int id = v.getId();
        if (id == R.id.etPin) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                doWithEnable(etPin);
                return true;
            }
        }
        return false;
    }
}