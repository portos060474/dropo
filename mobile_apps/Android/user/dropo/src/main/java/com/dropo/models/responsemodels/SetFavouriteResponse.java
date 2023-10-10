package com.dropo.models.responsemodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class SetFavouriteResponse {

    @SerializedName("success")
    private boolean success;

    @SerializedName("favourite_stores")
    private List<String> favouriteStores;

    @SerializedName("message")
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

    public List<String> getFavouriteStores() {
        return favouriteStores;
    }

    public void setFavouriteStores(List<String> favouriteStores) {
        this.favouriteStores = favouriteStores;
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
        return "SetFavouriteResponse{" + "success = '" + success + '\'' + ",favourite_stores = '" + favouriteStores + '\'' + ",message = '" + message + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}