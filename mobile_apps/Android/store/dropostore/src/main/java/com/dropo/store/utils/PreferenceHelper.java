package com.dropo.store.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.dropo.store.BuildConfig;
import com.dropo.store.parse.ApiClient;


import com.google.firebase.messaging.FirebaseMessaging;

public class PreferenceHelper {
    private static PreferenceHelper preferenceHelper;
    private static SharedPreferences app_prefs;

    private static final String IS_HIDE_OPTIONAL_FIELD_IN_REGISTER = "isShowOptionalFieldInRegister";
    private static final String IS_FORCE_UPDATE = "isForceUpdate";
    private static final String CURRENCY = "currency";
    private static final String IS_VERIFY_EMAIL = "verify_email";
    private static final String IS_VERIFY_PHONE = "is_verify_phone";
    private static final String IS_LOGIN_BY_PHONE = "login_by_phone";
    private static final String IS_LOGIN_BY_EMAIL = "login_by_email";
    private static final String NAME = "name";
    private static final String PHONE = "phone";
    private static final String IS_APPROVED = "is_approved";
    private static final String IS_EMAIL_VERIFIED = "is_email_verified";
    private static final String IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
    private static final String ADMIN_CONTACT_EMAIL = "admin_contact_email";
    private static final String COUNTRY_PHONE_CODE = "country_phone_code";
    private static final String EMAIL = "email";
    private static final String LANGUAGE_CODE = "language_code";
    private final String IS_UPLOAD_DOCUMENTS = "is_upload_documents";
    private final String IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    private final String IS_REFERRAL_ON = "is_referral_on";
    private final String REFERRAL_CODE = "referral_code";
    private final String SOCIAL_ID = "social_id";
    private final String IS_LOGIN_BY_SOCIAL = "is_login_by_social";
    private final String IS_PUSH_SOUND_ON = "is_push_sound_on";
    private final String ADMIN_CONTACT = "admin_contact";
    private final String T_AND_C = "t_and_c";
    private final String POLICY = "policy";
    private final String IS_ASK_ESTIMATED_TIME = "is_ask_estimated_time";
    private final String ADDRESS = "address";
    private final String LAT = "lat";
    private final String LNG = "lng";
    private final String ANDROID_ID = "android_id";
    private final String CART_ID = "cartId";
    private final String IS_PROVIDE_PICKUP_DELIVERY = "is_provide_pickup_delivery";
    private final String STORE_TAX = "store_tax";
    private final String IS_USE_ITEM_TAX = "is_use_item_tax";
    private final String IS_TAX_INCLUDED = "is_tax_included";

    private final String IS_STORE_CAN_CREATE_GROUP = "is_store_can_create_group";
    private final String IS_STORE_CAN_EDIT_ORDER = "is_store_can_edit_order";
    private final String IS_STORE_CAN_ADD_PROVIDER = "is_store_can_add_provider";
    private final String IS_STORE_CAN_COMPLETE_ORDER = "is_store_can_complete_order";

    private final String IS_STORE_CREATE_ORDER = "is_store_create_order";
    private final String IS_STORE_EDIT_ITEM = "is_store_edit_item";
    private final String IS_STORE_ADD_PROMOCODE = "is_store_add_promocode";
    private final String IS_STORE_CAN_SET_CANCELLATION_CHARGE = "is_store_can_set_cancellation_charge";
    private final String PROFILE_PIC = "profile_pic";

    private final String SUB_STORE_ID = "sub_store_id";
    private final String THEME = "theme";
    private final String FIREBASE_USER_TOKEN = "firebaseUserToken";
    private final String IS_USE_CAPTCHA = "is_use_captcha";

    private final String BASE_URL = "base_url";
    private final String USER_PANEL_URL = "user_panel_url";
    private final String IMAGE_URL = "image_url";

    private final String MINIMUM_PHONE_NUMBER_LENGTH = "minimum_phone_number_length";
    private final String MAXIMUM_PHONE_NUMBER_LENGTH = "maximum_phone_number_length";

    private final String IS_ENABLE_TWILIO_CALL_MASKING = "is_enable_twilio_call_masking";

