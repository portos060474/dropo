package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class OrderHistory {


    @SerializedName("completed_at")
    private String completedAt;
    @SerializedName("total_service_price")
    private double totalServicePrice;
    @SerializedName("total")
    private double total;
    @SerializedName("provider_profit")
    private double providerProfit;
    @SerializedName("delivery_status")
    private int deliveryStatus;
    @SerializedName("unique_id")
    private int uniqueId;
    @SerializedName("user_detail")
    private UserDetail userDetail;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("currency")
    private String currency;
    @SerializedName("_id")
    private String id;
    @SerializedName("total_order_price")
    private double totalOrderPrice;
    @SerializedName("store_detail")
    private StoreDetail storeDetail;

    @SerializedName("delivery_type")
    private int deliveryType;

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public String getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(String completedAt) {
        this.completedAt = completedAt;
    }

    public UserDetail getUserDetail() {
        return userDetail;
    }

    public void setUserDetail(UserDetail userDetail) {
        this.userDetail = userDetail;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public void setTotalOrderPrice(double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public StoreDetail getStoreDetail() {
        return storeDetail;
    }

    public void setStoreDetail(StoreDetail storeDetail) {
        this.storeDetail = storeDetail;
    }


    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public double getProviderProfit() {
        return providerProfit;
    }

    public void setProviderProfit(double providerProfit) {
        this.providerProfit = providerProfit;
    }

    public double getTotalServicePrice() {
        return totalServicePrice;
    }

    public void setTotalServicePrice(double totalServicePrice) {
        this.totalServicePrice = totalServicePrice;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}