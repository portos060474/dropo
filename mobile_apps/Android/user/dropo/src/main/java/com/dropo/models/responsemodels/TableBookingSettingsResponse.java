package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.TableSettings;
import com.google.gson.annotations.SerializedName;

public class TableBookingSettingsResponse extends IsSuccessResponse {

    @SerializedName("data")
    private TableSettings tableSettings;

    public TableSettings getTableSettings() {
        return tableSettings;
    }
}