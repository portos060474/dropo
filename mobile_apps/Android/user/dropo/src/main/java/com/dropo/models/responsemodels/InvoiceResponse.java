package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.Service;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.UnavailableItems;
import com.dropo.models.datamodels.User;
import com.dropo.models.datamodels.Vehicle;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class InvoiceResponse {

    @SerializedName("vehicles")
    private List<Vehicle> vehicleList;
    @SerializedName("min_order_price")
    private double minOrderPrice;
    @SerializedName("currency")
    private String currency;
    @SerializedName("payment_gateway_name")
    private String payment;
    @SerializedName("order_payment")
    private OrderPayment orderPayment;
    @SerializedName("store")
    private Store store;
    @SerializedName("server_time")
    private String serverTime;
    @SerializedName("timezone")
    private String timezone;
    @SerializedName("success")
    private boolean success;
    @SerializedName("service")
    private Service service;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    private int errorCode;
    @SerializedName("is_allow_contactless_delivery")
    private boolean isAllowContaclLessDelivery;
    @SerializedName("is_allow_user_to_give_tip")
    private boolean isAllowUserToGiveTip;
    @SerializedName("tip_type")
    private int tipType;
    @SerializedName("provider_detail")
    private User providerDetail;
    @SerializedName("is_tax_included")
    private boolean isTaxIncluded;
    @SerializedName("item_detail")
    private ProductItem productItem;
    @SerializedName("unavailable_items")
    private List<UnavailableItems> unavailableItems;
    @SerializedName("unavailable_products")
    private List<UnavailableItems> unavailableProducts;

    public List<Vehicle> getVehicleList() {
        return vehicleList;
    }

    public void setVehicleList(List<Vehicle> vehicleList) {
        this.vehicleList = vehicleList;
    }

    public double getMinOrderPrice() {
        return minOrderPrice;
    }

    public void setMinOrderPrice(double minOrderPrice) {
        this.minOrderPrice = minOrderPrice;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public OrderPayment getOrderPayment() {
        return orderPayment;
    }

    public void setOrderPayment(OrderPayment orderPayment) {
        this.orderPayment = orderPayment;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Service getService() {
        return service;
    }

    public void setService(Service service) {
        this.service = service;
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

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public String getTimezone() {
        return timezone;
    }

    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }

    public boolean isAllowContaclLessDelivery() {
        return isAllowContaclLessDelivery;
    }

    public void setAllowContaclLessDelivery(boolean allowContaclLessDelivery) {
        isAllowContaclLessDelivery = allowContaclLessDelivery;
    }

    public boolean isAllowUserToGiveTip() {
        return isAllowUserToGiveTip;
    }

    public int getTipType() {
        return tipType;
    }

    public User getProviderDetail() {
        return providerDetail;
    }

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setAllowUserToGiveTip(boolean allowUserToGiveTip) {
        isAllowUserToGiveTip = allowUserToGiveTip;
    }

    public void setTipType(int tipType) {
        this.tipType = tipType;
    }

    public void setProviderDetail(User providerDetail) {
        this.providerDetail = providerDetail;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public ProductItem getProductItem() {
        return productItem;
    }

    public void setProductItem(ProductItem productItem) {
        this.productItem = productItem;
    }

    public List<UnavailableItems> getUnavailableItems() {
        return unavailableItems;
    }

    public void setUnavailableItems(List<UnavailableItems> unavailableItems) {
        this.unavailableItems = unavailableItems;
    }

    public List<UnavailableItems> getUnavailableProducts() {
        return unavailableProducts;
    }

    public void setUnavailableProducts(List<UnavailableItems> unavailableProducts) {
        this.unavailableProducts = unavailableProducts;
    }
}