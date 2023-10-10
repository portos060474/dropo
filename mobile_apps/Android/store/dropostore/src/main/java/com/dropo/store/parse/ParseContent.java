package com.dropo.store.parse;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.location.Location;
import android.text.TextUtils;

import com.dropo.store.R;
import com.dropo.store.RegisterLoginActivity;
import com.dropo.store.models.datamodel.Analytic;
import com.dropo.store.models.datamodel.EarningData;
import com.dropo.store.models.datamodel.Invoice;
import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.OrderTotal;
import com.dropo.store.models.datamodel.StoreAnalyticDaily;
import com.dropo.store.models.datamodel.SubStore;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.datamodel.WeekData;
import com.dropo.store.models.responsemodel.AppSettingResponse;
import com.dropo.store.models.responsemodel.DayEarningResponse;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.android.gms.maps.model.LatLng;
import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
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

/**
 * A class to parse json response on 30-01-2017.
 */

public class ParseContent {

    private static ParseContent parseContent;
    public SimpleDateFormat webFormat;
    public SimpleDateFormat timeFormat_am;
    public SimpleDateFormat dateFormat;
    public SimpleDateFormat dateTimeFormat, dateTimeFormat_am;
    public SimpleDateFormat day, timeFormat, timeFormat2;
    public SimpleDateFormat dateFormatMonth, dateFormat2, dateFormat3;
    public PreferenceHelper preferenceHelper;
    public DecimalFormat decimalTwoDigitFormat;
    private Context context;


    private ParseContent() {

        webFormat = new SimpleDateFormat(Constant.DATE_TIME_FORMAT_WEB, Locale.US);
        webFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        timeFormat_am = new SimpleDateFormat(Constant.TIME_FORMAT_AM, Locale.US);
        timeFormat = new SimpleDateFormat(Constant.TIME_FORMAT, Locale.US);
        dateFormat = new SimpleDateFormat(Constant.DATE_FORMAT, Locale.US);
        dateTimeFormat = new SimpleDateFormat(Constant.DATE_TIME_FORMAT, Locale.US);
        day = new SimpleDateFormat(Constant.DAY, Locale.US);
        dateFormatMonth = new SimpleDateFormat(Constant.DATE_FORMAT_MONTH, Locale.US);
        dateFormat2 = new SimpleDateFormat(Constant.DATE_FORMAT_2, Locale.US);
        DecimalFormatSymbols decimalFormatSymbols = new DecimalFormatSymbols(Locale.US);
        decimalTwoDigitFormat = new DecimalFormat("0.00", decimalFormatSymbols);
        dateFormat3 = new SimpleDateFormat(Constant.DATE_FORMAT_3, Locale.US);
        timeFormat2 = new SimpleDateFormat(Constant.TIME_FORMAT_2, Locale.US);
        dateTimeFormat_am = new SimpleDateFormat(Constant.DATE_TIME_FORMAT_AM, Locale.US);

    }

    public static ParseContent getInstance() {
        if (parseContent == null) {
            parseContent = new ParseContent();
        }
        return parseContent;
    }

