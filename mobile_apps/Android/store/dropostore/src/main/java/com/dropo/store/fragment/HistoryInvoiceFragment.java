package com.dropo.store.fragment;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.InvoiceAdapter;
import com.dropo.store.models.datamodel.Invoice;
import com.dropo.store.models.datamodel.InvoicePayment;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class HistoryInvoiceFragment extends BaseHistoryFragment {

    private OrderPaymentDetail orderPaymentDetail;
    private CustomFontTextViewTitle tvInvoiceTotal;
    private ParseContent parseContent;
    private LinearLayout invoiceDistance, invoicePayment;
    private RecyclerView rcvInvoice;
    private String currency;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_history_invoice, container, false);
        parseContent = ParseContent.getInstance();
        invoiceDistance = view.findViewById(R.id.invoiceDistance);
        invoicePayment = view.findViewById(R.id.invoicePayment);
        rcvInvoice = view.findViewById(R.id.rcvInvoice);
        tvInvoiceTotal = view.findViewById(R.id.tvInvoiceTotal);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        orderPaymentDetail = activity.detailsResponse.getOrder().getOrderPaymentDetail();
        orderPaymentDetail.setTaxIncluded(activity.detailsResponse.getOrder().getCartDetail().isTaxIncluded());
        currency = activity.preferenceHelper.getCurrency();
        setInvoiceData();
        setInvoiceDistanceAndTime();
        setInvoicePayments();
    }

    private void setInvoiceDistanceAndTime() {
        String unit = orderPaymentDetail.isIsDistanceUnitMile() ? this.getResources().getString(R.string.unit_mile) : this.getResources().getString(R.string.unit_km);

        ArrayList<InvoicePayment> invoicePayments = new ArrayList<>();
        if (activity.detailsResponse.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
            invoicePayments.add(loadInvoiceImage(getString(R.string.text_table_no), activity.detailsResponse.getOrder().getCartDetail().getTableNo(), R.drawable.ic_table_booking));
            invoicePayments.add(loadInvoiceImage(getString(R.string.text_persons), activity.detailsResponse.getOrder().getCartDetail().getNoOfPersons(), R.drawable.ic_no_of_person));
        } else {
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_time_h_m), Utilities.minuteToHoursMinutesSeconds(orderPaymentDetail.getTotalTime()), R.drawable.ic_wall_clock));
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_distance), appendString(orderPaymentDetail.getTotalDistance(), unit), R.drawable.ic_route));
        }

        invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_pay), orderPaymentDetail.isIsPaymentModeCash() ? activity.getResources().getString(R.string.text_cash) : activity.getResources().getString(R.string.text_card), orderPaymentDetail.isIsPaymentModeCash() ? R.drawable.ic_cash : R.drawable.ic_card));

        int size = invoicePayments.size();
        for (int i = 0; i < size; i++) {
            CardView cardView = (CardView) invoiceDistance.getChildAt(i);
            cardView.setVisibility(View.VISIBLE);
            LinearLayout currentLayout = (LinearLayout) cardView.getChildAt(0);
            ImageView imageView = (ImageView) currentLayout.getChildAt(0);
            imageView.setImageDrawable(AppCompatResources.getDrawable(activity, invoicePayments.get(i).getImageId()));
            ((CustomTextView) currentLayout.getChildAt(1)).setText(invoicePayments.get(i).getTitle());
            ((CustomTextView) currentLayout.getChildAt(2)).setText(invoicePayments.get(i).getValue());
        }
    }

    private void setInvoicePayments() {
        ArrayList<InvoicePayment> invoicePayments = new ArrayList<>();
        invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_wallet), appendString(currency, orderPaymentDetail.getWalletPayment()), R.drawable.ic_wallet));
        if (orderPaymentDetail.isIsPaymentModeCash()) {
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_cash), appendString(currency, orderPaymentDetail.getCashPayment()), R.drawable.ic_cash));
        } else {
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_card), appendString(currency, orderPaymentDetail.getCardPayment()), R.drawable.ic_card));
        }

        if (orderPaymentDetail.getPromoPayment() > 0) {
            invoicePayment.addView(LayoutInflater.from(activity).inflate(R.layout.include_invoice_data, null));
            invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_promo), appendString(currency, orderPaymentDetail.getPromoPayment()), R.drawable.ic_promo_code));
        }
        int size = invoicePayments.size();
        for (int i = 0; i < size; i++) {
            CardView cardView = (CardView) invoicePayment.getChildAt(i);
            LinearLayout currentLayout = (LinearLayout) cardView.getChildAt(0);
            ImageView imageView = (ImageView) currentLayout.getChildAt(0);
            imageView.setImageDrawable(AppCompatResources.getDrawable(activity, invoicePayments.get(i).getImageId()));
            ((CustomTextView) currentLayout.getChildAt(1)).setText(invoicePayments.get(i).getTitle());
            ((CustomTextView) currentLayout.getChildAt(2)).setText(invoicePayments.get(i).getValue());
        }

        tvInvoiceTotal.setText(String.format("%s%s", currency, parseContent.decimalTwoDigitFormat.format(orderPaymentDetail.getTotal())));
    }

    private void setInvoiceData() {
        String unit = orderPaymentDetail.isIsDistanceUnitMile() ? this.getResources().
                getString(R.string.unit_mile) : this.getResources().getString(R.string.unit_km);

        ArrayList<ArrayList<Invoice>> arrayListsInvoices = new ArrayList<>();
        ArrayList<Invoice> invoices = new ArrayList<>();
        String tag1 = getResources().getString(R.string.text_payment_detail);
        if (orderPaymentDetail.getTotalBasePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_base_price), orderPaymentDetail.getTotalBasePrice(), currency, orderPaymentDetail.getBasePrice(), currency, orderPaymentDetail.getBasePriceDistance(), unit, tag1));
        }
        if (orderPaymentDetail.getDistancePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_distance_price), orderPaymentDetail.getDistancePrice(), currency, orderPaymentDetail.getPricePerUnitDistance(), currency, 0.0, unit, tag1));
        }
        if (orderPaymentDetail.getTotalTimePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_time_cost), orderPaymentDetail.getTotalTimePrice(), currency, orderPaymentDetail.getPricePerUnitTime(), currency, 0.0, this.getResources().getString(R.string.unit_mins), tag1));
        }

        if (orderPaymentDetail.getTotalServicePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_service_price), orderPaymentDetail.getTotalServicePrice(), currency, 0.0, "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTotalAdminTaxPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_service_tax), orderPaymentDetail.getTotalAdminTaxPrice(), currency, 0.0, orderPaymentDetail.getServiceTax() + "%", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTotalSurgePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_surge_price), orderPaymentDetail.getTotalSurgePrice(), currency, orderPaymentDetail.getSurgeCharges(), "x", 0.0, "", tag1));
        }

        if (orderPaymentDetail.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_promo), orderPaymentDetail.getPromoPayment(), currency, 0.0, "", 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalDeliveryPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_total_service_cost), orderPaymentDetail.getTotalDeliveryPrice(), currency, 0.0, "", 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalCartPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_item_price_2), orderPaymentDetail.getTotalCartPrice(), currency, 0.0, orderPaymentDetail.getTotalItem() + "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getBookingFees() > 0) {
            invoices.add(loadInvoiceData(getString(R.string.text_booking_fees), orderPaymentDetail.getBookingFees(), currency, 0.0, "", 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalStoreTaxPrice() > 0) {
            ArrayList<String> taxesSubtext = new ArrayList<>();
            for (TaxesDetail detail : orderPaymentDetail.getTaxes()) {
                taxesSubtext.add(Utilities.getDetailStringFromList(detail.getTaxName(), Language.getInstance().getStoreLanguageIndex()) + " " + detail.getTax() + "%");
            }
            String text = "";
            if (!taxesSubtext.isEmpty()) {
                text = "(" + TextUtils.join(",", taxesSubtext) + ") " + (orderPaymentDetail.isTaxIncluded() ? "Inc" : "Exc");
            }
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_tex), orderPaymentDetail.getTotalStoreTaxPrice(), currency, 0.0, text, 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalOrderPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_total_item_cost), orderPaymentDetail.getTotalOrderPrice(), currency, 0.0, "", 0.0, "", tag1));
        }

        arrayListsInvoices.add(invoices);

        ArrayList<Invoice> otherEarning = new ArrayList<>();
        String tag = getResources().getString(R.string.text_other_earning);
        otherEarning.add(loadInvoiceData(getResources().getString(R.string.text_profit), orderPaymentDetail.getTotalStoreIncome(), currency, 0.0, "", 0.0, "", tag));
        arrayListsInvoices.add(otherEarning);

        rcvInvoice.setLayoutManager(new LinearLayoutManager(activity));
        InvoiceAdapter invoiceAdapter = new InvoiceAdapter(arrayListsInvoices);
        invoiceAdapter.setShowFirstSection(true);
        rcvInvoice.setAdapter(invoiceAdapter);
    }

    private Invoice loadInvoiceData(String title, double mainPrice, String currency, double subPrice, String subText, double unitValue, String unit, String tagTitle) {
        Invoice invoice = new Invoice();
        invoice.setPrice(appendString(currency, mainPrice));
        invoice.setSubTitle(appendString(subText, subPrice, unitValue, unit));
        invoice.setTitle(title);
        invoice.setTagTitle(tagTitle);
        return invoice;
    }

    private InvoicePayment loadInvoiceImage(String title, String subTitle, int id) {
        InvoicePayment invoicePayment = new InvoicePayment();
        invoicePayment.setTitle(title);
        invoicePayment.setValue(subTitle);
        invoicePayment.setImageId(id);
        return invoicePayment;
    }

    private String appendString(String currency, Double price, Double value, String unit) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(currency);
        if (price > 0) {
            stringBuilder.append(parseContent.decimalTwoDigitFormat.format(price));
        }
        if (!TextUtils.isEmpty(unit)) {
            stringBuilder.append("/");
            if (value > 1.0) {
                stringBuilder.append(parseContent.decimalTwoDigitFormat.format(value));
            }
            stringBuilder.append(unit);
        }
        return stringBuilder.toString();
    }

    private String appendString(String string, Double value) {
        return string + parseContent.decimalTwoDigitFormat.format(value);
    }

    private String appendString(Double value, String unit) {
        return parseContent.decimalTwoDigitFormat.format(value) + unit;
    }
}