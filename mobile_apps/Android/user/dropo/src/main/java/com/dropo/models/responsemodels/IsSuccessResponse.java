package com.dropo.models.responsemodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class IsSuccessResponse {

    @SerializedName("is_payment_paid")
    @Expose
    private boolean isPaymentPaid;

    @SerializedName("payment_method")
    private String paymentMethod;

    @SerializedName("client_secret")
    private String clientSecret;

    @SerializedName("is_use_wallet")
    @Expose
    private boolean isWalletUse;

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

    public boolean isWalletUse() {
        return isWalletUse;
    }

    public void setWalletUse(boolean walletUse) {
        isWalletUse = walletUse;
    }

    public boolean isPaymentPaid() {
        return isPaymentPaid;
    }

    public void setPaymentPaid(boolean paymentPaid) {
        isPaymentPaid = paymentPaid;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }
}