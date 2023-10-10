package com.dropo.models.datamodels;


import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class AppLanguage implements Parcelable {

    public static final Creator<AppLanguage> CREATOR = new Creator<AppLanguage>() {
        @Override
        public AppLanguage createFromParcel(Parcel in) {
            return new AppLanguage(in);
        }

        @Override
        public AppLanguage[] newArray(int size) {
            return new AppLanguage[size];
        }
    };
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("code")
    @Expose
    private String code;
    @SerializedName("string_file_path")
    @Expose
    private String stringFilePath;
    @SerializedName("is_visible")
    @Expose
    private boolean isVisible;

    protected AppLanguage(Parcel in) {
        name = in.readString();
        code = in.readString();
        stringFilePath = in.readString();
        isVisible = in.readByte() != 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(name);
        dest.writeString(code);
        dest.writeString(stringFilePath);
        dest.writeByte((byte) (isVisible ? 1 : 0));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getStringFilePath() {
        return stringFilePath;
    }

    public void setStringFilePath(String stringFilePath) {
        this.stringFilePath = stringFilePath;
    }

    public boolean isVisible() {
        return isVisible;
    }

    public void setVisible(boolean visible) {
        isVisible = visible;
    }

}
