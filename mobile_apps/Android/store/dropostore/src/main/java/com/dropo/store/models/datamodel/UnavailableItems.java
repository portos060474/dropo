package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class UnavailableItems implements Parcelable {
    @SerializedName("item_id")
    private String itemId;

    @SerializedName("item_name")
    private String itemName;

    @SerializedName("product_id")
    private String productId;

    @SerializedName("product_name")
    private String productName;

    protected UnavailableItems(Parcel in) {
        itemId = in.readString();
        itemName = in.readString();
        productId = in.readString();
        productName = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(itemId);
        dest.writeString(itemName);
        dest.writeString(productId);
        dest.writeString(productName);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<UnavailableItems> CREATOR = new Creator<UnavailableItems>() {
        @Override
        public UnavailableItems createFromParcel(Parcel in) {
            return new UnavailableItems(in);
        }

        @Override
        public UnavailableItems[] newArray(int size) {
            return new UnavailableItems[size];
        }
    };

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
}
