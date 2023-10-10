package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.TypedArray;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.PromoForAdapter;
import com.dropo.store.adapter.PromoRecursionAdapter;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.component.TagView;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.PromoCodes;
import com.dropo.store.models.datamodel.PromoRecursionData;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.ProductResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.gson.Gson;
import com.soundcloud.android.crop.Crop;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddPromoCodeActivity extends BaseActivity implements CompoundButton.OnCheckedChangeListener {

    public static final String TAG = AddPromoCodeActivity.class.getName();
    private final ArrayList<Product> productList = new ArrayList<>();
    private LinearLayout llPromoMinimumAmountLimit, llPromoMaxDiscountLimit, llPromoRequiredUses, llRecursion, llPromoDate, llPromoTime, llDay, llWeek, llMonth, llPromoCompletedOrder, llPromoItemCountLimit, llPromoMaxDiscountMain;
    private SwitchCompat switchPromoMaxDiscountLimit, switchPromoRequiredUses, switchPromoMinimumAmountLimit, switchPromoActive, switchPromoRecursion, switchCompletedOrder, switchItemCountLimit;
    private CustomInputEditText etPromoCode, etPromoDetail, etPromoStartDate, etPromoExpDate, etPromoMinimumAmountLimit, etPromoMaxDiscountLimit, etPromoRequiredUses, etPromoAmount, etPromoItemCountLimit, etPromoOnCompletedOrder, etPromoStartTime, etPromoEndTime;
    private Spinner spinnerPromoType, spinnerPromoFor, spinnerPromoRecursionType;
    private int promoType, promoForValue, promoRecursionType;
    private DatePickerDialog.OnDateSetListener startDateSet, expDateSet;
    private Calendar calendar, startTimeCalender, endTimeCalender;
    private int day;
    private int month;
    private int year;
    private long promoStartDate = 0, promoExpDate = 0;
    private PromoCodes promoCodes;
    private PromoForAdapter promoForAdapter;
    private RecyclerView rcvPromoForList;
    private ArrayList<String> promoForeList;
    private TagView tagGroupDay, tagGroupWeek, tagGroupMonth;
    private ArrayList<PromoRecursionData> daysList, weekList, monthList;
    private ArrayList<String> selectedDaysList, selectedWeekList, selectedMonthList;
    private CustomTextView tvSelectRecursionDay, tvSelectRecursionWeek, tvSelectRecursionMonth;
    private ImageView ivAddDays, ivAddWeek, ivAddMonth, ivPromoImage;
    private Uri uri;
    private ImageHelper imageHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_promo_code);
        imageHelper = new ImageHelper(this);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(AddPromoCodeActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_promo));
        llPromoMaxDiscountMain = findViewById(R.id.llPromoMaxDiscountMain);
        llPromoMinimumAmountLimit = findViewById(R.id.llPromoMinimumAmountLimit);
        llPromoMaxDiscountLimit = findViewById(R.id.llPromoMaxDiscountLimit);
        llPromoRequiredUses = findViewById(R.id.llPromoRequiredUses);
        llRecursion = findViewById(R.id.llRecursion);
        llPromoDate = findViewById(R.id.llPromoDate);
        llPromoTime = findViewById(R.id.llPromoTime);
        llDay = findViewById(R.id.llDay);
        llWeek = findViewById(R.id.llWeek);
        llMonth = findViewById(R.id.llMonth);
        llPromoCompletedOrder = findViewById(R.id.llPromoCompletedOrder);
        llPromoItemCountLimit = findViewById(R.id.llPromoItemCountLimit);
        switchPromoMaxDiscountLimit = findViewById(R.id.switchPromoMaxDiscountLimit);
        switchPromoMaxDiscountLimit.setOnCheckedChangeListener(this);
        switchPromoRequiredUses = findViewById(R.id.switchPromoRequiredUses);
        switchPromoRequiredUses.setOnCheckedChangeListener(this);
        switchPromoMinimumAmountLimit = findViewById(R.id.switchPromoMinimumAmountLimit);
        switchPromoMinimumAmountLimit.setOnCheckedChangeListener(this);
        switchPromoRecursion = findViewById(R.id.switchPromoRecursion);
        switchPromoRecursion.setOnCheckedChangeListener(this);
        switchCompletedOrder = findViewById(R.id.switchCompletedOrder);
        switchCompletedOrder.setOnCheckedChangeListener(this);
        switchItemCountLimit = findViewById(R.id.switchItemCountLimit);
        switchItemCountLimit.setOnCheckedChangeListener(this);

        etPromoDetail = findViewById(R.id.etPromoDetail);
        etPromoStartDate = findViewById(R.id.etPromoStartDate);
        etPromoExpDate = findViewById(R.id.etPromoExpDate);
        spinnerPromoType = findViewById(R.id.spinnerPromoType);
        spinnerPromoFor = findViewById(R.id.spinnerPromoFor);
        spinnerPromoRecursionType = findViewById(R.id.spinnerPromoRecursionType);
        etPromoCode = findViewById(R.id.etPromoCode);
        etPromoMinimumAmountLimit = findViewById(R.id.etPromoMinimumAmountLimit);
        etPromoMaxDiscountLimit = findViewById(R.id.etPromoMaxDiscountLimit);
        etPromoRequiredUses = findViewById(R.id.etPromoRequiredUses);
        etPromoAmount = findViewById(R.id.etPromoAmount);
        etPromoItemCountLimit = findViewById(R.id.etPromoItemCountLimit);
        etPromoOnCompletedOrder = findViewById(R.id.etPromoOnCompletedOrder);
        etPromoExpDate.setOnClickListener(this);
        etPromoStartDate.setOnClickListener(this);
        etPromoStartTime = findViewById(R.id.etPromoStartTime);
        etPromoEndTime = findViewById(R.id.etPromoEndTime);
        etPromoEndTime.setOnClickListener(this);
        etPromoStartTime.setOnClickListener(this);
        switchPromoActive = findViewById(R.id.switchPromoActive);

        calendar = Calendar.getInstance();
        day = calendar.get(Calendar.DAY_OF_MONTH);
        month = calendar.get(Calendar.MONTH);
        year = calendar.get(Calendar.YEAR);

        startDateSet = (view, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            calendar.set(Calendar.HOUR_OF_DAY, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);
            promoStartDate = calendar.getTimeInMillis();
            etPromoStartDate.setText(parseContent.dateFormat.format(calendar.getTime()));
        };
        expDateSet = (view, year, monthOfYear, dayOfMonth) -> {
            calendar.clear();
            calendar.set(year, monthOfYear, dayOfMonth);
            calendar.set(Calendar.HOUR_OF_DAY, 23);
            calendar.set(Calendar.MINUTE, 59);
            calendar.set(Calendar.SECOND, 59);
            promoExpDate = calendar.getTimeInMillis();
            etPromoExpDate.setText(parseContent.dateFormat.format(calendar.getTime()));
        };

        rcvPromoForList = findViewById(R.id.rcvPromoForList);
        rcvPromoForList.setLayoutManager(new LinearLayoutManager(this));
        rcvPromoForList.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
        tagGroupDay = findViewById(R.id.tagGroupDay);
        tagGroupWeek = findViewById(R.id.tagGroupWeek);
        tagGroupMonth = findViewById(R.id.tagGroupMonth);
        tvSelectRecursionDay = findViewById(R.id.tvSelectRecursionDay);
        tvSelectRecursionWeek = findViewById(R.id.tvSelectRecursionWeek);
        tvSelectRecursionMonth = findViewById(R.id.tvSelectRecursionMonth);
        tvSelectRecursionDay.setOnClickListener(this);
        tvSelectRecursionWeek.setOnClickListener(this);
        tvSelectRecursionMonth.setOnClickListener(this);
        ivAddDays = findViewById(R.id.ivAddDays);
        ivAddMonth = findViewById(R.id.ivAddWeek);
        ivAddWeek = findViewById(R.id.ivAddMonth);
        ivPromoImage = findViewById(R.id.ivPromoImage);
        ivAddDays.setOnClickListener(this);
        ivAddMonth.setOnClickListener(this);
        ivAddWeek.setOnClickListener(this);
        ivPromoImage.setOnClickListener(this);
        promoForeList = new ArrayList<>();
        startTimeCalender = Calendar.getInstance();
        endTimeCalender = Calendar.getInstance();
        initPromoRecursionDataList();
        initSpinnerPromoRecursionType();
        initSpinnerPromoType();
        initSpinnerPromoForType();
        loadExtraData();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.etPromoStartDate) {
            openStartDatePicker();
        } else if (id == R.id.etPromoExpDate) {
            openExpDatePicker();
        } else if (id == R.id.etPromoStartTime) {
            openStartTimeDialog();
        } else if (id == R.id.etPromoEndTime) {
            openExpTimeDialog();
        } else if (id == R.id.tvSelectRecursionDay || id == R.id.ivAddDays) {
            openPromoRecursionDialog(daysList, selectedDaysList, tagGroupDay, getResources().getString(R.string.text_daily_recursion));
        } else if (id == R.id.tvSelectRecursionWeek || id == R.id.ivAddWeek) {
            openPromoRecursionDialog(weekList, selectedWeekList, tagGroupWeek, getResources().getString(R.string.text_weekly_recursion));
        } else if (id == R.id.tvSelectRecursionMonth || id == R.id.ivAddMonth) {
            openPromoRecursionDialog(monthList, selectedMonthList, tagGroupMonth, getResources().getString(R.string.text_monthly_recursion));
        } else if (id == R.id.ivPromoImage) {
            showPhotoSelectionDialog();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(true);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivSaveMenu) {
            if (TextUtils.isEmpty(etPromoCode.getText().toString())) {
                etPromoCode.setError(getResources().getString(R.string.msg_plz_enter_promo_code_first));
            } else {
                if (promoCodes == null) {
                    checkPromoReused(etPromoCode.getText().toString());
                } else {
                    if (validate()) {
                        addOrUpdatePromoCode();
                    }
                }
            }
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    private void scaleUpAndDown(final View view, boolean isShow) {
        if (isShow) {
            view.setVisibility(View.VISIBLE);
        } else {
            view.setVisibility(View.GONE);
        }
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        int id = buttonView.getId();
        if (id == R.id.switchPromoMaxDiscountLimit) {
            scaleUpAndDown(llPromoMaxDiscountLimit, isChecked);
        } else if (id == R.id.switchPromoRequiredUses) {
            scaleUpAndDown(llPromoRequiredUses, isChecked);
        } else if (id == R.id.switchPromoMinimumAmountLimit) {
            scaleUpAndDown(llPromoMinimumAmountLimit, isChecked);
        } else if (id == R.id.switchCompletedOrder) {
            scaleUpAndDown(llPromoCompletedOrder, isChecked);
        } else if (id == R.id.switchItemCountLimit) {
            scaleUpAndDown(llPromoItemCountLimit, isChecked);
        } else if (id == R.id.switchPromoRecursion) {
            updateUIPromoHaveDate(isChecked);
        }
    }

    private void initSpinnerPromoType() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.promo_type, R.layout.spinner_view_big);
        final CharSequence[] promoTypes = getResources().getTextArray(R.array.promo_value);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerPromoType.setAdapter(adapter);
        spinnerPromoType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                promoType = Integer.parseInt((String) promoTypes[i]);
                if (promoType == Constant.Type.ABSOLUTE) {
                    llPromoMaxDiscountMain.setVisibility(View.GONE);
                    switchPromoMaxDiscountLimit.setChecked(false);
                } else {
                    llPromoMaxDiscountMain.setVisibility(View.VISIBLE);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void initSpinnerPromoForType() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.promo_for_type, R.layout.spinner_view_big);
        final CharSequence[] promoFor = getResources().getTextArray(R.array.promo_for_value);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerPromoFor.setAdapter(adapter);
        spinnerPromoFor.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                promoForValue = Integer.parseInt((String) promoFor[i]);
                if (promoForValue == Constant.Promo.PROMO_FOR_STORE) {
                    hidePromoForList();
                } else {
                    getItemOrProductList(promoForValue);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void initSpinnerPromoRecursionType() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.promo_recursion_type, R.layout.spinner_view_big);
        final CharSequence[] promoTypes = getResources().getTextArray(R.array.promo_recursion_value);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerPromoRecursionType.setAdapter(adapter);
        spinnerPromoRecursionType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                promoRecursionType = Integer.parseInt((String) promoTypes[i]);
                updateRecursionPromoUI(promoRecursionType);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void addOrUpdatePromoCode() {
        Call<IsSuccessResponse> responseCall;
        PromoCodes promoCodes = new PromoCodes();
        promoCodes.setIsPromoForDeliveryService(false);
        promoCodes.setServerToken(preferenceHelper.getServerToken());
        promoCodes.setStoreId(preferenceHelper.getStoreId());
        promoCodes.setPromoCodeName(etPromoCode.getText().toString());
        promoCodes.setPromoDetails(etPromoDetail.getText().toString());
        promoCodes.setPromoCodeType(promoType);
        promoCodes.setPromoCodeValue(Utilities.roundDecimal(Double.parseDouble(etPromoAmount.getText().toString())));
        promoCodes.setIsActive(switchPromoActive.isChecked());
        promoCodes.setIsPromoHaveMinimumAmountLimit(switchPromoMinimumAmountLimit.isChecked());
        promoCodes.setIsPromoRequiredUses(switchPromoRequiredUses.isChecked());
        promoCodes.setIsPromoHaveMaxDiscountLimit(switchPromoMaxDiscountLimit.isChecked());
        promoCodes.setPromoHaveDate(switchPromoRecursion.isChecked());
        promoCodes.setPromoHaveItemCountLimit(switchItemCountLimit.isChecked());
        promoCodes.setPromoApplyOnCompletedOrder(switchCompletedOrder.isChecked());

        if (switchPromoMinimumAmountLimit.isChecked()) {
            promoCodes.setPromoCodeApplyOnMinimumAmount(Double.parseDouble(etPromoMinimumAmountLimit.getText().toString()));
        }
        if (switchPromoRequiredUses.isChecked()) {
            promoCodes.setPromoCodeUses(Integer.parseInt(etPromoRequiredUses.getText().toString()));
        }
        if (switchPromoMaxDiscountLimit.isChecked()) {
            promoCodes.setPromoCodeMaxDiscountAmount(Double.parseDouble(etPromoMaxDiscountLimit.getText().toString()));
        }
        if (switchCompletedOrder.isChecked()) {
            promoCodes.setPromoApplyAfterCompletedOrder(Integer.parseInt(etPromoOnCompletedOrder.getText().toString()));
        }

        if (switchItemCountLimit.isChecked()) {
            promoCodes.setPromoCodeApplyOnMinimumItemCount(Integer.parseInt(etPromoItemCountLimit.getText().toString()));
        }
        if (switchPromoRecursion.isChecked()) {
            promoCodes.setPromoRecursionType(promoRecursionType);

            switch (promoRecursionType) {
                case Constant.Type.NO_RECURSION:
                    promoCodes.setPromoStartDate(parseContent.webFormat.format(promoStartDate));
                    promoCodes.setPromoExpireDate(parseContent.webFormat.format(promoExpDate));
                    promoCodes.setPromoEndTime("");
                    promoCodes.setPromoStartTime("");
                    promoCodes.setDays(new ArrayList<>());
                    promoCodes.setWeeks(new ArrayList<>());
                    promoCodes.setMonths(new ArrayList<>());
                    break;
                case Constant.Type.DAILY_RECURSION:
                    promoCodes.setPromoStartDate(parseContent.webFormat.format(promoStartDate));
                    promoCodes.setPromoExpireDate(parseContent.webFormat.format(promoExpDate));
                    promoCodes.setPromoStartTime(etPromoStartTime.getText().toString());
                    promoCodes.setPromoEndTime(etPromoEndTime.getText().toString());
                    promoCodes.setDays(new ArrayList<>());
                    promoCodes.setWeeks(new ArrayList<>());
                    promoCodes.setMonths(new ArrayList<>());
                    break;
                case Constant.Type.WEEKLY_RECURSION:
                    promoCodes.setPromoStartDate(parseContent.webFormat.format(promoStartDate));
                    promoCodes.setPromoExpireDate(parseContent.webFormat.format(promoExpDate));
                    promoCodes.setPromoStartTime(etPromoStartTime.getText().toString());
                    promoCodes.setPromoEndTime(etPromoEndTime.getText().toString());
                    if (selectedDaysList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_day));
                        return;
                    }
                    promoCodes.setDays(selectedDaysList);
                    promoCodes.setWeeks(new ArrayList<>());
                    promoCodes.setMonths(new ArrayList<>());
                    break;
                case Constant.Type.MONTHLY_RECURSION:
                    promoCodes.setPromoStartDate(parseContent.webFormat.format(promoStartDate));
                    promoCodes.setPromoExpireDate(parseContent.webFormat.format(promoExpDate));
                    promoCodes.setPromoStartTime(etPromoStartTime.getText().toString());
                    promoCodes.setPromoEndTime(etPromoEndTime.getText().toString());
                    if (selectedDaysList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_day));
                        return;
                    }
                    if (selectedWeekList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_week));
                        return;
                    }
                    promoCodes.setDays(selectedDaysList);
                    promoCodes.setWeeks(selectedWeekList);
                    promoCodes.setMonths(new ArrayList<>());
                    break;
                case Constant.Type.ANNUALLY_RECURSION:
                    promoCodes.setPromoStartDate(parseContent.webFormat.format(promoStartDate));
                    promoCodes.setPromoExpireDate(parseContent.webFormat.format(promoExpDate));
                    promoCodes.setPromoStartTime(etPromoStartTime.getText().toString());
                    promoCodes.setPromoEndTime(etPromoEndTime.getText().toString());
                    if (selectedDaysList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_day));
                        return;
                    }
                    if (selectedWeekList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_week));
                        return;
                    }
                    if (selectedMonthList.isEmpty()) {
                        Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_month));
                        return;
                    }
                    promoCodes.setDays(selectedDaysList);
                    promoCodes.setWeeks(selectedWeekList);
                    promoCodes.setMonths(selectedMonthList);
                    break;
                default:
                    // do with default
                    break;
            }
        } else {
            promoCodes.setPromoStartDate("");
            promoCodes.setPromoExpireDate("");
            promoCodes.setPromoEndTime("");
            promoCodes.setPromoStartTime("");
            promoCodes.setDays(new ArrayList<>());
            promoCodes.setMonths(new ArrayList<>());
            promoCodes.setWeeks(new ArrayList<>());
        }

        Utilities.showCustomProgressDialog(this, false);
        if (this.promoCodes == null) {
            ///  add promo code
            setPromoFor(promoForValue, promoCodes);
            HashMap<String, String> hashMap = new Gson().fromJson(ApiClient.JSONResponse(promoCodes), HashMap.class);
            responseCall = ApiClient.getClient().create(ApiInterface.class).addPromoCodes(hashMap, ApiClient.makeMultipartRequestBody(this, ivPromoImage.getTag(R.drawable.placeholder) == null ? null : (String) ivPromoImage.getTag(R.drawable.placeholder), Constant.IMAGE_URL));
        } else {
            ///update  promo code
            promoCodes.setPromoCodeName(null);
            promoCodes.setPromoId(this.promoCodes.getId());
            setPromoFor(this.promoCodes.getPromoFor(), promoCodes);
            HashMap<String, String> hashMap = new Gson().fromJson(ApiClient.JSONResponse(promoCodes), HashMap.class);
            responseCall = ApiClient.getClient().create(ApiInterface.class).updatePromoCodes(hashMap, ApiClient.makeMultipartRequestBody(this, ivPromoImage.getTag(R.drawable.placeholder) == null ? null : (String) ivPromoImage.getTag(R.drawable.placeholder), Constant.IMAGE_URL));
        }
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        setResult(Activity.RESULT_OK);
                        finish();
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddPromoCodeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
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

    public void checkPromoReused(String promoCode) {
        etPromoCode.setError(null);
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.PROMO_CODE_NAME, promoCode);
        Call<IsSuccessResponse> productsCall = ApiClient.getClient().create(ApiInterface.class).checkPromoReuse(map);

        productsCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        etPromoCode.setError(null);
                        if (validate()) {
                            addOrUpdatePromoCode();
                        }
                    } else {
                        etPromoCode.getText().clear();
                        etPromoCode.setError(getResources().getString(R.string.msg_promo_code_already_added));
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddPromoCodeActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private boolean isInvalidNumber(CustomInputEditText view, boolean isRequired) {
        if (isRequired) {
            try {
                return Double.parseDouble(view.getText().toString()) < 0;
            } catch (NumberFormatException e) {
                return true;
            }
        } else {
            return false;
        }
    }

    private boolean validate() {
        String msg = null;
        if (isInvalidNumber(etPromoAmount, true)) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_amount);
            etPromoAmount.setError(msg);
            etPromoAmount.requestFocus();
        } else if (promoType == Constant.Type.PERCENTAGE && Double.parseDouble(etPromoAmount.getText().toString()) > 100) {
            msg = getResources().getString(R.string.msg_max_allowed_value);
            etPromoAmount.setError(msg);
            etPromoAmount.requestFocus();
        } else if (promoType == Constant.Type.ABSOLUTE && etPromoAmount.getText().length() > Constant.validationDigit.DIGIT_6) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_amount);
            etPromoAmount.setError(msg);
            etPromoAmount.requestFocus();
        } else if (isInvalidNumber(etPromoMinimumAmountLimit, switchPromoMinimumAmountLimit.isChecked())
                || etPromoMinimumAmountLimit.getText().length() > Constant.validationDigit.DIGIT_6
                || switchPromoMinimumAmountLimit.isChecked() && Double.parseDouble(etPromoMinimumAmountLimit.getText().toString()) == 0) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_amount);
            etPromoMinimumAmountLimit.setError(msg);
            etPromoMinimumAmountLimit.requestFocus();

        } else if (isInvalidNumber(etPromoMaxDiscountLimit, switchPromoMaxDiscountLimit.isChecked())
                || etPromoMaxDiscountLimit.getText().length() > Constant.validationDigit.DIGIT_6
                || switchPromoMaxDiscountLimit.isChecked() && Double.parseDouble(etPromoMaxDiscountLimit.getText().toString()) == 0) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_amount);
            etPromoMaxDiscountLimit.setError(msg);
            etPromoMaxDiscountLimit.requestFocus();

        } else if (isInvalidNumber(etPromoRequiredUses, switchPromoRequiredUses.isChecked())
                || etPromoRequiredUses.getText().length() > Constant.validationDigit.DIGIT_4
                || switchPromoRequiredUses.isChecked() && Double.parseDouble(etPromoRequiredUses.getText().toString()) == 0) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_value);
            etPromoRequiredUses.setError(msg);
            etPromoRequiredUses.requestFocus();

        } else if (isInvalidNumber(etPromoItemCountLimit, switchItemCountLimit.isChecked())
                || etPromoItemCountLimit.getText().length() > Constant.validationDigit.DIGIT_2
                || switchItemCountLimit.isChecked() && Double.parseDouble(etPromoItemCountLimit.getText().toString()) == 0) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_value);
            etPromoItemCountLimit.setError(msg);
            etPromoItemCountLimit.requestFocus();

        } else if (isInvalidNumber(etPromoOnCompletedOrder, switchCompletedOrder.isChecked())
                || etPromoOnCompletedOrder.getText().length() > Constant.validationDigit.DIGIT_2
                || switchCompletedOrder.isChecked() && Double.parseDouble(etPromoOnCompletedOrder.getText().toString()) == 0) {
            msg = getResources().getString(R.string.msg_plz_enter_valid_value);
            etPromoOnCompletedOrder.setError(msg);
            etPromoOnCompletedOrder.requestFocus();

        } else if (switchPromoRecursion.isChecked()) {
            if (TextUtils.isEmpty(etPromoStartDate.getText().toString())) {
                msg = getResources().getString(R.string.msg_plz_select_date);
                etPromoStartDate.setError(msg);
                etPromoStartDate.requestFocus();
            } else if (TextUtils.isEmpty(etPromoExpDate.getText().toString())) {
                msg = getResources().getString(R.string.msg_plz_select_date);
                etPromoExpDate.setError(msg);
                etPromoExpDate.requestFocus();
            } else if (promoRecursionType != Constant.Type.NO_RECURSION && endTimeCalender.getTimeInMillis() <= startTimeCalender.getTimeInMillis()) {
                msg = getResources().getString(R.string.msg_plz_select_valid_time);
                Utilities.showToast(this, msg);
            }

        }
        return TextUtils.isEmpty(msg);
    }

    private void openStartDatePicker() {
        DatePickerDialog fromPiker = new DatePickerDialog(this, startDateSet, year, month, day);
        fromPiker.setTitle(getResources().getString(R.string.text_start_date));
        if (promoExpDate > 0) {
            fromPiker.getDatePicker().setMaxDate(promoExpDate - 86400000);
        } else {
            fromPiker.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() - 10000);
        }
        fromPiker.show();
    }

    private void openExpDatePicker() {
        if (promoStartDate > 0) {
            DatePickerDialog toPiker = new DatePickerDialog(this, expDateSet, year, month, day);
            toPiker.setTitle(getResources().getString(R.string.text_exp_date));
            if (promoStartDate > 0) {
                toPiker.getDatePicker().setMinDate(promoStartDate);
            } else {
                toPiker.getDatePicker().setMinDate(Calendar.getInstance().getTimeInMillis() + 10000);
            }
            toPiker.show();
        } else {
            Utilities.showToast(this, getResources().getString(R.string.msg_plz_select_start_date_first));
        }

    }

    private void openStartTimeDialog() {
        int hour = startTimeCalender.get(Calendar.HOUR_OF_DAY);
        int minute = startTimeCalender.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            startTimeCalender.set(Calendar.HOUR_OF_DAY, selectedHour);
            startTimeCalender.set(Calendar.MINUTE, selectedMinute);
            startTimeCalender.set(Calendar.SECOND, 0);
            etPromoStartTime.setText(parseContent.timeFormat2.format(startTimeCalender.getTime()));
        }, hour, minute, true);

        timePickerDialog.show();
    }

    private void openExpTimeDialog() {

        int hour = endTimeCalender.get(Calendar.HOUR_OF_DAY);
        int minute = endTimeCalender.get(Calendar.MINUTE);

        TimePickerDialog timePickerDialog = new TimePickerDialog(this, (timePicker, selectedHour, selectedMinute) -> {
            endTimeCalender.set(Calendar.HOUR_OF_DAY, selectedHour);
            endTimeCalender.set(Calendar.MINUTE, selectedMinute);
            endTimeCalender.set(Calendar.SECOND, 0);
            etPromoEndTime.setText(parseContent.timeFormat2.format(endTimeCalender.getTime()));
        }, hour, minute, true);

        timePickerDialog.show();
    }

    @SuppressLint("Recycle")
    private void loadExtraData() {
        promoCodes = getIntent().getExtras().getParcelable(Constant.PROMO_DETAIL);
        etPromoCode.setEnabled(true);
        if (promoCodes != null) {
            promoForeList.clear();
            promoForeList.addAll(promoCodes.getPromoApplyOn());
            etPromoCode.setText(promoCodes.getPromoCodeName());
            etPromoCode.setEnabled(false);
            etPromoAmount.setText(String.valueOf(promoCodes.getPromoCodeValue()));
            etPromoDetail.setText(promoCodes.getPromoDetails());
            etPromoMinimumAmountLimit.setText(String.valueOf(promoCodes.getPromoCodeApplyOnMinimumAmount()));
            etPromoMaxDiscountLimit.setText(String.valueOf(promoCodes.getPromoCodeMaxDiscountAmount()));
            etPromoRequiredUses.setText(String.valueOf(promoCodes.getPromoCodeUses()));
            etPromoItemCountLimit.setText(String.valueOf(promoCodes.getPromoCodeApplyOnMinimumItemCount()));
            etPromoOnCompletedOrder.setText(String.valueOf(promoCodes.getPromoApplyAfterCompletedOrder()));
            switchPromoRequiredUses.setChecked(promoCodes.isIsPromoRequiredUses());
            switchPromoMinimumAmountLimit.setChecked(promoCodes.isIsPromoHaveMinimumAmountLimit());
            switchPromoMaxDiscountLimit.setChecked(promoCodes.isIsPromoHaveMaxDiscountLimit());
            switchPromoActive.setChecked(promoCodes.isIsActive());
            switchCompletedOrder.setChecked(promoCodes.isPromoApplyOnCompletedOrder());
            switchItemCountLimit.setChecked(promoCodes.isPromoHaveItemCountLimit());
            switchPromoRecursion.setChecked(promoCodes.isPromoHaveDate());
            if (promoCodes.getImageUrl() != null && !promoCodes.getImageUrl().isEmpty()) {
                GlideApp.with(this).load(IMAGE_URL + promoCodes.getImageUrl()).into(ivPromoImage);
            }
            try {
                if (promoCodes.isPromoHaveDate()) {
                    Date exp = parseContent.webFormat.parse(promoCodes.getPromoExpireDate());
                    promoExpDate = exp.getTime();
                    etPromoExpDate.setText(parseContent.dateFormat.format(exp));
                    Date start = parseContent.webFormat.parse(promoCodes.getPromoStartDate());
                    promoStartDate = start.getTime();
                    etPromoStartDate.setText(parseContent.dateFormat.format(start));

                    selectedDaysList.clear();
                    selectedMonthList.clear();
                    selectedWeekList.clear();
                    if (promoCodes.getDays() != null) {
                        selectedDaysList.addAll(promoCodes.getDays());
                    }
                    if (promoCodes.getMonths() != null) {
                        selectedMonthList.addAll(promoCodes.getMonths());
                    }
                    if (promoCodes.getWeeks() != null) {
                        selectedWeekList.addAll(promoCodes.getWeeks());
                    }
                    tagGroupDay.addTags(selectedDaysList);
                    tagGroupMonth.addTags(selectedMonthList);
                    tagGroupWeek.addTags(selectedWeekList);

                    etPromoStartTime.setText(promoCodes.getPromoStartTime());
                    etPromoEndTime.setText(promoCodes.getPromoEndTime());
                }
            } catch (ParseException e) {
                Utilities.handleException(TAG, e);
            }

            TypedArray array = getResources().obtainTypedArray(R.array.promo_value);
            for (int i = 0; i < array.length(); i++) {
                if (TextUtils.equals(String.valueOf(promoCodes.getPromoCodeType()), array.getString(i))) {
                    spinnerPromoType.setSelection(i);
                    break;
                }
            }
            TypedArray array1 = getResources().obtainTypedArray(R.array.promo_recursion_value);
            for (int i = 0; i < array1.length(); i++) {
                if (TextUtils.equals(String.valueOf(promoCodes.getPromoRecursionType()), array1.getString(i))) {
                    spinnerPromoRecursionType.setSelection(i);
                    break;
                }

            }
            TypedArray array2 = getResources().obtainTypedArray(R.array.promo_for_value);
            for (int i = 0; i < array2.length(); i++) {
                if (TextUtils.equals(String.valueOf(promoCodes.getPromoFor()), array2.getString(i))) {
                    spinnerPromoFor.setSelection(i);
                    break;
                }

            }
            spinnerPromoFor.setEnabled(false);
        }
    }

    /**
     * this method call webservice for get all itemList or productList in store
     */
    public void getItemOrProductList(final int selection) {
        Utilities.showCustomProgressDialog(this, false);

        Call<ProductResponse> call;
        if (selection == Constant.Promo.PROMO_FOR_ITEM) {
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            call = ApiClient.getClient().create(ApiInterface.class).getItemList(map);
        } else {
            HashMap<String, RequestBody> map = new HashMap<>();
            map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(preferenceHelper.getStoreId()));
            map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getServerToken()));
            call = ApiClient.getClient().create(ApiInterface.class).getProductList(map);
        }

        call.enqueue(new Callback<ProductResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProductResponse> call, @NonNull Response<ProductResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        if (promoCodes == null) {
                            promoForeList.clear();
                        }
                        productList.clear();
                        productList.addAll(response.body().getProducts());
                        promoForAdapter = new PromoForAdapter(productList, selection, promoForeList);
                        rcvPromoForList.setAdapter(promoForAdapter);
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddPromoCodeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddPromoCodeActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProductResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }


    @SuppressLint("NotifyDataSetChanged")
    private void hidePromoForList() {
        if (promoForAdapter != null) {
            productList.clear();
            promoForAdapter.notifyDataSetChanged();
        }
    }

    private void setPromoFor(int promoFor, PromoCodes promoCodes) {
        switch (promoFor) {
            case Constant.Promo.PROMO_FOR_STORE:
                promoCodes.setPromoFor(promoFor);
                promoForeList.clear();
                promoForeList.add(preferenceHelper.getStoreId());
                promoCodes.setPromoApplyOn(promoForeList);
                break;
            case Constant.Promo.PROMO_FOR_ITEM:
            case Constant.Promo.PROMO_FOR_PRODUCT:
                promoCodes.setPromoFor(promoFor);
                promoCodes.setPromoApplyOn(promoForeList);
                break;
            default:
                break;
        }
    }

    private void updateUIPromoHaveDate(boolean isChecked) {
        llRecursion.setVisibility(isChecked ? View.VISIBLE : View.GONE);
    }

    private void updateRecursionPromoUI(int recursionType) {
        switch (recursionType) {
            case Constant.Type.NO_RECURSION:
                llPromoDate.setVisibility(View.VISIBLE);
                llPromoTime.setVisibility(View.GONE);
                llDay.setVisibility(View.GONE);
                llWeek.setVisibility(View.GONE);
                llMonth.setVisibility(View.GONE);
                break;
            case Constant.Type.DAILY_RECURSION:
                llPromoDate.setVisibility(View.VISIBLE);
                llPromoTime.setVisibility(View.VISIBLE);
                llDay.setVisibility(View.GONE);
                llWeek.setVisibility(View.GONE);
                llMonth.setVisibility(View.GONE);
                break;
            case Constant.Type.WEEKLY_RECURSION:
                llPromoDate.setVisibility(View.VISIBLE);
                llPromoTime.setVisibility(View.VISIBLE);
                llDay.setVisibility(View.VISIBLE);
                llWeek.setVisibility(View.GONE);
                llMonth.setVisibility(View.GONE);
                break;
            case Constant.Type.MONTHLY_RECURSION:
                llPromoDate.setVisibility(View.VISIBLE);
                llPromoTime.setVisibility(View.VISIBLE);
                llDay.setVisibility(View.VISIBLE);
                llWeek.setVisibility(View.VISIBLE);
                llMonth.setVisibility(View.GONE);
                break;
            case Constant.Type.ANNUALLY_RECURSION:
                llPromoDate.setVisibility(View.VISIBLE);
                llPromoTime.setVisibility(View.VISIBLE);
                llDay.setVisibility(View.VISIBLE);
                llWeek.setVisibility(View.VISIBLE);
                llMonth.setVisibility(View.VISIBLE);
                break;
            default:
                break;
        }
    }

    private void initPromoRecursionDataList() {
        selectedDaysList = new ArrayList<>();
        selectedWeekList = new ArrayList<>();
        selectedMonthList = new ArrayList<>();

        daysList = new ArrayList<>();
        weekList = new ArrayList<>();
        monthList = new ArrayList<>();

        daysList.add(new PromoRecursionData(getString(R.string.text_sunday), "Sunday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_monday), "Monday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_tuesday), "Tuesday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_wednesday), "Wednesday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_thursday), "Thursday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_friday), "Friday", false));
        daysList.add(new PromoRecursionData(getString(R.string.text_saturday), "Saturday", false));

        weekList.add(new PromoRecursionData(getString(R.string.text_first), "First", false));
        weekList.add(new PromoRecursionData(getString(R.string.text_second), "Second", false));
        weekList.add(new PromoRecursionData(getString(R.string.text_third), "Third", false));
        weekList.add(new PromoRecursionData(getString(R.string.text_fourth), "Fourth", false));
        weekList.add(new PromoRecursionData(getString(R.string.text_fifth), "Fifth", false));

        monthList.add(new PromoRecursionData(getString(R.string.text_january), "January", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_february), "February", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_march), "March", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_april), "April", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_may), "May", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_june), "June", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_july), "July", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_august), "August", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_september), "September", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_october), "October", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_november), "November", false));
        monthList.add(new PromoRecursionData(getString(R.string.text_december), "December", false));

        tagGroupDay.setOnTagClickListener((v, position) -> {
            tagGroupDay.remove(position);
            selectedDaysList.remove(position);
        });
        tagGroupWeek.setOnTagClickListener((v, position) -> {
            tagGroupWeek.remove(position);
            selectedWeekList.remove(position);
        });
        tagGroupMonth.setOnTagClickListener((v, position) -> {
            tagGroupMonth.remove(position);
            selectedMonthList.remove(position);
        });
    }

    private void openPromoRecursionDialog(final ArrayList<PromoRecursionData> recursionData, final ArrayList<String> selectedList, final TagView tagView, String title) {
        for (PromoRecursionData data : recursionData) {
            data.setSelected(selectedList.contains(data.getRequestData()));
        }
        RecyclerView rcvRecursion;
        TextView tvDialogTitle;
        final BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_promo_recursion);
        rcvRecursion = dialog.findViewById(R.id.rcvRecursion);
        tvDialogTitle = dialog.findViewById(R.id.tvDialogTitle);
        tvDialogTitle.setText(title);
        rcvRecursion.setLayoutManager(new LinearLayoutManager(this));
        final PromoRecursionAdapter recursionAdapter = new PromoRecursionAdapter(recursionData);
        rcvRecursion.setAdapter(recursionAdapter);
        rcvRecursion.addOnItemTouchListener(new RecyclerTouchListener(this, rcvRecursion, new ClickListener() {

            @Override
            public void onClick(View view, int position) {
                recursionData.get(position).setSelected(!recursionData.get(position).isSelected());
                recursionAdapter.notifyItemChanged(position);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
        dialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            selectedList.clear();
            ArrayList<String> displayList = new ArrayList<>();
            for (PromoRecursionData data : recursionData) {
                if (data.isSelected()) {
                    selectedList.add(data.getRequestData());
                    displayList.add(data.getDisplayData());
                }
            }
            tagView.addTags(displayList);
            dialog.dismiss();
        });
        dialog.findViewById(R.id.btnNegative).setOnClickListener(view -> dialog.dismiss());
        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.setCancelable(false);
        dialog.show();
    }

    private void showPhotoSelectionDialog() {
        new CustomPhotoDialog(this) {
            @Override
            public void gallery() {
                choosePhotoFromGallery();
            }

            @Override
            public void camera() {
                takePhotoFromCameraPermission();
            }
        }.show();
    }

    private void choosePhotoFromGallery() {
        if (ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_CHOOSE_PHOTO);
        } else {
            Intent galleryIntent = new Intent();
            galleryIntent.setType("image/*");
            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(galleryIntent, Constant.PERMISSION_CHOOSE_PHOTO);
        }
    }

    private void takePhotoFromCameraPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_TAKE_PHOTO);
        } else {
            takePhotoFromCamera();
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        uri = imageHelper.createTakePictureUri();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        startActivityForResult(intent, Constant.PERMISSION_TAKE_PHOTO);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case Constant.PERMISSION_CHOOSE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        choosePhotoFromGallery();
                    }
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        takePhotoFromCameraPermission();
                    }
                }
                break;
            default:
                break;
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case Constant.PERMISSION_CHOOSE_PHOTO:
                    if (data != null) {
                        uri = data.getData();
                        beginCrop(uri);
                    }
                    break;
                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        beginCrop(uri);
                    }
                    break;
                case Crop.REQUEST_CROP:
                    setImage(Crop.getOutput(data), ivPromoImage);
                    break;
                default:
                    break;
            }
        }
    }

    private void setImage(Uri uri, ImageView imageView) {
        File file = ImageHelper.getFromMediaUriPfd(this, this.getContentResolver(), uri);
        if (file != null) {
            GlideApp.with(this).load(uri).error(R.drawable.icon_default_profile).into(imageView);
            imageView.setTag(R.drawable.placeholder, file.getPath());
        }
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        Uri outputUri = Uri.fromFile(imageHelper.createImageFile());
        Crop.of(sourceUri, outputUri).start(this);
    }
}