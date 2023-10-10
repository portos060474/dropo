package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class StoresResult {
    @SerializedName("count")
    @Expose
    int count;
    @SerializedName("results")
    @Expose
    List<Store> storeList;

    public int getCount() {
        return count;
    }

    public List<Store> getStoreList() {
        return storeList;
    }
}
