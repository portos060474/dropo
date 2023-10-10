package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.Documents;
import com.dropo.provider.models.datamodels.Vehicle;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class VehicleAddResponse {

    @SerializedName("provider_vehicle")
    private Vehicle vehicle;

    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("document_list")
    private List<Documents> documentList;

    @SerializedName("error_code")
    @Expose
    private int errorCode;

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle vehicle) {
        this.vehicle = vehicle;
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

    public List<Documents> getDocumentList() {
        return documentList;
    }

    public void setDocumentList(List<Documents> documentList) {
        this.documentList = documentList;
    }

    @Override
    public String toString() {
        return "VehicleAddResponse{" + "provider_vehicle = '" + vehicle + '\'' + ",success = '" + success + '\'' + ",message = '" + message + '\'' + ",document_list = '" + documentList + '\'' + "}";
    }
}