package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Ads {

    @SerializedName("image_url")
    private String imageUrl;

    @SerializedName("_id")
    private String id;

    @SerializedName("is_ads_redirect_to_store")
    private boolean isAdsRedirectToStore;

    @SerializedName("store_detail")
    @Expose
    private Store store;

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public boolean isAdsRedirectToStore() {
        return isAdsRedirectToStore;
    }
}