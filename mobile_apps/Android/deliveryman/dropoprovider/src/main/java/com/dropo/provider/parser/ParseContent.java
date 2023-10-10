package com.dropo.provider.parser;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.text.TextUtils;

import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.provider.R;
import com.dropo.provider.models.datamodels.Analytic;
import com.dropo.provider.models.datamodels.AvailableOrder;
import com.dropo.provider.models.datamodels.Cities;
import com.dropo.provider.models.datamodels.Countries;
import com.dropo.provider.models.datamodels.EarningData;
import com.dropo.provider.models.datamodels.Invoice;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.OrderTotal;
import com.dropo.provider.models.datamodels.Provider;
import com.dropo.provider.models.datamodels.ProviderAnalyticDaily;
import com.dropo.provider.models.datamodels.WeekData;
import com.dropo.provider.models.responsemodels.AppSettingDetailResponse;
import com.dropo.provider.models.responsemodels.AvailableOrdersResponse;
import com.dropo.provider.models.responsemodels.CityResponse;
import com.dropo.provider.models.responsemodels.CountriesResponse;
import com.dropo.provider.models.responsemodels.DayEarningResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.Marker;
import com.google.firebase.messaging.FirebaseMessaging;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import retrofit2.Response;

/**
 * Created by elluminati on 02-Feb-2017.
 */
public class ParseContent {
    private static final String TAG = "ParseContent";
    private static final ParseContent parseContent = new ParseContent();
    public SimpleDateFormat webFormat;
    public SimpleDateFormat timeFormat;
    public SimpleDateFormat dateFormat, dateFormat2, dateTimeFormat_am;
    public SimpleDateFormat day, weekDay, dateFormat3;
    public SimpleDateFormat dateFormatMonth, timeFormat_am, dateTimeFormat;
    public DecimalFormat decimalTwoDigitFormat;
    private PreferenceHelper preferenceHelper;
    private Context context;

