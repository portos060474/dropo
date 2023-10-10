package com.dropo.models.datamodels;

/**
 * Created by elluminati on 18-Dec-17.
 */

public class StoreClosedResult {
    private boolean isStoreClosed;
    private String reOpenAt = "";

    public boolean isStoreClosed() {
        return isStoreClosed;
    }

    public void setStoreClosed(boolean storeClosed) {
        isStoreClosed = storeClosed;
    }

    public String getReOpenAt() {
        return reOpenAt;
    }

    public void setReOpenAt(String reOpenAt) {
        this.reOpenAt = reOpenAt;
    }
}
