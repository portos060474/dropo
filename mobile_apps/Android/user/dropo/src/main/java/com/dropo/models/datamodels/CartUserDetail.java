package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class CartUserDetail implements Parcelable {

    public static final Creator<CartUserDetail> CREATOR = new Creator<CartUserDetail>() {
        @Override
        public CartUserDetail createFromParcel(Parcel source) {
            return new CartUserDetail(source);
        }

        @Override
        public CartUserDetail[] newArray(int size) {
            return new CartUserDetail[size];
        }
    };
    @SerializedName("country_phone_code")
    private String countryPhoneCode;
    @SerializedName("phone")
    private String phone;
    @SerializedName("name")
    private String name;
    @SerializedName("email")
    private String email;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;

    public CartUserDetail() {
    }

    protected CartUserDetail(Parcel in) {
        this.countryPhoneCode = in.readString();
        this.phone = in.readString();
        this.name = in.readString();
        this.email = in.readString();
        this.imageUrl = in.readString();
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "CartUserDetail{" + "country_phone_code = '" + countryPhoneCode + '\'' + ",phone = '" + phone + '\'' + ",name = '" + name + '\'' + ",email = '" + email + '\'' + "}";
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.countryPhoneCode);
        dest.writeString(this.phone);
        dest.writeString(this.name);
        dest.writeString(this.email);
        dest.writeString(this.imageUrl);
    }
}