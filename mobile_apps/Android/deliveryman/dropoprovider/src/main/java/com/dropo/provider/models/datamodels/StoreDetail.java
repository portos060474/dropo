package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class StoreDetail implements Parcelable {

    public static final Parcelable.Creator<StoreDetail> CREATOR = new Parcelable.Creator<StoreDetail>() {
        @Override
        public StoreDetail createFromParcel(Parcel source) {
            return new StoreDetail(source);
        }

        @Override
        public StoreDetail[] newArray(int size) {
            return new StoreDetail[size];
        }
    };
    @SerializedName("image_url")
    private String imageUrl;
    @SerializedName("name")
    private String name;

    public StoreDetail() {
    }

    protected StoreDetail(Parcel in) {
        this.imageUrl = in.readString();
        this.name = in.readString();
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.imageUrl);
        dest.writeString(this.name);
    }
}