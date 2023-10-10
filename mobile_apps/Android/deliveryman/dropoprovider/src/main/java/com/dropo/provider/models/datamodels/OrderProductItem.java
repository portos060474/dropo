package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class OrderProductItem {

    @SerializedName("total_item_price")
    @Expose
    private double totalItemAndSpecificationPrice;


    @SerializedName("details")
    @Expose
    private String details;

    @SerializedName("item_name")
    @Expose
    private String itemName;

    @SerializedName("item_price")
    @Expose
    private double itemPrice;


    @SerializedName("total_specification_price")
    @Expose
    private double totalSpecificationPrice;

    @SerializedName("quantity")
    @Expose
    private int quantity;
    @SerializedName("note_for_item")
    private String noteForItem;
    @SerializedName("item_id")
    @Expose
    private String itemId;
    private String productDescription;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("image_url")
    @Expose
    private List<String> imageUrl;
    @SerializedName("specifications")
    @Expose
    private List<Specifications> specifications;

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getProductDescription() {
        return productDescription;
    }

    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public double getItemPrice() {
        return itemPrice;
    }

    public void setItemPrice(double itemPrice) {
        this.itemPrice = itemPrice;
    }

    public double getTotalSpecificationPrice() {
        return totalSpecificationPrice;
    }

    public void setTotalSpecificationPrice(double totalSpecificationPrice) {
        this.totalSpecificationPrice = totalSpecificationPrice;
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

    public List<String> getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(List<String> imageUrl) {
        this.imageUrl = imageUrl;
    }

    public List<Specifications> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specifications> specifications) {
        this.specifications = specifications;
    }

    public String getNoteForItem() {
        return noteForItem;
    }

    public void setNoteForItem(String noteForItem) {
        this.noteForItem = noteForItem;
    }
}