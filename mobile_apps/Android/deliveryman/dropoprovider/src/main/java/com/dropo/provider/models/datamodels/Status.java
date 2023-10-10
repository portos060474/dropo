package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class Status implements Parcelable {

    public static final Creator<Status> CREATOR = new Creator<Status>() {
        @Override
        public Status createFromParcel(Parcel source) {
            return new Status(source);
        }

        @Override
        public Status[] newArray(int size) {
            return new Status[size];
        }
    };
    @SerializedName("date")
    private String date;
    @SerializedName("status")
    private int status;
    @SerializedName("image_url")
    private String imageUrl;
    @SerializedName("waiting_time")
    private long waitingTime;
    @SerializedName("stop_no")
    private int stopNo;

    public Status() {
    }

    protected Status(Parcel in) {
        this.date = in.readString();
        this.status = in.readInt();
        this.imageUrl = in.readString();
        this.waitingTime = in.readLong();
        this.stopNo = in.readInt();
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public long getWaitingTime() {
        return waitingTime;
    }

    public void setWaitingTime(long waitingTime) {
        this.waitingTime = waitingTime;
    }

    public int getStopNo() {
        return stopNo;
    }

    public void setStopNo(int stopNo) {
        this.stopNo = stopNo;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.date);
        dest.writeInt(this.status);
        dest.writeString(this.imageUrl);
        dest.writeLong(this.waitingTime);
        dest.writeInt(this.stopNo);
    }
}