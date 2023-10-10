package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

/**
 * Created by elluminati on 12-Jan-18.
 */

public class CancelReasons {

    @SerializedName("user_type")
    private String userType;

    @SerializedName("cancel_reason")
    private String cancelReason;

    @SerializedName("user_details")
    private UserDetail userDetail;

    @SerializedName("cancelled_at")
    private String cancelledAt;

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public UserDetail getUserDetail() {
        return userDetail;
    }

    public void setUserDetail(UserDetail userDetail) {
        this.userDetail = userDetail;
    }

    public String getCancelledAt() {
        return cancelledAt;
    }

    public void setCancelledAt(String cancelledAt) {
        this.cancelledAt = cancelledAt;
    }

}
