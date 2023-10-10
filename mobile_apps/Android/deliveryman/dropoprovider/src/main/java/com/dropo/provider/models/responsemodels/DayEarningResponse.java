package com.dropo.provider.models.responsemodels;

import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.OrderTotal;
import com.dropo.provider.models.datamodels.ProviderAnalyticDaily;
import com.dropo.provider.models.datamodels.WeekData;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class DayEarningResponse {


    @SerializedName("currency")
    private String currency;

    @SerializedName("success")
    private boolean success;

    @SerializedName("order_payments")
    private List<OrderPayment> orderPayments;

    @SerializedName("order_total")
    private OrderTotal orderTotal;

    @SerializedName("message")
    private int message;
    @SerializedName("status_phrase")
    private String statusPhrase;
    @SerializedName("provider_analytic_daily")
    private ProviderAnalyticDaily providerAnalyticDaily;
    @SerializedName("provider_analytic_weekly")
    private ProviderAnalyticDaily providerAnalyticWeekly;
    @SerializedName("error_code")
    @Expose
    private int errorCode;
    @SerializedName("order_day_total")
    private WeekData dayOfWeekOrderTotal;
    @SerializedName("date")
    private WeekData dayOfWeekDate;

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public List<OrderPayment> getOrderPayments() {
        return orderPayments;
    }

    public void setOrderPayments(List<OrderPayment> orderPayments) {
        this.orderPayments = orderPayments;
    }

    public OrderTotal getOrderTotal() {
        return orderTotal;
    }

    public void setOrderTotal(OrderTotal orderTotal) {
        this.orderTotal = orderTotal;
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

    public ProviderAnalyticDaily getProviderAnalyticDaily() {
        return providerAnalyticDaily;
    }

    public void setProviderAnalyticDaily(ProviderAnalyticDaily providerAnalyticDaily) {
        this.providerAnalyticDaily = providerAnalyticDaily;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public WeekData getDayOfWeekOrderTotal() {
        return dayOfWeekOrderTotal;
    }

    public void setDayOfWeekOrderTotal(WeekData dayOfWeekOrderTotal) {
        this.dayOfWeekOrderTotal = dayOfWeekOrderTotal;
    }

    public WeekData getDayOfWeekDate() {
        return dayOfWeekDate;
    }

    public void setDayOfWeekDate(WeekData dayOfWeekDate) {
        this.dayOfWeekDate = dayOfWeekDate;
    }

    public ProviderAnalyticDaily getProviderAnalyticWeekly() {
        return providerAnalyticWeekly;
    }

    public void setProviderAnalyticWeekly(ProviderAnalyticDaily providerAnalyticWeekly) {
        this.providerAnalyticWeekly = providerAnalyticWeekly;
    }
}