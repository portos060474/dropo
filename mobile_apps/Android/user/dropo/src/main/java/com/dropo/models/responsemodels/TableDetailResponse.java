package com.dropo.models.responsemodels;

import com.dropo.models.datamodels.Table;
import com.google.gson.annotations.SerializedName;

public class TableDetailResponse extends IsSuccessResponse {
    @SerializedName("table")
    private Table table;

    public Table getTable() {
        return table;
    }
}
