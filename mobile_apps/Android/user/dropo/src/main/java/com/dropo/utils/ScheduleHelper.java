package com.dropo.utils;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.text.TextUtils;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TimePicker;

import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.adapter.TimeSlotAdapter;
import com.dropo.models.datamodels.DayTime;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.models.singleton.CurrentBooking;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

/**
 * The type Schedule helper.
 */
public class ScheduleHelper {

    public final SimpleDateFormat dateFormat;
    private final Calendar calendar;
    private final Calendar calendar2;
    private final TimeZone timeZone;
    private final TimeSlotAdapter timeSlotAdapter;
    private DatePickerDialog datePickerDialog;
    private TimePickerDialog timePickerDialog;
    private int selectedHour;
    private int selectedMinute;
    private String scheduleDate = "";
    private String scheduleTime = "";
    private Dialog slotPikerDialog;
    private boolean isDeliverySlotSelect;
    private int selectedPosition = 0;

    /**
     * Instantiates a new Schedule helper.
     *
     * @param timeZoneId the time zone id
     */
    public ScheduleHelper(String timeZoneId) {
        calendar = Calendar.getInstance();
        calendar2 = Calendar.getInstance();
        timeZone = TimeZone.getTimeZone(timeZoneId);
        calendar.setTimeZone(timeZone);
        calendar2.setTimeZone(timeZone);
        calendar.setTime(new Date());
        selectedHour = calendar.get(Calendar.HOUR_OF_DAY);
        selectedMinute = calendar.get(Calendar.MINUTE);
        dateFormat = new SimpleDateFormat(Const.DATE_FORMAT, Locale.US);
        dateFormat.setTimeZone(timeZone);
        timeSlotAdapter = new TimeSlotAdapter();
    }

    /**
     * Open date picker.
     *
     * @param context      the context
     * @param dateListener the date listener
     */
    public void openDatePicker(Context context, final DateListener dateListener, int maxDays, boolean isTableBooking) {
        if (datePickerDialog != null && datePickerDialog.isShowing()) {
            return;
        }

        final int currentYear = calendar.get(Calendar.YEAR);
        final int currentMonth = calendar.get(Calendar.MONTH);
        final int currentDate = calendar.get(Calendar.DAY_OF_MONTH);

        datePickerDialog = new DatePickerDialog(context, AppColor.isDarkTheme(context) ? R.style.DatePickerDark : R.style.DatePickerLight, null, currentYear, currentMonth, currentDate);
        datePickerDialog.setButton(DialogInterface.BUTTON_POSITIVE, context.getResources().getString(R.string.text_select), (dialog, which) -> {
            calendar.set(datePickerDialog.getDatePicker().getYear(), datePickerDialog.getDatePicker().getMonth(), datePickerDialog.getDatePicker().getDayOfMonth());
            calendar.set(Calendar.HOUR_OF_DAY, selectedHour);
            calendar.set(Calendar.MINUTE, selectedMinute);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            scheduleDate = dateFormat.format(calendar.getTime());
            if (dateListener != null) {
                dateListener.onDateSet(calendar);
            }
        });
        long now = System.currentTimeMillis();
        datePickerDialog.getDatePicker().setMinDate(now - 10000);
        Calendar calendar = Calendar.getInstance();
        if (maxDays >= 0 && isTableBooking) {
            calendar.add(Calendar.DAY_OF_MONTH, +maxDays);
        } else {
            calendar.add(Calendar.DAY_OF_MONTH, +7);
        }
        datePickerDialog.getDatePicker().setMaxDate(calendar.getTimeInMillis());
        datePickerDialog.show();
    }

