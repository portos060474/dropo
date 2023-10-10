package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class SubStoreAccessService implements Parcelable {


    public static final Parcelable.Creator<SubStoreAccessService> CREATOR = new Parcelable.Creator<SubStoreAccessService>() {
        @Override
        public SubStoreAccessService createFromParcel(Parcel source) {
            return new SubStoreAccessService(source);
        }

        @Override
        public SubStoreAccessService[] newArray(int size) {
            return new SubStoreAccessService[size];
        }
    };
    @SerializedName("name")
    private final String name;
    @SerializedName("url")
    private final String url;
    @SerializedName("permission")
    private int permission;

    public SubStoreAccessService(String name, String url) {
        this.name = name;
        this.url = url;
    }

    protected SubStoreAccessService(Parcel in) {
        this.name = in.readString();
        this.permission = in.readInt();
        this.url = in.readString();
    }

    public String getName() {
        return name;
    }

    public int getPermission() {
        return permission;
    }

    public void setPermission(int permission) {
        this.permission = permission;
    }

    public String getUrl() {
        return url;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.name);
        dest.writeInt(this.permission);
        dest.writeString(this.url);
    }

}