    public void parseStoreData(StoreDataResponse storeData, boolean isSetting) {
        preferenceHelper.putCurrency(storeData.getCurrency());
        preferenceHelper.putName(storeData.getStoreData().getName());
        preferenceHelper.putPhone(storeData.getStoreData().getPhone());
        preferenceHelper.putProfilePic(storeData.getStoreData().getImageUrl());
        preferenceHelper.putIsApproved(storeData.getStoreData().isApproved());
        preferenceHelper.putIsEmailVerified(storeData.getStoreData().isEmailVerified());
        preferenceHelper.putIsPhoneNumberVerified(storeData.getStoreData().isPhoneNumberVerified());
        preferenceHelper.putCountryPhoneCode(storeData.getStoreData().getCountryPhoneCode());
        preferenceHelper.putEmail(storeData.getStoreData().getEmail());
        preferenceHelper.putIsStoreCanCreateGroup(storeData.isStoreCanCreateGroup());
        preferenceHelper.putIsStoreCanEditOrder(storeData.isStoreCanEditOrder());
        preferenceHelper.putIsUserAllDocumentsUpload(storeData.getStoreData().isDocumentUploaded());
        preferenceHelper.putReferralCode(storeData.getStoreData().getReferralCode());
        preferenceHelper.putIsAskForEstimatedTimeForOrderReady(storeData.getStoreData().isAskEstimatedTimeForReadyOrder());
        preferenceHelper.putCityId(storeData.getStoreData().getCityId());
        preferenceHelper.putAddress(storeData.getStoreData().getAddress());
        FirebaseMessaging.getInstance().subscribeToTopic(preferenceHelper.getStoreId());
        preferenceHelper.putLatitude(String.valueOf(storeData.getStoreData().getLocation().get(0)));
        preferenceHelper.putLongitude(String.valueOf(storeData.getStoreData().getLocation().get(1)));
        preferenceHelper.putFireBaseUserToken(storeData.getStoreData().getFirebaseToken());
        if (storeData.getStoreData().getSocialIds() != null && !storeData.getStoreData().getSocialIds().isEmpty()) {
            preferenceHelper.putSocialId(storeData.getStoreData().getSocialIds().get(0));
        } else {
            preferenceHelper.putSocialId("");
        }
        CurrentBooking.getInstance().setBookCountryId(storeData.getStoreData().getCountryId());
        CurrentBooking.getInstance().setStoreLatLng(new LatLng(storeData.getStoreData().getLocation().get(0), storeData.getStoreData().getLocation().get(1)));
        CurrentBooking.getInstance().setBookCityId(storeData.getStoreData().getCityId());
        preferenceHelper.putIsProvidePickupDelivery(storeData.getStoreData().isProvidePickupDelivery());
        preferenceHelper.putIsUseItemTax(storeData.getStoreData().isUseItemTax());
        preferenceHelper.putIsTaxIncluded(storeData.getStoreData().isTaxIncluded());
        double tax = 0;
        if (isSetting) {
            for (TaxesDetail detail : storeData.getStoreData().getStoreTaxesDetails()) {
                tax += detail.getTax();
            }
        } else {
            for (TaxesDetail detail : storeData.getStoreData().getTaxDetails()) {
                tax += detail.getTax();
            }
        }
        CurrentBooking.getInstance().setStoreTaxesDetails(storeData.getStoreData().getStoreTaxesDetails());
        preferenceHelper.putStoreTax((float) tax); // sum of all selected taxes
        preferenceHelper.putIsStoreCanCompleteOrder(storeData.getStoreData().isStoreCanCompleteOrder());
        preferenceHelper.putIsStoreCanAddProvider(storeData.getStoreData().isStoreCanAddProvider());
        preferenceHelper.putIsStoreCreateOrder(storeData.getStoreData().isStoreCreateOrder());
        preferenceHelper.putIsStoreEditItem(storeData.getStoreData().isStoreEditItem());
        preferenceHelper.putIsStoreAddPromoCode(storeData.getStoreData().isStoreAddPromoCode());
        preferenceHelper.putIsStoreCanSetCancellationCharge(storeData.getStoreData().isStoreCanSetCancellationCharge());
        Language.getInstance().setStoreLanguages((ArrayList<Languages>) storeData.getStoreData().getLanguages());
        for (Languages storeLanguage : Language.getInstance().getStoreLanguages()) {
            if (TextUtils.equals(storeLanguage.getCode(), "en")) {
                storeLanguage.setVisible(true);
                break;
            }
        }
        Language.getInstance().setStoreLanguageIndex(Utilities.getLangIndex(preferenceHelper.getLanguageCode(), Language.getInstance().getStoreLanguages(), true));
        if (!TextUtils.isEmpty(storeData.getStoreData().getId())) {
            preferenceHelper.putStoreId(storeData.getStoreData().getId());
        }
        if (!TextUtils.isEmpty(storeData.getStoreData().getServerToken())) {
            preferenceHelper.putServerToken(storeData.getStoreData().getServerToken());
        }
        if (storeData.getSubStore() != null) {
            SubStore subStore = storeData.getSubStore();
            preferenceHelper.putSubStoreId(subStore.getId());
            preferenceHelper.putServerToken(subStore.getServerToken());
            preferenceHelper.putStoreId(subStore.getMainStoreId());
            SubStoreAccess.getInstance().loadAccess(subStore.getSubStoreAccessServices());
        }

    }

