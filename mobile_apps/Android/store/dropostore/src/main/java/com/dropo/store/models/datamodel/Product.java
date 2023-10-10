package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Utilities;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Product implements Parcelable, Comparable<Product> {

    private boolean isProductFiltered = true;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("is_visible_in_store")
    @Expose
    private boolean isVisibleInStore;
    @SerializedName("specifications_details")
    @Expose
    private ArrayList<ProductSpecification> specificationsDetails;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("name")
    @Expose
    private Object name;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("details")
    @Expose
    private String details;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("sequence_number")
    @Expose
    private Long sequenceNumber=0L;
    @SerializedName("items")
    @Expose
    private ArrayList<Item> items;
    private boolean isArrayData;
    private boolean isSelected;

    public Product() {
    }

    protected Product(Parcel in) {
        isProductFiltered = in.readByte() != 0;
        storeId = in.readString();
        isVisibleInStore = in.readByte() != 0;
        specificationsDetails = in.createTypedArrayList(ProductSpecification.CREATOR);
        uniqueId = in.readInt();
        updatedAt = in.readString();
        imageUrl = in.readString();
        this.isArrayData = in.readByte() != 0;
        this.name = !isArrayData ? in.readString() : in.createStringArrayList();
        createdAt = in.readString();
        details = in.readString();
        id = in.readString();
        if (in.readByte() == 0) {
            sequenceNumber = null;
        } else {
            sequenceNumber = in.readLong();
        }
        items = in.createTypedArrayList(Item.CREATOR);
        isArrayData = in.readByte() != 0;
        isSelected = in.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte((byte) (isProductFiltered ? 1 : 0));
        dest.writeString(storeId);
        dest.writeByte((byte) (isVisibleInStore ? 1 : 0));
        dest.writeTypedList(specificationsDetails);
        dest.writeInt(uniqueId);
        dest.writeString(updatedAt);
        dest.writeString(imageUrl);
        this.isArrayData = name instanceof List;
        dest.writeByte(this.isArrayData ? (byte) 1 : (byte) 0);
        if (!isArrayData) {
            dest.writeString(String.valueOf(name));
        } else {
            dest.writeStringList((List<String>) name);
        }
        dest.writeString(createdAt);
        dest.writeString(details);
        dest.writeString(id);
        if (sequenceNumber == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeLong(sequenceNumber);
        }
        dest.writeTypedList(items);
        dest.writeByte((byte) (isArrayData ? 1 : 0));
        dest.writeByte((byte) (isSelected ? 1 : 0));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<Product> CREATOR = new Creator<Product>() {
        @Override
        public Product createFromParcel(Parcel in) {
            return new Product(in);
        }

        @Override
        public Product[] newArray(int size) {
            return new Product[size];
        }
    };

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public boolean isIsVisibleInStore() {
        return isVisibleInStore;
    }

    public void setIsVisibleInStore(boolean isVisibleInStore) {
        this.isVisibleInStore = isVisibleInStore;
    }

    public ArrayList<ProductSpecification> getSpecificationsDetails() {
        return specificationsDetails;
    }

    public void setSpecificationsDetails(ArrayList<ProductSpecification> specificationsDetails) {
        this.specificationsDetails = specificationsDetails;
    }

    public ArrayList<Item> getItems() {
        return items;
    }

    public void setItems(ArrayList<Item> items) {
        this.items = items;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getName() {
        if (name instanceof String) {
            return String.valueOf(name);
        } else {
            return Utilities.getDetailStringFromList(((ArrayList<String>) name), Language.getInstance().
                    getStoreLanguageIndex());

        }
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<String> getNameList() {
        return (List<String>) name;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isVisibleInStore() {
        return isVisibleInStore;
    }

    public void setVisibleInStore(boolean visibleInStore) {
        isVisibleInStore = visibleInStore;
    }

    public boolean isProductFiltered() {
        return isProductFiltered;
    }

    public void setProductFiltered(boolean productFiltered) {
        isProductFiltered = productFiltered;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public Product copy() {
        Product product = new Product();
        product.setStoreId(this.storeId);
        product.setIsVisibleInStore(this.isVisibleInStore);
        product.setSpecificationsDetails(this.specificationsDetails);
        product.setUniqueId(this.uniqueId);
        product.setUpdatedAt(this.updatedAt);
        product.setImageUrl(this.imageUrl);
        product.setCreatedAt(this.createdAt);
        product.setDetails(this.details);
        product.setId(this.id);
        product.setItems(new ArrayList<Item>());
        product.setName(getName());
        product.setSequenceNumber(product.sequenceNumber != null ? product.sequenceNumber : 0L);
        return product;
    }

    public Long getSequenceNumber() {
        return sequenceNumber;
    }

    public void setSequenceNumber(Long sequenceNumber) {
        this.sequenceNumber = sequenceNumber;
    }

    @Override
    public int compareTo(Product o) {
        return this.sequenceNumber > o.getSequenceNumber() ? 1 : -1;
    }
}