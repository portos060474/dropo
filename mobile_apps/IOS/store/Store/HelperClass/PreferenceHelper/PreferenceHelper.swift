//
//  PreferenceHelper.swift
//  tableViewDemo
//
//  Created by Jaydeep Vyas on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit

class PreferenceHelper: NSObject {
    private let KEY_DEVICE_TOKEN = "device_token";
    
    // MARK: Setting Preference Keys
    
    private let KEY_IS_PROFILE_PICTURE_REQUIRED = "is_profile_picture_required";
    private let KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER = "is_show_optional_field_in_register";
    
    private let KEY_IS_LOGIN_BY_EMAIL = "is_login_by_email"
    private let KEY_IS_LOGIN_BY_PHONE = "is_login_by_phone"
    private let KEY_IS_REFERRAL = "is_referral";
    private let KEY_IS_REFERRAL_ON = "is_referral_on";
    private let KEY_IS_REQUIRED_FORCE_UPDATE = "is_required_force_update";
    private let KEY_APP_VERSION = "app_latest_version";
    // MARK: User Preference Keys
    private let KEY_USER_ID = "user_id";
    private let KEY_SUBSTORE_ID = "substore_id";
    
    private let KEY_PHONE_NUMBER_LENGTH = "phone_number_length";
    private let KEY_PHONE_NUMBER_MAX_LENGTH = "phone_number_max_length";
    private let KEY_PHONE_NUMBER_MIN_LENGTH = "phone_number_min_length";
    private let KEY_SESSION_TOKEN = "session_token";
    private let KEY_SUBSTORE_SESSION_TOKEN = "substore_session_token";
    private let KEY_COUNTRY_CODE = "country_code";

    private let KEY_PHONE_NUMBER = "phone_number";
    private let KEY_PHONE_COUNTRY_CODE = "phone_country_code";
    private let KEY_EMAIL = "email";
    private let KEY_TEMP_EMAIL = "temp_email";
    private let KEY_TEMP_PHONE_NUMBER = "temp_phone_number";
    /*Check User Detail*/
    private let KEY_IS_APPROVE = "is_approve"
    private let KEY_IS_USER_DOCUMENT_UPLOADED = "is_user_document_uploaded";
    private let KEY_IS_EMAIL_VERIFIED = "is_email_verified";
    private let KEY_IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
    private let KEY_IS_SUB_STORE_LOGIN = "is_sub_store_login";
    
    /*check Admin Flags*/
    private let KEY_IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory";
    private let KEY_IS_PHONE_NUMBER_VERIFICATION = "is_phone_number_verification";
    private let KEY_IS_EMAIL_VERIFICATION = "is_email_verification";
    private let KEY_IS_STORE_CAN_EDIT_ORDER = "is_store_can_edit_order";
    private let KEY_IS_STORE_CAN_CREATE_GROUP = "is_store_can_create_group";
    
    private let KEY_IS_SOCIAL_LOGIN_ENABLE = "is_login_by_social";
    private let KEY_SOCIAL_ID = "social_id";
    private let KEY_IS_BUSINESS_ON = "is_business";
    private let KEY_LANGUAGE = "language";
    private let KEY_LANGUAGE_ADMIN_IND = "languageAdminInd";
    private let KEY_LANGUAGE_STORE_IND = "languageStoreInd";
    private let KEY_LANGUAGE_ADMIN_LANG = "languageAdminLang";
    private let KEY_LANGUAGE_STORE_LANG = "languageStoreLang";
    
    private let KEY_ADMIN_EMAIL = "admin_email";
    private let KEY_ADMIN_CONTACT = "admin_contact";
    private let KEY_TERMS_AND_CONDITION = "terms_and_condition";
    private let KEY_PRIVACY_POLICY = "privacy_policy";
    private let KEY_RANDOM_CART_ID = "random_cart_id";
    private let KEY_CART_ID = "cart_id"
    private let KEY_USER_TOKEN = "user_token"
    private let KEY_TERMS_PRIVACY_BASE_URL = "term_privacy_base_url"
    private let KEY_MIN_MOBILE_LENGTH = "minimum_phone_number_length"
    private let KEY_MAX_MOBILE_LENGTH = "maximum_phone_number_length"
    
