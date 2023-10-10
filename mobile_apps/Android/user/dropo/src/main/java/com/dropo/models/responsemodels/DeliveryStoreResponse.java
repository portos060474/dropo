package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.Ads;
import com.dropo.models.datamodels.City;
import com.dropo.models.datamodels.CityData;
import com.dropo.models.datamodels.Deliveries;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class DeliveryStoreResponse {

    @SerializedName("deliveries")
    @Expose
    private List<Deliveries> deliveries;

    @SerializedName("ads")
    private List<Ads> ads;

    @SerializedName("city_data")
    @Expose
    private CityData cityData;
    @SerializedName("server_time")
    @Expose
    private String serverTime;
    @SerializedName("city")
    @Expose
    private City city;
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
    @SerializedName("currency_sign")
    @Expose
    private String currencySign;
    @SerializedName("is_allow_contactless_delivery")
    @Expose
    private boolean isAllowContaclLessDelivery;

    public List<Deliveries> getDeliveries() {
        return deliveries;
    }

    public void setDeliveries(List<Deliveries> deliveries) {
        this.deliveries = deliveries;
    }

    public List<Ads> getAds() {
        return ads;
    }

    public void setAds(List<Ads> ads) {
        this.ads = ads;
    }

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public City getCity() {
        return city;
    }

    public void setCity(City city) {
        this.city = city;
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

    public String getCurrencySign() {
        return currencySign;
    }

    public void setCurrencySign(String currencySign) {
        this.currencySign = currencySign;
    }

    public CityData getCityData() {
        return cityData;
    }

    public void setCityData(CityData cityData) {
        this.cityData = cityData;
    }

    public boolean isAllowContaclLessDelivery() {
        return isAllowContaclLessDelivery;
    }

    public void setAllowContaclLessDelivery(boolean allowContaclLessDelivery) {
        isAllowContaclLessDelivery = allowContaclLessDelivery;
    }
}