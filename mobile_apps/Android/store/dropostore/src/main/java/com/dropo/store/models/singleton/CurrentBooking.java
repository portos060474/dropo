package com.dropo.store.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.datamodel.Addresses;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by elluminati on 13-Feb-17.
 *
 * @see "Please modify carfully b'coz is effect in wholl app"
 */

public class CurrentBooking implements Parcelable {

    public static final Creator<CurrentBooking> CREATOR = new Creator<CurrentBooking>() {
        @Override
        public CurrentBooking createFromParcel(Parcel in) {
            return new CurrentBooking(in);
        }

        @Override
        public CurrentBooking[] newArray(int size) {
            return new CurrentBooking[size];
        }
    };
    private static CurrentBooking currentBooking = new CurrentBooking();
    private final ArrayList<CartProducts> cartProductList;
    private final ArrayList<Addresses> destinationAddresses;
    private final ArrayList<Addresses> pickupAddresses;
    private final List<String> favourite;
    private final List<VehicleDetail> vehicleDetails;
    private final List<VehicleDetail> adminVehicleDetails;
    private String bookCityId;
    private String bookCountryId;
    private boolean isCashPaymentMode;
    private boolean isOtherPaymentMode;
    private boolean isPromoApplyForCash;
    private boolean isPromoApplyForOther;
    private String currentCity;
    private String currency;
    private String currencyCode = "";
    private String selectedStoreId;
    private String deliveryAddress;
    private LatLng deliveryLatLng;
    private LatLng storeLatLng;
    private double totalCartAmount;
    private double totalCartAmountWithoutTax;
    private String orderPaymentId;
    private boolean isStoreClosed;
    private boolean isHaveOrders;
    private String deliveryCurrency;
    private String deliveryNote;
    private String currentAddress;
    private LatLng currentLatLng;
    private String country = "";
    private String countryCode = "";
    private String countryCode2 = "";
    private String city1 = "";
    private String city2 = "";
    private String city3 = "";
    private String cityCode = "";
    private double paymentLatitude = 0.0;
    private double paymentLongitude = 0.0;
    private double totalInvoiceAmount;
    private String cartCityId;
    private String serverTime;
    private String timeZone;
    private String futureOrderDate;
    private String futureOrderTime;
    private long futureOrderSelectedTimeZoneMillis;
    private long futureOrderSelectedTimeUTCMillis;
    private boolean isFutureOrder;
    private ArrayList<TaxesDetail> storeTaxesDetails;

    private CurrentBooking() {
        cartProductList = new ArrayList<>();
        favourite = new ArrayList<>();
        destinationAddresses = new ArrayList<>();
        pickupAddresses = new ArrayList<>();
        vehicleDetails = new ArrayList<>();
        adminVehicleDetails = new ArrayList<>();
        storeTaxesDetails = new ArrayList<>();
    }

    protected CurrentBooking(Parcel in) {
        cartProductList = in.createTypedArrayList(CartProducts.CREATOR);
        destinationAddresses = in.createTypedArrayList(Addresses.CREATOR);
        pickupAddresses = in.createTypedArrayList(Addresses.CREATOR);
        storeTaxesDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
        favourite = in.createStringArrayList();
        bookCityId = in.readString();
        bookCountryId = in.readString();
        isCashPaymentMode = in.readByte() != 0;
        isOtherPaymentMode = in.readByte() != 0;
        isPromoApplyForCash = in.readByte() != 0;
        isPromoApplyForOther = in.readByte() != 0;
        currentCity = in.readString();
        currency = in.readString();
        currencyCode = in.readString();
        selectedStoreId = in.readString();
        deliveryAddress = in.readString();
        deliveryLatLng = in.readParcelable(LatLng.class.getClassLoader());
        storeLatLng = in.readParcelable(LatLng.class.getClassLoader());
        totalCartAmount = in.readDouble();
        totalCartAmountWithoutTax = in.readDouble();
        orderPaymentId = in.readString();
        isStoreClosed = in.readByte() != 0;
        isHaveOrders = in.readByte() != 0;
        deliveryCurrency = in.readString();
        deliveryNote = in.readString();
        currentAddress = in.readString();
        currentLatLng = in.readParcelable(LatLng.class.getClassLoader());
        country = in.readString();
        countryCode = in.readString();
        countryCode2 = in.readString();
        city1 = in.readString();
        city2 = in.readString();
        city3 = in.readString();
        cityCode = in.readString();
        paymentLatitude = in.readDouble();
        paymentLongitude = in.readDouble();
        totalInvoiceAmount = in.readDouble();
        cartCityId = in.readString();
        serverTime = in.readString();
        timeZone = in.readString();
        futureOrderDate = in.readString();
        futureOrderTime = in.readString();
        futureOrderSelectedTimeZoneMillis = in.readLong();
        futureOrderSelectedTimeUTCMillis = in.readLong();
        isFutureOrder = in.readByte() != 0;
        vehicleDetails = in.createTypedArrayList(VehicleDetail.CREATOR);
        adminVehicleDetails = in.createTypedArrayList(VehicleDetail.CREATOR);
    }

