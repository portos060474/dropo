package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.CategoryTimeAdapter;
import com.dropo.store.adapter.StoreDayAdapter;
import com.dropo.store.models.datamodel.CategoryDayTime;
import com.dropo.store.models.datamodel.CategoryTime;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomInputEditText;


import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class CategoryTimeActivity extends BaseActivity {
    public static final String TAG = CategoryTimeActivity.class.getName();

    public boolean isEditable;
    private RecyclerView rcvDay, rcvCategoryTime;
    private StoreDayAdapter storeDayAdapter;
    private CategoryTimeAdapter categoryTimeAdapter;
    private SwitchCompat switchCategory24HrsOpen, switchCategoryOpen;
    private CustomInputEditText etStartTime, etEndTime;
    private CustomButton btnAddTime;
    private ArrayList<CategoryTime> categoryTimeList;
    private ArrayList<CategoryDayTime> dayTimeList;
    private CategoryTime categoryTime;
    private CategoryDayTime dayTime;
    private LinearLayout llSelectTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_category_time);
        categoryTimeList = new ArrayList<>();
        getExtraData();
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_category_timing));
        rcvDay = findViewById(R.id.rcvDay);
        rcvCategoryTime = findViewById(R.id.rvCategoryTime);
        switchCategory24HrsOpen = findViewById(R.id.switchCategory24HrsOpen);
        switchCategoryOpen = findViewById(R.id.switchCategoryOpen);
        etStartTime = findViewById(R.id.etStartTime);
        etEndTime = findViewById(R.id.etEndTime);
        btnAddTime = findViewById(R.id.btnAddTime);
        llSelectTime = findViewById(R.id.llSelectTime);

        switchCategory24HrsOpen.setOnClickListener(this);
        switchCategoryOpen.setOnClickListener(this);
        llSelectTime.setOnClickListener(this);
        etStartTime.setOnClickListener(this);
        etEndTime.setOnClickListener(this);
        btnAddTime.setOnClickListener(this);

        initDayRcv();
        setEnableView(false);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(true, R.drawable.ic_edit);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ivEditMenu) {
            if (!isEditable) {
                isEditable = true;
                setEnableView(true);
                setToolbarEditIcon(false, 0);
                setToolbarSaveIcon(true);
            }
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            Intent intent = new Intent();
            intent.putExtra(Constant.CATEGORY_TIME, getCategoryTimings());
            setResult(Activity.RESULT_OK, intent);
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void setEnableView(boolean isEditable) {
        if (isEditable) {
            switchCategory24HrsOpen.setEnabled(true);
            if (switchCategory24HrsOpen.isChecked()) {
                categoryTime.setCategoryOpen(true);
                switchCategoryOpen.setChecked(categoryTime.isCategoryOpen());
                switchCategoryOpen.setEnabled(false);
                etStartTime.setEnabled(false);
                etEndTime.setEnabled(false);
                btnAddTime.setEnabled(false);
                llSelectTime.setEnabled(false);
            } else {
                switchCategoryOpen.setEnabled(true);
                etStartTime.setEnabled(true);
                etEndTime.setEnabled(true);
                btnAddTime.setEnabled(true);
                llSelectTime.setEnabled(true);
            }
        } else {
            switchCategory24HrsOpen.setEnabled(false);
            switchCategoryOpen.setEnabled(false);
            etStartTime.setEnabled(false);
            etEndTime.setEnabled(false);
            btnAddTime.setEnabled(false);
            llSelectTime.setEnabled(false);
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.switchCategory24HrsOpen) {
            categoryTime.setCategoryOpenFullTime(switchCategory24HrsOpen.isChecked());
            loadCategoryDayData();
        } else if (id == R.id.switchCategoryOpen) {
            categoryTime.setCategoryOpen(switchCategoryOpen.isChecked());
            loadCategoryDayData();
        } else if (id == R.id.etStartTime || id == R.id.etEndTime || id == R.id.llSelectTime) {
            openTimePickerDialog();
        } else if (id == R.id.btnAddTime) {
            if (!TextUtils.isEmpty(etStartTime.getText().toString()) && !TextUtils.isEmpty(etEndTime.getText().toString())) {
                dayTimeList.add(dayTime);
                categoryTimeAdapter.setCategoryTimeList(dayTimeList);
                categoryTimeAdapter.notifyDataSetChanged();
                etEndTime.getText().clear();
                etStartTime.getText().clear();
            } else {
                Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_valid_time));
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initDayRcv() {
        ArrayList<String> dayArrayList = new ArrayList<>();
        dayArrayList.add(getResources().getString(R.string.text_sun));
        dayArrayList.add(getResources().getString(R.string.text_mon));
        dayArrayList.add(getResources().getString(R.string.text_tue));
        dayArrayList.add(getResources().getString(R.string.text_wed));
        dayArrayList.add(getResources().getString(R.string.text_thu));
        dayArrayList.add(getResources().getString(R.string.text_fri));
        dayArrayList.add(getResources().getString(R.string.text_sat));
        storeDayAdapter = new StoreDayAdapter(this, dayArrayList);
        rcvDay.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        rcvDay.setAdapter(storeDayAdapter);
        rcvDay.addOnItemTouchListener(new RecyclerTouchListener(this, rcvDay, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                storeDayAdapter.setSelected(position);
                storeDayAdapter.notifyDataSetChanged();
                categoryTime = categoryTimeList.get(position);
                loadCategoryDayData();
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));

        if (!categoryTimeList.isEmpty()) {
            storeDayAdapter.setSelected(0);
            storeDayAdapter.notifyDataSetChanged();
            categoryTime = categoryTimeList.get(0);
            loadCategoryDayData();
        }
    }

    private void openTimePickerDialog() {
        final DecimalFormat numberFormat = new DecimalFormat("00");
        Calendar mCurrentTime = Calendar.getInstance();
        int hour = mCurrentTime.get(Calendar.HOUR_OF_DAY);
        int minute = mCurrentTime.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            dayTime = new CategoryDayTime();
            dayTime.setCategoryOpenTime(numberFormat.format(selectedHour).concat(":").concat(numberFormat.format(selectedMinute)));

            if (isValidOpeningTime(dayTime)) {
                openCloseTimePickerDialog(numberFormat.format(selectedHour), numberFormat.format(selectedMinute), dayTime);
            } else {
                Utilities.showToast(CategoryTimeActivity.this, getString(R.string.text_not_valid_Time));
            }
        }, hour, minute, true);
        timePickerDialog.setCustomTitle(getCustomTitleView(getString(R.string.text_opening_time), false, null));
        timePickerDialog.show();
    }

    private View getCustomTitleView(String dialogTitle, boolean showPreviousTime, String previousTime) {
        LayoutInflater inflater = this.getLayoutInflater();
        View dialogTitleView = inflater.inflate(R.layout.custom_time_picker_title, null);
        TextView titleView = dialogTitleView.findViewById(R.id.tvTimePickerTitle);
        TextView openingTime = dialogTitleView.findViewById(R.id.tvTimePickerOpeningTime);
        titleView.setText(dialogTitle);
        if (showPreviousTime) {
            openingTime.setVisibility(View.VISIBLE);
            openingTime.setText(String.format("%s %s", getString(R.string.text_opening_time), previousTime));
        }

        return dialogTitleView;
    }

    private void openCloseTimePickerDialog(final String openingTimeHours, final String openingTimeMinute, final CategoryDayTime categoryDayTime) {
        final DecimalFormat numberFormat = new DecimalFormat("00");
        Calendar mCurrentTime = Calendar.getInstance();
        int hour = mCurrentTime.get(Calendar.HOUR_OF_DAY);
        int minute = mCurrentTime.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            categoryDayTime.setCategoryCloseTime(numberFormat.format(selectedHour).concat(":").concat(numberFormat.format(selectedMinute)));
            if (isValidClosingTime(categoryDayTime)) {
                etStartTime.setText(categoryDayTime.getCategoryOpenTime());
                etEndTime.setText(categoryDayTime.getCategoryCloseTime());
            } else {
                Utilities.showToast(CategoryTimeActivity.this, getString(R.string.text_not_valid_Time));
            }
        }, hour, minute, true);

        timePickerDialog.setCustomTitle(getCustomTitleView(getString(R.string.text_closing_time), true, openingTimeHours + ":" + openingTimeMinute));
        timePickerDialog.show();
    }

    private boolean isValidOpeningTime(CategoryDayTime categoryDayTime) {
        if (!dayTimeList.isEmpty()) {
            for (int i = 0; i < dayTimeList.size(); i++) {
                try {
                    String oldStoreOpenTime = dayTimeList.get(i).getCategoryOpenTime();
                    Date oldOpenTime = parseContent.timeFormat2.parse(oldStoreOpenTime);

                    String oldStoreCloseTime = dayTimeList.get(i).getCategoryCloseTime();
                    Date oldClosedTime = parseContent.timeFormat2.parse(oldStoreCloseTime);

                    String openTime = categoryDayTime.getCategoryOpenTime();
                    Date newOpenTime = parseContent.timeFormat2.parse(openTime);

                    if (newOpenTime.after(oldOpenTime) && newOpenTime.before(oldClosedTime)) {
                        return false;
                    }
                } catch (ParseException e) {
                    Utilities.handleThrowable(TAG, e);
                }

            }
        }
        return true;
    }

    private boolean isValidClosingTime(CategoryDayTime categoryDayTime) {
        if (dayTimeList.isEmpty()) {
            try {
                String storeOpenTime = categoryDayTime.getCategoryOpenTime();
                Date selectedOpenTime = parseContent.timeFormat2.parse(storeOpenTime);

                String storeCloseTime = categoryDayTime.getCategoryCloseTime();
                Date newClosedTime = parseContent.timeFormat2.parse(storeCloseTime);

                return (newClosedTime.after(selectedOpenTime));
            } catch (ParseException e) {
                Utilities.handleException(TAG, e);
            }
        } else {
            for (int i = 0; i < dayTimeList.size(); i++) {
                try {
                    String oldStoreOpenTime = dayTimeList.get(i).getCategoryOpenTime();
                    Date oldOpenTime = parseContent.timeFormat2.parse(oldStoreOpenTime);

                    String oldStoreCloseTime = dayTimeList.get(i).getCategoryCloseTime();
                    Date oldClosedTime = parseContent.timeFormat2.parse(oldStoreCloseTime);

                    String storeOpenTime = categoryDayTime.getCategoryOpenTime();
                    Date selectedOpenTime = parseContent.timeFormat2.parse(storeOpenTime);

                    String storeCloseTime = categoryDayTime.getCategoryCloseTime();
                    Date newClosedTime = parseContent.timeFormat2.parse(storeCloseTime);

                    if (newClosedTime.after(selectedOpenTime)) {
                        if (newClosedTime.after(oldOpenTime) && newClosedTime.before(oldClosedTime)) {
                            return false;
                        } else if (selectedOpenTime.before(oldOpenTime) && newClosedTime.after(oldClosedTime)) {
                            return false;
                        }
                    } else {
                        return false;
                    }
                } catch (ParseException e) {
                    Utilities.handleThrowable(TAG, e);
                }
            }
        }
        return true;
    }

    public void deleteSpecificTime(CategoryDayTime categoryDayTime) {
        dayTimeList.remove(categoryDayTime);
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            categoryTimeList = getIntent().getExtras().getParcelableArrayList(Constant.CATEGORY_TIME);
            final DecimalFormat numberFormat = new DecimalFormat("00");
            // minute to string
            for (CategoryTime time : categoryTimeList) {
                if (time.getDayTime() != null && !time.getDayTime().isEmpty()) {
                    for (CategoryDayTime dayTime : time.getDayTime()) {
                        int hr = dayTime.getCategoryOpenTimeMinute() / 60;  // get hour from minute
                        int min = dayTime.getCategoryOpenTimeMinute() % 60; // get minute
                        dayTime.setCategoryOpenTime(numberFormat.format(hr).concat(":").concat(numberFormat.format(min)));
                        hr = dayTime.getCategoryCloseTimeMinute() / 60;
                        min = dayTime.getCategoryCloseTimeMinute() % 60;
                        dayTime.setCategoryCloseTime(numberFormat.format(hr).concat(":").concat(numberFormat.format(min)));
                    }
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    public void loadCategoryDayData() {
        dayTimeList = (ArrayList<CategoryDayTime>) categoryTime.getDayTime();
        if (categoryTimeAdapter == null) {
            categoryTimeAdapter = new CategoryTimeAdapter(dayTimeList, this);
            rcvCategoryTime.setLayoutManager(new LinearLayoutManager(this));
            rcvCategoryTime.setAdapter(categoryTimeAdapter);
            rcvCategoryTime.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
        } else {
            categoryTimeAdapter.setCategoryTimeList(dayTimeList);
            categoryTimeAdapter.notifyDataSetChanged();
        }
        switchCategory24HrsOpen.setChecked(categoryTime.isCategoryOpenFullTime());
        switchCategoryOpen.setChecked(categoryTime.isCategoryOpen());
        setEnableView(isEditable);
    }

    private ArrayList<CategoryTime> getCategoryTimings() {
        ArrayList<CategoryTime> categoryTimeFinalList = new ArrayList<>();
        for (CategoryTime time : categoryTimeList) {
            CategoryTime categoryTime = new CategoryTime();
            categoryTime.setDay(time.getDay());
            categoryTime.setDayTime(time.getDayTime());
            categoryTime.setCategoryOpen(time.isCategoryOpen());
            categoryTime.setCategoryOpenFullTime(time.isCategoryOpenFullTime());
            ArrayList<CategoryDayTime> dayTimes = new ArrayList<>();
            for (CategoryDayTime dayTime : time.getDayTime()) {
                CategoryDayTime dayTime1 = new CategoryDayTime();
                dayTime1.setCategoryOpenTime(dayTime.getCategoryOpenTime());
                dayTime1.setCategoryCloseTime(dayTime.getCategoryCloseTime());
                dayTimes.add(dayTime1);
            }
            categoryTime.setDayTime(dayTimes);
            categoryTimeFinalList.add(categoryTime);
        }

        for (CategoryTime time : categoryTimeFinalList) {
            if (time.getDayTime() != null && !time.getDayTime().isEmpty()) {
                for (CategoryDayTime dayTime : time.getDayTime()) {
                    String[] open = dayTime.getCategoryOpenTime().split(":");
                    String[] closed = dayTime.getCategoryCloseTime().split(":");
                    int min = Integer.parseInt(open[0]) * 60 + Integer.parseInt(open[1]); // get
                    // minute
                    // from hr
                    dayTime.setCategoryOpenTimeMinute(min);
                    min = Integer.parseInt(closed[0]) * 60 + Integer.parseInt(closed[1]);
                    dayTime.setCategoryCloseTimeMinute(min);
                    dayTime.setCategoryOpenTime(null);
                    dayTime.setCategoryCloseTime(null);
                }
            }
        }

        return categoryTimeFinalList;
    }
}