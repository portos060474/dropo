package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class OrderDetail {

    @SerializedName("is_provider_rated_to_user")
    private boolean isProviderRatedToUser;

    @SerializedName("unique_id")
    private int uniqueId;

    @SerializedName("is_provider_rated_to_store")
    private boolean isProviderRatedToStore;

    @SerializedName("is_schedule_order")
    private boolean isScheduleOrder;

    @SerializedName("completed_at")
    private String completedAt;

    @SerializedName("is_user_rated_to_store")
    private boolean isUserRatedToStore;

    @SerializedName("order_status")
    private int orderStatus;

    @SerializedName("updated_at")
    private String updatedAt;

    @SerializedName("is_user_rated_to_provider")
    private boolean isUserRatedToProvider;

    @SerializedName("is_store_rated_to_provider")
    private boolean isStoreRatedToProvider;

    @SerializedName("_id")
    private String id;

    @SerializedName("is_store_rated_to_user")
    private boolean isStoreRatedToUser;

    @SerializedName("request_id")
    private String requestId;
    @SerializedName("date_time")
    private ArrayList<Status> statusTime;

    public boolean isProviderRatedToUser() {
        return isProviderRatedToUser;
    }

    public void setProviderRatedToUser(boolean providerRatedToUser) {
        isProviderRatedToUser = providerRatedToUser;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public boolean isProviderRatedToStore() {
        return isProviderRatedToStore;
    }

    public void setProviderRatedToStore(boolean providerRatedToStore) {
        isProviderRatedToStore = providerRatedToStore;
    }

    public boolean isScheduleOrder() {
        return isScheduleOrder;
    }

    public void setScheduleOrder(boolean scheduleOrder) {
        isScheduleOrder = scheduleOrder;
    }

    public String getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(String completedAt) {
        this.completedAt = completedAt;
    }

    public boolean isUserRatedToStore() {
        return isUserRatedToStore;
    }

    public void setUserRatedToStore(boolean userRatedToStore) {
        isUserRatedToStore = userRatedToStore;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isUserRatedToProvider() {
        return isUserRatedToProvider;
    }

    public void setUserRatedToProvider(boolean userRatedToProvider) {
        isUserRatedToProvider = userRatedToProvider;
    }

    public boolean isStoreRatedToProvider() {
        return isStoreRatedToProvider;
    }

    public void setStoreRatedToProvider(boolean storeRatedToProvider) {
        isStoreRatedToProvider = storeRatedToProvider;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isStoreRatedToUser() {
        return isStoreRatedToUser;
    }

    public void setStoreRatedToUser(boolean storeRatedToUser) {
        isStoreRatedToUser = storeRatedToUser;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public ArrayList<Status> getStatusTime() {
        return statusTime;
    }

    public void setStatusTime(ArrayList<Status> statusTime) {
        this.statusTime = statusTime;
    }
}