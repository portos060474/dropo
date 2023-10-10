package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Countries implements Parcelable {


    public static final Parcelable.Creator<Countries> CREATOR = new Parcelable.Creator<Countries>() {
        @Override
        public Countries createFromParcel(Parcel source) {
            return new Countries(source);
        }

        @Override
        public Countries[] newArray(int size) {
            return new Countries[size];
        }
    };
    @SerializedName("is_referral_user")
    @Expose
    private boolean isReferralUser;
    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;
    @SerializedName("currency_name")
    @Expose
    private String currencyName;
    @SerializedName("country_timezone")
    @Expose
    private List<String> countryTimezone;
    @SerializedName("no_of_user_use_referral")
    @Expose
    private int noOfUserUseReferral;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("country_all_timezone")
    @Expose
    private List<String> countryAllTimezone;
    @SerializedName("currency_code")
    @Expose
    private String currencyCode;
    @SerializedName("country_code")
    @Expose
    private String countryCode;
    @SerializedName("referral_bonus_to_user")
    @Expose
    private double referralBonusToUser;
    @SerializedName("bonus_to_user_referral")
    @Expose
    private double bonusToUserReferral;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("country_phone_code")
    @Expose
    private String countryPhoneCode;
    @SerializedName("currency_sign")
    @Expose
    private String currencySign;
    @SerializedName("country_name")
    @Expose
    private String countryName;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("is_distance_unit_mile")
    @Expose
    private boolean isDistanceUnitMile;
    @SerializedName("maximum_phone_number_length")
    @Expose
    private int maxPhoneNumberLength;
    @SerializedName("country_flag")
    @Expose
    private String countryFlag;
    @SerializedName("minimum_phone_number_length")
    @Expose
    private int minPhoneNumberLength;

    public Countries() {
    }

    protected Countries(Parcel in) {
        this.isReferralUser = in.readByte() != 0;
        this.isBusiness = in.readByte() != 0;
        this.currencyName = in.readString();
        this.countryTimezone = in.createStringArrayList();
        this.noOfUserUseReferral = in.readInt();
        this.createdAt = in.readString();
        this.countryAllTimezone = in.createStringArrayList();
        this.currencyCode = in.readString();
        this.countryCode = in.readString();
        this.referralBonusToUser = in.readDouble();
        this.bonusToUserReferral = in.readDouble();
        this.updatedAt = in.readString();
        this.countryPhoneCode = in.readString();
        this.currencySign = in.readString();
        this.countryName = in.readString();
        this.id = in.readString();
        this.isDistanceUnitMile = in.readByte() != 0;
        this.maxPhoneNumberLength = in.readInt();
        this.countryFlag = in.readString();
        this.minPhoneNumberLength = in.readInt();
    }

    public boolean isIsBusiness() {
        return isBusiness;
    }

    public void setIsBusiness(boolean isBusiness) {
        this.isBusiness = isBusiness;
    }

    public String getCurrencyName() {
        return currencyName;
    }

    public void setCurrencyName(String currencyName) {
        this.currencyName = currencyName;
    }

    public List<String> getCountryTimezone() {
        return countryTimezone;
    }

    public void setCountryTimezone(List<String> countryTimezone) {
        this.countryTimezone = countryTimezone;
    }

    public int getNoOfUserUseReferral() {
        return noOfUserUseReferral;
    }

    public void setNoOfUserUseReferral(int noOfUserUseReferral) {
        this.noOfUserUseReferral = noOfUserUseReferral;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public List<String> getCountryAllTimezone() {
        return countryAllTimezone;
    }

    public void setCountryAllTimezone(List<String> countryAllTimezone) {
        this.countryAllTimezone = countryAllTimezone;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public double getReferralBonusToUser() {
        return referralBonusToUser;
    }

    public void setReferralBonusToUser(double referralBonusToUser) {
        this.referralBonusToUser = referralBonusToUser;
    }

    public double getBonusToUserReferral() {
        return bonusToUserReferral;
    }

    public void setBonusToUserReferral(double bonusToUserReferral) {
        this.bonusToUserReferral = bonusToUserReferral;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getCountryPhoneCode() {
        return countryPhoneCode;
    }

    public void setCountryPhoneCode(String countryPhoneCode) {
        this.countryPhoneCode = countryPhoneCode;
    }

    public String getCurrencySign() {
        return currencySign;
    }

    public void setCurrencySign(String currencySign) {
        this.currencySign = currencySign;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isIsDistanceUnitMile() {
        return isDistanceUnitMile;
    }

    public void setIsDistanceUnitMile(boolean isDistanceUnitMile) {
        this.isDistanceUnitMile = isDistanceUnitMile;
    }

    public int getMaxPhoneNumberLength() {
        return maxPhoneNumberLength;
    }

    public void setMaxPhoneNumberLength(int maxPhoneNumberLength) {
        this.maxPhoneNumberLength = maxPhoneNumberLength;
    }

    public String getCountryFlag() {
        return countryFlag;
    }

    public void setCountryFlag(String countryFlag) {
        this.countryFlag = countryFlag;
    }

    public int getMinPhoneNumberLength() {
        return minPhoneNumberLength;
    }

    public void setMinPhoneNumberLength(int minPhoneNumberLength) {
        this.minPhoneNumberLength = minPhoneNumberLength;
    }

    public boolean isReferralUser() {
        return isReferralUser;
    }

    public void setReferralUser(boolean referralUser) {
        isReferralUser = referralUser;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isReferralUser ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isBusiness ? (byte) 1 : (byte) 0);
        dest.writeString(this.currencyName);
        dest.writeStringList(this.countryTimezone);
        dest.writeInt(this.noOfUserUseReferral);
        dest.writeString(this.createdAt);
        dest.writeStringList(this.countryAllTimezone);
        dest.writeString(this.currencyCode);
        dest.writeString(this.countryCode);
        dest.writeDouble(this.referralBonusToUser);
        dest.writeDouble(this.bonusToUserReferral);
        dest.writeString(this.updatedAt);
        dest.writeString(this.countryPhoneCode);
        dest.writeString(this.currencySign);
        dest.writeString(this.countryName);
        dest.writeString(this.id);
        dest.writeByte(this.isDistanceUnitMile ? (byte) 1 : (byte) 0);
        dest.writeInt(this.maxPhoneNumberLength);
        dest.writeString(this.countryFlag);
        dest.writeInt(this.minPhoneNumberLength);
    }
}