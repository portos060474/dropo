package com.dropo.models.responsemodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.Status;
import com.dropo.models.datamodels.User;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ActiveOrderResponse implements Parcelable {


    public static final Creator<ActiveOrderResponse> CREATOR = new Creator<ActiveOrderResponse>() {
        @Override
        public ActiveOrderResponse createFromParcel(Parcel source) {
            return new ActiveOrderResponse(source);
        }

        @Override
        public ActiveOrderResponse[] newArray(int size) {
            return new ActiveOrderResponse[size];
        }
    };
    private boolean isSubmitInvoice;
    @SerializedName("order_status_details")
    private List<Status> orderStatusDetails;
    @SerializedName("delivery_status_details")
    private List<Status> deliveryStatusDetails;
    @SerializedName("estimated_time_for_delivery_in_min")
    private double estimatedTimeForDeliveryInMin;
    @SerializedName("total_time")
    @Expose
    private double totalTime;
    @SerializedName("delivery_status")
    private int deliveryStatus;
    @SerializedName("request_unique_id")
    private int requestUniqueId;
    @SerializedName("request_id")
    private String requestId;
    @SerializedName("order_cancellation_charge")
    private double orderCancellationCharge;

    @SerializedName("is_user_pick_up_order")
    private boolean isUserPickUpOrder;
    @SerializedName("is_confirmation_code_required_at_pickup_delivery")
    private boolean isConfirmationCodeRequiredAtPickupDelivery;
    @SerializedName("is_confirmation_code_required_at_complete_delivery")
    private boolean isConfirmationCodeRequiredAtCompleteDelivery;
    @SerializedName("user_rate")
    private double providerRate;
    @SerializedName("order_status")
    private int orderStatus;
    @SerializedName("provider_first_name")
    private String providerFirstName;
    @SerializedName("provider_phone")
    private String providerPhone;
    @SerializedName("success")
    private boolean success;
    @SerializedName("provider_country_phone_code")
    private String providerCountryPhoneCode;
    @SerializedName("provider_last_name")
    private String providerLastName;
    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("provider_image")
    private String providerImage;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("provider_id")
    private String providerId;
    @SerializedName("confirmation_code_for_pick_up_delivery")
    @Expose
    private String confirmationCodeForPickUpDelivery;
    @SerializedName("confirmation_code_for_complete_delivery")
    @Expose
    private String confirmationCode;
    @SerializedName("currency")
    private String currency;
    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;
    @SerializedName("pickup_addresses")
    private List<Addresses> pickupAddresses;
    @SerializedName("order_change")
    private boolean orderChange;
    @SerializedName("cancellation_charge_apply_from")
    private int cancellationChargeApplyFrom;
    @SerializedName("cancellation_charge_apply_till")
    private int cancellationChargeApplyTill;
    @SerializedName("delivery_type")
    private int deliveryType;
    @SerializedName("provider_detail")
    private User provider;

    public ActiveOrderResponse() {
    }

    protected ActiveOrderResponse(Parcel in) {
        this.orderStatusDetails = in.createTypedArrayList(Status.CREATOR);
        this.deliveryStatusDetails = in.createTypedArrayList(Status.CREATOR);
        this.estimatedTimeForDeliveryInMin = in.readDouble();
        this.totalTime = in.readDouble();
        this.deliveryStatus = in.readInt();
        this.requestUniqueId = in.readInt();
        this.requestId = in.readString();
        this.orderCancellationCharge = in.readDouble();
        this.isUserPickUpOrder = in.readByte() != 0;
        this.isConfirmationCodeRequiredAtPickupDelivery = in.readByte() != 0;
        this.isConfirmationCodeRequiredAtCompleteDelivery = in.readByte() != 0;
        this.providerRate = in.readDouble();
        this.orderStatus = in.readInt();
        this.providerFirstName = in.readString();
        this.providerPhone = in.readString();
        this.success = in.readByte() != 0;
        this.providerCountryPhoneCode = in.readString();
        this.providerLastName = in.readString();
        this.message = in.readInt();
        this.providerImage = in.readString();
        this.errorCode = in.readInt();
        this.uniqueId = in.readInt();
        this.providerId = in.readString();
        this.confirmationCodeForPickUpDelivery = in.readString();
        this.confirmationCode = in.readString();
        this.currency = in.readString();
        this.destinationAddresses = in.createTypedArrayList(Addresses.CREATOR);
        this.orderChange = in.readByte() != 0;
        this.deliveryType = in.readInt();
        this.cancellationChargeApplyFrom = in.readInt();
        this.cancellationChargeApplyTill = in.readInt();
        this.provider = in.readParcelable(User.class.getClassLoader());
    }

    public List<Status> getOrderStatusDetails() {
        return orderStatusDetails;
    }

    public void setOrderStatusDetails(List<Status> orderStatusDetails) {
        this.orderStatusDetails = orderStatusDetails;
    }

    public List<Status> getDeliveryStatusDetails() {
        return deliveryStatusDetails;
    }

    public void setDeliveryStatusDetails(List<Status> deliveryStatusDetails) {
        this.deliveryStatusDetails = deliveryStatusDetails;
    }

    public double getTotalTime() {
        return totalTime;
    }

    public void setTotalTime(double totalTime) {
        this.totalTime = totalTime;
    }

    public double getEstimatedTimeForDeliveryInMin() {
        return estimatedTimeForDeliveryInMin;
    }

    public void setEstimatedTimeForDeliveryInMin(double estimatedTimeForDeliveryInMin) {
        this.estimatedTimeForDeliveryInMin = estimatedTimeForDeliveryInMin;
    }

    public int getDeliveryStatus() {
        return deliveryStatus;
    }

    public void setDeliveryStatus(int deliveryStatus) {
        this.deliveryStatus = deliveryStatus;
    }

    public int getRequestUniqueId() {
        return requestUniqueId;
    }

    public void setRequestUniqueId(int requestUniqueId) {
        this.requestUniqueId = requestUniqueId;
    }

    public String getRequestId() {
        return requestId;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
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

    public double getOrderCancellationCharge() {
        return orderCancellationCharge;
    }

    public void setOrderCancellationCharge(double orderCancellationCharge) {
        this.orderCancellationCharge = orderCancellationCharge;
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

    public String getProviderFirstName() {
        return providerFirstName;
    }

    public void setProviderFirstName(String providerFirstName) {
        this.providerFirstName = providerFirstName;
    }

    public String getProviderPhone() {
        return providerPhone;
    }

    public void setProviderPhone(String providerPhone) {
        this.providerPhone = providerPhone;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getProviderCountryPhoneCode() {
        return providerCountryPhoneCode;
    }

    public void setProviderCountryPhoneCode(String providerCountryPhoneCode) {
        this.providerCountryPhoneCode = providerCountryPhoneCode;
    }

    public String getProviderLastName() {
        return providerLastName;
    }

    public void setProviderLastName(String providerLastName) {
        this.providerLastName = providerLastName;
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

    public String getProviderImage() {
        return providerImage;
    }

    public void setProviderImage(String providerImage) {
        this.providerImage = providerImage;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public String getConfirmationCode() {
        return confirmationCode;
    }

    public void setConfirmationCode(String confirmationCode) {
        this.confirmationCode = confirmationCode;
    }

    public double getProviderRate() {
        return providerRate;
    }

    public void setProviderRate(double providerRate) {
        this.providerRate = providerRate;
    }

    public String getConfirmationCodeForPickUpDelivery() {
        return confirmationCodeForPickUpDelivery;
    }

    public void setConfirmationCodeForPickUpDelivery(String confirmationCodeForPickUpDelivery) {
        this.confirmationCodeForPickUpDelivery = confirmationCodeForPickUpDelivery;
    }

    public boolean isConfirmationCodeRequiredAtPickupDelivery() {
        return isConfirmationCodeRequiredAtPickupDelivery;
    }

    public void setConfirmationCodeRequiredAtPickupDelivery(boolean confirmationCodeRequiredAtPickupDelivery) {
        isConfirmationCodeRequiredAtPickupDelivery = confirmationCodeRequiredAtPickupDelivery;
    }

    public boolean isOrderChange() {
        return orderChange;
    }

    public void setOrderChange(boolean orderChange) {
        this.orderChange = orderChange;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public User getProvider() {
        return provider;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.orderStatusDetails);
        dest.writeTypedList(this.deliveryStatusDetails);
        dest.writeDouble(this.estimatedTimeForDeliveryInMin);
        dest.writeDouble(this.totalTime);
        dest.writeInt(this.deliveryStatus);
        dest.writeInt(this.requestUniqueId);
        dest.writeString(this.requestId);
        dest.writeDouble(this.orderCancellationCharge);
        dest.writeByte(this.isUserPickUpOrder ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isConfirmationCodeRequiredAtPickupDelivery ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isConfirmationCodeRequiredAtCompleteDelivery ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.providerRate);
        dest.writeInt(this.orderStatus);
        dest.writeString(this.providerFirstName);
        dest.writeString(this.providerPhone);
        dest.writeByte(this.success ? (byte) 1 : (byte) 0);
        dest.writeString(this.providerCountryPhoneCode);
        dest.writeString(this.providerLastName);
        dest.writeInt(this.message);
        dest.writeString(this.providerImage);
        dest.writeInt(this.errorCode);
        dest.writeInt(this.uniqueId);
        dest.writeString(this.providerId);
        dest.writeString(this.confirmationCodeForPickUpDelivery);
        dest.writeString(this.confirmationCode);
        dest.writeString(this.currency);
        dest.writeTypedList(this.destinationAddresses);
        dest.writeByte(this.orderChange ? (byte) 1 : (byte) 0);
        dest.writeInt(this.deliveryType);
        dest.writeInt(this.cancellationChargeApplyFrom);
        dest.writeInt(this.cancellationChargeApplyTill);
        dest.writeParcelable(this.provider, flags);
    }

    public boolean isSubmitInvoice() {
        return isSubmitInvoice;
    }

    public void setSubmitInvoice(boolean submitInvoice) {
        isSubmitInvoice = submitInvoice;
    }

    public List<Addresses> getPickupAddresses() {
        return pickupAddresses;
    }

    public int getCancellationChargeApplyFrom() {
        return cancellationChargeApplyFrom;
    }

    public int getCancellationChargeApplyTill() {
        return cancellationChargeApplyTill;
    }
}