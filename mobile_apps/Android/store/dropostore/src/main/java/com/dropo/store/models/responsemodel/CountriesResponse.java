package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.Country;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by elluminati on 11-Jan-18.
 */

public class CountriesResponse {
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("success")
    @Expose
    private boolean success;

    @SerializedName("message")
    @Expose
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("countries")
    @Expose
    private ArrayList<Country> countries;

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
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

    public ArrayList<Country> getCountries() {
        return countries;
    }

    public void setCountries(ArrayList<Country> countries) {
        this.countries = countries;
    }
}
