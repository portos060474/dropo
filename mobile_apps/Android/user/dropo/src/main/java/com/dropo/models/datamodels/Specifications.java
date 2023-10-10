package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;
import java.util.Objects;

public class Specifications implements Parcelable, Comparable<Specifications> {

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
    @SerializedName("sequence_number")
    @Expose
    private long sequenceNumber;

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
    private Object name;
    @SerializedName("list")
    @Expose
    private List<SpecificationSubItem> list;
    @SerializedName("type")
    @Expose
    private int type;
    @SerializedName("user_can_add_specification_quantity")
    @Expose
    private boolean userCanAddSpecificationQuantity;
    @SerializedName("isParentAssociate")
    @Expose
    private boolean isParentAssociate;
    @SerializedName("isAssociated")
    @Expose
    private boolean isAssociated;
    @SerializedName("modifierId")
    @Expose
    private String modifierId;
    @SerializedName("modifierGroupId")
    @Expose
    private String modifierGroupId;
    @SerializedName("modifierName")
    @Expose
    private String modifierName;
    @SerializedName("modifierGroupName")
    @Expose
    private String modifierGroupName;
    @SerializedName("_id")
    @Expose
    private String id;

    public Specifications() {
    }

    protected Specifications(Parcel in) {
        this.id = in.readString();
        this.range = in.readInt();
        this.maxRange = in.readInt();
        this.isRequired = in.readByte() != 0;
        this.uniqueId = in.readInt();
        this.price = in.readDouble();
        this.name = in.readString();
        this.list = in.createTypedArrayList(SpecificationSubItem.CREATOR);
        this.type = in.readInt();
        this.sequenceNumber = in.readLong();
        this.userCanAddSpecificationQuantity = in.readByte() != 0;
        this.modifierId = in.readString();
        this.modifierGroupId = in.readString();
        this.isAssociated = in.readByte() != 0;
        this.isParentAssociate = in.readByte() != 0;
        this.modifierName = in.readString();
        this.modifierGroupName = in.readString();
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
        if (name instanceof String) {
            return String.valueOf(name);
        } else {
            return "";
        }
    }

    public void setName(Object name) {
        this.name = name;
    }

    public List<SpecificationSubItem> getList() {
        return list;
    }

    public void setList(List<SpecificationSubItem> list) {
        this.list = list;
    }

    public boolean isUserCanAddSpecificationQuantity() {
        return userCanAddSpecificationQuantity;
    }

    public void setUserCanAddSpecificationQuantity(boolean userCanAddSpecificationQuantity) {
        this.userCanAddSpecificationQuantity = userCanAddSpecificationQuantity;
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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isParentAssociate() {
        return isParentAssociate;
    }

    public void setParentAssociate(boolean parentAssociate) {
        isParentAssociate = parentAssociate;
    }

    public boolean isAssociated() {
        return isAssociated;
    }

    public void setAssociated(boolean associated) {
        isAssociated = associated;
    }

    public String getModifierId() {
        return modifierId;
    }

    public void setModifierId(String modifierId) {
        this.modifierId = modifierId;
    }

    public String getModifierGroupId() {
        return modifierGroupId;
    }

    public void setModifierGroupId(String modifierGroupId) {
        this.modifierGroupId = modifierGroupId;
    }

    public String getModifierName() {
        return modifierName;
    }

    public void setModifierName(String modifierName) {
        this.modifierName = modifierName;
    }

    public String getModifierGroupName() {
        return modifierGroupName;
    }

    public void setModifierGroupName(String modifierGroupName) {
        this.modifierGroupName = modifierGroupName;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.id);
        dest.writeInt(this.range);
        dest.writeInt(this.maxRange);
        dest.writeByte(this.isRequired ? (byte) 1 : (byte) 0);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.price);
        dest.writeString(name instanceof String ? String.valueOf(name) : "");
        dest.writeTypedList(this.list);
        dest.writeInt(this.type);
        dest.writeLong(this.sequenceNumber);
        dest.writeByte(this.userCanAddSpecificationQuantity ? (byte) 1 : (byte) 0);
        dest.writeString(this.modifierId);
        dest.writeString(this.modifierGroupId);
        dest.writeByte(this.isAssociated ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isParentAssociate ? (byte) 1 : (byte) 0);
        dest.writeString(this.modifierName);
        dest.writeString(this.modifierGroupName);
    }

    public long getSequenceNumber() {
        return sequenceNumber;
    }

    @Override
    public int compareTo(Specifications o) {
        return this.sequenceNumber > o.sequenceNumber ? 1 : -1;
    }

    @Override
    public int hashCode() {
        return Objects.hash(sequenceNumber, chooseMessage, selectedCount, range, maxRange, isRequired, uniqueId, price, name, list, type, userCanAddSpecificationQuantity, isParentAssociate, isAssociated, modifierId, modifierGroupId, modifierName, modifierGroupName, id);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Specifications that = (Specifications) o;
        return uniqueId == that.uniqueId && Objects.equals(list, that.list);
    }
}