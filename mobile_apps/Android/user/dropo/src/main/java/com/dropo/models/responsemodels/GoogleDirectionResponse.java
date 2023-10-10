package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.RoutesItem;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class GoogleDirectionResponse {

    @SerializedName("routes")
    private List<RoutesItem> routes;

    @SerializedName("status")
    private String status;

    public List<RoutesItem> getRoutes() {
        return routes;
    }

    public String getStatus() {
        return status;
    }
}