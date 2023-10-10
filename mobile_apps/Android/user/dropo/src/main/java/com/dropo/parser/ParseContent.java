package com.dropo.parser;

import android.content.Context;
import android.location.Location;
import android.text.TextUtils;

import com.dropo.user.R;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.City;
import com.dropo.models.datamodels.Country;
import com.dropo.models.datamodels.Deliveries;
import com.dropo.models.datamodels.Invoice;
import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.datamodels.TaxesDetail;
import com.dropo.models.datamodels.User;
import com.dropo.models.responsemodels.AppSettingDetailResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.DeliveryStoreResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.ScheduleHelper;
import com.dropo.utils.Utils;
import com.google.android.gms.maps.model.LatLng;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import okhttp3.ResponseBody;
import retrofit2.Response;

public class ParseContent {
    private static final String TAG = "ParseContent";
    private static final ParseContent parseContent = new ParseContent();
    public SimpleDateFormat webFormat;
    public SimpleDateFormat timeFormat, timeFormat2;
    public SimpleDateFormat dateFormat, dateFormat2, dateFormat3, dateTimeFormat_am;
    public SimpleDateFormat dateFormatMonth;
    public SimpleDateFormat day, dateTimeFormat, timeFormat_am;
    public DecimalFormat decimalTwoDigitFormat;
    private PreferenceHelper preferenceHelper;
    private Context context;