    private ParseContent() {

        webFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT_WEB, Locale.US);
        webFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        dateFormat = new SimpleDateFormat(Const.DATE_FORMAT, Locale.US);
        timeFormat = new SimpleDateFormat(Const.TIME_FORMAT, Locale.US);
        day = new SimpleDateFormat(Const.DAY, Locale.US);
        dateFormatMonth = new SimpleDateFormat(Const.DATE_FORMAT_MONTH, Locale.US);
        timeFormat_am = new SimpleDateFormat(Const.TIME_FORMAT_AM, Locale.US);
        dateTimeFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT, Locale.US);
        dateFormat2 = new SimpleDateFormat(Const.DATE_FORMAT_2, Locale.US);
        dateFormat3 = new SimpleDateFormat(Const.DATE_FORMAT_3, Locale.US);
        weekDay = new SimpleDateFormat(Const.WEEK_DAY, Locale.US);
        dateTimeFormat_am = new SimpleDateFormat(Const.DATE_TIME_FORMAT_AM, Locale.US);
        DecimalFormatSymbols decimalFormatSymbols = new DecimalFormatSymbols(Locale.US);
        decimalTwoDigitFormat = new DecimalFormat("0.00", decimalFormatSymbols);
    }

    public static ParseContent getInstance() {
        return parseContent;
    }

    public void setContext(Context context) {
        preferenceHelper = PreferenceHelper.getInstance(context);
        this.context = context;
    }

    public boolean parseUserStorageData(Response<ProviderDataResponse> response) {
        if (isSuccessful(response)) {
            Utils.hideCustomProgressDialog();
            if (response.body().isSuccess()) {

                Provider provider = response.body().getProvider();
                preferenceHelper.putProviderId(provider.getId());
                preferenceHelper.putSessionToken(provider.getServerToken());
                ApiClient.setLoginDetail(provider.getId(), provider.getServerToken());
                preferenceHelper.putFirstName(provider.getFirstName());
                preferenceHelper.putLastName(provider.getLastName());
                preferenceHelper.putAddress(provider.getAddress());
                preferenceHelper.putZipCode(provider.getZipcode());
                preferenceHelper.putPhoneNumber(provider.getPhone());
                preferenceHelper.putPhoneCountyCode(provider.getCountryPhoneCode());
                preferenceHelper.putEmail(provider.getEmail());
                preferenceHelper.putProfilePic(IMAGE_URL + provider.getImageUrl());
                preferenceHelper.putIsProviderOnline(provider.isIsOnline());
                preferenceHelper.putIsProviderActiveForJob(provider.isActiveForJob());
                preferenceHelper.putIsProviderAllDocumentsUpload(provider.isIsDocumentUploaded());
                preferenceHelper.putIsApproved(provider.isIsApproved());
                preferenceHelper.putIsPhoneNumberVerified(provider.isIsPhoneNumberVerified());
                preferenceHelper.putIsEmailVerified(provider.isIsEmailVerified());
                preferenceHelper.putReferral(provider.getReferralCode());
                preferenceHelper.putCityId(provider.getCityId());
                preferenceHelper.putSelectedVehicleId(provider.getSelectedVehicleId());
                preferenceHelper.putIsProviderAllVehicleDocumentsUpload(response.body().isVehicleDocumentUploaded());
                preferenceHelper.putUniqueId(provider.getUniqueId());
                preferenceHelper.putFireBaseUserToken(response.body().getFirebaseToken());
                FirebaseMessaging.getInstance().subscribeToTopic(preferenceHelper.getProviderId());
                if (provider.getSocialId() != null && !provider.getSocialId().isEmpty()) {
                    preferenceHelper.putSocialId(provider.getSocialId().get(0));
                } else {
                    preferenceHelper.putSocialId("");
                }
                preferenceHelper.putMaxPhoneNumberLength(response.body().getMaxPhoneNumberLength());
                preferenceHelper.putMinPhoneNumberLength(response.body().getMinPhoneNumberLength());
                if (response.body().getVehicleDetail() != null && !TextUtils.isEmpty(response.body().getVehicleDetail().getMapPinImageUrl())) {
                    CurrentOrder.getInstance().setVehiclePin(response.body().getVehicleDetail().getMapPinImageUrl());
                }
                preferenceHelper.putProviderType(provider.getProviderType());
                return true;
            } else {
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
            }
        }
        return false;
    }

    public ArrayList<AvailableOrder> parseOrders(Response<AvailableOrdersResponse> response) {
        if (isSuccessful(response)) {
            Utils.hideCustomProgressDialog();
            if (response.body().isSuccess()) {
                ArrayList<AvailableOrder> orderLists = (ArrayList<AvailableOrder>) response.body().getAvailableOrder();
                if (orderLists == null) {
                    return new ArrayList<>();
                } else {
                    return orderLists;
                }

            } else {
//                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                return new ArrayList<>();
            }
        }
        return new ArrayList<>();
    }

    public ArrayList<Countries> parseCountries(Response<CountriesResponse> response) {
        if (isSuccessful(response)) {
            Utils.hideCustomProgressDialog();
            if (response.body().isSuccess()) {
                ArrayList<Countries> countries = (ArrayList<Countries>) response.body().getCountries();
                if (countries == null) {
                    return new ArrayList<>();
                } else {
                    return countries;
                }

            } else {
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                return new ArrayList<>();
            }
        }


        return null;
    }

    public ArrayList<Cities> parseCities(Response<CityResponse> response) {

        if (isSuccessful(response)) {
            Utils.hideCustomProgressDialog();
            if (response.body().isSuccess()) {
                ArrayList<Cities> cities = (ArrayList<Cities>) response.body().getCities();
                if (cities == null) {
                    return new ArrayList<>();
                } else {
                    return cities;
                }
            } else {
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
                return new ArrayList<>();
            }
        }

        return null;
    }

    public boolean parseAppSettingDetail(Response<AppSettingDetailResponse> response) {
        if (isSuccessful(response)) {
            if (response.body().isSuccess()) {
                preferenceHelper.putIsShowOptionalFieldInRegister(response.body().isShowOptionalField());
                preferenceHelper.putIsMailVerification(response.body().isVerifyEmail());
                preferenceHelper.putIsSmsVerification(response.body().isVerifyPhone());
                preferenceHelper.putIsAdminDocumentMandatory(response.body().isUploadDocumentsMandatory());
                preferenceHelper.putGoogleKey(response.body().getGoogleKey());
                preferenceHelper.putIsLoginByEmail(response.body().isLoginByEmail());
                preferenceHelper.putIsLoginByPhone(response.body().isLoginByPhone());
                preferenceHelper.putAdminContactEmail(response.body().getAdminContactEmail());
                preferenceHelper.putIsReferralOn(response.body().isUseReferral());
                preferenceHelper.putIsLoginBySocial(response.body().isLoginBySocial());
                preferenceHelper.putAdminContact(response.body().getAdminContactPhoneNumber());
                preferenceHelper.putIsProfilePictureRequired(response.body().isProfilePictureRequired());

                preferenceHelper.putMinimumPhoneNumberLength(response.body().getMinimumPhoneNumberLength());
                preferenceHelper.putMaximumPhoneNumberLength(response.body().getMaximumPhoneNumberLength());

                if (response.body().getUserBaseUrl() != null && !response.body().getUserBaseUrl().isEmpty()) {
                    preferenceHelper.putPolicy(response.body().getUserBaseUrl().concat(Const.PRIVACY_POSTFIX_URL));
                    preferenceHelper.putTermsANdConditions(response.body().getUserBaseUrl().concat(Const.TERMS_POSTFIX_URL));
                } else {
                    preferenceHelper.putPolicy(Const.PRIVACY_URL);
                    preferenceHelper.putTermsANdConditions(Const.TERMS_URL);
                }

                preferenceHelper.putIsEnableTwilioCallMasking(response.body().isEnableTwilioCallMasking());
                return true;
            } else {
                Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), context);
            }
        }
        return false;
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

    public ArrayList<ArrayList<Invoice>> parseInvoice(OrderPayment orderPayment, int deliveryType) {
        String currency = CurrentOrder.getInstance().getCurrency();
        String unit = orderPayment.isDistanceUnitMile() ? context.getResources().getString(R.string.unit_mile) : context.getResources().getString(R.string.unit_km);

        ArrayList<ArrayList<Invoice>> arrayListsInvoices = new ArrayList<>();
        ArrayList<Invoice> invoices = new ArrayList<>();

        if (orderPayment.getTotalBasePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_base_price), orderPayment.getTotalBasePrice(), currency, orderPayment.getBasePrice(), currency, orderPayment.getBasePriceDistance(), unit, ""));
        }

        if (orderPayment.getDistancePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_distance_price), orderPayment.getDistancePrice(), currency, orderPayment.getPricePerUnitDistance(), currency, 0.0, unit, ""));
        }

        if (orderPayment.getTotalTimePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_time_price), orderPayment.getTotalTimePrice(), currency, orderPayment.getPricePerUnitTime(), currency, 0.0, context.getResources().getString(R.string.unit_mins), ""));
        }

        if (orderPayment.getTotalServicePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_service_price), orderPayment.getTotalServicePrice(), currency, 0.0, "", 0.0, "", ""));
        }
        if (orderPayment.getAdditionalStopPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_additional_stop_price), orderPayment.getAdditionalStopPrice(), currency, 0.0, "", 0.0, "", ""));
        }

        if (orderPayment.getTotalRoundTripCharge() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_round_trip_charge), orderPayment.getTotalRoundTripCharge(), currency, 0.0, orderPayment.getRoundTripCharge() + "%", 0.0, "", ""));
        }
        if (deliveryType == Const.DeliveryType.COURIER) {
            if (orderPayment.getTotalOrderPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_additional_service_price), orderPayment.getTotalOrderPrice(), currency, 0.0, "", 0.0, "", ""));
            }
        }
        if (orderPayment.getTotalWaitingTimePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_waiting_time_charge), orderPayment.getTotalWaitingTimePrice(), currency, 0.0, "(" + (int) orderPayment.getTotalWaitingTime() + " " + context.getResources().getString(R.string.unit_min) + ")", 0.0, "", ""));
        }

        if (orderPayment.getTotalAdminTaxPrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_service_tax), orderPayment.getTotalAdminTaxPrice(), currency, 0.0, orderPayment.getServiceTax() + "%", 0.0, "", ""));
        }
        if (orderPayment.getTotalSurgePrice() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_surge_price), orderPayment.getTotalSurgePrice(), currency, orderPayment.getSurgeMultiplier(), "x", 0.0, "", ""));
        }

        if (deliveryType != Const.DeliveryType.COURIER) {
            if (orderPayment.getTotalDeliveryPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_service_cost), orderPayment.getTotalDeliveryPrice(), currency, 0.0, "", 0.0, "", ""));
            }
            if (orderPayment.getTotalOrderPrice() > 0) {
                invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_total_item_cost), orderPayment.getTotalOrderPrice(), currency, 0.0, orderPayment.getTotalItem() + " " + context.getResources().getString(R.string.text_item), 0.0, "", ""));
            }
        }
        if (orderPayment.getTipAmount() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_tip_amount), orderPayment.getTipAmount(), currency, 0.0, "", 0.0, "", ""));
        }
        if (orderPayment.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(context.getResources().getString(R.string.text_promo), orderPayment.getPromoPayment(), currency, 0.0, "", 0.0, "", ""));
        }
        arrayListsInvoices.add(invoices);

        ArrayList<Invoice> otherEarning = new ArrayList<>();
        String tag = context.getResources().getString(R.string.text_other_earning);
        if (orderPayment.getProviderHaveCashPayment() > 0) {
            otherEarning.add(loadInvoiceData(context.getResources().getString(R.string.text_cash_amount), orderPayment.getProviderHaveCashPayment(), currency, 0.0, "", 0.0, "", tag));
        }
        if (orderPayment.getProviderPaidOrderPayment() > 0) {
            otherEarning.add(loadInvoiceData(context.getResources().getString(R.string.text_paid_order_amount), orderPayment.getProviderPaidOrderPayment(), currency, 0.0, "", 0.0, "", tag));
        }
        if (orderPayment.getTotalProviderIncome() > 0) {
            otherEarning.add(loadInvoiceData(context.getResources().getString(R.string.text_profit), orderPayment.getTotalProviderIncome(), currency, 0.0, "", 0.0, "", tag));
        }

        if (!otherEarning.isEmpty()) {
            arrayListsInvoices.add(otherEarning);
        }
        return arrayListsInvoices;
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
    private Invoice loadInvoiceData(String title, double mainPrice, String currency, double subPrice, String subText, double unitValue, String unit, String tagTitle) {

        Invoice invoice = new Invoice();
        invoice.setPrice(currency + decimalTwoDigitFormat.format(mainPrice));
        invoice.setSubTitle(appendString(subText, subPrice, unitValue, unit));
        invoice.setTitle(title);
        invoice.setTagTitle(tagTitle);
        return invoice;
    }

    private String appendString(String currency, Double price, Double value, String unit) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(currency);
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

    public void parseEarning(Response<DayEarningResponse> response, ArrayList<ArrayList<EarningData>> arrayListForEarning, ArrayList<Analytic> arrayListProviderAnalytic, List<Object> orderPaymentsItemList, boolean isWeekEarning) {

        OrderTotal orderTotal = response.body().getOrderTotal();
        if (orderTotal == null) {
            orderTotal = new OrderTotal();
        }

        Resources res = context.getResources();
        String tag1 = res.getString(R.string.text_service_earning);
        String tag2 = res.getString(R.string.text_provider_transactions);
        String tag3 = res.getString(R.string.text_payment);

        ArrayList<EarningData> earningDataArrayList1 = new ArrayList<>();

        earningDataArrayList1.add(loadEarningData(tag1, res.getString(R.string.text_service_price), "", orderTotal.getTotalServicePrice()));
        earningDataArrayList1.add(loadEarningData(tag1, res.getString(R.string.text_tax_price), "+", orderTotal.getTotalAfterTaxPrice()));
        earningDataArrayList1.add(loadEarningData(tag1, res.getString(R.string.text_delivery_price), "", orderTotal.getTotalDeliveryPrice()));
        earningDataArrayList1.add(loadEarningData(tag1, res.getString(R.string.text_admin_profit), "", orderTotal.getTotalAdminProfitOnDelivery()));
        earningDataArrayList1.add(loadEarningData(tag1, res.getString(R.string.text_provider_profit), "", orderTotal.getTotalProviderProfit()));

        arrayListForEarning.add(earningDataArrayList1);


        ArrayList<EarningData> earningDataArrayList2 = new ArrayList<>();

        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_paid_order_amount), "", orderTotal.getProviderPaidOrderPayment()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_cash_amount), "", orderTotal.getProviderHaveCashPayment()));

        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_cash_on_hand), "", orderTotal.getTotalProviderHaveCashPaymentOnHand()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_deduct_from_wallet), "", orderTotal.getTotalWalletIncomeSetInCashOrder()));
        earningDataArrayList2.add(loadEarningData(tag2, res.getString(R.string.text_added_in_wallet), "", orderTotal.getTotalWalletIncomeSetInOtherOrder()));

        arrayListForEarning.add(earningDataArrayList2);


        ArrayList<EarningData> earningDataArrayList3 = new ArrayList<>();
        earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_total_earning), "", orderTotal.getTotalEarning()));
        earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_paid_in_wallet), "", orderTotal.getTotalWalletIncomeSet()));

        earningDataArrayList3.add(loadEarningData(tag3, res.getString(R.string.text_total_paid), "", orderTotal.getTotalPaid()));

        arrayListForEarning.add(earningDataArrayList3);


        ProviderAnalyticDaily analyticDaily;

        if (isWeekEarning) {
            analyticDaily = response.body().getProviderAnalyticWeekly();
        } else {
            analyticDaily = response.body().getProviderAnalyticDaily();
        }


        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_time_online), Utils.secondsToHoursMinutesSeconds(analyticDaily.getTotalOnlineTime())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_job_time), Utils.secondsToHoursMinutesSeconds(analyticDaily.getTotalActiveJobTime())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_total_order), String.valueOf(analyticDaily.getReceived())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_not_answered), String.valueOf(analyticDaily.getNotAnswered())));

        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_accepted_order), String.valueOf(analyticDaily.getAccepted())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_accepted_ratio), decimalTwoDigitFormat.format(analyticDaily.getAcceptionRatio()) + "%"));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_completed_order), String.valueOf(analyticDaily.getCompleted())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_complete_ratio), decimalTwoDigitFormat.format(analyticDaily.getCompletedRatio()) + "%"));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_rejected_order), String.valueOf(analyticDaily.getRejected())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_rejected_ratio), decimalTwoDigitFormat.format(analyticDaily.getRejectionRatio()) + "%"));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_canceled_order), String.valueOf(analyticDaily.getCancelled())));
        arrayListProviderAnalytic.add(loadAnalyticData(res.getString(R.string.text_canceled_ratio), decimalTwoDigitFormat.format(analyticDaily.getCancellationRatio()) + "%"));

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

    public void downloadVehiclePin(final Context context, final Marker marker) {
        if (!TextUtils.isEmpty(CurrentOrder.getInstance().getVehiclePin())) {
            if (CurrentOrder.getInstance().getBmVehiclePin() == null) {
                GlideApp.with(context).asBitmap().load(IMAGE_URL + CurrentOrder.getInstance().getVehiclePin())

                        .diskCacheStrategy(DiskCacheStrategy.ALL).placeholder(R.drawable.driver_car).listener(new RequestListener<Bitmap>() {
                            @Override
                            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                                AppLog.handleException(getClass().getSimpleName(), e);
                                if (marker != null) {
                                    marker.setIcon(BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(context, R.drawable.driver_car))));
                                }
                                return true;
                            }

                            @Override
                            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                                if (marker != null) {
                                    marker.setIcon(BitmapDescriptorFactory.fromBitmap(resource));
                                    CurrentOrder.getInstance().setBmVehiclePin(resource);
                                }
                                return true;
                            }
                        }).dontAnimate().override(context.getResources().getDimensionPixelSize(R.dimen.vehicle_pin_width), context.getResources().getDimensionPixelSize(R.dimen.vehicle_pin_height)).preload(context.getResources().getDimensionPixelSize(R.dimen.vehicle_pin_width), context.getResources().getDimensionPixelSize(R.dimen.vehicle_pin_height));
            } else {
                if (marker != null) {
                    marker.setIcon(BitmapDescriptorFactory.fromBitmap(CurrentOrder.getInstance().getBmVehiclePin()));
                }
            }
        } else {
            if (marker != null) {
                marker.setIcon(BitmapDescriptorFactory.fromBitmap(Utils.drawableToBitmap(AppCompatResources.getDrawable(context, R.drawable.driver_car))));

            }
        }
    }

}
