package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.Calendar;

public class DayTime implements Parcelable, Comparable<DayTime> {
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

    private Calendar openTimeCalender;
    private Calendar closedTimeCalender;

    @SerializedName("store_open_time")
    private Object storeOpenTimeMinute;

    @SerializedName("store_close_time")
    private Object storeCloseTimeMinute;

    @SerializedName("booking_open_time")
    private Object bookingOpenTimeMinute;

    @SerializedName("booking_close_time")
    private Object bookingCloseTimeMinute;

    public DayTime() {
    }

    protected DayTime(Parcel in) {
        this.storeOpenTime = in.readString();
        this.storeCloseTime = in.readString();
        this.openTimeCalender = (Calendar) in.readSerializable();
        this.closedTimeCalender = (Calendar) in.readSerializable();
        this.storeOpenTimeMinute = in.readInt();
        this.storeCloseTimeMinute = in.readInt();
        this.bookingOpenTimeMinute = in.readInt();
        this.bookingCloseTimeMinute = in.readInt();
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

    public Calendar getOpenTimeCalender() {
        return openTimeCalender;
    }

    public void setOpenTimeCalender(Calendar openTimeCalender) {
        this.openTimeCalender = openTimeCalender;
    }

    public Calendar getClosedTimeCalender() {
        return closedTimeCalender;
    }

    public void setClosedTimeCalender(Calendar closedTimeCalender) {
        this.closedTimeCalender = closedTimeCalender;
    }

    @Override
    public int compareTo(DayTime dayTime) {
        return this.openTimeCalender.getTimeInMillis() > dayTime.getOpenTimeCalender().getTimeInMillis() ? 1 : -1;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.storeOpenTime);
        dest.writeString(this.storeCloseTime);
        dest.writeSerializable(this.openTimeCalender);
        dest.writeSerializable(this.closedTimeCalender);
        dest.writeInt(getStoreOpenTimeMinute());
        dest.writeInt(getStoreCloseTimeMinute());
        dest.writeInt(getBookingOpenTimeMinute());
        dest.writeInt(getBookingCloseTimeMinute());
    }

    public int getStoreOpenTimeMinute() {
        if (storeOpenTimeMinute instanceof Number) {
            return ((Number) storeOpenTimeMinute).intValue();
        } else {
            return 0;
        }

    }

    public int getStoreCloseTimeMinute() {
        if (storeCloseTimeMinute instanceof Number) {
            return ((Number) storeCloseTimeMinute).intValue();
        } else {
            return 0;
        }
    }

    public int getBookingOpenTimeMinute() {
        if (bookingOpenTimeMinute instanceof Number) {
            return ((Number) bookingOpenTimeMinute).intValue();
        } else {
            return 0;
        }

    }

    public int getBookingCloseTimeMinute() {
        if (bookingCloseTimeMinute instanceof Number) {
            return ((Number) bookingCloseTimeMinute).intValue();
        } else {
            return 0;
        }
    }
}