//
//  PreferenceHelper.swift
//  tableViewDemo
//
//  Created by Elluminati on 12/01/17.
//  Copyright © 2017 tag. All rights reserved.
//

import UIKit

class PreferenceHelper: NSObject {
    private let KEY_DEVICE_TOKEN = "device_token"

    //MARK: - Setting Preference Keys
    private let KEY_IS_PROFILE_PICTURE_REQUIRED = "is_profile_picture_required"
    private let KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER = "is_show_optional_field_in_register"
    private let KEY_IS_LOGIN_BY_EMAIL = "is_login_by_email"
    private let KEY_IS_LOGIN_BY_PHONE = "is_login_by_phone"
    private let KEY_IS_REFERRAL = "is_referral"
    private let KEY_IS_REFERRAL_ON = "is_referral_on"
    private let KEY_IS_REQUIRED_FORCE_UPDATE = "is_required_force_update"
    private let KEY_APP_VERSION = "app_latest_version"

    //MARK: - User Preference Keys
    private let KEY_FIRST_NAME = "first_name"
    private let KEY_LAST_NAME = "last_name"
    private let KEY_USER_ID = "user_id"
    private let KEY_PHONE_NUMBER_LENGTH = "phone_number_length"
    private let KEY_PHONE_NUMBER_MAX_LENGTH = "phone_number_max_length"
    private let KEY_PHONE_NUMBER_MIN_LENGTH = "phone_number_min_length"
    private let KEY_SESSION_TOKEN = "session_token"
    private let KEY_BIO = "bio"
    private let KEY_ADDRESS = "address"
    private let KEY_PROFILE_PIC = "profile_pic"
    private let KEY_PHONE_NUMBER = "phone_number"
    private let KEY_PHONE_COUNTRY_CODE = "phone_country_code"
    private let KEY_COUNTRY_CODE = "country_code"
    private let KEY_COUNTRY_ID = "country_id"
    private let KEY_EMAIL = "email"
    private let KEY_TEMP_EMAIL = "temp_email"
    private let KEY_MIN_MOBILE_LENGTH = "minimum_phone_number_length"
    private let KEY_MAX_MOBILE_LENGTH = "maximum_phone_number_length"
    private let KEY_TEMP_PHONE_NUMBER = "temp_phone_number"
    
    static let KEY_CURRENT_APP_MODE = "current_app_mode"

    /*Check User Detail*/
    private let KEY_IS_APPROVE = "is_approve"
    private let KEY_IS_USER_DOCUMENT_UPLOADED = "is_user_document_uploaded"
    private let KEY_IS_EMAIL_VERIFIED = "is_email_verified"
    private let KEY_IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified"

    /*check Admin Flags*/
    private let KEY_IS_ADMIN_DOCUMENT_MANDATORY = "is_admin_document_mandatory"
    private let KEY_IS_PHONE_NUMBER_VERIFICATION = "is_phone_number_verification"
    private let KEY_IS_EMAIL_VERIFICATION = "is_email_verification"

    /**Referral code*/
    private let KEY_REFERRAL_CODE = "referral_code"
    private let KEY_WALLET = "wallet"
    private let KEY_WALLET_CURRENCY_CODE = "wallet_currency_code"
    private let KEY_IS_SOCIAL_LOGIN_ENABLE = "is_login_by_social"
    private let KEY_SOCIAL_ID = "social_id"
    private let KEY_LANGUAGE = "language"
    private let KEY_IPHONE_ID = "iphone_id"
    private let KEY_IS_SHOW_TUTORIAL = "is_show_tutorial"

    /**Admin Detail*/
    private let KEY_ADMIN_EMAIL = "admin_email"
    private let KEY_ADMIN_CONTACT = "admin_contact"
    private let KEY_TERMS_AND_CONDITION = "terms_and_condition"
    private let KEY_PRIVACY_POLICY = "privacy_policy"
    private let KEY_RANDOM_CART_ID = "random_cart_id"
    private let KEY_IS_LOAD_STORE_IMAGE = "is_load_store_image"
    private let KEY_IS_LOAD_ITEM_IMAGE = "is_load_item_image"
    private let KEY_LANGUAGE_SELECTED = "language_Selcted"
    private let KEY_LANGUAGECODE_SELECTED = "languageCode_Selcted"
    private let KEY_CHAT_NAME = "chat_name"
    private let KEY_APPLE_USER_NAME = "apple_user_name"
    private let KEY_APPLE_EMAIL = "apple_email"
    private let KEY_USER_TOKEN = "user_token"
    private let KEY_TERMS_PRIVACY_BASE_URL = "term_privacy_base_url"
    private let KEY_IS_ALLOW_BRING_CHANGE = "is_allow_bring_change"
    private let KEY_IS_QR_USER_REGISTER = "is_qr_user_register"
    private let IS_ENABLE_TWILIO_CALL_MASKING = "is_enable_twilio_call_masking"
    private let MAX_COURIER_STOP_LIMIT = "max_courier_stop_limit"

