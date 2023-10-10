package com.dropo.provider.fragments;

import static com.dropo.provider.R.id.ivToolbarRightIcon;

import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.provider.HistoryDetailActivity;
import com.dropo.provider.R;
import com.dropo.provider.adapter.HistoryAdapter;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.models.datamodels.OrderHistory;
import com.dropo.provider.models.responsemodels.OrderHistoryResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PinnedHeaderItemDecoration;
import com.dropo.provider.utils.Utils;
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

public class HistoryFragment extends BaseFragments {

    private CustomFontEditTextView tvFromDate, tvToDate;
    private RecyclerView rcvOrderHistory;
    private HistoryAdapter ordersHistoryAdapter;
    private ArrayList<OrderHistory> orderHistoryShortList, orderHistoryOriznalList;
    private TreeSet<Integer> separatorSet;
    private ArrayList<Date> dateList;
    private DatePickerDialog.OnDateSetListener fromDateSet, toDateSet;
    private Calendar calendar;
    private int day;
    private int month;
    private int year;
    private boolean isFromDateSet, isToDateSet;
    private long fromDateSetTime, toDateSetTime;
    private LinearLayout ivEmpty;
    private SwipeRefreshLayout srlOrdersHistory;
    private PinnedHeaderItemDecoration pinnedHeaderItemDecoration;
    private BottomSheetDialog historyFilterDialog;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        homeActivity.setToolbarRightIcon(R.drawable.ic_icon_filter, this);
        homeActivity.setTitleOnToolBar(homeActivity.getResources().getString(R.string.text_history));
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_history, container, false);
        rcvOrderHistory = view.findViewById(R.id.rcvOrderHistory);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        srlOrdersHistory = view.findViewById(R.id.srlOrdersHistory);
        homeActivity.setColorSwipeToRefresh(srlOrdersHistory);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        dateList = new ArrayList<>();
        separatorSet = new TreeSet<>();
        orderHistoryShortList = new ArrayList<>();
        orderHistoryOriznalList = new ArrayList<>();
        getOrderHistory("", "");

        calendar = Calendar.getInstance();
        day = calendar.get(Calendar.DAY_OF_MONTH);
        month = calendar.get(Calendar.MONTH);
        year = calendar.get(Calendar.YEAR);

        fromDateSet = (view1, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            fromDateSetTime = calendar.getTimeInMillis();
            isFromDateSet = true;
            tvFromDate.setText(homeActivity.parseContent.dateFormat.format(calendar.getTime()));
        };
        toDateSet = (view1, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            toDateSetTime = calendar.getTimeInMillis();
            isToDateSet = true;
            tvToDate.setText(homeActivity.parseContent.dateFormat.format(calendar.getTime()));
        };

        srlOrdersHistory.setOnRefreshListener(() -> getOrderHistory("", ""));
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == ivToolbarRightIcon) {
            openHistoryFilterDialog();
        } else if (id == R.id.tvFromDate) {
            openFromDatePicker();
        } else if (id == R.id.tvToDate) {
            openToDatePicker();
        }
    }

    /**
     * this method call webservice for get order history
     *
     * @param fromDate date in format (mm/dd/yyyy)
     * @param toDate   date in format (mm/dd/yyyy)
     */
    private void getOrderHistory(String fromDate, String toDate) {
        srlOrdersHistory.setRefreshing(true);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.START_DATE, fromDate);
        map.put(Const.Params.END_DATE, toDate);
        map.put(Const.Params.PROVIDER_ID, homeActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, homeActivity.preferenceHelper.getSessionToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderHistoryResponse> responseCall = apiInterface.getOrdersHistory(map);
        responseCall.enqueue(new Callback<OrderHistoryResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderHistoryResponse> call, @NonNull Response<OrderHistoryResponse> response) {
                if (homeActivity.parseContent.isSuccessful(response)) {
                    srlOrdersHistory.setRefreshing(false);
                    if (response.body().isSuccess()) {
                        orderHistoryOriznalList.clear();
                        orderHistoryOriznalList.addAll(response.body().getOrderList());
                    }

                    updateUiHistoryList();
                    initRcvHistoryList();
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderHistoryResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(HistoryFragment.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * This method is give arrayList which have unique date arrayList and is also add Date list
     * in treeSet
     */
    private void makeShortHistoryList() {
        orderHistoryShortList.clear();
        dateList.clear();
        separatorSet.clear();
        try {
            SimpleDateFormat sdf = homeActivity.parseContent.dateFormat;
            final Calendar cal = Calendar.getInstance();

            Collections.sort(orderHistoryOriznalList, (lhs, rhs) -> compareTwoDate(lhs.getCompletedAt(), rhs.getCompletedAt()));

            HashSet<Date> listToSet = new HashSet<>();
            for (int i = 0; i < orderHistoryOriznalList.size(); i++) {
                if (listToSet.add(sdf.parse(orderHistoryOriznalList.get(i).getCompletedAt()))) {
                    dateList.add(sdf.parse(orderHistoryOriznalList.get(i).getCompletedAt()));
                }
            }

            for (int i = 0; i < dateList.size(); i++) {
                cal.setTime(dateList.get(i));
                OrderHistory item = new OrderHistory();
                item.setCompletedAt(sdf.format(dateList.get(i)));
                orderHistoryShortList.add(item);

                separatorSet.add(orderHistoryShortList.size() - 1);
                for (int j = 0; j < orderHistoryOriznalList.size(); j++) {
                    Calendar messageTime = Calendar.getInstance();
                    messageTime.setTime(sdf.parse(orderHistoryOriznalList.get(j).getCompletedAt()));
                    if (cal.getTime().compareTo(messageTime.getTime()) == 0) {
                        orderHistoryShortList.add(orderHistoryOriznalList.get(j));
                    }
                }
            }
        } catch (ParseException e) {
            AppLog.handleException(HistoryFragment.class.getName(), e);
        }
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat webFormat = homeActivity.parseContent.webFormat;
            SimpleDateFormat dateFormat = homeActivity.parseContent.dateTimeFormat;
            String date2 = dateFormat.format(webFormat.parse(secondStrDate));
            String date1 = dateFormat.format(webFormat.parse(firstStrDate));
            return date2.compareTo(date1);
        } catch (ParseException e) {
            AppLog.handleException(HistoryFragment.class.getName(), e);
        }
        return 0;
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvHistoryList() {
        makeShortHistoryList();
        if (ordersHistoryAdapter != null) {
            pinnedHeaderItemDecoration.disableCache();
            ordersHistoryAdapter.notifyDataSetChanged();
        } else {
            rcvOrderHistory.setLayoutManager(new LinearLayoutManager(homeActivity));
            ordersHistoryAdapter = new HistoryAdapter(this, separatorSet, orderHistoryShortList);
            rcvOrderHistory.setAdapter(ordersHistoryAdapter);
            pinnedHeaderItemDecoration = new PinnedHeaderItemDecoration();
        }
    }

    public void goToHistoryOderDetailActivity(String orderId) {
        Intent intent = new Intent(homeActivity, HistoryDetailActivity.class);
        intent.putExtra(Const.Params.ORDER_ID, orderId);
        homeActivity.startActivity(intent);
        homeActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void openFromDatePicker() {
        DatePickerDialog fromPiker = new DatePickerDialog(homeActivity, fromDateSet, year, month, day);
        fromPiker.setTitle(getResources().getString(R.string.text_select_from_date));
        if (isToDateSet) {
            fromPiker.getDatePicker().setMaxDate(calendar.getTimeInMillis());
        } else {
            fromPiker.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis());
        }
        fromPiker.show();
    }

    private void openToDatePicker() {
        DatePickerDialog toPiker = new DatePickerDialog(homeActivity, toDateSet, year, month, day);
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
    }

    private void updateUiHistoryList() {
        if (orderHistoryOriznalList.isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvOrderHistory.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvOrderHistory.setVisibility(View.VISIBLE);
        }
    }

    private void openHistoryFilterDialog() {
        if (historyFilterDialog != null && historyFilterDialog.isShowing()) {
            return;
        }
        historyFilterDialog = new BottomSheetDialog(homeActivity);
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
                getOrderHistory(homeActivity.parseContent.dateFormat2.format(new Date(fromDateSetTime)), homeActivity.parseContent.dateFormat2.format(new Date(toDateSetTime)));
                clearData();
                historyFilterDialog.dismiss();
            } else {
                Utils.showToast(getResources().getString(R.string.msg_plz_select_valid_date), historyFilterDialog.getContext());
            }
        });
        historyFilterDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> historyFilterDialog.dismiss());
        WindowManager.LayoutParams params = historyFilterDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        historyFilterDialog.show();

    }
}
