package com.dropo.store.fragment;

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

import com.dropo.store.BuildConfig;
import com.dropo.store.R;
import com.dropo.store.RegisterLoginActivity;
import com.dropo.store.component.DialogForgotPassword;
import com.dropo.store.component.DialogForgotPasswordOTPVerification;
import com.dropo.store.component.DialogResetPassword;
import com.dropo.store.component.ServerDialog;
import com.dropo.store.interfaces.TripleTapListener;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.validations.Validator;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.ServerConfig;
import com.dropo.store.utils.Utilities;

import com.google.android.gms.common.SignInButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginFragment extends Fragment implements View.OnClickListener, TextView.OnEditorActionListener {

    private final String TAG = this.getClass().getSimpleName();

    private TextInputEditText etUserName, etPassword;
    private RegisterLoginActivity activity;
    private DialogForgotPassword forgotPswDialog;
    private RegisterLoginActivity registerLoginActivity;
    private TextInputLayout inputLayoutUserName, inputLayoutUserPassword;
    private LinearLayout llSocialLogin;
    private Spinner spinnerLoginAs, spinnerLanguage;

    private SignInButton btnGoogleLogin;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (RegisterLoginActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_login, container, false);
        registerLoginActivity = (RegisterLoginActivity) getActivity();
        etUserName = view.findViewById(R.id.etUserName);
        etPassword = view.findViewById(R.id.etUserPassword);
        etPassword.setOnEditorActionListener(this);
        inputLayoutUserName = view.findViewById(R.id.inputLayoutUserName);
        inputLayoutUserPassword = view.findViewById(R.id.inputLayoutUserPassword);
        spinnerLoginAs = view.findViewById(R.id.spinnerLoginAs);
        spinnerLanguage = view.findViewById(R.id.spinnerLanguage);
        btnGoogleLogin = view.findViewById(R.id.btnGoogleLogin);
        TextView btnRegisterNow = view.findViewById(R.id.btnRegisterNow);
        btnRegisterNow.setOnClickListener(this);
        view.findViewById(R.id.tvForgotPsw).setOnClickListener(this);
        view.findViewById(R.id.btnLogin).setOnClickListener(this);
        setPlaceHolder();
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        activity.initFBLogin(view);
        activity.initGoogleLogin(view);
        activity.initTwitterLogin(view);

        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.elluminati.edelivery.store")) {
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

    private void setPlaceHolder() {
        if (registerLoginActivity.preferenceHelper.getIsLoginByPhone() && registerLoginActivity.preferenceHelper.getIsLoginByEmail()) {
            inputLayoutUserName.setHint(registerLoginActivity.getResources().getString(R.string.text_email_or_phone));
        } else if (registerLoginActivity.preferenceHelper.getIsLoginByEmail()) {
            inputLayoutUserName.setHint(registerLoginActivity.getResources().getString(R.string.text_email));
        } else if (registerLoginActivity.preferenceHelper.getIsLoginByPhone()) {
            inputLayoutUserName.setHint(registerLoginActivity.getResources().getString(R.string.text_phone));
            etUserName.setInputType(InputType.TYPE_CLASS_PHONE);
            FieldValidation.setMaxPhoneNumberInputLength(activity, etUserName);
        }
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        checkSocialLoginISOn(activity.preferenceHelper.getIsLoginBySocial());
        initStoreLoginOption();
        initLanguageSpinner();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnRegisterNow) {
            activity.setViewPagerPage(1);
        } else if (id == R.id.btnLogin) {
            if (validate()) {
                if (activity.preferenceHelper.isUseCaptcha()) {
                    activity.checkSafetyNet(token -> login("", token));
                } else {
                    login("", null);
                }
            }
        } else if (id == R.id.tvForgotPsw) {
            if (forgotPswDialog != null && forgotPswDialog.isShowing()) {
                return;
            }
            forgotPswDialog = new DialogForgotPassword(activity) {
                @Override
                public void otpSendSuccessFull(boolean isEmail, String sendTo) {
                    Utilities.showToast(activity, getResources().getString(R.string.msg_code_send_successfully));
                    DialogForgotPasswordOTPVerification verification = new DialogForgotPasswordOTPVerification(activity, sendTo, isEmail) {
                        @Override
                        public void optVerifySuccessfully(String id, String severToken) {
                            DialogResetPassword resetPassword = new DialogResetPassword(activity, id, severToken) {
                            };
                            resetPassword.show();
                        }
                    };
                    verification.show();
                }
            };
            forgotPswDialog.show();
        }
    }

    private boolean validate() {
        String msg = null;
        Validator emailValidation = FieldValidation.isEmailValid(activity, etUserName.getText().toString().trim());

        if (TextUtils.equals(inputLayoutUserName.getHint().toString(), getResources().getString(R.string.text_email_or_phone))) {
            if (emailValidation.isValid()) {
                msg = validatePassword();
            } else if (FieldValidation.isValidPhoneNumber(activity, etUserName.getText().toString())) {
                msg = validatePassword();
            } else {
                msg = getString(R.string.msg_please_enter_valid_email_or_phone);
                inputLayoutUserName.setError(msg);
                etUserName.requestFocus();
            }
        } else if (TextUtils.equals(inputLayoutUserName.getHint().toString(), getResources().getString(R.string.text_phone))) {
            if (!FieldValidation.isValidPhoneNumber(activity, etUserName.getText().toString())) {
                msg = FieldValidation.getPhoneNumberValidationMessage(activity);
                inputLayoutUserName.setError(msg);
                etUserName.requestFocus();
            } else {
                msg = validatePassword();
            }
        } else if (TextUtils.equals(inputLayoutUserName.getHint().toString(), getResources().getString(R.string.text_email))) {
            if (!emailValidation.isValid()) {
                msg = emailValidation.getErrorMsg();
                inputLayoutUserName.setError(msg);
                etUserName.requestFocus();
            } else {
                msg = validatePassword();
            }
        }
        return TextUtils.isEmpty(msg);
    }

    private String validatePassword() {
        String msg = null;
        Validator passwordValidation = FieldValidation.isPasswordValid(activity, etPassword.getText().toString().trim());

        if (!passwordValidation.isValid()) {
            msg = passwordValidation.getErrorMsg();
            inputLayoutUserPassword.setError(msg);
            etPassword.requestFocus();
        }
        return msg;
    }

    /**
     * this method call webservice for login to store user
     */
    public void login(String socialId, String token) {
        Utilities.showProgressDialog(activity);
        HashMap<String, Object> map = new HashMap<>();
        if (TextUtils.isEmpty(socialId)) {
            map.put(Constant.EMAIL, etUserName.getText().toString().trim().toLowerCase());
            map.put(Constant.PASS_WORD, etPassword.getText().toString());
            map.put(Constant.SOCIAL_ID, socialId);
            map.put(Constant.LOGIN_BY, Constant.MANUAL);
        } else {
            map.put(Constant.EMAIL, "");
            map.put(Constant.PASS_WORD, "");
            map.put(Constant.SOCIAL_ID, socialId);
            map.put(Constant.LOGIN_BY, Constant.SOCIAL);
        }
        map.put(Constant.CAPTCHA_TOKEN, token);
        map.put(Constant.DEVICE_TOKEN, PreferenceHelper.getPreferenceHelper(activity).getDeviceToken());
        map.put(Constant.DEVICE_TYPE, Constant.ANDROID);
        map.put(Constant.APP_VERSION, activity.getVersionCode());
        Call<StoreDataResponse> call;
        if (TextUtils.equals(activity.getString(R.string.text_sub_store), spinnerLoginAs.getSelectedItem().toString())) {
            call = ApiClient.getClient().create(ApiInterface.class).subStoreLogin(map);
        } else {
            call = ApiClient.getClient().create(ApiInterface.class).login(map);
        }
        call.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        ParseContent.getInstance().parseStoreData(response.body(), false);
                        PreferenceHelper.getPreferenceHelper(activity).putAndroidId(Utilities.generateRandomString());
                        PreferenceHelper.getPreferenceHelper(activity).putCartId("");
                        ParseContent.getInstance().showMessage(activity, response.body().getStatusPhrase());
                        activity.gotoHomeActivity();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public boolean onEditorAction(TextView textView, int actionId, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etUserPassword) {
            if (actionId == EditorInfo.IME_ACTION_DONE) {
                if (validate()) {
                    if (activity.preferenceHelper.isUseCaptcha()) {
                        activity.checkSafetyNet(token -> login("", token));
                    } else {
                        login("", null);
                    }
                }
                return true;
            }
        }
        return false;
    }

    public void clearError() {
        if (etUserName != null) {
            etUserName.setError(null);
            etPassword.setError(null);
        }
    }

    private void checkSocialLoginISOn(boolean isSocialLogin) {
        if (isSocialLogin) {
            llSocialLogin.setVisibility(View.VISIBLE);
        } else {
            llSocialLogin.setVisibility(View.GONE);
        }
    }

    private void initStoreLoginOption() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(activity, R.array.login_as, R.layout.spinner_view_big);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerLoginAs.setAdapter(adapter);
    }

    private void initLanguageSpinner() {
        TypedArray array = activity.getResources().obtainTypedArray(R.array.language_code);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(activity, R.array.language_name, R.layout.spinner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_small);
        spinnerLanguage.setAdapter(adapter);

        spinnerLanguage.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String languageCode = array.getString(i);
                if (!TextUtils.equals(activity.preferenceHelper.getLanguageCode(), languageCode)) {
                    activity.preferenceHelper.putLanguageCode(languageCode);
                    Language.getInstance().setAdminLanguageIndex(
                            Utilities.getLangIndex(languageCode, Language.getInstance().getAdminLanguages(), false),
                            languageCode);
                    Language.getInstance().setStoreLanguageIndex(
                            Utilities.getLangIndex(languageCode, Language.getInstance().getStoreLanguages(), true)
                    );
                    activity.finishAffinity();
                    activity.restartApp();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        int size = array.length();
        for (int i = 0; i < size; i++) {
            if (TextUtils.equals(activity.preferenceHelper.getLanguageCode(), array.getString(i))) {
                spinnerLanguage.setSelection(i);
                break;
            }
        }
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(activity) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getPreferenceHelper(activity).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getPreferenceHelper(activity).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getPreferenceHelper(activity).putImageUrl(ServerConfig.IMAGE_URL);
                activity.gotoSplashActivity();
            }
        };
        serverDialog.show();
    }
}