package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class CategoryTime implements Parcelable {

    public static final Creator<CategoryTime> CREATOR = new Creator<CategoryTime>() {
        @Override
        public CategoryTime createFromParcel(Parcel source) {
            return new CategoryTime(source);
        }

        @Override
        public CategoryTime[] newArray(int size) {
            return new CategoryTime[size];
        }
    };

    @SerializedName("is_category_open_full_time")
    private boolean isCategoryOpenFullTime;

    @SerializedName("is_category_open")
    private boolean isCategoryOpen;

    @SerializedName("day")
    private int day;

    @SerializedName("day_time")
    private List<CategoryDayTime> dayTime;

    public CategoryTime() {
    }

    protected CategoryTime(Parcel in) {
        this.isCategoryOpenFullTime = in.readByte() != 0;
        this.isCategoryOpen = in.readByte() != 0;
        this.day = in.readInt();
        this.dayTime = in.createTypedArrayList(CategoryDayTime.CREATOR);
    }

    public boolean isCategoryOpenFullTime() {
        return isCategoryOpenFullTime;
    }

    public void setCategoryOpenFullTime(boolean categoryOpenFullTime) {
        isCategoryOpenFullTime = categoryOpenFullTime;
    }

    public boolean isCategoryOpen() {
        return isCategoryOpen;
    }

    public void setCategoryOpen(boolean categoryOpen) {
        isCategoryOpen = categoryOpen;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }

    public List<CategoryDayTime> getDayTime() {
        return dayTime;
    }

    public void setDayTime(List<CategoryDayTime> dayTime) {
        this.dayTime = dayTime;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isCategoryOpenFullTime ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isCategoryOpen ? (byte) 1 : (byte) 0);
        dest.writeInt(this.day);
        dest.writeTypedList(this.dayTime);
    }
}