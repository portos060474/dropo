package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.UnavailableItems;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class CheckAvailableItemResponse {

    @SerializedName("success")
    private boolean success;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    private int errorCode;
    @SerializedName("unavailable_items")
    private List<UnavailableItems> unavailableItems;
    @SerializedName("unavailable_products")
    private List<UnavailableItems> unavailableProducts;

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

    public List<UnavailableItems> getUnavailableItems() {
        return unavailableItems;
    }

    public void setUnavailableItems(List<UnavailableItems> unavailableItems) {
        this.unavailableItems = unavailableItems;
    }

    public List<UnavailableItems> getUnavailableProducts() {
        return unavailableProducts;
    }

    public void setUnavailableProducts(List<UnavailableItems> unavailableProducts) {
        this.unavailableProducts = unavailableProducts;
    }
}