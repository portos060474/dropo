package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.UnavailableItems;
import com.google.gson.annotations.SerializedName;

import java.util.List;

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

    @SerializedName("unavailable_items")
    private List<UnavailableItems> unavailableItems;

    @SerializedName("unavailable_products")
    private List<UnavailableItems> unavailableProducts;

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

    public List<UnavailableItems> getUnavailableItems() {
        return unavailableItems;
    }

    public List<UnavailableItems> getUnavailableProducts() {
        return unavailableProducts;
    }
}