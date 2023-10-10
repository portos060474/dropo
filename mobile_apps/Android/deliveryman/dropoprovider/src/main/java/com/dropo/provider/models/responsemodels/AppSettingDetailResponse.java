package com.dropo.provider.models.responsemodels;

import com.dropo.provider.utils.Const;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class AppSettingDetailResponse {
    @SerializedName("admin_contact_phone_number")
    private String adminContactPhoneNumber;
    @SerializedName("terms_and_condition_url")
    private String termsAndConditionUrl;
    @SerializedName("privacy_policy_url")
    private String privacyPolicyUrl;
    @SerializedName("is_login_by_social")
    @Expose
    private boolean isLoginBySocial;
    @SerializedName("is_profile_picture_required")
    private boolean profilePictureRequired;
    @SerializedName("is_login_by_phone")
    private boolean loginByPhone;
    @SerializedName("version_code")
    private String versionCode;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("is_verify_phone")
    private boolean verifyPhone;
    @SerializedName("is_use_referral")
    private boolean useReferral;
    @SerializedName("is_show_optional_field")
    private boolean isShowOptionalField;
    @SerializedName("is_open_update_dialog")
    private boolean openUpdateDialog;
    @SerializedName("is_login_by_email")
    private boolean loginByEmail;
    @SerializedName("success")
    private boolean success;
    @SerializedName("is_document_mandatory")
    private boolean uploadDocumentsMandatory;
    @SerializedName("is_verify_email")
    private boolean verifyEmail;
    @SerializedName("google_key")
    private String googleKey;
    @SerializedName("is_force_update")
    private boolean forceUpdate;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("admin_contact_email")
    @Expose
    private String adminContactEmail;
    @SerializedName("user_base_url")
    @Expose
    private String userBaseUrl;
    @SerializedName("minimum_phone_number_length")
    private int minimumPhoneNumberLength = Const.PhoneNumber.MINIMUM_PHONE_NUMBER_LENGTH;
    @SerializedName("maximum_phone_number_length")
    private int maximumPhoneNumberLength = Const.PhoneNumber.MAXIMUM_PHONE_NUMBER_LENGTH;
    @SerializedName("is_enable_twilio_call_masking")
    private boolean isEnableTwilioCallMasking;

    public String getAdminContactPhoneNumber() {
        return adminContactPhoneNumber;
    }

    public void setAdminContactPhoneNumber(String adminContactPhoneNumber) {
        this.adminContactPhoneNumber = adminContactPhoneNumber;
    }

    public String getTermsAndConditionUrl() {
        return termsAndConditionUrl;
    }

    public void setTermsAndConditionUrl(String termsAndConditionUrl) {
        this.termsAndConditionUrl = termsAndConditionUrl;
    }

    public String getPrivacyPolicyUrl() {
        return privacyPolicyUrl;
    }

    public void setPrivacyPolicyUrl(String privacyPolicyUrl) {
        this.privacyPolicyUrl = privacyPolicyUrl;
    }

    public boolean isProfilePictureRequired() {
        return profilePictureRequired;
    }

    public void setProfilePictureRequired(boolean profilePictureRequired) {
        this.profilePictureRequired = profilePictureRequired;
    }

    public boolean isLoginByPhone() {
        return loginByPhone;
    }

    public void setLoginByPhone(boolean loginByPhone) {
        this.loginByPhone = loginByPhone;
    }

    public String getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(String versionCode) {
        this.versionCode = versionCode;
    }

    public int getMessage() {
        return message;
    }

    public void setMessage(int message) {
        this.message = message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public boolean isVerifyPhone() {
        return verifyPhone;
    }

    public void setVerifyPhone(boolean verifyPhone) {
        this.verifyPhone = verifyPhone;
    }

    public boolean isUseReferral() {
        return useReferral;
    }

    public void setUseReferral(boolean useReferral) {
        this.useReferral = useReferral;
    }

    public boolean isShowOptionalField() {
        return isShowOptionalField;
    }

    public void setShowOptionalField(boolean showOptionalField) {
        this.isShowOptionalField = showOptionalField;
    }

    public boolean isOpenUpdateDialog() {
        return openUpdateDialog;
    }

    public void setOpenUpdateDialog(boolean openUpdateDialog) {
        this.openUpdateDialog = openUpdateDialog;
    }

    public boolean isLoginByEmail() {
        return loginByEmail;
    }

    public void setLoginByEmail(boolean loginByEmail) {
        this.loginByEmail = loginByEmail;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public boolean isUploadDocumentsMandatory() {
        return uploadDocumentsMandatory;
    }

    public void setUploadDocumentsMandatory(boolean uploadDocumentsMandatory) {
        this.uploadDocumentsMandatory = uploadDocumentsMandatory;
    }

    public boolean isVerifyEmail() {
        return verifyEmail;
    }

    public void setVerifyEmail(boolean verifyEmail) {
        this.verifyEmail = verifyEmail;
    }

    public String getGoogleKey() {
        return googleKey;
    }

    public void setGoogleKey(String googleKey) {
        this.googleKey = googleKey;
    }

    public boolean isForceUpdate() {
        return forceUpdate;
    }

    public void setForceUpdate(boolean forceUpdate) {
        this.forceUpdate = forceUpdate;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getAdminContactEmail() {
        return adminContactEmail;
    }

    public void setAdminContactEmail(String adminContactEmail) {
        this.adminContactEmail = adminContactEmail;
    }

    public boolean isLoginBySocial() {
        return isLoginBySocial;
    }

    public void setLoginBySocial(boolean loginBySocial) {
        isLoginBySocial = loginBySocial;
    }

    public String getUserBaseUrl() {
        return userBaseUrl;
    }

    public void setUserBaseUrl(String userBaseUrl) {
        this.userBaseUrl = userBaseUrl;
    }

    public int getMinimumPhoneNumberLength() {
        return minimumPhoneNumberLength;
    }

    public void setMinimumPhoneNumberLength(int minimumPhoneNumberLength) {
        this.minimumPhoneNumberLength = minimumPhoneNumberLength;
    }

    public int getMaximumPhoneNumberLength() {
        return maximumPhoneNumberLength;
    }

    public void setMaximumPhoneNumberLength(int maximumPhoneNumberLength) {
        this.maximumPhoneNumberLength = maximumPhoneNumberLength;
    }

    public boolean isEnableTwilioCallMasking() {
        return isEnableTwilioCallMasking;
    }

    public void setEnableTwilioCallMasking(boolean enableTwilioCallMasking) {
        isEnableTwilioCallMasking = enableTwilioCallMasking;
    }
}