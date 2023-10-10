package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Vehicle {

    private boolean isSelected;
    @SerializedName("is_business")
    private boolean isBusiness;
    @SerializedName("unique_id")
    private int uniqueId;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("delivery_type")
    private List<Object> deliveryType;
    @SerializedName("image_url")
    private String imageUrl;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("map_pin_image_url")
    private String mapPinImageUrl;
    @SerializedName("description")
    private String description;
    @SerializedName("_id")
    private String id;
    @SerializedName("delivery_type_id")
    private List<Object> deliveryTypeId;
    @SerializedName("vehicle_name")
    private String vehicleName;
    @SerializedName("price_per_unit_distance")
    private double pricePerUnitDistance;
    @SerializedName("is_round_trip")
    private boolean isRoundTrip;
    @SerializedName("round_trip_charge")
    private double roundTripCharge;
    @SerializedName("additional_stop_price")
    private double additionalStopPrice;
    @SerializedName("size_type")
    private int sizeType;
    @SerializedName("weight_type")
    private int weightType;
    @SerializedName("length")
    private double length;
    @SerializedName("width")
    private double width;
    @SerializedName("height")
    private double height;
    @SerializedName("min_weight")
    private double minWeight;
    @SerializedName("max_weight")
    private double maxWeight;

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public double getPricePerUnitDistance() {
        return pricePerUnitDistance;
    }

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

    public List<Object> getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(List<Object> deliveryType) {
        this.deliveryType = deliveryType;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public List<Object> getDeliveryTypeId() {
        return deliveryTypeId;
    }

    public void setDeliveryTypeId(List<Object> deliveryTypeId) {
        this.deliveryTypeId = deliveryTypeId;
    }

    public String getVehicleName() {
        return vehicleName;
    }

    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public boolean isBusiness() {
        return isBusiness;
    }

    public void setBusiness(boolean business) {
        isBusiness = business;
    }

    public void setPricePerUnitDistance(double pricePerUnitDistance) {
        this.pricePerUnitDistance = pricePerUnitDistance;
    }

    public boolean isRoundTrip() {
        return isRoundTrip;
    }

    public void setRoundTrip(boolean roundTrip) {
        isRoundTrip = roundTrip;
    }

    public double getRoundTripCharge() {
        return roundTripCharge;
    }

    public void setRoundTripCharge(double roundTripCharge) {
        this.roundTripCharge = roundTripCharge;
    }

    public double getAdditionalStopPrice() {
        return additionalStopPrice;
    }

    public void setAdditionalStopPrice(double additionalStopPrice) {
        this.additionalStopPrice = additionalStopPrice;
    }

    public int getSizeType() {
        return sizeType;
    }

    public void setSizeType(int sizeType) {
        this.sizeType = sizeType;
    }

    public int getWeightType() {
        return weightType;
    }

    public void setWeightType(int weightType) {
        this.weightType = weightType;
    }

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    public double getMinWeight() {
        return minWeight;
    }

    public void setMinWeight(double minWeight) {
        this.minWeight = minWeight;
    }

    public double getMaxWeight() {
        return maxWeight;
    }

    public void setMaxWeight(double maxWeight) {
        this.maxWeight = maxWeight;
    }
}