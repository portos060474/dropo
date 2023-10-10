package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class VehicleDetail {

    @SerializedName("is_business")
    private boolean isBusiness;

    @SerializedName("unique_id")
    private int uniqueId;

    @SerializedName("updated_at")
    private String updatedAt;

    @SerializedName("image_url")
    private String imageUrl;

    @SerializedName("__v")
    private int V;

    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("map_pin_image_url")
    private String mapPinImageUrl;

    @SerializedName("description")
    private String description;

    @SerializedName("_id")
    private String id;

    @SerializedName("vehicle_name")
    private String vehicleName;

    @SerializedName("delivery_type_id")
    private List<Object> deliveryTypeId;

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
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

    public int getV() {
        return V;
    }

    public void setV(int V) {
        this.V = V;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getMapPinImageUrl() {
        return mapPinImageUrl;
    }

    public void setMapPinImageUrl(String mapPinImageUrl) {
        this.mapPinImageUrl = mapPinImageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public List<Object> getDeliveryTypeId() {
        return deliveryTypeId;
    }

    public void setDeliveryTypeId(List<Object> deliveryTypeId) {
        this.deliveryTypeId = deliveryTypeId;
    }

    @Override
    public String toString() {
        return "VehicleDetail{" + "is_business = '" + isBusiness + '\'' + ",unique_id = '" + uniqueId + '\'' + ",updated_at = '" + updatedAt + '\'' + ",image_url = '" + imageUrl + '\'' + ",__v = '" + V + '\'' + ",created_at = '" + createdAt + '\'' + ",map_pin_image_url = '" + mapPinImageUrl + '\'' + ",description = '" + description + '\'' + ",_id = '" + id + '\'' + ",vehicle_name = '" + vehicleName + '\'' + ",delivery_type_id = '" + deliveryTypeId + '\'' + "}";
    }
}