package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.Objects;

public class SpecificationSubItem implements Parcelable {


    public static final Parcelable.Creator<SpecificationSubItem> CREATOR = new Parcelable.Creator<SpecificationSubItem>() {
        @Override
        public SpecificationSubItem createFromParcel(Parcel source) {
            return new SpecificationSubItem(source);
        }

        @Override
        public SpecificationSubItem[] newArray(int size) {
            return new SpecificationSubItem[size];
        }
    };
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("price")
    @Expose
    private double price;
    @SerializedName("name")
    @Expose
    private Object name;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("is_default_selected")
    @Expose
    private boolean isDefaultSelected;
    @SerializedName("quantity")
    @Expose
    private int quantity = 1;

    public SpecificationSubItem() {
    }

    protected SpecificationSubItem(Parcel in) {
        this.uniqueId = in.readInt();
        this.price = in.readDouble();
        this.name = in.readString();
        this.id = in.readString();
        this.isDefaultSelected = in.readByte() != 0;
        this.quantity = in.readInt();
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getName() {
        if (name instanceof String) {
            return String.valueOf(name);
        } else {
            return "";
        }
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isIsDefaultSelected() {
        return isDefaultSelected;
    }

    public void setIsDefaultSelected(boolean isDefaultSelected) {
        this.isDefaultSelected = isDefaultSelected;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.price);
        dest.writeString(name instanceof String ? String.valueOf(name) : "");
        dest.writeString(this.id);
        dest.writeByte(this.isDefaultSelected ? (byte) 1 : (byte) 0);
        dest.writeInt(this.quantity);
    }

    @Override
    public int hashCode() {
        return Objects.hash(uniqueId, price, name, id, isDefaultSelected, quantity);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SpecificationSubItem that = (SpecificationSubItem) o;
        return uniqueId == that.uniqueId && quantity == that.quantity;
    }
}