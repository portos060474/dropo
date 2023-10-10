package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class OrderProducts {


    @SerializedName("store_id")
    @Expose
    private String storeId;

    @SerializedName("total_item_price")
    @Expose
    private double totalItemAndSpecificationPrice;

    @SerializedName("product_id")
    @Expose
    private String productId;

    @SerializedName("items")
    @Expose
    private List<OrderProductItem> items;

    @SerializedName("product_name")
    @Expose
    private String productName;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public List<OrderProductItem> getItems() {
        return items;
    }

    public void setItems(List<OrderProductItem> items) {
        this.items = items;
    }

    public double getTotalItemAndSpecificationPrice() {
        return totalItemAndSpecificationPrice;
    }

    public void setTotalItemAndSpecificationPrice(double totalItemAndSpecificationPrice) {
        this.totalItemAndSpecificationPrice = totalItemAndSpecificationPrice;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }


}