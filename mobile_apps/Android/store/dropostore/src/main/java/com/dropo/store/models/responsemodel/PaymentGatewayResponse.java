package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.PaymentGateway;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class PaymentGatewayResponse {

    @SerializedName("is_cash_payment_mode")
    @Expose
    private boolean isCashPaymentMode;
    @SerializedName("is_use_wallet")
    @Expose
    private boolean isUseWallet;
    @SerializedName("wallet_currency_code")
    @Expose
    private String walletCurrencyCode;
    @SerializedName("wallet")
    @Expose
    private double walletAmount;
    @SerializedName("payment_gateway")
    @Expose
    private List<PaymentGateway> paymentGateway;

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

    public List<PaymentGateway> getPaymentGateway() {
        return paymentGateway;
    }

    public void setPaymentGateway(List<PaymentGateway> paymentGateway) {
        this.paymentGateway = paymentGateway;
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

    public String getWalletCurrencyCode() {
        return walletCurrencyCode;
    }

    public void setWalletCurrencyCode(String walletCurrencyCode) {
        this.walletCurrencyCode = walletCurrencyCode;
    }

    public double getWalletAmount() {
        return walletAmount;
    }

    public void setWalletAmount(double walletAmount) {
        this.walletAmount = walletAmount;
    }

    public boolean isUseWallet() {
        return isUseWallet;
    }

    public void setUseWallet(boolean useWallet) {
        isUseWallet = useWallet;
    }

    public boolean isCashPaymentMode() {
        return isCashPaymentMode;
    }

    public void setCashPaymentMode(boolean cashPaymentMode) {
        isCashPaymentMode = cashPaymentMode;
    }
}