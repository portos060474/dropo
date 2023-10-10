package com.dropo.store.models.datamodel;

import com.google.gson.annotations.SerializedName;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class Customer {

    @SerializedName("server_token")
    private String serverToken;

    @SerializedName("_id")
    private String id;

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return "Customer{" + "server_token = '" + serverToken + '\'' + ",_id = '" + id + '\'' + "}";
    }
}