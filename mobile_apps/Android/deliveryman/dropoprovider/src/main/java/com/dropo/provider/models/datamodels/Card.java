package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Card {

    @SerializedName("unique_id")
    @Expose
    private int uniqueId;

    @SerializedName("updated_at")
    @Expose
    private String updatedAt;

    @SerializedName("user_id")
    @Expose
    private String userId;

    @SerializedName("last_four")
    @Expose
    private String lastFour;

    @SerializedName("payment_id")
    @Expose
    private String paymentId;

    @SerializedName("payment_token")
    @Expose
    private String paymentToken;

    @SerializedName("created_at")
    @Expose
    private String createdAt;

    @SerializedName("_id")
    @Expose
    private String id;

    @SerializedName("card_type")
    @Expose
    private String cardType;

    @SerializedName("customer_id")
    @Expose
    private String customerId;

    @SerializedName("is_default")
    @Expose
    private boolean isDefault;

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getLastFour() {
        return lastFour;
    }

    public void setLastFour(String lastFour) {
        this.lastFour = lastFour;
    }

    public String getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(String paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentToken() {
        return paymentToken;
    }

    public void setPaymentToken(String paymentToken) {
        this.paymentToken = paymentToken;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }


}