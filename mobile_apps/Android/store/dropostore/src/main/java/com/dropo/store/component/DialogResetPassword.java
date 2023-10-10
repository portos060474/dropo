package com.dropo.store.component;

import android.content.Context;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogResetPassword extends BottomSheetDialog implements View.OnClickListener, TextView.OnEditorActionListener {
    private final EditText etNewPassword;
    private final EditText etConfirmNewPassword;
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
        findViewById(R.id.btnNegative).setOnClickListener(this);
        Button button = findViewById(R.id.btnPositive);
        button.setOnClickListener(this);
        button.setText(R.string.text_reset);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(false);
    }

    @Override
    public void onClick(View view) {
        int viewId = view.getId();
        if (viewId == R.id.btnNegative) {
            dismiss();
        } else if (viewId == R.id.btnPositive) {
            resetPassword();
        }
    }


    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etConfirmNewPassword) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                resetPassword();
                return true;
            }
        }
        return false;
    }

    public void resetPassword() {
        if (etNewPassword.getText().toString().trim().length() < 6) {
            etNewPassword.setError(context.getString(R.string.msg_password_length));
            etNewPassword.requestFocus();
        } else if (!TextUtils.equals(etNewPassword.getText().toString().trim(), etConfirmNewPassword.getText().toString().trim())) {
            etConfirmNewPassword.setError(context.getResources().getString(R.string.msg_mismatch_password));
            etConfirmNewPassword.requestFocus();
        } else {
            HashMap<String, Object> map = new HashMap<>();
            Utilities.showProgressDialog(context);

            map.put(Constant.TYPE, Constant.Type.STORE);
            map.put(Constant.ID, id);
            map.put(Constant.SERVER_TOKEN, serverToken);
            map.put(Constant.PASS_WORD, etNewPassword.getText().toString().trim());

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = apiInterface.resetPassword(map);
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    Utilities.removeProgressDialog();
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            dismiss();
                            ParseContent.getInstance().showMessage(context, response.body().getStatusPhrase());
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
    }
}