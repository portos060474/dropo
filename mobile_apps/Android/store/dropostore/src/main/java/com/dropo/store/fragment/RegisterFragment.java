package com.dropo.store.fragment;

import static com.dropo.store.utils.Constant.REQUEST_CHECK_SETTINGS;
import static com.dropo.store.utils.Constant.STORE_LOCATION_RESULT;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.store.R;
import com.dropo.store.RegisterLoginActivity;
import com.dropo.store.StoreLocationActivity;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomCountryCityDialog;
import com.dropo.store.component.CustomEditTextDialog;
import com.dropo.store.component.CustomListDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.Category;
import com.dropo.store.models.datamodel.City;
import com.dropo.store.models.datamodel.Country;
import com.dropo.store.models.responsemodel.CategoriesResponse;
import com.dropo.store.models.responsemodel.CityResponse;
import com.dropo.store.models.responsemodel.CountriesResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.OTPResponse;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.validations.Validator;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageCompression;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.LocationHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.makeramen.roundedimageview.RoundedImageView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class RegisterFragment extends Fragment implements View.OnClickListener, LocationHelper.OnLocationReceived {

    private final String TAG = "RegisterFragment";

    public String cityId, countryId, countryCode, categoryId, cCode;
    public ArrayList<Country> countryList;
    public ArrayList<Category> categoryList;
    private EditText etName, etEmail, etPassword, etAddress, etMobileNo, etSlogan, etWebsite, etLat, etLng;
    private TextView tvCountry, tvCity, tvCategory, tvCountryCode;
    private ImageView ivSuccess;
    private RoundedImageView ivProfile;
    private RegisterLoginActivity activity;
    private Uri uri;
    private ArrayList<City> cityList;
    private LocationHelper locationHelper;
    private ImageHelper imageHelper;
    private TextView tvReferralApply;
    private CustomInputEditText etReferralCode;
    private String referralCode = "", socialId = "";
    private LinearLayout llReferral;
    private CustomListDialog customListDialog;
    private CustomCountryCityDialog customCountryCityDialog;
    private ImageView ivStoreLocation;
    private TextInputLayout tilPassword;
    private LinearLayout llSocialLogin;
    private CheckBox cbTcPolicy;
    private CustomTextView tvPolicy;
    private String currentPhotoPath;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private CustomEditTextDialog accountVerifyDialog;
    private TextView btnLoginNow;
    private String otpId;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (RegisterLoginActivity) getActivity();
        locationHelper = new LocationHelper(activity);
        locationHelper.setLocationReceivedLister(this);
        imageHelper = new ImageHelper(activity);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_register, container, false);
        etName = view.findViewById(R.id.etName);
        etEmail = view.findViewById(R.id.etEmail);
        etPassword = view.findViewById(R.id.etPassword);
        etAddress = view.findViewById(R.id.etAddress);
        etMobileNo = view.findViewById(R.id.etMobileNo);
        etSlogan = view.findViewById(R.id.etSlogan);
        etWebsite = view.findViewById(R.id.etWebsite);
        etLat = view.findViewById(R.id.etLat);
        etLng = view.findViewById(R.id.etLng);
        ivProfile = view.findViewById(R.id.ivProfile);
        tvCountry = view.findViewById(R.id.tvCountry);
        tvCountryCode = view.findViewById(R.id.tvCountryCode);
        tvCategory = view.findViewById(R.id.tvDeliveryType);
        tvCity = view.findViewById(R.id.tvCity);
        btnLoginNow = view.findViewById(R.id.btnLoginNow);
        btnLoginNow.setOnClickListener(this);
        LinearLayout llOptionalField = view.findViewById(R.id.llOptionalField);
        FieldValidation.setMaxPhoneNumberInputLength(activity, etMobileNo);
        if (PreferenceHelper.getPreferenceHelper(activity).isShowOptionalFieldInRegister()) {
            llOptionalField.setVisibility(View.VISIBLE);
        } else {
            llOptionalField.setVisibility(View.GONE);
        }

        view.findViewById(R.id.ivProfileImageSelect).setOnClickListener(this);
        view.findViewById(R.id.btnRegister).setOnClickListener(this);

        tvCountry.setOnClickListener(this);
        tvCity.setOnClickListener(this);
        tvCategory.setOnClickListener(this);

        tvReferralApply = view.findViewById(R.id.tvReferralApply);
        ivSuccess = view.findViewById(R.id.ivSuccess);
        etReferralCode = view.findViewById(R.id.etReferralCode);
        llReferral = view.findViewById(R.id.llReferral);

        tilPassword = view.findViewById(R.id.tilPassword);
        llSocialLogin = view.findViewById(R.id.llSocialButton);
        ivStoreLocation = view.findViewById(R.id.ivStoreLocation);
        cbTcPolicy = view.findViewById(R.id.cbTcPolicy);
        tvPolicy = view.findViewById(R.id.tvPolicy);
        activity.initFBLogin(view);
        activity.initGoogleLogin(view);
        activity.initTwitterLogin(view);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        checkSocialLoginISOn(activity.preferenceHelper.getIsLoginBySocial());
        tvReferralApply.setOnClickListener(this);
        ivStoreLocation.setOnClickListener(this);
        etAddress.setOnClickListener(this);
        String link = activity.getResources().getString(R.string.text_link_sign_up_privacy) + " " + "<a href=\"" + activity.preferenceHelper.getTermsANdConditions() + "\"" + ">" + getResources().getString(R.string.text_t_and_c) + "</a>" + " " + activity.getResources().getString(R.string.text_and) + " " + "<a href=\"" + activity.preferenceHelper.getPolicy() + "\"" + ">" + getResources().getString(R.string.text_policy) + "</a>";
        tvPolicy.setText(Utilities.fromHtml(link));
        tvPolicy.setMovementMethod(LinkMovementMethod.getInstance());
    }

    @Override
    public void onStart() {
        super.onStart();
        checkPermission();
    }

    private void checkPermission() {
        if (ContextCompat.checkSelfPermission(activity, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(activity, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, Constant.PERMISSION_FOR_LOCATION);
        } else {
            getCountryList();
            locationHelper.onStart();
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        locationHelper.onStop();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnLoginNow) {
            activity.setViewPagerPage(0);
        } else if (id == R.id.ivProfileImageSelect) {
            showPhotoSelectionDialog();
        } else if (id == R.id.btnRegister) {
            validate();
        } else if (id == R.id.tvCountry) {
            if (countryList != null && countryList.size() > 0) {
                if (customCountryCityDialog != null && customCountryCityDialog.isShowing()) {
                    return;
                }
                customCountryCityDialog = new CustomCountryCityDialog(activity, countryList, new ArrayList<>(), true) {
                    @Override
                    public void onSelect(Object object) {
                        setCountry(object);
                        dismiss();
                    }
                };
                customCountryCityDialog.show();
            }
        } else if (id == R.id.tvCity) {
            if (countryId != null) {
                if (cityList != null && cityList.size() > 0) {
                    if (customCountryCityDialog != null && customCountryCityDialog.isShowing()) {
                        return;
                    }
                    customCountryCityDialog = new CustomCountryCityDialog(activity, new ArrayList<>(), cityList, false) {
                        @Override
                        public void onSelect(Object object) {
                            City city = (City) object;
                            if (!TextUtils.equals(cityId, city.getId())) {
                                cityId = city.getId();
                                tvCity.setText(city.getCityName());
                                tvCategory.setText(getResources().getString(R.string.text_select_category));
                                getCategoryList(cityId);
                            }
                            this.dismiss();
                        }
                    };
                    customCountryCityDialog.show();
                }
            } else {
                new CustomAlterDialog(activity, null, activity.getResources().getString(R.string.msg_choose_country)) {
                    @Override
                    public void btnOnClick(int btnId) {
                        this.dismiss();
                    }
                }.show();
            }
        } else if (id == R.id.tvDeliveryType) {
            if (categoryList != null && categoryList.size() > 0) {
                if (customListDialog != null && customListDialog.isShowing()) {
                    return;
                }
                customListDialog = new CustomListDialog(activity, categoryList, 1) {
                    @Override
                    public void onItemClickOnList(Object object) {
                        Category category = (Category) object;
                        categoryId = category.getId();
                        tvCategory.setText(category.getDeliveryName());
                        this.dismiss();
                    }
                };
                customListDialog.show();
            }
        } else if (id == R.id.tvReferralApply) {
            if (TextUtils.isEmpty(etReferralCode.getText().toString().trim())) {
                Utilities.showToast(activity, activity.getResources().getString(R.string.msg_plz_enter_valid_referral));
            } else {
                if (TextUtils.isEmpty(countryId)) {
                    Utilities.showToast(activity, activity.getResources().getString(R.string.msg_select_your_country_first));
                } else {
                    checkReferralCode();
                }
            }
        } else if (id == R.id.ivStoreLocation || id == R.id.etAddress) {
            setStoreAddressORLocation();
        } else if (id == R.id.etName) {
            addMultiLanguageDetail(etName.getHint().toString(), (List<String>) etName.getTag(), detailList -> {
                etName.setTag(detailList);
                etName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
            });
        }
    }

    /**
     * this method call a webservice for get city list
     *
     * @param countryId selected country id in string
     */
    private void getCityList(String countryId) {
        Utilities.showProgressDialog(activity);
        Call<CityResponse> citiesCall = ApiClient.getClient().create(ApiInterface.class).getCities(countryId);
        citiesCall.enqueue(new Callback<CityResponse>() {
            @Override
            public void onResponse(@NonNull Call<CityResponse> call, @NonNull Response<CityResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        cityList = response.body().getCities();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<CityResponse> call, @NonNull Throwable t) {
                t.printStackTrace();
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void validate() {
        Validator emailValidation = FieldValidation.isEmailValid(activity, etEmail.getText().toString().trim());
        Validator passwordValidation = FieldValidation.isPasswordValid(activity, etPassword.getText().toString().trim());

        if (TextUtils.isEmpty(etName.getText().toString().trim())) {
            etName.setError(activity.getResources().getString(R.string.msg_empty_name));
        } else if (!emailValidation.isValid()) {
            etEmail.setError(emailValidation.getErrorMsg());
        } else if (etPassword.getVisibility() == View.VISIBLE && !passwordValidation.isValid()) {
            etPassword.setError(passwordValidation.getErrorMsg());
        } else if (countryId == null) {
            new CustomAlterDialog(activity, null, activity.getResources().getString(R.string.msg_choose_country)) {
                @Override
                public void btnOnClick(int btnId) {
                    this.dismiss();
                }
            }.show();
        } else if (cityId == null) {
            new CustomAlterDialog(activity, null, activity.getResources().getString(R.string.msg_choose_city)) {
                @Override
                public void btnOnClick(int btnId) {
                    this.dismiss();
                }
            }.show();
        } else if (categoryId == null) {
            new CustomAlterDialog(activity, null, activity.getResources().getString(R.string.msg_choose_type)) {
                @Override
                public void btnOnClick(int btnId) {
                    this.dismiss();
                }
            }.show();
        } else if (TextUtils.isEmpty(etAddress.getText().toString().trim())) {
            etAddress.setError(activity.getResources().getString(R.string.msg_empty_address));
        } else if (TextUtils.isEmpty(etLat.getText().toString().trim())) {
            etAddress.setError(this.getResources().getString(R.string.msg_empty_address));
        } else if (TextUtils.isEmpty(etLng.getText().toString().trim())) {
            etAddress.setError(this.getResources().getString(R.string.msg_empty_address));
        } else if (!FieldValidation.isValidPhoneNumber(activity, etMobileNo.getText().toString())) {
            etMobileNo.setError(FieldValidation.getPhoneNumberValidationMessage(activity));
        } else if (!cbTcPolicy.isChecked()) {
            Utilities.showToast(activity, getResources().getString(R.string.msg_plz_accept_tc));
        } else {
            if (activity.preferenceHelper.getIsVerifyEmail() || activity.preferenceHelper.getIsVerifyPhone()) {
                if (!TextUtils.isEmpty(socialId)) {
                    if (activity.preferenceHelper.getIsVerifyPhone()) {
                        if (activity.preferenceHelper.isUseCaptcha()) {
                            activity.checkSafetyNet(this::getOtp);
                        } else {
                            getOtp(null);
                        }
                    } else {
                        if (activity.preferenceHelper.isUseCaptcha()) {
                            activity.checkSafetyNet(token -> register(false, false, token));
                        } else {
                            register(false, false, null);
                        }
                    }
                } else {
                    if (activity.preferenceHelper.isUseCaptcha()) {
                        activity.checkSafetyNet(this::getOtp);
                    } else {
                        getOtp(null);
                    }
                }
            } else {
                if (activity.preferenceHelper.isUseCaptcha()) {
                    activity.checkSafetyNet(token -> register(false, false, token));
                } else {
                    register(false, false, null);
                }
            }
        }
    }

    private void register(boolean isEmailVerified, boolean isPhoneVerified, String token) {
        Utilities.showProgressDialog(activity);

        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_SERVICE_ID, ApiClient.makeTextRequestBody(categoryId));
        map.put(Constant.NAME, ApiClient.makeTextRequestBody(etName.getText().toString().trim()));
        map.put(Constant.EMAIL, ApiClient.makeTextRequestBody(etEmail.getText().toString().trim().toLowerCase()));
        map.put(Constant.COUNTRY_CODE, ApiClient.makeTextRequestBody(countryCode));
        map.put(Constant.PHONE, ApiClient.makeTextRequestBody(etMobileNo.getText().toString().trim()));
        map.put(Constant.ADDRESS, ApiClient.makeTextRequestBody(etAddress.getText().toString()));
        map.put(Constant.COUNTRY_ID, ApiClient.makeTextRequestBody(countryId));
        map.put(Constant.DEVICE_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(activity).getDeviceToken()));
        map.put(Constant.DEVICE_TYPE, ApiClient.makeTextRequestBody(Constant.ANDROID));
        map.put(Constant.SLOGAN, ApiClient.makeTextRequestBody(etSlogan.getText().toString().trim()));
        map.put(Constant.WEBSITE_URL, ApiClient.makeTextRequestBody(etWebsite.getText().toString().trim()));
        map.put(Constant.CITY_ID, ApiClient.makeTextRequestBody(cityId));
        map.put(Constant.LATITUDE, ApiClient.makeTextRequestBody(etLat.getText().toString()));
        map.put(Constant.LONGITUDE, ApiClient.makeTextRequestBody(etLng.getText().toString()));
        map.put(Constant.APP_VERSION, ApiClient.makeTextRequestBody(activity.getVersionCode()));
        map.put(Constant.REFERRAL_CODE, ApiClient.makeTextRequestBody(referralCode));
        map.put(Constant.IS_PHONE_NUMBER_VERIFIED, ApiClient.makeTextRequestBody(String.valueOf(isPhoneVerified)));
        map.put(Constant.IS_EMAIL_VERIFIED, ApiClient.makeTextRequestBody(String.valueOf(isEmailVerified)));
        map.put(Constant.SOCIAL_ID, ApiClient.makeTextRequestBody(String.valueOf(socialId)));
        map.put(Constant.CAPTCHA_TOKEN, ApiClient.makeTextRequestBody(String.valueOf(token)));
        if (TextUtils.isEmpty(socialId)) {
            map.put(Constant.PASS_WORD, ApiClient.makeTextRequestBody(etPassword.getText().toString()));
            map.put(Constant.LOGIN_BY, ApiClient.makeTextRequestBody(Constant.MANUAL));
        } else {
            map.put(Constant.PASS_WORD, ApiClient.makeTextRequestBody(""));
            map.put(Constant.LOGIN_BY, ApiClient.makeTextRequestBody(Constant.SOCIAL));
        }
        Call<StoreDataResponse> call = ApiClient.getClient().create(ApiInterface.class).register(map, ApiClient.makeMultipartRequestBody(activity, currentPhotoPath, Constant.IMAGE_URL));
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
                        activity.preferenceHelper.clearVerification();
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    activity.preferenceHelper.clearVerification();
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                activity.preferenceHelper.clearVerification();
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void getOtp(String token) {
        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.EMAIL, etEmail.getText().toString());
        map.put(Constant.PHONE, etMobileNo.getText().toString());
        map.put(Constant.TYPE, String.valueOf(Constant.Type.STORE));
        map.put(Constant.COUNTRY_CODE, countryCode);
        map.put(Constant.CAPTCHA_TOKEN, token);
        Call<OTPResponse> otpResponseCall = ApiClient.getClient().create(ApiInterface.class).getStoreOtp(map);
        otpResponseCall.enqueue(new Callback<OTPResponse>() {
            @Override
            public void onResponse(@NonNull Call<OTPResponse> call, @NonNull Response<OTPResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        otpId = response.body().getOtpId();
                        openAccountVerifyDialog(map);
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void verifyStoreOtp(String emailOTP, String smsOTP, String otpId) {
        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        if (!TextUtils.isEmpty(emailOTP)) {
            map.put(Constant.EMAIL_OTP, emailOTP);
        }
        if (!TextUtils.isEmpty(smsOTP)) {
            map.put(Constant.SMS_OTP, smsOTP);
        }
        map.put(Constant.OTP_ID, otpId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OTPResponse> getStoreOtpResponse = apiInterface.storeOtpVerification(map);
        getStoreOtpResponse.enqueue(new Callback<OTPResponse>() {
            @Override
            public void onResponse(@NonNull Call<OTPResponse> call, @NonNull Response<OTPResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        if (accountVerifyDialog != null && accountVerifyDialog.isShowing()) {
                            accountVerifyDialog.dismiss();
                        }
                        if (activity.preferenceHelper.isUseCaptcha()) {
                            activity.checkSafetyNet(token -> register(response.body().isEmailVerification(), response.body().isSmsVerification(), token));
                        } else {
                            register(response.body().isEmailVerification(), response.body().isSmsVerification(), null);
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OTPResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void showPhotoSelectionDialog() {
        new CustomPhotoDialog(activity) {
            @Override
            public void gallery() {
                choosePhotoFromGallery();
            }

            @Override
            public void camera() {
                takePhotoFromCameraPermission();
            }
        }.show();
    }

    private void choosePhotoFromGallery() {
        if (ContextCompat.checkSelfPermission(activity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_CHOOSE_PHOTO);
        } else {
            Intent galleryIntent = new Intent();
            galleryIntent.setType("image/*");
            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(galleryIntent, Constant.PERMISSION_CHOOSE_PHOTO);
        }
    }

    private void takePhotoFromCameraPermission() {
        if (ContextCompat.checkSelfPermission(activity, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(activity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_TAKE_PHOTO);
        } else {
            takePhotoFromCamera();
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        uri = imageHelper.createTakePictureUri();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        startActivityForResult(intent, Constant.PERMISSION_TAKE_PHOTO);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case Constant.PERMISSION_CHOOSE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        choosePhotoFromGallery();
                    }
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        takePhotoFromCameraPermission();
                    }
                }
                break;
            case Constant.PERMISSION_FOR_LOCATION:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        getCountryList();
                        locationHelper.onStart();
                    }
                }
                break;
            default:
                break;
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case Constant.PERMISSION_CHOOSE_PHOTO:
                    if (data != null) {
                        uri = data.getData();
                        setImage(uri);
                    }
                    break;
                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        setImage(uri);
                    }
                    break;
                case STORE_LOCATION_RESULT:
                    Bundle bundle = data.getExtras();
                    etAddress.setText(bundle.getString(Constant.ADDRESS));
                    etLat.setText(String.valueOf(bundle.getDouble(Constant.LATITUDE)));
                    etLng.setText(String.valueOf(bundle.getDouble(Constant.LONGITUDE)));
                    break;
                default:
                    break;
            }
        }
    }

    private void setImage(final Uri uri) {
        currentPhotoPath = ImageHelper.getFromMediaUriPfd(activity, activity.getContentResolver(), uri).getPath();
        new ImageCompression(activity).setImageCompressionListener(compressionImagePath -> {
            currentPhotoPath = compressionImagePath;
            GlideApp.with(activity).load(uri).error(R.drawable.icon_default_profile).into(ivProfile);
        }).execute(currentPhotoPath);
        Utilities.closeKeyboard(activity, getView());
    }

    private void openAccountVerifyDialog(HashMap<String, Object> map) {
        if (accountVerifyDialog != null && accountVerifyDialog.isShowing()) {
            return;
        }
        final int otpType = activity.checkWitchOtpValidationON();

        if (otpType != -1) {
            String message = null;

            switch (otpType) {
                case Constant.EMAIL_VERIFICATION_ON:
                    message = getString(R.string.text_verify_email);
                    break;
                case Constant.SMS_VERIFICATION_ON:
                    message = getString(R.string.text_verify_sms);
                    break;
                case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                    message = getString(R.string.text_verify_email_sms);
                    break;
                default:
                    break;
            }
            accountVerifyDialog = new CustomEditTextDialog(activity, false, getString(R.string.text_verify_details), message, getString(R.string.text_ok), otpType, map) {
                @Override
                public void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmailOtp) {
                    if (btnId == R.id.btnPositive) {
                        switch (otpType) {
                            case Constant.SMS_AND_EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else if (TextUtils.isEmpty(etEmailOtp.getText())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString(), etSMSOtp.getText().toString(), otpId);
                                }
                                break;
                            case Constant.SMS_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etSMSOtp.getText())) {
                                    etSMSOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(null, etSMSOtp.getText().toString(), otpId);
                                }
                                break;
                            case Constant.EMAIL_VERIFICATION_ON:
                                if (TextUtils.isEmpty(etEmailOtp.getText())) {
                                    etEmailOtp.setError(getString(R.string.msg_invalid_data));
                                } else {
                                    verifyStoreOtp(etEmailOtp.getText().toString(), null, otpId);
                                }
                                break;
                        }
                    } else {
                        dismiss();
                    }
                }

                @Override
                public void resetOtpId(String otpId) {
                    RegisterFragment.this.otpId = otpId;
                }
            };
            accountVerifyDialog.setCancelable(false);
            accountVerifyDialog.show();
        }
    }

    @Override
    public void onLocationChanged(Location location) {

    }

    /**
     * this method call a webservice for get country list
     */
    private void getCountryList() {
        if (categoryList == null) {
            Call<CountriesResponse> countriesCall = ApiClient.getClient().create(ApiInterface.class).getCountries();
            countriesCall.enqueue(new Callback<CountriesResponse>() {
                @Override
                public void onResponse(@NonNull Call<CountriesResponse> call, @NonNull Response<CountriesResponse> response) {
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            countryList = response.body().getCountries();
                            locationHelper.setLocationSettingRequest(activity, REQUEST_CHECK_SETTINGS, o -> locationHelper.getLastLocation(location -> {
                                if (location != null) {
                                    new GetCityAsyncTask(location.getLatitude(), location.getLongitude()).execute();
                                } else {
                                    setCountry(countryList.get(0));
                                }
                            }), () -> {
                            });
                        } else {
                            ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    } else {
                        Utilities.showHttpErrorToast(response.code(), activity);
                    }
                }

                @Override
                public void onFailure(@NonNull Call<CountriesResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });
        }
    }

    /**
     * this method call webservice fro get Delivery type Category list
     *
     * @param cityId selected cityId
     */
    private void getCategoryList(String cityId) {
        Utilities.showProgressDialog(activity);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.CITY_ID, cityId);
        Call<CategoriesResponse> deliveriesCall = ApiClient.getClient().create(ApiInterface.class).getCategories(map);
        deliveriesCall.enqueue(new Callback<CategoriesResponse>() {
            @Override
            public void onResponse(@NonNull Call<CategoriesResponse> call, @NonNull Response<CategoriesResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        categoryList = response.body().getCategories();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), activity);
                }
            }

            @Override
            public void onFailure(@NonNull Call<CategoriesResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void setCountry(Object object) {
        Country country = (Country) object;
        if (!TextUtils.equals(countryId, country.getId())) {
            countryId = country.getId();
            countryCode = country.getCountryPhoneCode();
            cCode = country.getCountryCode();
            tvCountryCode.setText(countryCode);
            tvCountry.setText(country.getCountryName());
            tvCity.setText(activity.getResources().getString(R.string.text_select_city));
            tvCategory.setText(activity.getResources().getString(R.string.text_select_category));
            getCityList(countryId);
            etMobileNo.getText().clear();
            tvCategory.setText(activity.getResources().getString(R.string.text_select_category));
            etReferralCode.setEnabled(true);
            etReferralCode.getText().clear();
            ivSuccess.setVisibility(View.GONE);
            cityId = null;
            if (activity.preferenceHelper.getIsReferralOn() && country.isReferralStore()) {
                llReferral.setVisibility(View.VISIBLE);
            } else {
                llReferral.setVisibility(View.GONE);
            }
        }
    }

    private void checkCountryCode(String country) {
        int countryListSize = countryList.size();
        for (int i = 0; i < countryListSize; i++) {
            if (countryList.get(i).getCountryName().toUpperCase().startsWith(country.toUpperCase())) {
                setCountry(countryList.get(i));
                return;
            }
        }
        setCountry(countryList.get(0));
    }

    public void clearError() {
        if (etName != null) {
            etName.setError(null);
            etEmail.setError(null);
            etPassword.setError(null);
            etAddress.setError(null);
            etMobileNo.setError(null);
            etSlogan.setError(null);
            etWebsite.setError(null);
            etLat.setError(null);
            etLng.setError(null);
        }
    }

    /**
     * this method call a webservice for check referral code enter by user
     */
    private void checkReferralCode() {
        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.REFERRAL_CODE, etReferralCode.getText().toString().trim());
        map.put(Constant.COUNTRY_ID, countryId);
        map.put(Constant.TYPE, Constant.Type.STORE);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.getCheckReferral(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (activity.parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        tvReferralApply.setVisibility(View.GONE);
                        ivSuccess.setVisibility(View.VISIBLE);
                        etReferralCode.setEnabled(false);
                        referralCode = etReferralCode.getText().toString();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
                        etReferralCode.getText().clear();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.printLog(RegisterFragment.class.getName(), t + "");
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void updateUiForSocialLogin(String email, String socialId, String firstName, String lastName, Uri profileUri) {
        if (!TextUtils.isEmpty(email)) {
            etEmail.setText(email);
            etEmail.setEnabled(false);
            etEmail.setFocusableInTouchMode(false);
            activity.preferenceHelper.putIsEmailVerified(true);
        }
        this.socialId = socialId;
        etName.setText(String.format("%s %s", firstName, lastName));
        uri = profileUri;
        etPassword.setVisibility(View.GONE);
        tilPassword.setVisibility(View.GONE);

        if (uri != null) {
            Utilities.showCustomProgressDialog(activity, false);
            GlideApp.with(activity.getApplicationContext())
                    .asBitmap()
                    .load(uri.toString())
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .listener(new RequestListener<Bitmap>() {
                        @Override
                        public boolean onLoadFailed(GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                            Utilities.handleException(getClass().getSimpleName(), e);
                            Utilities.showToast(activity, e.getMessage());
                            Utilities.hideCustomProgressDialog();
                            return true;
                        }

                        @Override
                        public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                            currentPhotoPath = getImageFile(resource).getPath();
                            ivProfile.setImageBitmap(resource);
                            Utilities.hideCustomProgressDialog();
                            return true;
                        }
                    }).into(ivProfile);
        }
    }

    private File getImageFile(Bitmap bitmap) {
        File imageFile = new File(activity.getFilesDir(), "name.jpg");
        OutputStream os;
        try {
            os = new FileOutputStream(imageFile);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
            os.flush();
            os.close();
        } catch (Exception e) {
            Utilities.handleException(getClass().getSimpleName(), e);
        }
        return imageFile;
    }

    private void checkSocialLoginISOn(boolean isSocialLogin) {
        if (isSocialLogin) {
            llSocialLogin.setVisibility(View.VISIBLE);
        } else {
            llSocialLogin.setVisibility(View.GONE);
        }
    }

    private void setStoreAddressORLocation() {
        Intent intent = new Intent(activity, StoreLocationActivity.class);
        startActivityForResult(intent, Constant.STORE_LOCATION_RESULT);
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(activity, title, saveDetails, detailMap, true);
        addDetailInMultiLanguageDialog.show();
    }

    /**
     * this class will help to get current city or county according current location
     */
    @SuppressLint("StaticFieldLeak")
    private class GetCityAsyncTask extends AsyncTask<String, Void, Address> {

        double lat, lng;

        public GetCityAsyncTask(double lat, double lng) {
            this.lat = lat;
            this.lng = lng;
        }

        @Override
        protected Address doInBackground(String... params) {
            Geocoder geocoder = new Geocoder(activity, new Locale("en_US"));
            try {
                List<Address> addressList = geocoder.getFromLocation(lat, lng, 1);
                if (addressList != null && !addressList.isEmpty()) {
                    return addressList.get(0);
                }

            } catch (IOException e) {
                publishProgress();
            }

            return null;
        }

        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);
            setCountry(countryList.get(0));
        }

        @Override
        protected void onPostExecute(Address address) {
            String countryName;
            if (address != null) {
                countryName = address.getCountryName();
                checkCountryCode(countryName);
            }
        }
    }
}