package com.dropo.provider.models.singleton;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by elluminati on 11-Apr-17.
 */

public class CurrentOrder implements Parcelable {

    public static final Creator<CurrentOrder> CREATOR = new Creator<CurrentOrder>() {
        @Override
        public CurrentOrder createFromParcel(Parcel in) {
            return new CurrentOrder(in);
        }

        @Override
        public CurrentOrder[] newArray(int size) {
            return new CurrentOrder[size];
        }
    };
    private static CurrentOrder currentOrder = new CurrentOrder();
    private String currency;
    private int availableOrders;
    private String vehiclePin;
    private Bitmap bmVehiclePin;

    private CurrentOrder() {
    }

    protected CurrentOrder(Parcel in) {
        currency = in.readString();
        availableOrders = in.readInt();
        vehiclePin = in.readString();
        bmVehiclePin = in.readParcelable(Bitmap.class.getClassLoader());
    }

    public static CurrentOrder getInstance() {
        return currentOrder;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("current_order", currentOrder);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            currentOrder = state.getParcelable("current_order");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(currency);
        dest.writeInt(availableOrders);
        dest.writeString(vehiclePin);
        dest.writeParcelable(bmVehiclePin, flags);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public int getAvailableOrders() {
        return availableOrders;
    }

    public void setAvailableOrders(int availableOrders) {
        this.availableOrders = availableOrders;
    }

    public String getVehiclePin() {
        return vehiclePin;
    }

    public void setVehiclePin(String vehiclePin) {
        this.vehiclePin = vehiclePin;
    }

    public Bitmap getBmVehiclePin() {
        return bmVehiclePin;
    }

    public void setBmVehiclePin(Bitmap bmVehiclePin) {
        this.bmVehiclePin = bmVehiclePin;
    }

    public void clearCurrentOrder() {
        currency = "";
        availableOrders = 0;
        vehiclePin = "";
        bmVehiclePin = null;
    }
}
