package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Order implements Parcelable {

    public static final Creator<Order> CREATOR = new Creator<Order>() {
        @Override
        public Order createFromParcel(Parcel source) {
            return new Order(source);
        }

        @Override
        public Order[] newArray(int size) {
            return new Order[size];
        }
    };
    @SerializedName("user_pay_payment")
    @Expose
    private double userPayPayment;
    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;
    @SerializedName("country_detail")
    @Expose
    private Countries countries;
    @SerializedName("request_id")
    @Expose
    private String requestId;
    @SerializedName("is_user_pick_up_order")
    private boolean isUserPickUpOrder;
    @SerializedName("is_confirmation_code_required_at_complete_delivery")
    private boolean isConfirmationCodeRequiredAtCompleteDelivery;
    @SerializedName("total_time")
    @Expose
    private double totalTime;
    @SerializedName("delivery_status")
    @Expose
    private int deliveryStatus;
    @SerializedName("request_unique_id")
    @Expose
    private int requestUniqueId;
    @SerializedName("order_status")
    @Expose
    private int orderStatus;
    @SerializedName("is_user_show_invoice")
    @Expose
    private boolean isUserShowInvoice;
    @SerializedName("store_phone")
    @Expose
    private String storePhone;
    @SerializedName("pickup_addresses")
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("store_name")
    @Expose
    private String storeName;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("store_country_phone_code")
    @Expose
    private String storeCountryPhoneCode;
    @SerializedName("currency")
    @Expose
    private String currency = "";
    @SerializedName("promo_code")
    @Expose
    private String promoCode;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("unique_code")
    @Expose
    private int uniqueCode;
    @SerializedName("store_image_url")
    @Expose
    private String storeImage;
    @SerializedName("total_order_price")
    @Expose
    private double orderTotalPrice;
    @SerializedName("total")
    @Expose
    private double total;
    @SerializedName("cart_detail")
    @Expose
    private OrderData orderData;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("order_change")
    private boolean orderChange;

    @SerializedName("is_schedule_order")
    private boolean isScheduleOrder;

    @SerializedName("schedule_order_start_at")
    private String scheduleOrderStartAt;

    @SerializedName("store_detail")
    private Store store;
    @SerializedName("image_url")
    @Expose
    private ArrayList<String> courierItemsImages;

    public Order() {
    }

    protected Order(Parcel in) {
        this.userPayPayment = in.readDouble();
        this.deliveryType = in.readInt();
        this.countries = in.readParcelable(Countries.class.getClassLoader());
        this.requestId = in.readString();
        this.isUserPickUpOrder = in.readByte() != 0;
        this.isConfirmationCodeRequiredAtCompleteDelivery = in.readByte() != 0;
        this.totalTime = in.readDouble();
        this.deliveryStatus = in.readInt();
        this.requestUniqueId = in.readInt();
        this.orderStatus = in.readInt();
        this.isUserShowInvoice = in.readByte() != 0;
        this.storePhone = in.readString();
        this.pickupAddresses = in.createTypedArrayList(Addresses.CREATOR);
        this.destinationAddresses = in.createTypedArrayList(Addresses.CREATOR);
        this.createdAt = in.readString();
        this.storeName = in.readString();
        this.storeId = in.readString();
        this.storeCountryPhoneCode = in.readString();
        this.currency = in.readString();
        this.promoCode = in.readString();
        this.id = in.readString();
        this.uniqueCode = in.readInt();
        this.storeImage = in.readString();
        this.orderTotalPrice = in.readDouble();
        this.orderData = in.readParcelable(OrderData.class.getClassLoader());
        this.uniqueId = in.readInt();
        this.orderChange = in.readByte() != 0;
        this.store = in.readParcelable(Store.class.getClassLoader());
        this.courierItemsImages = in.createStringArrayList();
        this.isScheduleOrder = in.readByte() != 0;
        this.scheduleOrderStartAt = in.readString();
    }

    public static Creator<Order> getCREATOR() {
        return CREATOR;
    }

    public ArrayList<String> getCourierItemsImages() {
        return courierItemsImages;
    }

    public void setCourierItemsImages(ArrayList<String> courierItemsImages) {
        this.courierItemsImages = courierItemsImages;
    }

    public OrderData getOrderData() {
        return orderData;
    }

    public void setOrderData(OrderData orderData) {
        this.orderData = orderData;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public int getRequestUniqueId() {
        return requestUniqueId;
    }

    public void setRequestUniqueId(int requestUniqueId) {
        this.requestUniqueId = requestUniqueId;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;

    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
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

    public boolean isUserPickUpOrder() {
        return isUserPickUpOrder;
    }

    public void setUserPickUpOrder(boolean userPickUpOrder) {
        isUserPickUpOrder = userPickUpOrder;
    }

    public boolean isConfirmationCodeRequiredAtCompleteDelivery() {
        return isConfirmationCodeRequiredAtCompleteDelivery;
    }

    public void setConfirmationCodeRequiredAtCompleteDelivery(boolean confirmationCodeRequiredAtCompleteDelivery) {
        isConfirmationCodeRequiredAtCompleteDelivery = confirmationCodeRequiredAtCompleteDelivery;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getStorePhone() {
        return storePhone;
    }

    public void setStorePhone(String storePhone) {
        this.storePhone = storePhone;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getStoreCountryPhoneCode() {
        return storeCountryPhoneCode;
    }

    public void setStoreCountryPhoneCode(String storeCountryPhoneCode) {
        this.storeCountryPhoneCode = storeCountryPhoneCode;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getUniqueCode() {
        return uniqueCode;
    }

    public void setUniqueCode(int uniqueCode) {
        this.uniqueCode = uniqueCode;
    }

    public String getStoreImage() {
        return storeImage;
    }

    public void setStoreImage(String storeImage) {
        this.storeImage = storeImage;
    }

    public double getOrderTotalPrice() {
        return orderTotalPrice;
    }

    public void setOrderTotalPrice(double orderTotalPrice) {
        this.orderTotalPrice = orderTotalPrice;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public boolean isUserShowInvoice() {
        return isUserShowInvoice;
    }

    public void setUserShowInvoice(boolean userShowInvoice) {
        isUserShowInvoice = userShowInvoice;
    }

    public double getTotalTime() {
        return totalTime;
    }

    public void setTotalTime(double totalTime) {
        this.totalTime = totalTime;
    }

    public Countries getCountries() {
        return countries;
    }

    public void setCountries(Countries countries) {
        this.countries = countries;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public boolean isOrderChange() {
        return orderChange;
    }

    public void setOrderChange(boolean orderChange) {
        this.orderChange = orderChange;
    }

    public double getUserPayPayment() {
        return userPayPayment;
    }

    public void setUserPayPayment(double userPayPayment) {
        this.userPayPayment = userPayPayment;
    }

    public Store getStore() {
        return store;
    }

    public String getStoreId() {
        return storeId;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeDouble(this.userPayPayment);
        dest.writeInt(this.deliveryType);
        dest.writeParcelable(this.countries, flags);
        dest.writeString(this.requestId);
        dest.writeByte(this.isUserPickUpOrder ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isConfirmationCodeRequiredAtCompleteDelivery ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalTime);
        dest.writeInt(this.deliveryStatus);
        dest.writeInt(this.requestUniqueId);
        dest.writeInt(this.orderStatus);
        dest.writeByte(this.isUserShowInvoice ? (byte) 1 : (byte) 0);
        dest.writeString(this.storePhone);
        dest.writeTypedList(this.pickupAddresses);
        dest.writeTypedList(this.destinationAddresses);
        dest.writeString(this.createdAt);
        dest.writeString(this.storeName);
        dest.writeString(this.storeId);
        dest.writeString(this.storeCountryPhoneCode);
        dest.writeString(this.currency);
        dest.writeString(this.promoCode);
        dest.writeString(this.id);
        dest.writeInt(this.uniqueCode);
        dest.writeString(this.storeImage);
        dest.writeDouble(this.orderTotalPrice);
        dest.writeParcelable(this.orderData, flags);
        dest.writeInt(this.uniqueId);
        dest.writeByte(this.orderChange ? (byte) 1 : (byte) 0);
        dest.writeParcelable(this.store, flags);
        dest.writeStringList(this.courierItemsImages);
        dest.writeByte(this.isScheduleOrder ? (byte) 1 : (byte) 0);
        dest.writeString(this.scheduleOrderStartAt);
    }

    public double getTotal() {
        return total;
    }

    public boolean isScheduleOrder() {
        return isScheduleOrder;
    }

    public String getScheduleOrderStartAt() {
        return scheduleOrderStartAt;
    }
}