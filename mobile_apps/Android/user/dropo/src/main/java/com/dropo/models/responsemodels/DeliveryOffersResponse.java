package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.PromoCodes;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class DeliveryOffersResponse {

    @SerializedName("success")
    @Expose
    private boolean success;

    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("promo_codes")
    @Expose
    private List<PromoCodes> promoCodes;
    @SerializedName("promo_code_detail")
    @Expose
    private PromoCodes promoCodeDetail;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    @SerializedName("is_promo_availabel")
    @Expose
    private boolean isPromoAvailable;

    public boolean isPromoAvailable() {
        return isPromoAvailable;
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

    public List<PromoCodes> getPromoCodes() {
        return promoCodes;
    }

    public PromoCodes getPromoCodeDetail() {
        return promoCodeDetail;
    }
}