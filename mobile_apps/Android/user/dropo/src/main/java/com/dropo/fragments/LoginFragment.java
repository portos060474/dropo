package com.dropo.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
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
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.user.BuildConfig;
import com.dropo.LoginActivity;
import com.dropo.user.R;
import com.dropo.component.CustomDialogVerification;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.DialogForgotPasswordOTPVerification;
import com.dropo.component.DialogResetPassword;
import com.dropo.component.ServerDialog;
import com.dropo.interfaces.TripleTapListener;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.models.validations.Validator;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.persistentroomdata.notification.NotificationRepository;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.ServerConfig;
import com.dropo.utils.Utils;
import com.facebook.login.LoginManager;
import com.google.android.gms.common.SignInButton;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
import com.google.android.material.textfield.TextInputLayout;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class LoginFragment extends BottomSheetDialogFragment implements TextView.OnEditorActionListener, View.OnClickListener {

    private EditText etLoginEmail, etLoginPassword;
    private CustomFontTextView tvForgotPassword;
    private CustomFontButton btnLogin;
    private TextInputLayout tilEmail, tilPassword;
    private LoginActivity loginActivity;
    private CustomDialogVerification forgotPassDialog;
    private LinearLayout llSocialLogin;
    private Spinner spinnerLanguage;
    private View ivAppLogo;
    private SignInButton btnGoogleLogin;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.loginActivity = (LoginActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = LayoutInflater.from(loginActivity).inflate(R.layout.fragment_login, container, false);
        etLoginEmail = view.findViewById(R.id.etLoginEmail);
        etLoginPassword = view.findViewById(R.id.etLoginPassword);
        tvForgotPassword = view.findViewById(R.id.tvForgotPassword);
        btnLogin = view.findViewById(R.id.btnLogin);
        tilEmail = view.findViewById(R.id.tilEmail);
        tilPassword = view.findViewById(R.id.tilPassword);
        spinnerLanguage = view.findViewById(R.id.spinnerLanguage);
        ivAppLogo = view.findViewById(R.id.ivAppLogo);
        TextView btnRegisterNow = view.findViewById(R.id.btnRegisterNow);
        btnRegisterNow.setOnClickListener(this);
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        btnGoogleLogin = view.findViewById(R.id.btnGoogleLogin);
        loginActivity.initFBLogin(view);
        loginActivity.initGoogleLogin(view);
        loginActivity.initTwitterLogin(view);

        TextView textView = (TextView) btnGoogleLogin.getChildAt(0);
        textView.setText(getResources().getString(R.string.google_sign_up));

        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        enabledLoginBy();
        checkSocialLoginISOn(loginActivity.preferenceHelper.getIsLoginBySocial());
        initLanguageSpinner();
        tvForgotPassword.setOnClickListener(this);
        btnLogin.setOnClickListener(this);
        etLoginPassword.setOnEditorActionListener(this);
        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.elluminatiinc.edelivery")) {
            ivAppLogo.setOnTouchListener(new TripleTapListener() {
                @Override
                protected void onTripleTap() {
                    showServerDialog();
                }
            });
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnLogin) {
            if (isValidate()) {
                login("");
            }
        } else if (id == R.id.tvForgotPassword) {
            openForgotPasswordDialog();
        } else if (id == R.id.btnRegisterNow) {
            loginActivity.swipeLoginAndRegister(false);
        }
    }

    protected boolean isValidate() {
        String msg = null;
        Validator emailValidation = FieldValidation.isEmailValid(loginActivity, etLoginEmail.getText().toString().trim());

        if (TextUtils.equals(tilEmail.getHint().toString().trim(), getResources().getString(R.string.text_email_or_phone))) {
            if (emailValidation.isValid()) {
                msg = validatePassword();
            } else if (!FieldValidation.isValidPhoneNumber(loginActivity, etLoginEmail.getText().toString())) {
                msg = validatePassword();
            } else {
                msg = getString(R.string.msg_please_enter_valid_email_or_phone);
                tilEmail.setError(msg);
                etLoginEmail.requestFocus();
            }
        } else if (TextUtils.equals(tilEmail.getHint().toString().trim(), getResources().getString(R.string.text_phone))) {
            if (FieldValidation.isValidPhoneNumber(loginActivity, etLoginEmail.getText().toString())) {
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

    /**
     * this method call a webservice for login
     */
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
        map.put(Const.Params.CART_UNIQUE_TOKEN, loginActivity.preferenceHelper.getAndroidId());
        map.put(Const.Params.DEVICE_TYPE, Const.ANDROID);
        map.put(Const.Params.DEVICE_TOKEN, loginActivity.preferenceHelper.getDeviceToken());
        map.put(Const.Params.APP_VERSION, loginActivity.getAppVersion());
        Utils.showCustomProgressDialog(loginActivity, false);
        ApiInterface loginInterface = ApiClient.getClient().create(ApiInterface.class);
        final Call<UserDataResponse> login = loginInterface.login(map);
        login.enqueue(new Callback<UserDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<UserDataResponse> call, @NonNull Response<UserDataResponse> response) {
                if (loginActivity.parseContent.parseUserStorageData(response)) {
                    Utils.showMessageToast(response.body().getStatusPhrase(), loginActivity);
                    if (loginActivity.isFromCheckOut) {
                        loginActivity.setResult(Activity.RESULT_OK);
                        loginActivity.finishAfterTransition();
                    } else {
                        CurrentBooking.getInstance().setBookCityId("");
                        loginActivity.goToHomeActivity();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<UserDataResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.LOG_IN_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openForgotPasswordDialog() {
        if (forgotPassDialog != null && forgotPassDialog.isShowing()) {
            return;
        }

        forgotPassDialog = new CustomDialogVerification(loginActivity, loginActivity.getString(R.string.text_forgot_password), loginActivity.getString(R.string.msg_forgot_password), loginActivity.getString(R.string.text_reset_password), null, loginActivity.getString(R.string.text_phone), false, InputType.TYPE_CLASS_PHONE, InputType.TYPE_CLASS_PHONE, false) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                String phone = etDialogEditTextTwo.getText().toString();
                if (FieldValidation.isValidPhoneNumber(loginActivity, phone)) {
                    etDialogEditTextTwo.setError(FieldValidation.getPhoneNumberValidationMessage(loginActivity));
                } else {
                    forgotPassword(phone);
                }
            }

            @Override
            public void resendOtp() {

            }
        };
        forgotPassDialog.show();
    }

    /**
     * this method call webservice for forgot password
     */
    private void forgotPassword(final String phone) {
        Utils.showCustomProgressDialog(loginActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.PHONE, phone);
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
                AppLog.handleThrowable(Const.Tag.LOG_IN_FRAGMENT, t);
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
        } else if (loginActivity.preferenceHelper.getIsLoginByPhone()) {
            tilEmail.setHint(getResources().getString(R.string.text_phone));
            etLoginEmail.setInputType(InputType.TYPE_CLASS_PHONE);
            FieldValidation.setMaxPhoneNumberInputLength(loginActivity, etLoginEmail);
        } else {
            tilEmail.setHint(getResources().getString(R.string.text_email));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
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
                    loginActivity.preferenceHelper.putLanguageCode(languageCode);
                    loginActivity.preferenceHelper.putLanguageIndex(loginActivity.getLangIndxex(languageCode, loginActivity.currentBooking.getLangs(), false));
                    CurrentBooking.getInstance().setLanguageChanged(true);
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

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        if (loginActivity != null && loginActivity.registerFragment == null && !loginActivity.isFinishing()) {
            loginActivity.onBackPressed();
        }
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(loginActivity) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getInstance(loginActivity).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getInstance(loginActivity).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getInstance(loginActivity).putImageUrl(ServerConfig.IMAGE_URL);

                loginActivity.preferenceHelper.putAndroidId(Utils.generateRandomString());
                loginActivity.preferenceHelper.clearVerification();
                loginActivity.preferenceHelper.logout();
                LoginManager.getInstance().logOut();
                NotificationRepository.getInstance(loginActivity).clearNotification();
                loginActivity.currentBooking.clearCurrentBookingModel();
                loginActivity.goToSplashActivity();
            }
        };
        serverDialog.show();
    }
}