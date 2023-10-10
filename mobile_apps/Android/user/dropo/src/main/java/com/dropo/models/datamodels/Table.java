package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

public class Table {

    @SerializedName("table_no")
    private String tableNo;

    @SerializedName("table_code")
    private String tableCode;

    @SerializedName("is_user_can_book")
    private boolean isUserCanBook;

    @SerializedName("table_max_person")
    private int tableMaxPerson;

    @SerializedName("table_min_person")
    private int tableMinPerson;

    @SerializedName("_id")
    private String id;

    @SerializedName("table_qrcode")
    private String tableQrcode;

    @SerializedName("store_id")
    private String storeId;

    @SerializedName("is_bussiness")
    private boolean isBusiness;

    public String getTableNo() {
        return tableNo;
    }

    public String getTableCode() {
        return tableCode;
    }

    public boolean isIsUserCanBook() {
        return isUserCanBook;
    }

    public int getTableMaxPerson() {
        return tableMaxPerson;
    }

    public int getTableMinPerson() {
        return tableMinPerson;
    }

    public String getId() {
        return id;
    }

    public String getTableQrcode() {
        return tableQrcode;
    }

    public String getStoreId() {
        return storeId;
    }

    public boolean isBusiness() {
        return isBusiness;
    }
}