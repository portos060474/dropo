package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by elluminati on 18-Apr-17.
 */

public class ProductDetail implements Parcelable {


    public static final Creator<ProductDetail> CREATOR = new Creator<ProductDetail>() {
        @Override
        public ProductDetail createFromParcel(Parcel source) {
            return new ProductDetail(source);
        }

        @Override
        public ProductDetail[] newArray(int size) {
            return new ProductDetail[size];
        }
    };
    @SerializedName("unique_id")
    private int uniqueId;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("image_url")
    private String imageUrl;
    @SerializedName("name")
    private String name;
    @SerializedName("details")
    private String details;
    @SerializedName("_id")
    private String id;
    @SerializedName("sequence_number")
    private long sequenceNumber;

    public ProductDetail() {
    }

    protected ProductDetail(Parcel in) {
        this.uniqueId = in.readInt();
        this.updatedAt = in.readString();
        this.imageUrl = in.readString();
        this.name = in.readString();
        this.details = in.readString();
        this.id = in.readString();
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
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

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.uniqueId);
        dest.writeString(this.updatedAt);
        dest.writeString(this.imageUrl);
        dest.writeString(this.name);
        dest.writeString(this.details);
        dest.writeString(this.id);
    }

    public long getSequenceNumber() {
        return sequenceNumber;
    }
}
