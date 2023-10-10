package com.dropo.store.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.datamodel.Product;

import java.util.ArrayList;

/**
 * Created by elluminati on 08-Jun-17.
 */

public class CurrentProduct implements Parcelable {
    public static final Creator<CurrentProduct> CREATOR = new Creator<CurrentProduct>() {
        @Override
        public CurrentProduct createFromParcel(Parcel in) {
            return new CurrentProduct(in);
        }

        @Override
        public CurrentProduct[] newArray(int size) {
            return new CurrentProduct[size];
        }
    };
    private static CurrentProduct currentProduct = new CurrentProduct();
    private final ArrayList<Product> productDataList;

    private CurrentProduct() {
        productDataList = new ArrayList<>();
    }

    protected CurrentProduct(Parcel in) {
        productDataList = in.createTypedArrayList(Product.CREATOR);
    }

    public static CurrentProduct getInstance() {
        return currentProduct;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("current_product", currentProduct);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            currentProduct = state.getParcelable("current_product");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(productDataList);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public ArrayList<Product> getProductDataList() {
        return productDataList;
    }

    public void setProductDataList(ArrayList<Product> productDataList) {
        this.productDataList.clear();
        this.productDataList.addAll(productDataList);
    }

}
