package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class UnavailableItems {
    @SerializedName("item_id")
    private String itemId;

    @SerializedName("item_name")
    private String itemName;

    @SerializedName("product_id")
    private String productId;

    @SerializedName("product_name")
    private String productName;

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
}
