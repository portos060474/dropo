package com.dropo;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Filter;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.HistoryAdapter;
import com.dropo.adapter.OrdersAdapter;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.models.datamodels.Order;
import com.dropo.models.datamodels.OrderHistory;
import com.dropo.models.responsemodels.OrderHistoryResponse;
import com.dropo.models.responsemodels.OrdersResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrdersActivity extends BaseAppCompatActivity implements BaseAppCompatActivity.OrderStatusListener {

    private final ArrayList<Order> orderArrayList = new ArrayList<>();
    private final ArrayList<OrderHistory> orderHistories = new ArrayList<>();
    private RecyclerView rcvCurrentOrder;
    private OrdersAdapter ordersAdapter;
    private CustomFontEditTextView tvFromDate, tvToDate;
    private RecyclerView rcvOrderHistory;
    private HistoryAdapter ordersHistoryAdapter;
    private DatePickerDialog.OnDateSetListener fromDateSet, toDateSet;
    private Calendar calendar;
    private int day;
    private int month;
    private int year;
    private boolean isFromDateSet, isToDateSet;
    private long fromDateSetTime, toDateSetTime;
    private BottomSheetDialog historyFilterDialog;
    private ImageView ivFilter;
    private LinearLayout llCurrentOrder, llHistory, ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_orders);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_orders));
        Drawable drawable = ContextCompat.getDrawable(getApplicationContext(), R.drawable.ic_filter);
        Objects.requireNonNull(drawable).setTint(AppColor.COLOR_THEME);
        toolbar.setOverflowIcon(drawable);
        initViewById();
        setViewListener();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setOrderStatusListener(this);
        getOrders();
        getOrderHistory("", "");
    }

    @Override
    protected void onPause() {
        super.onPause();
        setOrderStatusListener(null);
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvCurrentOrder = findViewById(R.id.rcvCurrentOrder);
        rcvOrderHistory = findViewById(R.id.rcvOrderHistory);
        ivFilter = findViewById(R.id.ivFilter);
        llCurrentOrder = findViewById(R.id.llCurrentOrder);
        llHistory = findViewById(R.id.llHistory);
        ivEmpty = findViewById(R.id.ivEmpty);
        llCurrentOrder.setVisibility(View.GONE);
        llHistory.setVisibility(View.GONE);
        ivEmpty.setVisibility(View.VISIBLE);
    }

    @Override
    protected void setViewListener() {
        ivFilter.setOnClickListener(this);
        calendar = Calendar.getInstance();
        day = calendar.get(Calendar.DAY_OF_MONTH);
        month = calendar.get(Calendar.MONTH);
        year = calendar.get(Calendar.YEAR);
        fromDateSet = (view, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            fromDateSetTime = calendar.getTimeInMillis();
            isFromDateSet = true;
            tvFromDate.setText(parseContent.dateFormat.format(calendar.getTime()));
        };
        toDateSet = (view, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            toDateSetTime = calendar.getTimeInMillis();
            isToDateSet = true;
            tvToDate.setText(parseContent.dateFormat.format(calendar.getTime()));
        };
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivFilter) {
            openHistoryFilterDialog();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_filter_order, menu);
        for (int i = 0; i < menu.size(); i++) {
            MenuItem item = menu.getItem(i);
            SpannableString spanString = new SpannableString(menu.getItem(i).getTitle().toString());
            spanString.setSpan(new ForegroundColorSpan(Color.BLACK), 0, spanString.length(), 0);
            item.setTitle(spanString);
        }
        return super.onCreateOptionsMenu(menu);
    }

    private final Filter.FilterListener filterListener = count -> updateUiWhenDataAvailable();

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.item_all) {
            ordersAdapter.getFilter().filter("", filterListener);
            ordersHistoryAdapter.getFilter().filter("", filterListener);
        } else if (id == R.id.item_courier) {
            ordersAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.COURIER), filterListener);
            ordersHistoryAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.COURIER), filterListener);
        } else if (id == R.id.item_store) {
            ordersAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.STORE), filterListener);
            ordersHistoryAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.STORE), filterListener);
        } else if (id == R.id.item_table_reservation) {
            ordersAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.TABLE_BOOKING), filterListener);
            ordersHistoryAdapter.getFilter().filter(String.valueOf(Const.DeliveryType.TABLE_BOOKING), filterListener);
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        if (getIntent().getBooleanExtra(Const.IS_FROM_COMPLETE_ORDER, false)) {
            goToHomeActivity();
        } else {
            super.onBackPressed();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        }
    }

    @Override
    public void onOrderStatus() {
        getOrders();
    }

    /**
     * this method call a webservice for get ruining order of user
     */
    private void getOrders() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrdersResponse> responseCall = apiInterface.getOrders(map);
        responseCall.enqueue(new Callback<OrdersResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrdersResponse> call, @NonNull Response<OrdersResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    orderArrayList.clear();
                    if (response.body().isSuccess()) {
                        orderArrayList.addAll(response.body().getOrderList());
                        Collections.sort(orderArrayList, (order1, order2) -> compareTwoDate(order1.getCreatedAt(), order2.getCreatedAt()));
                    }
                    initRcvOrders(orderArrayList);
                    updateUiWhenDataAvailable();
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrdersResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CURRENT_ORDER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat dateFormat = parseContent.webFormat;
            Date date2 = dateFormat.parse(secondStrDate);
            Date date1 = dateFormat.parse(firstStrDate);
            return date2.compareTo(date1);
        } catch (ParseException e) {
            AppLog.handleException(OrdersActivity.class.getName(), e);
        }
        return 0;
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvOrders(final ArrayList<Order> orderArrayList) {
        if (ordersAdapter != null) {
            ordersAdapter.notifyDataSetChanged();
        } else {
            ordersAdapter = new OrdersAdapter(this, orderArrayList, position -> {
                if (position > -1) {
                    Order order = ordersAdapter.getItemList().get(position);
                    goToOrderDetailActivity(order, "", false);
                }
            });
            rcvCurrentOrder.setLayoutManager(new LinearLayoutManager(this));
            rcvCurrentOrder.setAdapter(ordersAdapter);
        }
    }

    private void goToOrderDetailActivity(Order order, String orderId, boolean isShowHistory) {
        Intent intent = new Intent(this, OrderDetailActivity.class);
        intent.putExtra(Const.Params.ORDER, order);
        intent.putExtra(Const.Params.IS_SHOW_HISTORY, isShowHistory);
        intent.putExtra(Const.Params.ORDER_ID, orderId);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method call webservice for get order history
     *
     * @param fromDate date in format (mm/dd/yyyy)
     * @param toDate   date in format (mm/dd/yyyy)
     */
    private void getOrderHistory(String fromDate, String toDate) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.START_DATE, fromDate);
        map.put(Const.Params.END_DATE, toDate);
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderHistoryResponse> responseCall = apiInterface.getOrdersHistory(map);
        responseCall.enqueue(new Callback<OrderHistoryResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderHistoryResponse> call, @NonNull Response<OrderHistoryResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        orderHistories.clear();
                        orderHistories.addAll(response.body().getOrderList());
                    }
                    initRcvHistoryList();
                    updateUiWhenDataAvailable();
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderHistoryResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(OrdersActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvHistoryList() {
        Collections.sort(orderHistories, (lhs, rhs) -> compareTwoDate(lhs.getCreatedAt(), rhs.getCreatedAt()));
        if (ordersHistoryAdapter != null) {
            ordersHistoryAdapter.notifyDataSetChanged();
        } else {
            rcvOrderHistory.setLayoutManager(new LinearLayoutManager(this));
            ordersHistoryAdapter = new HistoryAdapter(this, orderHistories, position -> {
                OrderHistory orderHistory = ordersHistoryAdapter.getItemList().get(position);
                goToOrderDetailActivity(null, orderHistory.getId(), true);
            });
            rcvOrderHistory.setAdapter(ordersHistoryAdapter);
        }
    }

    private void openFromDatePicker() {
        DatePickerDialog fromPiker = new DatePickerDialog(this, fromDateSet, year, month, day);
        fromPiker.setTitle(getResources().getString(R.string.text_select_from_date));
        fromPiker.getDatePicker();
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
            getOrderHistory("", "");
        });
        historyFilterDialog.findViewById(R.id.tvHistoryApply).setOnClickListener(view -> {
            if (fromDateSetTime > 0 && toDateSetTime > 0) {
                getOrderHistory(parseContent.dateFormat2.format(new Date(fromDateSetTime)), parseContent.dateFormat2.format(new Date(toDateSetTime)));
                clearData();
                historyFilterDialog.dismiss();
            } else {
                Utils.showToast(getResources().getString(R.string.msg_plz_select_valid_date), this);
            }
        });

        historyFilterDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> historyFilterDialog.dismiss());
        WindowManager.LayoutParams params = historyFilterDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        historyFilterDialog.show();
    }

    private void clearData() {
        isFromDateSet = false;
        isToDateSet = false;
        tvToDate.setText(getResources().getString(R.string.text_to));
        tvFromDate.setText(getResources().getString(R.string.text_from));
        fromDateSetTime = 0;
        toDateSetTime = 0;
        calendar.setTimeInMillis(System.currentTimeMillis());
    }

    @SuppressLint("NotifyDataSetChanged")
    public void updateUiWhenDataAvailable() {
        ivEmpty.setVisibility((ordersAdapter != null && ordersAdapter.getItemCount() > 0) && (ordersHistoryAdapter != null && ordersHistoryAdapter.getItemCount() > 0) ? View.GONE : View.VISIBLE);
        llCurrentOrder.setVisibility(ordersAdapter == null || ordersAdapter.getItemCount() <= 0 ? View.GONE : View.VISIBLE);
        llHistory.setVisibility(ordersHistoryAdapter == null || ordersHistoryAdapter.getItemCount() <= 0 ? View.GONE : View.VISIBLE);
        if (ordersAdapter != null) {
            rcvCurrentOrder.post(() -> ordersAdapter.notifyDataSetChanged());
        }
        if (ordersHistoryAdapter != null) {
            rcvOrderHistory.post(() -> ordersHistoryAdapter.notifyDataSetChanged());
        }
    }

    public interface OrderSelectListener {
        void onOrderSelect(int position);
    }
}