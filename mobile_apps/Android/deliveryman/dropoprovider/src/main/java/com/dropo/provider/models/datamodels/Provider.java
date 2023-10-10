package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Provider {


    @SerializedName("selected_vehicle_id")
    @Expose
    private String selectedVehicleId;


    @SerializedName("is_document_uploaded")
    @Expose
    private boolean isDocumentUploaded;
    @SerializedName("is_email_verified")
    @Expose
    private boolean isEmailVerified;

    @SerializedName("created_at")
    @Expose
    private String createdAt;


    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("country_phone_code")
    @Expose
    private String countryPhoneCode;
    @SerializedName("user_rate")
    @Expose
    private double rate;
    @SerializedName("is_phone_number_verified")
    @Expose
    private boolean isPhoneNumberVerified;

    @SerializedName("is_online")
    @Expose
    private boolean isOnline;

    @SerializedName("first_name")
    @Expose
    private String firstName;
    @SerializedName("vehicle_id")
    @Expose
    private String vehicleId;
    @SerializedName("vehicle_ids")
    @Expose
    private List<String> vehicleIds;
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("is_provider_type_approved")
    @Expose
    private boolean isProviderTypeApproved;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("bearing")
    @Expose
    private double bearing;
    @SerializedName("last_name")
    @Expose
    private String lastName;
    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("is_in_delivery")
    @Expose
    private boolean isInDelivery;
    @SerializedName("zipcode")
    @Expose
    private String zipcode;
    @SerializedName("social_ids")
    @Expose
    private ArrayList<String> socialId;
    @SerializedName("rate_count")
    @Expose
    private int rateCount;
    @SerializedName("sort_bio")
    @Expose
    private String sortBio;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("vehicle_number")
    @Expose
    private String vehicleNumber;

    @SerializedName("referral_code")
    @Expose
    private String referralCode;
    @SerializedName("is_approved")
    @Expose
    private boolean isApproved;
    @SerializedName("is_active_for_job")
    @Expose
    private boolean isActiveForJob;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("referred_by")
    @Expose
    private Object referredBy;
    @SerializedName("login_by")
    @Expose
    private String loginBy;
    @SerializedName("country_id")
    @Expose
    private String countryId;
    @SerializedName("city_id")
    @Expose
    private String cityId;
    @SerializedName("requests")
    @Expose
    private List<String> orders;
    @SerializedName("wallet")
    @Expose
    private double wallet;
    @SerializedName("wallet_currency_code")
    @Expose
    private String walletCurrencyCode;
    @SerializedName("provider_type")
    @Expose
    private int providerType;

    public List<String> getVehicleIds() {
        return vehicleIds;
    }

    public void setVehicleIds(List<String> vehicleIds) {
        this.vehicleIds = vehicleIds;
    }

    public String getSelectedVehicleId() {
        return selectedVehicleId;
    }

    public void setSelectedVehicleId(String selectedVehicleId) {
        this.selectedVehicleId = selectedVehicleId;
    }

    public boolean isIsDocumentUploaded() {
        return isDocumentUploaded;
    }

    public void setIsDocumentUploaded(boolean isDocumentUploaded) {
        this.isDocumentUploaded = isDocumentUploaded;
    }

    public boolean isIsEmailVerified() {
        return isEmailVerified;
    }

    public void setIsEmailVerified(boolean isEmailVerified) {
        this.isEmailVerified = isEmailVerified;
    }


    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
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

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public boolean isIsPhoneNumberVerified() {
        return isPhoneNumberVerified;
    }

    public void setIsPhoneNumberVerified(boolean isPhoneNumberVerified) {
        this.isPhoneNumberVerified = isPhoneNumberVerified;
    }


    public boolean isIsOnline() {
        return isOnline;
    }

    public void setIsOnline(boolean isOnline) {
        this.isOnline = isOnline;
    }


    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isIsProviderTypeApproved() {
        return isProviderTypeApproved;
    }

    public void setIsProviderTypeApproved(boolean isProviderTypeApproved) {
        this.isProviderTypeApproved = isProviderTypeApproved;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public double getBearing() {
        return bearing;
    }

    public void setBearing(double bearing) {
        this.bearing = bearing;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public boolean isIsInDelivery() {
        return isInDelivery;
    }

    public void setIsInDelivery(boolean isInDelivery) {
        this.isInDelivery = isInDelivery;
    }

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public ArrayList<String> getSocialId() {
        return socialId;
    }

    public void setSocialId(ArrayList<String> socialId) {
        this.socialId = socialId;
    }

    public int getRateCount() {
        return rateCount;
    }

    public void setRateCount(int rateCount) {
        this.rateCount = rateCount;
    }

    public String getSortBio() {
        return sortBio;
    }

    public void setSortBio(String sortBio) {
        this.sortBio = sortBio;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }


    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
    }

    public boolean isIsApproved() {
        return isApproved;
    }

    public void setIsApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Object getReferredBy() {
        return referredBy;
    }

    public void setReferredBy(Object referredBy) {
        this.referredBy = referredBy;
    }

    public String getLoginBy() {
        return loginBy;
    }

    public void setLoginBy(String loginBy) {
        this.loginBy = loginBy;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public boolean isActiveForJob() {
        return isActiveForJob;
    }

    public void setActiveForJob(boolean activeForJob) {
        isActiveForJob = activeForJob;
    }

    public List<String> getOrders() {
        return orders;
    }

    public void setOrders(List<String> orders) {
        this.orders = orders;
    }

    public double getWallet() {
        return wallet;
    }

    public void setWallet(double wallet) {
        this.wallet = wallet;
    }

    public String getWalletCurrencyCode() {
        return walletCurrencyCode;
    }

    public void setWalletCurrencyCode(String walletCurrencyCode) {
        this.walletCurrencyCode = walletCurrencyCode;
    }

    public int getProviderType() {
        return providerType;
    }

    public void setProviderType(int providerType) {
        this.providerType = providerType;
    }
}