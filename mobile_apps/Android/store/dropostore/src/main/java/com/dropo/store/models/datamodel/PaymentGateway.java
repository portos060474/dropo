package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class PaymentGateway implements Parcelable {

    @SerializedName("payment_key_id")
    @Expose
    private String paymentKeyId;

    @SerializedName("payment_key")
    @Expose
    private String paymentKey;

    @SerializedName("name")
    @Expose
    private String name;


    @SerializedName("_id")
    @Expose
    private String id;

    protected PaymentGateway(Parcel in) {
        paymentKeyId = in.readString();
        paymentKey = in.readString();
        name = in.readString();
        id = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(paymentKeyId);
        dest.writeString(paymentKey);
        dest.writeString(name);
        dest.writeString(id);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<PaymentGateway> CREATOR = new Creator<PaymentGateway>() {
        @Override
        public PaymentGateway createFromParcel(Parcel in) {
            return new PaymentGateway(in);
        }

        @Override
        public PaymentGateway[] newArray(int size) {
            return new PaymentGateway[size];
        }
    };

    public String getPaymentKeyId() {
        return paymentKeyId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

}