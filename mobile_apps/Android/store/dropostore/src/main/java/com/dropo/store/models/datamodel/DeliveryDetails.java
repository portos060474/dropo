package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class DeliveryDetails implements Parcelable {

    public static final Creator<DeliveryDetails> CREATOR = new Creator<DeliveryDetails>() {
        @Override
        public DeliveryDetails createFromParcel(Parcel in) {
            return new DeliveryDetails(in);
        }

        @Override
        public DeliveryDetails[] newArray(int size) {
            return new DeliveryDetails[size];
        }
    };
    @SerializedName("famous_products_tags")
    @Expose
    private List<FamousProductsTags> famousProductsTags;
    @SerializedName("is_store_can_create_group")
    @Expose
    private boolean isStoreCanCreateGroup;

    public DeliveryDetails() {
    }

    protected DeliveryDetails(Parcel in) {
        this.isStoreCanCreateGroup = in.readByte() != 0;
        this.famousProductsTags = new ArrayList<>();
        this.famousProductsTags = in.createTypedArrayList(FamousProductsTags.CREATOR);
    }

    public List<FamousProductsTags> getFamousProductsTags() {
        return famousProductsTags;
    }

    public boolean isStoreCanCreateGroup() {
        return isStoreCanCreateGroup;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte((byte) (isStoreCanCreateGroup ? 1 : 0));
        dest.writeTypedList(this.famousProductsTags);
    }

    @Override
    public int describeContents() {
        return 0;
    }
}