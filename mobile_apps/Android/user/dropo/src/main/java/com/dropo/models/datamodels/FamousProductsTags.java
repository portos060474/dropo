package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class FamousProductsTags implements Parcelable {

    @SerializedName("tag_id")
    private String tagId;
    @SerializedName("tag")
    private String tag;

    protected FamousProductsTags(Parcel in) {
        this.tagId = in.readString();
        this.tag = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.tagId);
        dest.writeString(this.tag);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<FamousProductsTags> CREATOR = new Creator<FamousProductsTags>() {
        @Override
        public FamousProductsTags createFromParcel(Parcel in) {
            return new FamousProductsTags(in);
        }

        @Override
        public FamousProductsTags[] newArray(int size) {
            return new FamousProductsTags[size];
        }
    };

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }
}
