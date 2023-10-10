package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class VehicleDetail implements Parcelable {

    public static final Creator<VehicleDetail> CREATOR = new Creator<VehicleDetail>() {
        @Override
        public VehicleDetail createFromParcel(Parcel in) {
            return new VehicleDetail(in);
        }

        @Override
        public VehicleDetail[] newArray(int size) {
            return new VehicleDetail[size];
        }
    };
    private boolean isSelected;
    @SerializedName("is_business")
    private boolean isBusiness;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("delivery_type")
    private List<String> deliveryType;
    @SerializedName("image_url")
    private String imageUrl;
    @SerializedName("description")
    private String description;
    @SerializedName("map_pin_image_url")
    private String mapPinImageUrl;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("_id")
    private String id;
    @SerializedName("vehicle_name")
    private String vehicleName;

    public VehicleDetail() {
    }

    protected VehicleDetail(Parcel in) {
        isSelected = in.readByte() != 0;
        isBusiness = in.readByte() != 0;
        updatedAt = in.readString();
        deliveryType = in.createStringArrayList();
        imageUrl = in.readString();
        description = in.readString();
        mapPinImageUrl = in.readString();
        createdAt = in.readString();
        id = in.readString();
        vehicleName = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte((byte) (isSelected ? 1 : 0));
        dest.writeByte((byte) (isBusiness ? 1 : 0));
        dest.writeString(updatedAt);
        dest.writeStringList(deliveryType);
        dest.writeString(imageUrl);
        dest.writeString(description);
        dest.writeString(mapPinImageUrl);
        dest.writeString(createdAt);
        dest.writeString(id);
        dest.writeString(vehicleName);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<String> getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(List<String> deliveryType) {
        this.deliveryType = deliveryType;
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

    public String getMapPinImageUrl() {
        return mapPinImageUrl;
    }

    public void setMapPinImageUrl(String mapPinImageUrl) {
        this.mapPinImageUrl = mapPinImageUrl;
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

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    @Override
    public String toString() {
        return "VehicleDetail{" + "is_business = '" + isBusiness + '\'' + ",updated_at = '" + updatedAt + '\'' + ",delivery_type = '" + deliveryType + '\'' + ",image_url = '" + imageUrl + '\'' + ",description = '" + description + '\'' + ",map_pin_image_url = '" + mapPinImageUrl + '\'' + ",created_at = '" + createdAt + '\'' + ",_id = '" + id + '\'' + ",vehicle_name = '" + vehicleName + '\'' + "}";
    }
}