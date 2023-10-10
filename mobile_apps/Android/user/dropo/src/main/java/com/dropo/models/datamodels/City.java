package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class City implements Parcelable {

    public static final Parcelable.Creator<City> CREATOR = new Parcelable.Creator<City>() {
        @Override
        public City createFromParcel(Parcel source) {
            return new City(source);
        }

        @Override
        public City[] newArray(int size) {
            return new City[size];
        }
    };
    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;
    @SerializedName("payment_gateway")
    @Expose
    private List<String> paymentGateway;
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
    private List<String> deliveriesInCity;
    @SerializedName("city_lat_long")
    @Expose
    private List<Double> cityLatLong;
    @SerializedName("city_name")
    @Expose
    private String cityName;
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
    @SerializedName("country_id")
    @Expose
    private String countryId;

    public City() {
    }

    protected City(Parcel in) {
        this.isBusiness = in.readByte() != 0;
        this.paymentGateway = in.createStringArrayList();
        this.timezone = in.readString();
        this.cityCode = in.readString();
        this.createdAt = in.readString();
        this.deliveriesInCity = in.createStringArrayList();
        this.cityLatLong = new ArrayList<Double>();
        in.readList(this.cityLatLong, Double.class.getClassLoader());
        this.cityName = in.readString();
        this.updatedAt = in.readString();
        this.V = in.readInt();
        this.isCashPaymentMode = in.readByte() != 0;
        this.isOtherPaymentMode = in.readByte() != 0;
        this.cityRadius = in.readDouble();
        this.id = in.readString();
        this.countryId = in.readString();
    }

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public List<String> getPaymentGateway() {
        return paymentGateway;
    }

    public void setPaymentGateway(List<String> paymentGateway) {
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

    public List<String> getDeliveriesInCity() {
        return deliveriesInCity;
    }

    public void setDeliveriesInCity(List<String> deliveriesInCity) {
        this.deliveriesInCity = deliveriesInCity;
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

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isBusiness ? (byte) 1 : (byte) 0);
        dest.writeStringList(this.paymentGateway);
        dest.writeString(this.timezone);
        dest.writeString(this.cityCode);
        dest.writeString(this.createdAt);
        dest.writeStringList(this.deliveriesInCity);
        dest.writeList(this.cityLatLong);
        dest.writeString(this.cityName);
        dest.writeString(this.updatedAt);
        dest.writeInt(this.V);
        dest.writeByte(this.isCashPaymentMode ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isOtherPaymentMode ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.cityRadius);
        dest.writeString(this.id);
        dest.writeString(this.countryId);
    }
}