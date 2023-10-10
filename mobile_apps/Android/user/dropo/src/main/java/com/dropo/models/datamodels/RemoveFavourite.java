package com.dropo.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by elluminati on 10-Nov-17.
 */

public class RemoveFavourite {
    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("user_id")
    @Expose
    private String userId;
    @SerializedName("store_id")
    @Expose
    private List<String> storeIdList;

    public RemoveFavourite(String serverToken, String userId, List<String> storeIdList) {

        this.serverToken = serverToken;
        this.userId = userId;
        this.storeIdList = storeIdList;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public List<String> getStoreIdList() {
        return storeIdList;
    }

    public void setStoreIdList(ArrayList<String> storeIdList) {
        this.storeIdList = storeIdList;
    }
}
