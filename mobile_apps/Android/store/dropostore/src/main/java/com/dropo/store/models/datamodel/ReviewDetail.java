package com.dropo.store.models.datamodel;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class ReviewDetail implements Parcelable {

    public static final Creator<ReviewDetail> CREATOR = new Creator<ReviewDetail>() {
        @Override
        public ReviewDetail createFromParcel(Parcel in) {
            return new ReviewDetail(in);
        }

        @Override
        public ReviewDetail[] newArray(int size) {
            return new ReviewDetail[size];
        }
    };
    @SerializedName("user_rating_to_provider")
    @Expose
    private Integer userRatingToProvider;
    @SerializedName("user_review_to_provider")
    @Expose
    private String userReviewToProvider;
    @SerializedName("user_rating_to_store")
    @Expose
    private Integer userRatingToStore;
    @SerializedName("user_review_to_store")
    @Expose
    private String userReviewToStore;
    @SerializedName("provider_rating_to_user")
    @Expose
    private Integer providerRatingToUser;
    @SerializedName("provider_review_to_user")
    @Expose
    private String providerReviewToUser;
    @SerializedName("provider_rating_to_store")
    @Expose
    private Integer providerRatingToStore;
    @SerializedName("provider_review_to_store")
    @Expose
    private String providerReviewToStore;
    @SerializedName("store_rating_to_provider")
    @Expose
    private double storeRatingToProvider;
    @SerializedName("store_review_to_provider")
    @Expose
    private String storeReviewToProvider;
    @SerializedName("store_rating_to_user")
    @Expose
    private double storeRatingToUser;
    @SerializedName("store_review_to_user")
    @Expose
    private String storeReviewToUser;
    @SerializedName("order_unique_id")
    @Expose
    private Integer orderUniqueId;
    @SerializedName("number_of_users_like_store_comment")
    @Expose
    private Integer numberOfUsersLikeStoreComment;
    @SerializedName("number_of_users_dislike_store_comment")
    @Expose
    private Integer numberOfUsersDislikeStoreComment;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("order_id")
    @Expose
    private String orderId;
    @SerializedName("user_id")
    @Expose
    private String userId;
    @SerializedName("store_id")
    @Expose
    private String storeId;
    @SerializedName("provider_id")
    @Expose
    private String providerId;
    @SerializedName("created_at")
    @Expose
    private String createdAt;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("unique_id")
    @Expose
    private Integer uniqueId;
    @SerializedName("__v")
    @Expose
    private Integer v;

    protected ReviewDetail(Parcel in) {
        if (in.readByte() == 0) {
            userRatingToProvider = null;
        } else {
            userRatingToProvider = in.readInt();
        }
        userReviewToProvider = in.readString();
        if (in.readByte() == 0) {
            userRatingToStore = null;
        } else {
            userRatingToStore = in.readInt();
        }
        userReviewToStore = in.readString();
        if (in.readByte() == 0) {
            providerRatingToUser = null;
        } else {
            providerRatingToUser = in.readInt();
        }
        providerReviewToUser = in.readString();
        if (in.readByte() == 0) {
            providerRatingToStore = null;
        } else {
            providerRatingToStore = in.readInt();
        }
        providerReviewToStore = in.readString();
        storeRatingToProvider = in.readDouble();
        storeReviewToProvider = in.readString();
        storeRatingToUser = in.readDouble();
        storeReviewToUser = in.readString();
        if (in.readByte() == 0) {
            orderUniqueId = null;
        } else {
            orderUniqueId = in.readInt();
        }
        if (in.readByte() == 0) {
            numberOfUsersLikeStoreComment = null;
        } else {
            numberOfUsersLikeStoreComment = in.readInt();
        }
        if (in.readByte() == 0) {
            numberOfUsersDislikeStoreComment = null;
        } else {
            numberOfUsersDislikeStoreComment = in.readInt();
        }
        id = in.readString();
        orderId = in.readString();
        userId = in.readString();
        storeId = in.readString();
        providerId = in.readString();
        createdAt = in.readString();
        updatedAt = in.readString();
        if (in.readByte() == 0) {
            uniqueId = null;
        } else {
            uniqueId = in.readInt();
        }
        if (in.readByte() == 0) {
            v = null;
        } else {
            v = in.readInt();
        }
    }

    public Integer getUserRatingToProvider() {
        return userRatingToProvider;
    }

    public void setUserRatingToProvider(Integer userRatingToProvider) {
        this.userRatingToProvider = userRatingToProvider;
    }

    public String getUserReviewToProvider() {
        return userReviewToProvider;
    }

    public void setUserReviewToProvider(String userReviewToProvider) {
        this.userReviewToProvider = userReviewToProvider;
    }

    public Integer getUserRatingToStore() {
        return userRatingToStore;
    }

    public void setUserRatingToStore(Integer userRatingToStore) {
        this.userRatingToStore = userRatingToStore;
    }

    public String getUserReviewToStore() {
        return userReviewToStore;
    }

    public void setUserReviewToStore(String userReviewToStore) {
        this.userReviewToStore = userReviewToStore;
    }

    public Integer getProviderRatingToUser() {
        return providerRatingToUser;
    }

    public void setProviderRatingToUser(Integer providerRatingToUser) {
        this.providerRatingToUser = providerRatingToUser;
    }

    public String getProviderReviewToUser() {
        return providerReviewToUser;
    }

    public void setProviderReviewToUser(String providerReviewToUser) {
        this.providerReviewToUser = providerReviewToUser;
    }

    public Integer getProviderRatingToStore() {
        return providerRatingToStore;
    }

    public void setProviderRatingToStore(Integer providerRatingToStore) {
        this.providerRatingToStore = providerRatingToStore;
    }

    public String getProviderReviewToStore() {
        return providerReviewToStore;
    }

    public void setProviderReviewToStore(String providerReviewToStore) {
        this.providerReviewToStore = providerReviewToStore;
    }

    public double getStoreRatingToProvider() {
        return storeRatingToProvider;
    }

    public void setStoreRatingToProvider(double storeRatingToProvider) {
        this.storeRatingToProvider = storeRatingToProvider;
    }

    public String getStoreReviewToProvider() {
        return storeReviewToProvider;
    }

    public void setStoreReviewToProvider(String storeReviewToProvider) {
        this.storeReviewToProvider = storeReviewToProvider;
    }

    public double getStoreRatingToUser() {
        return storeRatingToUser;
    }

    public void setStoreRatingToUser(double storeRatingToUser) {
        this.storeRatingToUser = storeRatingToUser;
    }

    public String getStoreReviewToUser() {
        return storeReviewToUser;
    }

    public void setStoreReviewToUser(String storeReviewToUser) {
        this.storeReviewToUser = storeReviewToUser;
    }

    public Integer getOrderUniqueId() {
        return orderUniqueId;
    }

    public void setOrderUniqueId(Integer orderUniqueId) {
        this.orderUniqueId = orderUniqueId;
    }

    public Integer getNumberOfUsersLikeStoreComment() {
        return numberOfUsersLikeStoreComment;
    }

    public void setNumberOfUsersLikeStoreComment(Integer numberOfUsersLikeStoreComment) {
        this.numberOfUsersLikeStoreComment = numberOfUsersLikeStoreComment;
    }

    public Integer getNumberOfUsersDislikeStoreComment() {
        return numberOfUsersDislikeStoreComment;
    }

    public void setNumberOfUsersDislikeStoreComment(Integer numberOfUsersDislikeStoreComment) {
        this.numberOfUsersDislikeStoreComment = numberOfUsersDislikeStoreComment;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStoreId() {
        return storeId;
    }

    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
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

    public Integer getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(Integer uniqueId) {
        this.uniqueId = uniqueId;
    }

    public Integer getV() {
        return v;
    }

    public void setV(Integer v) {
        this.v = v;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        if (userRatingToProvider == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(userRatingToProvider);
        }
        dest.writeString(userReviewToProvider);
        if (userRatingToStore == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(userRatingToStore);
        }
        dest.writeString(userReviewToStore);
        if (providerRatingToUser == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(providerRatingToUser);
        }
        dest.writeString(providerReviewToUser);
        if (providerRatingToStore == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(providerRatingToStore);
        }
        dest.writeString(providerReviewToStore);
        dest.writeDouble(storeRatingToProvider);
        dest.writeString(storeReviewToProvider);
        dest.writeDouble(storeRatingToUser);
        dest.writeString(storeReviewToUser);
        if (orderUniqueId == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(orderUniqueId);
        }
        if (numberOfUsersLikeStoreComment == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(numberOfUsersLikeStoreComment);
        }
        if (numberOfUsersDislikeStoreComment == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(numberOfUsersDislikeStoreComment);
        }
        dest.writeString(id);
        dest.writeString(orderId);
        dest.writeString(userId);
        dest.writeString(storeId);
        dest.writeString(providerId);
        dest.writeString(createdAt);
        dest.writeString(updatedAt);
        if (uniqueId == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(uniqueId);
        }
        if (v == null) {
            dest.writeByte((byte) 0);
        } else {
            dest.writeByte((byte) 1);
            dest.writeInt(v);
        }
    }
}