package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class Store implements Parcelable {

    public static final Creator<Store> CREATOR = new Creator<Store>() {
        @Override
        public Store createFromParcel(Parcel source) {
            return new Store(source);
        }

        @Override
        public Store[] newArray(int size) {
            return new Store[size];
        }
    };

    @SerializedName("is_use_item_tax")
    @Expose
    private boolean isUseItemTax;

    @SerializedName("is_tax_included")
    private boolean isTaxIncluded;

    @SerializedName("is_provide_pickup_delivery")
    @Expose
    private boolean isProvidePickupDelivery;

    @SerializedName("is_provide_delivery")
    @Expose
    private boolean isProvideDelivery;

    @SerializedName("delivery_radius")
    private double deliveryRadius;
    @SerializedName("is_provide_delivery_anywhere")
    private boolean isProvideDeliveryAnywhere;
    @SerializedName("delivery_time_max")
    @Expose
    private int deliveryTimeMax;
    @SerializedName("is_taking_schedule_order")
    @Expose
    private boolean isTakingScheduleOrder;
    @SerializedName("is_order_cancellation_charge_apply")
    @Expose
    private boolean isOrderCancellationChargeApply;
    @SerializedName("is_store_pay_delivery_fees")
    @Expose
    private boolean isStorePayDeliveryFees;
    @SerializedName("items")
    @Expose
    private List<String> productItemNameList;
    @SerializedName("city_detail")
    @Expose
    private City cityDetail;
    @SerializedName("is_store_busy")
    @Expose
    private boolean isBusy;

    private String tags;
    private String priceRattingTag;
    private double distance;
    private boolean isStoreClosed;

    @SerializedName("country_detail")
    @Expose
    private Countries countries;
    @SerializedName("famous_products_tag_ids")
    @Expose
    private ArrayList<String> famousProductsTagIds = new ArrayList<>();
    @SerializedName("famous_products_tags")
    @Expose
    private ArrayList<FamousProductsTags> famousProductsTags = new ArrayList<>();

    private boolean isFavouriteRemove;
    private boolean isFavourite;

    @SerializedName("currency")
    @Expose
    private String currency;
    @SerializedName("delivery_time")
    @Expose
    private int deliveryTime;
    @SerializedName("price_rating")
    @Expose
    private int priceRating;
    @SerializedName("country_phone_code")
    @Expose
    private String countryPhoneCode;
    @SerializedName("user_rate")
    @Expose
    private double rate;
    @SerializedName("store_time")
    @Expose
    private List<StoreTime> storeTime;
    @SerializedName("store_delivery_time")
    @Expose
    private List<StoreTime> storeDeliveryTime;
    @SerializedName("email")
    @Expose
    private String email;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("image_url")
    @Expose
    private String imageUrl;
    @SerializedName("server_token")
    @Expose
    private String serverToken;
    @SerializedName("fax_number")
    @Expose
    private String faxNumber;
    @SerializedName("user_rate_count")
    @Expose
    private int rateCount;
    @SerializedName("website_url")
    @Expose
    private String websiteUrl;
    @SerializedName("phone")
    @Expose
    private String phone;
    @SerializedName("referral_code")
    @Expose
    private String referralCode;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("location")
    @Expose
    private List<Double> location;
    @SerializedName("_id")
    @Expose
    private String id;
    @SerializedName("slogan")
    @Expose
    private String slogan;
    private String reOpenTime;
    @SerializedName("languages_supported")
    @Expose
    private List<AppLanguage> lang;
    @SerializedName("store_delivery_type_id")
    @Expose
    private String storeDeliveryTypeId;
    @SerializedName("is_store_can_create_group")
    @Expose
    private boolean isStoreCanCreateGroup;
    @SerializedName("order_cancellation_charge_type")
    @Expose
    private int orderCancellationChargeType;
    @SerializedName("order_cancellation_charge_value")
    @Expose
    private double orderCancellationChargeValue;
    @SerializedName("order_cancellation_charge_for_above_order_price")
    @Expose
    private double orderCancellationChargeForAboveOrderPrice;
    @SerializedName("schedule_order_create_after_minute")
    @Expose
    private int scheduleOrderCreateAfterMinute;
    @SerializedName("tax_details")
    private ArrayList<TaxesDetail> taxDetails;
    @SerializedName("store_tax_details")
    private ArrayList<TaxesDetail> storeTaxDetails;
    @SerializedName("is_table_reservation_with_order")
    @Expose
    private boolean isTableReservationWithOrder;
    @SerializedName("is_table_reservation")
    @Expose
    private boolean isTableReservation;
    @SerializedName("is_provide_table_booking")
    @Expose
    private boolean isProvideTableBooking;
    @SerializedName("is_approved")
    @Expose
    private boolean isApproved;
    @SerializedName("is_business")
    @Expose
    private boolean isBusiness;
    @SerializedName("is_country_business")
    @Expose
    private boolean isCountryBusiness;
    @SerializedName("is_city_business")
    @Expose
    private boolean isCityBusiness;
    @SerializedName("is_delivery_business")
    @Expose
    private boolean isDeliveryBusiness;

    public Store() {
    }

    protected Store(Parcel in) {
        this.isUseItemTax = in.readByte() != 0;
        this.isTaxIncluded = in.readByte() != 0;
        this.isProvidePickupDelivery = in.readByte() != 0;
        this.isProvideDelivery = in.readByte() != 0;
        this.deliveryRadius = in.readDouble();
        this.isProvideDeliveryAnywhere = in.readByte() != 0;
        this.deliveryTimeMax = in.readInt();
        this.isTakingScheduleOrder = in.readByte() != 0;
        this.isOrderCancellationChargeApply = in.readByte() != 0;
        this.isStorePayDeliveryFees = in.readByte() != 0;
        this.productItemNameList = in.createStringArrayList();
        this.cityDetail = in.readParcelable(City.class.getClassLoader());
        this.isBusy = in.readByte() != 0;
        this.tags = in.readString();
        this.priceRattingTag = in.readString();
        this.distance = in.readDouble();
        this.isStoreClosed = in.readByte() != 0;
        this.countries = in.readParcelable(Countries.class.getClassLoader());
        this.famousProductsTagIds = in.createStringArrayList();
        this.famousProductsTags = in.createTypedArrayList(FamousProductsTags.CREATOR);
        this.isFavouriteRemove = in.readByte() != 0;
        this.isFavourite = in.readByte() != 0;
        this.currency = in.readString();
        this.deliveryTime = in.readInt();
        this.priceRating = in.readInt();
        this.countryPhoneCode = in.readString();
        this.rate = in.readDouble();
        this.storeTime = in.createTypedArrayList(StoreTime.CREATOR);
        this.email = in.readString();
        this.address = in.readString();
        this.imageUrl = in.readString();
        this.serverToken = in.readString();
        this.faxNumber = in.readString();
        this.rateCount = in.readInt();
        this.websiteUrl = in.readString();
        this.phone = in.readString();
        this.referralCode = in.readString();
        this.name = in.readString();
        this.location = new ArrayList<Double>();
        in.readList(this.location, Double.class.getClassLoader());
        this.id = in.readString();
        this.slogan = in.readString();
        this.reOpenTime = in.readString();
        this.lang = in.createTypedArrayList(AppLanguage.CREATOR);
        this.storeDeliveryTypeId = in.readString();
        this.isStoreCanCreateGroup = in.readByte() != 0;
        this.taxDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
        this.storeTaxDetails = in.createTypedArrayList(TaxesDetail.CREATOR);
        this.orderCancellationChargeType = in.readInt();
        this.orderCancellationChargeValue = in.readDouble();
        this.orderCancellationChargeForAboveOrderPrice = in.readDouble();
        this.isTableReservationWithOrder = in.readByte() != 0;
        this.isTableReservation = in.readByte() != 0;
        this.scheduleOrderCreateAfterMinute = in.readInt();
        this.isProvideTableBooking = in.readByte() != 0;

    }

    public int getScheduleOrderCreateAfterMinute() {
        return scheduleOrderCreateAfterMinute;
    }

    public boolean isUseItemTax() {
        return isUseItemTax;
    }

    public void setUseItemTax(boolean useItemTax) {
        isUseItemTax = useItemTax;
    }


    public boolean isProvidePickupDelivery() {
        return isProvidePickupDelivery;
    }

    public void setProvidePickupDelivery(boolean providePickupDelivery) {
        isProvidePickupDelivery = providePickupDelivery;
    }

    public boolean isProvideDelivery() {
        return isProvideDelivery;
    }

    public void setProvideDelivery(boolean provideDelivery) {
        isProvideDelivery = provideDelivery;
    }

    public double getDeliveryRadius() {
        return deliveryRadius;
    }

    public void setDeliveryRadius(double deliveryRadius) {
        this.deliveryRadius = deliveryRadius;
    }

    public boolean isProvideDeliveryAnywhere() {
        return isProvideDeliveryAnywhere;
    }

    public void setProvideDeliveryAnywhere(boolean provideDeliveryAnywhere) {
        isProvideDeliveryAnywhere = provideDeliveryAnywhere;
    }

    public int getDeliveryTimeMax() {
        return deliveryTimeMax;
    }

    public void setDeliveryTimeMax(int deliveryTimeMax) {
        this.deliveryTimeMax = deliveryTimeMax;
    }

    public boolean isTakingScheduleOrder() {
        return isTakingScheduleOrder;
    }

    public void setTakingScheduleOrder(boolean takingScheduleOrder) {
        isTakingScheduleOrder = takingScheduleOrder;
    }

    public boolean isOrderCancellationChargeApply() {
        return isOrderCancellationChargeApply;
    }

    public void setOrderCancellationChargeApply(boolean orderCancellationChargeApply) {
        isOrderCancellationChargeApply = orderCancellationChargeApply;
    }

    public boolean isStorePayDeliveryFees() {
        return isStorePayDeliveryFees;
    }

    public void setStorePayDeliveryFees(boolean storePayDeliveryFees) {
        isStorePayDeliveryFees = storePayDeliveryFees;
    }

    public List<String> getProductItemNameList() {
        return productItemNameList;
    }

    public void setProductItemNameList(List<String> productItemNameList) {
        this.productItemNameList = productItemNameList;
    }

    public City getCityDetail() {
        return cityDetail;
    }

    public void setCityDetail(City cityDetail) {
        this.cityDetail = cityDetail;
    }

    public boolean isBusy() {
        return isBusy;
    }

    public void setBusy(boolean busy) {
        isBusy = busy;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public double getDistance() {
        return distance;
    }

    public void setDistance(double distance) {
        this.distance = distance;
    }

    public Countries getCountries() {
        return countries;
    }

    public void setCountries(Countries countries) {
        this.countries = countries;
    }

    public ArrayList<String> getFamousProductsTagIds() {
        return famousProductsTagIds;
    }

    public void setFamousProductsTagIds(ArrayList<String> famousProductsTagIds) {
        this.famousProductsTagIds = famousProductsTagIds;
    }

    public ArrayList<FamousProductsTags> getFamousProductsTags() {
        return famousProductsTags;
    }

    public void setFamousProductsTags(ArrayList<FamousProductsTags> famousProductsTags) {
        this.famousProductsTags = famousProductsTags;
    }

    public boolean isFavouriteRemove() {
        return isFavouriteRemove;
    }

    public void setFavouriteRemove(boolean favouriteRemove) {
        isFavouriteRemove = favouriteRemove;
    }

    public int getPriceRating() {
        return priceRating;
    }

    public void setPriceRating(int priceRating) {
        this.priceRating = priceRating;
    }

    public String getCountryPhoneCode() {
        return countryPhoneCode;
    }

    public void setCountryPhoneCode(String countryPhoneCode) {
        this.countryPhoneCode = countryPhoneCode;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public List<StoreTime> getStoreTime() {
        return storeTime;
    }

    public void setStoreTime(List<StoreTime> storeTime) {
        this.storeTime = storeTime;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isStoreClosed() {
        return isStoreClosed;
    }

    public void setStoreClosed(boolean storeClosed) {
        isStoreClosed = storeClosed;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getServerToken() {
        return serverToken;
    }

    public void setServerToken(String serverToken) {
        this.serverToken = serverToken;
    }

    public String getFaxNumber() {
        return faxNumber;
    }

    public void setFaxNumber(String faxNumber) {
        this.faxNumber = faxNumber;
    }

    public int getRateCount() {
        return rateCount;
    }

    public void setRateCount(int rateCount) {
        this.rateCount = rateCount;
    }

    public String getWebsiteUrl() {
        return websiteUrl;
    }

    public void setWebsiteUrl(String websiteUrl) {
        this.websiteUrl = websiteUrl;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getReferralCode() {
        return referralCode;
    }

    public void setReferralCode(String referralCode) {
        this.referralCode = referralCode;
    }

    public String getName() {
        return name;

    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Double> getLocation() {
        return location;
    }

    public void setLocation(List<Double> location) {
        this.location = location;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getSlogan() {
        return slogan;
    }

    public void setSlogan(String slogan) {
        this.slogan = slogan;
    }

    public int getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getReOpenTime() {
        return reOpenTime;
    }

    public void setReOpenTime(String reOpenTime) {
        this.reOpenTime = reOpenTime;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public boolean isFavourite() {
        return isFavourite;
    }

    public void setFavourite(boolean favourite) {
        isFavourite = favourite;
    }

    public List<AppLanguage> getLang() {
        return lang;
    }

    public void setLang(List<AppLanguage> lang) {
        this.lang = lang;
    }

    public String getStoreDeliveryTypeId() {
        return storeDeliveryTypeId;
    }

    public void setStoreDeliveryTypeId(String storeDeliveryTypeId) {
        this.storeDeliveryTypeId = storeDeliveryTypeId;
    }

    public boolean isStoreCanCreateGroup() {
        return isStoreCanCreateGroup;
    }

    public void setStoreCanCreateGroup(boolean storeCanCreateGroup) {
        isStoreCanCreateGroup = storeCanCreateGroup;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte(this.isUseItemTax ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isTaxIncluded ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isProvidePickupDelivery ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isProvideDelivery ? (byte) 1 : (byte) 0);
        dest.writeDouble(this.deliveryRadius);
        dest.writeByte(this.isProvideDeliveryAnywhere ? (byte) 1 : (byte) 0);
        dest.writeInt(this.deliveryTimeMax);
        dest.writeByte(this.isTakingScheduleOrder ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isOrderCancellationChargeApply ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isStorePayDeliveryFees ? (byte) 1 : (byte) 0);
        dest.writeStringList(this.productItemNameList);
        dest.writeParcelable(this.cityDetail, flags);
        dest.writeByte(this.isBusy ? (byte) 1 : (byte) 0);
        dest.writeString(this.tags);
        dest.writeString(this.priceRattingTag);
        dest.writeDouble(this.distance);
        dest.writeByte(this.isStoreClosed ? (byte) 1 : (byte) 0);
        dest.writeParcelable(this.countries, flags);
        dest.writeStringList(this.famousProductsTagIds);
        dest.writeTypedList(this.famousProductsTags);
        dest.writeByte(this.isFavouriteRemove ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isFavourite ? (byte) 1 : (byte) 0);
        dest.writeString(this.currency);
        dest.writeInt(this.deliveryTime);
        dest.writeInt(this.priceRating);
        dest.writeString(this.countryPhoneCode);
        dest.writeDouble(this.rate);
        dest.writeTypedList(this.storeTime);
        dest.writeString(this.email);
        dest.writeString(this.address);
        dest.writeString(this.imageUrl);
        dest.writeString(this.serverToken);
        dest.writeString(this.faxNumber);
        dest.writeInt(this.rateCount);
        dest.writeString(this.websiteUrl);
        dest.writeString(this.phone);
        dest.writeString(this.referralCode);
        dest.writeString(this.name);
        dest.writeList(this.location);
        dest.writeString(this.id);
        dest.writeString(this.slogan);
        dest.writeString(this.reOpenTime);
        dest.writeTypedList(this.lang);
        dest.writeString(this.storeDeliveryTypeId);
        dest.writeByte(this.isStoreCanCreateGroup ? (byte) 1 : (byte) 0);
        dest.writeTypedList(taxDetails);
        dest.writeTypedList(storeTaxDetails);
        dest.writeInt(orderCancellationChargeType);
        dest.writeDouble(orderCancellationChargeValue);
        dest.writeDouble(orderCancellationChargeForAboveOrderPrice);
        dest.writeByte(this.isTableReservationWithOrder ? (byte) 1 : (byte) 0);
        dest.writeByte(this.isTableReservation ? (byte) 1 : (byte) 0);
        dest.writeInt(this.scheduleOrderCreateAfterMinute);
        dest.writeByte((byte) (this.isProvideTableBooking ? 1 : 0));
    }

    public List<StoreTime> getStoreDeliveryTime() {
        return storeDeliveryTime;
    }


    public String getPriceRattingTag() {
        return priceRattingTag;
    }

    public void setPriceRattingTag(String priceRattingTag) {
        this.priceRattingTag = priceRattingTag;
    }

    public boolean isTaxIncluded() {
        return isTaxIncluded;
    }

    public void setTaxIncluded(boolean taxIncluded) {
        isTaxIncluded = taxIncluded;
    }

    public double getTotalTaxes() {
        if (taxDetails != null && !taxDetails.isEmpty()) {
            double tax = 0;
            for (TaxesDetail taxesDetail : taxDetails) {
                tax += taxesDetail.getTax();
            }
            return tax;
        } else {
            return 0.0;
        }
    }

    public ArrayList<TaxesDetail> getTaxDetails() {
        return taxDetails;
    }

    public void setTaxDetails(ArrayList<TaxesDetail> taxDetails) {
        this.taxDetails = taxDetails;
    }

    public ArrayList<TaxesDetail> getStoreTaxDetails() {
        return storeTaxDetails;
    }

    public void setStoreTaxDetails(ArrayList<TaxesDetail> storeTaxDetails) {
        this.storeTaxDetails = storeTaxDetails;
    }

    public int getOrderCancellationChargeType() {
        return orderCancellationChargeType;
    }

    public double getOrderCancellationChargeValue() {
        return orderCancellationChargeValue;
    }

    public double getOrderCancellationChargeForAboveOrderPrice() {
        return orderCancellationChargeForAboveOrderPrice;
    }

    public boolean isTableReservationWithOrder() {
        return isTableReservationWithOrder;
    }

    public boolean isTableReservation() {
        return isTableReservation;
    }

    public boolean isProvideTableBooking() {
        return isProvideTableBooking;
    }

    public void setProvideTableBooking(boolean provideTableBooking) {
        isProvideTableBooking = provideTableBooking;
    }

    public boolean isApproved() {
        return isApproved;
    }

    public void setApproved(boolean approved) {
        isApproved = approved;
    }

    public boolean isBusiness() {
        return isBusiness;
    }

    public void setBusiness(boolean business) {
        isBusiness = business;
    }

    public boolean isCountryBusiness() {
        return isCountryBusiness;
    }

    public void setCountryBusiness(boolean countryBusiness) {
        isCountryBusiness = countryBusiness;
    }

    public boolean isCityBusiness() {
        return isCityBusiness;
    }

    public void setCityBusiness(boolean cityBusiness) {
        isCityBusiness = cityBusiness;
    }

    public boolean isDeliveryBusiness() {
        return isDeliveryBusiness;
    }

    public void setDeliveryBusiness(boolean deliveryBusiness) {
        isDeliveryBusiness = deliveryBusiness;
    }
}