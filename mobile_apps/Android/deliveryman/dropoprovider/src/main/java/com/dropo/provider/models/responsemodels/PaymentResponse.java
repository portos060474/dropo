package com.dropo.provider.models.responsemodels;

import com.google.gson.annotations.SerializedName;

public class PaymentResponse extends IsSuccessResponse {

    @SerializedName("authorization_url")
    private String authorizationUrl;

    @SerializedName("required_param")
    private String requiredParam;

    @SerializedName("reference")
    private String reference;

    @SerializedName("html_form")
    private String htmlForm;

    @SerializedName("wallet")
    private double wallet;

    @SerializedName("wallet_currency_code")
    private String walletCurrencyCode;

    @SerializedName("error")
    private String error;

    @SerializedName("error_message")
    private String errorMessage;

    @SerializedName("client_secret")
    private String clientSecret;

    @SerializedName("payment_method")
    private String paymentMethod;

    public String getAuthorizationUrl() {
        return authorizationUrl;
    }

    public String getRequiredParam() {
        return requiredParam;
    }

    public String getReference() {
        return reference;
    }

    public String getHtmlForm() {
        return htmlForm;
    }

    public double getWallet() {
        return wallet;
    }

    public String getWalletCurrencyCode() {
        return walletCurrencyCode;
    }

    public String getError() {
        return error;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public String getClientSecret() {
        return clientSecret;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }
}