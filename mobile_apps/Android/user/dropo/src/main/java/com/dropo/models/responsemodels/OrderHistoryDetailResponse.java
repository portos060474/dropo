package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.OrderData;
import com.dropo.models.datamodels.OrderDetail;
import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.datamodels.Status;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.User;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class OrderHistoryDetailResponse {

    @SerializedName("currency")
    private String currency;
    @SerializedName("success")
    private boolean success;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("order_list")
    private OrderDetail orderDetail;

    @SerializedName("order_payment")
    private OrderPayment orderPaymentDetail;

    @SerializedName("cart_detail")
    @Expose
    private OrderData cartDetail;

    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("provider_detail")
    private User providerDetail;
    @SerializedName("store_detail")
    private Store store;
    @SerializedName("payment_gateway_name")
    private String payment;
    @SerializedName("date_time")
    private ArrayList<Status> statusTime;

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
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

    public OrderDetail getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(OrderDetail orderDetail) {
        this.orderDetail = orderDetail;
    }

    public User getProviderDetail() {
        return providerDetail;
    }

    public void setProviderDetail(User providerDetail) {
        this.providerDetail = providerDetail;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public ArrayList<Status> getStatusTime() {
        return statusTime;
    }

    public OrderPayment getOrderPaymentDetail() {
        return orderPaymentDetail;
    }

    public OrderData getCartDetail() {
        return cartDetail;
    }
}