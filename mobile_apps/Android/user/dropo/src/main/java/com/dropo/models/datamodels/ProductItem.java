package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class ProductItem implements Parcelable, Comparable<ProductItem> {
    public static final Creator<ProductItem> CREATOR = new Creator<ProductItem>() {
        @Override
        public ProductItem createFromParcel(Parcel source) {
            return new ProductItem(source);
        }

        @Override
        public ProductItem[] newArray(int size) {
            return new ProductItem[size];
        }
    };
    @SerializedName("sequence_number")
    @Expose
    private long sequenceNumber;


    @SerializedName("tax")
    @Expose
    private double tax;

    @SerializedName("item_price_without_offer")
    @Expose
    private double itemPriceWithoutOffer;
    @SerializedName("offer_message_or_percentage")
    @Expose
    private String offerMessageOrPercentage;
    private String currency;
    @SerializedName("quantity")
    @Expose
    private int quantity;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("total_price")
    @Expose
    private double totalPrice;
    @SerializedName("image_url")
    @Expose
    private List<String> imageUrl;

    @SerializedName("is_out_of_stock")
    @Expose
    private boolean isOutOfStock;
    @SerializedName("no_of_order")
    @Expose
    private int noOfOrder;
    @SerializedName("is_default")
    @Expose
    private boolean isDefault;
    @SerializedName("specifications")
    @Expose
    private List<Specifications> specifications;

    @SerializedName("total_item_price")
    @Expose
    private double totalItemPrice;
    @SerializedName("price")
    @Expose
    private double price;
    @SerializedName("instruction")
    @Expose
    private String instruction;
    @SerializedName("product_id")
    @Expose
    private String productId;
    @SerializedName("name")
    @Expose
    private String name = "";
    @SerializedName("details")
    @Expose
    private String details = "";
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("total_specification_price")
    @Expose
    private double totalSpecificationPrice;
    @SerializedName("max_item_quantity")
    @Expose
    private int maxItemQuantity = 10;

    @SerializedName("tax_details")
    private ArrayList<TaxesDetail> taxesDetails;

    private int cartItemQuantity = 0;

    public ProductItem() {
    }

    protected ProductItem(Parcel in) {
        this.tax = in.readDouble();
        this.itemPriceWithoutOffer = in.readDouble();
        this.offerMessageOrPercentage = in.readString();
        this.currency = in.readString();
        this.quantity = in.readInt();
        this.storeId = in.readString();
        this.uniqueId = in.readInt();
        this.totalPrice = in.readDouble();
        this.imageUrl = in.createStringArrayList();
        this.isOutOfStock = in.readByte() != 0;
        this.noOfOrder = in.readInt();
        this.isDefault = in.readByte() != 0;
        this.specifications = in.createTypedArrayList(Specifications.CREATOR);
        this.totalItemPrice = in.readDouble();
        this.price = in.readDouble();
        this.instruction = in.readString();
        this.productId = in.readString();
        this.name = in.readString();
        this.details = in.readString();
        this.id = in.readString();
        this.totalSpecificationPrice = in.readDouble();
        this.maxItemQuantity = in.readInt();
        this.sequenceNumber = in.readLong();
        taxesDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
        this.cartItemQuantity = in.readInt();
    }

    public ArrayList<TaxesDetail> getTaxesDetails() {
        return taxesDetails;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public double getTotalTax() {
        if (taxesDetails != null && !taxesDetails.isEmpty()) {
            double tax = 0;
            for (TaxesDetail taxesDetail : taxesDetails) {
                tax += taxesDetail.getTax();
            }
            return tax;
        } else {
            return 0.0;
        }
    }

    public double getItemPriceWithoutOffer() {
        return itemPriceWithoutOffer;
    }

    public void setItemPriceWithoutOffer(double itemPriceWithoutOffer) {
        this.itemPriceWithoutOffer = itemPriceWithoutOffer;
    }

    public String getOfferMessageOrPercentage() {
        return offerMessageOrPercentage;
    }

    public void setOfferMessageOrPercentage(String offerMessageOrPercentage) {
        this.offerMessageOrPercentage = offerMessageOrPercentage;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public int getMaxItemQuantity() {
        return maxItemQuantity;
    }

    public void setMaxItemQuantity(int maxItemQuantity) {
        this.maxItemQuantity = maxItemQuantity;
    }

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

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(int totalPrice) {
        this.totalPrice = totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public boolean isIsOutOfStock() {
        return isOutOfStock;
    }

    public void setIsOutOfStock(boolean isOutOfStock) {
        this.isOutOfStock = isOutOfStock;
    }

    public int getNoOfOrder() {
        return noOfOrder;
    }

    public void setNoOfOrder(int noOfOrder) {
        this.noOfOrder = noOfOrder;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public List<Specifications> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specifications> specifications) {
        this.specifications = specifications;
    }

    public double getTotalItemPrice() {
        return totalItemPrice;
    }

    public void setTotalItemPrice(double totalItemPrice) {
        this.totalItemPrice = totalItemPrice;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getInstruction() {
        return instruction;
    }

    public void setInstruction(String instruction) {
        this.instruction = instruction;
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

    public double getTotalSpecificationPrice() {
        return totalSpecificationPrice;
    }

    public void setTotalSpecificationPrice(double totalSpecificationPrice) {
        this.totalSpecificationPrice = totalSpecificationPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public List<String> getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(List<String> imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isOutOfStock() {
        return isOutOfStock;
    }

    public void setOutOfStock(boolean outOfStock) {
        isOutOfStock = outOfStock;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public void setCartItemQuantity(int cartItemQuantity) {
        this.cartItemQuantity = cartItemQuantity;
    }

    public int getCartItemQuantity() {
        return cartItemQuantity;
    }

    public ProductItem copy() {
        ProductItem itemsItem = new ProductItem();
        itemsItem.setQuantity(this.quantity);
        itemsItem.setStoreId(this.storeId);
        itemsItem.setUniqueId(this.uniqueId);
        itemsItem.setTotalPrice(this.totalPrice);
        itemsItem.setImageUrl(this.imageUrl);
        itemsItem.setIsOutOfStock(this.isOutOfStock);
        itemsItem.setNoOfOrder(this.noOfOrder);
        itemsItem.setIsDefault(this.isDefault);
        itemsItem.setSpecifications(this.specifications);
        itemsItem.setTotalItemPrice(this.totalItemPrice);
        itemsItem.setPrice(this.price);
        itemsItem.setInstruction(this.instruction);
        itemsItem.setProductId(this.productId);
        itemsItem.setName(this.name);
        itemsItem.setDetails(this.details);
        itemsItem.setId(this.id);
        itemsItem.setTotalSpecificationPrice(this.totalSpecificationPrice);
        itemsItem.setCartItemQuantity(this.cartItemQuantity);
        return itemsItem;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeDouble(this.tax);
        dest.writeDouble(this.itemPriceWithoutOffer);
        dest.writeString(this.offerMessageOrPercentage);
        dest.writeString(this.currency);
        dest.writeInt(this.quantity);
        dest.writeString(this.storeId);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.totalPrice);
        dest.writeStringList(this.imageUrl);
        dest.writeByte(this.isOutOfStock ? (byte) 1 : (byte) 0);
        dest.writeInt(this.noOfOrder);
        dest.writeByte(this.isDefault ? (byte) 1 : (byte) 0);
        dest.writeTypedList(this.specifications);
        dest.writeDouble(this.totalItemPrice);
        dest.writeDouble(this.price);
        dest.writeString(this.instruction);
        dest.writeString(this.productId);
        dest.writeString(this.name);
        dest.writeString(this.details);
        dest.writeString(this.id);
        dest.writeDouble(this.totalSpecificationPrice);
        dest.writeInt(this.maxItemQuantity);
        dest.writeLong(this.sequenceNumber);
        dest.writeTypedList(taxesDetails);
        dest.writeInt(cartItemQuantity);
    }

    public long getSequenceNumber() {
        return sequenceNumber;
    }

    @Override
    public int compareTo(ProductItem o) {
        return this.sequenceNumber > o.sequenceNumber ? 1 : -1;
    }
}