    public void setContext(Context context) {
        this.context = context;
        preferenceHelper = PreferenceHelper.getPreferenceHelper(context);
    }

    /*public void showErrorMessage(Context context, int errorCode) {
        if (errorCode == Constant.INVALID_TOKEN || errorCode == Constant.STORE_DATA_NOT_FOUND) {
            PreferenceHelper.getPreferenceHelper(context).logout();
            Intent intent = new Intent(context, RegisterLoginActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            context.startActivity(intent);
            ((Activity) context).finish();
        } else {
            String message;
            try {
                String error_code = Constant.ERROR_CODE_PREFIX + errorCode;
                message = context.getResources().getString(context.getResources().getIdentifier(error_code, "string", context.getPackageName()));
            } catch (Resources.NotFoundException e) {
                message = String.valueOf(errorCode);
            }
            Utilities.showToast(context, message);
        }
    }

    public void showMessage(Context context, int messageCode) {
        String message;
        try {
            String code = Constant.MESSAGE_CODE_PREFIX + messageCode;
            message = context.getResources().getString(context.getResources().getIdentifier(code, "string", context.getPackageName()));
        } catch (Resources.NotFoundException e) {
            message = String.valueOf(messageCode);
        }
        Utilities.showToast(context, message);
    }*/

    public void showErrorMessage(Context context, int errorCode, String error) {
        if (errorCode == Constant.INVALID_TOKEN || errorCode == Constant.STORE_DATA_NOT_FOUND) {
            PreferenceHelper.getPreferenceHelper(context).logout();
            Intent intent = new Intent(context, RegisterLoginActivity.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            context.startActivity(intent);
            ((Activity) context).finish();
        }
        if (error != null) {
            Utilities.showToast(context, error);
        }
    }

    public void showMessage(Context context, String message) {
        if (message != null) {
            Utilities.showToast(context, message);
        }
    }

    public LatLng getLatLngFromAddress(String response) {
        if (!TextUtils.isEmpty(response)) {
            try {
                JSONObject jsonObject = new JSONObject(response);
                if (jsonObject.getString(Constant.STATUS).equals("OK")) {
                    JSONObject jObject = jsonObject.getJSONArray(Constant.RESULTS).getJSONObject(0).getJSONObject(Constant.GEOMETRY).getJSONObject(Constant.LOCATION);
                    return new LatLng(Double.parseDouble(jObject.getString(Constant.LAT)), Double.parseDouble(jObject.getString(Constant.LNG)));
                }
            } catch (JSONException e) {

                Utilities.handleException("getLatLngFromAddress", e);
            }
        }
        return null;
    }

    public boolean parseAppSettingDetails(Response<AppSettingResponse> response) {
        if (isSuccessful(response)) {
            preferenceHelper.putGoogleKey(response.body().getGoogleKey());
            preferenceHelper.putForceUpdate(response.body().isIsForceUpdate());
            preferenceHelper.putShowOptionalFieldInRegister(response.body().isIsHideOptionalField());
            preferenceHelper.putIsLoginByPhone(response.body().isIsLoginByPhone());
            preferenceHelper.putIsLoginByEmail(response.body().isIsLoginByEmail());
            preferenceHelper.putAdminContactEmail(response.body().getAdminContactEmail());
            preferenceHelper.putIsVerifyEmail(response.body().isIsVerifyEmail());
            preferenceHelper.putIsVerifyPhone(response.body().isIsVerifyPhone());
            preferenceHelper.putIsAdminDocumentMandatory(response.body().isIsDocumentMandatory());
            preferenceHelper.putIsReferralOn(response.body().isIsUseReferral());
            preferenceHelper.putIsLoginBySocial(response.body().isLoginBySocial());
            preferenceHelper.putAdminContact(response.body().getAdminContactPhoneNumber());
            preferenceHelper.putTermsANdConditions(Constant.TERMS_URL);
            preferenceHelper.putPolicy(Constant.PRIVACY_URL);
            preferenceHelper.putIsUseCaptcha(response.body().isUseCaptcha());

            preferenceHelper.putMinimumPhoneNumberLength(response.body().getMinimumPhoneNumberLength());
            preferenceHelper.putMaximumPhoneNumberLength(response.body().getMaximumPhoneNumberLength());

            if (response.body().getUserBaseUrl() != null && !response.body().getUserBaseUrl().isEmpty()) {
                preferenceHelper.putPolicy(response.body().getUserBaseUrl().concat(Constant.PRIVACY_POSTFIX_URL));
                preferenceHelper.putTermsANdConditions(response.body().getUserBaseUrl().concat(Constant.TERMS_POSTFIX_URL));
            } else {
                preferenceHelper.putPolicy(Constant.PRIVACY_URL);
                preferenceHelper.putTermsANdConditions(Constant.TERMS_URL);
            }
            preferenceHelper.putIsEnableTwilioCallMasking(response.body().isEnableTwilioCallMasking());

            Language.getInstance().setAdminLanguages((ArrayList<Languages>) response.body().getLanguage());
            return true;
        }

        return false;
    }

    public boolean isSuccessful(Response<?> response) {
        if (response.isSuccessful()) {

            return true;

        } else {
            Utilities.showHttpErrorToast(response.code(), context);
            Utilities.hideCustomProgressDialog();
        }
        return false;
    }

    public void parseEarning(Response<DayEarningResponse> response, ArrayList<ArrayList<EarningData>> arrayListForEarning, ArrayList<Analytic> arrayListStoreAnalytic, List<Object> orderPaymentsItemList, boolean isWeekEarning) {

        OrderTotal orderTotal = response.body().getOrderTotal();
        if (orderTotal == null) {
            orderTotal = new OrderTotal();
        }

        Resources res = context.getResources();
        String tag1 = res.getString(R.string.text_order_earning);
        String tag2 = res.getString(R.string.text_store_transactions);
        String tag3 = res.getString(R.string.text_payment);

        ArrayList<EarningData> earningDataArrayList = new ArrayList<>();

        earningDataArrayList.add(loadEarningData(tag1, res.getString(R.string.text_item_price), "+", orderTotal.getTotalItemPrice()));
        earningDataArrayList.add(loadEarningData(tag1, res.getString(R.string.text_tax_price), "+", orderTotal.getTotalStoreTaxPrice()));
        earningDataArrayList.add(loadEarningData(tag1, res.getString(R.string.text_order_price), "", orderTotal.getTotalOrderPrice()));
        if (orderTotal.getTotalCancellationIncome() > 0) {
            earningDataArrayList.add(loadEarningData(tag2, res.getString(R.string.text_cancellation_fees), "", orderTotal.getTotalCancellationIncome()));
        }
        earningDataArrayList.add(loadEarningData(tag1, res.getString(R.string.text_admin_profit), "-", orderTotal.getTotalAdminProfitOnStore()));
        earningDataArrayList.add(loadEarningData(tag1, res.getString(R.string.text_store_profit), "", orderTotal.getTotalStoreIncome()));

        arrayListForEarning.add(earningDataArrayList);

        ArrayList<EarningData> earningDataArrayList2 = new ArrayList<>();

        if (orderTotal.getStoreHavePromoPayment() > 0) {
            earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_promo_payment), "", orderTotal.getStoreHavePromoPayment()));
        }

        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_received_order_amount), "", orderTotal.getStoreHaveOrderPayment()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_paid_service_fee), "", orderTotal.getStoreHaveServicePayment()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_deduct_from_wallet), "", orderTotal.getTotalWalletIncomeSetInCashOrder()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_added_in_wallet), "", orderTotal.getTotalWalletIncomeSetInOtherOrder()));

        arrayListForEarning.add(earningDataArrayList2);

        ArrayList<EarningData> earningDataArrayList3 = new ArrayList<>();
        earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_total_earning), "", orderTotal.getTotalEarning()));
        earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_paid_in_wallet), "", orderTotal.getTotalWalletIncomeSet()));
        if (isWeekEarning) {
            earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_total_paid), "", orderTotal.getTotalPaid()));
        }

        arrayListForEarning.add(earningDataArrayList3);
        StoreAnalyticDaily analyticDaily;


        if (isWeekEarning) {
            analyticDaily = response.body().getStoreAnalyticWeekly();
        } else {
            analyticDaily = response.body().getStoreAnalyticDaily();
        }
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_total_order), String.valueOf(analyticDaily.getTotalOrders())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_total_item_sold), String.valueOf(analyticDaily.getTotalItems())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_accepted_order), String.valueOf(analyticDaily.getAccepted())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_accepted_ratio), parseContent.decimalTwoDigitFormat.format(analyticDaily.getAcceptionRatio()) + "%"));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_reject_order), String.valueOf(analyticDaily.getRejected())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_reject_ration), parseContent.decimalTwoDigitFormat.format(analyticDaily.getRejectionRatio()) + "%"));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_completed_order), String.valueOf(analyticDaily.getCompleted())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_completed_ratio), parseContent.decimalTwoDigitFormat.format(analyticDaily.getCompletedRatio()) + "%"));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_canceled_order), String.valueOf(analyticDaily.getCancelled())));
        arrayListStoreAnalytic.add(loadAnalyticData(res.getString(R.string.text_canceled_ratio), parseContent.decimalTwoDigitFormat.format(analyticDaily.getCancellationRatio()) + "%"));
        orderPaymentsItemList.clear();
        if (isWeekEarning) {
            WeekData dayOfWeekOrderTotal, dayOfWeekDate;
            dayOfWeekOrderTotal = response.body().getDayOfWeekOrderTotal();
            if (dayOfWeekOrderTotal == null) {
                dayOfWeekOrderTotal = new WeekData();
            }
            dayOfWeekDate = response.body().getDayOfWeekDate();

            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate1(), dayOfWeekOrderTotal.getDate1()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate2(), dayOfWeekOrderTotal.getDate2()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate3(), dayOfWeekOrderTotal.getDate3()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate4(), dayOfWeekOrderTotal.getDate4()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate5(), dayOfWeekOrderTotal.getDate5()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate6(), dayOfWeekOrderTotal.getDate6()));
            orderPaymentsItemList.add(loadAnalyticData(dayOfWeekDate.getDate7(), dayOfWeekOrderTotal.getDate7()));
        } else {
            if (response.body().getOrderPayments() != null) {
                orderPaymentsItemList.addAll(response.body().getOrderPayments());
            }
        }


    }

    public HashMap<String, String> parsGoogleGeocode(Response<ResponseBody> response) {
        if (isSuccessful(response)) {
            HashMap<String, String> map = new HashMap<>();
            try {
                String responseGeocode = response.body().string();
                JSONObject jsonObject = new JSONObject(responseGeocode);
                if (jsonObject.getString(Constant.Google.STATUS).equals(Constant.Google.OK)) {

                    JSONObject resultObject = jsonObject.getJSONArray(Constant.Google.RESULTS).getJSONObject(0);

                    JSONArray addressComponent = resultObject.getJSONArray(Constant.Google.ADDRESS_COMPONENTS);

                    JSONObject geometryObject = resultObject.getJSONObject(Constant.Google.GEOMETRY);
                    map.put(Constant.Google.LAT, geometryObject.getJSONObject(Constant.Google.LOCATION).getString(Constant.Google.LAT));
                    map.put(Constant.Google.LNG, geometryObject.getJSONObject(Constant.Google.LOCATION).getString(Constant.Google.LNG));
                    map.put(Constant.Google.FORMATTED_ADDRESS, resultObject.getString(Constant.Google.FORMATTED_ADDRESS));

                    int addressSize = addressComponent.length();
                    for (int i = 0; i < addressSize; i++) {
                        JSONObject address = addressComponent.getJSONObject(i);
                        JSONArray typesArray = address.getJSONArray(Constant.Google.TYPES);
                        if (typesArray.length() > 0) {
                            if (Constant.Google.LOCALITY.equals(typesArray.get(0).toString())) {
                                map.put(Constant.Google.LOCALITY, address.getString(Constant.Google.LONG_NAME));
                            } else if (Constant.Google.ADMINISTRATIVE_AREA_LEVEL_2.equals(typesArray.get(0).toString())) {
                                map.put(Constant.Google.ADMINISTRATIVE_AREA_LEVEL_2, address.getString(Constant.Google.LONG_NAME));
                            } else if (Constant.Google.ADMINISTRATIVE_AREA_LEVEL_1.equals(typesArray.get(0).toString())) {
                                map.put(Constant.Google.ADMINISTRATIVE_AREA_LEVEL_1, address.getString(Constant.Google.LONG_NAME));
                                map.put(Constant.CITY_CODE, address.getString(Constant.Google.SHORT_NAME));

                            } else if (Constant.Google.COUNTRY.equals(typesArray.get(0).toString())) {
                                map.put(Constant.Google.COUNTRY, address.getString(Constant.Google.LONG_NAME));
                                map.put(Constant.Google.COUNTRY_CODE, address.getString(Constant.Google.SHORT_NAME));
                            }
                        }

                    }
                    return map;
                } else {
                    Utilities.hideCustomProgressDialog();
                }

            } catch (JSONException | IOException e) {
                Utilities.handleException(ParseContent.class.getName(), e);
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
                if (jsonObject.getString(Constant.Google.STATUS).equals(Constant.Google.OK)) {
                    destAddress = jsonObject.getJSONArray(Constant.Google.DESTINATION_ADDRESSES).getString(0);
                    originAddress = jsonObject.getJSONArray(Constant.Google.ORIGIN_ADDRESSES).getString(0);
                    JSONObject rowsJson = jsonObject.getJSONArray(Constant.Google.ROWS).getJSONObject(0);
                    JSONObject elementsJson = rowsJson.getJSONArray(Constant.Google.ELEMENTS).getJSONObject(0);
                    if (elementsJson.getString(Constant.Google.STATUS).equals(Constant.Google.OK)) {
                        distance = elementsJson.getJSONObject(Constant.Google.DISTANCE).getString(Constant.Google.VALUE);
                        time = elementsJson.getJSONObject(Constant.Google.DURATION).getString(Constant.Google.VALUE);
                    } else {
                        float distanceFloat = calculateManualDistance();
                        time = String.format("%.0f", calculateManualTime(distanceFloat));
                        distance = String.format("%.0f", distanceFloat);
                    }
                    map.put(Constant.Google.DESTINATION_ADDRESSES, destAddress);
                    map.put(Constant.Google.DISTANCE, distance);
                    map.put(Constant.Google.DURATION, time);
                    map.put(Constant.Google.ORIGIN_ADDRESSES, originAddress);
                    return map;
                }
            } catch (JSONException | IOException e) {
                Utilities.handleException(ParseContent.class.getName(), e);
            }
        }
        return null;
    }

    public ArrayList<Invoice> parseInvoice(OrderPaymentDetail orderPayment, String currency) {
        CurrentBooking.getInstance().setOrderPaymentId(orderPayment.getId());
        String unit = orderPayment.isIsDistanceUnitMile() ? context.getResources().getString(R.string.unit_mile) : context.getResources().getString(R.string.unit_km);

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
        if (orderPayment.getTotalAdminTaxPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_service_tax), orderPayment.getTotalAdminTaxPrice(), currency, 0.0, orderPayment.getServiceTax() + "%", 0.0, ""));
        }
        if (orderPayment.getTotalSurgePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_surge_price), orderPayment.getTotalSurgePrice(), currency, orderPayment.getSurgeCharges(), "x", 0.0, ""));
        }
        if (orderPayment.isPromoForDeliveryService() && orderPayment.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_promo), orderPayment.getPromoPayment(), currency, 0.0, "", 0.0, ""));
        }

        if (orderPayment.getTotalDeliveryPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_service_cost), orderPayment.getTotalDeliveryPrice(), currency, 0.0, "", 0.0, ""));
        }
        if (orderPayment.getTotalCartPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_item_price), orderPayment.getTotalCartPrice(), currency, 0.0, orderPayment.getTotalItem() + "" + " " + "" + context.getResources().getString(R.string.text_items), 0.0, ""));
        }
        if (orderPayment.getBookingFees() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_booking_fees), orderPayment.getBookingFees(), currency, 0.0, "", 0.0, ""));
        }


        if (orderPayment.getTotalStoreTaxPrice() > 0) {
            ArrayList<String> taxesSubtext = new ArrayList<>();
            for (TaxesDetail detail : orderPayment.getTaxes()) {
                taxesSubtext.add(Utilities.getDetailStringFromList(detail.getTaxName(), Language.getInstance().getStoreLanguageIndex()) + " " + detail.getTax() + "%");
            }
            String text = "";
            if (!taxesSubtext.isEmpty()) {
                text = "(" + TextUtils.join(",", taxesSubtext) + ") " + (orderPayment.isTaxIncluded() ? "Inc" : "Exc");
            }
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_tax), orderPayment.getTotalStoreTaxPrice(), currency, 0.0, text, 0.0, ""));
        }


        if (!orderPayment.isPromoForDeliveryService() && orderPayment.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_promo), orderPayment.getPromoPayment(), currency, 0.0, "", 0.0, ""));
        }
        if (orderPayment.getTotalOrderPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_item_cost), orderPayment.getTotalOrderPrice(), currency, 0.0, "", 0.0, ""));
        }
        if (orderPayment.getTipAmount() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_tip_amount), orderPayment.getTipAmount(), currency, 0.0, "", 0.0, ""));
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
     * @return
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

    private EarningData loadEarningData(String titleMain, String title, String currency, double mainPrice) {

        EarningData earningData = new EarningData();
        earningData.setTitle(title);
        earningData.setTitleMain(titleMain);
        earningData.setPrice(currency + parseContent.decimalTwoDigitFormat.format(mainPrice));

        return earningData;
    }

    private Analytic loadAnalyticData(String title, String value) {
        Analytic analytic = new Analytic();
        analytic.setTitle(title);
        analytic.setValue(value);
        return analytic;
    }

    private float calculateManualDistance() {
        CurrentBooking currentBooking = CurrentBooking.getInstance();
        float[] result = new float[1];
        Location.distanceBetween(currentBooking.getStoreLatLng().latitude, currentBooking.getStoreLatLng().longitude, currentBooking.getDeliveryLatLng().latitude, currentBooking.getDeliveryLatLng().longitude, result);

        return result[0];
    }

    private double calculateManualTime(float distance) {
        double time = (60 * distance) / 30000;
        time = time * 60;
        return time;
    }
}