    private ParseContent() {
        webFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT_WEB, Locale.US);
        webFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        dateFormat = new SimpleDateFormat(Const.DATE_FORMAT, Locale.US);
        timeFormat = new SimpleDateFormat(Const.TIME_FORMAT, Locale.US);
        dateFormatMonth = new SimpleDateFormat(Const.DATE_FORMAT_MONTH, Locale.US);
        dateTimeFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT, Locale.US);
        day = new SimpleDateFormat(Const.DAY, Locale.US);
        timeFormat_am = new SimpleDateFormat(Const.TIME_FORMAT_AM, Locale.US);
        dateFormat2 = new SimpleDateFormat(Const.DATE_FORMAT_2, Locale.US);
        dateFormat3 = new SimpleDateFormat(Const.DATE_FORMAT_3, Locale.US);
        timeFormat2 = new SimpleDateFormat(Const.TIME_FORMAT_2, Locale.US);
        DecimalFormatSymbols decimalFormatSymbols = new DecimalFormatSymbols(Locale.US);
        decimalTwoDigitFormat = new DecimalFormat("0.00", decimalFormatSymbols);
        dateTimeFormat_am = new SimpleDateFormat(Const.DATE_TIME_FORMAT_AM, Locale.US);

    }

    public static ParseContent getInstance() {
        return parseContent;
    }

    public void setContext(Context context) {
        preferenceHelper = PreferenceHelper.getInstance(context);
        this.context = context;
    }

    public boolean parseUserStorageData(Response<UserDataResponse> response) {
        if (isSuccessful(response)) {
            Utils.hideCustomProgressDialog();
            if (response.body().isSuccess()) {
                User user = response.body().getUser();
                preferenceHelper.putUserId(user.getId());
                preferenceHelper.putSessionToken(user.getServerToken());
                ApiClient.setLoginDetail(user.getId(), user.getServerToken());
                preferenceHelper.putFirstName(user.getFirstName());
                preferenceHelper.putLastName(user.getLastName());
                preferenceHelper.putAddress(user.getAddress());
                preferenceHelper.putZipCode(user.getZipcode());
                preferenceHelper.putPhoneNumber(user.getPhone());
                preferenceHelper.putCountryPhoneCode(user.getCountryPhoneCode());
                preferenceHelper.putEmail(user.getEmail());
                preferenceHelper.putProfilePic(user.getImageUrl());
                preferenceHelper.putReferral(user.getReferralCode());
                preferenceHelper.putIsPhoneNumberVerified(user.isIsPhoneNumberVerified());
                preferenceHelper.putIsEmailVerified(user.isIsEmailVerified());
                preferenceHelper.putIsUserAllDocumentsUpload(user.isIsDocumentUploaded());
                preferenceHelper.putIsApproved(user.isIsApproved());
                preferenceHelper.putIsPhoneNumberVerified(user.isIsPhoneNumberVerified());
                preferenceHelper.putIsEmailVerified(user.isIsEmailVerified());
                preferenceHelper.putCountryId(user.getCountryId());
                preferenceHelper.putWalletAmount((float) user.getWallet());
                preferenceHelper.putCountryCode(user.getCountryCode());
                preferenceHelper.putFirebaseUserToken(response.body().getFirebaseToken());
                if (user.getSocialId() != null && !user.getSocialId().isEmpty()) {
                    preferenceHelper.putSocialId(user.getSocialId().get(0));
                } else {
                    preferenceHelper.putSocialId("");
                }
                if (user.getOrders() != null) {
                    CurrentBooking.getInstance().setHaveOrders(user.getOrders().isEmpty());
                } else {
                    CurrentBooking.getInstance().setHaveOrders(false);
                }

                CurrentBooking.getInstance().getFavourite().clear();
                CurrentBooking.getInstance().setFavourite(user.getFavouriteStores());
                FirebaseMessaging.getInstance().subscribeToTopic(preferenceHelper.getUserId());
                preferenceHelper.putCountryCodeISO2(getCountryCodeISO2(preferenceHelper.getCountryPhoneCode()));
                return true;
            } else {

                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
            }
        }
        return false;
    }

    public ArrayList<Invoice> parseInvoice(OrderPayment orderPayment, String currency, boolean isShowPromo) {
        CurrentBooking.getInstance().setOrderPaymentId(orderPayment.getId());
        String unit = orderPayment.isDistanceUnitMile() ? context.getResources().getString(R.string.unit_mile) : context.getResources().getString(R.string.unit_km);

        ArrayList<Invoice> invoices = new ArrayList<>();

        if (orderPayment.getTotalBasePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_base_price), orderPayment.getTotalBasePrice(), currency, orderPayment.getBasePrice(), currency, orderPayment.getBasePriceDistance(), unit));
        }

        if (orderPayment.getDistancePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_distance_price), orderPayment.getDistancePrice(), currency, orderPayment.getPricePerUnitDistance(), currency, 0.0, unit));
        }

        if (orderPayment.getTotalTimePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_time_price), orderPayment.getTotalTimePrice(), currency, orderPayment.getPricePerUnitTime(), currency, 0.0, context.getResources().getString(R.string.unit_mins)));
        }
        if (orderPayment.getTotalServicePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_service_price), orderPayment.getTotalServicePrice(), currency, 0.0, "", 0.0, ""));
        }
        if (orderPayment.getAdditionalStopPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_additional_stop_price), orderPayment.getAdditionalStopPrice(), currency, 0.0, "", 0.0, ""));
        }

        if (orderPayment.getTotalRoundTripCharge() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_round_trip_charge), orderPayment.getTotalRoundTripCharge(), currency, 0.0, orderPayment.getRoundTripCharge() + "%", 0.0, ""));
        }
        if (CurrentBooking.getInstance().getDeliveryType() == Const.DeliveryType.COURIER) {
            if (orderPayment.getTotalOrderPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_additional_service_price), orderPayment.getTotalOrderPrice(), currency, 0.0, "", 0.0, ""));
            }
        }
        if (orderPayment.getTotalWaitingTimePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_waiting_time_charge), orderPayment.getTotalWaitingTimePrice(), currency, 0.0, "(" + (int) orderPayment.getTotalWaitingTime() + " " + context.getResources().getString(R.string.unit_min) + ")", 0.0, ""));
        }

        if (orderPayment.getTotalAdminTaxPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_service_tax), orderPayment.getTotalAdminTaxPrice(), currency, 0.0, orderPayment.getServiceTax() + "%", 0.0, ""));
        }
        if (orderPayment.getTotalSurgePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_surge_price), orderPayment.getTotalSurgePrice(), currency, orderPayment.getSurgeMultiplier(), "x", 0.0, ""));
        }

        if (CurrentBooking.getInstance().getDeliveryType() != Const.DeliveryType.COURIER) {
            if (orderPayment.getTotalDeliveryPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_service_cost), orderPayment.getTotalDeliveryPrice(), currency, 0.0, "", 0.0, ""));
            }
            if (orderPayment.getTotalCartPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_item_price), orderPayment.getTotalCartPrice(), currency, 0.0, orderPayment.getTotalItem() + "" + " " + "" + context.getResources().getString(R.string.text_items), 0.0, ""));
            }
        }
        if (orderPayment.getBookingFees() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_booking_fees), orderPayment.getBookingFees(), currency, 0.0, "", 0.0, ""));
        }

        if (orderPayment.getTotalStoreTaxPrice() > 0) {
            ArrayList<String> taxesSubtext = new ArrayList<>();
            for (TaxesDetail detail : orderPayment.getTaxes()) {
                taxesSubtext.add(Utils.getDetailStringFromList(detail.getTaxName(), PreferenceHelper.getInstance(context).getLanguageIndex()) + " " + detail.getTax() + "%");
            }
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_tax), orderPayment.getTotalStoreTaxPrice(), currency, 0.0, "(" + TextUtils.join(",", taxesSubtext) + ") " + (orderPayment.isTaxIncluded() ? "Inc" : "Exc"), 0.0, ""));
        }
        if (CurrentBooking.getInstance().getDeliveryType() != Const.DeliveryType.COURIER) {
            if (orderPayment.getTotalOrderPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_item_cost), orderPayment.getTotalOrderPrice(), currency, 0.0, "", 0.0, ""));
            }
        }

        if (orderPayment.getTipAmount() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_tip_amount), orderPayment.getTipAmount(), currency, 0.0, "", 0.0, ""));
        }

        if (orderPayment.getPromoPayment() > 0 && isShowPromo) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_promo), orderPayment.getPromoPayment(), currency, 0.0, "", 0.0, ""));
        }

        return invoices;
    }

    /***
     *
     * @param title main title for show in invoice
     * @param mainPrice main price for show in invoice
     * @param currency currency append with main price
     * @param subPrice subPrice is price which is apply particular distance or time or other
     *                 things
     * @param subText subTex is append ahead with subPrice
     * @param unitValue unitValue is value to decide distance or time
     * @param unit unit km/mile
     */
    private Invoice loadInvoiceData(String title, double mainPrice, String currency, double subPrice, String subText, double unitValue, String unit) {

        Invoice invoice = new Invoice();
        invoice.setPrice(currency + decimalTwoDigitFormat.format(mainPrice));
        invoice.setSubTitle(appendString(subText, subPrice, unitValue, unit));
        invoice.setTitle(title);
        return invoice;
    }

    private String appendString(String text, Double price, Double value, String unit) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(text);
        if (price > 0) {
            stringBuilder.append(decimalTwoDigitFormat.format(price));
        }
        if (!TextUtils.isEmpty(unit)) {
            stringBuilder.append("/");
            if (value > 1.0) {
                stringBuilder.append(decimalTwoDigitFormat.format(value));
            }
            stringBuilder.append(unit);
        }
        return stringBuilder.toString();
    }

    public boolean parseDeliveryStore(Response<DeliveryStoreResponse> response) {
        if (isSuccessful(response)) {
            if (response.body().isSuccess()) {
                CurrentBooking currentBooking = CurrentBooking.getInstance();
                currentBooking.getDeliveryStoreList().clear();
                City deliveryCity = response.body().getCity();
                currentBooking.setBookCityId(deliveryCity.getId());
                currentBooking.setBookCountryId(deliveryCity.getCountryId());
                currentBooking.setCashPaymentMode(deliveryCity.isIsCashPaymentMode());
                currentBooking.setOtherPaymentMode(deliveryCity.isIsOtherPaymentMode());
                currentBooking.setCurrentCity(deliveryCity.getCityName());
                currentBooking.setDeliveryStoreList((ArrayList<Deliveries>) response.body().getDeliveries());
                currentBooking.setCurrency(response.body().getCurrencySign());
                currentBooking.setCity1(response.body().getCityData().getCity1());
                currentBooking.setCity2(response.body().getCityData().getCity2());
                currentBooking.setCity3(response.body().getCityData().getCity3());
                currentBooking.setCityCode(response.body().getCityData().getCityCode());
                currentBooking.setCountry(response.body().getCityData().getCountry());
                currentBooking.setCountryCode(response.body().getCityData().getCountryCode());
                currentBooking.setCountryCode2(response.body().getCityData().getCountryCode2());
                currentBooking.setPaymentLongitude(response.body().getCityData().getLongitude());
                currentBooking.setPaymentLatitude(response.body().getCityData().getLatitude());
                currentBooking.setTimeZone(response.body().getCity().getTimezone());
                currentBooking.setServerTime(response.body().getServerTime());
                currentBooking.setAdminAllowContactLessDelivery(response.body().isAllowContaclLessDelivery());
                currentBooking.getAds().clear();
                if (response.body().getAds() != null) {
                    currentBooking.setAds(response.body().getAds());
                }
                Utils.hideCustomProgressDialog();
                return true;
            } else {
                CurrentBooking.getInstance().setBookCityId("");
                CurrentBooking.getInstance().getDeliveryStoreList().clear();
                CurrentBooking.getInstance().getAds().clear();
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                Utils.hideCustomProgressDialog();
            }

        }
        Utils.hideCustomProgressDialog();
        return false;
    }

    /**
     * This method sync a serverCart to localCart so please read whole response of server cart
     * and take care about all models of cart which is help to make sync serverCart to localCart.
     *
     * @param response response
     * @see "check web service which have uniqueId for all produt,produtItem,
     * productSpecificationItem and productSpecificationItemItems"
     */
    public void parseCart(Response<CartResponse> response) {
        if (isSuccessful(response)) {
            CurrentBooking currentBooking = CurrentBooking.getInstance();
            if (response.body().isSuccess()) {
                ScheduleHelper scheduleHelper = currentBooking.getSchedule();
                currentBooking.clearCart();
                currentBooking.setSchedule(scheduleHelper);
                currentBooking.setTaxIncluded(response.body().isTaxIncluded());
                currentBooking.setUseItemTax(response.body().isUseItemTax());
                currentBooking.setTaxesDetails(response.body().getTaxDetails());
                currentBooking.setCartCityId(response.body().getCityId());
                currentBooking.setStoreLangs(response.body().getLangs());
                currentBooking.setCartId(response.body().getCartId());
                currentBooking.setCartCurrency(response.body().getCurrency());
                currentBooking.setPickupAddresses(response.body().getPickupAddresses().get(0));
                Addresses addresses = response.body().getDestinationAddresses().get(0);
                currentBooking.setDeliveryAddress(addresses.getAddress());
                currentBooking.setDeliveryLatLng(new LatLng(addresses.getLocation().get(0), addresses.getLocation().get(1)));
                currentBooking.setDestinationAddresses(response.body().getDestinationAddresses().get(0));
                List<CartProducts> cartProductsList = response.body().getCart().getProducts();
                for (CartProducts cartProducts : cartProductsList) {
                    double itemPriceAndSpecificationPriceTotal = 0;
                    CartProducts products = new CartProducts();
                    products.setProductName(cartProducts.getCartProductItemDetail().getName());
                    products.setUniqueId(cartProducts.getCartProductItemDetail().getUniqueId());
                    products.setProductId(cartProducts.getCartProductItemDetail().getId());
                    CartProductItems cartProductItemsNew;
                    ArrayList<CartProductItems> cartProductItemsListNew = new ArrayList<>();
                    for (CartProductItems cartProductItems : cartProducts.getItems()) {
                        cartProductItems.getProductItem().setCurrency(response.body().getCurrency());
                        currentBooking.setCartProductItemWithAllSpecificationList(cartProductItems.getProductItem());
                        ArrayList<Specifications> specificationListNew = new ArrayList<>();
                        cartProductItemsNew = new CartProductItems();
                        cartProductItemsNew.setImageUrl(cartProductItems.getProductItem().getImageUrl());
                        cartProductItemsNew.setItemId(cartProductItems.getProductItem().getId());
                        cartProductItemsNew.setItemName(cartProductItems.getProductItem().getName());
                        cartProductItemsNew.setItemPrice(cartProductItems.getProductItem().getPrice());
                        cartProductItemsNew.setItemNote(cartProductItems.getItemNote());
                        cartProductItemsNew.setDetails(cartProductItems.getProductItem().getDetails());
                        cartProductItemsNew.setQuantity(cartProductItems.getQuantity());
                        cartProductItemsNew.setUniqueId(cartProductItems.getUniqueId());
                        cartProductItemsNew.setTaxesDetails(cartProductItems.getProductItem().getTaxesDetails());
                        itemPriceAndSpecificationPriceTotal = cartProductItems.getProductItem().getPrice();
                        List<Specifications> cartSpecifications = cartProductItems.getSpecifications();
                        List<Specifications> specifications = cartProductItems.getProductItem().getSpecifications();

                        int specificationSize = cartSpecifications.size();
                        double specificationPriceTotal = 0;
                        double specificationPrice = 0;
                        ArrayList<SpecificationSubItem> specificationItemCartListNew = null;

                        for (int i = 0; i < specificationSize; i++) {
                            Specifications specificationsNew = null;
                            int size = specifications.size();
                            for (int a = 0; a < size; a++) {
                                if (cartSpecifications.get(i).getUniqueId() == specifications.get(a).getUniqueId()) {
                                    specificationItemCartListNew = new ArrayList<>();
                                    List<SpecificationSubItem> cartSpecificationListItemSub = cartSpecifications.get(i).getList();
                                    List<SpecificationSubItem> specificationListItemSub = specifications.get(a).getList();
                                    int cartSpecificationItemListSize = cartSpecificationListItemSub.size();
                                    int specificationListItemListSize = specifications.get(a).getList().size();
                                    for (int j = 0; j < cartSpecificationItemListSize; j++) {
                                        for (int k = 0; k < specificationListItemListSize; k++) {
                                            if (cartSpecificationListItemSub.get(j).getUniqueId() == specificationListItemSub.get(k).getUniqueId()) {
                                                for (Specifications specifications1 : cartProductItems.getSpecifications()) {
                                                    for (SpecificationSubItem specificationSubItem1 : specifications1.getList()) {
                                                        if (cartSpecificationListItemSub.get(j).getUniqueId() == specificationSubItem1.getUniqueId()) {
                                                            specificationListItemSub.get(k).setQuantity(specificationSubItem1.getQuantity());
                                                        }
                                                    }
                                                }
                                                specificationPrice = specificationPrice + specificationListItemSub.get(k).getPrice();
                                                specificationPriceTotal = specificationPriceTotal + (specificationListItemSub.get(k).getPrice() * specificationListItemSub.get(k).getQuantity());
                                                specificationListItemSub.get(k).setName(cartSpecificationListItemSub.get(j).getName());
                                                specificationItemCartListNew.add(specificationListItemSub.get(k));
                                                break;
                                            }
                                        }

                                    }
                                    if (!specificationItemCartListNew.isEmpty()) {
                                        specificationsNew = new Specifications();
                                        specificationsNew.setList(specificationItemCartListNew);
                                        specificationsNew.setName(cartSpecifications.get(i).getName());
                                        specificationsNew.setPrice(specificationPrice);
                                        specificationsNew.setType(specifications.get(a).getType());
                                        specificationsNew.setUniqueId(specifications.get(a).getUniqueId());
                                    }
                                    specificationPrice = 0;
                                    break;
                                }

                            }

                            if (specificationsNew != null) {
                                specificationListNew.add(specificationsNew);
                            }

                        }

                        cartProductItemsNew.setSpecifications(specificationListNew);
                        cartProductItemsNew.setTotalSpecificationPrice(specificationPriceTotal);
                        itemPriceAndSpecificationPriceTotal = (itemPriceAndSpecificationPriceTotal + specificationPriceTotal) * cartProductItems.getQuantity();
                        cartProductItemsNew.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);
                        cartProductItemsNew.setTotalPrice(cartProductItemsNew.getItemPrice() + cartProductItemsNew.getTotalSpecificationPrice());
                        cartProductItemsNew.setTax(response.body().isUseItemTax() ? cartProductItems.getTax() : response.body().getTotalTaxes());
                        cartProductItemsNew.setItemTax(getTaxableAmount(cartProductItems.getItemPrice(), cartProductItems.getTax(), response.body().isTaxIncluded()));
                        cartProductItemsNew.setTotalSpecificationTax(getTaxableAmount(cartProductItems.getTotalSpecificationPrice(), cartProductItems.getTax(), response.body().isTaxIncluded()));
                        cartProductItemsNew.setTotalTax(cartProductItemsNew.getItemTax() + cartProductItemsNew.getTotalSpecificationTax());
                        cartProductItemsNew.setTotalItemTax(cartProductItemsNew.getTotalTax() * cartProductItems.getQuantity());
                        cartProductItemsListNew.add(cartProductItemsNew);

                        currentBooking.setTotalCartAmount(currentBooking.getTotalCartAmount() + cartProductItemsNew.getTotalItemAndSpecificationPrice());
                        currentBooking.setTotalCartAmountWithoutTax(currentBooking.getTotalCartAmountWithoutTax() + cartProductItemsNew.getTotalItemAndSpecificationPrice());
                        if (currentBooking.isTaxIncluded()) {
                            currentBooking.setTotalCartAmount(currentBooking.getTotalCartAmount() - cartProductItemsNew.getTotalItemTax());
                        }
                    }
                    products.setItems(cartProductItemsListNew);
                    products.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
                    currentBooking.setSelectedStoreId(cartProducts.getCartProductItemDetail().getStoreId());
                    currentBooking.setCartProduct(products);
                    currentBooking.setTableBookingType(response.body().getBookingType());
                    currentBooking.setBookingFee(response.body().getBookingFee());
                    currentBooking.setNumberOfPerson(response.body().getNoOfPersons());
                    currentBooking.setTableNumber(response.body().getTableNo());
                }
            } else {
                currentBooking.setTableBookingType(0);
                currentBooking.setBookingFee(0);
                currentBooking.setNumberOfPerson(0);
                currentBooking.setTableNumber(0);
            }
        }
    }

    private double getTaxableAmount(double amount, double taxValue, boolean isTaxIncluded) {
        if (isTaxIncluded) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }

    public boolean parseAppSettingDetail(Response<AppSettingDetailResponse> response) {
        if (isSuccessful(response)) {
            if (response.body().isSuccess()) {
                preferenceHelper.putIsShowOptionalFieldInRegister(response.body().isShowOptionalField());
                preferenceHelper.putIsMailVerification(response.body().isVerifyEmail());
                preferenceHelper.putIsSmsVerification(response.body().isVerifyPhone());
                preferenceHelper.putIsProfilePictureRequired(response.body().isProfilePictureRequired());
                preferenceHelper.putIsAdminDocumentMandatory(response.body().isUploadDocumentsMandatory());
                preferenceHelper.putGoogleKey(response.body().getGoogleKey());

                preferenceHelper.putIsLoginByEmail(response.body().isLoginByEmail());
                preferenceHelper.putIsLoginByPhone(response.body().isLoginByPhone());

                preferenceHelper.putAdminContactEmail(response.body().getAdminContactEmail());
                preferenceHelper.putIsReferralOn(response.body().isUseReferral());
                preferenceHelper.putIsLoginBySocial(response.body().isLoginBySocial());
                preferenceHelper.putAdminContact(response.body().getAdminContactPhoneNumber());

                preferenceHelper.putMinimumPhoneNumberLength(response.body().getMinimumPhoneNumberLength());
                preferenceHelper.putMaximumPhoneNumberLength(response.body().getMaximumPhoneNumberLength());

                if (response.body().getUserBaseUrl() != null && !response.body().getUserBaseUrl().isEmpty()) {
                    preferenceHelper.putPolicy(response.body().getUserBaseUrl().concat(Const.PRIVACY_POSTFIX_URL));
                    preferenceHelper.putTermsANdConditions(response.body().getUserBaseUrl().concat(Const.TERMS_POSTFIX_URL));
                } else {
                    preferenceHelper.putPolicy(Const.PRIVACY_URL);
                    preferenceHelper.putTermsANdConditions(Const.TERMS_URL);
                }

                preferenceHelper.putIsAllowBringChangeOption(response.body().isAllowBringChangeOption());
                preferenceHelper.putIsEnableTwilioCallMasking(response.body().isEnableTwilioCallMasking());
                preferenceHelper.putMaxCourierStopLimit(response.body().getMaxCourierStopLimit());

                return true;
            } else {
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
            }
        }
        return false;
    }

    public HashMap<String, String> parsGoogleGeocode(Response<ResponseBody> response) {
        if (isSuccessful(response)) {
            HashMap<String, String> map = new HashMap<>();
            try {
                String responseGeocode = response.body().string();
                JSONObject jsonObject = new JSONObject(responseGeocode);
                if (jsonObject.getString(Const.Google.STATUS).equals(Const.Google.OK)) {
                    JSONObject resultObject = jsonObject.getJSONArray(Const.Google.RESULTS).getJSONObject(0);
                    JSONArray addressComponent = resultObject.getJSONArray(Const.Google.ADDRESS_COMPONENTS);
                    JSONObject geometryObject = resultObject.getJSONObject(Const.Google.GEOMETRY);
                    map.put(Const.Google.LAT, geometryObject.getJSONObject(Const.Google.LOCATION).getString(Const.Google.LAT));
                    map.put(Const.Google.LNG, geometryObject.getJSONObject(Const.Google.LOCATION).getString(Const.Google.LNG));
                    map.put(Const.Google.FORMATTED_ADDRESS, resultObject.getString(Const.Google.FORMATTED_ADDRESS));
                    int addressSize = addressComponent.length();
                    for (int i = 0; i < addressSize; i++) {
                        JSONObject address = addressComponent.getJSONObject(i);
                        JSONArray typesArray = address.getJSONArray(Const.Google.TYPES);
                        if (typesArray.length() > 0) {
                            if (Const.Google.LOCALITY.equals(typesArray.get(0).toString())) {
                                map.put(Const.Google.LOCALITY, address.getString(Const.Google.LONG_NAME));
                            } else if (Const.Google.ADMINISTRATIVE_AREA_LEVEL_2.equals(typesArray.get(0).toString())) {
                                map.put(Const.Google.ADMINISTRATIVE_AREA_LEVEL_2, address.getString(Const.Google.LONG_NAME));
                            } else if (Const.Google.ADMINISTRATIVE_AREA_LEVEL_1.equals(typesArray.get(0).toString())) {
                                map.put(Const.Google.ADMINISTRATIVE_AREA_LEVEL_1, address.getString(Const.Google.LONG_NAME));
                                map.put(Const.Params.CITY_CODE, address.getString(Const.Google.SHORT_NAME));
                            } else if (Const.Google.COUNTRY.equals(typesArray.get(0).toString())) {
                                map.put(Const.Google.COUNTRY, address.getString(Const.Google.LONG_NAME));
                                map.put(Const.Google.COUNTRY_CODE, address.getString(Const.Google.SHORT_NAME));
                            }
                        }
                    }
                    return map;
                } else {
                    Utils.hideCustomProgressDialog();
                    Utils.showToast("Google Key Error", context);
                }
            } catch (JSONException | IOException e) {
                AppLog.handleException(TAG, e);
            }
        }
        return null;
    }

    public HashMap<String, String> parsDistanceMatrix(Response<ResponseBody> response) {
        if (isSuccessful(response)) {
            HashMap<String, String> map = new HashMap<>();
            String destAddress, distance, time, originAddress;
            try {
                String distanceMatrix = response.body().string();
                JSONObject jsonObject = new JSONObject(distanceMatrix);
                if (jsonObject.getString(Const.Google.STATUS).equals(Const.Google.OK)) {
                    destAddress = jsonObject.getJSONArray(Const.Google.DESTINATION_ADDRESSES).getString(0);
                    originAddress = jsonObject.getJSONArray(Const.Google.ORIGIN_ADDRESSES).getString(0);
                    JSONObject rowsJson = jsonObject.getJSONArray(Const.Google.ROWS).getJSONObject(0);
                    JSONObject elementsJson = rowsJson.getJSONArray(Const.Google.ELEMENTS).getJSONObject(0);
                    if (elementsJson.getString(Const.Google.STATUS).equals(Const.Google.OK)) {
                        distance = elementsJson.getJSONObject(Const.Google.DISTANCE).getString(Const.Google.VALUE);
                        time = elementsJson.getJSONObject(Const.Google.DURATION).getString(Const.Google.VALUE);
                    } else {
                        float distanceFloat = calculateManualDistance();
                        time = String.format(Locale.getDefault(), "%.0f", calculateManualTime(distanceFloat));
                        distance = String.format(Locale.getDefault(), "%.0f", distanceFloat);
                    }
                    map.put(Const.Google.DESTINATION_ADDRESSES, destAddress);
                    map.put(Const.Google.DISTANCE, distance);
                    map.put(Const.Google.DURATION, time);
                    map.put(Const.Google.ORIGIN_ADDRESSES, originAddress);
                    return map;
                }
            } catch (JSONException | IOException e) {
                AppLog.handleException(TAG, e);
            }
        }
        return null;
    }

    private float calculateManualDistance() {
        CurrentBooking currentBooking = CurrentBooking.getInstance();
        float[] result = new float[1];
        Location.distanceBetween(currentBooking.getPickupAddresses().get(0).getLocation().get(0), currentBooking.getPickupAddresses().get(0).getLocation().get(1), currentBooking.getDeliveryLatLng().latitude, currentBooking.getDeliveryLatLng().longitude, result);

        return result[0];
    }

    private double calculateManualTime(float distance) {
        double time = (60 * distance) / 30000;
        time = time * 60;
        return time;
    }

    public boolean isSuccessful(Response<?> response) {
        if (response.isSuccessful()) {
            return true;
        } else {
            Utils.showHttpErrorToast(response.code(), context);
            Utils.hideCustomProgressDialog();
        }
        return false;
    }

    public ArrayList<Country> getRawCountryCodeList() {
        InputStream inputStream = context.getResources().openRawResource(R.raw.country_list);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        int ctr;
        try {
            ctr = inputStream.read();
            while (ctr != -1) {
                byteArrayOutputStream.write(ctr);
                ctr = inputStream.read();
            }
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        Gson gson = new Gson();
        Type listType = new TypeToken<List<Country>>() {
        }.getType();
        return gson.fromJson(byteArrayOutputStream.toString(), listType);
    }

    private String getCountryCodeISO2(String countryPhoneCode) {
        List<Country> countryList = parseContent.getRawCountryCodeList();
        for (Country countries : countryList) {
            for (String callingCode : countries.getCallingCodes()) {
                if (TextUtils.equals(countryPhoneCode, callingCode)) {
                    return countries.getCode();
                }
            }
        }
        return "";
    }
}