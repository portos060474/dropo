package com.dropo.component;

import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.RadioButton;

import androidx.annotation.NonNull;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.adapter.TableAdapter;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.StoreTime;
import com.dropo.models.datamodels.Table;
import com.dropo.models.datamodels.TableSettings;
import com.dropo.models.responsemodels.TableBookingSettingsResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.ScheduleHelper;
import com.dropo.utils.SpacesItemDecoration;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class DialogTableBooking extends BottomSheetDialog implements View.OnClickListener {

    private final List<StoreTime> storeDeliveryTimes = new ArrayList<>();
    private final RecyclerView rcvNoOfPeople;
    private final RecyclerView rcvTable;
    private final Store store;
    private final EditText tvScheduleDate;
    private final EditText tvScheduleTime;
    private final CustomFontButton btnBookTable;
    private final CustomFontTextView tvNoTable;
    private final PreferenceHelper preferenceHelper;
    private final ParseContent parseContent;
    private final TableAdapter peopleAdapter;
    private final TableAdapter tableAdapter;
    private final RadioButton rbBookAtRest;
    private final RadioButton rbBookNow;
    private final Context context;
    private final Table tableDetail;
    public CurrentBooking currentBooking;
    private TableSettings tableSettings;
    private List<Table> tableList;

    public DialogTableBooking(Context context, PreferenceHelper preferenceHelper, ParseContent parseContent, Store store, Table tableDetail, String serverTime) {
        super(context);
        this.context = context;
        this.store = store;
        this.preferenceHelper = preferenceHelper;
        this.parseContent = parseContent;
        this.tableDetail = tableDetail;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_table_booking);
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(v -> dismiss());
        findViewById(R.id.btnBookTable).setOnClickListener(this);
        CustomFontTextView tvReopenAt = findViewById(R.id.tvReopenAt);
        tvNoTable = findViewById(R.id.tvNoTable);
        btnBookTable = findViewById(R.id.btnBookTable);
        rcvNoOfPeople = findViewById(R.id.rcvNoOfPeople);
        rcvTable = findViewById(R.id.rcvTable);
        rbBookNow = findViewById(R.id.rbBookNow);
        rbBookAtRest = findViewById(R.id.rbBookAtRest);
        tvScheduleDate = findViewById(R.id.tvScheduleDate);
        tvScheduleTime = findViewById(R.id.tvScheduleTime);
        tvScheduleDate.setOnClickListener(this);
        tvScheduleTime.setOnClickListener(this);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(params);
        getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
        setCancelable(false);
        currentBooking = CurrentBooking.getInstance();
        if (currentBooking.getSchedule() == null) {
            ScheduleHelper scheduleHelper = new ScheduleHelper(CurrentBooking.getInstance().getTimeZone());
            currentBooking.setSchedule(scheduleHelper);
        }
        currentBooking.setBookTableForFuture(true);

        ArrayList<String> peopleNumber = new ArrayList<>();
        peopleNumber.add("1");
        peopleNumber.add("2");
        peopleNumber.add("3");
        peopleNumber.add("4");
        peopleNumber.add("5");
        peopleNumber.add("6");
        peopleNumber.add("7");
        peopleNumber.add("8");
        peopleNumber.add("9");
        peopleNumber.add("10");
        peopleAdapter = new TableAdapter(peopleNumber) {
            @Override
            public void onChooseNumber(String number, int position) {
                setNumberOfPeople(number);
                updateUIButton();
            }
        };
        rcvNoOfPeople.addItemDecoration(new SpacesItemDecoration((int) context.getResources().getDimension(R.dimen.card_view_space_8dp), RecyclerView.HORIZONTAL));
        rcvTable.addItemDecoration(new SpacesItemDecoration((int) context.getResources().getDimension(R.dimen.card_view_space_8dp), RecyclerView.HORIZONTAL));
        rcvNoOfPeople.setAdapter(peopleAdapter);

        tableList = new ArrayList<>();
        tableAdapter = new TableAdapter(new ArrayList<>()) {
            @Override
            public void onChooseNumber(String number, int position) {
                if (TextUtils.isEmpty(peopleAdapter.getSelected())) {
                    Utils.showToast(getContext().getString(R.string.error_choose_number_of_people), getContext());
                    tableAdapter.resetTable();
                }
                updateUIButton();
            }
        };
        rcvTable.setAdapter(tableAdapter);
        getBookingSettings();

    }

    private void setNumberOfPeople(String number) {
        int people = Integer.parseInt(number);
        if (tableDetail == null || TextUtils.isEmpty(tableDetail.getId())) {
            ArrayList<String> tablesNumber = new ArrayList<>();
            tableList.clear();
            for (Table table : tableSettings.getTableList()) {
                if (people >= table.getTableMinPerson() && people <= table.getTableMaxPerson() && table.isIsUserCanBook() && table.isBusiness()) {
                    tablesNumber.add(table.getTableNo());
                    tableList.add(table);
                }
            }
            tableAdapter.setTables(tablesNumber);
            ConstraintLayout.LayoutParams layoutParams = (ConstraintLayout.LayoutParams) findViewById(R.id.tvOrder).getLayoutParams();
            if (tablesNumber.isEmpty()) {
                tvNoTable.setVisibility(View.VISIBLE);
                rcvTable.setVisibility(View.GONE);
                layoutParams.topToBottom = tvNoTable.getId();
            } else {
                rcvTable.setVisibility(View.VISIBLE);
                layoutParams.topToBottom = rcvTable.getId();
                tvNoTable.setVisibility(View.GONE);
            }
            findViewById(R.id.tvOrder).setLayoutParams(layoutParams);
        }
    }

    public abstract void doWithEnable(Store store, int tableBookingType);

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnBookTable) {
            if (TextUtils.isEmpty(peopleAdapter.getSelected())) {
                Utils.showToast(getContext().getString(R.string.error_choose_number_of_people), getContext());
            } else if (TextUtils.isEmpty(tableAdapter.getSelected())) {
                Utils.showToast(getContext().getString(R.string.error_choose_table_number), getContext());
            } else if (!currentBooking.isBookTableForFuture()) {
                currentBooking.setNumberOfPerson(Integer.parseInt(peopleAdapter.getSelected()));
                currentBooking.setTableNumber(Integer.parseInt(tableAdapter.getSelected()));
                currentBooking.setTableId(tableList.get(tableAdapter.getSelectedPosition()).getId());
                if (rbBookNow.isChecked()) {
                    currentBooking.setTableBookingType(Const.TableBookingType.BOOK_WITH_ORDER);
                } else {
                    currentBooking.setTableBookingType(Const.TableBookingType.BOOK_AT_REST);
                }
                currentBooking.setSelectedStoreId(store.getId());
                currentBooking.setDeliveryType(Const.DeliveryType.TABLE_BOOKING);
                currentBooking.setBookingFee(tableSettings.getBookingFees());
                doWithEnable(store, currentBooking.getTableBookingType());
            } else if (currentBooking.getSchedule().isValidScheduleTime(store.getScheduleOrderCreateAfterMinute()) && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleDate()) && !TextUtils.isEmpty(currentBooking.getSchedule().getScheduleTime())) {
                currentBooking.setNumberOfPerson(Integer.parseInt(peopleAdapter.getSelected()));
                currentBooking.setTableNumber(Integer.parseInt(tableAdapter.getSelected()));
                currentBooking.setTableId(tableList.get(tableAdapter.getSelectedPosition()).getId());
                if (rbBookNow.isChecked()) {
                    currentBooking.setTableBookingType(Const.TableBookingType.BOOK_WITH_ORDER);
                } else {
                    currentBooking.setTableBookingType(Const.TableBookingType.BOOK_AT_REST);
                }
                currentBooking.setSelectedStoreId(store.getId());
                currentBooking.setDeliveryType(Const.DeliveryType.TABLE_BOOKING);
                currentBooking.setBookingFee(tableSettings.getBookingFees());
                doWithEnable(store, currentBooking.getTableBookingType());
            } else {
                if (TextUtils.isEmpty(tvScheduleDate.getText().toString().trim())) {
                    Utils.showToast(getContext().getString(R.string.msg_plz_select_schedule_date), getContext());
                } else {
                    Utils.showToast(getContext().getString(R.string.msg_plz_select_schedule_time), getContext());
                }
            }
        } else if (id == R.id.tvScheduleDate) {
            openDatePicker();
        } else if (id == R.id.tvScheduleTime) {
            if (TextUtils.isEmpty(tvScheduleDate.getText().toString().trim())) {
                Utils.showToast(getContext().getString(R.string.msg_plz_select_schedule_date), getContext());
            } else {
                openTimePicker();
            }
        }
    }

    private void openDatePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openDatePicker(getContext(), calendar -> {
                tvScheduleDate.setText(currentBooking.getSchedule().getScheduleDate());
                updateUIButton();
                currentBooking.getSchedule().removeScheduleTime("");
                tvScheduleTime.setText("");
            }, tableSettings != null ? tableSettings.getReservationMaxDays() : 0, true);
        }
    }

    private void openTimePicker() {
        if (currentBooking.isFutureOrder()) {
            currentBooking.getSchedule().openSlotPicker(getContext(), calendar -> {
                tvScheduleTime.setText(currentBooking.getSchedule().getScheduleTime());
                updateUIButton();
            }, storeDeliveryTimes, true, 0);
        }
    }

    private void updateUIButton() {
        if (TextUtils.isEmpty(tvScheduleDate.getText().toString().trim()) || TextUtils.isEmpty(tvScheduleTime.getText().toString().trim()) || TextUtils.isEmpty(peopleAdapter.getSelected()) || TextUtils.isEmpty(tableAdapter.getSelected())) {
            btnBookTable.setEnabled(false);
            btnBookTable.setAlpha(0.5f);
        } else {
            btnBookTable.setEnabled(true);
            btnBookTable.setAlpha(1f);
        }
    }

    private void getBookingSettings() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.STORE_ID, store.getId());
        Utils.showCustomProgressDialog(context, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<TableBookingSettingsResponse> responseCall = apiInterface.tableBookingSettings(map);
        responseCall.enqueue(new Callback<TableBookingSettingsResponse>() {
            @Override
            public void onResponse(@NonNull Call<TableBookingSettingsResponse> call, @NonNull Response<TableBookingSettingsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        tableSettings = response.body().getTableSettings();
                        storeDeliveryTimes.clear();
                        storeDeliveryTimes.addAll(tableSettings.getBookingTime());

                        if (tableSettings.isTableReservation() && tableSettings.isTableReservationWithOrder()) {
                            if (currentBooking.isTableBooking()) {
                                rbBookAtRest.setChecked(currentBooking.getTableBookingType() == Const.TableBookingType.BOOK_AT_REST);
                                rbBookNow.setChecked(currentBooking.getTableBookingType() == Const.TableBookingType.BOOK_WITH_ORDER);
                            } else {
                                rbBookAtRest.setChecked(true);
                            }
                        } else if (tableSettings.isTableReservation()) {
                            rbBookAtRest.setChecked(true);
                            rbBookNow.setVisibility(View.GONE);
                        } else if (tableSettings.isTableReservationWithOrder()) {
                            rbBookAtRest.setVisibility(View.GONE);
                            rbBookNow.setChecked(true);
                        }
                        if (currentBooking.isTableBooking()) {
                            tvScheduleDate.setText(currentBooking.getSchedule().getScheduleDate());
                            tvScheduleTime.setText(currentBooking.getSchedule().getScheduleTime());
                            peopleAdapter.setSelected(String.valueOf(currentBooking.getNumberOfPerson()));
                            setNumberOfPeople(String.valueOf(currentBooking.getNumberOfPerson()));
                            tableAdapter.setSelected(String.valueOf(currentBooking.getTableNumber()));
                            updateUIButton();
                        } else {
                            ArrayList<String> tablesNumber = new ArrayList<>();
                            tableList.clear();
                            for (Table table : tableSettings.getTableList()) {
                                tablesNumber.add(table.getTableNo());
                                tableList.add(table);
                            }
                            tableAdapter.setTables(tablesNumber);
                            if (tableDetail != null) {
                                getTableDetail();
                            }
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<TableBookingSettingsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getTableDetail() {
        if (tableDetail != null && tableDetail.isIsUserCanBook() && tableDetail.isBusiness()) {
            ArrayList<String> tablesNumber = new ArrayList<>();
            tablesNumber.add(tableDetail.getTableNo());
            tableList.clear();
            tableList.add(tableDetail);
            tableAdapter.setTables(tablesNumber);
            tableAdapter.setSelected(String.valueOf(tableDetail.getTableNo()));
            ArrayList<String> peoples = new ArrayList<String>();
            for (int i = tableDetail.getTableMinPerson(); i <= tableDetail.getTableMaxPerson(); i++) {
                if (i <= tableSettings.getReservationPersonMaxSeat()) {
                    peoples.add(String.valueOf(i));
                } else {
                    break;
                }
            }
            peopleAdapter.setTables(peoples);
            tvScheduleDate.setText(currentBooking.getSchedule().dateFormat.format(new Date()));
            tvScheduleDate.setEnabled(false);
            String time = Calendar.getInstance().get(Calendar.HOUR_OF_DAY) + ":" + Calendar.getInstance().get(Calendar.MINUTE);
            tvScheduleTime.setText(time);
            currentBooking.setBookTableForFuture(false);
            tvScheduleTime.setEnabled(false);
        }
    }
}