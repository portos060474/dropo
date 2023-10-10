package com.dropo.store.models.responsemodel;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class OTPResponse {

    @SerializedName("otp_id")
    @Expose
    private String otpId;
    @SerializedName("email_verification")
    @Expose
    private boolean emailVerification;
    @SerializedName("sms_verification")
    @Expose
    private boolean smsVerification;
    @SerializedName("success")
    @Expose
    private boolean success;

    @SerializedName("otp_for_sms")
    @Expose
    private String otpForSms;

    @SerializedName("otp_for_email")
    @Expose
    private String otpForEmail;

    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getOtpForSms() {
        return otpForSms;
    }

    public void setOtpForSms(String otpForSms) {
        this.otpForSms = otpForSms;
    }

    public String getOtpForEmail() {
        return otpForEmail;
    }

    public void setOtpForEmail(String otpForEmail) {
        this.otpForEmail = otpForEmail;
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

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getOtpId() {
        return otpId;
    }

    public boolean isEmailVerification() {
        return emailVerification;
    }

    public boolean isSmsVerification() {
        return smsVerification;
    }
}