    public static CurrentBooking getInstance() {
        return currentBooking;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("current_booking", currentBooking);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            currentBooking = state.getParcelable("current_booking");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(cartProductList);
        dest.writeTypedList(destinationAddresses);
        dest.writeTypedList(pickupAddresses);
        dest.writeTypedList(storeTaxesDetails);
        dest.writeStringList(favourite);
        dest.writeString(bookCityId);
        dest.writeString(bookCountryId);
        dest.writeByte((byte) (isCashPaymentMode ? 1 : 0));
        dest.writeByte((byte) (isOtherPaymentMode ? 1 : 0));
        dest.writeByte((byte) (isPromoApplyForCash ? 1 : 0));
        dest.writeByte((byte) (isPromoApplyForOther ? 1 : 0));
        dest.writeString(currentCity);
        dest.writeString(currency);
        dest.writeString(currencyCode);
        dest.writeString(selectedStoreId);
        dest.writeString(deliveryAddress);
        dest.writeParcelable(deliveryLatLng, flags);
        dest.writeParcelable(storeLatLng, flags);
        dest.writeDouble(totalCartAmount);
        dest.writeDouble(totalCartAmountWithoutTax);
        dest.writeString(orderPaymentId);
        dest.writeByte((byte) (isStoreClosed ? 1 : 0));
        dest.writeByte((byte) (isHaveOrders ? 1 : 0));
        dest.writeString(deliveryCurrency);
        dest.writeString(deliveryNote);
        dest.writeString(currentAddress);
        dest.writeParcelable(currentLatLng, flags);
        dest.writeString(country);
        dest.writeString(countryCode);
        dest.writeString(countryCode2);
        dest.writeString(city1);
        dest.writeString(city2);
        dest.writeString(city3);
        dest.writeString(cityCode);
        dest.writeDouble(paymentLatitude);
        dest.writeDouble(paymentLongitude);
        dest.writeDouble(totalInvoiceAmount);
        dest.writeString(cartCityId);
        dest.writeString(serverTime);
        dest.writeString(timeZone);
        dest.writeString(futureOrderDate);
        dest.writeString(futureOrderTime);
        dest.writeLong(futureOrderSelectedTimeZoneMillis);
        dest.writeLong(futureOrderSelectedTimeUTCMillis);
        dest.writeByte((byte) (isFutureOrder ? 1 : 0));
        dest.writeTypedList(vehicleDetails);
        dest.writeTypedList(adminVehicleDetails);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public List<VehicleDetail> getAdminVehicleDetails() {
        return adminVehicleDetails;
    }

    public void setAdminVehicleDetails(List<VehicleDetail> adminVehicleDetails) {
        this.adminVehicleDetails.clear();
        this.adminVehicleDetails.addAll(adminVehicleDetails);
    }

    public List<VehicleDetail> getVehicleDetails() {
        return vehicleDetails;
    }

    public void setVehicleDetails(List<VehicleDetail> vehicleDetails) {
        this.vehicleDetails.clear();
        this.vehicleDetails.addAll(vehicleDetails);
    }

    public ArrayList<Addresses> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(Addresses destinationAddresses) {
        this.destinationAddresses.add(destinationAddresses);
    }

    public ArrayList<Addresses> getPickupAddresses() {
        return pickupAddresses;
    }

    public void setPickupAddresses(Addresses pickupAddresses) {
        this.pickupAddresses.add(pickupAddresses);
    }

    public double getTotalCartAmount() {
        return totalCartAmount;
    }

    public void setTotalCartAmount(double totalCartAmount) {
        this.totalCartAmount = totalCartAmount;
    }

    public double getTotalCartAmountWithoutTax() {
        return totalCartAmountWithoutTax;
    }

    public void setTotalCartAmountWithoutTax(double totalCartAmountWithoutTax) {
        this.totalCartAmountWithoutTax = totalCartAmountWithoutTax;
    }

    public LatLng getStoreLatLng() {
        return storeLatLng;
    }

    public void setStoreLatLng(LatLng storeLatLng) {
        this.storeLatLng = storeLatLng;
    }

    public ArrayList<CartProducts> getCartProductList() {
        return cartProductList;
    }

    public void setCartProduct(CartProducts cartProducts) {
        this.cartProductList.add(cartProducts);
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getSelectedStoreId() {
        return selectedStoreId;
    }

    public void setSelectedStoreId(String selectedStoreId) {
        this.selectedStoreId = selectedStoreId;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public LatLng getDeliveryLatLng() {
        return deliveryLatLng;
    }

    public void setDeliveryLatLng(LatLng deliveryLatLng) {
        this.deliveryLatLng = deliveryLatLng;
    }

    public String getCurrentCity() {
        return currentCity;
    }

    public void setCurrentCity(String currentCity) {
        this.currentCity = currentCity;
    }

    public boolean isCashPaymentMode() {
        return isCashPaymentMode;
    }

    public void setCashPaymentMode(boolean cashPaymentMode) {
        isCashPaymentMode = cashPaymentMode;
    }

    public boolean isOtherPaymentMode() {
        return isOtherPaymentMode;
    }

    public void setOtherPaymentMode(boolean otherPaymentMode) {
        isOtherPaymentMode = otherPaymentMode;
    }

    public boolean isPromoApplyForCash() {
        return isPromoApplyForCash;
    }

    public void setPromoApplyForCash(boolean promoApplyForCash) {
        isPromoApplyForCash = promoApplyForCash;
    }

    public boolean isPromoApplyForOther() {
        return isPromoApplyForOther;
    }

    public void setPromoApplyForOther(boolean promoApplyForOther) {
        isPromoApplyForOther = promoApplyForOther;
    }

    public String getBookCityId() {
        return bookCityId;
    }

    public void setBookCityId(String bookCityId) {
        this.bookCityId = bookCityId;
    }

    public String getBookCountryId() {
        return bookCountryId;
    }

    public void setBookCountryId(String bookCountryId) {
        this.bookCountryId = bookCountryId;
    }

    public void clearCart() {
        cartProductList.clear();
        setTotalCartAmount(0);
        setTotalCartAmountWithoutTax(0);
        currencyCode = "";
        deliveryAddress = currentAddress;
        deliveryLatLng = currentLatLng;
        totalInvoiceAmount = 0.0;
        destinationAddresses.clear();
        pickupAddresses.clear();

    }

    public String getOrderPaymentId() {
        return orderPaymentId;
    }

    public void setOrderPaymentId(String orderPaymentId) {
        this.orderPaymentId = orderPaymentId;
    }

    public boolean isStoreClosed() {
        return isStoreClosed;
    }

    public void setStoreClosed(boolean storeClosed) {
        isStoreClosed = storeClosed;
    }

    public boolean isHaveOrders() {
        return isHaveOrders;
    }

    public void setHaveOrders(boolean haveOrders) {
        isHaveOrders = haveOrders;
    }

    public String getDeliveryCurrency() {
        return deliveryCurrency;
    }

    public void setDeliveryCurrency(String deliveryCurrency) {
        this.deliveryCurrency = deliveryCurrency;
    }

    public String getCurrentAddress() {
        return currentAddress;
    }

    public void setCurrentAddress(String currentAddress) {
        this.currentAddress = currentAddress;
    }

    public LatLng getCurrentLatLng() {
        return currentLatLng;
    }

    public void setCurrentLatLng(LatLng currentLatLng) {
        this.currentLatLng = currentLatLng;
    }

    public String getDeliveryNote() {
        return deliveryNote;
    }

    public void setDeliveryNote(String deliveryNote) {
        this.deliveryNote = deliveryNote;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getCountryCode() {
        return countryCode;
    }

    public void setCountryCode(String countryCode) {
        this.countryCode = countryCode;
    }

    public String getCity1() {
        return city1;
    }

    public void setCity1(String city1) {
        this.city1 = city1;
    }

    public String getCity2() {
        return city2;
    }

    public void setCity2(String city2) {
        this.city2 = city2;
    }

    public String getCity3() {
        return city3;
    }

    public void setCity3(String city3) {
        this.city3 = city3;
    }

    public double getPaymentLatitude() {
        return paymentLatitude;
    }

    public void setPaymentLatitude(double paymentLatitude) {
        this.paymentLatitude = paymentLatitude;
    }

    public double getPaymentLongitude() {
        return paymentLongitude;
    }

    public void setPaymentLongitude(double paymentLongitude) {
        this.paymentLongitude = paymentLongitude;
    }

    public String getCityCode() {
        return cityCode;
    }

    public void setCityCode(String cityCode) {
        this.cityCode = cityCode;
    }

    public String getCountryCode2() {
        return countryCode2;
    }

    public void setCountryCode2(String countryCode2) {
        this.countryCode2 = countryCode2;
    }

    public String getCurrencyCode() {
        return currencyCode;
    }

    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }

    public double getTotalInvoiceAmount() {
        return totalInvoiceAmount;
    }

    public void setTotalInvoiceAmount(double totalInvoiceAmount) {
        this.totalInvoiceAmount = totalInvoiceAmount;
    }

    public String getCartCityId() {
        return cartCityId;
    }

    public void setCartCityId(String cartCityId) {
        this.cartCityId = cartCityId;
    }

    public void clearCurrentBookingModel() {
        cartProductList.clear();
        bookCityId = "";
        bookCountryId = "";
        isCashPaymentMode = false;
        isOtherPaymentMode = false;
        isPromoApplyForCash = false;
        isPromoApplyForOther = false;
        currentCity = "";
        currency = "";
        selectedStoreId = "";
        deliveryAddress = "";
        deliveryLatLng = null;
        storeLatLng = null;
        totalCartAmount = 0.0;
        orderPaymentId = "";
        isStoreClosed = false;
        isHaveOrders = false;
        deliveryCurrency = "";
        deliveryNote = "";
        currentAddress = "";
        currentLatLng = null;
        country = "";
        countryCode = "";
        countryCode2 = "";
        city1 = "";
        city2 = "";
        city3 = "";
        cityCode = "";
        paymentLatitude = 0.0;
        paymentLongitude = 0.0;
        currencyCode = "";
        totalInvoiceAmount = 0.0;
        cartCityId = "";
        futureOrderDate = "";
        futureOrderTime = "";
        futureOrderSelectedTimeUTCMillis = 0;
        futureOrderSelectedTimeZoneMillis = 0;
        isFutureOrder = false;

    }

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;


    }

    public String getFutureOrderDate() {
        return futureOrderDate;
    }

    public void setFutureOrderDate(String futureOrderDate) {
        this.futureOrderDate = futureOrderDate;
    }

    public String getFutureOrderTime() {
        return futureOrderTime;
    }

    public void setFutureOrderTime(String futureOrderTime) {
        this.futureOrderTime = futureOrderTime;
    }

    public long getFutureOrderSelectedTimeZoneMillis() {
        return futureOrderSelectedTimeZoneMillis;
    }

    public void setFutureOrderSelectedTimeZoneMillis(long futureOrderSelectedTimeZoneMillis) {
        this.futureOrderSelectedTimeZoneMillis = futureOrderSelectedTimeZoneMillis;
    }

    public long getFutureOrderSelectedTimeUTCMillis() {
        return futureOrderSelectedTimeUTCMillis;
    }

    public void setFutureOrderSelectedTimeUTCMillis(long futureOrderSelectedTimeUTCMillis) {
        this.futureOrderSelectedTimeUTCMillis = futureOrderSelectedTimeUTCMillis;
    }

    public boolean isFutureOrder() {
        return isFutureOrder;
    }

    public void setFutureOrder(boolean futureOrder) {
        isFutureOrder = futureOrder;
    }

    public ArrayList<TaxesDetail> getStoreTaxesDetails() {
        return storeTaxesDetails;
    }

    public void setStoreTaxesDetails(ArrayList<TaxesDetail> storeTaxesDetails) {
        this.storeTaxesDetails = storeTaxesDetails;
    }
}
