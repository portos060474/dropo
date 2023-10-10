package com.dropo.store.component;

import static com.dropo.store.utils.PreferenceHelper.getPreferenceHelper;

import android.app.Activity;
import android.text.InputFilter;
import android.text.InputType;
import android.util.Patterns;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.Utilities;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogForgotPassword extends BottomSheetDialog implements View.OnClickListener, TextView.OnEditorActionListener {
    private final String TAG = this.getClass().getSimpleName();

    private final EditText etEmail;
    private final RadioButton rbEmail;
    private final RadioButton rbPhone;
    private final Activity context;

    public DialogForgotPassword(Activity context) {
        super(context);
        this.context = context;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_forgot_password);
        etEmail = findViewById(R.id.etEmail);
        rbEmail = findViewById(R.id.rbEmail);
        rbPhone = findViewById(R.id.rbPhone);
        findViewById(R.id.btnNegative).setOnClickListener(this);
        findViewById(R.id.btnPositive).setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
        RadioGroup radioGroup = findViewById(R.id.radioGroup);

        if (getPreferenceHelper(context).getIsLoginByPhone()) {
            rbPhone.setVisibility(View.VISIBLE);
            rbPhone.setChecked(true);
            etEmail.setHint(context.getResources().getString(R.string.text_phone));
            etEmail.setInputType(InputType.TYPE_CLASS_PHONE);
            FieldValidation.setMaxPhoneNumberInputLength(context, etEmail);
        }

        if (getPreferenceHelper(context).getIsLoginByEmail()) {
            rbEmail.setVisibility(View.VISIBLE);
            rbEmail.setChecked(true);
            etEmail.setHint(context.getResources().getString(R.string.text_email));
            etEmail.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
            etEmail.setFilters(new InputFilter[]{});
        }

        radioGroup.setOnCheckedChangeListener((group, checkedId) -> {
            if (checkedId == R.id.rbEmail) {
                etEmail.getText().clear();
                etEmail.setError(null);
                etEmail.setHint(context.getResources().getString(R.string.text_email));
                etEmail.setInputType(InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS);
                etEmail.setFilters(new InputFilter[]{});
            } else {
                etEmail.getText().clear();
                etEmail.setError(null);
                etEmail.setHint(context.getResources().getString(R.string.text_phone));
                etEmail.setInputType(InputType.TYPE_CLASS_PHONE);
                FieldValidation.setMaxPhoneNumberInputLength(context, etEmail);
            }
        });
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnNegative) {
            dismiss();
        } else if (id == R.id.btnPositive) {
            forgetPassword(rbEmail.isChecked(), etEmail.getText().toString());
        }
    }

    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etEmail) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                forgetPassword(rbEmail.isChecked(), etEmail.getText().toString());
                return true;
            }
        }
        return false;
    }


    public abstract void otpSendSuccessFull(boolean isEmail, String sendTo);

    /**
     * this method call webservice for forgot password
     */
    private void forgetPassword(boolean isEmail, String sendTo) {
        if (isEmail && !Patterns.EMAIL_ADDRESS.matcher(sendTo).matches()) {
            etEmail.setError(context.getResources().getString(R.string.msg_valid_email));
            etEmail.requestFocus();
        } else if (!isEmail && !FieldValidation.isValidPhoneNumber(context, etEmail.getText().toString())) {
            etEmail.setError(FieldValidation.getPhoneNumberValidationMessage(context));
            etEmail.requestFocus();
        } else {
            Utilities.showProgressDialog(context);
            HashMap<String, Object> map = new HashMap<>();
            map.put(isEmail ? Constant.EMAIL : Constant.PHONE, sendTo);
            map.put(Constant.TYPE, Constant.Type.STORE);
            Call<IsSuccessResponse> responseCall = ApiClient.getClient().create(ApiInterface.class).forgotPassword(map);
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    Utilities.removeProgressDialog();
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            dismiss();
                            otpSendSuccessFull(isEmail, sendTo);
                        } else {
                            ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    } else {
                        Utilities.showHttpErrorToast(response.code(), context);
                    }
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.removeProgressDialog();
                }
            });
        }
    }
}