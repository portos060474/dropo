package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.RemainingReview;
import com.dropo.models.datamodels.StoreReview;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class ReviewResponse {
    @SerializedName("store_review_list")
    private List<StoreReview> storeReviewList;

    @SerializedName("remaining_review_list")
    private List<RemainingReview> remainingReviewList;

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

    public List<RemainingReview> getRemainingReviewList() {
        return remainingReviewList;
    }

    public void setRemainingReviewList(List<RemainingReview> remainingReviewList) {
        this.remainingReviewList = remainingReviewList;
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

    @Override
    public String toString() {
        return "EResponse{" + "store_review_list = '" + storeReviewList + '\'' + ",remaining_review_list = '" + remainingReviewList + '\'' + ",store_avg_review = '" + storeAvgReview + '\'' + ",success = '" + success + '\'' + ",message = '" + message + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}