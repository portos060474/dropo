package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Country {
    @SerializedName("calling_code")
    private String callingCode;

    @SerializedName("calling_codes")
    private List<String> callingCodes;

    @SerializedName("flag")
    private String flag;

    @SerializedName("code")
    private String code;

    @SerializedName("name")
    private String name;

    @SerializedName("code_3")
    private String code3;

    @SerializedName("currencies")
    private List<String> currencies;

    public List<String> getCallingCodes() {
        return callingCodes;
    }

    public String getFlag() {
        return flag;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getCode3() {
        return code3;
    }

    public List<String> getCurrencies() {
        return currencies;
    }

    public String getCallingCode() {
        return callingCode;
    }

    public void setCallingCode(String callingCode) {
        this.callingCode = callingCode;
    }
}