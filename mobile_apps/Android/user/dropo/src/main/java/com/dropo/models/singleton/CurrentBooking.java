package com.dropo.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.Ads;
import com.dropo.models.datamodels.AppLanguage;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.Deliveries;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.TaxesDetail;
import com.dropo.utils.ScheduleHelper;
import com.google.android.gms.maps.model.LatLng;

import java.util.ArrayList;
import java.util.List;

/**
 * Please modify carefully because is effect in whole app
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
    private final ArrayList<Addresses> destinationAddresses;
    private final ArrayList<Addresses> pickupAddresses;
    private final ArrayList<ProductItem> cartProductItemWithAllSpecificationList;
    private final ArrayList<CartProducts> cartProductWithSelectedSpecificationList;
    private final ArrayList<Deliveries> deliveryStoreList;
    private final List<String> favourite;
    private List<Ads> ads;
    private String bookCityId;
    private String bookCountryId;
    private boolean isCashPaymentMode;
    private boolean isOtherPaymentMode;
    private boolean isPromoApply;
    private String currentCity;
    private String cartCurrency;
    private String currencyCode = "";
    private String selectedStoreId;
    private String deliveryAddress;
    private LatLng deliveryLatLng;
    private double totalCartAmount;
    private double totalCartAmountWithoutTax;
    private String orderPaymentId;
    private String cartId;
    private boolean isApplication = true;
    private boolean isStoreClosed;
    private boolean isHaveOrders;
    private String currency;
    private String currentAddress = "";
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
    private String timeZone;
    private String serverTime;
    private String storeIdBranchIO;
    private ArrayList<String> courierItems;
    private String selectedDeliveryId = "";
    private boolean isStoreCanCreateGroup;
    private List<AppLanguage> langs;
    private List<AppLanguage> storeLangs;
    private String selectedStoreLang = "0";
    private boolean isLanguageChanged = false;
    private boolean isAllowContactLessDelivery = false;
    private boolean isAdminAllowContactLessDelivery = false;
    private boolean isTaxIncluded = false;
    private boolean isUseItemTax = false;
    private boolean isBookTableForFuture = true;
    private ArrayList<TaxesDetail> taxesDetails;
    private String vehicleId;
    private ScheduleHelper scheduleHelper;
    private int numberOfPerson;
    private int tableNumber;
    private String tableId;
    private int tableBookingType;
    private int deliveryType;
    private double bookingFee;

    protected CurrentBooking(Parcel in) {
        destinationAddresses = in.createTypedArrayList(Addresses.CREATOR);
        pickupAddresses = in.createTypedArrayList(Addresses.CREATOR);
        cartProductItemWithAllSpecificationList = in.createTypedArrayList(ProductItem.CREATOR);
        cartProductWithSelectedSpecificationList = in.createTypedArrayList(CartProducts.CREATOR);
        deliveryStoreList = in.createTypedArrayList(Deliveries.CREATOR);
        favourite = in.createStringArrayList();
        bookCityId = in.readString();
        bookCountryId = in.readString();
        isCashPaymentMode = in.readByte() != 0;
        isOtherPaymentMode = in.readByte() != 0;
        isPromoApply = in.readByte() != 0;
        currentCity = in.readString();
        cartCurrency = in.readString();
        currencyCode = in.readString();
        selectedStoreId = in.readString();
        deliveryAddress = in.readString();
        deliveryLatLng = in.readParcelable(LatLng.class.getClassLoader());
        totalCartAmount = in.readDouble();
        totalCartAmountWithoutTax = in.readDouble();
        orderPaymentId = in.readString();
        cartId = in.readString();
        isApplication = in.readByte() != 0;
        isStoreClosed = in.readByte() != 0;
        isHaveOrders = in.readByte() != 0;
        currency = in.readString();
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
        timeZone = in.readString();
        serverTime = in.readString();
        storeIdBranchIO = in.readString();
        courierItems = in.createStringArrayList();
        selectedDeliveryId = in.readString();
        isStoreCanCreateGroup = in.readByte() != 0;
        langs = in.createTypedArrayList(AppLanguage.CREATOR);
        storeLangs = in.createTypedArrayList(AppLanguage.CREATOR);
        selectedStoreLang = in.readString();
        isLanguageChanged = in.readByte() != 0;
        isAllowContactLessDelivery = in.readByte() != 0;
        isAdminAllowContactLessDelivery = in.readByte() != 0;
        isTaxIncluded = in.readByte() != 0;
        isUseItemTax = in.readByte() != 0;
        vehicleId = in.readString();
        taxesDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
        numberOfPerson = in.readInt();
        tableNumber = in.readInt();
        tableBookingType = in.readInt();
        deliveryType = in.readInt();
        bookingFee = in.readDouble();
        isBookTableForFuture = in.readByte() != 0;
        tableId = in.readString();
    }

    private CurrentBooking() {
        cartProductItemWithAllSpecificationList = new ArrayList<>();
        cartProductWithSelectedSpecificationList = new ArrayList<>();
        deliveryStoreList = new ArrayList<>();
        ads = new ArrayList<>();
        favourite = new ArrayList<>();
        destinationAddresses = new ArrayList<>();
        pickupAddresses = new ArrayList<>();
        langs = new ArrayList<>();
        storeLangs = new ArrayList<>();
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
        dest.writeTypedList(destinationAddresses);
        dest.writeTypedList(pickupAddresses);
        dest.writeTypedList(cartProductItemWithAllSpecificationList);
        dest.writeTypedList(cartProductWithSelectedSpecificationList);
        dest.writeTypedList(deliveryStoreList);
        dest.writeStringList(favourite);
        dest.writeString(bookCityId);
        dest.writeString(bookCountryId);
        dest.writeByte((byte) (isCashPaymentMode ? 1 : 0));
        dest.writeByte((byte) (isOtherPaymentMode ? 1 : 0));
        dest.writeByte((byte) (isPromoApply ? 1 : 0));
        dest.writeString(currentCity);
        dest.writeString(cartCurrency);
        dest.writeString(currencyCode);
        dest.writeString(selectedStoreId);
        dest.writeString(deliveryAddress);
        dest.writeParcelable(deliveryLatLng, flags);
        dest.writeDouble(totalCartAmount);
        dest.writeDouble(totalCartAmountWithoutTax);
        dest.writeString(orderPaymentId);
        dest.writeString(cartId);
        dest.writeByte((byte) (isApplication ? 1 : 0));
        dest.writeByte((byte) (isStoreClosed ? 1 : 0));
        dest.writeByte((byte) (isHaveOrders ? 1 : 0));
        dest.writeString(currency);
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
        dest.writeString(timeZone);
        dest.writeString(serverTime);
        dest.writeString(storeIdBranchIO);
        dest.writeStringList(courierItems);
        dest.writeString(selectedDeliveryId);
        dest.writeByte((byte) (isStoreCanCreateGroup ? 1 : 0));
        dest.writeTypedList(langs);
        dest.writeTypedList(storeLangs);
        dest.writeString(selectedStoreLang);
        dest.writeByte((byte) (isLanguageChanged ? 1 : 0));
        dest.writeByte((byte) (isAllowContactLessDelivery ? 1 : 0));
        dest.writeByte((byte) (isAdminAllowContactLessDelivery ? 1 : 0));
        dest.writeByte((byte) (isTaxIncluded ? 1 : 0));
        dest.writeByte((byte) (isUseItemTax ? 1 : 0));
        dest.writeString(vehicleId);
        dest.writeTypedList(taxesDetails);
        dest.writeInt(numberOfPerson);
        dest.writeInt(tableNumber);
        dest.writeInt(tableBookingType);
        dest.writeInt(deliveryType);
        dest.writeDouble(bookingFee);
        dest.writeByte((byte) (isBookTableForFuture ? 1 : 0));
        dest.writeString(tableId);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public String getSelectedDeliveryId() {
        return selectedDeliveryId;
    }

    public void setSelectedDeliveryId(String selectedDeliveryId) {
        this.selectedDeliveryId = selectedDeliveryId;
    }

    public boolean isStoreCanCreateGroup() {
        return isStoreCanCreateGroup;
    }

    public void setStoreCanCreateGroup(boolean storeCanCreateGroup) {
        isStoreCanCreateGroup = storeCanCreateGroup;
    }

    public ScheduleHelper getSchedule() {
        return scheduleHelper;
    }

    public void setSchedule(ScheduleHelper scheduleHelper) {
        this.scheduleHelper = scheduleHelper;
    }

    public String getStoreIdBranchIO() {
        return storeIdBranchIO;
    }

    public void setStoreIdBranchIO(String storeIdBranchIO) {
        this.storeIdBranchIO = storeIdBranchIO;
    }

    public ArrayList<Addresses> getDestinationAddresses() {
        return destinationAddresses;
    }

    public void setDestinationAddresses(Addresses destinationAddresses) {
        this.destinationAddresses.clear();
        this.destinationAddresses.add(destinationAddresses);
    }

    public ArrayList<Addresses> getPickupAddresses() {
        return pickupAddresses;
    }

    public void setPickupAddresses(Addresses pickupAddresses) {
        this.pickupAddresses.add(pickupAddresses);
    }

    public List<String> getFavourite() {
        return favourite;
    }

    public void setFavourite(List<String> favourite) {
        this.favourite.addAll(favourite);
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

    public ArrayList<CartProducts> getCartProductWithSelectedSpecificationList() {
        return cartProductWithSelectedSpecificationList;
    }

    public void setCartProduct(CartProducts cartProducts) {
        this.cartProductWithSelectedSpecificationList.add(cartProducts);
    }

    public String getCartCurrency() {
        return cartCurrency;
    }

    public void setCartCurrency(String cartCurrency) {
        this.cartCurrency = cartCurrency;
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

    public ArrayList<Deliveries> getDeliveryStoreList() {
        return deliveryStoreList;
    }

    public void setDeliveryStoreList(ArrayList<Deliveries> deliveryStoreList) {
        if (deliveryStoreList != null) {
            this.deliveryStoreList.clear();
            this.deliveryStoreList.addAll(deliveryStoreList);
        }
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

    public boolean isPromoApply() {
        return isPromoApply;
    }

    public void setPromoApply(boolean promoApply) {
        isPromoApply = promoApply;
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
        cartProductItemWithAllSpecificationList.clear();
        cartProductWithSelectedSpecificationList.clear();
        storeLangs.clear();
        selectedStoreLang = "0";
        //destinationAddresses.clear();
        pickupAddresses.clear();
        setSelectedStoreId("");
        setTotalCartAmount(0);
        setTotalCartAmountWithoutTax(0);
        currencyCode = "";
        deliveryAddress = currentAddress;
        deliveryLatLng = currentLatLng;
        totalInvoiceAmount = 0.0;
        courierItems = null;
        selectedDeliveryId = "";
        isAllowContactLessDelivery = false;
        scheduleHelper = null;
    }

    public String getOrderPaymentId() {
        return orderPaymentId;
    }

    public void setOrderPaymentId(String orderPaymentId) {
        this.orderPaymentId = orderPaymentId;
    }

    public String getCartId() {
        return cartId;
    }

    public void setCartId(String cartId) {
        this.cartId = cartId;
    }

    public boolean isApplication() {
        return isApplication;
    }

    public void setApplication(boolean application) {
        isApplication = application;
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

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
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

    public ArrayList<ProductItem> getCartProductItemWithAllSpecificationList() {
        return cartProductItemWithAllSpecificationList;
    }

    public void setCartProductItemWithAllSpecificationList(ProductItem productItem) {
        this.cartProductItemWithAllSpecificationList.add(productItem);
    }

    public void clearCurrentBookingModel() {
        pickupAddresses.clear();
        destinationAddresses.clear();
        cartProductItemWithAllSpecificationList.clear();

        cartProductWithSelectedSpecificationList.clear();
        deliveryStoreList.clear();
        bookCityId = "";
        bookCountryId = "";
        isCashPaymentMode = false;
        isOtherPaymentMode = false;
        isPromoApply = false;
        currentCity = "";
        cartCurrency = "";
        selectedStoreId = "";
        deliveryAddress = "";
        deliveryLatLng = null;
        totalCartAmount = 0.0;
        orderPaymentId = "";
        cartId = "";
        isApplication = true;
        isStoreClosed = false;
        isHaveOrders = false;
        currency = "";
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
        if (ads != null) {
            ads.clear();
        }
        storeIdBranchIO = "";
        scheduleHelper = null;
        vehicleId = "";
        courierItems = null;
        selectedDeliveryId = "";
        isTaxIncluded = false;
        isUseItemTax = false;
        numberOfPerson = 0;
        tableNumber = 0;
        tableBookingType = 0;
        deliveryType = 0;
        bookingFee = 0.0;
        isBookTableForFuture = false;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public String getServerTime() {
        return serverTime;
    }

    public void setServerTime(String serverTime) {
        this.serverTime = serverTime;
    }

    public List<Ads> getAds() {
        if (ads == null) {
            ads = new ArrayList<>();
        }
        return ads;
    }

    public void setAds(List<Ads> ads) {
        if (this.ads != null) {
            this.ads.clear();
            this.ads.addAll(ads);
        }
    }

    public boolean isFutureOrder() {
        return scheduleHelper != null;
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(String vehicleId) {
        this.vehicleId = vehicleId;
    }

    public ArrayList<String> getCourierItems() {
        return courierItems;
    }

    public void setCourierItems(ArrayList<String> courierItems) {
        this.courierItems = courierItems;
    }

    public List<AppLanguage> getLangs() {
        return langs;
    }

    public void setLangs(List<AppLanguage> langs) {
        this.langs = langs;
    }

    public String getSelectedStoreLang() {
        return selectedStoreLang;
    }

    public void setSelectedStoreLang(String selectedStoreLang) {
        this.selectedStoreLang = selectedStoreLang;
    }

    public List<AppLanguage> getStoreLangs() {
        return storeLangs;
    }

    public void setStoreLangs(List<AppLanguage> storeLangs) {
        this.storeLangs = storeLangs;
    }

    public boolean isLanguageChanged() {
        return isLanguageChanged;
    }

    public void setLanguageChanged(boolean languageChanged) {
        isLanguageChanged = languageChanged;
    }

    public boolean isAllowContactLessDelivery() {
        return isAllowContactLessDelivery;
    }

    public void setAllowContactLessDelivery(boolean allowContactLessDelivery) {
        isAllowContactLessDelivery = allowContactLessDelivery;
    }

    public boolean isAdminAllowContactLessDelivery() {
        return isAdminAllowContactLessDelivery;
    }

    public void setAdminAllowContactLessDelivery(boolean adminAllowContactLessDelivery) {
        isAdminAllowContactLessDelivery = adminAllowContactLessDelivery;
    }

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public boolean isUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(boolean useItemTax) {
        isUseItemTax = useItemTax;
    }

    public ArrayList<TaxesDetail> getTaxesDetails() {
        return taxesDetails;
    }

    public void setTaxesDetails(ArrayList<TaxesDetail> taxesDetails) {
        this.taxesDetails = taxesDetails;
    }

    public int getNumberOfPerson() {
        return numberOfPerson;
    }

    public void setNumberOfPerson(int numberOfPerson) {
        this.numberOfPerson = numberOfPerson;
    }

    public int getTableNumber() {
        return tableNumber;
    }

    public void setTableNumber(int tableNumber) {
        this.tableNumber = tableNumber;
    }

    public int getTableBookingType() {
        return tableBookingType;
    }

    public void setTableBookingType(int tableBookingType) {
        this.tableBookingType = tableBookingType;
    }

    public int getDeliveryType() {
        return deliveryType;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    public double getBookingFee() {
        return bookingFee;
    }

    public void setBookingFee(double bookingFee) {
        this.bookingFee = bookingFee;
    }

    public boolean isTableBooking() {
        return tableBookingType != 0 && tableNumber != 0 && numberOfPerson != 0 && deliveryType != 0;
    }

    public boolean isBookTableForFuture() {
        return isBookTableForFuture;
    }

    public void setBookTableForFuture(boolean bookTableForFuture) {
        isBookTableForFuture = bookTableForFuture;
    }

    public String getTableId() {
        return tableId;
    }

    public void setTableId(String tableId) {
        this.tableId = tableId;
    }
}
