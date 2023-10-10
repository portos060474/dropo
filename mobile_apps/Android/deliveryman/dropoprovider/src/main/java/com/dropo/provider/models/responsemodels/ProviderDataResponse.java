package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.Provider;
import com.dropo.provider.models.datamodels.VehicleDetail;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class ProviderDataResponse {


    @SerializedName("currency_sign")
    @Expose
    private String currency;

    @SerializedName("is_vehicle_document_uploaded")
    @Expose
    private boolean isVehicleDocumentUploaded;
    @SerializedName("provider")
    @Expose
    private Provider provider;
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
    @SerializedName("minimum_phone_number_length")
    @Expose
    private int minPhoneNumberLength;
    @SerializedName("maximum_phone_number_length")
    @Expose
    private int maxPhoneNumberLength;
    @SerializedName("vehicle_detail")
    private VehicleDetail vehicleDetail;
    @SerializedName("firebase_token")
    private String firebaseToken;

    public boolean isVehicleDocumentUploaded() {
        return isVehicleDocumentUploaded;
    }

    public void setVehicleDocumentUploaded(boolean vehicleDocumentUploaded) {
        isVehicleDocumentUploaded = vehicleDocumentUploaded;
    }

    public Provider getProvider() {
        return provider;
    }

    public void setProvider(Provider provider) {
        this.provider = provider;
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

    public int getMinPhoneNumberLength() {
        return minPhoneNumberLength;
    }

    public void setMinPhoneNumberLength(int minPhoneNumberLength) {
        this.minPhoneNumberLength = minPhoneNumberLength;
    }

    public int getMaxPhoneNumberLength() {
        return maxPhoneNumberLength;
    }

    public void setMaxPhoneNumberLength(int maxPhoneNumberLength) {
        this.maxPhoneNumberLength = maxPhoneNumberLength;
    }

    public VehicleDetail getVehicleDetail() {
        return vehicleDetail;
    }

    public void setVehicleDetail(VehicleDetail vehicleDetail) {
        this.vehicleDetail = vehicleDetail;
    }

    public String getCurrency() {
        return currency;
    }

    public String getFirebaseToken() {
        return firebaseToken;
    }
}