package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class SurgeHours {

    @SerializedName("surge_start_hour")
    @Expose
    private String surgeStartHour;

    @SerializedName("surge_multiplier")
    @Expose
    private double surgeMultiplier;

    @SerializedName("surge_end_hour")
    @Expose
    private String surgeEndHour;

    public String getSurgeStartHour() {
        return surgeStartHour;
    }

    public void setSurgeStartHour(String surgeStartHour) {
        this.surgeStartHour = surgeStartHour;
    }

    public double getSurgeMultiplier() {
        return surgeMultiplier;
    }

    public void setSurgeMultiplier(double surgeMultiplier) {
        this.surgeMultiplier = surgeMultiplier;
    }

    public String getSurgeEndHour() {
        return surgeEndHour;
    }

    public void setSurgeEndHour(String surgeEndHour) {
        this.surgeEndHour = surgeEndHour;
    }


}