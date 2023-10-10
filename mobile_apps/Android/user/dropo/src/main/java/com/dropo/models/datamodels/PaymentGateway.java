package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class PaymentGateway {

    private boolean isSelect;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;

    @SerializedName("payment_key_id")
    @Expose
    private String paymentKeyId;

    @SerializedName("is_payment_visible")
    @Expose
    private boolean isPaymentVisible;

    @SerializedName("description")
    @Expose
    private String description;

    @SerializedName("created_at")
    @Expose
    private String createdAt;

    @SerializedName("is_using_card_details")
    @Expose
    private boolean isUsingCardDetails;

    @SerializedName("payment_key")
    @Expose
    private String paymentKey;

    @SerializedName("is_payment_by_web_url")
    @Expose
    private boolean isPaymentByWebUrl;

    @SerializedName("updated_at")
    @Expose
    private String updatedAt;

    @SerializedName("__v")
    @Expose
    private int V;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("is_payment_by_login")
    @Expose
    private boolean isPaymentByLogin;

    @SerializedName("_id")
    @Expose
    private String id;
    private boolean isPaymentModeCash = false;

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getPaymentKeyId() {
        return paymentKeyId;
    }

    public void setPaymentKeyId(String paymentKeyId) {
        this.paymentKeyId = paymentKeyId;
    }

    public boolean isIsPaymentVisible() {
        return isPaymentVisible;
    }

    public void setIsPaymentVisible(boolean isPaymentVisible) {
        this.isPaymentVisible = isPaymentVisible;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isIsUsingCardDetails() {
        return isUsingCardDetails;
    }

    public void setIsUsingCardDetails(boolean isUsingCardDetails) {
        this.isUsingCardDetails = isUsingCardDetails;
    }

    public String getPaymentKey() {
        return paymentKey;
    }

    public void setPaymentKey(String paymentKey) {
        this.paymentKey = paymentKey;
    }

    public boolean isIsPaymentByWebUrl() {
        return isPaymentByWebUrl;
    }

    public void setIsPaymentByWebUrl(boolean isPaymentByWebUrl) {
        this.isPaymentByWebUrl = isPaymentByWebUrl;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getV() {
        return V;
    }

    public void setV(int V) {
        this.V = V;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isIsPaymentByLogin() {
        return isPaymentByLogin;
    }

    public void setIsPaymentByLogin(boolean isPaymentByLogin) {
        this.isPaymentByLogin = isPaymentByLogin;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }

    public boolean isPaymentModeCash() {
        return isPaymentModeCash;
    }

    public void setPaymentModeCash(boolean paymentModeCash) {
        isPaymentModeCash = paymentModeCash;
    }
}