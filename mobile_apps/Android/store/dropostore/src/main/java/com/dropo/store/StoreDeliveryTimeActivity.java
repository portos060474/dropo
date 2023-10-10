package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.StoreDayAdapter;
import com.dropo.store.adapter.StoreDeliveryTimeAdapter;
import com.dropo.store.models.datamodel.DayTime;
import com.dropo.store.models.datamodel.StoreTime;
import com.dropo.store.models.datamodel.UpdateStoreTime;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StoreDeliveryTimeActivity extends BaseActivity {

    private final String TAG = this.getClass().getSimpleName();
    public boolean isEditable;
    private RecyclerView rcvDay, rcvStoreTime;
    private StoreDayAdapter storeDayAdapter;
    private StoreDeliveryTimeAdapter storeTimeAdapter;
    private ArrayList<String> dayArrayList;
    private SwitchCompat switchStore24HrsOpen, switchStoreOpen;
    private CustomInputEditText etStartTime, etEndTime;
    private CustomButton btnAddTime;
    private ArrayList<StoreTime> storeTimeList;
    private ArrayList<DayTime> dayTimeList;
    private StoreTime storeTime;
    private DayTime dayTime;
    private LinearLayout llSelectTime;
    private BottomSheetDialog dialog;
    private EditText etVerifyPassword;
    private CustomTextView tvStoreOpen;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_time);
        storeTimeList = new ArrayList<>();
        getExtraData();
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_store_delivery_time));
        rcvDay = findViewById(R.id.rcvDay);
        rcvStoreTime = findViewById(R.id.rvStoreTime);
        switchStore24HrsOpen = findViewById(R.id.switchStore24HrsOpen);
        switchStoreOpen = findViewById(R.id.switchStoreOpen);
        etStartTime = findViewById(R.id.etStartTime);
        etEndTime = findViewById(R.id.etEndTime);
        btnAddTime = findViewById(R.id.btnAddTime);
        llSelectTime = findViewById(R.id.llSelectTime);
        tvStoreOpen = findViewById(R.id.tvStoreOpen);
        tvStoreOpen.setText(getString(R.string.text_provide_pickup_delivery));
        switchStore24HrsOpen.setOnClickListener(this);
        switchStoreOpen.setOnClickListener(this);
        llSelectTime.setOnClickListener(this);
        btnAddTime.setOnClickListener(this);
        etStartTime.setOnClickListener(this);
        etEndTime.setOnClickListener(this);
        initDayRcv();
        setEnableView(false);
    }

    private void setEnableView(boolean isEditable) {
        if (isEditable) {
            switchStore24HrsOpen.setEnabled(true);
            if (switchStore24HrsOpen.isChecked()) {
                storeTime.setStoreOpen(true);
                switchStoreOpen.setChecked(storeTime.isStoreOpen());
                switchStoreOpen.setEnabled(false);
                etStartTime.setEnabled(false);
                etEndTime.setEnabled(false);
                btnAddTime.setEnabled(false);
                llSelectTime.setEnabled(false);
            } else {
                switchStoreOpen.setEnabled(true);
                etStartTime.setEnabled(true);
                etEndTime.setEnabled(true);
                btnAddTime.setEnabled(true);
                llSelectTime.setEnabled(true);
            }
        } else {
            switchStore24HrsOpen.setEnabled(false);
            switchStoreOpen.setEnabled(false);
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
        if (id == R.id.switchStore24HrsOpen) {
            storeTime.setStoreOpenFullTime(switchStore24HrsOpen.isChecked());
            loadStoreDayData();
        } else if (id == R.id.switchStoreOpen) {
            storeTime.setStoreOpen(switchStoreOpen.isChecked());
            loadStoreDayData();
        } else if (id == R.id.etStartTime || id == R.id.etEndTime || id == R.id.llSelectTime) {
            openTimePickerDialog();
        } else if (id == R.id.btnAddTime) {
            if (!TextUtils.isEmpty(etStartTime.getText().toString()) && !TextUtils.isEmpty(etEndTime.getText().toString())) {
                dayTimeList.add(dayTime);
                storeTimeAdapter.setStoreTimeList(dayTimeList);
                storeTimeAdapter.notifyDataSetChanged();
                etEndTime.getText().clear();
                etStartTime.getText().clear();
            } else {
                Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_valid_time));
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initDayRcv() {
        dayArrayList = new ArrayList<>();
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
                storeTime = storeTimeList.get(position);
                loadStoreDayData();
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
        if (!storeTimeList.isEmpty()) {
            storeDayAdapter.setSelected(0);
            storeDayAdapter.notifyDataSetChanged();
            storeTime = storeTimeList.get(0);
            loadStoreDayData();
        }
    }

    private void openTimePickerDialog() {
        final DecimalFormat numberFormat = new DecimalFormat("00");
        Calendar mCurrentTime = Calendar.getInstance();
        int hour = mCurrentTime.get(Calendar.HOUR_OF_DAY);
        int minute = mCurrentTime.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            dayTime = new DayTime();
            dayTime.setStoreOpenTime(numberFormat.format(selectedHour).concat(":").concat(numberFormat.format(selectedMinute)));

            if (isValidOpeningTime(dayTime)) {
                openCloseTimePickerDialog(numberFormat.format(selectedHour), numberFormat.format(selectedMinute), dayTime);
            } else {
                Utilities.showToast(StoreDeliveryTimeActivity.this, getString(R.string.text_not_valid_Time));
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

    private void openCloseTimePickerDialog(final String openingTimeHours, final String openingTimeMinute, final DayTime storeTime) {
        final DecimalFormat numberFormat = new DecimalFormat("00");
        Calendar mCurrentTime = Calendar.getInstance();
        int hour = mCurrentTime.get(Calendar.HOUR_OF_DAY);
        int minute = mCurrentTime.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            storeTime.setStoreCloseTime(numberFormat.format(selectedHour).concat(":").concat(numberFormat.format(selectedMinute)));
            if (isValidClosingTime(storeTime)) {
                etStartTime.setText(storeTime.getStoreOpenTime());
                etEndTime.setText(storeTime.getStoreCloseTime());
            } else {
                Utilities.showToast(StoreDeliveryTimeActivity.this, getString(R.string.text_not_valid_Time));
            }
        }, hour, minute, true);
        timePickerDialog.setCustomTitle(getCustomTitleView(getString(R.string.text_closing_time), true, openingTimeHours + ":" + openingTimeMinute));

        timePickerDialog.show();
    }

    private boolean isValidOpeningTime(DayTime storeTime) {
        if (dayTimeList.isEmpty()) {
            return true;
        } else {
            for (int i = 0; i < dayTimeList.size(); i++) {
                try {
                    String oldStoreOpenTime = dayTimeList.get(i).getStoreOpenTime();
                    Date oldOpenTime = parseContent.timeFormat2.parse(oldStoreOpenTime);

                    String oldStoreCloseTime = dayTimeList.get(i).getStoreCloseTime();
                    Date oldClosedTime = parseContent.timeFormat2.parse(oldStoreCloseTime);

                    String openTime = storeTime.getStoreOpenTime();
                    Date newOpenTime = parseContent.timeFormat2.parse(openTime);

                    if (newOpenTime.after(oldOpenTime) && newOpenTime.before(oldClosedTime)) {
                        return false;
                    }
                } catch (ParseException e) {
                    Utilities.handleThrowable(TAG, e);
                }
            }
            return true;
        }
    }

    private boolean isValidClosingTime(DayTime storeTime) {
        if (dayTimeList.isEmpty()) {
            try {
                String storeOpenTime = storeTime.getStoreOpenTime();
                Date selectedOpenTime = parseContent.timeFormat2.parse(storeOpenTime);

                String storeCloseTime = storeTime.getStoreCloseTime();
                Date newClosedTime = parseContent.timeFormat2.parse(storeCloseTime);

                return (newClosedTime.after(selectedOpenTime));
            } catch (ParseException e) {
                Utilities.handleException("time_compare", e);
            }
        } else {
            for (int i = 0; i < dayTimeList.size(); i++) {
                try {
                    String oldStoreOpenTime = dayTimeList.get(i).getStoreOpenTime();
                    Date oldOpenTime = parseContent.timeFormat2.parse(oldStoreOpenTime);

                    String oldStoreCloseTime = dayTimeList.get(i).getStoreCloseTime();
                    Date oldClosedTime = parseContent.timeFormat2.parse(oldStoreCloseTime);

                    String storeOpenTime = storeTime.getStoreOpenTime();
                    Date selectedOpenTime = parseContent.timeFormat2.parse(storeOpenTime);

                    String storeCloseTime = storeTime.getStoreCloseTime();
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

    public void deleteSpecificTime(DayTime storeTime) {
        dayTimeList.remove(storeTime);
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            storeTimeList = getIntent().getExtras().getParcelableArrayList(Constant.STORE_TIME);
            final DecimalFormat numberFormat = new DecimalFormat("00");
            // minute to string
            for (StoreTime time : storeTimeList) {
                if (time.getDayTime() != null && !time.getDayTime().isEmpty()) {
                    for (DayTime dayTime : time.getDayTime()) {
                        int hr = dayTime.getStoreOpenTimeMinute() / 60;  // get hour from minute
                        int min = dayTime.getStoreOpenTimeMinute() % 60; // get minute
                        dayTime.setStoreOpenTime(numberFormat.format(hr).concat(":").concat(numberFormat.format(min)));
                        hr = dayTime.getStoreCloseTimeMinute() / 60;
                        min = dayTime.getStoreCloseTimeMinute() % 60;
                        dayTime.setStoreCloseTime(numberFormat.format(hr).concat(":").concat(numberFormat.format(min)));
                    }
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    public void loadStoreDayData() {
        dayTimeList = (ArrayList<DayTime>) storeTime.getDayTime();
        if (storeTimeAdapter == null) {
            storeTimeAdapter = new StoreDeliveryTimeAdapter(dayTimeList, this);
            rcvStoreTime.setLayoutManager(new LinearLayoutManager(this));
            rcvStoreTime.setAdapter(storeTimeAdapter);
            rcvStoreTime.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
        } else {
            storeTimeAdapter.setStoreTimeList(dayTimeList);
            storeTimeAdapter.notifyDataSetChanged();
        }
        switchStore24HrsOpen.setChecked(storeTime.isStoreOpenFullTime());
        switchStoreOpen.setChecked(storeTime.isStoreOpen());
        setEnableView(isEditable);
    }

    private void updateStoreTime(String pass, String socialId) {
        Utilities.showCustomProgressDialog(this, false);
        ArrayList<StoreTime> storeTimeFinalList = new ArrayList<>();
        for (StoreTime time : storeTimeList) {
            StoreTime storeTime = new StoreTime();
            storeTime.setDay(time.getDay());
            storeTime.setDayTime(time.getDayTime());
            storeTime.setStoreOpen(time.isStoreOpen());
            storeTime.setStoreOpenFullTime(time.isStoreOpenFullTime());
            ArrayList<DayTime> dayTimes = new ArrayList<>();
            for (DayTime dayTime : time.getDayTime()) {
                DayTime dayTime1 = new DayTime();
                dayTime1.setStoreCloseTime(dayTime.getStoreCloseTime());
                dayTime1.setStoreOpenTime(dayTime.getStoreOpenTime());
                dayTimes.add(dayTime1);
            }
            storeTime.setDayTime(dayTimes);
            storeTimeFinalList.add(storeTime);
        }
        for (StoreTime time : storeTimeFinalList) {
            if (time.getDayTime() != null && !time.getDayTime().isEmpty()) {
                for (DayTime dayTime : time.getDayTime()) {
                    String[] closed = dayTime.getStoreCloseTime().split(":");
                    String[] open = dayTime.getStoreOpenTime().split(":");
                    int min = Integer.parseInt(open[0]) * 60 + Integer.parseInt(open[1]); // get
                    // minute
                    // from hr
                    dayTime.setStoreOpenTimeMinute(min);
                    min = Integer.parseInt(closed[0]) * 60 + Integer.parseInt(closed[1]);
                    dayTime.setStoreCloseTimeMinute(min);
                    dayTime.setStoreOpenTime(null);
                    dayTime.setStoreCloseTime(null);
                }
            }

        }
        UpdateStoreTime updateStoreTime = new UpdateStoreTime();
        updateStoreTime.setStoreId(preferenceHelper.getStoreId());
        updateStoreTime.setServerToken(preferenceHelper.getServerToken());
        updateStoreTime.setStoreDeliveryTime(storeTimeFinalList);
        updateStoreTime.setOldPassword(pass);
        updateStoreTime.setSocialId(socialId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.updateStoreTime(ApiClient.makeGSONRequestBody(updateStoreTime));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        ParseContent.getInstance().showMessage(StoreDeliveryTimeActivity.this, response.body().getStatusPhrase());
                        setResult(Activity.RESULT_OK);
                        finish();
                    } else {
                        ParseContent.getInstance().showErrorMessage(StoreDeliveryTimeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void showVerificationDialog() {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            if (dialog == null) {
                dialog = new BottomSheetDialog(this);
                dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);

                dialog.setContentView(R.layout.dialog_account_verification);
                etVerifyPassword = dialog.findViewById(R.id.etCurrentPassword);

                dialog.findViewById(R.id.btnPositive).setOnClickListener(v -> {
                    if (!TextUtils.isEmpty(etVerifyPassword.getText().toString())) {
                        dialog.dismiss();
                        updateStoreTime(etVerifyPassword.getText().toString(), "");
                    } else {
                        etVerifyPassword.setError(getString(R.string.msg_empty_password));
                    }

                });
                dialog.findViewById(R.id.btnNegative).setOnClickListener(v -> dialog.dismiss());
                dialog.setOnDismissListener(dialog1 -> dialog = null);

                WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
                params.width = WindowManager.LayoutParams.MATCH_PARENT;
                dialog.show();
            }
        } else {
            updateStoreTime("", preferenceHelper.getSocialId());
        }
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
            showVerificationDialog();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}