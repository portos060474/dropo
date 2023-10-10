package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class OrderPayment implements Parcelable {
    public static final Creator<OrderPayment> CREATOR = new Creator<OrderPayment>() {
        @Override
        public OrderPayment createFromParcel(Parcel source) {
            return new OrderPayment(source);
        }

        @Override
        public OrderPayment[] newArray(int size) {
            return new OrderPayment[size];
        }
    };
    @SerializedName("is_min_fare_applied")
    private boolean isMinFareApplied;
    @SerializedName("user_pay_payment")
    @Expose
    private double userPayPayment;
    @SerializedName("is_user_pick_up_order")
    @Expose
    private boolean isUserPickUpOrder;
    @SerializedName("total_cart_price")
    @Expose
    private double totalCartPrice;
    private String currency;
    @SerializedName("refund_amount")
    @Expose
    private double refundAmount;
    @SerializedName("is_store_pay_delivery_fees")
    @Expose
    private boolean isStorePayDeliveryFees;
    @SerializedName("is_payment_mode_cash")
    @Expose
    private boolean isPaymentModeCash;
    @SerializedName("is_promo_for_delivery_service")
    @Expose
    private boolean isPromoForDeliveryService;
    @SerializedName("total_time_price")
    @Expose
    private double totalTimePrice;
    @SerializedName("total_admin_profit_on_delivery")
    @Expose
    private double totalAdminProfitOnDelivery;
    @SerializedName("price_per_unit_distance")
    @Expose
    private double pricePerUnitDistance;
    @SerializedName("admin_profit_mode_on_store")
    @Expose
    private double adminProfitModeOnStore;
    @SerializedName("distance_price")
    @Expose
    private double distancePrice;
    @SerializedName("createdAt")
    @Expose
    private String createdAt;
    @SerializedName("wallet_payment")
    @Expose
    private double walletPayment;
    @SerializedName("min_fare")
    @Expose
    private double minFare;
    @SerializedName("total_delivery_and_store_price")
    @Expose
    private double totalDeliveryAndStorePrice;
    @SerializedName("total_distance")
    @Expose
    private double totalDistance;
    @SerializedName("total_base_price")
    @Expose
    private double totalBasePrice;
    @SerializedName("total_after_tax_price")
    @Expose
    private double totalAfterTaxPrice;
    @SerializedName("total_time")
    @Expose
    private double totalTime;
    @SerializedName("card_payment")
    @Expose
    private double cardPayment;
    @SerializedName("unique_id")
    @Expose
    private int uniqueId;
    @SerializedName("surge_multiplier")
    @Expose
    private double surgeMultiplier;
    @SerializedName("total_admin_tax_price")
    @Expose
    private double totalAdminTaxPrice;
    @SerializedName("admin_profit_value_on_store")
    @Expose
    private double adminProfitValueOnStore;
    @SerializedName("total_service_price")
    @Expose
    private double totalServicePrice;
    @SerializedName("total_store_tax_price")
    @Expose
    private double totalStoreTaxPrice;
    @SerializedName("total_specification_count")
    @Expose
    private int totalSpecifications;
    @SerializedName("cash_payment")
    @Expose
    private double cashPayment;
    @SerializedName("user_id")
    @Expose
    private String userId;
    @SerializedName("admin_currency_code")
    @Expose
    private String adminCurrencyCode;
    @SerializedName("service_tax")
    @Expose
    private double serviceTax;
    @SerializedName("provider_id")
    @Expose
    private Object providerId;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("total_delivery_price_after_surge")
    @Expose
    private double totalDeliveryPriceAfterSurge;
    @SerializedName("order_id")
    @Expose
    private Object orderId;
    @SerializedName("total_delivery_price")
    @Expose
    private double totalDeliveryPrice;
    @SerializedName("total_after_wallet_payment")
    @Expose
    private double totalAfterWalletPayment;
    @SerializedName("price_per_unit_time")
    @Expose
    private double pricePerUnitTime;
    @SerializedName("total_item_count")
    @Expose
    private int totalItem;
    @SerializedName("total_admin_profit_on_store")
    @Expose
    private double totalAdminProfitOnStore;
    @SerializedName("total_distance_price")
    @Expose
    private double totalDistancePrice;
    @SerializedName("admin_profit_mode_on_delivery")
    @Expose
    private double adminProfitModeOnDelivery;
    @SerializedName("currency_code")
    @Expose
    private String currencyCode;
    @SerializedName("total_order_price")
    @Expose
    private double totalOrderPrice;
    @SerializedName("admin_profit_value_on_delivery")
    @Expose
    private double adminProfitValueOnDelivery;
    @SerializedName("total")
    @Expose
    private double total;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("total_item_price")
    @Expose
    private double totalItemPrice;
    @SerializedName("base_price")
    @Expose
    private double basePrice;
    @SerializedName("delivered_at")
    @Expose
    private String deliveredAt;
    @SerializedName("base_price_distance")
    @Expose
    private double basePriceDistance;
    @SerializedName("total_specification_price")
    @Expose
    private double totalItemSpecificationPrice;
    @SerializedName("promo_payment")
    @Expose
    private double promoPayment;
    @SerializedName("current_rate")
    @Expose
    private double currentRate;
    @SerializedName("total_surge_price")
    @Expose
    private double totalSurgePrice;
    @SerializedName("total_provider_income")
    @Expose
    private double totalProviderIncome;
    @SerializedName("remaining_payment")
    @Expose
    private double remainingPayment;
    @SerializedName("total_store_income")
    @Expose
    private double totalStoreIncome;
    @SerializedName("is_distance_unit_mile")
    @Expose
    private boolean isDistanceUnitMile;
    @SerializedName("taxes")
    @Expose
    private ArrayList<TaxesDetail> taxes;
    @SerializedName("is_tax_included")
    @Expose
    private boolean isTaxIncluded;
    @SerializedName("tip_amount")
    @Expose
    private double tipAmount;
    @SerializedName("booking_fees")
    private double bookingFees;
    @SerializedName("round_trip_charge")
    private double roundTripCharge;
    @SerializedName("total_round_trip_charge")
    private double totalRoundTripCharge;
    @SerializedName("additional_stop_price")
    private double additionalStopPrice;
    @SerializedName("total_waiting_time")
    private double totalWaitingTime;
    @SerializedName("total_waiting_time_price")
    private double totalWaitingTimePrice;

    public OrderPayment() {
    }

    protected OrderPayment(Parcel in) {
        this.userPayPayment = in.readDouble();
        this.isUserPickUpOrder = in.readByte() != 0;
        this.totalCartPrice = in.readDouble();
        this.currency = in.readString();
        this.refundAmount = in.readDouble();
        this.isStorePayDeliveryFees = in.readByte() != 0;
        this.isPaymentModeCash = in.readByte() != 0;
        this.isPromoForDeliveryService = in.readByte() != 0;
        this.totalTimePrice = in.readDouble();
        this.totalAdminProfitOnDelivery = in.readDouble();
        this.pricePerUnitDistance = in.readDouble();
        this.adminProfitModeOnStore = in.readDouble();
        this.distancePrice = in.readDouble();
        this.createdAt = in.readString();
        this.walletPayment = in.readDouble();
        this.minFare = in.readDouble();
        this.totalDeliveryAndStorePrice = in.readDouble();
        this.totalDistance = in.readDouble();
        this.totalBasePrice = in.readDouble();
        this.totalAfterTaxPrice = in.readDouble();
        this.totalTime = in.readDouble();
        this.cardPayment = in.readDouble();
        this.uniqueId = in.readInt();
        this.surgeMultiplier = in.readDouble();
        this.totalAdminTaxPrice = in.readDouble();
        this.adminProfitValueOnStore = in.readDouble();
        this.totalServicePrice = in.readDouble();
        this.totalStoreTaxPrice = in.readDouble();
        this.totalSpecifications = in.readInt();
        this.cashPayment = in.readDouble();
        this.userId = in.readString();
        this.adminCurrencyCode = in.readString();
        this.serviceTax = in.readDouble();
        this.id = in.readString();
        this.totalDeliveryPriceAfterSurge = in.readDouble();
        this.totalDeliveryPrice = in.readDouble();
        this.totalAfterWalletPayment = in.readDouble();
        this.pricePerUnitTime = in.readDouble();
        this.totalItem = in.readInt();
        this.totalAdminProfitOnStore = in.readDouble();
        this.totalDistancePrice = in.readDouble();
        this.adminProfitModeOnDelivery = in.readDouble();
        this.currencyCode = in.readString();
        this.totalOrderPrice = in.readDouble();
        this.adminProfitValueOnDelivery = in.readDouble();
        this.total = in.readDouble();
        this.updatedAt = in.readString();
        this.totalItemPrice = in.readDouble();
        this.basePrice = in.readDouble();
        this.deliveredAt = in.readString();
        this.basePriceDistance = in.readDouble();
        this.totalItemSpecificationPrice = in.readDouble();
        this.promoPayment = in.readDouble();
        this.currentRate = in.readDouble();
        this.totalSurgePrice = in.readDouble();
        this.totalProviderIncome = in.readDouble();
        this.remainingPayment = in.readDouble();
        this.totalStoreIncome = in.readDouble();
        this.isDistanceUnitMile = in.readByte() != 0;
        this.isTaxIncluded = in.readByte() != 0;
        this.taxes = in.createTypedArrayList(TaxesDetail.CREATOR);
        this.tipAmount = in.readDouble();
        this.bookingFees = in.readDouble();
        this.roundTripCharge = in.readDouble();
        this.totalRoundTripCharge = in.readDouble();
        this.additionalStopPrice = in.readDouble();
        this.totalWaitingTime = in.readDouble();
        this.totalWaitingTimePrice = in.readDouble();
    }

    public boolean isMinFareApplied() {
        return isMinFareApplied;
    }

    public double getUserPayPayment() {
        return userPayPayment;
    }

    public void setUserPayPayment(double userPayPayment) {
        this.userPayPayment = userPayPayment;
    }

    public boolean isUserPickUpOrder() {
        return isUserPickUpOrder;
    }

    public void setUserPickUpOrder(boolean userPickUpOrder) {
        isUserPickUpOrder = userPickUpOrder;
    }

    public double getTotalCartPrice() {
        return totalCartPrice;
    }

    public void setTotalCartPrice(double totalCartPrice) {
        this.totalCartPrice = totalCartPrice;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public double getTotalTimePrice() {
        return totalTimePrice;
    }

    public void setTotalTimePrice(double totalTimePrice) {
        this.totalTimePrice = totalTimePrice;
    }

    public double getTotalAdminProfitOnDelivery() {
        return totalAdminProfitOnDelivery;
    }

    public void setTotalAdminProfitOnDelivery(double totalAdminProfitOnDelivery) {
        this.totalAdminProfitOnDelivery = totalAdminProfitOnDelivery;
    }

    public double getPricePerUnitDistance() {
        return pricePerUnitDistance;
    }

    public void setPricePerUnitDistance(double pricePerUnitDistance) {
        this.pricePerUnitDistance = pricePerUnitDistance;
    }

    public double getAdminProfitModeOnStore() {
        return adminProfitModeOnStore;
    }

    public void setAdminProfitModeOnStore(double adminProfitModeOnStore) {
        this.adminProfitModeOnStore = adminProfitModeOnStore;
    }

    public double getDistancePrice() {
        return distancePrice;
    }

    public void setDistancePrice(double distancePrice) {
        this.distancePrice = distancePrice;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public double getWalletPayment() {
        return walletPayment;
    }

    public void setWalletPayment(double walletPayment) {
        this.walletPayment = walletPayment;
    }

    public double getMinFare() {
        return minFare;
    }

    public void setMinFare(double minFare) {
        this.minFare = minFare;
    }

    public double getTotalDeliveryAndStorePrice() {
        return totalDeliveryAndStorePrice;
    }

    public void setTotalDeliveryAndStorePrice(double totalDeliveryAndStorePrice) {
        this.totalDeliveryAndStorePrice = totalDeliveryAndStorePrice;
    }

    public double getTotalDistance() {
        return totalDistance;
    }

    public void setTotalDistance(double totalDistance) {
        this.totalDistance = totalDistance;
    }

    public double getTotalBasePrice() {
        return totalBasePrice;
    }

    public void setTotalBasePrice(double totalBasePrice) {
        this.totalBasePrice = totalBasePrice;
    }

    public double getTotalAfterTaxPrice() {
        return totalAfterTaxPrice;
    }

    public void setTotalAfterTaxPrice(double totalAfterTaxPrice) {
        this.totalAfterTaxPrice = totalAfterTaxPrice;
    }

    public double getTotalTime() {
        return totalTime;
    }

    public void setTotalTime(double totalTime) {
        this.totalTime = totalTime;
    }

    public double getCardPayment() {
        return cardPayment;
    }

    public void setCardPayment(double cardPayment) {
        this.cardPayment = cardPayment;
    }

    public int getUniqueId() {
        return uniqueId;
    }

    public void setUniqueId(int uniqueId) {
        this.uniqueId = uniqueId;
    }

    public double getSurgeMultiplier() {
        return surgeMultiplier;
    }

    public void setSurgeMultiplier(double surgeMultiplier) {
        this.surgeMultiplier = surgeMultiplier;
    }

    public double getTotalAdminTaxPrice() {
        return totalAdminTaxPrice;
    }

    public void setTotalAdminTaxPrice(double totalAdminTaxPrice) {
        this.totalAdminTaxPrice = totalAdminTaxPrice;
    }

    public double getAdminProfitValueOnStore() {
        return adminProfitValueOnStore;
    }

    public void setAdminProfitValueOnStore(double adminProfitValueOnStore) {
        this.adminProfitValueOnStore = adminProfitValueOnStore;
    }

    public double getTotalServicePrice() {
        return totalServicePrice;
    }

    public void setTotalServicePrice(double totalServicePrice) {
        this.totalServicePrice = totalServicePrice;
    }

    public double getTotalStoreTaxPrice() {
        return totalStoreTaxPrice;
    }

    public void setTotalStoreTaxPrice(double totalStoreTaxPrice) {
        this.totalStoreTaxPrice = totalStoreTaxPrice;
    }

    public int getTotalSpecifications() {
        return totalSpecifications;
    }

    public void setTotalSpecifications(int totalSpecifications) {
        this.totalSpecifications = totalSpecifications;
    }

    public double getCashPayment() {
        return cashPayment;
    }

    public void setCashPayment(double cashPayment) {
        this.cashPayment = cashPayment;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getAdminCurrencyCode() {
        return adminCurrencyCode;
    }

    public void setAdminCurrencyCode(String adminCurrencyCode) {
        this.adminCurrencyCode = adminCurrencyCode;
    }

    public Object getProviderId() {
        return providerId;
    }

    public void setProviderId(Object providerId) {
        this.providerId = providerId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getTotalDeliveryPriceAfterSurge() {
        return totalDeliveryPriceAfterSurge;
    }

    public void setTotalDeliveryPriceAfterSurge(double totalDeliveryPriceAfterSurge) {
        this.totalDeliveryPriceAfterSurge = totalDeliveryPriceAfterSurge;
    }

    public Object getOrderId() {
        return orderId;
    }

    public void setOrderId(Object orderId) {
        this.orderId = orderId;
    }

    public double getTotalDeliveryPrice() {
        return totalDeliveryPrice;
    }

    public void setTotalDeliveryPrice(double totalDeliveryPrice) {
        this.totalDeliveryPrice = totalDeliveryPrice;
    }

    public double getTotalAfterWalletPayment() {
        return totalAfterWalletPayment;
    }

    public void setTotalAfterWalletPayment(double totalAfterWalletPayment) {
        this.totalAfterWalletPayment = totalAfterWalletPayment;
    }

    public double getPricePerUnitTime() {
        return pricePerUnitTime;
    }

    public void setPricePerUnitTime(double pricePerUnitTime) {
        this.pricePerUnitTime = pricePerUnitTime;
    }

    public int getTotalItem() {
        return totalItem;
    }

    public void setTotalItem(int totalItem) {
        this.totalItem = totalItem;
    }

    public double getTotalAdminProfitOnStore() {
        return totalAdminProfitOnStore;
    }

    public void setTotalAdminProfitOnStore(double totalAdminProfitOnStore) {
        this.totalAdminProfitOnStore = totalAdminProfitOnStore;
    }

    public double getTotalDistancePrice() {
        return totalDistancePrice;
    }

    public void setTotalDistancePrice(double totalDistancePrice) {
        this.totalDistancePrice = totalDistancePrice;
    }


    public double getAdminProfitModeOnDelivery() {
        return adminProfitModeOnDelivery;
    }

    public void setAdminProfitModeOnDelivery(double adminProfitModeOnDelivery) {
        this.adminProfitModeOnDelivery = adminProfitModeOnDelivery;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public double getTotalOrderPrice() {
        return totalOrderPrice;
    }

    public void setTotalOrderPrice(double totalOrderPrice) {
        this.totalOrderPrice = totalOrderPrice;
    }

    public double getAdminProfitValueOnDelivery() {
        return adminProfitValueOnDelivery;
    }

    public void setAdminProfitValueOnDelivery(double adminProfitValueOnDelivery) {
        this.adminProfitValueOnDelivery = adminProfitValueOnDelivery;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public double getTotalItemPrice() {
        return totalItemPrice;
    }

    public void setTotalItemPrice(double totalItemPrice) {
        this.totalItemPrice = totalItemPrice;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public String getDeliveredAt() {
        return deliveredAt;
    }

    public void setDeliveredAt(String deliveredAt) {
        this.deliveredAt = deliveredAt;
    }

    public double getBasePriceDistance() {
        return basePriceDistance;
    }

    public void setBasePriceDistance(double basePriceDistance) {
        this.basePriceDistance = basePriceDistance;
    }

    public double getTotalItemSpecificationPrice() {
        return totalItemSpecificationPrice;
    }

    public void setTotalItemSpecificationPrice(double totalItemSpecificationPrice) {
        this.totalItemSpecificationPrice = totalItemSpecificationPrice;
    }

    public double getPromoPayment() {
        return promoPayment;
    }

    public void setPromoPayment(double promoPayment) {
        this.promoPayment = promoPayment;
    }

    public double getCurrentRate() {
        return currentRate;
    }

    public void setCurrentRate(double currentRate) {
        this.currentRate = currentRate;
    }

    public double getTotalSurgePrice() {
        return totalSurgePrice;
    }

    public void setTotalSurgePrice(double totalSurgePrice) {
        this.totalSurgePrice = totalSurgePrice;
    }

    public double getTotalProviderIncome() {
        return totalProviderIncome;
    }

    public void setTotalProviderIncome(double totalProviderIncome) {
        this.totalProviderIncome = totalProviderIncome;
    }

    public double getRemainingPayment() {
        return remainingPayment;
    }

    public void setRemainingPayment(double remainingPayment) {
        this.remainingPayment = remainingPayment;
    }

    public double getTotalStoreIncome() {
        return totalStoreIncome;
    }

    public void setTotalStoreIncome(double totalStoreIncome) {
        this.totalStoreIncome = totalStoreIncome;
    }

    public double getServiceTax() {
        return serviceTax;
    }

    public void setServiceTax(double serviceTax) {
        this.serviceTax = serviceTax;
    }

    public boolean isDistanceUnitMile() {
        return isDistanceUnitMile;
    }

    public void setDistanceUnitMile(boolean distanceUnitMile) {
        isDistanceUnitMile = distanceUnitMile;
    }

    public boolean isPromoForDeliveryService() {
        return isPromoForDeliveryService;
    }

    public void setPromoForDeliveryService(boolean promoForDeliveryService) {
        isPromoForDeliveryService = promoForDeliveryService;
    }

    public boolean isPaymentModeCash() {
        return isPaymentModeCash;
    }

    public void setPaymentModeCash(boolean paymentModeCash) {
        isPaymentModeCash = paymentModeCash;
    }

    public boolean isStorePayDeliveryFees() {
        return isStorePayDeliveryFees;
    }

    public void setStorePayDeliveryFees(boolean storePayDeliveryFees) {
        isStorePayDeliveryFees = storePayDeliveryFees;
    }

    public double getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(double refundAmount) {
        this.refundAmount = refundAmount;
    }

    public double getTipAmount() {
        return tipAmount;
    }

    public double getBookingFees() {
        return bookingFees;
    }

    public ArrayList<TaxesDetail> getTaxes() {
        return taxes;
    }

    public void setTaxes(ArrayList<TaxesDetail> taxes) {
        this.taxes = taxes;
    }

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public void setMinFareApplied(boolean minFareApplied) {
        isMinFareApplied = minFareApplied;
    }

    public void setTipAmount(double tipAmount) {
        this.tipAmount = tipAmount;
    }

    public void setBookingFees(double bookingFees) {
        this.bookingFees = bookingFees;
    }

    public double getRoundTripCharge() {
        return roundTripCharge;
    }

    public void setRoundTripCharge(double roundTripCharge) {
        this.roundTripCharge = roundTripCharge;
    }

    public double getTotalRoundTripCharge() {
        return totalRoundTripCharge;
    }

    public void setTotalRoundTripCharge(double totalRoundTripCharge) {
        this.totalRoundTripCharge = totalRoundTripCharge;
    }

    public double getAdditionalStopPrice() {
        return additionalStopPrice;
    }

    public void setAdditionalStopPrice(double additionalStopPrice) {
        this.additionalStopPrice = additionalStopPrice;
    }

    public double getTotalWaitingTime() {
        return totalWaitingTime;
    }

    public void setTotalWaitingTime(double totalWaitingTime) {
        this.totalWaitingTime = totalWaitingTime;
    }

    public double getTotalWaitingTimePrice() {
        return totalWaitingTimePrice;
    }

    public void setTotalWaitingTimePrice(double totalWaitingTimePrice) {
        this.totalWaitingTimePrice = totalWaitingTimePrice;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeDouble(this.userPayPayment);
        dest.writeByte(this.isUserPickUpOrder ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalCartPrice);
        dest.writeString(this.currency);
        dest.writeDouble(this.refundAmount);
        dest.writeByte(this.isStorePayDeliveryFees ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isPaymentModeCash ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isPromoForDeliveryService ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalTimePrice);
        dest.writeDouble(this.totalAdminProfitOnDelivery);
        dest.writeDouble(this.pricePerUnitDistance);
        dest.writeDouble(this.adminProfitModeOnStore);
        dest.writeDouble(this.distancePrice);
        dest.writeString(this.createdAt);
        dest.writeDouble(this.walletPayment);
        dest.writeDouble(this.minFare);
        dest.writeDouble(this.totalDeliveryAndStorePrice);
        dest.writeDouble(this.totalDistance);
        dest.writeDouble(this.totalBasePrice);
        dest.writeDouble(this.totalAfterTaxPrice);
        dest.writeDouble(this.totalTime);
        dest.writeDouble(this.cardPayment);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.surgeMultiplier);
        dest.writeDouble(this.totalAdminTaxPrice);
        dest.writeDouble(this.adminProfitValueOnStore);
        dest.writeDouble(this.totalServicePrice);
        dest.writeDouble(this.totalStoreTaxPrice);
        dest.writeInt(this.totalSpecifications);
        dest.writeDouble(this.cashPayment);
        dest.writeString(this.userId);
        dest.writeString(this.adminCurrencyCode);
        dest.writeDouble(this.serviceTax);
        dest.writeString(this.id);
        dest.writeDouble(this.totalDeliveryPriceAfterSurge);
        dest.writeDouble(this.totalDeliveryPrice);
        dest.writeDouble(this.totalAfterWalletPayment);
        dest.writeDouble(this.pricePerUnitTime);
        dest.writeInt(this.totalItem);
        dest.writeDouble(this.totalAdminProfitOnStore);
        dest.writeDouble(this.totalDistancePrice);
        dest.writeDouble(this.adminProfitModeOnDelivery);
        dest.writeString(this.currencyCode);
        dest.writeDouble(this.totalOrderPrice);
        dest.writeDouble(this.adminProfitValueOnDelivery);
        dest.writeDouble(this.total);
        dest.writeString(this.updatedAt);
        dest.writeDouble(this.totalItemPrice);
        dest.writeDouble(this.basePrice);
        dest.writeString(this.deliveredAt);
        dest.writeDouble(this.basePriceDistance);
        dest.writeDouble(this.totalItemSpecificationPrice);
        dest.writeDouble(this.promoPayment);
        dest.writeDouble(this.currentRate);
        dest.writeDouble(this.totalSurgePrice);
        dest.writeDouble(this.totalProviderIncome);
        dest.writeDouble(this.remainingPayment);
        dest.writeDouble(this.totalStoreIncome);
        dest.writeByte(this.isDistanceUnitMile ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isTaxIncluded ? (byte) 1 : (byte) 0);
        dest.writeTypedList(taxes);
        dest.writeDouble(this.tipAmount);
        dest.writeDouble(this.bookingFees);
        dest.writeDouble(this.roundTripCharge);
        dest.writeDouble(this.totalRoundTripCharge);
        dest.writeDouble(this.additionalStopPrice);
        dest.writeDouble(this.totalWaitingTime);
        dest.writeDouble(this.totalWaitingTimePrice);
    }
}