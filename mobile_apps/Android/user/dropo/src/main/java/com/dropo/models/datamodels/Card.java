package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Card {

    @SerializedName("last_four")
    @Expose
    private String lastFour;

    @SerializedName("_id")
    @Expose
    private String id;

    @SerializedName("payment_id")
    @Expose
    private String paymentId;

    @SerializedName("is_default")
    @Expose
    private boolean isDefault;

    public String getLastFour() {
        return lastFour;
    }

    public String getId() {
        return id;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean aDefault) {
        isDefault = aDefault;
    }

    public String getPaymentId() {
        return paymentId;
    }
}