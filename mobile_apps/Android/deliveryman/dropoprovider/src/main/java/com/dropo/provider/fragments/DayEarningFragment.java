package com.dropo.provider.fragments;

import android.app.DatePickerDialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.adapter.OrderAnalyticAdapter;
import com.dropo.provider.adapter.OrderDayEarningAdaptor;
import com.dropo.provider.adapter.OrderEarningAdapter;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.Analytic;
import com.dropo.provider.models.datamodels.EarningData;
import com.dropo.provider.models.responsemodels.DayEarningResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;
import com.github.mikephil.charting.charts.BarChart;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DayEarningFragment extends BaseEarningFragment {

    public CustomFontTextView tvOrderDate;
    private CustomFontTextViewTitle tvOrderTotal, tvPrice, tvDayEarning;
    private RecyclerView rcvOrderEarning, rcvProviderAnalytic, rcvOrders;
    private ArrayList<ArrayList<EarningData>> arrayListForEarning;
    private ArrayList<Analytic> arrayListProviderAnalytic;
    private List<Object> orderPaymentsItemList;
    private LinearLayout llData, ivEmpty;
    private Calendar calendar;
    private int day;
    private int month;
    private int year;
    private DatePickerDialog.OnDateSetListener fromDateSet;
    private BarChart barChart;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View fragEarView = inflater.inflate(R.layout.fragment_earning, container, false);
        tvOrderDate = fragEarView.findViewById(R.id.tvOrderDate);
        tvOrderTotal = fragEarView.findViewById(R.id.tvOrderTotal);
        tvPrice = fragEarView.findViewById(R.id.tvPrice);
        rcvOrderEarning = fragEarView.findViewById(R.id.rcvOrderEarning);
        rcvProviderAnalytic = fragEarView.findViewById(R.id.rcvProviderAnalytic);
        rcvOrders = fragEarView.findViewById(R.id.rcvOrders);
        llData = fragEarView.findViewById(R.id.llData);
        ivEmpty = fragEarView.findViewById(R.id.ivEmpty);
        barChart = fragEarView.findViewById(R.id.barChart);
        tvDayEarning = fragEarView.findViewById(R.id.tvDayEarning);
        return fragEarView;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        barChart.setVisibility(View.GONE);
        tvDayEarning.setVisibility(View.GONE);
        calendar = Calendar.getInstance();
        day = calendar.get(Calendar.DAY_OF_MONTH);
        month = calendar.get(Calendar.MONTH);
        year = calendar.get(Calendar.YEAR);
        arrayListForEarning = new ArrayList<>();
        arrayListProviderAnalytic = new ArrayList<>();
        orderPaymentsItemList = new ArrayList<>();
        getDailyEarning(earningActivity.parseContent.dateFormat2.format(new Date()));
        tvOrderDate.setText(String.format("%s %s", Utils.getDayOfMonthSuffix(Integer.parseInt(earningActivity.parseContent.day.format(new Date()))), earningActivity.parseContent.dateFormatMonth.format(new Date())));
        tvOrderDate.setOnClickListener(this);
        fromDateSet = (view1, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            tvOrderDate.setText(String.format("%s %s", Utils.getDayOfMonthSuffix(dayOfMonth), earningActivity.parseContent.dateFormatMonth.format(new Date(calendar.getTimeInMillis()))));
            getDailyEarning(year + "-" + (monthOfYear + 1) + "-" + dayOfMonth);
        };
    }

    public void getDailyEarning(final String data) {
        Utils.showCustomProgressDialog(earningActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, earningActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.PROVIDER_ID, earningActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.START_DATE, data);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DayEarningResponse> responseCall = apiInterface.getDailyEarning(map);
        responseCall.enqueue(new Callback<DayEarningResponse>() {
            @Override
            public void onResponse(@NonNull Call<DayEarningResponse> call, @NonNull Response<DayEarningResponse> response) {
                Utils.hideCustomProgressDialog();
                if (response.body().isSuccess()) {
                    arrayListForEarning.clear();
                    arrayListProviderAnalytic.clear();
                    orderPaymentsItemList.clear();
                    earningActivity.parseContent.parseEarning(response, arrayListForEarning, arrayListProviderAnalytic, orderPaymentsItemList, false);
                    initEarningOrderRcv();
                    initAnalyticRcv();
                    initOrdersRcv();
                    tvOrderTotal.setText(String.format("%s %s", response.body().getCurrency(), earningActivity.parseContent.decimalTwoDigitFormat.format(response.body().getOrderTotal().getTotalEarning())));
                    tvPrice.setText(earningActivity.parseContent.decimalTwoDigitFormat.format(response.body().getOrderTotal().getPayToProvider()));
                    llData.setVisibility(View.VISIBLE);
                    ivEmpty.setVisibility(View.GONE);
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), earningActivity);
                    llData.setVisibility(View.GONE);
                    ivEmpty.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onFailure(@NonNull Call<DayEarningResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.tvOrderDate) {
            openFromDatePicker();
        }
    }

    private void initEarningOrderRcv() {
        rcvOrderEarning.setLayoutManager(new LinearLayoutManager(earningActivity));
        rcvOrderEarning.setAdapter(new OrderEarningAdapter(arrayListForEarning));
        rcvOrderEarning.setNestedScrollingEnabled(false);
    }

    private void initAnalyticRcv() {
        rcvProviderAnalytic.setLayoutManager(new GridLayoutManager(earningActivity, 2, LinearLayoutManager.VERTICAL, false));
        DividerItemDecoration itemDecoration = new DividerItemDecoration(earningActivity, DividerItemDecoration.HORIZONTAL);
        itemDecoration.getDrawable().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(earningActivity) ? R.color.color_app_divider_dark : R.color.color_app_divider_light, null));
        rcvProviderAnalytic.addItemDecoration(itemDecoration);
        rcvProviderAnalytic.setAdapter(new OrderAnalyticAdapter(arrayListProviderAnalytic));
        rcvProviderAnalytic.setNestedScrollingEnabled(false);
    }

    private void initOrdersRcv() {
        rcvOrders.setLayoutManager(new LinearLayoutManager(earningActivity));
        DividerItemDecoration itemDecoration = new DividerItemDecoration(earningActivity, DividerItemDecoration.VERTICAL);
        itemDecoration.getDrawable().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(earningActivity) ? R.color.color_app_divider_dark : R.color.color_app_divider_light, null));
        rcvOrders.addItemDecoration(itemDecoration);
        rcvOrders.setAdapter(new OrderDayEarningAdaptor(earningActivity, orderPaymentsItemList));
        rcvOrders.setNestedScrollingEnabled(false);
    }

    private void openFromDatePicker() {
        DatePickerDialog fromPiker = new DatePickerDialog(earningActivity, fromDateSet, year, month, day);
        fromPiker.setTitle(getResources().getString(R.string.text_select_from_date));
        fromPiker.getDatePicker().setMaxDate(Calendar.getInstance().getTimeInMillis());
        fromPiker.show();
    }
}