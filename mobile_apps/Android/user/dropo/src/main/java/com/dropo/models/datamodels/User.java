package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class User implements Parcelable {


    public static final Creator<User> CREATOR = new Creator<User>() {
        @Override
        public User createFromParcel(Parcel source) {
            return new User(source);
        }

        @Override
        public User[] newArray(int size) {
            return new User[size];
        }
    };
    @SerializedName("favourite_stores")
    @Expose
    private List<String> favouriteStores;
    @SerializedName("is_user_type_approved")
    @Expose
    private boolean isUserTypeApproved;
    @SerializedName("is_document_uploaded")
    @Expose
    private boolean isDocumentUploaded;
    @SerializedName("is_email_verified")
    @Expose
    private boolean isEmailVerified;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("device_type")
    @Expose
    private String deviceType;
    @SerializedName("requests")
    @Expose
    private List<Object> requests;
    @SerializedName("is_referral")
    @Expose
    private boolean isReferral;
    @SerializedName("wallet_currency_code")
    @Expose
    private String walletCurrencyCode;
    @SerializedName("password")
    @Expose
    private String password;
    @SerializedName("user_type")
    @Expose
    private int userType;
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
    @SerializedName("total_referrals")
    @Expose
    private int totalReferrals;
    @SerializedName("user_type_id")
    @Expose
    private Object userTypeId;
    @SerializedName("current_request")
    @Expose
    private Object currentRequest;
    @SerializedName("first_name")
    @Expose
    private String firstName = "";
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("wallet")
    @Expose
    private double wallet;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("last_name")
    @Expose
    private String lastName;
    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("zipcode")
    @Expose
    private String zipcode = "";
    @SerializedName("social_ids")
    @Expose
    private ArrayList<String> socialId;
    @SerializedName("rate_count")
    @Expose
    private int rateCount;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("device_token")
    @Expose
    private String deviceToken;
    @SerializedName("referral_code")
    @Expose
    private String referralCode;
    @SerializedName("promo_count")
    @Expose
    private int promoCount;
    @SerializedName("is_approved")
    @Expose
    private boolean isApproved;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("orders")
    @Expose
    private List<String> orders;
    @SerializedName("referred_by")
    @Expose
    private Object referredBy;
    @SerializedName("login_by")
    @Expose
    private String loginBy;
    @SerializedName("country_id")
    @Expose
    private String countryId;
    @SerializedName("is_use_wallet")
    @Expose
    private boolean isUseWallet;
    @SerializedName("city_id")
    @Expose
    private String cityId;
    @SerializedName("store_detail")
    @Expose
    private List<Store> storeDetail;

    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("country_code")
    @Expose
    private String countryCode;

    public User() {
    }

    protected User(Parcel in) {
        this.favouriteStores = in.createStringArrayList();
        this.isUserTypeApproved = in.readByte() != 0;
        this.isDocumentUploaded = in.readByte() != 0;
        this.isEmailVerified = in.readByte() != 0;
        this.createdAt = in.readString();
        this.deviceType = in.readString();
        this.requests = new ArrayList<Object>();
        in.readList(this.requests, Object.class.getClassLoader());
        this.isReferral = in.readByte() != 0;
        this.walletCurrencyCode = in.readString();
        this.password = in.readString();
        this.userType = in.readInt();
        this.updatedAt = in.readString();
        this.countryPhoneCode = in.readString();
        this.rate = in.readDouble();
        this.isPhoneNumberVerified = in.readByte() != 0;
        this.totalReferrals = in.readInt();
        this.firstName = in.readString();
        this.email = in.readString();
        this.uniqueId = in.readInt();
        this.address = in.readString();
        this.wallet = in.readDouble();
        this.imageUrl = in.readString();
        this.lastName = in.readString();
        this.serverToken = in.readString();
        this.zipcode = in.readString();
        this.socialId = in.createStringArrayList();
        this.rateCount = in.readInt();
        this.phone = in.readString();
        this.deviceToken = in.readString();
        this.referralCode = in.readString();
        this.promoCount = in.readInt();
        this.isApproved = in.readByte() != 0;
        this.id = in.readString();
        this.orders = in.createStringArrayList();
        this.loginBy = in.readString();
        this.countryId = in.readString();
        this.isUseWallet = in.readByte() != 0;
        this.cityId = in.readString();
        this.name = in.readString();
        this.storeDetail = in.createTypedArrayList(Store.CREATOR);
        this.countryCode = in.readString();
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public List<Store> getStoreDetail() {
        return storeDetail;
    }

    public void setStoreDetail(List<Store> storeDetail) {
        this.storeDetail = storeDetail;
    }

    public boolean isIsUserTypeApproved() {
        return isUserTypeApproved;
    }

    public void setIsUserTypeApproved(boolean isUserTypeApproved) {
        this.isUserTypeApproved = isUserTypeApproved;
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

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public List<Object> getRequests() {
        return requests;
    }

    public void setRequests(List<Object> requests) {
        this.requests = requests;
    }

    public boolean isIsReferral() {
        return isReferral;
    }

    public void setIsReferral(boolean isReferral) {
        this.isReferral = isReferral;
    }

    public String getWalletCurrencyCode() {
        return walletCurrencyCode;
    }

    public void setWalletCurrencyCode(String walletCurrencyCode) {
        this.walletCurrencyCode = walletCurrencyCode;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
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

    public int getTotalReferrals() {
        return totalReferrals;
    }

    public void setTotalReferrals(int totalReferrals) {
        this.totalReferrals = totalReferrals;
    }

    public Object getUserTypeId() {
        return userTypeId;
    }

    public void setUserTypeId(Object userTypeId) {
        this.userTypeId = userTypeId;
    }

    public Object getCurrentRequest() {
        return currentRequest;
    }

    public void setCurrentRequest(Object currentRequest) {
        this.currentRequest = currentRequest;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
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

    public double getWallet() {
        return wallet;
    }

    public void setWallet(double wallet) {
        this.wallet = wallet;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
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

    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public int getRateCount() {
        return rateCount;
    }

    public void setRateCount(int rateCount) {
        this.rateCount = rateCount;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDeviceToken() {
        return deviceToken;
    }

    public void setDeviceToken(String deviceToken) {
        this.deviceToken = deviceToken;
    }

    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
    }

    public int getPromoCount() {
        return promoCount;
    }

    public void setPromoCount(int promoCount) {
        this.promoCount = promoCount;
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

    public boolean isIsUseWallet() {
        return isUseWallet;
    }

    public void setIsUseWallet(boolean isUseWallet) {
        this.isUseWallet = isUseWallet;
    }

    public String getCityId() {
        return cityId;
    }

    public void setCityId(String cityId) {
        this.cityId = cityId;
    }

    public List<String> getOrders() {
        return orders;
    }

    public void setOrders(List<String> orders) {
        this.orders = orders;
    }

    public List<String> getFavouriteStores() {
        return favouriteStores;
    }

    public void setFavouriteStores(List<String> favouriteStores) {
        this.favouriteStores = favouriteStores;
    }

    public ArrayList<String> getSocialId() {
        return socialId;
    }

    public void setSocialId(ArrayList<String> socialId) {
        this.socialId = socialId;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeStringList(this.favouriteStores);
        dest.writeByte(this.isUserTypeApproved ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isDocumentUploaded ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isEmailVerified ? (byte) 1 : (byte) 0);
        dest.writeString(this.createdAt);
        dest.writeString(this.deviceType);
        dest.writeList(this.requests);
        dest.writeByte(this.isReferral ? (byte) 1 : (byte) 0);
        dest.writeString(this.walletCurrencyCode);
        dest.writeString(this.password);
        dest.writeInt(this.userType);
        dest.writeString(this.updatedAt);
        dest.writeString(this.countryPhoneCode);
        dest.writeDouble(this.rate);
        dest.writeByte(this.isPhoneNumberVerified ? (byte) 1 : (byte) 0);
        dest.writeInt(this.totalReferrals);
        dest.writeString(this.firstName);
        dest.writeString(this.email);
        dest.writeInt(this.uniqueId);
        dest.writeString(this.address);
        dest.writeDouble(this.wallet);
        dest.writeString(this.imageUrl);
        dest.writeString(this.lastName);
        dest.writeString(this.serverToken);
        dest.writeString(this.zipcode);
        dest.writeStringList(this.socialId);
        dest.writeInt(this.rateCount);
        dest.writeString(this.phone);
        dest.writeString(this.deviceToken);
        dest.writeString(this.referralCode);
        dest.writeInt(this.promoCount);
        dest.writeByte(this.isApproved ? (byte) 1 : (byte) 0);
        dest.writeString(this.id);
        dest.writeStringList(this.orders);
        dest.writeString(this.loginBy);
        dest.writeString(this.countryId);
        dest.writeByte(this.isUseWallet ? (byte) 1 : (byte) 0);
        dest.writeString(this.cityId);
        dest.writeString(this.name);
        dest.writeTypedList(this.storeDetail);
        dest.writeString(this.countryCode);
    }


    public String getName() {
        return name;
    }
}