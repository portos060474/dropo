package com.dropo.store.models.datamodel;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class OrderDetail {


    @SerializedName("provider_detail")
    private ProviderDetail providerDetail;

    @SerializedName("request_detail")
    private RequestDetail requestDetail;

    @SerializedName("order")
    @Expose
    private Order order;

    @SerializedName("order_payment_detail")
    private OrderPaymentDetail orderPaymentDetail;

    @SerializedName("cart_detail")
    @Expose
    private OrderData cartDetail;

    @SerializedName("user_id")
    @Expose
    private String userId;

    @SerializedName("is_confirmation_code_required_at_pickup_delivery")
    private boolean isConfirmationCodeRequiredAtPickupDelivery;
    @SerializedName("is_confirmation_code_required_at_complete_delivery")
    private boolean isConfirmationCodeRequiredAtCompleteDelivery;

    @SerializedName("currency")
    @Expose
    private String currency;

    @SerializedName("store_tax_details")
    @Expose
    private List<TaxesDetail> storeTaxDetails;

    @SerializedName("is_use_item_tax")
    private boolean isUseItemTax;

    @SerializedName("is_tax_included")
    private boolean isTaxIncluded;

    public OrderPaymentDetail getOrderPaymentDetail() {
        return orderPaymentDetail;
    }

    public OrderData getCartDetail() {
        return cartDetail;
    }

    public String getUserId() {
        return userId;
    }

    public boolean isConfirmationCodeRequiredAtPickupDelivery() {
        return isConfirmationCodeRequiredAtPickupDelivery;
    }

    public boolean isConfirmationCodeRequiredAtCompleteDelivery() {
        return isConfirmationCodeRequiredAtCompleteDelivery;
    }

    public String getCurrency() {
        return currency;
    }

    public Order getOrder() {
        return order;
    }

    public RequestDetail getRequestDetail() {
        return requestDetail;
    }

    public ProviderDetail getProviderDetail() {
        return providerDetail;
    }

    public List<TaxesDetail> getStoreTaxDetails() {
        if (storeTaxDetails == null) {
            return new ArrayList<>();
        } else {
            return storeTaxDetails;
        }
    }

    public boolean getUseItemTax() {
        return isUseItemTax;
    }

    public boolean getTaxIncluded() {
        return isTaxIncluded;
    }
}