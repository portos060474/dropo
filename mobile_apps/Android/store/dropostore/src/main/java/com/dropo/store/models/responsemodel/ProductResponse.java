package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by elluminati on 11-Jan-18.
 */

public class ProductResponse {
    @SerializedName("currency")
    @Expose
    private String currency;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("products")
    @Expose
    private List<Product> products;

    @SerializedName("tax_details")
    @Expose
    private List<TaxesDetail> taxDetails;


    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getMessage() {
        return message;
    }

    public void setMessage(int message) {
        this.message = message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public List<TaxesDetail> getTaxDetails() {
        return taxDetails;
    }

    public void setTaxDetails(List<TaxesDetail> taxDetails) {
        this.taxDetails = taxDetails;
    }
}
