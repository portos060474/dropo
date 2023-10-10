package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class CartProductItems implements Parcelable {


    public static final Creator<CartProductItems> CREATOR = new Creator<CartProductItems>() {
        @Override
        public CartProductItems createFromParcel(Parcel source) {
            return new CartProductItems(source);
        }

        @Override
        public CartProductItems[] newArray(int size) {
            return new CartProductItems[size];
        }
    };

    @SerializedName("item_price")
    @Expose
    private double itemPrice;

    @SerializedName("tax")
    @Expose
    private double tax;

    @SerializedName("item_tax")
    @Expose
    private double itemTax;

    @SerializedName("total_specification_price")
    @Expose
    private double totalSpecificationPrice;

    @SerializedName("total_specification_tax")
    @Expose
    private double totalSpecificationTax;

    @SerializedName("total_price")
    @Expose
    private double totalPrice;

    @SerializedName("total_tax")
    @Expose
    private double totalTax;

    @SerializedName("quantity")
    @Expose
    private int quantity;

    @SerializedName("total_item_price")
    private double totalItemAndSpecificationPrice;

    @SerializedName("total_item_tax")
    @Expose
    private double totalItemTax;


    @SerializedName("note_for_item")
    private String itemNote;

    @SerializedName("item_details")
    private ProductItem productItem;

    @SerializedName("details")
    @Expose
    private String details;
    @SerializedName("item_name")
    @Expose
    private String itemName;


    @SerializedName("item_id")
    @Expose
    private String itemId;
    @SerializedName("specifications")
    @Expose
    private List<Specifications> specifications;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("image_url")
    @Expose
    private List<String> imageUrl;
    @SerializedName("max_item_quantity")
    @Expose
    private int maxItemQuantity = 10;

    @SerializedName("tax_details")
    @Expose
    private ArrayList<TaxesDetail> taxesDetails;

    public CartProductItems() {
    }

    protected CartProductItems(Parcel in) {
        this.tax = in.readDouble();
        this.totalPrice = in.readDouble();
        this.totalTax = in.readDouble();
        this.totalSpecificationTax = in.readDouble();
        this.itemTax = in.readDouble();
        this.totalItemTax = in.readDouble();
        this.itemNote = in.readString();
        this.totalItemAndSpecificationPrice = in.readDouble();
        this.productItem = in.readParcelable(ProductItem.class.getClassLoader());
        this.details = in.readString();
        this.itemName = in.readString();
        this.itemPrice = in.readDouble();
        this.totalSpecificationPrice = in.readDouble();
        this.quantity = in.readInt();
        this.itemId = in.readString();
        this.specifications = in.createTypedArrayList(Specifications.CREATOR);
        this.uniqueId = in.readInt();
        this.imageUrl = in.createStringArrayList();
        this.maxItemQuantity = in.readInt();
        taxesDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
    }

    public ArrayList<TaxesDetail> getTaxesDetails() {
        if (taxesDetails == null) {
            return new ArrayList<>();
        } else {
            return taxesDetails;
        }
    }

    public void setTaxesDetails(ArrayList<TaxesDetail> taxesDetails) {
        this.taxesDetails = taxesDetails;
    }

    public double getTax() {
        return tax;
    }

    public void setTax(double tax) {
        this.tax = tax;
    }

    public double getItemTax() {
        return itemTax;
    }

    public void setItemTax(double itemTax) {
        this.itemTax = itemTax;
    }

    public double getTotalItemTax() {
        return totalItemTax;
    }

    public void setTotalItemTax(double totalItemTax) {
        this.totalItemTax = totalItemTax;
    }

    public int getMaxItemQuantity() {
        return maxItemQuantity;
    }

    public void setMaxItemQuantity(int maxItemQuantity) {
        this.maxItemQuantity = maxItemQuantity;
    }

    public String getItemNote() {
        return itemNote;
    }

    public void setItemNote(String itemNote) {
        this.itemNote = itemNote;
    }

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

    public List<Specifications> getSpecifications() {
        return specifications;
    }

    public void setSpecifications(List<Specifications> specifications) {
        this.specifications = specifications;
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

    public ProductItem getProductItem() {
        return productItem;
    }

    public void setProductItem(ProductItem productItem) {
        this.productItem = productItem;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public double getTotalTax() {
        return totalTax;
    }

    public void setTotalTax(double totalTax) {
        this.totalTax = totalTax;
    }

    public double getTotalSpecificationTax() {
        return totalSpecificationTax;
    }

    public void setTotalSpecificationTax(double totalSpecificationTax) {
        this.totalSpecificationTax = totalSpecificationTax;
    }

    public double getTotalTaxes() {
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

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeDouble(this.tax);
        dest.writeDouble(this.totalPrice);
        dest.writeDouble(this.totalTax);
        dest.writeDouble(this.totalSpecificationTax);
        dest.writeDouble(this.itemTax);
        dest.writeDouble(this.totalItemTax);
        dest.writeString(this.itemNote);
        dest.writeDouble(this.totalItemAndSpecificationPrice);
        dest.writeParcelable(this.productItem, flags);
        dest.writeString(this.details);
        dest.writeString(this.itemName);
        dest.writeDouble(this.itemPrice);
        dest.writeDouble(this.totalSpecificationPrice);
        dest.writeInt(this.quantity);
        dest.writeString(this.itemId);
        dest.writeTypedList(this.specifications);
        dest.writeInt(this.uniqueId);
        dest.writeStringList(this.imageUrl);
        dest.writeInt(this.maxItemQuantity);
        dest.writeTypedList(taxesDetails);
    }

    @Override
    public int hashCode() {
        return Objects.hash(itemPrice, tax, itemTax, totalSpecificationPrice, totalSpecificationTax, totalPrice, totalTax, quantity, totalItemAndSpecificationPrice, totalItemTax, itemNote, productItem, details, itemName, itemId, specifications, uniqueId, imageUrl, maxItemQuantity, taxesDetails);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartProductItems that = (CartProductItems) o;
        return uniqueId == that.uniqueId && itemId.equals(that.itemId) && specifications.equals(that.specifications);
    }
}