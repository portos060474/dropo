package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.models.datamodels.OrderDetail;
import com.dropo.provider.models.datamodels.OrderHistoryDetail;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.StoreDetail;
import com.dropo.provider.models.datamodels.UserDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class OrderHistoryDetailResponse {

    @SerializedName("currency")
    private String currency;
    @SerializedName("success")
    private boolean success;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("request")
    private OrderHistoryDetail orderRequestDetail;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("user_detail")
    private UserDetail user;
    @SerializedName("store_detail")
    private StoreDetail storeDetail;
    @SerializedName("payment_gateway_name")
    private String payment;

    @SerializedName("order_detail")
    @Expose
    private OrderDetail orderDetail;

    @SerializedName("order_payment")
    private OrderPayment orderPaymentDetail;

    @SerializedName("cart_data")
    @Expose
    private Order cartDetail;

    @SerializedName("provider_rating_to_user")
    @Expose
    private double providerRattingToUser;

    @SerializedName("provider_rating_to_store")
    @Expose
    private double providerRattingToStore;

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

    public OrderHistoryDetail getOrderRequestDetail() {
        return orderRequestDetail;
    }

    public void setOrderRequestDetail(OrderHistoryDetail orderRequestDetail) {
        this.orderRequestDetail = orderRequestDetail;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public UserDetail getUser() {
        return user;
    }

    public void setUser(UserDetail user) {
        this.user = user;
    }

    public StoreDetail getStoreDetail() {
        return storeDetail;
    }

    public void setStoreDetail(StoreDetail storeDetail) {
        this.storeDetail = storeDetail;
    }

    public OrderDetail getOrderDetail() {
        return orderDetail;
    }

    public OrderPayment getOrderPaymentDetail() {
        return orderPaymentDetail;
    }

    public Order getCartDetail() {
        return cartDetail;
    }

    public double getProviderRattingToUser() {
        return providerRattingToUser;
    }

    public void setProviderRattingToUser(double providerRattingToUser) {
        this.providerRattingToUser = providerRattingToUser;
    }

    public double getProviderRattingToStore() {
        return providerRattingToStore;
    }

    public void setProviderRattingToStore(double providerRattingToStore) {
        this.providerRattingToStore = providerRattingToStore;
    }
}