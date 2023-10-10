package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class RemainingReview {

    @SerializedName("order_unique_id")
    private int orderUniqueId;

    @SerializedName("_id")
    private String id;

    @SerializedName("order_id")
    private String orderId;

    public int getOrderUniqueId() {
        return orderUniqueId;
    }

    public void setOrderUniqueId(int orderUniqueId) {
        this.orderUniqueId = orderUniqueId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    @Override
    public String toString() {
        return "RemainingReview{" + "order_unique_id = '" + orderUniqueId + '\'' + ",_id = '" + id + '\'' + ",order_id = '" + orderId + '\'' + "}";
    }
}