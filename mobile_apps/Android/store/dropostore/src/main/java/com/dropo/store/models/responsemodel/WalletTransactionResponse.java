package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.WalletRequestDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class WalletTransactionResponse {

    @SerializedName("success")
    private boolean success;

    @SerializedName("wallet_request_detail")
    private List<WalletRequestDetail> walletRequestDetail;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public List<WalletRequestDetail> getWalletRequestDetail() {
        return walletRequestDetail;
    }

    public void setWalletRequestDetail(List<WalletRequestDetail> walletRequestDetail) {
        this.walletRequestDetail = walletRequestDetail;
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
        return "WalletTransactionResponse{" + "success = '" + success + '\'' + ",wallet_request_detail = '" + walletRequestDetail + '\'' + ",message = '" + message + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}