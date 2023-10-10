package com.dropo.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.dropo.user.BuildConfig;
import com.dropo.parser.ApiClient;
import com.dropo.user.BuildConfig;
import com.google.firebase.messaging.FirebaseMessaging;

public class PreferenceHelper {

    /**
     * Preference Const
     */
    private static final String PREF_NAME = "EDelivery";
    private static final PreferenceHelper preferenceHelper = new PreferenceHelper();
    private static SharedPreferences app_preferences;
    private final String DEVICE_TOKEN = "device_token";
    private final String GOOGLE_KEY = "google_key";
    private final String IS_PROFILE_PICTURE_REQUIRED = "is_profile_picture_required";
    private final String IS_SMS_VERIFICATION = "is_sms_verification";
    private final String IS_MAIL_VERIFICATION = "is_mail_verification";
    private final String IS_UPLOAD_DOCUMENTS = "is_upload_documents";
    private final String IS_HIDE_OPTIONAL_FIELD_IN_REGISTER = "is_hide_optional_field_in_register";
    private final String USER_ID = "user_id";
    private final String SESSION_TOKEN = "session_token";
    private final String FIRST_NAME = "first_name";
    private final String LAST_NAME = "last_name";
    private final String BIO = "bio";
    private final String ADDRESS = "address";
    private final String ZIP_CODE = "zip_code";
    private final String PROFILE_PIC = "profile_pic";
    private final String PHONE_NUMBER = "phone_number";
    private final String PHONE_COUNTRY_CODE = "phone_country_code";
    private final String EMAIL = "email";
    private final String COUNTRY = "country";
    private final String IS_PUSH_SOUND_ON = "is_push_sound_on";
    private final String IS_IN_APPLICATION = "is_in_application";
    private final String IS_APPROVED = "is_approved";
    private final String IS_LOGIN_BY_EMAIL = "is_login_by_email";
    private final String IS_LOGIN_BY_PHONE = "is_login_by_phone";
    private final String REFERRAL = "referral";
    private final String IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    private final String IS_MAIL_VERIFIED = "is_mail_verified";
    private final String IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
    private final String ADMIN_EMAIL = "admin_email";
    private final String MINIMUM_PHONE_NUMBER_LENGTH = "minimum_phone_number_length";
    private final String MAXIMUM_PHONE_NUMBER_LENGTH = "maximum_phone_number_length";
    private final String LANGUAGE_CODE = "language_code";
    private final String LANGUAGE_INDEX = "language_index";
    private final String IS_REFERRAL_ON = "is_referral_on";
    private final String WALLET_AMOUNT = "wallet_amount";
    private final String SOCIAL_ID = "social_id";
    private final String IS_LOGIN_BY_SOCIAL = "is_login_by_social";
    private final String ANDROID_ID = "android_id";
    private final String IS_WELCOME = "is_welcome";

    private final String ADMIN_CONTACT = "admin_contact";
    private final String T_AND_C = "t_and_c";
    private final String POLICY = "policy";
    private final String IS_LOAD_STORE_IMAGE = "is_load_store_image";
    private final String IS_LOAD_PRODUCT_IMAGE = "is_load_product_image";
    private final String COUNTRY_CODE_ISO2 = "country_code_iso2";
    private final String PREVIOUS_SAVE_LATITUDE = "previous_save_latitude";
    private final String PREVIOUS_SAVE_LONGITUDE = "previous_save_longitude";
    private final String COUNTRY_CODE = "country_code";
    private final String THEME = "theme";
    private final String FIREBASE_USER_TOKEN = "firebase_user_token";
    private final String IS_ALLOW_BRING_CHANGE_OPTION = "is_allow_bring_change_option";
    private final String IS_FROM_QR_CODE = "is_from_qr_code";
    private final String IS_REGISTER_QR_USER = "is_register_qr_user";
    private final String IS_ENABLE_TWILIO_CALL_MASKING = "is_enable_twilio_call_masking";
    private final String MAX_COURIER_STOP_LIMIT = "max_courier_stop_limit";

    private final String BASE_URL = "base_url";
    private final String USER_PANEL_URL = "user_panel_url";
    private final String IMAGE_URL = "image_url";

    private PreferenceHelper() {
    }

    public static PreferenceHelper getInstance(Context context) {
        app_preferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return preferenceHelper;
    }

