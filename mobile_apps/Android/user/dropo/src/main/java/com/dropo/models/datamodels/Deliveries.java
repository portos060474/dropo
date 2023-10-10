package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class Deliveries implements Parcelable {

    public static final Creator<Deliveries> CREATOR = new Creator<Deliveries>() {
        @Override
        public Deliveries createFromParcel(Parcel source) {
            return new Deliveries(source);
        }

        @Override
        public Deliveries[] newArray(int size) {
            return new Deliveries[size];
        }
    };
    @SerializedName("famous_products_tags")
    @Expose
    private ArrayList<FamousProductsTags> famousProductsTags = new ArrayList<>();
    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;
    @SerializedName("map_pin_url")
    @Expose
    private String mapPinUrl;
    @SerializedName("icon_url")
    @Expose
    private String iconUrl;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;
    @SerializedName("delivery_name")
    @Expose
    private String deliveryName;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("description")
    @Expose
    private String description;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("is_store_can_create_group")
    @Expose
    private boolean isStoreCanCreateGroup;
    @SerializedName("is_provide_table_booking")
    @Expose
    private boolean isProvideTableBooking;


    public Deliveries() {
    }

    protected Deliveries(Parcel in) {
        this.famousProductsTags = in.createTypedArrayList(FamousProductsTags.CREATOR);
        this.isBusiness = in.readByte() != 0;
        this.mapPinUrl = in.readString();
        this.iconUrl = in.readString();
        this.updatedAt = in.readString();
        this.deliveryType = in.readInt();
        this.deliveryName = in.readString();
        this.imageUrl = in.readString();
        this.description = in.readString();
        this.createdAt = in.readString();
        this.id = in.readString();
        this.isStoreCanCreateGroup = in.readByte() != 0;
        this.isProvideTableBooking = in.readByte() != 0;
    }

    public ArrayList<FamousProductsTags> getFamousProductsTags() {
        return famousProductsTags;
    }

    public void setFamousProductsTags(ArrayList<FamousProductsTags> famousProductsTags) {
        this.famousProductsTags = famousProductsTags;
    }

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public String getDeliveryName() {
        return deliveryName;
    }

    public void setDeliveryName(String deliveryName) {
        this.deliveryName = deliveryName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getMapPinUrl() {
        return mapPinUrl;
    }

    public void setMapPinUrl(String mapPinUrl) {
        this.mapPinUrl = mapPinUrl;
    }

    public boolean isStoreCanCreateGroup() {
        return isStoreCanCreateGroup;
    }

    public void setStoreCanCreateGroup(boolean storeCanCreateGroup) {
        isStoreCanCreateGroup = storeCanCreateGroup;
    }

    public boolean isProvideTableBooking() {
        return isProvideTableBooking;
    }

    public void setProvideTableBooking(boolean provideTableBooking) {
        isProvideTableBooking = provideTableBooking;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.famousProductsTags);
        dest.writeByte(this.isBusiness ? (byte) 1 : (byte) 0);
        dest.writeString(this.mapPinUrl);
        dest.writeString(this.iconUrl);
        dest.writeString(this.updatedAt);
        dest.writeInt(this.deliveryType);
        dest.writeString(this.deliveryName);
        dest.writeString(this.imageUrl);
        dest.writeString(this.description);
        dest.writeString(this.createdAt);
        dest.writeString(this.id);
        dest.writeByte(this.isStoreCanCreateGroup ? (byte) 1 : (byte) 0);
        dest.writeByte((byte) (this.isProvideTableBooking ? 1 : 0));
    }
}