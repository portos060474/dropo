package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Addresses implements Parcelable {

    public static final Creator<Addresses> CREATOR = new Creator<Addresses>() {
        @Override
        public Addresses createFromParcel(Parcel source) {
            return new Addresses(source);
        }

        @Override
        public Addresses[] newArray(int size) {
            return new Addresses[size];
        }
    };
    @SerializedName("note")
    private String note;
    @SerializedName("address")
    private String address;
    @SerializedName("flat_no")
    private String flatNo;
    @SerializedName("street")
    private String street;
    @SerializedName("landmark")
    private String landmark;
    @SerializedName("user_type")
    private int userType;
    @SerializedName("address_type")
    private String addressType;
    @SerializedName("city")
    private String city;
    @SerializedName("user_details")
    private UserDetail userDetails;
    @SerializedName("location")
    private List<Double> location;
    @SerializedName("delivery_status")
    private int deliveryStatus;

    private String arrivedTime;

    public Addresses() {
    }

    protected Addresses(Parcel in) {
        this.note = in.readString();
        this.address = in.readString();
        this.flatNo = in.readString();
        this.street = in.readString();
        this.landmark = in.readString();
        this.userType = in.readInt();
        this.addressType = in.readString();
        this.city = in.readString();
        this.userDetails = in.readParcelable(UserDetail.class.getClassLoader());
        this.location = new ArrayList<>();
        in.readList(this.location, Double.class.getClassLoader());
        this.deliveryStatus = in.readInt();
        this.arrivedTime = in.readString();
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public String getAddressType() {
        return addressType;
    }

    public void setAddressType(String addressType) {
        this.addressType = addressType;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public UserDetail getUserDetails() {
        return userDetails;
    }

    public void setUserDetails(UserDetail userDetails) {
        this.userDetails = userDetails;
    }

    public List<Double> getLocation() {
        return location;
    }

    public void setLocation(List<Double> location) {
        this.location = location;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public String getFlatNo() {
        return flatNo;
    }

    public void setFlatNo(String flatNo) {
        this.flatNo = flatNo;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getLandmark() {
        return landmark;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public String getArrivedTime() {
        return arrivedTime;
    }

    public void setArrivedTime(String arrivedTime) {
        this.arrivedTime = arrivedTime;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.note);
        dest.writeString(this.address);
        dest.writeString(this.flatNo);
        dest.writeString(this.street);
        dest.writeString(this.landmark);
        dest.writeInt(this.userType);
        dest.writeString(this.addressType);
        dest.writeString(this.city);
        dest.writeParcelable(this.userDetails, flags);
        dest.writeList(this.location);
        dest.writeInt(this.deliveryStatus);
        dest.writeString(this.arrivedTime);
    }
}