package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Utilities;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class ProductGroup implements Parcelable, Comparable<ProductGroup> {

    public static final Creator<ProductGroup> CREATOR = new Creator<ProductGroup>() {
        @Override
        public ProductGroup createFromParcel(Parcel in) {
            return new ProductGroup(in);
        }

        @Override
        public ProductGroup[] newArray(int size) {
            return new ProductGroup[size];
        }
    };
    @SerializedName("name")
    @Expose
    private List<String> name = null;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("sequence_number")
    @Expose
    private int sequenceNumber;
    @SerializedName("product_ids")
    @Expose
    private List<String> productIds = null;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("__v")
    @Expose
    private int v;
    @SerializedName("category_time")
    @Expose
    private ArrayList<CategoryTime> categoryTime;

    protected ProductGroup(Parcel in) {
        name = in.createStringArrayList();
        imageUrl = in.readString();
        sequenceNumber = in.readInt();
        productIds = in.createStringArrayList();
        id = in.readString();
        storeId = in.readString();
        createdAt = in.readString();
        updatedAt = in.readString();
        uniqueId = in.readInt();
        v = in.readInt();
        categoryTime = in.createTypedArrayList(CategoryTime.CREATOR);
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeStringList(name);
        dest.writeString(imageUrl);
        dest.writeInt(sequenceNumber);
        dest.writeStringList(productIds);
        dest.writeString(id);
        dest.writeString(storeId);
        dest.writeString(createdAt);
        dest.writeString(updatedAt);
        dest.writeInt(uniqueId);
        dest.writeInt(v);
        dest.writeTypedList(categoryTime);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public String getName() {
        return Utilities.getDetailStringFromList(name, Language.getInstance().
                getStoreLanguageIndex());
    }

    public void setName(List<String> name) {
        this.name = name;
    }

    public List<String> getNameList() {
        return name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getSequenceNumber() {
        return sequenceNumber;
    }

    public void setSequenceNumber(int sequenceNumber) {
        this.sequenceNumber = sequenceNumber;
    }

    public List<String> getProductIds() {
        return productIds;
    }

    public void setProductIds(List<String> productIds) {
        this.productIds = productIds;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getV() {
        return v;
    }

    public void setV(int v) {
        this.v = v;
    }

    public ArrayList<CategoryTime> getCategoryTime() {
        return categoryTime;
    }

    public void setCategoryTime(ArrayList<CategoryTime> categoryTime) {
        this.categoryTime = categoryTime;
    }

    @Override
    public int compareTo(ProductGroup o) {
        return this.sequenceNumber > o.sequenceNumber ? 1 : -1;
    }
}
