package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Product implements Comparable<Product> {


    private boolean isProductFiltered = true;

    @SerializedName("items")
    @Expose
    private List<ProductItem> items;

    @SerializedName("_id")
    private ProductDetail productDetail;

    public List<ProductItem> getItems() {
        return items;
    }

    public void setItems(List<ProductItem> items) {
        this.items = items;
    }

    public ProductDetail getProductDetail() {
        return productDetail;
    }

    public void setProductDetail(ProductDetail productDetail) {
        this.productDetail = productDetail;
    }

    public Product copy() {
        Product product = new Product();
        product.setItems(new ArrayList<ProductItem>());
        product.setProductDetail(productDetail);
        return product;
    }

    public boolean isProductFiltered() {
        return isProductFiltered;
    }

    public void setProductFiltered(boolean productFiltered) {
        isProductFiltered = productFiltered;
    }


    @Override
    public int compareTo(Product o) {
        return this.productDetail.getSequenceNumber() > o.productDetail.getSequenceNumber() ? 1 : -1;
    }
}