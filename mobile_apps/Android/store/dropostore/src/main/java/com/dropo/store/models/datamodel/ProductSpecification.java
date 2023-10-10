package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Utilities;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class ProductSpecification implements Parcelable, Comparable<ProductSpecification> {


    public static final Creator<ProductSpecification> CREATOR = new Creator<ProductSpecification>() {
        @Override
        public ProductSpecification createFromParcel(Parcel source) {
            return new ProductSpecification(source);
        }

        @Override
        public ProductSpecification[] newArray(int size) {
            return new ProductSpecification[size];
        }
    };
    @SerializedName("sequence_number")
    @Expose
    private Long sequenceNumber;
    private boolean isArrayData;
    @SerializedName("is_user_selected")
    @Expose
    private boolean isUserSelected;
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
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("specification_group_id")
    @Expose
    private String specificationGroupId;
    private String specificationName;

    public ProductSpecification() {
    }

    protected ProductSpecification(Parcel in) {
        this.isUserSelected = in.readByte() != 0;
        this.price = in.readDouble();
        this.isArrayData = in.readByte() != 0;
        this.name = !isArrayData ? in.readString() : in.createStringArrayList();
        this.id = in.readString();
        this.isDefaultSelected = in.readByte() != 0;
        this.uniqueId = in.readInt();
        this.specificationGroupId = in.readString();
        this.specificationName = in.readString();
        this.sequenceNumber = in.readLong();
        this.quantity = in.readInt();
    }

    public void setUserSelected(boolean userSelected) {
        isUserSelected = userSelected;
    }

    public String getSpecificationGroupId() {
        return specificationGroupId;
    }

    public void setSpecificationGroupId(String specificationGroupId) {
        this.specificationGroupId = specificationGroupId;
    }

    public boolean isIsUserSelected() {
        return isUserSelected;
    }

    public void setIsUserSelected(boolean isUserSelected) {
        this.isUserSelected = isUserSelected;
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
            return Utilities.getDetailStringFromList((ArrayList<String>) name, Language.getInstance().
                    getStoreLanguageIndex());
        }
    }

    public void setName(Object name) {
        this.name = name;
    }

    public void setNameListToString() {
        if (this.name instanceof String) {
            return;
        }
        this.name = Utilities.getDetailStringFromList((ArrayList<String>) name, Language.getInstance().
                getStoreLanguageIndex());
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

    public String getSpecificationName() {
        return specificationName;
    }

    public void setSpecificationName(String specificationName) {
        this.specificationName = specificationName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isUserSelected ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.price);
        this.isArrayData = name instanceof List;
        dest.writeByte(this.isArrayData ? (byte) 1 : (byte) 0);
        if (!isArrayData) {
            dest.writeString(String.valueOf(name));
        } else {
            dest.writeStringList((List<String>) name);
        }
        dest.writeString(this.id);
        dest.writeByte(this.isDefaultSelected ? (byte) 1 : (byte) 0);
        dest.writeInt(this.uniqueId);
        dest.writeString(this.specificationGroupId);
        dest.writeString(this.specificationName);
        dest.writeLong(this.sequenceNumber != null ? this.sequenceNumber : 0L);
        dest.writeInt(this.quantity);
    }

    public Long getSequenceNumber() {
        return sequenceNumber;
    }

    @Override
    public int compareTo(ProductSpecification o) {
        return this.sequenceNumber > o.sequenceNumber ? 1 : -1;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ProductSpecification that = (ProductSpecification) o;
        return uniqueId == that.uniqueId && quantity == that.quantity;
    }
}