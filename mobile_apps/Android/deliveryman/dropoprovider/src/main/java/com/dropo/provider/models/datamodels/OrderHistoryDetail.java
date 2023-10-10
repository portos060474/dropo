package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class OrderHistoryDetail {
    @SerializedName("completed_at")
    private String completedAt;
    @SerializedName("provider_type")
    private int providerType;
    @SerializedName("order_status_id")
    private int orderStatusId;
    @SerializedName("promo_code")
    private String promoCode;
    @SerializedName("current_provider")
    private String currentProvider;
    @SerializedName("order_status")
    private int orderStatus;
    @SerializedName("user_type")
    private int userType;
    @SerializedName("order_type")
    private int orderType;
    @SerializedName("unique_code")
    private int uniqueCode;
    @SerializedName("unique_id")
    private int uniqueId;
    @SerializedName("user_id")
    private String userId;
    @SerializedName("_id")
    private String id;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("total_order_price")
    private double totalOrderPrice;
    @SerializedName("is_schedule_order")
    private boolean isScheduleOrder;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("order_payment_id")
    private String orderPaymentId;
    @SerializedName("store_id")
    private String storeId;
    @SerializedName("admin_currency")
    private String adminCurrency;
    @SerializedName("store_notify")
    private int storeNotify;
    @SerializedName("date_time")
    private ArrayList<Status> statusTime;
    @SerializedName("delivery_type")
    private int deliveryType;
    @SerializedName("pickup_addresses")
    @Expose
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    @Expose

    private List<Addresses> destinationAddresses;

    public int getProviderType() {
        return providerType;
    }

    public void setProviderType(int providerType) {
        this.providerType = providerType;
    }

    public int getOrderStatusId() {
        return orderStatusId;
    }

    public void setOrderStatusId(int orderStatusId) {
        this.orderStatusId = orderStatusId;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public String getCurrentProvider() {
        return currentProvider;
    }

    public void setCurrentProvider(String currentProvider) {
        this.currentProvider = currentProvider;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public int getOrderType() {
        return orderType;
    }

    public void setOrderType(int orderType) {
        this.orderType = orderType;
    }

    public int getUniqueCode() {
        return uniqueCode;
    }

    public void setUniqueCode(int uniqueCode) {
        this.uniqueCode = uniqueCode;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public void setTotalOrderPrice(double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public boolean isIsScheduleOrder() {
        return isScheduleOrder;
    }

    public void setIsScheduleOrder(boolean isScheduleOrder) {
        this.isScheduleOrder = isScheduleOrder;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }


    public String getOrderPaymentId() {
        return orderPaymentId;
    }

    public void setOrderPaymentId(String orderPaymentId) {
        this.orderPaymentId = orderPaymentId;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }


    public String getAdminCurrency() {
        return adminCurrency;
    }

    public void setAdminCurrency(String adminCurrency) {
        this.adminCurrency = adminCurrency;
    }

    public int getStoreNotify() {
        return storeNotify;
    }

    public void setStoreNotify(int storeNotify) {
        this.storeNotify = storeNotify;
    }

    public String getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(String completedAt) {
        this.completedAt = completedAt;
    }

    public ArrayList<Status> getStatusTime() {
        return statusTime;
    }

    public void setStatusTime(ArrayList<Status> statusTime) {
        this.statusTime = statusTime;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
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
}