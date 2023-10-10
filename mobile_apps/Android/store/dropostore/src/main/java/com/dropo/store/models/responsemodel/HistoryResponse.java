package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.OrderData;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class HistoryResponse {

    @SerializedName("success")
    @Expose
    private boolean success;

    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("order_list")
    @Expose
    private ArrayList<OrderData> orderList;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public int getMessage() {
        return message;
    }

    public void setMessage(int message) {
        this.message = message;
    }

    public String getStatusPhrase() {
        return statusPhrase;
    }

    public void setStatusPhrase(String statusPhrase) {
        this.statusPhrase = statusPhrase;
    }

    public ArrayList<OrderData> getOrderList() {
        return orderList;
    }

    public void setOrderList(ArrayList<OrderData> orderList) {
        this.orderList = orderList;
    }

    @Override
    public String toString() {
        return "HistoryResponse{" + "success = '" + success + '\'' + ",message = '" + message + '\'' + ",order_list = '" + orderList + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}