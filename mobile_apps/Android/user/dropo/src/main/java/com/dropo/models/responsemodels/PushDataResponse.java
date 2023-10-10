package com.dropo.models.responsemodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class PushDataResponse implements Parcelable {

    public static final Parcelable.Creator<PushDataResponse> CREATOR = new Parcelable.Creator<PushDataResponse>() {
        @Override
        public PushDataResponse createFromParcel(Parcel source) {
            return new PushDataResponse(source);
        }

        @Override
        public PushDataResponse[] newArray(int size) {
            return new PushDataResponse[size];
        }
    };
    @SerializedName("unique_id")
    private String uniqueId;

    @SerializedName("store_name")
    private Object storeName;

    @SerializedName("order_id")
    private String orderId;

    @SerializedName("store_image")
    private String storeImage;
    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;

    public PushDataResponse() {
    }

    protected PushDataResponse(Parcel in) {
        this.uniqueId = in.readString();
        this.storeName = in.readString();
        this.orderId = in.readString();
        this.storeImage = in.readString();
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public String getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(String uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getStoreName() {
        if (storeName instanceof ArrayList && !((ArrayList) storeName).isEmpty()) {
            return ((ArrayList) storeName).get(0).toString();
        }
        if (storeName instanceof String) {
            return storeName.toString();
        }
        return "";
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getStoreImage() {
        return storeImage;
    }

    public void setStoreImage(String storeImage) {
        this.storeImage = storeImage;
    }

    @Override
    public String toString() {
        return "PushDataResponse{" + "unique_id = '" + uniqueId + '\'' + ",store_name = '" + storeName + '\'' + ",order_id = '" + orderId + '\'' + ",store_image = '" + storeImage + '\'' + "}";
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.uniqueId);
        if (storeName instanceof ArrayList && !((ArrayList) storeName).isEmpty()) {
            dest.writeString(((ArrayList) storeName).get(0).toString());
        }
        if (storeName instanceof String) {
            dest.writeString(storeName.toString());
        } else {
            dest.writeString("");
        }
        dest.writeString(this.orderId);
        dest.writeString(this.storeImage);
    }
}