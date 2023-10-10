package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class OrderHistory {
    @SerializedName("total_service_price")
    private double totalServicePrice;
    @SerializedName("total")
    private double total;
    @SerializedName("order_status")
    private int orderStatus;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("store_detail")
    private Store storeDetail;
    @SerializedName("total_order_price")
    private double totalOrderPrice;
    @SerializedName("currency")
    private String currency = "";
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("refund_amount")
    @Expose
    private double refundAmount;
    @SerializedName("_id")
    private String id;
    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;
    @SerializedName("delivery_type")
    private int deliveryType;
    @SerializedName("date_time")
    private ArrayList<Status> dateTime;

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
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

    public Store getStoreDetail() {
        return storeDetail;
    }

    public void setStoreDetail(Store storeDetail) {
        this.storeDetail = storeDetail;
    }

    public double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public void setTotalOrderPrice(double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }


    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
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

    public double getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(double refundAmount) {
        this.refundAmount = refundAmount;
    }

    public List<Addresses> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(List<Addresses> destinationAddresses) {
        this.destinationAddresses = destinationAddresses;
    }

    public ArrayList<Status> getDateTime() {
        return dateTime;
    }

    public void setDateTime(ArrayList<Status> dateTime) {
        this.dateTime = dateTime;
    }
}