package com.dropo.store.models.datamodel;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

import javax.annotation.Generated;

import static android.icu.lang.UCharacter.GraphemeClusterBreak.V;

@Generated("com.robohorse.robopojogenerator")
public class SpecificationGroupForAdd implements Serializable {

    private boolean isEdited;
    @SerializedName("store_id")
    private String storeId;

    @SerializedName("unique_id")
    private int uniqueId;

    @SerializedName("updated_at")
    private String updatedAt;

    @SerializedName("product_id")
    private String productId;


    @SerializedName("name")
    private String name;

    @SerializedName("created_at")
    private String createdAt;

    @SerializedName("_id")
    private String id;

    @SerializedName("specifications")
    private List<ProductSpecification> specifications;

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
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

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public List<ProductSpecification> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<ProductSpecification> specifications) {
        this.specifications = specifications;
    }

    @Override
    public String toString() {
        return "SpecificationGroup{" + "store_id = '" + storeId + '\'' + ",unique_id = '" + uniqueId + '\'' + ",updated_at = '" + updatedAt + '\'' + ",product_id = '" + productId + '\'' + ",__v = '" + V + '\'' + ",name = '" + name + '\'' + ",created_at = '" + createdAt + '\'' + ",_id = '" + id + '\'' + ",specifications = '" + specifications + '\'' + "}";
    }

    public boolean isEdited() {
        return isEdited;
    }

    public void setEdited(boolean edited) {
        isEdited = edited;
    }


}