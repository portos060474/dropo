package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Specifications implements Parcelable {


    public static final Creator<Specifications> CREATOR = new Creator<Specifications>() {
        @Override
        public Specifications createFromParcel(Parcel source) {
            return new Specifications(source);
        }

        @Override
        public Specifications[] newArray(int size) {
            return new Specifications[size];
        }
    };
    @SerializedName("is_required")
    @Expose
    private boolean isRequired;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("price")
    @Expose
    private double price;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("list")
    @Expose
    private List<SpecificationSubItem> list;
    @SerializedName("type")
    @Expose
    private int type;

    public Specifications() {
    }

    protected Specifications(Parcel in) {
        this.isRequired = in.readByte() != 0;
        this.uniqueId = in.readInt();
        this.price = in.readDouble();
        this.name = in.readString();
        this.list = in.createTypedArrayList(SpecificationSubItem.CREATOR);
        this.type = in.readInt();
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<SpecificationSubItem> getList() {
        return list;
    }

    public void setList(List<SpecificationSubItem> list) {
        this.list = list;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public boolean isRequired() {
        return isRequired;
    }

    public void setRequired(boolean required) {
        isRequired = required;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isRequired ? (byte) 1 : (byte) 0);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.price);
        dest.writeString(this.name);
        dest.writeTypedList(this.list);
        dest.writeInt(this.type);
    }
}