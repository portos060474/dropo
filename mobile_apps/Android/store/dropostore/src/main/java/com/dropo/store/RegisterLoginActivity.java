package com.dropo.store;

import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;

import com.dropo.store.adapter.ViewPagerAdapter;
import com.dropo.store.component.CustomViewPager;
import com.dropo.store.fragment.LoginFragment;
import com.dropo.store.fragment.RegisterFragment;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.persistentroomdata.NotificationRepository;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.LocationHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.GraphRequest;
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
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.android.gms.safetynet.SafetyNet;
import com.google.android.gms.tasks.Task;
import com.google.android.material.tabs.TabLayout;
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

import java.util.Arrays;

public class RegisterLoginActivity extends BaseActivity implements LocationHelper.OnLocationReceived {

    public static final String TAG = RegisterLoginActivity.class.getName();
    public PreferenceHelper preferenceHelper;
    public CallbackManager callbackManager;
    public GoogleSignInClient googleSignInClient;
    private CustomViewPager viewPager;
    private TabLayout tabLayout;
    private ViewPagerAdapter viewPagerAdapter;
    private RegisterFragment registerFragment;
    private LoginFragment loginFragment;
    private TwitterLoginButton twitterLoginButton;
    private ProfileTracker profileTracker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register_login);
        initTwitter();
        CurrentBooking.getInstance().clearCurrentBookingModel();
        SubStoreAccess.getInstance().clearStoreAccess();
        NotificationRepository.getInstance(this).clearNotification();
        preferenceHelper = PreferenceHelper.getPreferenceHelper(this);
        preferenceHelper.clearVerification();
        preferenceHelper.logout();
        LoginManager.getInstance().logOut();
        callbackManager = CallbackManager.Factory.create();
        viewPager = findViewById(R.id.viewPager);
        tabLayout = findViewById(R.id.tabLayout);
        GoogleSignInOptions googleSignInOptions = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail().requestProfile().build();
        googleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions);
        initTabLayout();
    }

    public void gotoHomeActivity() {
        Intent intent = new Intent(this, HomeActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    @Override
    public void onLocationChanged(Location location) {

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constant.GOOGLE_SIGN_IN) {
            getGoogleSignInResult(data);
        }
        callbackManager.onActivityResult(requestCode, resultCode, data);
        twitterLoginButton.onActivityResult(requestCode, resultCode, data);
    }

    private void initTabLayout() {
        if (viewPagerAdapter == null) {
            viewPagerAdapter = new ViewPagerAdapter(getSupportFragmentManager());
            viewPagerAdapter.addFragment(new LoginFragment(), getString(R.string.text_login));
            viewPagerAdapter.addFragment(new RegisterFragment(), getString(R.string.text_register));
            viewPager.setAdapter(viewPagerAdapter);
            tabLayout.setupWithViewPager(viewPager);
            tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
                @Override
                public void onTabSelected(TabLayout.Tab tab) {
                    int position = tab.getPosition();
                    switch (position) {
                        case 0:
                            LoginFragment loginFragment = (LoginFragment) viewPagerAdapter.getItem(position);
                            loginFragment.clearError();
                            break;
                        case 1:
                            RegisterFragment registerFragment = (RegisterFragment) viewPagerAdapter.getItem(position);
                            registerFragment.clearError();
                            break;
                        default:
                            break;
                    }
                }

                @Override
                public void onTabUnselected(TabLayout.Tab tab) {

                }

                @Override
                public void onTabReselected(TabLayout.Tab tab) {

                }
            });
            loginFragment = (LoginFragment) viewPagerAdapter.getItem(0);
            registerFragment = (RegisterFragment) viewPagerAdapter.getItem(1);
            viewPager.setPageScrollEnabled(false);
        }
    }

    public void setViewPagerPage(int item) {
        viewPager.setCurrentItem(item, true);
    }

    private void initTwitter() {
        TwitterConfig config = new TwitterConfig.Builder(this).logger(new DefaultLogger(Log.DEBUG)).twitterAuthConfig(new TwitterAuthConfig(getResources().getString(R.string.TWITTER_CONSUMER_KEY), getResources().getString(R.string.TWITTER_CONSUMER_SECRET))).debug(BuildConfig.DEBUG).build();
        Twitter.initialize(config);
    }

    private void getFacebookSignInResult(AccessToken accessToken, final Profile profile) {
        GraphRequest data_request = GraphRequest.newMeRequest(accessToken, (json_object, response) -> {
            try {
                registerFragment.updateUiForSocialLogin(json_object.getString(Constant.Facebook.EMAIL), profile.getId(), profile.getFirstName(), profile.getLastName(), ImageRequest.getProfilePictureUri(profile.getId(), 250, 250));
            } catch (Exception e) {
                Utilities.handleException(TAG, e);
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
            if (isLoginTabSelect()) {
                if (preferenceHelper.isUseCaptcha()) {
                    checkSafetyNet(token -> loginFragment.login(acct.getId(), token));
                } else {
                    loginFragment.login(acct.getId(), null);
                }
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

    private boolean isLoginTabSelect() {
        return tabLayout.getSelectedTabPosition() == 0;
    }

    public void initTwitterLogin(View view) {
        twitterLoginButton = view.findViewById(R.id.btnTwitterLogin);
        twitterLoginButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimensionPixelSize(R.dimen.size_app_text_regular));
        twitterLoginButton.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(this, R.drawable.iconmonstr_twitter_1), null, null, null);
        twitterLoginButton.setCallback(new Callback<TwitterSession>() {
            @Override
            public void success(final Result<TwitterSession> result) {
                Utilities.showCustomProgressDialog(RegisterLoginActivity.this, false);
                TwitterAuthClient twitterAuthClient = new TwitterAuthClient();
                twitterAuthClient.requestEmail(result.data, new Callback<String>() {
                    @Override
                    public void success(Result<String> result2) {
                        Utilities.hideCustomProgressDialog();
                        if (isLoginTabSelect()) {
                            if (preferenceHelper.isUseCaptcha()) {
                                checkSafetyNet(token -> loginFragment.login(String.valueOf(result.data.getUserId()), token));
                            } else {
                                loginFragment.login(String.valueOf(result.data.getUserId()), null);
                            }
                        } else {
                            registerFragment.updateUiForSocialLogin(result2.data, String.valueOf(result.data.getUserId()), result.data.getUserName(), "", null);
                        }
                    }

                    @Override
                    public void failure(TwitterException exception) {
                        Utilities.hideCustomProgressDialog();
                        Utilities.handleException("TWITTER_LOGIN", exception);
                    }
                });
            }

            @Override
            public void failure(TwitterException exception) {

            }
        });
    }

    public void initGoogleLogin(View view) {
        SignInButton btnGoogleSingIn;
        btnGoogleSingIn = view.findViewById(R.id.btnGoogleLogin);
        btnGoogleSingIn.setSize(SignInButton.SIZE_WIDE);
        btnGoogleSingIn.setOnClickListener(v -> googleSignInClient.signOut().addOnCompleteListener(task -> {
            Intent intent = googleSignInClient.getSignInIntent();
            startActivityForResult(intent, Constant.GOOGLE_SIGN_IN);
        }));
    }

    public void initFBLogin(View view) {
        callbackManager = CallbackManager.Factory.create();
        LoginButton faceBookLogin = view.findViewById(R.id.btnFbLogin);
        faceBookLogin.setReadPermissions(Arrays.asList(Constant.Facebook.PUBLIC_PROFILE, Constant.Facebook.EMAIL));
        faceBookLogin.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                if (loginResult != null) {
                    if (isLoginTabSelect()) {
                        if (preferenceHelper.isUseCaptcha()) {
                            checkSafetyNet(token -> loginFragment.login(loginResult.getAccessToken().getUserId(), token));
                        } else {
                            loginFragment.login(loginResult.getAccessToken().getUserId(), null);
                        }
                        LoginManager.getInstance().logOut();
                    } else {
                        getFacebookSignInResult(AccessToken.getCurrentAccessToken(), Profile.getCurrentProfile());
                        profileTracker.startTracking();
                    }
                } else {
                    profileTracker.stopTracking();
                }
            }

            @Override
            public void onCancel() {
                Utilities.showToast(RegisterLoginActivity.this, "Facebook login cancel");
            }

            @Override
            public void onError(@NonNull FacebookException error) {
                Utilities.showToast(RegisterLoginActivity.this, "Facebook login error");
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (profileTracker != null) {
            profileTracker.stopTracking();
        }
    }

    public void checkSafetyNet(@NonNull CaptchaTokenListener captchaTokenListener) {
        SafetyNet.getClient(this).verifyWithRecaptcha(getResources().getString(R.string.GOOGLE_reCAPTCHA)).addOnSuccessListener(response -> {
            // Indicates communication with reCAPTCHA service was
            // successful.
            String userResponseToken = response.getTokenResult();
            if (!userResponseToken.isEmpty()) {
                // Validate the user response token using the
                // reCAPTCHA siteverify API.
                captchaTokenListener.onToken(userResponseToken);
            } else {
                Utilities.showToast(this, getString(R.string.error_recaptcha));
            }
        }).addOnFailureListener(e -> {
            String error;
            if (e instanceof ApiException) {
                // An error occurred when communicating with the
                // reCAPTCHA service. Refer to the status code to
                // handle the error appropriately.
                ApiException apiException = (ApiException) e;
                int statusCode = apiException.getStatusCode();
                error = CommonStatusCodes.getStatusCodeString(statusCode);
            } else {
                // A different, unknown type of error occurred.
                error = e.getMessage();
            }
            Utilities.printLog(TAG, "Error: " + error);
            Utilities.showToast(this, getString(R.string.error_recaptcha) + "\n" + error);
        }).addOnCanceledListener(() -> Utilities.showToast(this, getString(R.string.error_recaptcha)));
    }

    public interface CaptchaTokenListener {
        void onToken(String token);
    }
}