package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.models.datamodels.Status;
import com.dropo.provider.models.datamodels.UserDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;


public class OrderStatusResponse {

    @SerializedName("user_detail")
    @Expose
    private UserDetail userDetail;
    @SerializedName("delivery_status")
    @Expose
    private int deliveryStatus;
    @SerializedName("order_status")
    @Expose
    private int orderStatus;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("request")
    @Expose
    private Order orderRequest;
    @SerializedName("is_allow_contactless_delivery")
    @Expose
    private boolean isAllowContactLessDelivery;
    @SerializedName("is_distance_unit_mile")
    @Expose
    private boolean isDistanceUnitMile;
    @SerializedName("date_time")
    private ArrayList<Status> statusTime;

    public UserDetail getUserDetail() {
        return userDetail;
    }

    public void setUserDetail(UserDetail userDetail) {
        this.userDetail = userDetail;
    }

    public Order getOrderRequest() {
        return orderRequest;
    }

    public void setOrderRequest(Order orderRequest) {
        this.orderRequest = orderRequest;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getMessage() {
        return message;
    }

    public void setMessage(int message) {
        this.message = message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public boolean isAllowContactLessDelivery() {
        return isAllowContactLessDelivery;
    }

    public void setAllowContactLessDelivery(boolean allowContactLessDelivery) {
        isAllowContactLessDelivery = allowContactLessDelivery;
    }

    public boolean isDistanceUnitMile() {
        return isDistanceUnitMile;
    }

    public ArrayList<Status> getStatusTime() {
        return statusTime;
    }

    public void setStatusTime(ArrayList<Status> statusTime) {
        this.statusTime = statusTime;
    }
}