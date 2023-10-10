package com.dropo.store.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by elluminati on 25-Dec-17.
 */

public class UpdateOrder implements Parcelable {

    public static final Creator<UpdateOrder> CREATOR = new Creator<UpdateOrder>() {
        @Override
        public UpdateOrder createFromParcel(Parcel in) {
            return new UpdateOrder(in);
        }

        @Override
        public UpdateOrder[] newArray(int size) {
            return new UpdateOrder[size];
        }
    };
    private static UpdateOrder updateOrder = new UpdateOrder();
    private final ArrayList<Item> saveNewItem;
    @SerializedName("order_details")
    @Expose
    private final List<OrderDetails> orderDetails;
    @SerializedName("total_item_tax")
    @Expose
    private double cartOrderTotalTaxPrice;
    @SerializedName("total_cart_price")
    private double cartOrderTotalPrice;
    @SerializedName("total_cart_amout_without_tax")
    private double totalCartAmoutWithoutTax;
    @SerializedName("total_specification_count")
    private int totalSpecificationCount;
    @SerializedName("store_id")
    private String storeId;
    @SerializedName("server_token")
    private String serverToken;
    @SerializedName("total_item_count")
    private int totalItemCount;
    @SerializedName("order_id")
    private String orderId;
    @SerializedName("is_use_item_tax")
    @Expose
    private Boolean isUseItemTax = false;
    @SerializedName("is_tax_included")
    @Expose
    private Boolean isTaxIncluded = false;
    @SerializedName("tax_details")
    @Expose
    private List<TaxesDetail> taxesDetails;

    private UpdateOrder() {
        orderDetails = new ArrayList<>();
        saveNewItem = new ArrayList<>();
    }

    protected UpdateOrder(Parcel in) {
        saveNewItem = in.createTypedArrayList(Item.CREATOR);
        cartOrderTotalTaxPrice = in.readDouble();
        cartOrderTotalPrice = in.readDouble();
        totalCartAmoutWithoutTax = in.readDouble();
        totalSpecificationCount = in.readInt();
        storeId = in.readString();
        serverToken = in.readString();
        totalItemCount = in.readInt();
        orderId = in.readString();
        orderDetails = in.createTypedArrayList(OrderDetails.CREATOR);
        this.isUseItemTax = in.readByte() != 0;
        this.isTaxIncluded = in.readByte() != 0;
        taxesDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
    }

    public static UpdateOrder getInstance() {
        return updateOrder;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("update_order", updateOrder);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            updateOrder = state.getParcelable("update_order");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(saveNewItem);
        dest.writeDouble(cartOrderTotalTaxPrice);
        dest.writeDouble(cartOrderTotalPrice);
        dest.writeDouble(totalCartAmoutWithoutTax);
        dest.writeInt(totalSpecificationCount);
        dest.writeString(storeId);
        dest.writeString(serverToken);
        dest.writeInt(totalItemCount);
        dest.writeString(orderId);
        dest.writeTypedList(orderDetails);
        dest.writeByte(this.isUseItemTax ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isTaxIncluded ? (byte) 1 : (byte) 0);
        dest.writeTypedList(taxesDetails);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public double getCartOrderTotalTaxPrice() {
        return cartOrderTotalTaxPrice;
    }

    public void setCartOrderTotalTaxPrice(double cartOrderTotalTaxPrice) {
        this.cartOrderTotalTaxPrice = cartOrderTotalTaxPrice;
    }

    public int getTotalSpecificationCount() {
        return totalSpecificationCount;
    }

    public void setTotalSpecificationCount(int totalSpecificationCount) {
        this.totalSpecificationCount = totalSpecificationCount;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public int getTotalItemCount() {
        return totalItemCount;
    }

    public void setTotalItemCount(int totalItemCount) {
        this.totalItemCount = totalItemCount;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public double getCartOrderTotalPrice() {
        return cartOrderTotalPrice;
    }

    public void setCartOrderTotalPrice(double cartOrderTotalPrice) {
        this.cartOrderTotalPrice = cartOrderTotalPrice;
    }

    public double getTotalCartAmoutWithoutTax() {
        return totalCartAmoutWithoutTax;
    }

    public void setTotalCartAmoutWithoutTax(double totalCartAmoutWithout_tax) {
        this.totalCartAmoutWithoutTax = totalCartAmoutWithout_tax;
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

    public List<OrderDetails> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetails> orderDetails) {
        this.orderDetails.clear();
        this.orderDetails.addAll(orderDetails);
    }

    public void setTaxesDetails(List<TaxesDetail> taxesDetails) {
        this.taxesDetails = taxesDetails;
    }

    public ArrayList<Item> getSaveNewItem() {
        return saveNewItem;
    }

    public void setSaveNewItem(Item saveNewItem) {
        this.saveNewItem.add(saveNewItem);
    }

    public void clearSaveNewItem() {
        this.saveNewItem.clear();
    }
}