    let ph = UserDefaults.standard
    static let preferenceHelper = PreferenceHelper()

    private override init() {}

    func setAuthToken(_ token:String) {
        ph.set(token, forKey: KEY_USER_TOKEN)
        ph.synchronize()
    }
    func getAuthToken() -> String {
        return (ph.value(forKey: KEY_USER_TOKEN) as? String) ?? ""
    }

    func setRandomCartID(_ id:String) {
        ph.set(id, forKey: KEY_RANDOM_CART_ID)
        ph.synchronize()
    }
    func getRandomCartID() -> String {
        return (ph.value(forKey: KEY_RANDOM_CART_ID) as? String) ?? ""
    }

    func setAdminEmail(_ email:String) {
        ph.set(email, forKey: KEY_ADMIN_EMAIL)
        ph.synchronize()
    }
    func getAdminEmail() -> String {
        return (ph.value(forKey: KEY_ADMIN_EMAIL) as? String) ?? ""
    }

    func setAdminContact(_ contact:String) {
        ph.set(contact, forKey: KEY_ADMIN_CONTACT)
        ph.synchronize()
    }
    func getAdminContact() -> String {
        return (ph.value(forKey: KEY_ADMIN_CONTACT) as? String) ?? ""
    }

    func setTermsAndCondition(_ url:String) {
        ph.set(url, forKey: KEY_TERMS_AND_CONDITION)
        ph.synchronize()
    }
    func getTermsAndCondition() -> String {
        return (ph.value(forKey: KEY_TERMS_AND_CONDITION) as? String) ?? ""
    }

    func setPrivacyPolicy(_ url:String) {
        ph.set(url, forKey: KEY_PRIVACY_POLICY)
        ph.synchronize()
    }
    func getPrivacyPolicy() -> String {
        return (ph.value(forKey: KEY_PRIVACY_POLICY) as? String) ?? ""
    }

