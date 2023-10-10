package com.dropo.provider.models.responsemodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class IsSuccessResponse {

    @SerializedName("stripe_error")
    @Expose
    private String stripeError = "";
    @SerializedName("request_count")
    @Expose
    private int requestCount;
    @SerializedName("is_online")
    @Expose
    private boolean isOnline;
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
    @SerializedName("is_active_for_job")
    @Expose
    private boolean isActiveForJob;

    public String getStripeError() {
        return stripeError;
    }

    public void setStripeError(String stripeError) {
        this.stripeError = stripeError;
    }

    public int getRequestCount() {
        return requestCount;
    }

    public void setRequestCount(int requestCount) {
        this.requestCount = requestCount;
    }

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

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public boolean isOnline() {
        return isOnline;
    }

    public void setOnline(boolean online) {
        isOnline = online;
    }

    public boolean isActiveForJob() {
        return isActiveForJob;
    }

    public void setActiveForJob(boolean activeForJob) {
        isActiveForJob = activeForJob;
    }
}