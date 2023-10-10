package com.dropo.models.responsemodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ProviderLocationResponse {

    @SerializedName("map_pin_image_url")
    private String mapPinImageUrl;
    @SerializedName("bearing")
    private double bearing;
    @SerializedName("provider_location")
    private List<Double> providerLocation;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("success")
    private boolean success;

    public String getMapPinImageUrl() {
        return mapPinImageUrl;
    }

    public void setMapPinImageUrl(String mapPinImageUrl) {
        this.mapPinImageUrl = mapPinImageUrl;
    }

    public List<Double> getProviderLocation() {
        return providerLocation;
    }

    public void setProviderLocation(List<Double> providerLocation) {
        this.providerLocation = providerLocation;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public int getMessage() {
        return message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public void setMessage(int message) {
        this.message = message;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }


    public double getBearing() {
        return bearing;
    }

    public void setBearing(double bearing) {
        this.bearing = bearing;
    }
}