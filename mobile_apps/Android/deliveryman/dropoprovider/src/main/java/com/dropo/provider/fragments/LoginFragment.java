package com.dropo.provider.fragments;

import android.content.res.TypedArray;
import android.os.Bundle;
import android.text.InputType;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dropo.provider.BuildConfig;
import com.dropo.provider.LoginActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.DialogForgotPasswordOTPVerification;
import com.dropo.provider.component.DialogResetPassword;
import com.dropo.provider.component.ServerDialog;
import com.dropo.provider.interfaces.TripleTapListener;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.models.validations.Validator;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.FieldValidation;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.ServerConfig;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.common.SignInButton;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginFragment extends Fragment implements TextView.OnEditorActionListener, View.OnClickListener {
    private final String TAG = this.getClass().getSimpleName();

    private CustomFontEditTextView etLoginEmail, etLoginPassword;
    private CustomFontTextView tvForgotPassword;
    private CustomFontButton btnLogin;
    private TextInputLayout tilEmail, tilPassword;
    private LoginActivity loginActivity;
    private CustomDialogVerification forgotPassDialog;
    private LinearLayout llSocialLogin;
    private Spinner spinnerLanguage;
    private SignInButton btnGoogleLogin;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        loginActivity = (LoginActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_login, container, false);
        etLoginEmail = view.findViewById(R.id.etLoginEmail);
        etLoginPassword = view.findViewById(R.id.etLoginPassword);
        tvForgotPassword = view.findViewById(R.id.tvForgotPassword);
        btnLogin = view.findViewById(R.id.btnLogin);
        tilEmail = view.findViewById(R.id.tilEmail);
        tilPassword = view.findViewById(R.id.tilPassword);
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        loginActivity.initTwitterLogin(view);
        loginActivity.initFBLogin(view);
        loginActivity.initGoogleLogin(view);
        spinnerLanguage = view.findViewById(R.id.spinnerLanguage);
        btnGoogleLogin = view.findViewById(R.id.btnGoogleLogin);

        TextView btnRegisterNow = view.findViewById(R.id.btnRegisterNow);
        btnRegisterNow.setOnClickListener(this);

        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.elluminati.edelivery.provider")) {
            view.findViewById(R.id.tvSignIn).setOnTouchListener(new TripleTapListener() {
                @Override
                protected void onTripleTap() {
                    showServerDialog();
                }
            });
        }

        TextView textView = (TextView) btnGoogleLogin.getChildAt(0);
        textView.setText(getResources().getString(R.string.google_sign_up));

        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        enabledLoginBy();
        checkSocialLoginISOn(loginActivity.preferenceHelper.getIsLoginBySocial());
        initLanguageSpinner();
        Utils.errorListener(tilEmail);
        Utils.errorListener(tilPassword);
        tvForgotPassword.setOnClickListener(this);
        etLoginPassword.setOnEditorActionListener(this);
        btnLogin.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnRegisterNow) {
            loginActivity.setViewPagerPage(1);
        } else if (id == R.id.btnLogin) {
            if (isValidate()) {
                login("");
            }
        } else if (id == R.id.tvForgotPassword) {
            openForgotPasswordDialog();
        }
    }

    protected boolean isValidate() {
        String msg = null;
        Validator emailValidation = FieldValidation.isEmailValid(loginActivity, etLoginEmail.getText().toString().trim());

        if (TextUtils.equals(tilEmail.getHint().toString(), getResources().getString(R.string.text_email_or_phone))) {
            if (emailValidation.isValid()) {
                msg = validatePassword();
            } else if (FieldValidation.isValidPhoneNumber(loginActivity, etLoginEmail.getText().toString())) {
                msg = validatePassword();
            } else {
                msg = getString(R.string.msg_please_enter_valid_email_or_phone);
                tilEmail.setError(msg);
                etLoginEmail.requestFocus();
            }
        } else if (TextUtils.equals(tilEmail.getHint().toString().trim(), getResources().getString(R.string.text_phone))) {
            if (!FieldValidation.isValidPhoneNumber(loginActivity, etLoginEmail.getText().toString())) {
                msg = FieldValidation.getPhoneNumberValidationMessage(loginActivity);
                tilEmail.setError(msg);
                etLoginEmail.requestFocus();
            } else {
                msg = validatePassword();
            }
        } else if (TextUtils.equals(tilEmail.getHint().toString().trim(), getResources().getString(R.string.text_email))) {
            if (!emailValidation.isValid()) {
                msg = emailValidation.getErrorMsg();
                tilEmail.setError(msg);
                etLoginEmail.requestFocus();
            } else {
                msg = validatePassword();
            }
        }
        return TextUtils.isEmpty(msg);
    }

    private String validatePassword() {
        String msg = null;
        Validator passwordValidation = FieldValidation.isPasswordValid(loginActivity, etLoginPassword.getText().toString().trim());

        if (!passwordValidation.isValid()) {
            msg = passwordValidation.getErrorMsg();
            tilPassword.setError(msg);
            etLoginPassword.requestFocus();
        }
        return msg;
    }

    public void login(String socialId) {
        HashMap<String, Object> map = new HashMap<>();
        if (TextUtils.isEmpty(socialId)) {
            map.put(Const.Params.EMAIL, etLoginEmail.getText().toString());
            map.put(Const.Params.PASS_WORD, etLoginPassword.getText().toString());
            map.put(Const.Params.SOCIAL_ID, socialId);
            map.put(Const.Params.LOGIN_BY, Const.MANUAL);
        } else {
            map.put(Const.Params.EMAIL, "");
            map.put(Const.Params.PASS_WORD, "");
            map.put(Const.Params.SOCIAL_ID, socialId);
            map.put(Const.Params.LOGIN_BY, Const.SOCIAL);
        }
        map.put(Const.Params.DEVICE_TYPE, Const.ANDROID);
        map.put(Const.Params.DEVICE_TOKEN, loginActivity.preferenceHelper.getDeviceToken());
        map.put(Const.Params.APP_VERSION, loginActivity.getAppVersion());

        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProviderDataResponse> providerDataResponseCall = apiInterface.login(map);
        providerDataResponseCall.enqueue(new Callback<ProviderDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProviderDataResponse> call, @NonNull Response<ProviderDataResponse> response) {
                if (loginActivity.parseContent.parseUserStorageData(response)) {
                    Utils.showMessageToast(response.body().getStatusPhrase(), loginActivity);
                    loginActivity.goToHomeActivity();
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProviderDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openForgotPasswordDialog() {
        if (forgotPassDialog != null && forgotPassDialog.isShowing()) {
            return;
        }

        forgotPassDialog = new CustomDialogVerification(loginActivity, loginActivity.getString(R.string.text_forgot_password), loginActivity.getString(R.string.msg_forgot_password), loginActivity.getString(R.string.text_ok), null, loginActivity.getString(R.string.text_phone_no), false, InputType.TYPE_CLASS_PHONE, InputType.TYPE_CLASS_PHONE, false) {
            @Override
            protected void resendOtp() {

            }

            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                String email = etDialogEditTextTwo.getText().toString();
                if (!FieldValidation.isValidPhoneNumber(loginActivity, email)) {
                    etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(loginActivity));
                } else {
                    forgotPassword(email);
                }
            }
        };
        forgotPassDialog.show();
    }

    /**
     * this method call webservice for forgot password
     */
    private void forgotPassword(String phone) {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.PHONE, phone);
        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.forgotPassword(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (loginActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (forgotPassDialog != null && forgotPassDialog.isShowing()) {
                            forgotPassDialog.dismiss();
                        }
                        DialogForgotPasswordOTPVerification verification = new DialogForgotPasswordOTPVerification(loginActivity, phone) {
                            @Override
                            public void optVerifySuccessfully(String id, String severToken) {
                                DialogResetPassword resetPassword = new DialogResetPassword(loginActivity, id, severToken) {
                                };
                                resetPassword.show();
                            }
                        };
                        verification.show();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), loginActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etLoginPassword) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                if (isValidate()) {
                    login("");
                }
                return true;
            }
        }
        return false;
    }

    private void enabledLoginBy() {
        if (loginActivity.preferenceHelper.getIsLoginByEmail() && loginActivity.preferenceHelper.getIsLoginByPhone()) {
            tilEmail.setHint(getResources().getString(R.string.text_email_or_phone));
        }  else if (loginActivity.preferenceHelper.getIsLoginByEmail()) {
            tilEmail.setHint(getResources().getString(R.string.text_email));
        } else if (loginActivity.preferenceHelper.getIsLoginByPhone()) {
            tilEmail.setHint(getResources().getString(R.string.text_phone));
            etLoginEmail.setInputType(InputType.TYPE_CLASS_PHONE);
            FieldValidation.setMaxPhoneNumberInputLength(loginActivity, etLoginEmail);
        }
    }

    public void clearError() {
        if (etLoginEmail != null) {
            etLoginEmail.setError(null);
            etLoginPassword.setError(null);
        }
    }

    private void checkSocialLoginISOn(boolean isSocialLogin) {
        if (isSocialLogin) {
            llSocialLogin.setVisibility(View.VISIBLE);
        } else {
            llSocialLogin.setVisibility(View.GONE);
        }
    }

    private void initLanguageSpinner() {
        TypedArray array = loginActivity.getResources().obtainTypedArray(R.array.language_code);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(loginActivity, R.array.language_name, R.layout.spiner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spiner_view_small);
        spinnerLanguage.setAdapter(adapter);

        spinnerLanguage.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String languageCode = array.getString(i);
                if (!TextUtils.equals(loginActivity.preferenceHelper.getLanguageCode(), languageCode)) {
                    loginActivity.preferenceHelper.putLanguageIndex(i);
                    loginActivity.preferenceHelper.putLanguageCode(languageCode);
                    loginActivity.finishAffinity();
                    loginActivity.restartApp();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        int size = array.length();
        for (int i = 0; i < size; i++) {
            if (TextUtils.equals(loginActivity.preferenceHelper.getLanguageCode(), array.getString(i))) {
                spinnerLanguage.setSelection(i);
                break;
            }
        }
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(loginActivity) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getInstance(loginActivity).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getInstance(loginActivity).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getInstance(loginActivity).putImageUrl(ServerConfig.IMAGE_URL);
                loginActivity.goToSplashActivity();
            }
        };
        serverDialog.show();
    }
}