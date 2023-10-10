package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.Addresses;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class PushDataResponse {


    @SerializedName("total")
    @Expose
    private double total;

    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;

    @SerializedName("order_unique_id")
    @Expose
    private int orderUniqueId;
    @SerializedName("estimated_time_for_ready_order")
    @Expose

    private String estimatedTimeForReadyOrder;
    @SerializedName("currency")
    @Expose
    private String currency = "$";
    @SerializedName("total_provider_income")
    @Expose
    private double totalProviderIncome;
    @SerializedName("total_order_price")
    @Expose
    private double totalOrderPrice;
    @SerializedName("order_count")
    @Expose
    private int orderCount;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("pickup_addresses")
    @Expose
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    @Expose

    private List<Addresses> destinationAddresses;
    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("request_id")
    private String requestId;
    @SerializedName("store_image")
    private String storeImage;

    @SerializedName("is_schedule_order")
    private boolean isScheduleOrder;

    public int getOrderUniqueId() {
        return orderUniqueId;
    }

    public void setOrderUniqueId(int orderUniqueId) {
        this.orderUniqueId = orderUniqueId;
    }

    public String getEstimatedTimeForReadyOrder() {
        return estimatedTimeForReadyOrder;
    }

    public void setEstimatedTimeForReadyOrder(String estimatedTimeForReadyOrder) {
        this.estimatedTimeForReadyOrder = estimatedTimeForReadyOrder;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public double getTotalProviderIncome() {
        return totalProviderIncome;
    }

    public void setTotalProviderIncome(double totalProviderIncome) {
        this.totalProviderIncome = totalProviderIncome;
    }

    public double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public void setTotalOrderPrice(double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public List<Addresses> getPickupAddresses() {
        return pickupAddresses;
    }

    public void setPickupAddresses(List<Addresses> pickupAddresses) {
        this.pickupAddresses = pickupAddresses;
    }

    public List<Addresses> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(List<Addresses> destinationAddresses) {
        this.destinationAddresses = destinationAddresses;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public String getStoreImage() {
        return storeImage;
    }

    public void setStoreImage(String storeImage) {
        this.storeImage = storeImage;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public boolean isScheduleOrder() {
        return isScheduleOrder;
    }
}