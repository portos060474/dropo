package com.dropo.store.models.datamodel;

import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Utilities;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class Category implements Serializable {

    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;

    @SerializedName("icon_url")
    @Expose
    private String iconUrl;

    @SerializedName("updated_at")
    @Expose
    private String updatedAt;

    @SerializedName("delivery_type")
    @Expose
    private int deliveryType;

    @SerializedName("delivery_name")
    @Expose
    private List<String> deliveryName;

    @SerializedName("image_url")
    @Expose
    private String imageUrl;

    @SerializedName("__v")
    @Expose
    private int V;

    @SerializedName("created_at")
    @Expose
    private String createdAt;

    @SerializedName("_id")
    @Expose
    private String id;

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public String getDeliveryName() {
        return Utilities.getDetailStringFromList((ArrayList<String>) deliveryName, Language.getInstance().
                getAdminLanguageIndex());
    }

    public void setDeliveryName(List<String> deliveryName) {
        this.deliveryName = deliveryName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getV() {
        return V;
    }

    public void setV(int V) {
        this.V = V;
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
}