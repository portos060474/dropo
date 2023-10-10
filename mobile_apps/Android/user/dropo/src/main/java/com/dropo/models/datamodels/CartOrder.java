package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class CartOrder {

    @SerializedName("country_id")
    private String countryId;

    @SerializedName("order_id")
    private String orderId;

    @SerializedName("city_id")
    private String cityId;

    @SerializedName("delivery_type")
    private Integer deliveryType;
    @SerializedName("user_type")
    private int userType;
    @SerializedName("cart_unique_token")
    @Expose
    private String androidId;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("pickup_addresses")
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;
    @SerializedName("user_id")
    @Expose
    private String userId;
    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("order_details")
    @Expose
    private List<CartProducts> products;
    @SerializedName("total_item_tax")
    @Expose
    private double cartOrderTotalTaxPrice;
    @SerializedName("total_cart_price")
    @Expose
    private double cartOrderTotalPrice;
    @SerializedName("order_payment_id")
    @Expose
    private String orderPaymentId;

    @SerializedName("total_item_count")
    @Expose
    private long totalItemCount;

    @SerializedName("is_tax_included")
    @Expose
    private Boolean isTaxIncluded = false;

    @SerializedName("is_use_item_tax")
    @Expose
    private Boolean isUseItemTax = false;

    @SerializedName("tax_details")
    @Expose
    private ArrayList<TaxesDetail> taxesDetails;

    @SerializedName("total_cart_amout_without_tax")
    private double totalCartAmoutWithoutTax;

    @SerializedName("table_no")
    private int tableNo;

    @SerializedName("no_of_persons")
    private int noOfPersons;

    @SerializedName("booking_type")
    private int bookingType;

    @SerializedName("order_start_at")
    private long orderStartAt;

    @SerializedName("order_start_at2")
    private long orderStartAt2;

    @SerializedName("table_id")
    private String tableId;

    public double getCartOrderTotalTaxPrice() {
        return cartOrderTotalTaxPrice;
    }

    public void setCartOrderTotalTaxPrice(double cartOrderTotalTaxPrice) {
        this.cartOrderTotalTaxPrice = cartOrderTotalTaxPrice;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
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

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public List<CartProducts> getProducts() {
        return products;
    }

    public void setProducts(List<CartProducts> products) {
        this.products = products;
    }

    public double getCartOrderTotalPrice() {
        return cartOrderTotalPrice;
    }

    public void setCartOrderTotalPrice(double cartOrderTotalPrice) {
        this.cartOrderTotalPrice = cartOrderTotalPrice;
    }

    public String getOrderPaymentId() {
        return orderPaymentId;
    }

    public void setOrderPaymentId(String orderPaymentId) {
        this.orderPaymentId = orderPaymentId;
    }


    public String getAndroidId() {
        return androidId;
    }

    public void setAndroidId(String androidId) {
        this.androidId = androidId;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public Integer getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(Integer deliveryType) {
        this.deliveryType = deliveryType;
    }

    public long getTotalItemCount() {
        return totalItemCount;
    }

    public void setTotalItemCount(long totalItemCount) {
        this.totalItemCount = totalItemCount;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Boolean getTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(Boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public Boolean getUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(Boolean useItemTax) {
        isUseItemTax = useItemTax;
    }

    public ArrayList<TaxesDetail> getTaxesDetails() {
        return taxesDetails;
    }

    public void setTaxesDetails(ArrayList<TaxesDetail> taxesDetails) {
        this.taxesDetails = taxesDetails;
    }

    public double getTotalCartAmountWithoutTax() {
        return totalCartAmoutWithoutTax;
    }

    public void setTotalCartAmountWithoutTax(double totalCartAmountWithoutTax) {
        this.totalCartAmoutWithoutTax = totalCartAmountWithoutTax;
    }

    public void setTableNo(int tableNo) {
        this.tableNo = tableNo;
    }

    public void setNoOfPersons(int noOfPersons) {
        this.noOfPersons = noOfPersons;
    }

    public void setBookingType(int bookingType) {
        this.bookingType = bookingType;
    }

    public long getOrderStartAt() {
        return orderStartAt;
    }

    public void setOrderStartAt(long orderStartAt) {
        this.orderStartAt = orderStartAt;
    }

    public long getOrderStartAt2() {
        return orderStartAt2;
    }

    public void setOrderStartAt2(long orderStartAt2) {
        this.orderStartAt2 = orderStartAt2;
    }

    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }
}