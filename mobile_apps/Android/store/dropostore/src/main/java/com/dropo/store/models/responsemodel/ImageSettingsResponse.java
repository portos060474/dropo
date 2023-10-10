package com.dropo.store.models.responsemodel;

import com.dropo.store.models.datamodel.ImageSetting;
import com.google.gson.annotations.SerializedName;

public class ImageSettingsResponse {

    @SerializedName("success")
    private boolean success;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("image_setting")
    private ImageSetting imageSetting;

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

    public ImageSetting getImageSetting() {
        return imageSetting;
    }

    public void setImageSetting(ImageSetting imageSetting) {
        this.imageSetting = imageSetting;
    }

    @Override
    public String toString() {
        return "ImageSettingsResponse{" + "success = '" + success + '\'' + ",message = '" + message + '\'' + ",image_setting = '" + imageSetting + '\'' + "}";
    }
}