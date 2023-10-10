package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class Address implements Parcelable {

    //    @PrimaryKey(autoGenerate = true)
    @SerializedName("_id")
    private String id;
    @SerializedName("address_title")
    private String addressTitle;
    @SerializedName("country")
    private String country;
    @SerializedName("country_code")
    private String countryCode;
    @SerializedName("city")
    private String city;
    @SerializedName("sub_admin_area")
    private String subAdminArea;
    @SerializedName("admin_area")
    private String adminArea;
    @SerializedName("latitude")
    private String latitude;
    @SerializedName("longitude")
    private String longitude;
    @SerializedName("address_name")
    private String addressName;
    @SerializedName("address")
    private String address;
    @SerializedName("city_code")
    private String cityCode;
    @SerializedName("landmark")
    private String landmark;
    @SerializedName("street")
    private String street;
    @SerializedName("flat_no")
    private String flat_no;

    public Address() {
    }


    protected Address(Parcel in) {
        id = in.readString();
        addressTitle = in.readString();
        country = in.readString();
        countryCode = in.readString();
        city = in.readString();
        subAdminArea = in.readString();
        adminArea = in.readString();
        latitude = in.readString();
        longitude = in.readString();
        addressName = in.readString();
        address = in.readString();
        cityCode = in.readString();
        landmark = in.readString();
        street = in.readString();
        flat_no = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(id);
        dest.writeString(addressTitle);
        dest.writeString(country);
        dest.writeString(countryCode);
        dest.writeString(city);
        dest.writeString(subAdminArea);
        dest.writeString(adminArea);
        dest.writeString(latitude);
        dest.writeString(longitude);
        dest.writeString(addressName);
        dest.writeString(address);
        dest.writeString(cityCode);
        dest.writeString(landmark);
        dest.writeString(street);
        dest.writeString(flat_no);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<Address> CREATOR = new Creator<Address>() {
        @Override
        public Address createFromParcel(Parcel in) {
            return new Address(in);
        }

        @Override
        public Address[] newArray(int size) {
            return new Address[size];
        }
    };

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getSubAdminArea() {
        return subAdminArea;
    }

    public void setSubAdminArea(String subAdminArea) {
        this.subAdminArea = subAdminArea;
    }

    public String getAdminArea() {
        return adminArea;
    }

    public void setAdminArea(String adminArea) {
        this.adminArea = adminArea;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public String getAddressTitle() {
        return addressTitle;
    }

    public void setAddressTitle(String addressTitle) {
        this.addressTitle = addressTitle;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getAddressName() {
        return addressName;
    }

    public void setAddressName(String addressName) {
        this.addressName = addressName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getFlat_no() {
        return flat_no;
    }

    public void setFlat_no(String flat_no) {
        this.flat_no = flat_no;
    }

}