    public void openDatePicker(Context context, final DateListener dateListener, int maxDays, int minDays, boolean isTableBooking) {
        if (datePickerDialog != null && datePickerDialog.isShowing()) {
            return;
        }

        final int currentYear = calendar.get(Calendar.YEAR);
        final int currentMonth = calendar.get(Calendar.MONTH);
        final int currentDate = calendar.get(Calendar.DAY_OF_MONTH);

        datePickerDialog = new DatePickerDialog(context, AppColor.isDarkTheme(context) ? R.style.DatePickerDark : R.style.DatePickerLight, null, currentYear, currentMonth, currentDate);
        datePickerDialog.setButton(DialogInterface.BUTTON_POSITIVE, context.getResources().getString(R.string.text_select), (dialog, which) -> {
            calendar.set(datePickerDialog.getDatePicker().getYear(), datePickerDialog.getDatePicker().getMonth(), datePickerDialog.getDatePicker().getDayOfMonth());
            calendar.set(Calendar.HOUR_OF_DAY, selectedHour);
            calendar.set(Calendar.MINUTE, selectedMinute);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MILLISECOND, 0);
            scheduleDate = dateFormat.format(calendar.getTime());
            if (dateListener != null) {
                dateListener.onDateSet(calendar);
            }
        });
        long now = System.currentTimeMillis();
        datePickerDialog.getDatePicker().setMinDate(now - 10000);
        Calendar calendar = Calendar.getInstance();
        if (maxDays >= 0 && isTableBooking) {
            calendar.add(Calendar.DAY_OF_MONTH, +maxDays);
        } else {
            calendar.add(Calendar.DAY_OF_MONTH, +7);
            datePickerDialog.getDatePicker().setMinDate(now - 10000 + TimeUnit.MINUTES.toMillis(minDays));
        }
        datePickerDialog.getDatePicker().setMaxDate(calendar.getTimeInMillis());
        datePickerDialog.show();
    }


    /**
     * Open time picker.
     *
     * @param context                        the context
     * @param timeListener                   the time listener
     * @param scheduleOrderCreateAfterMinute the schedule order create after minute
     */
    public void openTimePicker(Context context, final TimeListener timeListener, int scheduleOrderCreateAfterMinute) {
        final int currentHour = calendar.get(Calendar.HOUR_OF_DAY);
        final int currentMinute = calendar.get(Calendar.MINUTE);
        if (timePickerDialog != null && timePickerDialog.isShowing()) {
            return;
        }
        timePickerDialog = new TimePickerDialog(context, AppColor.isDarkTheme(context) ? R.style.TimePickerDark : R.style.TimePickerLight, new TimePickerDialog.OnTimeSetListener() {
            @Override
            public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                selectedHour = hourOfDay;
                selectedMinute = minute;
                calendar.set(Calendar.HOUR_OF_DAY, selectedHour);
                calendar.set(Calendar.MINUTE, selectedMinute);
                calendar.set(Calendar.SECOND, 0);
                calendar.set(Calendar.MILLISECOND, 0);
                scheduleTime = calendar.get(Calendar.HOUR_OF_DAY) + ":" + calendar.get(Calendar.MINUTE);
                if (timeListener != null) {
                    timeListener.onTimeSet(calendar);
                }
                isDeliverySlotSelect = false;

            }

        }, currentHour, currentMinute + scheduleOrderCreateAfterMinute, true);
        timePickerDialog.show();
    }


    /**
     * Open slot picker.
     *
     * @param context       the context
     * @param timeListener  the time listener
     * @param deliveryTimes the delivery times
     */
    public void openSlotPicker(Context context, final TimeListener timeListener, List<StoreTime> deliveryTimes, boolean isTableBooking, int timeDelay) {
        if (TextUtils.isEmpty(scheduleDate)) {
            if (isTableBooking) {
                Utils.showToast(context.getString(R.string.error_please_select_schedule_date_for_table_booking), context);
            } else {
                Utils.showToast(context.getString(R.string.msg_please_select_scedule_date), context);
            }
        } else {
            Calendar currentCalender = Calendar.getInstance();
            currentCalender.add(Calendar.MINUTE, timeDelay);
            Calendar serverTimeCalendar = Calendar.getInstance();
            serverTimeCalendar.set(Calendar.DAY_OF_MONTH, calendar.get(Calendar.DAY_OF_MONTH));
            serverTimeCalendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR));
            serverTimeCalendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
            serverTimeCalendar.set(Calendar.HOUR_OF_DAY, calendar.get(Calendar.HOUR_OF_DAY));
            serverTimeCalendar.set(Calendar.MINUTE, calendar.get(Calendar.MINUTE));
            serverTimeCalendar.set(Calendar.SECOND, 0);
            boolean isStoreOpenFullTime = false;
            int dayOfWeek = serverTimeCalendar.get(Calendar.DAY_OF_WEEK) - 1;
            ArrayList<DayTime> dayTimes = new ArrayList<>();
            for (StoreTime timeItem : deliveryTimes) {
                if (timeItem.getDay() == dayOfWeek) {
                    if (timeItem.isStoreOpenFullTime() && !isTableBooking) {
                        isStoreOpenFullTime = true;
                        break;
                    } else if (timeItem.isBookingOpenFullTime() && isTableBooking) {
                        isStoreOpenFullTime = true;
                        break;
                    } else {
                        if (timeItem.getDayTime().isEmpty()) {
                            isStoreOpenFullTime = true;
                        } else {
                            for (DayTime dayTime : timeItem.getDayTime()) {
                                int hr = (isTableBooking ? dayTime.getBookingCloseTimeMinute() : dayTime.getStoreCloseTimeMinute()) / 60;
                                int min = (isTableBooking ? dayTime.getBookingCloseTimeMinute() : dayTime.getStoreCloseTimeMinute()) % 60;
                                dayTime.setStoreCloseTime(hr + ":" + min);
                                int hrOpen = (isTableBooking ? dayTime.getBookingOpenTimeMinute() : dayTime.getStoreOpenTimeMinute()) / 60;
                                int minOpen = (isTableBooking ? dayTime.getBookingOpenTimeMinute() : dayTime.getStoreOpenTimeMinute()) % 60;
                                dayTime.setStoreOpenTime(hrOpen + ":" + minOpen);
                                Calendar closedCalendar = Calendar.getInstance();
                                closedCalendar.setTimeInMillis(serverTimeCalendar.getTimeInMillis());
                                closedCalendar.set(Calendar.HOUR_OF_DAY, hr);
                                closedCalendar.set(Calendar.MINUTE, min);
                                closedCalendar.set(Calendar.SECOND, 0);
                                closedCalendar.set(Calendar.MILLISECOND, 0);
                                if (closedCalendar.after(currentCalender)) {
                                    dayTimes.add(dayTime);
                                }
                            }
                        }
                    }
                    break;
                }
            }
            if (isStoreOpenFullTime) {
                int startTimeFrom = isSameDateTime(CurrentBooking.getInstance().getSchedule().getScheduleCalendar(), Calendar.getInstance()) ? currentCalender.get(Calendar.HOUR_OF_DAY) + 1 : 0;
                for (int i = startTimeFrom; i < 24; i++) {
                    DayTime dayTime = new DayTime();
                    dayTime.setStoreOpenTime(i + ":" + "00");
                    if (i == 23) {
                        dayTime.setStoreCloseTime("00" + ":" + "00");
                    } else {
                        dayTime.setStoreCloseTime((i + 1) + ":" + "00");
                    }
                    dayTimes.add(dayTime);
                }
            }
            slotPikerDialog = new BottomSheetDialog(context);
            slotPikerDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            slotPikerDialog.setContentView(R.layout.dialog_time_slot_picker);
            timeSlotAdapter.setDayTimes(dayTimes, selectedPosition);
            RecyclerView rcvTime = slotPikerDialog.findViewById(R.id.rcvTimeSlotPicker);
            rcvTime.setAdapter(timeSlotAdapter);
            slotPikerDialog.findViewById(R.id.btnConfirmOrder).setOnClickListener(v -> {
                DayTime dayTime = timeSlotAdapter.getSelectedTime();
                selectedPosition = timeSlotAdapter.getSelectedPosition();
                if (dayTime != null) {
                    isDeliverySlotSelect = true;
                    String[] open = dayTime.getStoreOpenTime().split(":");
                    String[] close = dayTime.getStoreCloseTime().split(":");
                    calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(open[0]));
                    calendar.set(Calendar.MINUTE, Integer.parseInt(open[1]));
                    calendar.set(Calendar.SECOND, 0);
                    calendar.set(Calendar.MILLISECOND, 0);

                    calendar2.setTimeInMillis(calendar.getTimeInMillis());
                    calendar2.set(Calendar.HOUR_OF_DAY, Integer.parseInt(close[0]));
                    calendar2.set(Calendar.MINUTE, Integer.parseInt(close[1]));
                    calendar2.set(Calendar.SECOND, 0);
                    calendar.set(Calendar.MILLISECOND, 0);

                    scheduleTime = dayTime.getStoreOpenTime() + " - " + dayTime.getStoreCloseTime();
                    if (timeListener != null) {
                        timeListener.onTimeSet(calendar);
                    }
                    timeSlotAdapter.resetSelection();
                    slotPikerDialog.dismiss();
                }
            });
            slotPikerDialog.findViewById(R.id.btnCancelOrder).setOnClickListener(v -> {
                timeSlotAdapter.resetSelection();
                slotPikerDialog.dismiss();
            });
            WindowManager.LayoutParams params = slotPikerDialog.getWindow().getAttributes();
            params.width = WindowManager.LayoutParams.WRAP_CONTENT;
            slotPikerDialog.getWindow().setAttributes(params);
            slotPikerDialog.show();
        }


    }

    public boolean isSameDateTime(Calendar cal1, Calendar cal2) {
        // compare if is the same ERA, YEAR, DAY, HOUR, MINUTE and SECOND
        return (cal1.get(Calendar.ERA) == cal2.get(Calendar.ERA) && cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) && cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR));
    }

    /**
     * Gets schedule date and start time milli.
     *
     * @return the schedule date and start time milli
     */
    public long getScheduleDateAndStartTimeMilli() {
        return calendar.getTimeInMillis();
    }

    /**
     * Gets schedule date and end time milli.
     *
     * @return the schedule date and end time milli
     */
    public long getScheduleDateAndEndTimeMilli() {
        return calendar2.getTimeInMillis();
    }

    /**
     * Gets schedule calendar.
     *
     * @return the schedule calendar
     */
    public Calendar getScheduleCalendar() {
        return calendar;
    }

    /**
     * Gets current milli as time zone.
     *
     * @return the current milli as time zone
     */
    public long getCurrentMilliAsTimeZone() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeZone(timeZone);
        return calendar.getTimeInMillis();
    }

    /**
     * Gets schedule date.
     *
     * @return the schedule date
     */
    public String getScheduleDate() {
        return scheduleDate;
    }

    /**
     * Gets schedule time.
     *
     * @return the schedule time
     */
    public String getScheduleTime() {
        return scheduleTime;
    }

    public void removeScheduleTime(String scheduleTime) {
        this.scheduleTime = scheduleTime;
        this.selectedHour = 0;
        this.selectedMinute = 0;
        this.selectedPosition = 0;
    }

    /**
     * Is valid schedule time boolean.
     *
     * @param scheduleOrderCreateAfterMinute the schedule order create after minute
     * @return the boolean
     */
    public boolean isValidScheduleTime(long scheduleOrderCreateAfterMinute) {
        long scheduleOrderCreateAfterMilli = scheduleOrderCreateAfterMinute * 60 * 1000; //
        // convert to milli
        return (getScheduleDateAndStartTimeMilli() + scheduleOrderCreateAfterMilli) >= getCurrentMilliAsTimeZone();

    }

    /**
     * Is delivery slot select boolean.
     *
     * @return the boolean
     */
    public boolean isDeliverySlotSelect() {
        return isDeliverySlotSelect;
    }

    /**
     * The interface Date listener.
     */
    public interface DateListener {
        /**
         * On date set.
         *
         * @param calendar the calendar
         */
        void onDateSet(Calendar calendar);
    }

    /**
     * The interface Time listener.
     */
    public interface TimeListener {
        /**
         * On time set.
         *
         * @param calendar the calendar
         */
        void onTimeSet(Calendar calendar);
    }
}