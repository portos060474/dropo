package com.dropo;

import static com.dropo.utils.Const.Google.GOOGLE_SIGN_IN;

import android.app.ActivityManager;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;

import com.dropo.fragments.LoginFragment;
import com.dropo.fragments.RegisterFragment;
import com.dropo.persistentroomdata.notification.NotificationRepository;
import com.dropo.user.BuildConfig;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.LocationHelper;
import com.dropo.utils.Utils;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.facebook.internal.ImageRequest;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.SignInButton;
import com.google.android.gms.tasks.Task;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.DefaultLogger;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterAuthClient;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;

import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

public class LoginActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived {

    public LocationHelper locationHelper;
    public CallbackManager callbackManager;
    public RegisterFragment registerFragment;
    public LoginFragment loginFragment;
    public GoogleSignInClient googleSignInClient;
    public boolean isFromCheckOut = false;
    private TwitterLoginButton twitterLoginButton;
    private ProfileTracker profileTracker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS, WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
        preferenceHelper.clearVerification();
        preferenceHelper.logout();
        LoginManager.getInstance().logOut();
        NotificationRepository.getInstance(this).clearNotification();
        initTwitter();
        initViewById();
        setViewListener();
        isFromCheckOut = getIntent().getBooleanExtra(Const.IS_FROM_CHECKOUT, false);
        GoogleSignInOptions googleSignInOptions = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail().requestProfile().build();
        googleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions);
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        callbackManager = CallbackManager.Factory.create();
        swipeLoginAndRegister(true);
    }

    public void swipeLoginAndRegister(boolean isLogin) {
        if (isLogin) {
            loginFragment = new LoginFragment();
            loginFragment.show(getSupportFragmentManager(), loginFragment.getTag());
            if (registerFragment != null) {
                registerFragment.dismiss();
                registerFragment = null;
            }
        } else {
            registerFragment = new RegisterFragment();
            registerFragment.show(getSupportFragmentManager(), registerFragment.getTag());
            if (loginFragment != null) {
                loginFragment.dismiss();
                loginFragment = null;
            }
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        locationHelper.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
        locationHelper.onStop();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
    }

    @Override
    protected void setViewListener() {
    }

    @Override
    protected void onBackNavigation() {
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == GOOGLE_SIGN_IN) {
            getGoogleSignInResult(data);
        }
        callbackManager.onActivityResult(requestCode, resultCode, data);
        twitterLoginButton.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onClick(View view) {
    }

    @Override
    public void onLocationChanged(Location location) {

    }

    @Override
    public void onBackPressed() {
        try {
            ActivityManager activityManager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
            List<ActivityManager.RunningTaskInfo> taskList = activityManager.getRunningTasks(10);
            if (taskList.get(0).numActivities == 2 && taskList.get(0).baseActivity.getClassName().equals(HomeActivity.class.getName())) {
                super.onBackPressed();
            } else {
                if (isFromCheckOut || preferenceHelper.getIsFromQRCode()) {
                    super.onBackPressed();
                } else {
                    goToHomeActivity();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            super.onBackPressed();
        }
    }

    private void initTwitter() {
        TwitterConfig config = new TwitterConfig.Builder(this).logger(new DefaultLogger(Log.DEBUG)).twitterAuthConfig(new TwitterAuthConfig(getResources().getString(R.string.TWITTER_CONSUMER_KEY), getResources().getString(R.string.TWITTER_CONSUMER_SECRET))).debug(BuildConfig.DEBUG).build();
        Twitter.initialize(config);
    }

    private void getFacebookSignInResult(AccessToken accessToken, final Profile profile) {
        GraphRequest data_request = GraphRequest.newMeRequest(accessToken, new GraphRequest.GraphJSONObjectCallback() {
            @Override
            public void onCompleted(JSONObject json_object, GraphResponse response) {
                try {
                    if (registerFragment != null) {
                        registerFragment.updateUiForSocialLogin(json_object.getString(Const.Facebook.EMAIL), profile.getId(), profile.getFirstName(), profile.getLastName(), ImageRequest.getProfilePictureUri(profile.getId(), 250, 250));
                        LoginManager.getInstance().logOut();
                    }
                } catch (Exception e) {
                    AppLog.handleException(Const.Tag.REGISTER_FRAGMENT, e);
                }
            }
        });
        Bundle permission_param = new Bundle();
        permission_param.putString("fields", "id,name,email,picture");
        data_request.setParameters(permission_param);
        data_request.executeAsync();
    }

    private void getGoogleSignInResult(Intent data) {
        Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
        if (task.isSuccessful()) {
            GoogleSignInAccount acct = task.getResult();
            if (loginFragment != null) {
                loginFragment.login(acct.getId());
            } else {
                if (acct != null) {
                    String firstName;
                    String lastName = "";
                    if (acct.getDisplayName().contains(" ")) {
                        String[] strings = acct.getDisplayName().split(" ");
                        firstName = strings[0];
                        lastName = strings[1];
                    } else {
                        firstName = acct.getDisplayName();
                    }
                    if (registerFragment != null) {
                        registerFragment.updateUiForSocialLogin(acct.getEmail(), acct.getId(), firstName, lastName, acct.getPhotoUrl());
                    }
                }
            }
        }
    }

    public void initTwitterLogin(View view) {
        twitterLoginButton = view.findViewById(R.id.btnTwitterLogin);
        twitterLoginButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimensionPixelSize(R.dimen.size_app_text_regular));
        twitterLoginButton.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(this, R.drawable.iconmonstr_twitter_1), null, null, null);
        twitterLoginButton.setCallback(new Callback<TwitterSession>() {
            @Override
            public void success(final Result<TwitterSession> result) {
                Utils.showCustomProgressDialog(LoginActivity.this, false);
                TwitterAuthClient twitterAuthClient = new TwitterAuthClient();
                twitterAuthClient.requestEmail(result.data, new Callback<String>() {
                    @Override
                    public void success(Result<String> result2) {
                        Utils.hideCustomProgressDialog();
                        if (loginFragment != null) {
                            loginFragment.login(String.valueOf(result.data.getUserId()));
                        }
                    }

                    @Override
                    public void failure(TwitterException exception) {
                        Utils.hideCustomProgressDialog();
                        AppLog.handleException("TWITTER_LOGIN", exception);
                    }
                });
            }

            @Override
            public void failure(TwitterException exception) {

            }
        });
    }

    public void initFBLogin(View view) {
        callbackManager = CallbackManager.Factory.create();
        LoginButton faceBookLogin = view.findViewById(R.id.btnFbLogin);
        faceBookLogin.setReadPermissions(Arrays.asList(Const.Facebook.PUBLIC_PROFILE, Const.Facebook.EMAIL));
        faceBookLogin.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                if (loginResult != null) {
                    if (loginFragment != null) {
                        loginFragment.login(loginResult.getAccessToken().getUserId());
                        LoginManager.getInstance().logOut();
                    }
                } else {
                    profileTracker.stopTracking();
                }
            }

            @Override
            public void onCancel() {
                Utils.showToast("Facebook login cancel", LoginActivity.this);

            }

            @Override
            public void onError(@NonNull FacebookException error) {
                Utils.showToast("Facebook login error", LoginActivity.this);
            }
        });
        profileTracker = new ProfileTracker() {
            @Override
            protected void onCurrentProfileChanged(Profile oldProfile, Profile currentProfile) {
                if (AccessToken.getCurrentAccessToken() != null && !AccessToken.getCurrentAccessToken().isExpired()) {
                    getFacebookSignInResult(AccessToken.getCurrentAccessToken(), currentProfile);
                }
            }
        };
    }

    public void initGoogleLogin(View view) {
        SignInButton btnGoogleSingIn;
        btnGoogleSingIn = view.findViewById(R.id.btnGoogleLogin);
        btnGoogleSingIn.setSize(SignInButton.SIZE_WIDE);
        btnGoogleSingIn.setOnClickListener(v -> googleSignInClient.signOut().addOnCompleteListener(task -> {
            Intent intent = googleSignInClient.getSignInIntent();
            startActivityForResult(intent, GOOGLE_SIGN_IN);
        }));
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (profileTracker != null) {
            profileTracker.stopTracking();
        }
    }
}