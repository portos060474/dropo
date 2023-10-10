package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class DayTime implements Parcelable {
    public static final Creator<DayTime> CREATOR = new Creator<DayTime>() {
        @Override
        public DayTime createFromParcel(Parcel source) {
            return new DayTime(source);
        }

        @Override
        public DayTime[] newArray(int size) {
            return new DayTime[size];
        }
    };
    private String storeOpenTime;
    private String storeCloseTime;
    @SerializedName("store_open_time")
    private Object storeOpenTimeMinute;
    @SerializedName("store_close_time")
    private Object storeCloseTimeMinute;

    public DayTime() {
    }

    protected DayTime(Parcel in) {
        this.storeOpenTime = in.readString();
        this.storeCloseTime = in.readString();
        this.storeOpenTimeMinute = in.readInt();
        this.storeCloseTimeMinute = in.readInt();
    }

    public String getStoreOpenTime() {
        return storeOpenTime;
    }

    public void setStoreOpenTime(String storeOpenTime) {
        this.storeOpenTime = storeOpenTime;
    }

    public String getStoreCloseTime() {
        return storeCloseTime;
    }

    public void setStoreCloseTime(String storeCloseTime) {
        this.storeCloseTime = storeCloseTime;
    }

    @Override
    public String toString() {
        return "DayTime{" + "store_open_time = '" + storeOpenTime + '\'' + ",store_close_time = '" + storeCloseTime + '\'' + "}";
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.storeOpenTime);
        dest.writeString(this.storeCloseTime);
        dest.writeInt(getStoreOpenTimeMinute());
        dest.writeInt(getStoreCloseTimeMinute());
    }

    public int getStoreOpenTimeMinute() {
        if (storeOpenTimeMinute instanceof Number) {
            return (int) ((Number) storeOpenTimeMinute).intValue();
        } else {
            return 0;
        }

    }

    public void setStoreOpenTimeMinute(int storeOpenTimeMinute) {
        this.storeOpenTimeMinute = storeOpenTimeMinute;
    }

    public int getStoreCloseTimeMinute() {
        if (storeCloseTimeMinute instanceof Number) {
            return (int) ((Number) storeCloseTimeMinute).intValue();
        } else {
            return 0;
        }
    }

    public void setStoreCloseTimeMinute(int storeCloseTimeMinute) {
        this.storeCloseTimeMinute = storeCloseTimeMinute;
    }
}