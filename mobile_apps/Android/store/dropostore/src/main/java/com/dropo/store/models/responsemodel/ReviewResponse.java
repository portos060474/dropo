package com.dropo.store.models.responsemodel;


import com.dropo.store.models.datamodel.StoreReview;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ReviewResponse {
    @SerializedName("store_review_list")
    private List<StoreReview> storeReviewList;


    @SerializedName("store_avg_review")
    private double storeAvgReview;

    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public List<StoreReview> getStoreReviewList() {
        return storeReviewList;
    }

    public void setStoreReviewList(List<StoreReview> storeReviewList) {
        this.storeReviewList = storeReviewList;
    }

    public double getStoreAvgReview() {
        return storeAvgReview;
    }

    public void setStoreAvgReview(double storeAvgReview) {
        this.storeAvgReview = storeAvgReview;
    }

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

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}