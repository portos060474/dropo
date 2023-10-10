package com.dropo.store.models.responsemodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.Service;
import com.dropo.store.models.datamodel.UnavailableItems;
import com.dropo.store.models.datamodel.UserDetail;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class InvoiceResponse implements Parcelable {

    public static final Parcelable.Creator<InvoiceResponse> CREATOR = new Parcelable.Creator<InvoiceResponse>() {
        @Override
        public InvoiceResponse createFromParcel(Parcel source) {
            return new InvoiceResponse(source);
        }

        @Override
        public InvoiceResponse[] newArray(int size) {
            return new InvoiceResponse[size];
        }
    };

    @SerializedName("min_order_price")
    private double minOrderPrice;
    @SerializedName("currency")
    private String currency;
    @SerializedName("payment_gateway_name")
    private String payment;
    @SerializedName("order_payment")
    private OrderPaymentDetail orderPayment;
    @SerializedName("store")
    private UserDetail store;
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
    @SerializedName("is_tax_included")
    private boolean isTaxIncluded;
    @SerializedName("is_use_item_tax")
    private boolean isUseItemTax;
    @SerializedName("unavailable_items")
    private List<UnavailableItems> unavailableItems;
    @SerializedName("unavailable_products")
    private List<UnavailableItems> unavailableProducts;

    public InvoiceResponse() {
    }

    protected InvoiceResponse(Parcel in) {
        this.minOrderPrice = in.readDouble();
        this.currency = in.readString();
        this.payment = in.readString();
        this.orderPayment = in.readParcelable(OrderPaymentDetail.class.getClassLoader());
        this.store = in.readParcelable(UserDetail.class.getClassLoader());
        this.serverTime = in.readString();
        this.timezone = in.readString();
        this.success = in.readByte() != 0;
        this.isTaxIncluded = in.readByte() != 0;
        this.isUseItemTax = in.readByte() != 0;
        this.service = in.readParcelable(Service.class.getClassLoader());
        this.message = in.readInt();
        this.errorCode = in.readInt();
        this.unavailableItems = in.createTypedArrayList(UnavailableItems.CREATOR);
        this.unavailableProducts = in.createTypedArrayList(UnavailableItems.CREATOR);
    }

    public double getMinOrderPrice() {
        return minOrderPrice;
    }

    public void setMinOrderPrice(double minOrderPrice) {
        this.minOrderPrice = minOrderPrice;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getPayment() {
        return payment;
    }

    public void setPayment(String payment) {
        this.payment = payment;
    }

    public OrderPaymentDetail getOrderPayment() {
        return orderPayment;
    }

    public void setOrderPayment(OrderPaymentDetail orderPayment) {
        this.orderPayment = orderPayment;
    }

    public UserDetail getStore() {
        return store;
    }

    public void setStore(UserDetail store) {
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

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public boolean isUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(boolean useItemTax) {
        isUseItemTax = useItemTax;
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

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeDouble(this.minOrderPrice);
        dest.writeString(this.currency);
        dest.writeString(this.payment);
        dest.writeParcelable(this.orderPayment, flags);
        dest.writeParcelable(this.store, flags);
        dest.writeString(this.serverTime);
        dest.writeString(this.timezone);
        dest.writeByte(this.success ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isTaxIncluded ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isUseItemTax ? (byte) 1 : (byte) 0);
        dest.writeParcelable(this.service, flags);
        dest.writeInt(this.message);
        dest.writeInt(this.errorCode);
        dest.writeTypedList(this.unavailableItems);
        dest.writeTypedList(this.unavailableProducts);
    }
}