package com.dropo.models.responsemodels;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class CancellationChargeResponse extends IsSuccessResponse {

    @SerializedName("cancellation_charge")
    private Double cancellationCharge;

    @SerializedName("cancellation_reason")
    private ArrayList<String> cancellationReason;

    public Double getCancellationCharge() {
        return cancellationCharge;
    }

    public ArrayList<String> getCancellationReason() {
        if (cancellationReason == null) {
            return new ArrayList<>();
        } else {
            return cancellationReason;
        }
    }
}
