package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class UserDetail implements Parcelable {

    public static final Creator<UserDetail> CREATOR = new Creator<UserDetail>() {
        @Override
        public UserDetail createFromParcel(Parcel source) {
            return new UserDetail(source);
        }

        @Override
        public UserDetail[] newArray(int size) {
            return new UserDetail[size];
        }
    };
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("image_url")
    @Expose
    private String imageUrl = "";
    @SerializedName("last_name")
    @Expose
    private String lastName;
    @SerializedName("country_phone_code")
    @Expose
    private String countryPhoneCode;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("first_name")
    @Expose
    private String firstName;
    @SerializedName("country_id")
    @Expose
    private String countryId;
    @SerializedName("city_id")
    @Expose
    private String cityId;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("email")
    @Expose
    private String email;

    public UserDetail() {
    }

    protected UserDetail(Parcel in) {
        this.uniqueId = in.readInt();
        this.address = in.readString();
        this.imageUrl = in.readString();
        this.lastName = in.readString();
        this.countryPhoneCode = in.readString();
        this.phone = in.readString();
        this.id = in.readString();
        this.firstName = in.readString();
        this.countryId = in.readString();
        this.cityId = in.readString();
        this.name = in.readString();
        this.email = in.readString();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getCountryPhoneCode() {
        return countryPhoneCode;
    }

    public void setCountryPhoneCode(String countryPhoneCode) {
        this.countryPhoneCode = countryPhoneCode;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.uniqueId);
        dest.writeString(this.address);
        dest.writeString(this.imageUrl);
        dest.writeString(this.lastName);
        dest.writeString(this.countryPhoneCode);
        dest.writeString(this.phone);
        dest.writeString(this.id);
        dest.writeString(this.firstName);
        dest.writeString(this.countryId);
        dest.writeString(this.cityId);
        dest.writeString(this.name);
        dest.writeString(this.email);
    }
}