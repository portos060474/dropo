package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.Ads;
import com.dropo.models.datamodels.StoresResult;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class StoreResponse {

    @SerializedName("ads")
    private List<Ads> ads;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("stores")
    @Expose
    private StoresResult storesResult;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("server_time")
    @Expose
    private String serverTime;
    @SerializedName("timezone")
    @Expose
    private String timezone;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public List<Ads> getAds() {
        return ads;
    }

    public void setAds(List<Ads> ads) {
        this.ads = ads;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public StoresResult getStoresResult() {
        return storesResult;
    }

    public void setStoresResult(StoresResult storesResult) {
        this.storesResult = storesResult;
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

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }
}