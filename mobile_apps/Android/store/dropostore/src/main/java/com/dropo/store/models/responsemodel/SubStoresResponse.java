package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.SubStore;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by elluminati on 05-Oct-17.
 */

public class SubStoresResponse {

    @SerializedName("sub_stores")
    @Expose
    private List<SubStore> subStoreList;
    @SerializedName("success")
    @Expose
    private boolean success;
    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public List<SubStore> getSubStoreList() {
        return subStoreList;
    }

    public boolean isSuccess() {
        return success;
    }

    public int getMessage() {
        return message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public int getErrorCode() {
        return errorCode;
    }
}
