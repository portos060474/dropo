package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class SpeficiationGroup implements Parcelable {


    public static final Parcelable.Creator<SpeficiationGroup> CREATOR = new Parcelable.Creator<SpeficiationGroup>() {
        @Override
        public SpeficiationGroup createFromParcel(Parcel source) {
            return new SpeficiationGroup(source);
        }

        @Override
        public SpeficiationGroup[] newArray(int size) {
            return new SpeficiationGroup[size];
        }
    };

    private String chooseMessage;
    private int selectedCount;
    @SerializedName("range")
    @Expose
    private int range;
    @SerializedName("max_range")
    @Expose
    private int maxRange;
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

    public SpeficiationGroup() {
    }

    protected SpeficiationGroup(Parcel in) {
        this.range = in.readInt();
        this.maxRange = in.readInt();
        this.isRequired = in.readByte() != 0;
        this.uniqueId = in.readInt();
        this.price = in.readDouble();
        this.name = in.readString();
        this.list = in.createTypedArrayList(SpecificationSubItem.CREATOR);
        this.type = in.readInt();
    }

    public String getChooseMessage() {
        return chooseMessage;
    }

    public void setChooseMessage(String chooseMessage) {
        this.chooseMessage = chooseMessage;
    }

    public int getSelectedCount() {
        return selectedCount;
    }

    public void setSelectedCount(int selectedCount) {
        this.selectedCount = selectedCount;
    }

    public int getRange() {
        return range;
    }

    public void setRange(int range) {
        this.range = range;
    }

    public int getMaxRange() {
        return maxRange;
    }

    public void setMaxRange(int maxRange) {
        this.maxRange = maxRange;
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
        dest.writeInt(this.range);
        dest.writeInt(this.maxRange);
        dest.writeByte(this.isRequired ? (byte) 1 : (byte) 0);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.price);
        dest.writeString(this.name);
        dest.writeTypedList(this.list);
        dest.writeInt(this.type);
    }
}
