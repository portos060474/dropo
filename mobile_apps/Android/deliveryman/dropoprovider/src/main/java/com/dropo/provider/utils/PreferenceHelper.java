package com.dropo.provider.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.dropo.provider.BuildConfig;
import com.dropo.provider.parser.ApiClient;
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
    private final String IS_SMS_VERIFICATION = "is_sms_verification";
    private final String IS_MAIL_VERIFICATION = "is_mail_verification";
    private final String IS_UPLOAD_DOCUMENTS = "is_upload_documents";
    private final String IS_HIDE_OPTIONAL_FIELD_IN_REGISTER = "is_hide_optional_field_in_register";
    private final String PROVIDER_ID = "provider_id";
    private final String SESSION_TOKEN = "session_token";
    private final String FIRST_NAME = "first_name";
    private final String LAST_NAME = "last_name";
    private final String ADDRESS = "address";
    private final String ZIP_CODE = "zip_code";
    private final String PROFILE_PIC = "profile_pic";
    private final String PHONE_NUMBER = "phone_number";
    private final String PHONE_COUNTRY_CODE = "phone_country_code";
    private final String EMAIL = "email";
    private final String IS_ACTIVE_FOR_JOB = "is_active_for_job";
    private final String IS_PROVIDER_ONLINE = "is_provider_online";
    private final String IS_NEW_ORDER_SOUND_ON = "is_new_order_sound_on";
    private final String IS_APPROVED = "is_approved";
    private final String IS_LOGIN_BY_EMAIL = "is_login_by_email";
    private final String IS_LOGIN_BY_PHONE = "is_login_by_phone";
    private final String IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    private final String IS_MAIL_VERIFIED = "is_mail_verified";
    private final String IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
    private final String ADMIN_EMAIL = "admin_email";
    private final String MAX_LENGTH = "max_length";
    private final String MIN_LENGTH = "min_length";
    private final String IS_REFERRAL_ON = "is_referral_on";
    private final String REFERRAL = "referral";
    private final String SOCIAL_ID = "social_id";
    private final String IS_LOGIN_BY_SOCIAL = "is_login_by_social";
    private final String ADMIN_CONTACT = "admin_contact";
    private final String T_AND_C = "t_and_c";
    private final String POLICY = "policy";
    private final String CITY_ID = "city_id";
    private final String IS_VEHICLE_UPLOAD_DOCUMENTS = "is_vehicle_upload_documents";
    private final String SELECTED_VEHICLE_ID = "selected_vehicle_id";
    private final String UNIQUE_ID = "unique_id";
    private final String LANGUAGE_CODE = "language_code";
    private final String LANGUAGE_INDEX = "language_index";
    private final String HOME_SCREEN = "home_screen";
    private final String THEME = "theme";
    private final String PROVIDER_TYPE = "provider_type";
    private final String FIREBASE_USER_TOKEN = "firebase_provider_token";
    private final String IS_PROFILE_MANDATORY = "is_profile_mandatory";
    private final String MINIMUM_PHONE_NUMBER_LENGTH = "minimum_phone_number_length";
    private final String MAXIMUM_PHONE_NUMBER_LENGTH = "maximum_phone_number_length";

    private final String BASE_URL = "base_url";
    private final String USER_PANEL_URL = "user_panel_url";
    private final String IMAGE_URL = "image_url";

    private final String IS_ENABLE_TWILIO_CALL_MASKING = "is_enable_twilio_call_masking";

    private PreferenceHelper() {
    }

    public static PreferenceHelper getInstance(Context context) {
        app_preferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE);
        return preferenceHelper;
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


    public void putIsProviderAllDocumentsUpload(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_UPLOAD_DOCUMENTS, isRequired);
        editor.apply();
    }

    public boolean getIsProviderAllDocumentsUpload() {
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
        return app_preferences.getString(SESSION_TOKEN, null);

    }

    public void putProviderId(String userId) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PROVIDER_ID, userId);
        edit.apply();
    }

    public String getProviderId() {
        return app_preferences.getString(PROVIDER_ID, null);
    }

    public void putFirstName(String firstName) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(FIRST_NAME, firstName);
        edit.apply();
    }

    public String getFirstName() {
        return app_preferences.getString(FIRST_NAME, null);

    }

    public void putLastName(String lastName) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(LAST_NAME, lastName);
        edit.apply();
    }

    public String getLastName() {
        return app_preferences.getString(LAST_NAME, null);

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

    public String getZipCode() {
        return app_preferences.getString(ZIP_CODE, null);
    }

    public void putPhoneCountyCode(String phoneCountryCode) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PHONE_COUNTRY_CODE, phoneCountryCode);
        edit.apply();
    }

    public String getPhoneCountyCode() {
        return app_preferences.getString(PHONE_COUNTRY_CODE, null);
    }

    public void putPhoneNumber(String phoneNumber) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(PHONE_NUMBER, phoneNumber);
        edit.apply();
    }

    public String getPhoneNumber() {
        return app_preferences.getString(PHONE_NUMBER, null);

    }

    public void putEmail(String providerEmail) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(EMAIL, providerEmail);
        edit.apply();
    }

    public String getEmail() {
        return app_preferences.getString(EMAIL, null);

    }

    public void putIsProviderOnline(boolean isProviderOnline) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_PROVIDER_ONLINE, isProviderOnline);
        edit.apply();
    }

    public boolean getIsProviderOnline() {
        return app_preferences.getBoolean(IS_PROVIDER_ONLINE, false);
    }

    public void putIsProviderActiveForJob(boolean isActiveForJob) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_ACTIVE_FOR_JOB, isActiveForJob);
        edit.apply();
    }

    public boolean getIsProviderActiveForJob() {
        return app_preferences.getBoolean(IS_ACTIVE_FOR_JOB, false);
    }


    public void putIsNewOrderSoundOn(boolean isSoundOn) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_NEW_ORDER_SOUND_ON, isSoundOn);
        edit.apply();

    }

    public boolean getIsNewOrderSoundOn() {
        return app_preferences.getBoolean(IS_NEW_ORDER_SOUND_ON, true);
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

    public void putAdminContactEmail(String email) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(ADMIN_EMAIL, email);
        edit.apply();
    }

    public String getAdminContactEmail() {
        return app_preferences.getString(ADMIN_EMAIL, null);

    }

    public void putMaxPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(MAX_LENGTH, length);
        editor.apply();
    }

    public int getMaxPhoneNumberLength() {
        return app_preferences.getInt(MAX_LENGTH, 10);
    }

    public void putMinPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(MIN_LENGTH, length);
        editor.apply();
    }

    public int getMinPhoneNumberLength() {
        return app_preferences.getInt(MIN_LENGTH, 9);
    }

    public void putIsReferralOn(boolean isReferralOn) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_REFERRAL_ON, isReferralOn);
        edit.apply();
    }

    public boolean getIsReferralOn() {
        return app_preferences.getBoolean(IS_REFERRAL_ON, false);
    }

    public void putReferral(String referral) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(REFERRAL, referral);
        edit.apply();
    }

    public String getReferral() {
        return app_preferences.getString(REFERRAL, null);

    }

    public void putSocialId(String id) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(SOCIAL_ID, id);
        edit.apply();
    }

    public String getSocialId() {
        return app_preferences.getString(SOCIAL_ID, "");

    }

    public void putIsLoginBySocial(boolean isLogin) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_LOGIN_BY_SOCIAL, isLogin);
        editor.apply();
    }

    public boolean getIsLoginBySocial() {
        return app_preferences.getBoolean(IS_LOGIN_BY_SOCIAL, false);
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

    public void putCityId(String cityId) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(CITY_ID, cityId);
        edit.apply();
    }

    public String getCityId() {
        return app_preferences.getString(CITY_ID, null);

    }


    public void putIsProviderAllVehicleDocumentsUpload(boolean isRequired) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putBoolean(IS_VEHICLE_UPLOAD_DOCUMENTS, isRequired);
        editor.apply();
    }

    public boolean getIsProviderAllVehicleDocumentsUpload() {
        return app_preferences.getBoolean(IS_VEHICLE_UPLOAD_DOCUMENTS, false);
    }

    public void putSelectedVehicleId(String contact) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(SELECTED_VEHICLE_ID, contact);
        edit.apply();
    }

    public String getSelectedVehicleId() {
        return app_preferences.getString(SELECTED_VEHICLE_ID, "");

    }

    public void putUniqueId(int id) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putInt(UNIQUE_ID, id);
        edit.apply();
    }

    public int getUniqueId() {
        return app_preferences.getInt(UNIQUE_ID, 0);
    }

    public void putLanguageCode(String languageCode) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(LANGUAGE_CODE, languageCode);
        edit.apply();
        ApiClient.setLanguageCode(languageCode);
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

    public void clearVerification() {
        putIsEmailVerified(false);
        putIsPhoneNumberVerified(false);
    }

    public void logout() {
        if (preferenceHelper.getProviderId() != null && !preferenceHelper.getProviderId().equals("")) {
            FirebaseMessaging.getInstance().unsubscribeFromTopic(preferenceHelper.getProviderId());
        }
        putSessionToken(null);
        putProviderId("");
        ApiClient.setLoginDetail("", "");
    }

    public void putIsHomeScreenVisible(boolean isVisible) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(HOME_SCREEN, isVisible);
        edit.apply();
    }

    public boolean getIsHomeScreenVisible() {
        return app_preferences.getBoolean(HOME_SCREEN, false);
    }

    public void putTheme(int theme) {
        SharedPreferences.Editor editor = app_preferences.edit();
        editor.putInt(THEME, theme);
        editor.apply();
    }

    public int getTheme() {
        return app_preferences.getInt(THEME, AppColor.DEVICE_DEFAULT);
    }

    public void putProviderType(int providerType) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putInt(PROVIDER_TYPE, providerType);
        edit.apply();
    }

    public int getProviderType() {
        return app_preferences.getInt(PROVIDER_TYPE, 1);
    }

    public void putFireBaseUserToken(String firebaseUserToken) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(FIREBASE_USER_TOKEN, firebaseUserToken);
        edit.apply();
    }

    public String getFireBaseUserToken() {
        return app_preferences.getString(FIREBASE_USER_TOKEN, null);
    }

    public void putIsProfilePictureRequired(boolean isReferralOn) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_PROFILE_MANDATORY, isReferralOn);
        edit.apply();
    }

    public boolean getIsProfilePictureRequired() {
        return app_preferences.getBoolean(IS_PROFILE_MANDATORY, false);
    }

    public void putBaseUrl(String baseUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(BASE_URL,baseUrl);
        edit.apply();
    }

    public String getBaseUrl() {
        return app_preferences.getString(BASE_URL, BuildConfig.BASE_URL);
    }

    public void putUserPanelUrl(String userPanelUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(USER_PANEL_URL,userPanelUrl);
        edit.apply();
    }

    public String getUserPanelUrl() {
        return app_preferences.getString(USER_PANEL_URL, BuildConfig.USER_PANEL_URL);
    }

    public void putImageUrl(String imageUrl) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putString(IMAGE_URL,imageUrl);
        edit.apply();
    }

    public String getImageUrl() {
        return app_preferences.getString(IMAGE_URL, BuildConfig.IMAGE_URL);
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

    public void putIsEnableTwilioCallMasking(Boolean isEnableTwilioCallMasking) {
        SharedPreferences.Editor edit = app_preferences.edit();
        edit.putBoolean(IS_ENABLE_TWILIO_CALL_MASKING, isEnableTwilioCallMasking);
        edit.apply();
    }

    public Boolean getIsEnableTwilioCallMasking() {
        return app_preferences.getBoolean(IS_ENABLE_TWILIO_CALL_MASKING, false);
    }
}