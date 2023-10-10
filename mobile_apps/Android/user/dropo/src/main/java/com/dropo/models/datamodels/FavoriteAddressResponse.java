package com.dropo.models.datamodels;

import java.util.List;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class FavoriteAddressResponse {

    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("favourite_addresses")
    @Expose
    private List<Address> favouriteAddresses = null;
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

    public List<Address> getFavouriteAddresses() {
        return favouriteAddresses;
    }

    public void setFavouriteAddresses(List<Address> favouriteAddresses) {
        this.favouriteAddresses = favouriteAddresses;
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
}