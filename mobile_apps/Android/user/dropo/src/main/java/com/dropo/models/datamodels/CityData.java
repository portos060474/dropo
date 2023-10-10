package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class CityData {

    @SerializedName("country_code_2")
    private String countryCode2;

    @SerializedName("cityCode")
    private String cityCode;
    @SerializedName("country_code")
    private String countryCode;

    @SerializedName("country")
    private String country;

    @SerializedName("city1")
    private String city1;

    @SerializedName("city2")
    private String city2;

    @SerializedName("latitude")
    private double latitude;

    @SerializedName("city3")
    private String city3;

    @SerializedName("longitude")
    private double longitude;

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCity1() {
        return city1;
    }

    public void setCity1(String city1) {
        this.city1 = city1;
    }

    public String getCity2() {
        return city2;
    }

    public void setCity2(String city2) {
        this.city2 = city2;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public String getCity3() {
        return city3;
    }

    public void setCity3(String city3) {
        this.city3 = city3;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    @Override
    public String toString() {
        return "CityData{" + "country_code = '" + countryCode + '\'' + ",country = '" + country + '\'' + ",city1 = '" + city1 + '\'' + ",city2 = '" + city2 + '\'' + ",latitude = '" + latitude + '\'' + ",city3 = '" + city3 + '\'' + ",longitude = '" + longitude + '\'' + "}";
    }

    public String getCountryCode2() {
        return countryCode2;
    }

    public void setCountryCode2(String countryCode2) {
        this.countryCode2 = countryCode2;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }
}