    private PreferenceHelper(Context context) {
        app_prefs = context.getSharedPreferences("Store", Context.MODE_PRIVATE);
    }

    public static PreferenceHelper getPreferenceHelper(Context context) {
        if (preferenceHelper == null) {
            preferenceHelper = new PreferenceHelper(context);
        }

        return preferenceHelper;
    }

    public void logout() {
        if (preferenceHelper.getStoreId() != null && !preferenceHelper.getStoreId().equals("")) {
            FirebaseMessaging.getInstance().unsubscribeFromTopic(preferenceHelper.getStoreId());
        }
        putServerToken(null);
        putStoreId("");
        putSubStoreId("");
        putFireBaseUserToken("");
    }

    public void putPhone(String phone) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(PHONE, phone);
        editor.apply();
    }

    public String getPhone() {
        return app_prefs.getString(PHONE, null);
    }

    public void putIsApproved(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_APPROVED, value);
        editor.apply();
    }

    public boolean isApproved() {
        return app_prefs.getBoolean(IS_APPROVED, false);
    }

    public void putIsPhoneNumberVerified(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_PHONE_NUMBER_VERIFIED, value);
        editor.apply();
    }

    public boolean isPhoneNumberVerified() {
        return app_prefs.getBoolean(IS_PHONE_NUMBER_VERIFIED, false);
    }

    public void putIsEmailVerified(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_EMAIL_VERIFIED, value);
        editor.apply();
    }

    public boolean isEmailVerified() {
        return app_prefs.getBoolean(IS_EMAIL_VERIFIED, false);
    }

    public void putName(String name) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(NAME, name);
        editor.apply();
    }

    public String getName() {
        return app_prefs.getString(NAME, null);
    }

    public void putEmail(String email) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(EMAIL, email);
        editor.apply();
    }

    public String getEmail() {
        return app_prefs.getString(EMAIL, null);
    }

    public void putCountryPhoneCode(String code) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(COUNTRY_PHONE_CODE, code);
        editor.apply();
    }

    public String getCountryPhoneCode() {
        return app_prefs.getString(COUNTRY_PHONE_CODE, null);
    }

    public void putDeviceToken(String deviceToken) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(Constant.DEVICE_TOKEN, deviceToken);
        editor.apply();
    }

    public String getDeviceToken() {
        return app_prefs.getString(Constant.DEVICE_TOKEN, null);
    }

    public void putGoogleKey(String googleKey) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(Constant.GOOGLE_KEY, googleKey);
        editor.apply();
    }

    public String getGoogleKey() {
        return app_prefs.getString(Constant.GOOGLE_KEY, null);
    }

    public void putAdminContactEmail(String email) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(ADMIN_CONTACT_EMAIL, email);
        editor.apply();
    }

    public String getAdminContactEmail() {
        return app_prefs.getString(ADMIN_CONTACT_EMAIL, null);
    }

    public void putIsVerifyEmail(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_VERIFY_EMAIL, value);
        editor.apply();
    }

    public boolean getIsVerifyEmail() {
        return app_prefs.getBoolean(IS_VERIFY_EMAIL, false);
    }

    public void putIsVerifyPhone(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_VERIFY_PHONE, value);
        editor.apply();
    }

    public boolean getIsVerifyPhone() {
        return app_prefs.getBoolean(IS_VERIFY_PHONE, false);
    }

    public void putIsLoginByPhone(boolean isLogin) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_LOGIN_BY_PHONE, isLogin);
        editor.apply();
    }

    public boolean getIsLoginByPhone() {
        return app_prefs.getBoolean(IS_LOGIN_BY_PHONE, false);
    }

    public void putIsLoginByEmail(boolean isLogin) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_LOGIN_BY_EMAIL, isLogin);
        editor.apply();
    }

    public boolean getIsLoginByEmail() {
        return app_prefs.getBoolean(IS_LOGIN_BY_EMAIL, false);
    }

    public void putStoreId(String userId) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(Constant.STORE_ID, userId);
        editor.apply();
        ApiClient.setStoreId(userId);
    }

    public String getStoreId() {
        return app_prefs.getString(Constant.STORE_ID, null);
    }

    public String getServerToken() {
        return app_prefs.getString(Constant.SERVER_TOKEN, null);
    }

    public void putServerToken(String serverToken) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(Constant.SERVER_TOKEN, serverToken);
        editor.apply();
        ApiClient.setServerToken(serverToken);
    }

    public void putShowOptionalFieldInRegister(boolean isHideOptionalFieldInRegister) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_HIDE_OPTIONAL_FIELD_IN_REGISTER, isHideOptionalFieldInRegister);
        editor.apply();
    }

    public boolean isShowOptionalFieldInRegister() {
        return app_prefs.getBoolean(IS_HIDE_OPTIONAL_FIELD_IN_REGISTER, false);
    }

    public void putForceUpdate(boolean isForceUpdate) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_FORCE_UPDATE, isForceUpdate);
        editor.apply();
    }

    public boolean isForceUpdate() {
        return app_prefs.getBoolean(IS_FORCE_UPDATE, false);
    }

    public void putCurrency(String currency) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(CURRENCY, currency);
        editor.apply();
    }

    public String getCurrency() {
        return app_prefs.getString(CURRENCY, null);
    }

    public void putIsUserAllDocumentsUpload(boolean isRequired) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_UPLOAD_DOCUMENTS, isRequired);
        editor.apply();
    }

    public boolean getIsUserAllDocumentsUpload() {
        return app_prefs.getBoolean(IS_UPLOAD_DOCUMENTS, false);
    }

    public void putIsAdminDocumentMandatory(boolean isUpload) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_ADMIN_DOCUMENT_MANDATORY, isUpload);
        editor.apply();
    }

    public boolean getIsAdminDocumentMandatory() {
        return app_prefs.getBoolean(IS_ADMIN_DOCUMENT_MANDATORY, false);
    }

    public void putLanguageCode(String code) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(LANGUAGE_CODE, code);
        edit.apply();
    }

    public String getLanguageCode() {
        return app_prefs.getString(LANGUAGE_CODE, "en");
    }

    public void putIsReferralOn(boolean isReferralOn) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_REFERRAL_ON, isReferralOn);
        edit.apply();
    }

    public boolean getIsReferralOn() {
        return app_prefs.getBoolean(IS_REFERRAL_ON, false);
    }

    public void putReferralCode(String code) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(REFERRAL_CODE, code);
        edit.apply();
    }

    public String getReferralCode() {
        return app_prefs.getString(REFERRAL_CODE, "--");
    }

    public void putSocialId(String id) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(SOCIAL_ID, id);
        edit.apply();
    }

    public String getSocialId() {
        return app_prefs.getString(SOCIAL_ID, "");
    }

    public void putIsLoginBySocial(boolean isLogin) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_LOGIN_BY_SOCIAL, isLogin);
        editor.apply();
    }

    public boolean getIsLoginBySocial() {
        return app_prefs.getBoolean(IS_LOGIN_BY_SOCIAL, false);
    }

    public boolean getIsPushNotificationSoundOn() {
        return app_prefs.getBoolean(IS_PUSH_SOUND_ON, true);
    }

    public void putIsPushNotificationSoundOn(boolean isSoundOn) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_PUSH_SOUND_ON, isSoundOn);
        edit.apply();
    }

    public void putAdminContact(String contact) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(ADMIN_CONTACT, contact);
        edit.apply();
    }

    public String getAdminContact() {
        return app_prefs.getString(ADMIN_CONTACT, null);
    }

    public void putTermsANdConditions(String tandc) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(T_AND_C, tandc);
        edit.apply();
    }

    public String getTermsANdConditions() {
        return app_prefs.getString(T_AND_C, null);
    }

    public void putPolicy(String policy) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(POLICY, policy);
        edit.apply();
    }

    public String getPolicy() {
        return app_prefs.getString(POLICY, null);
    }

    public void putIsAskForEstimatedTimeForOrderReady(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_ASK_ESTIMATED_TIME, value);
        editor.apply();
    }

    public boolean getIsAskForEstimatedTimeForOrderReady() {
        return app_prefs.getBoolean(IS_ASK_ESTIMATED_TIME, false);
    }

    public void putIsProvidePickupDelivery(boolean value) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_PROVIDE_PICKUP_DELIVERY, value);
        editor.apply();
    }

    public boolean getIsProvidePickupDelivery() {
        return app_prefs.getBoolean(IS_PROVIDE_PICKUP_DELIVERY, false);
    }

    public void putCityId(String cityId) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(Constant.CITY_ID, cityId);
        edit.apply();
    }

    public String getCityId() {
        return app_prefs.getString(Constant.CITY_ID, null);
    }

    public void putAddress(String address) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(ADDRESS, address);
        edit.apply();
    }

    public String getAddress() {
        return app_prefs.getString(ADDRESS, null);
    }

    public void putLatitude(String lat) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(LAT, lat);
        edit.apply();
    }

    public String getLatitude() {
        return app_prefs.getString(LAT, "0");

    }

    public void putLongitude(String lng) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(LNG, lng);
        edit.apply();
    }

    public String getLongitude() {
        return app_prefs.getString(LNG, "0");
    }

    public void putAndroidId(String id) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(ANDROID_ID, id);
        edit.apply();
    }

    public String getAndroidId() {
        return app_prefs.getString(ANDROID_ID, "");
    }

    public void putCartId(String id) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(CART_ID, id);
        edit.apply();
    }

    public String getCartId() {
        return app_prefs.getString(CART_ID, "");
    }

    public void clearVerification() {
        putIsEmailVerified(false);
        putIsPhoneNumberVerified(false);
    }

    public boolean getIsUseItemTax() {
        return app_prefs.getBoolean(IS_USE_ITEM_TAX, false);
    }

    public void putIsUseItemTax(boolean isUseItemTax) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_USE_ITEM_TAX, isUseItemTax);
        edit.apply();
    }

    public void putIsTaxIncluded(boolean isUseItemTax) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_TAX_INCLUDED, isUseItemTax);
        edit.apply();
    }

    public boolean getTaxIncluded() {
        return app_prefs.getBoolean(IS_TAX_INCLUDED, false);
    }

    public float getStoreTax() {
        return app_prefs.getFloat(STORE_TAX, 0f);
    }

    public void putStoreTax(float storeTax) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putFloat(STORE_TAX, storeTax);
        edit.apply();
    }

    public void putIsStoreCanCreateGroup(boolean isStoreCanCreateGroup) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CAN_CREATE_GROUP, isStoreCanCreateGroup);
        edit.apply();
    }

    public boolean getIsStoreCanCreateGroup() {
        return app_prefs.getBoolean(IS_STORE_CAN_CREATE_GROUP, false);
    }

    public void putIsStoreCanEditOrder(boolean isStoreCanEditOrder) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CAN_EDIT_ORDER, isStoreCanEditOrder);
        edit.apply();
    }

    public boolean getIsStoreCanEditOrder() {
        return app_prefs.getBoolean(IS_STORE_CAN_EDIT_ORDER, false);
    }

    public void putIsStoreCanAddProvider(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CAN_ADD_PROVIDER, isEnable);
        edit.apply();
    }

    public boolean getIsStoreCanAddProvider() {
        return app_prefs.getBoolean(IS_STORE_CAN_ADD_PROVIDER, false);
    }

    public void putIsStoreCanCompleteOrder(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CAN_COMPLETE_ORDER, isEnable);
        edit.apply();
    }

    public boolean getIsStoreCanCompleteOrder() {
        return app_prefs.getBoolean(IS_STORE_CAN_COMPLETE_ORDER, false);
    }

    public void putIsStoreCreateOrder(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CREATE_ORDER, isEnable);
        edit.apply();
    }

    public boolean getIsStoreCreateOrder() {
        return app_prefs.getBoolean(IS_STORE_CREATE_ORDER, false);
    }

    public void putIsStoreEditItem(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_EDIT_ITEM, isEnable);
        edit.apply();
    }

    public boolean getIsStoreEditItem() {
        return app_prefs.getBoolean(IS_STORE_EDIT_ITEM, false);
    }

    public void putIsStoreAddPromoCode(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_ADD_PROMOCODE, isEnable);
        edit.apply();
    }

    public boolean getIsStoreAddPromoCode() {
        return app_prefs.getBoolean(IS_STORE_ADD_PROMOCODE, false);
    }

    public void putIsStoreCanSetCancellationCharge(boolean isEnable) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_STORE_CAN_SET_CANCELLATION_CHARGE, isEnable);
        edit.apply();
    }

    public boolean getIsStoreCanSetCancellationCharge() {
        return app_prefs.getBoolean(IS_STORE_CAN_SET_CANCELLATION_CHARGE, false);
    }

    public void putProfilePic(String profilePic) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(PROFILE_PIC, profilePic);
        edit.apply();
    }

    public String getProfilePic() {
        return app_prefs.getString(PROFILE_PIC, null);
    }

    public void putSubStoreId(String subStoreId) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(SUB_STORE_ID, subStoreId);
        editor.apply();
        ApiClient.setSubStoreId(subStoreId);
    }

    public String getSubStoreId() {
        return app_prefs.getString(SUB_STORE_ID, "");
    }

    public void putTheme(int theme) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putInt(THEME, theme);
        editor.apply();
    }

    public int getTheme() {
        return app_prefs.getInt(THEME, AppColor.DEVICE_DEFAULT);
    }

    public void putFireBaseUserToken(String firebaseUserToken) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putString(FIREBASE_USER_TOKEN, firebaseUserToken);
        editor.apply();
    }

    public String getFireBaseUserToken() {
        return app_prefs.getString(FIREBASE_USER_TOKEN, null);
    }

    public void putIsUseCaptcha(boolean isUseCaptcha) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putBoolean(IS_USE_CAPTCHA, isUseCaptcha);
        editor.apply();
    }

    public boolean isUseCaptcha() {
        return app_prefs.getBoolean(IS_USE_CAPTCHA, false);
    }

    public void putBaseUrl(String baseUrl) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(BASE_URL, baseUrl);
        edit.apply();
    }

    public String getBaseUrl() {
        return app_prefs.getString(BASE_URL, BuildConfig.BASE_URL);
    }

    public void putUserPanelUrl(String userPanelUrl) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(USER_PANEL_URL, userPanelUrl);
        edit.apply();
    }

    public String getUserPanelUrl() {
        return app_prefs.getString(USER_PANEL_URL, BuildConfig.USER_PANEL_URL);
    }

    public void putImageUrl(String imageUrl) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putString(IMAGE_URL, imageUrl);
        edit.apply();
    }

    public String getImageUrl() {
        return app_prefs.getString(IMAGE_URL, BuildConfig.IMAGE_URL);
    }

    public void putMinimumPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putInt(MINIMUM_PHONE_NUMBER_LENGTH, length);
        editor.apply();
    }

    public int getMinimumPhoneNumberLength() {
        return app_prefs.getInt(MINIMUM_PHONE_NUMBER_LENGTH, Constant.PhoneNumber.MINIMUM_PHONE_NUMBER_LENGTH);
    }

    public void putMaximumPhoneNumberLength(int length) {
        SharedPreferences.Editor editor = app_prefs.edit();
        editor.putInt(MAXIMUM_PHONE_NUMBER_LENGTH, length);
        editor.apply();
    }

    public int getMaximumPhoneNumberLength() {
        return app_prefs.getInt(MAXIMUM_PHONE_NUMBER_LENGTH, Constant.PhoneNumber.MAXIMUM_PHONE_NUMBER_LENGTH);
    }

    public void putIsEnableTwilioCallMasking(Boolean isEnableTwilioCallMasking) {
        SharedPreferences.Editor edit = app_prefs.edit();
        edit.putBoolean(IS_ENABLE_TWILIO_CALL_MASKING, isEnableTwilioCallMasking);
        edit.apply();
    }

    public Boolean getIsEnableTwilioCallMasking() {
        return app_prefs.getBoolean(IS_ENABLE_TWILIO_CALL_MASKING, false);
    }
}