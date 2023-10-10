package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.User;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class UserDataResponse {

    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("user")
    @Expose
    private User user;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("minimum_phone_number_length")
    @Expose
    private int minPhoneNumberLength;
    @SerializedName("maximum_phone_number_length")
    @Expose
    private int maxPhoneNumberLength;
    @SerializedName("firebase_token")
    @Expose
    private String firebaseToken;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public int getMinPhoneNumberLength() {
        return minPhoneNumberLength;
    }

    public void setMinPhoneNumberLength(int minPhoneNumberLength) {
        this.minPhoneNumberLength = minPhoneNumberLength;
    }

    public int getMaxPhoneNumberLength() {
        return maxPhoneNumberLength;
    }

    public void setMaxPhoneNumberLength(int maxPhoneNumberLength) {
        this.maxPhoneNumberLength = maxPhoneNumberLength;
    }

    public String getFirebaseToken() {
        return firebaseToken;
    }
}