    public void putCountryCode(String code) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(COUNTRY_CODE, code);
        edit.apply();
    }

    public String getCountryCode() {
        return app_preferences.getString(COUNTRY_CODE, "");
    }

    public void putDeviceToken(String deviceToken) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putString(DEVICE_TOKEN, deviceToken);
        editor.apply();
    }

    public String getDeviceToken() {
        return app_preferences.getString(DEVICE_TOKEN, null);
    }

    public void putGoogleKey(String key) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putString(GOOGLE_KEY, key.trim());
        editor.apply();
    }

    public String getGoogleKey() {
        return app_preferences.getString(GOOGLE_KEY, null);
    }

    public void putIsProfilePictureRequired(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_PROFILE_PICTURE_REQUIRED, isRequired);
        editor.apply();
    }

    public boolean getIsProfilePictureRequired() {
        return app_preferences.getBoolean(IS_PROFILE_PICTURE_REQUIRED, false);
    }

    public void putIsSmsVerification(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_SMS_VERIFICATION, isRequired);
        editor.apply();
    }

    public boolean getIsSmsVerification() {
        return app_preferences.getBoolean(IS_SMS_VERIFICATION, false);
    }

    public void putIsMailVerification(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_MAIL_VERIFICATION, isRequired);
        editor.apply();
    }

    public boolean getIsMailVerification() {
        return app_preferences.getBoolean(IS_MAIL_VERIFICATION, false);
    }

    public void putIsEmailVerified(boolean isVerified) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_MAIL_VERIFIED, isVerified);
        editor.apply();
    }

    public boolean getIsEmailVerified() {
        return app_preferences.getBoolean(IS_MAIL_VERIFIED, false);
    }

    public void putIsPhoneNumberVerified(boolean isVerified) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_PHONE_NUMBER_VERIFIED, isVerified);
        editor.apply();
    }

    public boolean getIsPhoneNumberVerified() {
        return app_preferences.getBoolean(IS_PHONE_NUMBER_VERIFIED, false);
    }

    public void putIsUserAllDocumentsUpload(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_UPLOAD_DOCUMENTS, isRequired);
        editor.apply();
    }

    public boolean getIsUserAllDocumentsUpload() {
        return app_preferences.getBoolean(IS_UPLOAD_DOCUMENTS, false);
    }

    public void putIsShowOptionalFieldInRegister(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_HIDE_OPTIONAL_FIELD_IN_REGISTER, isRequired);
        editor.apply();
    }

    public boolean getIsShowOptionalFieldInRegister() {
        return app_preferences.getBoolean(IS_HIDE_OPTIONAL_FIELD_IN_REGISTER, false);
    }

    public void putSessionToken(String sessionToken) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(SESSION_TOKEN, sessionToken);
        edit.apply();
    }

    public String getSessionToken() {
        return app_preferences.getString(SESSION_TOKEN, "");
    }

    public void putUserId(String userId) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(USER_ID, userId);
        edit.apply();
    }

    public String getUserId() {
        return app_preferences.getString(USER_ID, "");
    }

    public void putFirstName(String firstName) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(FIRST_NAME, firstName);
        edit.apply();
    }

    public String getFirstName() {
        return app_preferences.getString(FIRST_NAME, "");
    }

    public void putLastName(String lastName) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(LAST_NAME, lastName);
        edit.apply();
    }

    public String getLastName() {
        return app_preferences.getString(LAST_NAME, "");
    }

    public void putProfilePic(String profilePic) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PROFILE_PIC, profilePic);
        edit.apply();
    }

    public String getProfilePic() {
        return app_preferences.getString(PROFILE_PIC, null);
    }

    public void putAddress(String address) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ADDRESS, address);
        edit.apply();
    }

    public String getAddress() {
        return app_preferences.getString(ADDRESS, null);
    }

    public void putZipCode(String zipCode) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ZIP_CODE, zipCode);
        edit.apply();
    }

    public void putCountryPhoneCode(String phoneCountryCode) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PHONE_COUNTRY_CODE, phoneCountryCode);
        edit.apply();
    }

    public String getCountryPhoneCode() {
        return app_preferences.getString(PHONE_COUNTRY_CODE, "");
    }

    public void putPhoneNumber(String phoneNumber) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PHONE_NUMBER, phoneNumber);
        edit.apply();
    }

    public String getPhoneNumber() {
        return app_preferences.getString(PHONE_NUMBER, "");
    }

    public void putEmail(String userEmail) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(EMAIL, userEmail);
        edit.apply();
    }

    public String getEmail() {
        return app_preferences.getString(EMAIL, "");
    }

    public void putReferral(String referral) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(REFERRAL, referral);
        edit.apply();
    }

    public String getReferral() {
        return app_preferences.getString(REFERRAL, null);
    }

    public void putIsPushNotificationSoundOn(boolean isSoundOn) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_PUSH_SOUND_ON, isSoundOn);
        edit.apply();
    }

    public boolean getIsPushNotificationSoundOn() {
        return app_preferences.getBoolean(IS_PUSH_SOUND_ON, true);
    }

    public void putIsReferralOn(boolean isReferralOn) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_REFERRAL_ON, isReferralOn);
        edit.apply();
    }

    public boolean getIsReferralOn() {
        return app_preferences.getBoolean(IS_REFERRAL_ON, false);
    }

    public void putIsApproved(boolean is_approved) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_APPROVED, is_approved);
        edit.apply();
    }

    public boolean getIsApproved() {
        return app_preferences.getBoolean(IS_APPROVED, false);
    }

    public void putIsLoginByEmail(boolean isLoginEmail) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOGIN_BY_EMAIL, isLoginEmail);
        editor.apply();
    }

    public boolean getIsLoginByEmail() {
        return app_preferences.getBoolean(IS_LOGIN_BY_EMAIL, false);
    }

    public void putIsLoginByPhone(boolean isLoginPhone) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOGIN_BY_PHONE, isLoginPhone);
        editor.apply();
    }

    public boolean getIsLoginByPhone() {
        return app_preferences.getBoolean(IS_LOGIN_BY_PHONE, false);
    }

    public void putIsAdminDocumentMandatory(boolean isUpload) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_ADMIN_DOCUMENT_MANDATORY, isUpload);
        editor.apply();
    }

    public boolean getIsAdminDocumentMandatory() {
        return app_preferences.getBoolean(IS_ADMIN_DOCUMENT_MANDATORY, false);
    }

    public void putAdminContactEmail(String email) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ADMIN_EMAIL, email);
        edit.apply();
    }

    public String getAdminContactEmail() {
        return app_preferences.getString(ADMIN_EMAIL, null);
    }

    public void putMinimumPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(MINIMUM_PHONE_NUMBER_LENGTH, length);
        editor.apply();
    }

    public int getMinimumPhoneNumberLength() {
        return app_preferences.getInt(MINIMUM_PHONE_NUMBER_LENGTH, Const.PhoneNumber.MINIMUM_PHONE_NUMBER_LENGTH);
    }

    public void putMaximumPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(MAXIMUM_PHONE_NUMBER_LENGTH, length);
        editor.apply();
    }

    public int getMaximumPhoneNumberLength() {
        return app_preferences.getInt(MAXIMUM_PHONE_NUMBER_LENGTH, Const.PhoneNumber.MAXIMUM_PHONE_NUMBER_LENGTH);
    }

    public void putLanguageCode(String code) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(LANGUAGE_CODE, code);
        edit.apply();
        ApiClient.setLanguageCode(code);
    }

    public String getLanguageCode() {
        return app_preferences.getString(LANGUAGE_CODE, "en");
    }

    public void putLanguageIndex(int index) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putInt(LANGUAGE_INDEX, index);
        edit.apply();
        ApiClient.setLanguage(index);
    }

    public int getLanguageIndex() {
        return app_preferences.getInt(LANGUAGE_INDEX, 0);
    }

    public void putCountryId(String id) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(COUNTRY, id);
        edit.apply();
    }

    public String getCountryId() {
        return app_preferences.getString(COUNTRY, "en");
    }

    public void putWalletAmount(float amount) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putFloat(WALLET_AMOUNT, amount);
        edit.apply();
    }

    public float getWalletAmount() {
        return app_preferences.getFloat(WALLET_AMOUNT, 0);
    }

    public void putSocialId(String id) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(SOCIAL_ID, id);
        edit.apply();
    }

    public String getSocialId() {
        return app_preferences.getString(SOCIAL_ID, null);
    }

    public void putIsLoginBySocial(boolean isLogin) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOGIN_BY_SOCIAL, isLogin);
        editor.apply();
    }

    public boolean getIsLoginBySocial() {
        return app_preferences.getBoolean(IS_LOGIN_BY_SOCIAL, false);
    }

    public void putAndroidId(String id) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ANDROID_ID, id);
        edit.apply();
    }

    public String getAndroidId() {
        return app_preferences.getString(ANDROID_ID, "");
    }

    public void putIsHideWelcomeScreen(boolean isHide) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_WELCOME, isHide);
        editor.apply();
    }

    public boolean getIsHideWelcomeScreen() {
        return app_preferences.getBoolean(IS_WELCOME, false);
    }

    public void putAdminContact(String contact) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ADMIN_CONTACT, contact);
        edit.apply();
    }

    public String getAdminContact() {
        return app_preferences.getString(ADMIN_CONTACT, null);
    }

    public void putTermsANdConditions(String tandc) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(T_AND_C, tandc);
        edit.apply();
    }

    public String getTermsANdConditions() {
        return app_preferences.getString(T_AND_C, null);
    }

    public void putPolicy(String policy) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(POLICY, policy);
        edit.apply();
    }

    public String getPolicy() {
        return app_preferences.getString(POLICY, null);
    }

    public void putCountryCodeISO2(String code) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(COUNTRY_CODE_ISO2, code);
        edit.apply();
    }

    public String getCountryCodeISO2() {
        return app_preferences.getString(COUNTRY_CODE_ISO2, "US");
    }

    public void putIsLoadStoreImage(boolean isLoad) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOAD_STORE_IMAGE, isLoad);
        editor.apply();
    }

    public boolean getIsLoadStoreImage() {
        return app_preferences.getBoolean(IS_LOAD_STORE_IMAGE, true);
    }

    public void putIsLoadProductImage(boolean isLoad) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOAD_PRODUCT_IMAGE, isLoad);
        editor.apply();
    }

    public boolean getIsLoadProductImage() {
        return app_preferences.getBoolean(IS_LOAD_PRODUCT_IMAGE, true);
    }

    public void clearVerification() {
        putIsEmailVerified(false);
        putIsPhoneNumberVerified(false);
    }

    public void logout() {
        if (preferenceHelper.getUserId() != null && !preferenceHelper.getUserId().equals("")) {
            FirebaseMessaging.getInstance().unsubscribeFromTopic(preferenceHelper.getUserId());
        }
        putSessionToken(null);
        putUserId("");
        ApiClient.setLoginDetail("", "");
        putFirebaseUserToken("");
    }

    public void putPreviousSaveLatitude(String latitude) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PREVIOUS_SAVE_LATITUDE, latitude);
        edit.apply();
    }

    public String getPreviousSaveLatitude() {
        return app_preferences.getString(PREVIOUS_SAVE_LATITUDE, null);
    }

    public void putPreviousSaveLongitude(String longitude) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PREVIOUS_SAVE_LONGITUDE, longitude);
        edit.apply();
    }

    public String getPreviousSaveLongitude() {
        return app_preferences.getString(PREVIOUS_SAVE_LONGITUDE, null);
    }

    public void putTheme(int theme) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(THEME, theme);
        editor.apply();
    }

    public int getTheme() {
        return app_preferences.getInt(THEME, AppColor.DEVICE_DEFAULT);
    }

    public void putFirebaseUserToken(String firebaseUserToken) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(FIREBASE_USER_TOKEN, firebaseUserToken);
        edit.apply();
    }

    public String getFirebaseUserToken() {
        return app_preferences.getString(FIREBASE_USER_TOKEN, null);
    }

    public void putBaseUrl(String baseUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(BASE_URL, baseUrl);
        edit.apply();
    }

    public String getBaseUrl() {
        return app_preferences.getString(BASE_URL, BuildConfig.BASE_URL);
    }

    public void putUserPanelUrl(String userPanelUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(USER_PANEL_URL, userPanelUrl);
        edit.apply();
    }

    public String getUserPanelUrl() {
        return app_preferences.getString(USER_PANEL_URL, BuildConfig.USER_PANEL_URL);
    }

    public void putImageUrl(String imageUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(IMAGE_URL, imageUrl);
        edit.apply();
    }

    public String getImageUrl() {
        return app_preferences.getString(IMAGE_URL, BuildConfig.IMAGE_URL);
    }

    public void putIsAllowBringChangeOption(Boolean isAllowBringChangeOption) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_ALLOW_BRING_CHANGE_OPTION, isAllowBringChangeOption);
        edit.apply();
    }

    public Boolean getIsAllowBringChangeOption() {
        return app_preferences.getBoolean(IS_ALLOW_BRING_CHANGE_OPTION, false);
    }

    public void putIsFromQRCode(Boolean isFromQRCode) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_FROM_QR_CODE, isFromQRCode);
        edit.apply();
    }

    public Boolean getIsFromQRCode() {
        return app_preferences.getBoolean(IS_FROM_QR_CODE, false);
    }

    public void putIsRegisterQRUser(Boolean isRegisterQRUser) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_REGISTER_QR_USER, isRegisterQRUser);
        edit.apply();
    }

    public Boolean getIsRegisterQRUser() {
        return app_preferences.getBoolean(IS_REGISTER_QR_USER, false);
    }

    public void putIsEnableTwilioCallMasking(Boolean isEnableTwilioCallMasking) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_ENABLE_TWILIO_CALL_MASKING, isEnableTwilioCallMasking);
        edit.apply();
    }

    public Boolean getIsEnableTwilioCallMasking() {
        return app_preferences.getBoolean(IS_ENABLE_TWILIO_CALL_MASKING, false);
    }

    public void putMaxCourierStopLimit(int maxCourierStopLimit) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putInt(MAX_COURIER_STOP_LIMIT, maxCourierStopLimit);
        edit.apply();
    }

    public int getMaxCourierStopLimit() {
        return app_preferences.getInt(MAX_COURIER_STOP_LIMIT, 0);
    }
}