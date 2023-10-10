package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.AppLanguage;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.models.datamodels.TaxesDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class CartResponse {


    @SerializedName("name")
    @Expose
    public String name;
    @SerializedName("is_use_item_tax")
    @Expose
    private boolean isUseItemTax;

    @SerializedName("currency")
    @Expose
    private String currency;

    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;

    @SerializedName("pickup_addresses")
    private List<Addresses> pickupAddresses;

    @SerializedName("languages_supported")
    private List<AppLanguage> langs;

    @SerializedName("city_id")
    @Expose
    private String cityId;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("cart_id")
    @Expose
    private String cartId;
    @SerializedName("cart")
    @Expose
    private CartOrder cart;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("store_time")
    @Expose
    private List<StoreTime> storeTime;
    @SerializedName("location")
    @Expose
    private List<Double> location;
    @SerializedName("is_tax_included")
    @Expose
    private boolean isTaxIncluded;

    @SerializedName("tax_details")
    private ArrayList<TaxesDetail> taxDetails;

    @SerializedName("table_no")
    private int tableNo;

    @SerializedName("no_of_persons")
    private int noOfPersons;

    @SerializedName("booking_type")
    private int bookingType;

    @SerializedName("delivery_type")
    private int deliveryType;

    @SerializedName("booking_fee")
    private double bookingFee;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(boolean useItemTax) {
        this.isUseItemTax = useItemTax;
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

    public List<AppLanguage> getLangs() {
        return langs;
    }

    public void setLangs(List<AppLanguage> langs) {
        this.langs = langs;
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

    public CartOrder getCart() {
        return cart;
    }

    public void setCart(CartOrder cart) {
        this.cart = cart;
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


    public List<StoreTime> getStoreTime() {
        return storeTime;
    }

    public void setStoreTime(List<StoreTime> storeTime) {
        this.storeTime = storeTime;
    }

    public List<Double> getLocation() {
        return location;
    }

    public void setLocation(List<Double> location) {
        this.location = location;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public String getCartId() {
        return cartId;
    }

    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public ArrayList<TaxesDetail> getTaxDetails() {
        return taxDetails;
    }

    public double getTotalTaxes() {
        if (taxDetails != null && !taxDetails.isEmpty()) {
            double tax = 0;
            for (TaxesDetail taxesDetail : taxDetails) {
                tax += taxesDetail.getTax();
            }
            return tax;
        } else {
            return 0.0;
        }
    }

    public int getTableNo() {
        return tableNo;
    }

    public int getNoOfPersons() {
        return noOfPersons;
    }

    public int getBookingType() {
        return bookingType;
    }

    public double getBookingFee() {
        return bookingFee;
    }

    public int getDeliveryType() {
        return deliveryType;
    }
}