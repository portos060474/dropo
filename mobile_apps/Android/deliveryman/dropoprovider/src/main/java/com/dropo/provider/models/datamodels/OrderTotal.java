package com.dropo.provider.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class OrderTotal {
    @SerializedName("is_weekly_invoice_paid")
    private boolean isWeeklyInvoicePaid;

    @SerializedName("total_earning")
    private double totalEarning = 0;

    @SerializedName("provider_have_cash_payment")
    private double providerHaveCashPayment = 0;

    @SerializedName("wallet")
    private double wallet = 0;

    @SerializedName("total_provider_profit")
    private double totalProviderProfit = 0;

    @SerializedName("total_service_price")
    private double totalServicePrice = 0;

    @SerializedName("provider_paid_order_payment")
    private double providerPaidOrderPayment = 0;

    @SerializedName("total_admin_profit_on_delivery")
    private double totalAdminProfitOnDelivery = 0;

    @SerializedName("pay_to_provider")
    private double payToProvider = 0;

    @SerializedName("_id")
    private Object id;

    @SerializedName("total_admin_tax_price")
    private double totalAfterTaxPrice = 0;

    @SerializedName("total_surge_price")
    private double totalSurgePrice = 0;

    @SerializedName("total_delivery_price")
    private double totalDeliveryPrice = 0;
    @SerializedName("total_deduct_wallet_income")
    private double totalWalletIncomeSetInCashOrder = 0;
    @SerializedName("total_added_wallet_income")
    private double totalWalletIncomeSetInOtherOrder = 0;
    @SerializedName("total_provider_have_cash_payment_on_hand")
    private double totalProviderHaveCashPaymentOnHand = 0;
    @SerializedName("total_transferred_amount")
    private double totalPaid = 0;
    @SerializedName("total_wallet_income_set")
    private double totalWalletIncomeSet = 0;

    public double getTotalEarning() {
        return totalEarning;
    }

    public void setTotalEarning(double totalEarning) {
        this.totalEarning = totalEarning;
    }

    public double getProviderHaveCashPayment() {
        return providerHaveCashPayment;
    }

    public void setProviderHaveCashPayment(double providerHaveCashPayment) {
        this.providerHaveCashPayment = providerHaveCashPayment;
    }

    public double getWallet() {
        return wallet;
    }

    public void setWallet(double wallet) {
        this.wallet = wallet;
    }

    public double getTotalProviderProfit() {
        return totalProviderProfit;
    }

    public void setTotalProviderProfit(double totalProviderProfit) {
        this.totalProviderProfit = totalProviderProfit;
    }

    public double getTotalServicePrice() {
        return totalServicePrice;
    }

    public void setTotalServicePrice(double totalServicePrice) {
        this.totalServicePrice = totalServicePrice;
    }

    public double getProviderPaidOrderPayment() {
        return providerPaidOrderPayment;
    }

    public void setProviderPaidOrderPayment(double providerPaidOrderPayment) {
        this.providerPaidOrderPayment = providerPaidOrderPayment;
    }

    public double getTotalAdminProfitOnDelivery() {
        return totalAdminProfitOnDelivery;
    }

    public void setTotalAdminProfitOnDelivery(double totalAdminProfitOnDelivery) {
        this.totalAdminProfitOnDelivery = totalAdminProfitOnDelivery;
    }

    public double getPayToProvider() {
        return payToProvider;
    }

    public void setPayToProvider(double payToProvider) {
        this.payToProvider = payToProvider;
    }

    public Object getId() {
        return id;
    }

    public void setId(Object id) {
        this.id = id;
    }

    public double getTotalAfterTaxPrice() {
        return totalAfterTaxPrice;
    }

    public void setTotalAfterTaxPrice(double totalAfterTaxPrice) {
        this.totalAfterTaxPrice = totalAfterTaxPrice;
    }

    public double getTotalSurgePrice() {
        return totalSurgePrice;
    }

    public void setTotalSurgePrice(double totalSurgePrice) {
        this.totalSurgePrice = totalSurgePrice;
    }

    public double getTotalDeliveryPrice() {
        return totalDeliveryPrice;
    }

    public void setTotalDeliveryPrice(double totalDeliveryPrice) {
        this.totalDeliveryPrice = totalDeliveryPrice;
    }

    public boolean isWeeklyInvoicePaid() {
        return isWeeklyInvoicePaid;
    }

    public void setWeeklyInvoicePaid(boolean weeklyInvoicePaid) {
        isWeeklyInvoicePaid = weeklyInvoicePaid;
    }

    public double getTotalWalletIncomeSetInCashOrder() {
        return totalWalletIncomeSetInCashOrder;
    }

    public void setTotalWalletIncomeSetInCashOrder(double totalWalletIncomeSetInCashOrder) {
        this.totalWalletIncomeSetInCashOrder = totalWalletIncomeSetInCashOrder;
    }

    public double getTotalWalletIncomeSetInOtherOrder() {
        return totalWalletIncomeSetInOtherOrder;
    }

    public void setTotalWalletIncomeSetInOtherOrder(double totalWalletIncomeSetInOtherOrder) {
        this.totalWalletIncomeSetInOtherOrder = totalWalletIncomeSetInOtherOrder;
    }

    public double getTotalProviderHaveCashPaymentOnHand() {
        return totalProviderHaveCashPaymentOnHand;
    }

    public void setTotalProviderHaveCashPaymentOnHand(double totalProviderHaveCashPaymentOnHand) {
        this.totalProviderHaveCashPaymentOnHand = totalProviderHaveCashPaymentOnHand;
    }

    public double getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(double totalPaid) {
        this.totalPaid = totalPaid;
    }


    public double getTotalWalletIncomeSet() {
        return totalWalletIncomeSet;
    }

    public void setTotalWalletIncomeSet(double totalWalletIncomeSet) {
        this.totalWalletIncomeSet = totalWalletIncomeSet;
    }
}