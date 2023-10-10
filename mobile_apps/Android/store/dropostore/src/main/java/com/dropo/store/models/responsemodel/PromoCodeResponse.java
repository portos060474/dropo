package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.PromoCodes;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class PromoCodeResponse {

    @SerializedName("promo_codes")
    private List<PromoCodes> promoCodes;

    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public List<PromoCodes> getPromoCodes() {
        return promoCodes;
    }

    public void setPromoCodes(List<PromoCodes> promoCodes) {
        this.promoCodes = promoCodes;
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

    @Override
    public String toString() {
        return "PromoCodeResponse{" + "promo_codes = '" + promoCodes + '\'' + ",success = '" + success + '\'' + ",message = '" + message + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}