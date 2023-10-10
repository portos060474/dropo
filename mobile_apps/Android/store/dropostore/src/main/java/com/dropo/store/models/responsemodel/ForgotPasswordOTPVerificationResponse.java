package com.dropo.store.models.responsemodel;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class ForgotPasswordOTPVerificationResponse {


    @SerializedName("id")
    @Expose
    private String id;

    @SerializedName("server_token")
    @Expose
    private String serverToken;

    @SerializedName("success")
    @Expose
    private boolean success;

    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public String getId() {
        return id;
    }

    public String getServerToken() {
        return serverToken;
    }

    public boolean isSuccess() {
        return success;
    }

    public int getMessage() {
        return message;
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
}