    private let IS_ENABLE_TWILIO_CALL_MASK = "is_enable_twilio_call_masking"
    
    static let KEY_CURRENT_APP_MODE = "current_app_mode"
    
    let ph = UserDefaults.standard;
    static let preferenceHelper = PreferenceHelper()
    
    private override init() {
    }
    
    func setAuthToken(_ token:String){
        ph.set(token, forKey: KEY_USER_TOKEN)
        ph.synchronize()
    }
    
    func getAuthToken() -> String{
        return (ph.value(forKey: KEY_USER_TOKEN) as? String) ?? ""
    }
    
    func setCartID(_ id:String) {
        ph.set(id, forKey: KEY_CART_ID);
        ph.synchronize();
    }
    func getCartID() -> String {
        return (ph.value(forKey: KEY_CART_ID) as? String) ?? ""
    }
    
    func setRandomCartID(_ id:String) {
        ph.set(id, forKey: KEY_RANDOM_CART_ID);
        ph.synchronize();
    }
    func getRandomCartID() -> String {
        return (ph.value(forKey: KEY_RANDOM_CART_ID) as? String) ?? ""
    }
    func setAdminEmail(_ email:String) {
        ph.set(email, forKey: KEY_ADMIN_EMAIL);
        ph.synchronize();
    }
    func getAdminEmail() -> String {
        return (ph.value(forKey: KEY_ADMIN_EMAIL) as? String) ?? ""
    }
    
    func setAdminContact(_ contact:String) {
        ph.set(contact, forKey: KEY_ADMIN_CONTACT);
        ph.synchronize();
    }
    func getAdminContact() -> String {
        return (ph.value(forKey: KEY_ADMIN_CONTACT) as? String) ?? ""
    }
    
    func setTermsAndCondition(_ url:String) {
        ph.set(url, forKey: KEY_TERMS_AND_CONDITION);
        ph.synchronize();
    }
    func getTermsAndCondition() -> String {
        return (ph.value(forKey: KEY_TERMS_AND_CONDITION) as? String) ?? ""
    }
    
    func setPrivacyPolicy(_ url:String) {
        ph.set(url, forKey: KEY_PRIVACY_POLICY);
        ph.synchronize();
    }
    func getPrivacyPolicy() -> String {
        return (ph.value(forKey: KEY_PRIVACY_POLICY) as? String) ?? ""
    }
    
    
    func setIsSocialLoginEnable(_ isSocialLoginEnable:Bool) {
        ph.set(isSocialLoginEnable, forKey: KEY_IS_SOCIAL_LOGIN_ENABLE);
        ph.synchronize();
    }
    func getIsSocialLoginEnable() -> Bool {
        return (ph.value(forKey: KEY_IS_SOCIAL_LOGIN_ENABLE) as? Bool) ?? false
    }
    
