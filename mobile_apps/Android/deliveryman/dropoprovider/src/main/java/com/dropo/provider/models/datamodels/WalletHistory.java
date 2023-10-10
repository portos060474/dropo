package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

public class WalletHistory implements Parcelable {

    public static final Creator<WalletHistory> CREATOR = new Creator<WalletHistory>() {
        @Override
        public WalletHistory createFromParcel(Parcel source) {
            return new WalletHistory(source);
        }

        @Override
        public WalletHistory[] newArray(int size) {
            return new WalletHistory[size];
        }
    };
    @SerializedName("from_currency_code")
    private String fromCurrencyCode;
    @SerializedName("to_currency_code")
    private String toCurrencyCode;
    @SerializedName("current_rate")
    private double currentRate;
    @SerializedName("wallet_comment_id")
    private int walletCommentId;
    @SerializedName("unique_id")
    private int uniqueId;
    @SerializedName("user_unique_id")
    private int userUniqueId;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("wallet_status")
    private int walletStatus;
    @SerializedName("added_wallet")
    private double addedWallet;
    @SerializedName("total_wallet_amount")
    private double totalWalletAmount;
    @SerializedName("user_type")
    private int userType;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("user_id")
    private String userId;
    @SerializedName("_id")
    private String id;
    @SerializedName("country_id")
    private String countryId;
    @SerializedName("wallet_amount")
    private double walletAmount;
    @SerializedName("wallet_description")
    private String walletDescription;
    @SerializedName("from_amount")
    private double fromAmount;

    public WalletHistory() {
    }

    protected WalletHistory(Parcel in) {
        this.fromCurrencyCode = in.readString();
        this.toCurrencyCode = in.readString();
        this.currentRate = in.readDouble();
        this.walletCommentId = in.readInt();
        this.uniqueId = in.readInt();
        this.userUniqueId = in.readInt();
        this.createdAt = in.readString();
        this.walletStatus = in.readInt();
        this.addedWallet = in.readDouble();
        this.totalWalletAmount = in.readDouble();
        this.userType = in.readInt();
        this.updatedAt = in.readString();
        this.userId = in.readString();
        this.id = in.readString();
        this.countryId = in.readString();
        this.walletAmount = in.readDouble();
        this.walletDescription = in.readString();
        this.fromAmount = in.readDouble();
    }

    public double getFromAmount() {
        return fromAmount;
    }

    public void setFromAmount(double fromAmount) {
        this.fromAmount = fromAmount;
    }

    public int getWalletCommentId() {
        return walletCommentId;
    }

    public void setWalletCommentId(int walletCommentId) {
        this.walletCommentId = walletCommentId;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public int getUserUniqueId() {
        return userUniqueId;
    }

    public void setUserUniqueId(int userUniqueId) {
        this.userUniqueId = userUniqueId;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getWalletStatus() {
        return walletStatus;
    }

    public void setWalletStatus(int walletStatus) {
        this.walletStatus = walletStatus;
    }

    public double getAddedWallet() {
        return addedWallet;
    }

    public void setAddedWallet(double addedWallet) {
        this.addedWallet = addedWallet;
    }

    public double getTotalWalletAmount() {
        return totalWalletAmount;
    }

    public void setTotalWalletAmount(double totalWalletAmount) {
        this.totalWalletAmount = totalWalletAmount;
    }

    public int getUserType() {
        return userType;
    }

    public void setUserType(int userType) {
        this.userType = userType;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public double getWalletAmount() {
        return walletAmount;
    }

    public void setWalletAmount(double walletAmount) {
        this.walletAmount = walletAmount;
    }

    public String getWalletDescription() {
        return walletDescription;
    }

    public void setWalletDescription(String walletDescription) {
        this.walletDescription = walletDescription;
    }

    public String getFromCurrencyCode() {
        return fromCurrencyCode;
    }

    public void setFromCurrencyCode(String fromCurrencyCode) {
        this.fromCurrencyCode = fromCurrencyCode;
    }

    public String getToCurrencyCode() {
        return toCurrencyCode;
    }

    public void setToCurrencyCode(String toCurrencyCode) {
        this.toCurrencyCode = toCurrencyCode;
    }

    public double getCurrentRate() {
        return currentRate;
    }

    public void setCurrentRate(double currentRate) {
        this.currentRate = currentRate;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.fromCurrencyCode);
        dest.writeString(this.toCurrencyCode);
        dest.writeDouble(this.currentRate);
        dest.writeInt(this.walletCommentId);
        dest.writeInt(this.uniqueId);
        dest.writeInt(this.userUniqueId);
        dest.writeString(this.createdAt);
        dest.writeInt(this.walletStatus);
        dest.writeDouble(this.addedWallet);
        dest.writeDouble(this.totalWalletAmount);
        dest.writeInt(this.userType);
        dest.writeString(this.updatedAt);
        dest.writeString(this.userId);
        dest.writeString(this.id);
        dest.writeString(this.countryId);
        dest.writeDouble(this.walletAmount);
        dest.writeString(this.walletDescription);
        dest.writeDouble(this.fromAmount);
    }
}