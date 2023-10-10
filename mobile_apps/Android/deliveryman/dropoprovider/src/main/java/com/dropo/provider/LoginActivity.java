package com.dropo.provider;

import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;

import com.dropo.provider.adapter.ViewPagerAdapter;
import com.dropo.provider.component.CustomViewPager;
import com.dropo.provider.fragments.LoginFragment;
import com.dropo.provider.fragments.RegisterFragment;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.persistentroomdata.NotificationRepository;
import com.dropo.provider.service.EdeliveryUpdateLocationAndOrderService;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.LocationHelper;
import com.dropo.provider.utils.Utils;
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

public class LoginActivity extends BaseAppCompatActivity implements LocationHelper.OnLocationReceived {

    public LocationHelper locationHelper;
    public CallbackManager callbackManager;
    public GoogleSignInClient googleSignInClient;
    private TabLayout tabLayout;
    private CustomViewPager viewPager;
    private ViewPagerAdapter adapter;
    private RegisterFragment registerFragment;
    private LoginFragment loginFragment;
    private TwitterLoginButton twitterLoginButton;
    private ProfileTracker profileTracker;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        stopService(new Intent(this, EdeliveryUpdateLocationAndOrderService.class));
        initTwitter();
        CurrentOrder.getInstance().clearCurrentOrder();
        NotificationRepository.getInstance(this).clearNotification();
        initViewById();
        setViewListener();
        LoginManager.getInstance().logOut();
        GoogleSignInOptions googleSignInOptions = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).requestEmail().requestProfile().build();
        googleSignInClient = GoogleSignIn.getClient(this, googleSignInOptions);
        preferenceHelper.clearVerification();
        preferenceHelper.logout();
        locationHelper = new LocationHelper(this);
        locationHelper.setLocationReceivedLister(this);
        callbackManager = CallbackManager.Factory.create();
        initTabLayout(viewPager);
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        tabLayout = findViewById(R.id.loginTabsLayout);
        viewPager = findViewById(R.id.loginViewpager);
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
        if (requestCode == Const.GOOGLE_SIGN_IN) {
            getGoogleSignInResult(data);
        }
        callbackManager.onActivityResult(requestCode, resultCode, data);
        twitterLoginButton.onActivityResult(requestCode, resultCode, data);
    }

    private void initTabLayout(CustomViewPager viewPager) {
        if (adapter == null) {
            adapter = new ViewPagerAdapter(getSupportFragmentManager());
            adapter.addFragment(new LoginFragment(), getString(R.string.text_login));
            adapter.addFragment(new RegisterFragment(), getString(R.string.text_register));
            viewPager.setAdapter(adapter);
            tabLayout.setupWithViewPager(viewPager);
            tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
                @Override
                public void onTabSelected(TabLayout.Tab tab) {
                    int position = tab.getPosition();
                    switch (position) {
                        case 0:
                            LoginFragment loginFragment = (LoginFragment) adapter.getItem(position);
                            loginFragment.clearError();
                            break;
                        case 1:
                            RegisterFragment registerFragment = (RegisterFragment) adapter.getItem(position);
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
        }
        loginFragment = (LoginFragment) adapter.getItem(0);
        registerFragment = (RegisterFragment) adapter.getItem(1);
        viewPager.setPageScrollEnabled(false);
    }

    @Override
    public void onClick(View view) {

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
    public void onLocationChanged(Location location) {

    }

    private void initTwitter() {
        TwitterConfig config = new TwitterConfig.Builder(this).logger(new DefaultLogger(Log.DEBUG)).twitterAuthConfig(new TwitterAuthConfig(getResources().getString(R.string.TWITTER_CONSUMER_KEY), getResources().getString(R.string.TWITTER_CONSUMER_SECRET))).debug(BuildConfig.DEBUG).build();
        Twitter.initialize(config);
    }

    private void getFacebookSignInResult(AccessToken accessToken, final Profile profile) {
        GraphRequest data_request = GraphRequest.newMeRequest(accessToken, (json_object, response) -> {
            try {
                registerFragment.updateUiForSocialLogin(json_object.getString(Const.Facebook.EMAIL), profile.getId(), profile.getFirstName(), profile.getLastName(), ImageRequest.getProfilePictureUri(profile.getId(), 250, 250));
                LoginManager.getInstance().logOut();
            } catch (Exception e) {
                AppLog.handleException(TAG, e);
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
                Utils.showCustomProgressDialog(LoginActivity.this, false);
                TwitterAuthClient twitterAuthClient = new TwitterAuthClient();
                twitterAuthClient.requestEmail(result.data, new Callback<String>() {
                    @Override
                    public void success(Result<String> result2) {
                        Utils.hideCustomProgressDialog();
                        if (isLoginTabSelect()) {
                            loginFragment.login(String.valueOf(result.data.getUserId()));
                        } else {
                            registerFragment.updateUiForSocialLogin(result2.data, String.valueOf(result.data.getUserId()), result.data.getUserName(), "", null);
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

    public void initGoogleLogin(View view) {
        SignInButton btnGoogleSingIn;
        btnGoogleSingIn = view.findViewById(R.id.btnGoogleLogin);
        btnGoogleSingIn.setSize(SignInButton.SIZE_WIDE);
        btnGoogleSingIn.setOnClickListener(v -> googleSignInClient.signOut().addOnCompleteListener(task -> {
            Intent intent = googleSignInClient.getSignInIntent();
            startActivityForResult(intent, Const.GOOGLE_SIGN_IN);
        }));
    }

    public void initFBLogin(View view) {
        callbackManager = CallbackManager.Factory.create();
        LoginButton faceBookLogin = view.findViewById(R.id.btnFbLogin);
        faceBookLogin.setReadPermissions(Arrays.asList(Const.Facebook.PUBLIC_PROFILE, Const.Facebook.EMAIL));

        faceBookLogin.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                if (loginResult != null) {
                    if (isLoginTabSelect()) {
                        loginFragment.login(loginResult.getAccessToken().getUserId());
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

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (profileTracker != null) {
            profileTracker.stopTracking();
        }
    }

    public void setViewPagerPage(int item) {
        viewPager.setCurrentItem(item, true);
    }
}