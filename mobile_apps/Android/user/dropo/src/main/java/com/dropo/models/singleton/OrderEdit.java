package com.dropo.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.OrderData;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.Store;

import java.util.ArrayList;

public class OrderEdit implements Parcelable {
    public static final Creator<OrderEdit> CREATOR = new Creator<OrderEdit>() {
        @Override
        public OrderEdit createFromParcel(Parcel in) {
            return new OrderEdit(in);
        }

        @Override
        public OrderEdit[] newArray(int size) {
            return new OrderEdit[size];
        }
    };
    private static OrderEdit ourInstance = new OrderEdit();
    private final ArrayList<ProductItem> orderEditedProductItemWithAllSpecificationList;
    private ArrayList<CartProducts> orderEditedProductWithSelectedSpecificationList;
    private double totalOrderAmount;
    private String orderCurrency;
    private Store store;
    private OrderData orderDetail;
    private String orderId;

    protected OrderEdit(Parcel in) {
        orderEditedProductWithSelectedSpecificationList = in.createTypedArrayList(CartProducts.CREATOR);
        orderEditedProductItemWithAllSpecificationList = in.createTypedArrayList(ProductItem.CREATOR);
        totalOrderAmount = in.readDouble();
        orderCurrency = in.readString();
        store = in.readParcelable(Store.class.getClassLoader());
        orderDetail = in.readParcelable(OrderData.class.getClassLoader());
        orderId = in.readString();
    }

    private OrderEdit() {
        orderEditedProductWithSelectedSpecificationList = new ArrayList<>();
        orderEditedProductItemWithAllSpecificationList = new ArrayList<>();
    }

    public static OrderEdit getInstance() {
        return ourInstance;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("order_edit", ourInstance);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            ourInstance = state.getParcelable("order_edit");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(orderEditedProductWithSelectedSpecificationList);
        dest.writeTypedList(orderEditedProductItemWithAllSpecificationList);
        dest.writeDouble(totalOrderAmount);
        dest.writeString(orderCurrency);
        dest.writeParcelable(store, flags);
        dest.writeParcelable(orderDetail, flags);
        dest.writeString(orderId);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public void clearOrderEditModel() {
        orderEditedProductWithSelectedSpecificationList.clear();
        orderEditedProductItemWithAllSpecificationList.clear();
        totalOrderAmount = 0.0;
        orderCurrency = "";
        store = null;
        orderDetail = null;

    }

    public ArrayList<CartProducts> getOrderEditedProductWithSelectedSpecificationList() {
        return orderEditedProductWithSelectedSpecificationList;
    }

    public void setOrderEditedProductWithSelectedSpecificationList(ArrayList<CartProducts> orderEditedProductWithSelectedSpecificationList) {
        this.orderEditedProductWithSelectedSpecificationList = orderEditedProductWithSelectedSpecificationList;
    }

    public double getTotalOrderAmount() {
        return totalOrderAmount;
    }

    public void setTotalOrderAmount(double totalOrderAmount) {
        this.totalOrderAmount = totalOrderAmount;
    }

    public String getOrderCurrency() {
        return orderCurrency;
    }

    public void setOrderCurrency(String orderCurrency) {
        this.orderCurrency = orderCurrency;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }

    public OrderData getOrderDetail() {
        return orderDetail;
    }

    public void setOrderDetail(OrderData orderDetail) {
        this.orderDetail = orderDetail;
    }

    public ArrayList<ProductItem> getOrderEditedProductItemWithAllSpecificationList() {
        return orderEditedProductItemWithAllSpecificationList;
    }

    public void setOrderEditedProductItemWithAllSpecificationList(ProductItem productItem) {
        this.orderEditedProductItemWithAllSpecificationList.add(productItem);
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
}
