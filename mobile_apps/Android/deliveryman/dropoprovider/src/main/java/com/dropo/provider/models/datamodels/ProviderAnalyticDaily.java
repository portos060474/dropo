package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class ProviderAnalyticDaily {

    @SerializedName("date_in_server_time")
    private String dateInServerTime;

    @SerializedName("date")
    private String date;

    @SerializedName("rejection_ratio")
    private double rejectionRatio;

    @SerializedName("unique_id")
    private int uniqueId;

    @SerializedName("completed_ratio")
    private double completedRatio;

    @SerializedName("rejected")
    private int rejected;

    @SerializedName("cancellation_ratio")
    private double cancellationRatio;

    @SerializedName("total_active_job_time")
    private long totalActiveJobTime = 0;

    @SerializedName("accepted")
    private int accepted;

    @SerializedName("received")
    private int received;

    @SerializedName("completed")
    private int completed;

    @SerializedName("not_answered")
    private int notAnswered;

    @SerializedName("total_online_time")
    private long totalOnlineTime = 0;

    @SerializedName("working_hours")
    private int workingHours;

    @SerializedName("provider_id")
    private String providerId;

    @SerializedName("cancelled")
    private int cancelled;

    @SerializedName("_id")
    private String id;

    @SerializedName("tag")
    private String tag;

    @SerializedName("acception_ratio")
    private double acceptionRatio;

    public String getDateInServerTime() {
        return dateInServerTime;
    }

    public void setDateInServerTime(String dateInServerTime) {
        this.dateInServerTime = dateInServerTime;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public double getRejectionRatio() {
        return rejectionRatio;
    }

    public void setRejectionRatio(double rejectionRatio) {
        this.rejectionRatio = rejectionRatio;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public double getCompletedRatio() {
        return completedRatio;
    }

    public void setCompletedRatio(double completedRatio) {
        this.completedRatio = completedRatio;
    }

    public int getRejected() {
        return rejected;
    }

    public void setRejected(int rejected) {
        this.rejected = rejected;
    }

    public double getCancellationRatio() {
        return cancellationRatio;
    }

    public void setCancellationRatio(double cancellationRatio) {
        this.cancellationRatio = cancellationRatio;
    }

    public long getTotalActiveJobTime() {
        return totalActiveJobTime;
    }

    public void setTotalActiveJobTime(long totalActiveJobTime) {
        this.totalActiveJobTime = totalActiveJobTime;
    }

    public int getAccepted() {
        return accepted;
    }

    public void setAccepted(int accepted) {
        this.accepted = accepted;
    }

    public int getReceived() {
        return received;
    }

    public void setReceived(int received) {
        this.received = received;
    }

    public int getCompleted() {
        return completed;
    }

    public void setCompleted(int completed) {
        this.completed = completed;
    }

    public int getNotAnswered() {
        return notAnswered;
    }

    public void setNotAnswered(int notAnswered) {
        this.notAnswered = notAnswered;
    }

    public long getTotalOnlineTime() {
        return totalOnlineTime;
    }

    public void setTotalOnlineTime(long totalOnlineTime) {
        this.totalOnlineTime = totalOnlineTime;
    }

    public int getWorkingHours() {
        return workingHours;
    }

    public void setWorkingHours(int workingHours) {
        this.workingHours = workingHours;
    }

    public String getProviderId() {
        return providerId;
    }

    public void setProviderId(String providerId) {
        this.providerId = providerId;
    }

    public int getCancelled() {
        return cancelled;
    }

    public void setCancelled(int cancelled) {
        this.cancelled = cancelled;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public double getAcceptionRatio() {
        return acceptionRatio;
    }

    public void setAcceptionRatio(double acceptionRatio) {
        this.acceptionRatio = acceptionRatio;
    }


}