package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.OrderDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;


public class OrderDetailResponse {

    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("order")
    @Expose
    private OrderDetail orderDetail;

    public OrderDetail getOrderDetail() {
        return orderDetail;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public boolean isSuccess() {
        return success;
    }

    public int getMessage() {
        return message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }
}
