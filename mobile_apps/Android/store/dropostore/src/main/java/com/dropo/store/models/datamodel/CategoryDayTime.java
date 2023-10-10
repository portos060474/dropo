package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class CategoryDayTime implements Parcelable {

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

    @SerializedName("category_open_time")
    private Object categoryOpenTimeMinute;
    @SerializedName("category_close_time")
    private Object categoryCloseTimeMinute;

    public CategoryDayTime() {

    }

    protected CategoryDayTime(Parcel in) {
        this.categoryOpenTime = in.readString();
        this.categoryCloseTime = in.readString();
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

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.categoryOpenTime);
        dest.writeString(this.categoryCloseTime);
        dest.writeInt(getCategoryOpenTimeMinute());
        dest.writeInt(getCategoryCloseTimeMinute());
    }

    public int getCategoryOpenTimeMinute() {
        if (categoryOpenTimeMinute instanceof Number) {
            return (int) ((Number) categoryOpenTimeMinute).intValue();
        } else {
            return 0;
        }
    }

    public void setCategoryOpenTimeMinute(int categoryOpenTimeMinute) {
        this.categoryOpenTimeMinute = categoryOpenTimeMinute;
    }

    public int getCategoryCloseTimeMinute() {
        if (categoryCloseTimeMinute instanceof Number) {
            return (int) ((Number) categoryCloseTimeMinute).intValue();
        } else {
            return 0;
        }
    }

    public void setCategoryCloseTimeMinute(int categoryCloseTimeMinute) {
        this.categoryCloseTimeMinute = categoryCloseTimeMinute;
    }
}