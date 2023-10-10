package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.SpecificationGroup;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import javax.annotation.Generated;

@Generated("com.robohorse.robopojogenerator")
public class SpecificationGroupResponse {

    @SerializedName("success")
    private boolean success;

    @SerializedName("specification_group")
    private List<SpecificationGroup> specificationGroup;

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

    public List<SpecificationGroup> getSpecificationGroup() {
        return specificationGroup;
    }

    public void setSpecificationGroup(List<SpecificationGroup> specificationGroup) {
        this.specificationGroup = specificationGroup;
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
        return "SpecificationGroupResponse{" + "success = '" + success + '\'' + ",specification_group = '" + specificationGroup + '\'' + ",message = '" + message + '\'' + "}";
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }
}