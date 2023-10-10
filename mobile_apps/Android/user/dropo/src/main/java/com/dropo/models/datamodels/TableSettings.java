package com.dropo.models.datamodels;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

public class TableSettings {

    @SerializedName("booking_fees")
    private double bookingFees;

    @SerializedName("is_table_reservation_with_order")
    private boolean isTableReservationWithOrder;

    @SerializedName("is_cancellation_charges_for_without_order")
    private boolean isCancellationChargesForWithoutOrder;

    @SerializedName("is_table_reservation")
    private boolean isTableReservation;

    @SerializedName("booking_time")
    private List<StoreTime> bookingTime;

    @SerializedName("is_cancellation_charges_for_with_order")
    private boolean isCancellationChargesForWithOrder;

    @SerializedName("reservation_person_min_seat")
    private int reservationPersonMinSeat;

    @SerializedName("table_reservation_time")
    private int tableReservationTime;

    @SerializedName("reservation_person_max_seat")
    private int reservationPersonMaxSeat;

    @SerializedName("reservation_max_days")
    private int reservationMaxDays;

    @SerializedName("_id")
    private String id;

    @SerializedName("is_set_booking_fees")
    private boolean isSetBookingFees;

    @SerializedName("table_list")
    private List<Table> tableList;

    public double getBookingFees() {
        return bookingFees;
    }

    public boolean isTableReservationWithOrder() {
        return isTableReservationWithOrder;
    }

    public boolean isCancellationChargesForWithoutOrder() {
        return isCancellationChargesForWithoutOrder;
    }

    public boolean isTableReservation() {
        return isTableReservation;
    }

    public List<StoreTime> getBookingTime() {
        return bookingTime;
    }

    public boolean isCancellationChargesForWithOrder() {
        return isCancellationChargesForWithOrder;
    }

    public int getReservationPersonMinSeat() {
        return reservationPersonMinSeat;
    }

    public int getTableReservationTime() {
        return tableReservationTime;
    }

    public int getReservationPersonMaxSeat() {
        return reservationPersonMaxSeat;
    }

    public int getReservationMaxDays() {
        return reservationMaxDays;
    }

    public String getId() {
        return id;
    }

    public boolean isSetBookingFees() {
        return isSetBookingFees;
    }

    public List<Table> getTableList() {
        if (tableList == null) {
            return new ArrayList<>();
        }
        return tableList;
    }
}