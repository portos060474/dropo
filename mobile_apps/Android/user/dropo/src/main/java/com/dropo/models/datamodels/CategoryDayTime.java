package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.Calendar;

public class CategoryDayTime implements Parcelable, Comparable<CategoryDayTime> {

    public static final Creator<CategoryDayTime> CREATOR = new Creator<CategoryDayTime>() {
        @Override
        public CategoryDayTime createFromParcel(Parcel source) {
            return new CategoryDayTime(source);
        }

        @Override
        public CategoryDayTime[] newArray(int size) {
            return new CategoryDayTime[size];
        }
    };

    private String categoryOpenTime;
    private String categoryCloseTime;

    private Calendar openTimeCalender;
    private Calendar closedTimeCalender;

    @SerializedName("category_open_time")
    private Object categoryOpenTimeMinute;

    @SerializedName("category_close_time")
    private Object categoryCloseTimeMinute;

    public CategoryDayTime() {
    }

    protected CategoryDayTime(Parcel in) {
        this.categoryOpenTime = in.readString();
        this.categoryCloseTime = in.readString();
        this.openTimeCalender = (Calendar) in.readSerializable();
        this.closedTimeCalender = (Calendar) in.readSerializable();
        this.categoryOpenTimeMinute = in.readInt();
        this.categoryCloseTimeMinute = in.readInt();
    }

    public String getCategoryOpenTime() {
        return categoryOpenTime;
    }

    public void setCategoryOpenTime(String categoryOpenTime) {
        this.categoryOpenTime = categoryOpenTime;
    }

    public String getCategoryCloseTime() {
        return categoryCloseTime;
    }

    public void setCategoryCloseTime(String categoryCloseTime) {
        this.categoryCloseTime = categoryCloseTime;
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
    public int compareTo(CategoryDayTime dayTime) {
        return this.openTimeCalender.getTimeInMillis() > dayTime.getOpenTimeCalender().getTimeInMillis() ? 1 : -1;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.categoryOpenTime);
        dest.writeString(this.categoryCloseTime);
        dest.writeSerializable(this.openTimeCalender);
        dest.writeSerializable(this.closedTimeCalender);
        dest.writeInt(getCategoryOpenTimeMinute());
        dest.writeInt(getCategoryCloseTimeMinute());
    }

    public int getCategoryOpenTimeMinute() {
        if (categoryOpenTimeMinute instanceof Number) {
            return ((Number) categoryOpenTimeMinute).intValue();
        } else {
            return 0;
        }
    }

    public int getCategoryCloseTimeMinute() {
        if (categoryCloseTimeMinute instanceof Number) {
            return ((Number) categoryCloseTimeMinute).intValue();
        } else {
            return 0;
        }
    }
}