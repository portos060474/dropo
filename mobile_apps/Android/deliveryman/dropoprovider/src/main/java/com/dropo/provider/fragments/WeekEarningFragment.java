package com.dropo.provider.fragments;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.adapter.CalenderWeekAdaptor;
import com.dropo.provider.adapter.OrderAnalyticAdapter;
import com.dropo.provider.adapter.OrderEarningAdapter;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.Analytic;
import com.dropo.provider.models.datamodels.EarningData;
import com.dropo.provider.models.datamodels.WeekData;
import com.dropo.provider.models.responsemodels.DayEarningResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.CalenderHelper;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;
import com.github.mikephil.charting.charts.BarChart;
import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.BarData;
import com.github.mikephil.charting.data.BarDataSet;
import com.github.mikephil.charting.data.BarEntry;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.formatter.ValueFormatter;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.interfaces.datasets.IBarDataSet;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;
import com.github.mikephil.charting.utils.ViewPortHandler;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WeekEarningFragment extends BaseEarningFragment {

    private CustomFontTextView tvOrderDate;
    private CustomFontTextViewTitle tvOrderTotal, tvPrice, tvOrderTitle, tvDayEarning;
    private RecyclerView rcvOrderEarning, rcvProviderAnalytic;
    private ArrayList<ArrayList<EarningData>> arrayListForEarning;
    private ArrayList<Analytic> arrayListProviderAnalytic;
    private List<Object> orderPaymentsItemList;
    private LinearLayout llData, ivEmpty;
    private CalenderHelper calenderHelper;
    private BarChart barChart;
    private int textColorTheme;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_earning, container, false);
        tvOrderDate = view.findViewById(R.id.tvOrderDate);
        tvOrderTotal = view.findViewById(R.id.tvOrderTotal);
        tvPrice = view.findViewById(R.id.tvPrice);
        rcvOrderEarning = view.findViewById(R.id.rcvOrderEarning);
        rcvProviderAnalytic = view.findViewById(R.id.rcvProviderAnalytic);
        tvOrderTitle = view.findViewById(R.id.tvOrdersTitle);
        view.findViewById(R.id.llOrderPayment).setVisibility(View.GONE);
        llData = view.findViewById(R.id.llData);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        barChart = view.findViewById(R.id.barChart);
        tvDayEarning = view.findViewById(R.id.tvDayEarning);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        textColorTheme = AppColor.getThemeTextColor(earningActivity);
        barChart.setVisibility(View.VISIBLE);
        tvDayEarning.setVisibility(View.VISIBLE);
        calenderHelper = new CalenderHelper();
        tvOrderTitle.setText(earningActivity.getResources().getString(R.string.text_daily_earning));
        tvOrderTitle.setVisibility(View.GONE);
        tvDayEarning.setVisibility(View.GONE);
        arrayListForEarning = new ArrayList<>();
        arrayListProviderAnalytic = new ArrayList<>();
        orderPaymentsItemList = new ArrayList<>();
        tvOrderDate.setOnClickListener(this);
        tvOrderDate.setText(earningActivity.parseContent.dateFormat.format(new Date()));
        initChart();
        ArrayList<Date> dateArrayList = calenderHelper.getCurrentWeekDates();
        getWeeklyEarning(dateArrayList.get(0), dateArrayList.get(1));
    }

    private void getWeeklyEarning(Date start, Date end) {
        String date1 = earningActivity.parseContent.dateFormat3.format(start);
        String date2 = earningActivity.parseContent.dateFormat3.format(end);
        tvOrderDate.setText(String.format("%s - %s", date1, date2));
        Utils.showCustomProgressDialog(earningActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, earningActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.PROVIDER_ID, earningActivity.preferenceHelper.getProviderId());
        map.put(Const.Params.START_DATE, earningActivity.parseContent.dateFormat2.format(start));
        map.put(Const.Params.END_DATE, earningActivity.parseContent.dateFormat2.format(end));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DayEarningResponse> responseCall = apiInterface.getWeeklyEarning(map);
        responseCall.enqueue(new Callback<DayEarningResponse>() {
            @Override
            public void onResponse(@NonNull Call<DayEarningResponse> call, @NonNull Response<DayEarningResponse> response) {
                Utils.hideCustomProgressDialog();
                if (response.body().isSuccess()) {
                    arrayListForEarning.clear();
                    arrayListProviderAnalytic.clear();
                    orderPaymentsItemList.clear();
                    earningActivity.parseContent.parseEarning(response, arrayListForEarning, arrayListProviderAnalytic, orderPaymentsItemList, true);
                    initEarningOrderRcv();
                    initAnalyticRcv();
                    tvOrderTotal.setText(String.format("%s %s", response.body().getCurrency(), earningActivity.parseContent.decimalTwoDigitFormat.format(response.body().getOrderTotal().getTotalEarning())));
                    tvPrice.setText(earningActivity.parseContent.decimalTwoDigitFormat.format(response.body().getOrderTotal().getPayToProvider()));
                    llData.setVisibility(View.VISIBLE);
                    ivEmpty.setVisibility(View.GONE);
                    setBarChartData(orderPaymentsItemList);
                } else {
                    Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), earningActivity);
                    llData.setVisibility(View.GONE);
                    ivEmpty.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onFailure(@NonNull Call<DayEarningResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(WeekEarningFragment.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.tvOrderDate) {
            openWeekCalender();
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

    private void selectDayDate(String date) {
        DayEarningFragment dayEarningFragment = (DayEarningFragment) earningActivity.adapter.getItem(0);
        try {
            Date orderDate = earningActivity.parseContent.webFormat.parse(date);
            Date currentDate = new Date();
            if (orderDate.before(currentDate)) {
                dayEarningFragment.getDailyEarning(earningActivity.parseContent.dateFormat2.format(orderDate));
                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(earningActivity.parseContent.day.format(orderDate))) + " " + earningActivity.parseContent.dateFormatMonth.format(orderDate);
                dayEarningFragment.tvOrderDate.setText(dateString);
                earningActivity.earningViewpager.setCurrentItem(0);
            }
        } catch (ParseException e) {
            AppLog.handleException(WeekEarningFragment.class.getName(), e);
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void openWeekCalender() {
        final CustomFontTextView tvYear;
        final CalenderWeekAdaptor calenderWeekAdaptor;
        final ArrayList<WeekData> weekDatas = new ArrayList<>();
        final Calendar calendar = Calendar.getInstance();
        final Calendar calendar1 = Calendar.getInstance();
        weekDatas.addAll(calenderHelper.getCurrentYearCalender(calendar.get(Calendar.YEAR)));
        RecyclerView rcvCalender;
        final Dialog dialog = new BottomSheetDialog(earningActivity);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_calender_weekly);
        rcvCalender = dialog.findViewById(R.id.rcvCalender);
        rcvCalender.setLayoutManager(new LinearLayoutManager(earningActivity));
        calenderWeekAdaptor = new CalenderWeekAdaptor(earningActivity, weekDatas);
        rcvCalender.setAdapter(calenderWeekAdaptor);
        rcvCalender.addOnItemTouchListener(new RecyclerTouchListener(earningActivity, rcvCalender, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                calenderWeekAdaptor.toggleSelection(position);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
        tvYear = dialog.findViewById(R.id.tvYear);
        tvYear.setText(String.valueOf(calendar.get(Calendar.YEAR)));
        dialog.findViewById(R.id.ivMax).setOnClickListener(view -> {
            int year = calendar.get(Calendar.YEAR) + 1;
            if (year <= calendar1.get(Calendar.YEAR)) {
                calendar.set(Calendar.YEAR, year);
                tvYear.setText(String.valueOf(calendar.get(Calendar.YEAR)));
                weekDatas.clear();
                weekDatas.addAll(calenderHelper.getCurrentYearCalender(year));
                calenderWeekAdaptor.notifyDataSetChanged();
            }
        });
        dialog.findViewById(R.id.ivMin).setOnClickListener(view -> {
            int year = calendar.get(Calendar.YEAR) - 1;
            if (year > calendar1.get(Calendar.YEAR) - 3) {
                calendar.set(Calendar.YEAR, year);
                tvYear.setText(String.valueOf(calendar.get(Calendar.YEAR)));
                weekDatas.clear();
                weekDatas.addAll(calenderHelper.getCurrentYearCalender(year));
                calenderWeekAdaptor.notifyDataSetChanged();
            }
        });
        dialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            if (calenderWeekAdaptor.getDate() != null) {
                ArrayList<Date> dates = calenderWeekAdaptor.getDate().getParticularDate();
                getWeeklyEarning(dates.get(0), dates.get(1));
                dialog.dismiss();
            } else {
                Utils.showToast(earningActivity.getResources().getString(R.string.msg_plz_select_date), earningActivity);
            }

        });
        dialog.findViewById(R.id.btnNegative).setOnClickListener(view -> dialog.dismiss());

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.setCancelable(false);
        dialog.show();
    }


    private void initChart() {
        barChart.setDrawBarShadow(false);
        barChart.setDrawValueAboveBar(true);
        barChart.getDescription().setEnabled(false);

        // if more than 60 entries are displayed in the chart, no values will be
        // drawn
        barChart.setMaxVisibleValueCount(60);
        // scaling can now only be done on x- and y-axis separately
        barChart.setPinchZoom(false);

        barChart.setDrawGridBackground(false);
        barChart.setDoubleTapToZoomEnabled(false);
        barChart.setScaleEnabled(false);
        // barChart.setDrawYLabels(false);
        barChart.setOnChartValueSelectedListener(new OnChartValueSelectedListener() {
            @Override
            public void onValueSelected(Entry e, Highlight h) {
                Analytic analytic = (Analytic) orderPaymentsItemList.get(Math.round(e.getX()));
                selectDayDate(analytic.getTitle());
            }

            @Override
            public void onNothingSelected() {

            }
        });

        XAxis xAxis = barChart.getXAxis();
        xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);
        xAxis.setDrawGridLines(false);
        xAxis.setGranularity(1f); // only intervals of 1 day
        xAxis.setLabelCount(7);
        xAxis.setValueFormatter(new CustomAxisValueFormatter());
        xAxis.setTextColor(textColorTheme);

        YAxis leftAxis = barChart.getAxisLeft();
        leftAxis.setLabelCount(8, false);
        leftAxis.setDrawGridLines(false);
        leftAxis.setPosition(YAxis.YAxisLabelPosition.OUTSIDE_CHART);
        leftAxis.setSpaceTop(15f);
        leftAxis.setTextColor(textColorTheme);

        YAxis rightAxis = barChart.getAxisRight();
        rightAxis.setEnabled(false);
        rightAxis.setDrawGridLines(false);
        rightAxis.setLabelCount(8, false);
        rightAxis.setSpaceTop(15f);
        rightAxis.setTextColor(textColorTheme);

        Legend l = barChart.getLegend();
        l.setEnabled(false);
        l.setVerticalAlignment(Legend.LegendVerticalAlignment.BOTTOM);
        l.setHorizontalAlignment(Legend.LegendHorizontalAlignment.LEFT);
        l.setOrientation(Legend.LegendOrientation.HORIZONTAL);
        l.setDrawInside(false);
        l.setForm(Legend.LegendForm.SQUARE);
        l.setFormSize(9f);
        l.setTextSize(11f);
        l.setXEntrySpace(4f);
        l.setTextColor(textColorTheme);
    }

    private void setChartWithNegativeValue(boolean isHaveNegativeValue) {
        if (isHaveNegativeValue) {
            barChart.getAxisRight().resetAxisMinimum();
            barChart.getAxisLeft().resetAxisMinimum();
        } else {
            barChart.getAxisRight().setAxisMinimum(0f);
            barChart.getAxisLeft().setAxisMinimum(0f);
        }
    }

    private void setBarChartData(List<Object> orderPaymentsItemList) {
        ArrayList<BarEntry> yVals = new ArrayList<BarEntry>();
        boolean isHaveNegativeValue = false;
        for (int i = 0; i < orderPaymentsItemList.size(); i++) {
            Analytic analytic = (Analytic) orderPaymentsItemList.get(i);
            float value = Float.parseFloat(analytic.getValue());
            if (!isHaveNegativeValue && value < 0) {
                isHaveNegativeValue = true;
            }
            yVals.add(new BarEntry(i, value));
        }

        BarDataSet set1;
        setChartWithNegativeValue(isHaveNegativeValue);
        if (barChart.getData() != null && barChart.getData().getDataSetCount() > 0) {
            set1 = (BarDataSet) barChart.getData().getDataSetByIndex(0);
            set1.setValues(yVals);
            set1.setValueTextColor(textColorTheme);
            barChart.getData().notifyDataChanged();
            barChart.notifyDataSetChanged();
        } else {
            set1 = new BarDataSet(yVals, "");
            set1.setValueFormatter(new MyValueFormatter());
            set1.setDrawIcons(false);
            set1.setHighLightAlpha(0);
            set1.setValueTextColor(textColorTheme);
            ArrayList<IBarDataSet> dataSets = new ArrayList<IBarDataSet>();
            dataSets.add(set1);

            BarData data = new BarData(dataSets);
            data.setValueTextSize(10f);
            data.setBarWidth(0.9f);

            barChart.setData(data);

        }
        barChart.invalidate();
        barChart.animateY(2000);
    }

    private String getDate(String date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(" d MMM", Locale.US);
        dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        SimpleDateFormat webFormat = new SimpleDateFormat(Const.DATE_TIME_FORMAT_WEB, Locale.US);
        webFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        try {
            Date date1 = webFormat.parse(date);
            if (date1 != null) {
                return dateFormat.format(date1);
            }
        } catch (ParseException e) {
            AppLog.handleException(WeekEarningFragment.class.getSimpleName(), e);
        }
        return "";
    }

    private class CustomAxisValueFormatter extends ValueFormatter {

        public CustomAxisValueFormatter() {
        }

        @Override
        public String getFormattedValue(float value, AxisBase axis) {
            if (Math.round(value) > orderPaymentsItemList.size() - 1) {
                Analytic analytic = (Analytic) orderPaymentsItemList.get(Math.round(value) - ((Math.round(value) - orderPaymentsItemList.size() - 1)));
                return getDate(analytic.getTitle());
            } else {
                Analytic analytic = (Analytic) orderPaymentsItemList.get(Math.round(value));
                return getDate(analytic.getTitle());
            }
        }
    }

    public class MyValueFormatter extends ValueFormatter {

        public MyValueFormatter() {
        }

        @Override
        public String getFormattedValue(float value, Entry entry, int dataSetIndex, ViewPortHandler viewPortHandler) {
            return earningActivity.parseContent.decimalTwoDigitFormat.format(value);
        }
    }
}