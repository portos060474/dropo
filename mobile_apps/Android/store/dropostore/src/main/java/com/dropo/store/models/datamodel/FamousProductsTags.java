package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class FamousProductsTags implements Parcelable {

    @SerializedName("tag_id")
    private String tagId;
    @SerializedName("tags")
    private ArrayList<String> tag;

    protected FamousProductsTags(Parcel in) {
        this.tagId = in.readString();
        this.tag = new ArrayList<>();
        in.readList(this.tag, String.class.getClassLoader());
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.tagId);
        dest.writeList(this.tag);
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

    public ArrayList<String> getTag() {
        return tag;
    }

    public void setTag(ArrayList<String> tag) {
        this.tag = tag;
    }
}
