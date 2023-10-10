package com.dropo.provider.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

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
    @SerializedName("total_cart_price")
    @Expose
    private double totalCartPrice;
    @SerializedName("is_store_pay_delivery_fees")
    @Expose
    private boolean isStorePayDeliveryFees;
    @SerializedName("is_order_price_paid_by_store")
    @Expose
    private boolean isOrderPricePaidByStore;
    @SerializedName("order_unique_id")
    private int orderUniqueId;
    @SerializedName("is_promo_for_delivery_service")
    @Expose
    private boolean isPromoForDeliveryService;
    @SerializedName("total_base_price")
    @Expose
    private double totalBasePrice;
    @SerializedName("total_time_price")
    @Expose
    private double totalTimePrice;
    @SerializedName("total_admin_profit_on_delivery")
    @Expose
    private double totalAdminProfitOnDelivery;
    @SerializedName("price_per_unit_distance")
    @Expose
    private double pricePerUnitDistance;
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
    @SerializedName("total_service_price")
    @Expose
    private double totalServicePrice;
    @SerializedName("total_store_tax_price")
    @Expose
    private double totalStoreTaxPrice;
    @SerializedName("is_payment_mode_cash")
    @Expose
    private boolean isPaymentModeCash;
    @SerializedName("total_specification_count")
    @Expose
    private int totalSpecifications;
    @SerializedName("cash_payment")
    @Expose
    private double cashPayment;
    @SerializedName("is_cancellation_fee")
    @Expose
    private boolean isCancellationFee;
    @SerializedName("user_id")
    @Expose
    private String userId;
    @SerializedName("admin_currency_code")
    @Expose
    private String adminCurrencyCode;
    @SerializedName("service_tax")
    @Expose
    private double serviceTax;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("total_delivery_price_after_surge")
    @Expose
    private double totalDeliveryPriceAfterSurge;
    @SerializedName("order_id")
    @Expose
    private String orderId;
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
    @SerializedName("is_payment_paid")
    @Expose
    private boolean isPaymentPaid;
    @SerializedName("total_distance_price")
    @Expose
    private double totalDistancePrice;
    @SerializedName("item_tax")
    @Expose
    private double itemTax;
    @SerializedName("currency_code")
    @Expose
    private String currencyCode;
    @SerializedName("total_order_price")
    @Expose
    private double totalOrderPrice;
    @SerializedName("is_pending_payment")
    @Expose
    private boolean isPendingPayment;
    @SerializedName("admin_profit_value_on_delivery")
    @Expose
    private double adminProfitValueOnDelivery;
    @SerializedName("total")
    @Expose
    private double total;
    @SerializedName("updated_at")
    @Expose
    private String updatedAt;
    @SerializedName("is_surge_hours")
    @Expose
    private boolean isSurgeHours;
    @SerializedName("base_price")
    @Expose
    private double basePrice;
    @SerializedName("delivered_at")
    @Expose
    private String deliveredAt;
    @SerializedName("base_price_distance")
    @Expose
    private double basePriceDistance;
    @SerializedName("promo_payment")
    @Expose
    private double promoPayment;
    @SerializedName("is_min_fare_used")
    @Expose
    private boolean isMinFareUsed;
    @SerializedName("total_surge_price")
    @Expose
    private double totalSurgePrice;
    @SerializedName("total_provider_income")
    @Expose
    private double totalProviderIncome;
    @SerializedName("remaining_payment")
    @Expose
    private double remainingPayment;
    @SerializedName("is_distance_unit_mile")
    @Expose
    private boolean isDistanceUnitMile;
    @SerializedName("total_item_price")
    @Expose
    private double totalItemPrice;
    @SerializedName("total_specification_price")
    @Expose
    private double totalItemSpecificationPrice;
    @SerializedName("provider_paid_order_payment")
    private double providerPaidOrderPayment;
    @SerializedName("provider_have_cash_payment")
    private double providerHaveCashPayment;
    @SerializedName("pay_to_provider")
    private double payToProvider;
    @SerializedName("tip_amount")
    private double tipAmount;
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
        this.totalCartPrice = in.readDouble();
        this.isStorePayDeliveryFees = in.readByte() != 0;
        this.isOrderPricePaidByStore = in.readByte() != 0;
        this.orderUniqueId = in.readInt();
        this.isPromoForDeliveryService = in.readByte() != 0;
        this.totalBasePrice = in.readDouble();
        this.totalTimePrice = in.readDouble();
        this.totalAdminProfitOnDelivery = in.readDouble();
        this.pricePerUnitDistance = in.readDouble();
        this.distancePrice = in.readDouble();
        this.createdAt = in.readString();
        this.walletPayment = in.readDouble();
        this.minFare = in.readDouble();
        this.totalDeliveryAndStorePrice = in.readDouble();
        this.totalDistance = in.readDouble();
        this.totalAfterTaxPrice = in.readDouble();
        this.totalTime = in.readDouble();
        this.cardPayment = in.readDouble();
        this.uniqueId = in.readInt();
        this.surgeMultiplier = in.readDouble();
        this.totalAdminTaxPrice = in.readDouble();
        this.totalServicePrice = in.readDouble();
        this.totalStoreTaxPrice = in.readDouble();
        this.isPaymentModeCash = in.readByte() != 0;
        this.totalSpecifications = in.readInt();
        this.cashPayment = in.readDouble();
        this.isCancellationFee = in.readByte() != 0;
        this.userId = in.readString();
        this.adminCurrencyCode = in.readString();
        this.serviceTax = in.readDouble();
        this.id = in.readString();
        this.totalDeliveryPriceAfterSurge = in.readDouble();
        this.orderId = in.readString();
        this.totalDeliveryPrice = in.readDouble();
        this.totalAfterWalletPayment = in.readDouble();
        this.pricePerUnitTime = in.readDouble();
        this.totalItem = in.readInt();
        this.isPaymentPaid = in.readByte() != 0;
        this.totalDistancePrice = in.readDouble();
        this.itemTax = in.readDouble();
        this.currencyCode = in.readString();
        this.totalOrderPrice = in.readDouble();
        this.isPendingPayment = in.readByte() != 0;
        this.adminProfitValueOnDelivery = in.readDouble();
        this.total = in.readDouble();
        this.updatedAt = in.readString();
        this.isSurgeHours = in.readByte() != 0;
        this.basePrice = in.readDouble();
        this.deliveredAt = in.readString();
        this.basePriceDistance = in.readDouble();
        this.promoPayment = in.readDouble();
        this.isMinFareUsed = in.readByte() != 0;
        this.totalSurgePrice = in.readDouble();
        this.totalProviderIncome = in.readDouble();
        this.remainingPayment = in.readDouble();
        this.isDistanceUnitMile = in.readByte() != 0;
        this.totalItemPrice = in.readDouble();
        this.totalItemSpecificationPrice = in.readDouble();
        this.providerPaidOrderPayment = in.readDouble();
        this.providerHaveCashPayment = in.readDouble();
        this.payToProvider = in.readDouble();
        this.tipAmount = in.readDouble();
        this.roundTripCharge = in.readDouble();
        this.totalRoundTripCharge = in.readDouble();
        this.additionalStopPrice = in.readDouble();
        this.totalWaitingTime = in.readDouble();
        this.totalWaitingTimePrice = in.readDouble();
    }

    public double getTotalCartPrice() {
        return totalCartPrice;
    }

    public void setTotalCartPrice(double totalCartPrice) {
        this.totalCartPrice = totalCartPrice;
    }

    public double getTotalBasePrice() {
        return totalBasePrice;
    }

    public void setTotalBasePrice(double totalBasePrice) {
        this.totalBasePrice = totalBasePrice;
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

    public boolean isPaymentModeCash() {
        return isPaymentModeCash;
    }

    public void setPaymentModeCash(boolean paymentModeCash) {
        isPaymentModeCash = paymentModeCash;
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

    public boolean isCancellationFee() {
        return isCancellationFee;
    }

    public void setCancellationFee(boolean cancellationFee) {
        isCancellationFee = cancellationFee;
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

    public double getServiceTax() {
        return serviceTax;
    }

    public void setServiceTax(double serviceTax) {
        this.serviceTax = serviceTax;
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

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
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

    public boolean isPaymentPaid() {
        return isPaymentPaid;
    }

    public void setPaymentPaid(boolean paymentPaid) {
        isPaymentPaid = paymentPaid;
    }

    public double getTotalDistancePrice() {
        return totalDistancePrice;
    }

    public void setTotalDistancePrice(double totalDistancePrice) {
        this.totalDistancePrice = totalDistancePrice;
    }

    public double getItemTax() {
        return itemTax;
    }

    public void setItemTax(double itemTax) {
        this.itemTax = itemTax;
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

    public boolean isPendingPayment() {
        return isPendingPayment;
    }

    public void setPendingPayment(boolean pendingPayment) {
        isPendingPayment = pendingPayment;
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

    public boolean isSurgeHours() {
        return isSurgeHours;
    }

    public void setSurgeHours(boolean surgeHours) {
        isSurgeHours = surgeHours;
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

    public double getPromoPayment() {
        return promoPayment;
    }

    public void setPromoPayment(double promoPayment) {
        this.promoPayment = promoPayment;
    }

    public boolean isMinFareUsed() {
        return isMinFareUsed;
    }

    public void setMinFareUsed(boolean minFareUsed) {
        isMinFareUsed = minFareUsed;
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

    public boolean isDistanceUnitMile() {
        return isDistanceUnitMile;
    }

    public void setDistanceUnitMile(boolean distanceUnitMile) {
        isDistanceUnitMile = distanceUnitMile;
    }

    public double getTotalItemPrice() {
        return totalItemPrice;
    }

    public void setTotalItemPrice(double totalItemPrice) {
        this.totalItemPrice = totalItemPrice;
    }

    public double getTotalItemSpecificationPrice() {
        return totalItemSpecificationPrice;
    }

    public void setTotalItemSpecificationPrice(double totalItemSpecificationPrice) {
        this.totalItemSpecificationPrice = totalItemSpecificationPrice;
    }

    public int getOrderUniqueId() {
        return orderUniqueId;
    }

    public void setOrderUniqueId(int orderUniqueId) {
        this.orderUniqueId = orderUniqueId;
    }

    public boolean isPromoForDeliveryService() {
        return isPromoForDeliveryService;
    }

    public void setPromoForDeliveryService(boolean promoForDeliveryService) {
        isPromoForDeliveryService = promoForDeliveryService;
    }

    public double getProviderPaidOrderPayment() {
        return providerPaidOrderPayment;
    }

    public void setProviderPaidOrderPayment(double providerPaidOrderPayment) {
        this.providerPaidOrderPayment = providerPaidOrderPayment;
    }

    public double getProviderHaveCashPayment() {
        return providerHaveCashPayment;
    }

    public void setProviderHaveCashPayment(double providerHaveCashPayment) {
        this.providerHaveCashPayment = providerHaveCashPayment;
    }

    public double getPayToProvider() {
        return payToProvider;
    }

    public void setPayToProvider(double payToProvider) {
        this.payToProvider = payToProvider;
    }

    public boolean isOrderPricePaidByStore() {
        return isOrderPricePaidByStore;
    }

    public void setOrderPricePaidByStore(boolean orderPricePaidByStore) {
        isOrderPricePaidByStore = orderPricePaidByStore;
    }

    public boolean isStorePayDeliveryFees() {
        return isStorePayDeliveryFees;
    }

    public void setStorePayDeliveryFees(boolean storePayDeliveryFees) {
        isStorePayDeliveryFees = storePayDeliveryFees;
    }

    public double getTipAmount() {
        return tipAmount;
    }

    public void setTipAmount(double tipAmount) {
        this.tipAmount = tipAmount;
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
        dest.writeDouble(this.totalCartPrice);
        dest.writeByte(this.isStorePayDeliveryFees ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isOrderPricePaidByStore ? (byte) 1 : (byte) 0);
        dest.writeInt(this.orderUniqueId);
        dest.writeByte(this.isPromoForDeliveryService ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalBasePrice);
        dest.writeDouble(this.totalTimePrice);
        dest.writeDouble(this.totalAdminProfitOnDelivery);
        dest.writeDouble(this.pricePerUnitDistance);
        dest.writeDouble(this.distancePrice);
        dest.writeString(this.createdAt);
        dest.writeDouble(this.walletPayment);
        dest.writeDouble(this.minFare);
        dest.writeDouble(this.totalDeliveryAndStorePrice);
        dest.writeDouble(this.totalDistance);
        dest.writeDouble(this.totalAfterTaxPrice);
        dest.writeDouble(this.totalTime);
        dest.writeDouble(this.cardPayment);
        dest.writeInt(this.uniqueId);
        dest.writeDouble(this.surgeMultiplier);
        dest.writeDouble(this.totalAdminTaxPrice);
        dest.writeDouble(this.totalServicePrice);
        dest.writeDouble(this.totalStoreTaxPrice);
        dest.writeByte(this.isPaymentModeCash ? (byte) 1 : (byte) 0);
        dest.writeInt(this.totalSpecifications);
        dest.writeDouble(this.cashPayment);
        dest.writeByte(this.isCancellationFee ? (byte) 1 : (byte) 0);
        dest.writeString(this.userId);
        dest.writeString(this.adminCurrencyCode);
        dest.writeDouble(this.serviceTax);
        dest.writeString(this.id);
        dest.writeDouble(this.totalDeliveryPriceAfterSurge);
        dest.writeString(this.orderId);
        dest.writeDouble(this.totalDeliveryPrice);
        dest.writeDouble(this.totalAfterWalletPayment);
        dest.writeDouble(this.pricePerUnitTime);
        dest.writeInt(this.totalItem);
        dest.writeByte(this.isPaymentPaid ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalDistancePrice);
        dest.writeDouble(this.itemTax);
        dest.writeString(this.currencyCode);
        dest.writeDouble(this.totalOrderPrice);
        dest.writeByte(this.isPendingPayment ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.adminProfitValueOnDelivery);
        dest.writeDouble(this.total);
        dest.writeString(this.updatedAt);
        dest.writeByte(this.isSurgeHours ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.basePrice);
        dest.writeString(this.deliveredAt);
        dest.writeDouble(this.basePriceDistance);
        dest.writeDouble(this.promoPayment);
        dest.writeByte(this.isMinFareUsed ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalSurgePrice);
        dest.writeDouble(this.totalProviderIncome);
        dest.writeDouble(this.remainingPayment);
        dest.writeByte(this.isDistanceUnitMile ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.totalItemPrice);
        dest.writeDouble(this.totalItemSpecificationPrice);
        dest.writeDouble(this.providerPaidOrderPayment);
        dest.writeDouble(this.providerHaveCashPayment);
        dest.writeDouble(this.payToProvider);
        dest.writeDouble(this.tipAmount);
        dest.writeDouble(this.roundTripCharge);
        dest.writeDouble(this.totalRoundTripCharge);
        dest.writeDouble(this.additionalStopPrice);
        dest.writeDouble(this.totalWaitingTime);
        dest.writeDouble(this.totalWaitingTimePrice);
    }
}