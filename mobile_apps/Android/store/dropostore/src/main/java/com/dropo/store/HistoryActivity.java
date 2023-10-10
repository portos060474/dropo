package com.dropo.store;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.store.R;
import com.dropo.store.adapter.HistoryAdapter;
import com.dropo.store.models.datamodel.OrderData;
import com.dropo.store.models.responsemodel.HistoryResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.TreeSet;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HistoryActivity extends BaseActivity {

    private ArrayList<OrderData> orderItemArrayList, sortlistItemArrayList;
    private RecyclerView recyclerView;
    private HistoryAdapter historyAdapter;
    private TreeSet<Integer> separatorSet;
    private ArrayList<Date> dateList;
    private ParseContent parseContent;
    private SwipeRefreshLayout swipeRefreshLayout;
    private View ivEmpty;

    private Calendar calendar;
    private int day;
    private int month;
    private int year;

    private DatePickerDialog.OnDateSetListener fromDateSet, toDateSet;
    private boolean isFromDateSet, isToDateSet;
    private long fromDateSetTime, toDateSetTime;
    private BottomSheetDialog historyFilterDialog;
    private TextView tvFromDate, tvToDate;

    private EditText etSearch;
    private ImageView ivClear;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);

        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_history));

        parseContent = ParseContent.getInstance();
        recyclerView = findViewById(R.id.recyclerView);
        etSearch = findViewById(R.id.etSearch);
        ivClear = findViewById(R.id.ivClear);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        swipeRefreshLayout = findViewById(R.id.swipe_history);
        ivEmpty = findViewById(R.id.ivEmpty);
        separatorSet = new TreeSet<>();
        dateList = new ArrayList<>();
        orderItemArrayList = new ArrayList<>();
        sortlistItemArrayList = new ArrayList<>();
        getHistory("", "");
        swipeLayoutSetup();

        calendar = Calendar.getInstance();
        day = calendar.get(Calendar.DAY_OF_MONTH);
        month = calendar.get(Calendar.MONTH);
        year = calendar.get(Calendar.YEAR);

        fromDateSet = (datePicker, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            fromDateSetTime = calendar.getTimeInMillis();
            isFromDateSet = true;
            if (historyFilterDialog != null) {
                tvFromDate.setText(parseContent.dateFormat.format(calendar.getTime()));
            }
        };

        toDateSet = (view, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            toDateSetTime = calendar.getTimeInMillis();
            isToDateSet = true;
            if (historyFilterDialog != null) {
                tvToDate.setText(parseContent.dateFormat.format(calendar.getTime()));
            }
        };

        etSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (historyAdapter != null) {
                    historyAdapter.getFilter().filter(s.toString().trim());
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        ivClear.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.ivClear) {
            etSearch.setText(null);
            historyAdapter.getFilter().filter(etSearch.getText().toString().trim());
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(true, R.drawable.filter_store);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            openHistoryFilterDialog();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


    private void swipeLayoutSetup() {
        swipeRefreshLayout.setOnRefreshListener(() -> getHistory("", ""));
        setColorSwipeToRefresh(swipeRefreshLayout);
    }

    private void getHistory(String fromDate, String toDate) {
        swipeRefreshLayout.setRefreshing(true);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.START_DATE, fromDate);
        map.put(Constant.END_DATE, toDate);
        Call<HistoryResponse> call = ApiClient.getClient().create(ApiInterface.class).getHistoryList(map);
        call.enqueue(new Callback<HistoryResponse>() {
            @Override
            public void onResponse(@NonNull Call<HistoryResponse> call, @NonNull Response<HistoryResponse> response) {
                swipeRefreshLayout.setRefreshing(false);
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        orderItemArrayList.clear();
                        orderItemArrayList.addAll(response.body().getOrderList());
                        historyAdapter = new HistoryAdapter(HistoryActivity.this, getShortHistoryList(orderItemArrayList), separatorSet, HistoryActivity.this);
                        recyclerView.setAdapter(historyAdapter);
                    } else {
                        orderItemArrayList.clear();
                        ParseContent.getInstance().showErrorMessage(HistoryActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }

                ivEmpty.setVisibility(orderItemArrayList.isEmpty() ? View.VISIBLE : View.GONE);
            }


            @Override
            public void onFailure(@NonNull Call<HistoryResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                ivEmpty.setVisibility(orderItemArrayList.isEmpty() ? View.VISIBLE : View.GONE);
            }
        });
    }

    private ArrayList<OrderData> getShortHistoryList(ArrayList<OrderData> listItems) {
        sortlistItemArrayList.clear();
        dateList.clear();
        separatorSet.clear();
        try {
            SimpleDateFormat sdf = parseContent.dateFormat;
            Calendar calendar = Calendar.getInstance();

            Collections.sort(listItems, (orderList, orderList2) -> compareTwoDate(orderList.getCompletedAt(), orderList2.getCompletedAt()));

            HashSet<Date> listToSet = new HashSet<>();
            for (int i = 0; i < listItems.size(); i++) {
                if (listToSet.add(sdf.parse(listItems.get(i).getCompletedAt()))) {
                    dateList.add(sdf.parse(listItems.get(i).getCompletedAt()));
                }
            }

            for (int i = 0; i < dateList.size(); i++) {
                calendar.setTime(dateList.get(i));
                OrderData orderList = new OrderData();
                orderList.setCompletedAt(sdf.format(dateList.get(i)));
                sortlistItemArrayList.add(orderList);

                separatorSet.add(sortlistItemArrayList.size() - 1);
                for (int j = 0; j < listItems.size(); j++) {
                    Calendar messageTime = Calendar.getInstance();
                    messageTime.setTime(sdf.parse(listItems.get(j).getCompletedAt()));
                    if (calendar.getTime().compareTo(messageTime.getTime()) == 0) {
                        sortlistItemArrayList.add(listItems.get(j));

                    }
                }
            }
        } catch (ParseException e) {
            Utilities.handleException(Constant.Tag.HISTORY_ACTIVITY, e);
        }

        return sortlistItemArrayList;
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat webFormat = parseContent.webFormat;
            SimpleDateFormat dateFormat = parseContent.dateTimeFormat;
            String date2 = dateFormat.format(webFormat.parse(secondStrDate));
            String date1 = dateFormat.format(webFormat.parse(firstStrDate));
            return date2.compareTo(date1);
        } catch (ParseException e) {
            Utilities.handleException(Constant.Tag.HISTORY_ACTIVITY, e);
        }
        return 0;
    }

    private void openFromDatePicker() {
        DatePickerDialog fromPiker = new DatePickerDialog(this, fromDateSet, year, month, day);
        fromPiker.setTitle(getResources().getString(R.string.text_select_from_date));
        if (isToDateSet) {
            fromPiker.getDatePicker().setMaxDate(calendar.getTimeInMillis());
        } else {
            fromPiker.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis());
        }
        fromPiker.show();
    }

    private void openToDatePicker() {
        DatePickerDialog toPiker = new DatePickerDialog(this, toDateSet, year, month, day);
        toPiker.setTitle(getResources().getString(R.string.text_select_to_date));
        if (isFromDateSet) {
            toPiker.getDatePicker().setMaxDate(System.currentTimeMillis());
            toPiker.getDatePicker().setMinDate(fromDateSetTime);
        } else {
            toPiker.getDatePicker().setMaxDate(System.currentTimeMillis());
        }
        toPiker.show();
    }

    private void clearData() {
        isFromDateSet = false;
        isToDateSet = false;
        fromDateSetTime = 0;
        toDateSetTime = 0;
        calendar.setTimeInMillis(System.currentTimeMillis());
        if (historyFilterDialog != null) {
            tvToDate.setText(getResources().getString(R.string.text_to));
            tvFromDate.setText(getResources().getString(R.string.text_from));
        }
    }

    private void openHistoryFilterDialog() {
        if (historyFilterDialog != null && historyFilterDialog.isShowing()) {
            return;
        }
        historyFilterDialog = new BottomSheetDialog(this);
        historyFilterDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        historyFilterDialog.setContentView(R.layout.dialog_history_filter);
        tvFromDate = historyFilterDialog.findViewById(R.id.tvFromDate);
        tvToDate = historyFilterDialog.findViewById(R.id.tvToDate);
        tvFromDate.setOnClickListener(view -> openFromDatePicker());
        tvToDate.setOnClickListener(view -> openToDatePicker());
        historyFilterDialog.findViewById(R.id.tvHistoryReset).setOnClickListener(view -> {
            clearData();
            getHistory("", "");
        });

        historyFilterDialog.findViewById(R.id.tvHistoryApply).setOnClickListener(view -> {
            if (fromDateSetTime > 0 && toDateSetTime > 0) {
                getHistory(parseContent.dateFormat2.format(new Date(fromDateSetTime)), parseContent.dateFormat2.format(new Date(toDateSetTime)));
                clearData();
                historyFilterDialog.dismiss();
            } else {
                Utilities.showToast(historyFilterDialog.getContext(), getResources().getString(R.string.msg_plz_select_valid_date));
            }
        });

        historyFilterDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> historyFilterDialog.dismiss());
        WindowManager.LayoutParams params = historyFilterDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        historyFilterDialog.show();
    }
}