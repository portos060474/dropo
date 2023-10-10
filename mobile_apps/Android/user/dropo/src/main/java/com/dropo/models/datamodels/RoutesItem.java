package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class RoutesItem {

    @SerializedName("legs")
    private List<LegsItem> legs;

    @SerializedName("waypoint_order")
    private List<Integer> waypointOrder;

    public List<LegsItem> getLegs() {
        return legs;
    }

    public List<Integer> getWaypointOrder() {
        return waypointOrder;
    }
}