    func setLanguage(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE);
        ph.synchronize();
    }
    func getLanguage() -> (Int) {   return (ph.value(forKey: KEY_LANGUAGE) as? Int) ?? 0
    }
    
    func setSocialId(_ id:String) {
        ph.set(id, forKey: KEY_SOCIAL_ID);
        ph.synchronize();
    }
    
    func setStoreCanCreateGroup(_ id:Bool) {
        ph.set(id, forKey: KEY_IS_STORE_CAN_CREATE_GROUP);
        ph.synchronize();
    }
    
    func getStoreCanCreateGroup() -> Bool {
        return (ph.value(forKey: KEY_IS_STORE_CAN_CREATE_GROUP) as? Bool) ?? false
    }
    
    
    func setStoreCanEditOrder(_ id:Bool) {
        ph.set(id, forKey: KEY_IS_STORE_CAN_EDIT_ORDER);
        ph.synchronize();
    }
    
    func getStoreCanEditOrder() -> Bool {
        return (ph.value(forKey: KEY_IS_STORE_CAN_EDIT_ORDER) as? Bool) ?? false
    }
    
    
    func getSocialId() -> String {
        return (ph.value(forKey: KEY_SOCIAL_ID) as? String) ?? ""
    }
    
    func setLanguageAdminInd(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE_ADMIN_IND);
        ph.synchronize();
    }
    
    func getLanguageAdminInd() -> (Int) {
        return (ph.value(forKey: KEY_LANGUAGE_ADMIN_IND) as? Int) ?? 0
    }
    
    func setLanguageStoreInd(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE_STORE_IND);
        ph.synchronize();
    }
    
    func getLanguageStoreInd() -> (Int) {
        return (ph.value(forKey: KEY_LANGUAGE_STORE_IND) as? Int) ?? 0
    }
    
    func setLanguageAdminLang(_ index:String) {
        ph.set(index, forKey: KEY_LANGUAGE_ADMIN_LANG);
        ph.synchronize();
    }
    
    func getLanguageAdminLang() -> (String) {
        return (ph.value(forKey: KEY_LANGUAGE_ADMIN_LANG) as? String) ?? ""
    }
    
    func setLanguageStoreLang(_ index:String) {
        ph.set(index, forKey: KEY_LANGUAGE_STORE_LANG);
        ph.synchronize();
    }
    
    func getLanguageStoreLang() -> (String) {
        return (ph.value(forKey: KEY_LANGUAGE_STORE_LANG) as? String) ?? ""
    }
    
    /* Email Verification is on or not*/
    func setIsEmailVerification(_ isEmailVerification:Bool) {
        ph.set(isEmailVerification, forKey: KEY_IS_EMAIL_VERIFICATION);
        ph.synchronize();
    }
    func getIsEmailVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFICATION) as? Bool) ?? false
    }
    /* Set is business is on or not*/
    func setIsBusinessOn(_ isBusinessOn:Bool) {
        ph.set(isBusinessOn, forKey: KEY_IS_BUSINESS_ON);
        ph.synchronize();
    }
    func getIsBusinessOn() -> Bool {
        return (ph.value(forKey: KEY_IS_BUSINESS_ON) as? Bool) ?? false
    }
    
    /*Phone number is on or not*/
    func setIsPhoneNumberVerification(_ isPhoneNumberVerification:Bool) {
        ph.set(isPhoneNumberVerification, forKey: KEY_IS_PHONE_NUMBER_VERIFICATION);
        ph.synchronize();
    }
    func getIsPhoneNumberVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFICATION) as? Bool) ?? false
    }
    
    /*Profile picture is on or not*/
    func setIsProfilePicRequired(_ isProPicRequired:Bool) {
        ph.set(isProPicRequired, forKey: KEY_IS_PROFILE_PICTURE_REQUIRED);
        ph.synchronize();
    }
    func getIsProfilePicRequired() -> Bool {
        return (ph.value(forKey: KEY_IS_PROFILE_PICTURE_REQUIRED) as? Bool) ?? false
    }
    
    
    /*Referral code is available in country on or not*/
    func setIsReferralInCountry(_ isReferral:Bool) {
        ph.set(isReferral, forKey: KEY_IS_REFERRAL);
        ph.synchronize();
    }
    func getIsReferralInCountry() -> Bool {
        return (ph.value(forKey: KEY_IS_REFERRAL) as? Bool) ?? false
    }
    /*Referral code is available by Admin on or not*/
    func setIsReferralOn(_ isReferral:Bool) {
        ph.set(isReferral, forKey: KEY_IS_REFERRAL_ON);
        ph.synchronize();
    }
    func getIsReferralOn() -> Bool {
        return (ph.value(forKey: KEY_IS_REFERRAL_ON) as? Bool) ?? false
    }
    
    /*Force update is available by Admin on or not*/
    func setIsRequiredForceUpdate(_ fUpdate:Bool) {
        ph.set(fUpdate, forKey: KEY_IS_REQUIRED_FORCE_UPDATE);
        ph.synchronize();
    }
    
    func getIsRequiredForceUpdate() -> Bool {
        return (ph.value(forKey: KEY_IS_REQUIRED_FORCE_UPDATE) as? Bool) ?? false
    }
    
    /*Hide Optional Fields  on or not*/
    func setIsShowOptionalFieldInRegister(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER);
        ph.synchronize();
    }
    
    func getIsShowOptionalFieldInRegister() -> Bool {
        return ph.value(forKey: KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER) as? Bool ?? true
    }
    
    
    // MARK: Preference User Device Token
    func setDeviceToken(_ token:String) {
        ph.set(token, forKey: KEY_DEVICE_TOKEN);
        ph.synchronize();
    }
    
    func getDeviceToken() -> String {
        return (ph.value(forKey: KEY_DEVICE_TOKEN) as? String) ?? ""
    }
    // MARK: Preference User Getter Setters
    
    
    func setUserId(_ userId:String) {
        ph.set(userId, forKey: KEY_USER_ID);
        ph.synchronize();
    }
    
    func getUserId() -> String {
        return (ph.value(forKey: KEY_USER_ID) as? String) ?? ""
    }
    
    func setSessionToken(_ sessionToken:String) {
        ph.set(sessionToken, forKey: KEY_SESSION_TOKEN);
        ph.synchronize();
    }
    
    func getSessionToken() -> String {
        return ph.value(forKey: KEY_SESSION_TOKEN) as? String ?? ""
    }
    
    func setPhoneNumber(_ phoneNumber:String) {
        ph.set(phoneNumber, forKey: KEY_PHONE_NUMBER);
        ph.synchronize();
    }
    func getPhoneNumber() -> String {
        return (ph.value(forKey: KEY_PHONE_NUMBER) as? String) ?? ""
    }
    
    func setPhoneCountryCode(_ coutryCode:String) {
        ph.set(coutryCode, forKey: KEY_PHONE_COUNTRY_CODE);
        ph.synchronize();
    }
    func getPhoneCountryCode() -> String {
        return (ph.value(forKey: KEY_PHONE_COUNTRY_CODE) as? String) ?? ""
    }
    
    func setEmail(_ email:String) {
        ph.set(email, forKey: KEY_EMAIL);
        ph.synchronize();
    }
    func getEmail() -> String {
        return (ph.value(forKey: KEY_EMAIL) as? String) ?? ""
    }
    func setLatestAppVersion(_ version:String) {
        ph.set(version, forKey: KEY_APP_VERSION);
        ph.synchronize();
    }
    func getLatestAppVersion() -> String {
        return ( ph.value(forKey: KEY_APP_VERSION) as? String) ?? ""
    }
    
    func setPhoneNumberLength(_ length:Int) {
        ph.set(length, forKey: KEY_PHONE_NUMBER_LENGTH);
        ph.synchronize();
    }
    
    func getPhoneNumberLength() -> Int {
        return (ph.value(forKey: KEY_PHONE_NUMBER_LENGTH) as? Int) ?? 0
    }
    
    func setIsLoginByEmail(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_LOGIN_BY_EMAIL);
        ph.synchronize();
    }
    
    func getIsLoginByEmail() -> Bool {
        return ph.value(forKey: KEY_IS_LOGIN_BY_EMAIL) as? Bool ?? false
    }
    
    func setIsLoginByPhone(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_LOGIN_BY_PHONE);
        ph.synchronize();
    }
    
    func getIsLoginByPhone() -> Bool {
        return ph.value(forKey: KEY_IS_LOGIN_BY_PHONE) as? Bool ?? false
    }
    func setIsUserApprove(_ isApprove: Bool) {
        ph.set(isApprove, forKey: KEY_IS_APPROVE);
        ph.synchronize();
    }
    func getIsUserApprove() -> Bool {
        return (ph.value(forKey: KEY_IS_APPROVE) as? Bool) ?? false
    }
    func setIsAdminDocumentMandatory(_ isAdminDocumentMandatory: Bool) {
        ph.set(isAdminDocumentMandatory, forKey: KEY_IS_ADMIN_DOCUMENT_MANDATORY);
        ph.synchronize();
    }
    func getIsAdminDocumentMandatory() -> Bool {
        return (ph.value(forKey: KEY_IS_ADMIN_DOCUMENT_MANDATORY) as? Bool) ?? false
    }
    func setIsEmailVerified(_ isEmailVerified:Bool) {
        ph.set(isEmailVerified, forKey: KEY_IS_EMAIL_VERIFIED);
        ph.synchronize();
    }
    func getIsEmailVerified() -> Bool {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFIED) as? Bool) ?? false
    }
    func setIsPhoneNumberVerified(_ isPhoneNumberVerified:Bool) {
        ph.set(isPhoneNumberVerified, forKey: KEY_IS_PHONE_NUMBER_VERIFIED);
        ph.synchronize();
    }
    func getIsPhoneNumberVerified() -> Bool {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFIED) as? Bool) ?? false
    }
    func setIsUserDocumentUploaded(_ isProviderDocumentUploaded:Bool) {
        ph.set(isProviderDocumentUploaded, forKey: KEY_IS_USER_DOCUMENT_UPLOADED);
        ph.synchronize();
    }
    func getIsUserDocumentUploaded() -> Bool {
        return (ph.value(forKey: KEY_IS_USER_DOCUMENT_UPLOADED) as? Bool) ?? false
        
    }
    func setTempPhoneNumber(_ phoneNumber:String) {
        ph.set(phoneNumber, forKey: KEY_TEMP_PHONE_NUMBER);
        ph.synchronize();
    }
    func getTempPhoneNumber() -> String {
        return (ph.value(forKey: KEY_TEMP_PHONE_NUMBER) as? String) ?? ""
    }
    func setTempEmail(_ email:String) {
        ph.set(email, forKey: KEY_TEMP_EMAIL);
        ph.synchronize();
    }
    func getTempEmail() -> String {
        return (ph.value(forKey: KEY_TEMP_EMAIL) as? String) ?? ""
    }
    
    func getCountryCode() -> String {
        return (ph.value(forKey: KEY_COUNTRY_CODE) as? String) ?? ""
    }
    func setCountryCode(_ code:String) {
        ph.set(code, forKey: KEY_COUNTRY_CODE);
        ph.synchronize();
    }

    func setSubStoreId(_ userId:String) {
        ph.set(userId, forKey: KEY_SUBSTORE_ID);
        ph.synchronize();
    }
    
    func getSubStoreId() -> String {
        return (ph.value(forKey: KEY_SUBSTORE_ID) as? String) ?? ""
    }
    
    //    func setSubStoreSessionToken(_ sessionToken:String) {
    //        ph.set(sessionToken, forKey: KEY_SUBSTORE_SESSION_TOKEN);
    //        ph.synchronize();
    //    }
    //
    //    func getSubStoreSessionToken() -> String {
    //        return ph.value(forKey: KEY_SUBSTORE_SESSION_TOKEN) as? String ?? ""
    //    }
    
    func setIsSubStoreLogin(_ isSubStoreLogin:Bool) {
        ph.set(isSubStoreLogin, forKey: KEY_IS_SUB_STORE_LOGIN);
        ph.synchronize();
    }
    func getIsSubStoreLogin() -> Bool {
        return (ph.value(forKey: KEY_IS_SUB_STORE_LOGIN) as? Bool) ?? false
        
    }
    
    func getCurrentAppMode() -> Int {
        return (ph.value(forKey: PreferenceHelper.KEY_CURRENT_APP_MODE) as? Int) ?? 0
    }
    
    func setCurrentAppMode(_ length:Int) {
        ph.set(length, forKey: PreferenceHelper.KEY_CURRENT_APP_MODE);
        ph.synchronize();
    }
    
    func getUserPanelUrl() -> String {
        return (ph.value(forKey: KEY_TERMS_PRIVACY_BASE_URL) as? String) ?? ""
    }
    
    func setUserPanelUrl(_ str:String) {
        ph.set(str, forKey: KEY_TERMS_PRIVACY_BASE_URL);
        ph.synchronize();
    }
    
    func setMinMobileLength(_ int:Int) {
        ph.set(int, forKey: KEY_MIN_MOBILE_LENGTH)
        ph.synchronize()
    }
    
    func getMinMobileLength() -> Int {
        return (ph.value(forKey: KEY_MIN_MOBILE_LENGTH) as? Int) ?? 7
    }
    
    func setMaxMobileLength(_ int:Int) {
        ph.set(int, forKey: KEY_MAX_MOBILE_LENGTH)
        ph.synchronize()
    }
    
    func getMaxMobileLength() -> Int {
        return (ph.value(forKey: KEY_MAX_MOBILE_LENGTH) as? Int) ?? 12
    }
    
    func setIsEnableTwilioCallMask(_ bool:Bool) {
        ph.set(bool, forKey: IS_ENABLE_TWILIO_CALL_MASK);
        ph.synchronize();
    }
    
    func getIsEnableTwilioCallMask() -> Bool {
        return (ph.value(forKey: IS_ENABLE_TWILIO_CALL_MASK) as? Bool) ?? false
    }

    
    func clearAll() {
        ph.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        ph.synchronize();
    }
    
}
