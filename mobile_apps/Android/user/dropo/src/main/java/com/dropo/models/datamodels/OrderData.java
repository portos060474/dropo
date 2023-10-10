package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class OrderData implements Parcelable {
    public static final Parcelable.Creator<OrderData> CREATOR = new Parcelable.Creator<OrderData>() {
        @Override
        public OrderData createFromParcel(Parcel source) {
            return new OrderData(source);
        }

        @Override
        public OrderData[] newArray(int size) {
            return new OrderData[size];
        }
    };
    @SerializedName("pickup_addresses")
    private List<Addresses> pickupAddresses;
    @SerializedName("destination_addresses")
    private List<Addresses> destinationAddresses;
    @SerializedName("order_details")
    @Expose
    private ArrayList<CartProducts> orderDetails;

    @SerializedName("is_use_item_tax")
    @Expose
    private Boolean isUseItemTax = false;

    @SerializedName("is_tax_included")
    @Expose
    private Boolean isTaxIncluded = false;

    @SerializedName("store_taxes")
    @Expose
    private ArrayList<TaxesDetail> storeTaxDetails;

    @SerializedName("table_no")
    @Expose
    private String tableNo;

    @SerializedName("no_of_persons")
    @Expose
    private String NoOfPerson;

    public OrderData() {
    }

    protected OrderData(Parcel in) {
        this.orderDetails = in.createTypedArrayList(CartProducts.CREATOR);
    }

    public ArrayList<CartProducts> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(ArrayList<CartProducts> orderDetails) {
        this.orderDetails = orderDetails;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.orderDetails);
    }

    public List<Addresses> getPickupAddresses() {
        return pickupAddresses;
    }

    public void setPickupAddresses(List<Addresses> pickupAddresses) {
        this.pickupAddresses = pickupAddresses;
    }

    public List<Addresses> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(List<Addresses> destinationAddresses) {
        this.destinationAddresses = destinationAddresses;
    }

    public Boolean getUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(Boolean useItemTax) {
        isUseItemTax = useItemTax;
    }

    public Boolean getTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(Boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public ArrayList<TaxesDetail> getStoreTaxDetails() {
        return storeTaxDetails;
    }

    public void setStoreTaxDetails(ArrayList<TaxesDetail> storeTaxDetails) {
        this.storeTaxDetails = storeTaxDetails;
    }


    public String getTableNo() {
        return tableNo;
    }

    public String getNoOfPerson() {
        return NoOfPerson;
    }
}
