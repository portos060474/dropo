package com.dropo.component;

import android.content.Context;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.user.R;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogResetPassword extends BottomSheetDialog implements View.OnClickListener, TextView.OnEditorActionListener {

    private final EditText etNewPassword;
    private final EditText etConfirmNewPassword;
    private final Button btnDialogAlertRight;
    private final ImageView btnDialogAlertLeft;
    private final Context context;
    private final String id;
    private final String serverToken;

    public DialogResetPassword(Context context, String id, String serverToken) {
        super(context);
        this.context = context;
        this.serverToken = serverToken;
        this.id = id;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_reset_password);
        etNewPassword = findViewById(R.id.etNewPassword);
        etConfirmNewPassword = findViewById(R.id.etConfirmNewPassword);
        btnDialogAlertLeft = findViewById(R.id.btnDialogAlertLeft);
        btnDialogAlertRight = findViewById(R.id.btnDialogAlertRight);
        btnDialogAlertLeft.setOnClickListener(this);
        btnDialogAlertRight.setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnDialogAlertLeft) {
            dismiss();
        } else if (id == R.id.btnDialogAlertRight) {
            resetPassword();
        }

    }


    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etDialogEditTextTwo) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                resetPassword();
                return true;
            }
        }

        return false;
    }

    public void resetPassword() {
        if (etNewPassword.getText().toString().trim().length() < 6) {
            etNewPassword.setError(context.getString(R.string.msg_please_enter_valid_password));
            etNewPassword.requestFocus();
        } else if (!TextUtils.equals(etNewPassword.getText().toString().trim(), etConfirmNewPassword.getText().toString().trim())) {
            etConfirmNewPassword.setError(context.getResources().getString(R.string.msg_incorrect_confirm_password));
            etConfirmNewPassword.requestFocus();
        } else {
            HashMap<String, Object> map = new HashMap<>();
            Utils.showCustomProgressDialog(context, false);
            map.put(Const.Params.TYPE, Const.Type.USER);
            map.put(Const.Params.ID, id);
            map.put(Const.Params.SERVER_TOKEN, serverToken);
            map.put(Const.Params.PASS_WORD, etNewPassword.getText().toString().trim());
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = apiInterface.resetPassword(map);
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    Utils.hideCustomProgressDialog();
                    if (ParseContent.getInstance().isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            dismiss();
                            Utils.showMessageToast(response.body().getStatusPhrase(), context);
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
    }
}