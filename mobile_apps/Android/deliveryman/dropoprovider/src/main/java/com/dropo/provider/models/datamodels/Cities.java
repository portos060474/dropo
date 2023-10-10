package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Cities {

    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;

    @SerializedName("payment_gateway")
    @Expose
    private List<Integer> paymentGateway;

    @SerializedName("timezone")
    @Expose
    private String timezone;

    @SerializedName("city_code")
    @Expose
    private String cityCode;

    @SerializedName("created_at")
    @Expose
    private String createdAt;

    @SerializedName("deliveries_in_city")
    @Expose
    private Object deliveriesInCity;

    @SerializedName("is_promo_apply_for_other")
    @Expose
    private boolean isPromoApplyForOther;

    @SerializedName("city_lat_long")
    @Expose
    private List<Double> cityLatLong;
    @SerializedName("city_nick_name")
    @Expose
    private String cityNickName = "";
    @SerializedName("city_name")
    @Expose
    private String cityName = "";
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("__v")
    @Expose
    private int V;
    @SerializedName("is_cash_payment_mode")
    @Expose
    private boolean isCashPaymentMode;
    @SerializedName("is_other_payment_mode")
    @Expose
    private boolean isOtherPaymentMode;
    @SerializedName("city_radius")
    @Expose
    private double cityRadius;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("is_promo_apply_for_cash")
    @Expose
    private boolean isPromoApplyForCash;
    @SerializedName("country_id")
    @Expose
    private String countryId;

    public String getCityNickName() {
        return cityNickName;
    }

    public void setCityNickName(String cityNickName) {
        this.cityNickName = cityNickName;
    }

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public List<Integer> getPaymentGateway() {
        return paymentGateway;
    }

    public void setPaymentGateway(List<Integer> paymentGateway) {
        this.paymentGateway = paymentGateway;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public Object getDeliveriesInCity() {
        return deliveriesInCity;
    }

    public void setDeliveriesInCity(Object deliveriesInCity) {
        this.deliveriesInCity = deliveriesInCity;
    }

    public boolean isIsPromoApplyForOther() {
        return isPromoApplyForOther;
    }

    public void setIsPromoApplyForOther(boolean isPromoApplyForOther) {
        this.isPromoApplyForOther = isPromoApplyForOther;
    }

    public List<Double> getCityLatLong() {
        return cityLatLong;
    }

    public void setCityLatLong(List<Double> cityLatLong) {
        this.cityLatLong = cityLatLong;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getV() {
        return V;
    }

    public void setV(int V) {
        this.V = V;
    }

    public boolean isIsCashPaymentMode() {
        return isCashPaymentMode;
    }

    public void setIsCashPaymentMode(boolean isCashPaymentMode) {
        this.isCashPaymentMode = isCashPaymentMode;
    }

    public boolean isIsOtherPaymentMode() {
        return isOtherPaymentMode;
    }

    public void setIsOtherPaymentMode(boolean isOtherPaymentMode) {
        this.isOtherPaymentMode = isOtherPaymentMode;
    }

    public double getCityRadius() {
        return cityRadius;
    }

    public void setCityRadius(double cityRadius) {
        this.cityRadius = cityRadius;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isIsPromoApplyForCash() {
        return isPromoApplyForCash;
    }

    public void setIsPromoApplyForCash(boolean isPromoApplyForCash) {
        this.isPromoApplyForCash = isPromoApplyForCash;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }
}