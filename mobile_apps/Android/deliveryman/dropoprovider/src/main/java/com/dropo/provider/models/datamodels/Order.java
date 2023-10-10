package com.dropo.provider.models.datamodels;

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
    @SerializedName("order_unique_id")
    @Expose
    private int orderUniqueId;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("currency")
    @Expose
    private String currency;
    @SerializedName("total_provider_income")
    @Expose
    private double totalProviderIncome;
    @SerializedName("estimated_time_for_ready_order")
    @Expose
    private String estimatedTimeForReadyOrder;
    @SerializedName("is_allow_pickup_order_verification")
    private boolean isAllowPickupOrderVerification;
    @SerializedName("is_allow_contactless_delivery")
    private boolean isAllowContactlessDelivery;
    @SerializedName("is_confirmation_code_required_at_pickup_delivery")
    private boolean isConfirmationCodeRequiredAtPickupDelivery;
    @SerializedName("is_confirmation_code_required_at_complete_delivery")
    private boolean isConfirmationCodeRequiredAtCompleteDelivery;
    @SerializedName("unique_id")
    @Expose
    private int requestUniqueId;
    @SerializedName("confirmation_code_for_complete_delivery")
    @Expose
    private String confirmationCodeForCompleteDelivery;
    @SerializedName("confirmation_code_for_pick_up_delivery")
    @Expose
    private String confirmationCodeForPickUp;
    @SerializedName("delivery_status")
    @Expose
    private int deliveryStatus;
    @SerializedName("pickup_addresses")
    @Expose
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    @Expose
    private List<Addresses> destinationAddresses;
    @SerializedName("time_left_to_responds_trip")
    @Expose
    private int timeLeftToRespondsTrip;
    @SerializedName("total_distance")
    @Expose
    private double totalDistance;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("order_id")
    @Expose
    private String order_id;
    @SerializedName("total_time")
    @Expose
    private double totalTime;
    @SerializedName("order_status_id")
    @Expose
    private int orderStatusId;
    @SerializedName("store_name")
    @Expose
    private String storeName;
    @SerializedName("store_image")
    @Expose
    private String storeImage;
    @SerializedName("store_image_url")
    @Expose
    private String storeImageUrl;
    @SerializedName("user_image")
    @Expose
    private String userImage;
    @SerializedName("user_first_name")
    @Expose
    private String userFirstName;
    @SerializedName("user_last_name")
    @Expose
    private String userLastName;
    @SerializedName("order_details")
    @Expose
    private ArrayList<OrderProducts> orderDetails;
    @SerializedName("image_url")
    @Expose
    private ArrayList<String> courierItemsImages;
    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;
    @SerializedName("is_bring_change")
    @Expose
    private boolean isBringChange;
    @SerializedName("arrived_at_stop_no")
    @Expose
    private int arrivedAtStopNo;
    @SerializedName("is_round_trip")
    @Expose
    private boolean isRoundTrip;
    @SerializedName("date_time")
    private ArrayList<Status> statusTime;

    public Order() {
    }

    protected Order(Parcel in) {
        this.orderUniqueId = in.readInt();
        this.createdAt = in.readString();
        this.storeId = in.readString();
        this.currency = in.readString();
        this.totalProviderIncome = in.readDouble();
        this.estimatedTimeForReadyOrder = in.readString();
        this.isAllowPickupOrderVerification = in.readByte() != 0;
        this.isAllowContactlessDelivery = in.readByte() != 0;
        this.isConfirmationCodeRequiredAtPickupDelivery = in.readByte() != 0;
        this.isConfirmationCodeRequiredAtCompleteDelivery = in.readByte() != 0;
        this.requestUniqueId = in.readInt();
        this.confirmationCodeForCompleteDelivery = in.readString();
        this.confirmationCodeForPickUp = in.readString();
        this.deliveryStatus = in.readInt();
        this.pickupAddresses = in.createTypedArrayList(Addresses.CREATOR);
        this.destinationAddresses = in.createTypedArrayList(Addresses.CREATOR);
        this.timeLeftToRespondsTrip = in.readInt();
        this.totalDistance = in.readDouble();
        this.id = in.readString();
        this.order_id = in.readString();
        this.totalTime = in.readDouble();
        this.orderStatusId = in.readInt();
        this.storeName = in.readString();
        this.storeImage = in.readString();
        this.userImage = in.readString();
        this.userFirstName = in.readString();
        this.userLastName = in.readString();
        this.orderDetails = new ArrayList<>();
        in.readList(this.orderDetails, OrderProducts.class.getClassLoader());
        this.courierItemsImages = in.createStringArrayList();
        this.deliveryType = in.readInt();
        this.isBringChange = in.readByte() != 0;
        this.arrivedAtStopNo = in.readInt();
        this.isRoundTrip = in.readByte() != 0;
        this.statusTime = new ArrayList<>();
        in.readList(this.statusTime, Status.class.getClassLoader());
    }

    public ArrayList<OrderProducts> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(ArrayList<OrderProducts> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public int getOrderUniqueId() {
        return orderUniqueId;
    }

    public void setOrderUniqueId(int orderUniqueId) {
        this.orderUniqueId = orderUniqueId;
    }

    public String getUserImage() {
        return userImage;
    }

    public void setUserImage(String userImage) {
        this.userImage = userImage;
    }

    public String getUserFirstName() {
        return userFirstName;
    }

    public void setUserFirstName(String userFirstName) {
        this.userFirstName = userFirstName;
    }

    public String getUserLastName() {
        return userLastName;
    }

    public void setUserLastName(String userLastName) {
        this.userLastName = userLastName;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
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

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public double getTotalProviderIncome() {
        return totalProviderIncome;
    }

    public void setTotalProviderIncome(double totalProviderIncome) {
        this.totalProviderIncome = totalProviderIncome;
    }

    public String getEstimatedTimeForReadyOrder() {
        return estimatedTimeForReadyOrder;
    }

    public void setEstimatedTimeForReadyOrder(String estimatedTimeForReadyOrder) {
        this.estimatedTimeForReadyOrder = estimatedTimeForReadyOrder;
    }

    public boolean isConfirmationCodeRequiredAtPickupDelivery() {
        return isConfirmationCodeRequiredAtPickupDelivery;
    }

    public void setConfirmationCodeRequiredAtPickupDelivery(boolean confirmationCodeRequiredAtPickupDelivery) {
        isConfirmationCodeRequiredAtPickupDelivery = confirmationCodeRequiredAtPickupDelivery;
    }

    public boolean isConfirmationCodeRequiredAtCompleteDelivery() {
        return isConfirmationCodeRequiredAtCompleteDelivery;
    }

    public void setConfirmationCodeRequiredAtCompleteDelivery(boolean confirmationCodeRequiredAtCompleteDelivery) {
        isConfirmationCodeRequiredAtCompleteDelivery = confirmationCodeRequiredAtCompleteDelivery;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public int getTimeLeftToRespondsTrip() {
        return timeLeftToRespondsTrip;
    }

    public void setTimeLeftToRespondsTrip(int timeLeftToRespondsTrip) {
        this.timeLeftToRespondsTrip = timeLeftToRespondsTrip;
    }

    public double getTotalDistance() {
        return totalDistance;
    }

    public void setTotalDistance(double totalDistance) {
        this.totalDistance = totalDistance;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getTotalTime() {
        return totalTime;
    }

    public void setTotalTime(double totalTime) {
        this.totalTime = totalTime;
    }

    public int getOrderStatusId() {
        return orderStatusId;
    }

    public void setOrderStatusId(int orderStatusId) {
        this.orderStatusId = orderStatusId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getStoreImage() {
        return storeImage;
    }

    public void setStoreImage(String storeImage) {
        this.storeImage = storeImage;
    }

    public String getStoreImageUrl() {
        return storeImageUrl;
    }

    public void setStoreImageUrl(String storeImageUrl) {
        this.storeImageUrl = storeImageUrl;
    }

    public String getConfirmationCodeForPickUp() {
        return confirmationCodeForPickUp;
    }

    public void setConfirmationCodeForPickUp(String confirmationCodeForPickUp) {
        this.confirmationCodeForPickUp = confirmationCodeForPickUp;
    }

    public int getRequestUniqueId() {
        return requestUniqueId;
    }

    public void setRequestUniqueId(int requestUniqueId) {
        this.requestUniqueId = requestUniqueId;
    }

    public String getConfirmationCodeForCompleteDelivery() {
        return confirmationCodeForCompleteDelivery;
    }

    public void setConfirmationCodeForCompleteDelivery(String confirmationCodeForCompleteDelivery) {
        this.confirmationCodeForCompleteDelivery = confirmationCodeForCompleteDelivery;
    }

    public ArrayList<String> getCourierItemsImages() {
        return courierItemsImages;
    }

    public void setCourierItemsImages(ArrayList<String> courierItemsImages) {
        this.courierItemsImages = courierItemsImages;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public boolean isAllowPickupOrderVerification() {
        return isAllowPickupOrderVerification;
    }

    public boolean isAllowContactlessDelivery() {
        return isAllowContactlessDelivery;
    }

    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    public String getStoreId() {
        return storeId;
    }

    public boolean isBringChange() {
        return isBringChange;
    }

    public void setBringChange(boolean bringChange) {
        isBringChange = bringChange;
    }

    public int getArrivedAtStopNo() {
        return arrivedAtStopNo;
    }

    public void setArrivedAtStopNo(int arrivedAtStopNo) {
        this.arrivedAtStopNo = arrivedAtStopNo;
    }

    public boolean isRoundTrip() {
        return isRoundTrip;
    }

    public void setRoundTrip(boolean roundTrip) {
        isRoundTrip = roundTrip;
    }

    public ArrayList<Status> getStatusTime() {
        return statusTime;
    }

    public void setStatusTime(ArrayList<Status> statusTime) {
        this.statusTime = statusTime;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.orderUniqueId);
        dest.writeString(this.createdAt);
        dest.writeString(this.storeId);
        dest.writeString(this.currency);
        dest.writeDouble(this.totalProviderIncome);
        dest.writeString(this.estimatedTimeForReadyOrder);
        dest.writeByte(this.isAllowPickupOrderVerification ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isAllowContactlessDelivery ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isConfirmationCodeRequiredAtPickupDelivery ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isConfirmationCodeRequiredAtCompleteDelivery ? (byte) 1 : (byte) 0);
        dest.writeInt(this.requestUniqueId);
        dest.writeString(this.confirmationCodeForCompleteDelivery);
        dest.writeString(this.confirmationCodeForPickUp);
        dest.writeInt(this.deliveryStatus);
        dest.writeTypedList(this.pickupAddresses);
        dest.writeTypedList(this.destinationAddresses);
        dest.writeInt(this.timeLeftToRespondsTrip);
        dest.writeDouble(this.totalDistance);
        dest.writeString(this.id);
        dest.writeString(this.order_id);
        dest.writeDouble(this.totalTime);
        dest.writeInt(this.orderStatusId);
        dest.writeString(this.storeName);
        dest.writeString(this.storeImage);
        dest.writeString(this.userImage);
        dest.writeString(this.userFirstName);
        dest.writeString(this.userLastName);
        dest.writeList(this.orderDetails);
        dest.writeStringList(this.courierItemsImages);
        dest.writeInt(this.deliveryType);
        dest.writeByte(this.isBringChange ? (byte) 1 : (byte) 0);
        dest.writeInt(this.arrivedAtStopNo);
        dest.writeByte(this.isRoundTrip ? (byte) 1 : (byte) 0);
        dest.writeList(this.statusTime);
    }
}