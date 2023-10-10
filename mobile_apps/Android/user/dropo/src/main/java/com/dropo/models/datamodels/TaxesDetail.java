package com.dropo.models.datamodels;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class TaxesDetail implements Parcelable {

    public static final Creator<TaxesDetail> CREATOR = new Creator<TaxesDetail>() {
        @Override
        public TaxesDetail createFromParcel(Parcel in) {
            return new TaxesDetail(in);
        }

        @Override
        public TaxesDetail[] newArray(int size) {
            return new TaxesDetail[size];
        }
    };
    @SerializedName("is_tax_visible")
    private final boolean isTaxVisible;
    @SerializedName("tax_name")
    private final List<String> taxName;
    @SerializedName("tax")
    private final double tax;
    @SerializedName("_id")
    private final String id;
    @SerializedName("country_id")
    private final String countryId;
    @SerializedName("tax_amount")
    private double taxAmount;

    protected TaxesDetail(Parcel in) {
        isTaxVisible = in.readByte() != 0;
        taxName = in.createStringArrayList();
        tax = in.readDouble();
        taxAmount = in.readDouble();
        id = in.readString();
        countryId = in.readString();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeByte((byte) (isTaxVisible ? 1 : 0));
        dest.writeStringList(taxName);
        dest.writeDouble(tax);
        dest.writeDouble(taxAmount);
        dest.writeString(id);
        dest.writeString(countryId);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public boolean isIsTaxVisible() {
        return isTaxVisible;
    }


    public List<String> getTaxName() {
        return taxName;
    }


    public double getTax() {
        return tax;
    }

    public String getId() {
        return id;
    }

    public String getCountryId() {
        return countryId;
    }

    public double getTaxAmount() {
        return taxAmount;
    }

    public void setTaxAmount(double taxAmount) {
        this.taxAmount = taxAmount;
    }
}