    func setLanguage(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE)
        ph.synchronize()
    }

    func getLanguage() -> (Int) {
        return (ph.value(forKey: KEY_LANGUAGE) as? Int) ?? 0
    }

    //Changed
    func setSelectedLanguage(_ index:Int) {
        ph.set(index, forKey: KEY_LANGUAGE_SELECTED)
        ph.synchronize()
    }
    func getSelectedLanguage() -> (Int) {
        return (ph.value(forKey: KEY_LANGUAGE_SELECTED) as? Int) ?? 0
    }

    func setSelectedLanguageCode(str:String) {
        ph.set(str, forKey: KEY_LANGUAGECODE_SELECTED)
        ph.synchronize()
    }
    func getSelectedLanguageCode() -> (String) {
        return (ph.value(forKey: KEY_LANGUAGECODE_SELECTED) as? String) ?? "en"
    }

    func setChatName(_ name:String) {
        ph.set(name, forKey: KEY_CHAT_NAME);
        ph.synchronize();
    }
    func getChatName() -> String {
        return (ph.value(forKey: KEY_CHAT_NAME) as? String) ?? ""
    }

    func setIsLoadStoreImage(_ isLoadStoreImage:Bool) {
        ph.set(isLoadStoreImage, forKey: KEY_IS_LOAD_STORE_IMAGE)
        ph.synchronize()
    }
    func getIsLoadStoreImage() -> Bool {
        return (ph.value(forKey: KEY_IS_LOAD_STORE_IMAGE) as? Bool) ?? true
    }

    func setIsLoadItemImage(_ isLoadItemImage:Bool) {
        ph.set(isLoadItemImage, forKey: KEY_IS_LOAD_ITEM_IMAGE)
        ph.synchronize()
    }
    func getIsLoadItemImage() -> Bool {
        return (ph.value(forKey: KEY_IS_LOAD_ITEM_IMAGE) as? Bool) ?? true
    }

    func setIsSocialLoginEnable(_ isSocialLoginEnable:Bool) {
        ph.set(isSocialLoginEnable, forKey: KEY_IS_SOCIAL_LOGIN_ENABLE)
        ph.synchronize()
    }
    func getIsSocialLoginEnable() -> Bool {
        return (ph.value(forKey: KEY_IS_SOCIAL_LOGIN_ENABLE) as? Bool) ?? false
    }

    func setIsShowTutorial(_ isShowTutorial:Bool) {
        ph.set(isShowTutorial, forKey: KEY_IS_SHOW_TUTORIAL)
        ph.synchronize()
    }
    func getIsShowTutorial() -> Bool {
        return (ph.value(forKey: KEY_IS_SHOW_TUTORIAL) as? Bool) ?? true
    }

    func setSocialId(_ id:String) {
        ph.set(id, forKey: KEY_SOCIAL_ID)
        ph.synchronize()
    }
    func getSocialId() -> String {
        return (ph.value(forKey: KEY_SOCIAL_ID) as? String) ?? ""
    }

    //MARK: - Wallet Setting Getter Setters
    func setWalletAmount(_ walletAmount:String) {
        ph.set(walletAmount, forKey: KEY_WALLET)
        ph.synchronize()
    }
    func getWalletAmount() -> String {
        return (ph.value(forKey: KEY_WALLET) as? String) ?? "0.00"
    }

    func setWalletCurrencyCode(_ wallet:String) {
        ph.set(wallet, forKey: KEY_WALLET_CURRENCY_CODE)
        ph.synchronize()
    }
    func getWalletCurrencyCode() -> String {
        return (ph.value(forKey: KEY_WALLET_CURRENCY_CODE) as? String) ?? "INR"
    }

    func setReferralCode(_ wallet:String) {
        ph.set(wallet, forKey: KEY_REFERRAL_CODE)
        ph.synchronize()
    }
    func getReferralCode() -> String {
        return (ph.value(forKey: KEY_REFERRAL_CODE) as? String) ?? ""
    }

    //MARK: - Preference Setting Getter Setters
    func setIsEmailVerification(_ isEmailVerification:Bool) {
        ph.set(isEmailVerification, forKey: KEY_IS_EMAIL_VERIFICATION)
        ph.synchronize()
    }
    func getIsEmailVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFICATION) as? Bool) ?? false
    }

    func setIsPhoneNumberVerification(_ isPhoneNumberVerification:Bool) {
        ph.set(isPhoneNumberVerification, forKey: KEY_IS_PHONE_NUMBER_VERIFICATION)
        ph.synchronize()
    }
    func getIsPhoneNumberVerification() -> Bool {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFICATION) as? Bool) ?? false
    }

    func setIsProfilePicRequired(_ isProPicRequired:Bool) {
        ph.set(isProPicRequired, forKey: KEY_IS_PROFILE_PICTURE_REQUIRED)
        ph.synchronize()
    }
    func getIsProfilePicRequired() -> Bool {
        return (ph.value(forKey: KEY_IS_PROFILE_PICTURE_REQUIRED) as? Bool) ?? false
    }

    func setIsReferralInCountry(_ isReferral:Bool) {
        ph.set(isReferral, forKey: KEY_IS_REFERRAL)
        ph.synchronize()
    }
    func getIsReferralInCountry() -> Bool {
        return (ph.value(forKey: KEY_IS_REFERRAL) as? Bool) ?? false
    }

    func setIsReferralOn(_ isReferral:Bool) {
        ph.set(isReferral, forKey: KEY_IS_REFERRAL_ON)
        ph.synchronize()
    }
    func getIsReferralOn() -> Bool {
        return (ph.value(forKey: KEY_IS_REFERRAL_ON) as? Bool) ?? false
    }

    func setIsRequiredForceUpdate(_ fUpdate:Bool) {
        ph.set(fUpdate, forKey: KEY_IS_REQUIRED_FORCE_UPDATE)
        ph.synchronize()
    }
    func getIsRequiredForceUpdate() -> Bool {
        return (ph.value(forKey: KEY_IS_REQUIRED_FORCE_UPDATE) as? Bool) ?? false
    }

    func setIsShowOptionalFieldInRegister(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER)
        ph.synchronize()
    }
    func getIsShowOptionalFieldInRegister() -> Bool {
        return ph.value(forKey: KEY_IS_SHOW_OPTIONAL_FIELD_IN_REGISTER) as? Bool ?? true
    }

    //MARK: - Preference User Device Token
    func setDeviceToken(_ token:String) {
        ph.set(token, forKey: KEY_DEVICE_TOKEN)
        ph.synchronize()
    }
    func getDeviceToken() -> String {
        return (ph.value(forKey: KEY_DEVICE_TOKEN) as? String) ?? ""
    }

    //MARK: - Preference User Getter Setters
    func setFirstName(_ fname:String) {
        ph.set(fname, forKey: KEY_FIRST_NAME)
        ph.synchronize()
    }
    func getFirstName() -> String {
        return (ph.value(forKey: KEY_FIRST_NAME) as? String) ?? ""
    }

    func setLastName(_ lname:String) {
        ph.set(lname, forKey: KEY_LAST_NAME)
        ph.synchronize()
    }
    func getLastName() -> String {
        return (ph.value(forKey: KEY_LAST_NAME) as? String) ?? ""
    }

    func setUserId(_ userId:String) {
        ph.set(userId, forKey: KEY_USER_ID)
        ph.synchronize()
    }
    func getUserId() -> String {
        return (ph.value(forKey: KEY_USER_ID) as? String) ?? ""
    }

    func setSessionToken(_ sessionToken:String) {
        ph.set(sessionToken, forKey: KEY_SESSION_TOKEN)
        ph.synchronize()
    }
    func getSessionToken() -> String {
        return (ph.value(forKey: KEY_SESSION_TOKEN) as? String) ?? ""
    }

    func setBio(_ bio:String) {
        ph.set(bio, forKey: KEY_BIO)
        ph.synchronize()
    }
    func getBio() -> String {
        return (ph.value(forKey: KEY_BIO) as? String) ?? ""
    }

    func setAddress(_ address:String) {
        ph.set(address, forKey: KEY_ADDRESS)
        ph.synchronize()
    }
    func getAddress() -> String {
        return (ph.value(forKey: KEY_ADDRESS) as? String) ?? ""
    }

    func setProfilePicUrl(_ profileUrl:String) {
        ph.set(profileUrl, forKey: KEY_PROFILE_PIC)
        ph.synchronize()
    }
    func getProfilePicUrl() -> String {
        return (ph.value(forKey: KEY_PROFILE_PIC) as? String) ?? ""
    }

    func setPhoneNumber(_ phoneNumber:String) {
        ph.set(phoneNumber, forKey: KEY_PHONE_NUMBER)
        ph.synchronize()
    }
    func getPhoneNumber() -> String {
        return (ph.value(forKey: KEY_PHONE_NUMBER) as? String) ?? ""
    }

    func setPhoneCountryCode(_ coutryCode:String) {
        ph.set(coutryCode, forKey: KEY_PHONE_COUNTRY_CODE)
        ph.synchronize()
    }
    func getPhoneCountryCode() -> String {
        return (ph.value(forKey: KEY_PHONE_COUNTRY_CODE) as? String) ?? ""
    }

    func setCountryCode(_ coutryCode:String) {
        ph.set(coutryCode, forKey: KEY_COUNTRY_CODE)
        ph.synchronize()
    }
    func getCountryCode() -> String {
        return (ph.value(forKey: KEY_COUNTRY_CODE) as? String) ?? (Locale.current.regionCode ?? "IN")
    }

    func setEmail(_ email:String) {
        ph.set(email, forKey: KEY_EMAIL)
        ph.synchronize()
    }
    func getEmail() -> String {
        return (ph.value(forKey: KEY_EMAIL) as? String) ?? ""
    }

    func setLatestAppVersion(_ version:String) {
        ph.set(version, forKey: KEY_APP_VERSION)
        ph.synchronize()
    }
    func getLatestAppVersion() -> String {
        return (ph.value(forKey: KEY_APP_VERSION) as? String) ?? ""
    }

    func setPhoneNumberLength(_ length:Int) {
        ph.set(length, forKey: KEY_PHONE_NUMBER_LENGTH)
        ph.synchronize()
    }
    func getPhoneNumberLength() -> Int {
        return (ph.value(forKey: KEY_PHONE_NUMBER_LENGTH) as? Int) ?? 10
    }

    func setIsLoginByEmail(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_LOGIN_BY_EMAIL)
        ph.synchronize()
    }
    func getIsLoginByEmail() -> Bool {
        return ph.value(forKey: KEY_IS_LOGIN_BY_EMAIL) as? Bool ?? false
    }

    func setIsLoginByPhone(_ hide:Bool) {
        ph.set(hide, forKey: KEY_IS_LOGIN_BY_PHONE)
        ph.synchronize()
    }
    func getIsLoginByPhone() -> Bool {
        return ph.value(forKey: KEY_IS_LOGIN_BY_PHONE) as? Bool ?? false
    }

    func setIsUserApprove(_ isApprove: Bool) {
        ph.set(isApprove, forKey: KEY_IS_APPROVE)
        ph.synchronize()
    }
    func getIsUserApprove() -> Bool {
        return (ph.value(forKey: KEY_IS_APPROVE) as? Bool) ?? true
    }

    func setIsAdminDocumentMandatory(_ isAdminDocumentMandatory: Bool) {
        ph.set(isAdminDocumentMandatory, forKey: KEY_IS_ADMIN_DOCUMENT_MANDATORY)
        ph.synchronize()
    }
    func getIsAdminDocumentMandatory() -> Bool {
        return (ph.value(forKey: KEY_IS_ADMIN_DOCUMENT_MANDATORY) as? Bool) ?? false
    }

    func setIsEmailVerified(_ isEmailVerified:Bool) {
        ph.set(isEmailVerified, forKey: KEY_IS_EMAIL_VERIFIED)
        ph.synchronize()
    }
    func getIsEmailVerified() -> Bool {
        return (ph.value(forKey: KEY_IS_EMAIL_VERIFIED) as?  Bool) ?? false
    }

    func setIsPhoneNumberVerified(_ isPhoneNumberVerified:Bool) {
        ph.set(isPhoneNumberVerified, forKey: KEY_IS_PHONE_NUMBER_VERIFIED)
        ph.synchronize()
    }
    func getIsPhoneNumberVerified() -> Bool {
        return (ph.value(forKey: KEY_IS_PHONE_NUMBER_VERIFIED) as? Bool) ?? false
    }

    func setIsUserDocumentUploaded(_ isProviderDocumentUploaded:Bool) {
        ph.set(isProviderDocumentUploaded, forKey: KEY_IS_USER_DOCUMENT_UPLOADED)
        ph.synchronize()
    }
    func getIsUserDocumentUploaded() -> Bool {
        return (ph.value(forKey: KEY_IS_USER_DOCUMENT_UPLOADED) as? Bool) ?? false
    }

    func setTempPhoneNumber(_ phoneNumber:String) {
        ph.set(phoneNumber, forKey: KEY_TEMP_PHONE_NUMBER)
        ph.synchronize()
    }
    func getTempPhoneNumber() -> String {
        return (ph.value(forKey: KEY_TEMP_PHONE_NUMBER) as? String) ?? ""
    }

    func setTempEmail(_ email:String) {
        ph.set(email, forKey: KEY_TEMP_EMAIL)
        ph.synchronize()
    }
    func getTempEmail() -> String {
        return (ph.value(forKey: KEY_TEMP_EMAIL) as? String) ?? ""
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

    func setCountryId(_ countryId:String) {
        ph.set(countryId, forKey: KEY_COUNTRY_ID)
        ph.synchronize()
    }
    func getCountryId() -> String {
        return (ph.value(forKey: KEY_COUNTRY_ID) as? String) ?? ""
    }

    func setSigninWithAppleUserName(_ username:String) {
        ph.set(username, forKey: KEY_APPLE_USER_NAME)
        ph.synchronize()
    }
    func getSigninWithAppleUserName() -> String {
        return (ph.value(forKey: KEY_APPLE_USER_NAME) as? String) ?? ""
    }

    func setSigninWithAppleEmail(_ email:String) {
        ph.set(email, forKey: KEY_APPLE_EMAIL)
        ph.synchronize()
    }
    func getSigninWithAppleEmail() -> String {
        return (ph.value(forKey: KEY_APPLE_EMAIL) as? String) ?? ""
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
    
    func getIsAllowBringChange() -> Bool {
        return (ph.value(forKey: KEY_IS_ALLOW_BRING_CHANGE) as? Bool) ?? false
    }
    
    func setIsAllowBringChange(_ bool:Bool) {
        ph.set(bool, forKey: KEY_IS_ALLOW_BRING_CHANGE);
        ph.synchronize();
    }
    
    func setIsQRUser(_ bool:Bool) {
        ph.set(bool, forKey: KEY_IS_QR_USER_REGISTER)
        ph.synchronize()
    }
    func getIsQRUser() -> Bool {
        return (ph.value(forKey: KEY_IS_QR_USER_REGISTER) as? Bool) ?? false
    }
    
    func setIsTwillowMaskEnable(_ bool:Bool) {
        ph.set(bool, forKey: IS_ENABLE_TWILIO_CALL_MASKING)
        ph.synchronize()
    }
    func getIsTwillowMaskEnable() -> Bool {
        return (ph.value(forKey: IS_ENABLE_TWILIO_CALL_MASKING) as? Bool) ?? false
    }
    
    func setMaxCourierStop(_ int:Int) {
        ph.set(int, forKey: MAX_COURIER_STOP_LIMIT)
        ph.synchronize()
    }
    func getMaxCourierStop() -> Int {
        return (ph.value(forKey: MAX_COURIER_STOP_LIMIT) as? Int) ?? 0
    }

    func clearAll() {
        ph.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        ph.synchronize()
    }
}
