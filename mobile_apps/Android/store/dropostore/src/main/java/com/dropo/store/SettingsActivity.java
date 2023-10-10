package com.dropo.store;

import static com.dropo.store.utils.Constant.FAMOUS_TAG_LIST;
import static com.dropo.store.utils.Constant.REQUEST_STORE_TIME;
import static com.dropo.store.utils.Constant.STORE_LOCATION_RESULT;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.cardview.widget.CardView;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.adapter.CancellationSpinnerAdapter;
import com.dropo.store.component.tag.TagLayout;
import com.dropo.store.component.tag.TagView;
import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.models.datamodel.StoreData;
import com.dropo.store.models.datamodel.StoreSettings;
import com.dropo.store.models.datamodel.StoreTime;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.ResizeAnimation;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomCheckBox;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SettingsActivity extends BaseActivity implements CompoundButton.OnCheckedChangeListener {

    private final List<Languages> tempSelectedLangs = new ArrayList<>();
    private final ArrayList<Integer> cancellationFrom = new ArrayList<>();
    private final ArrayList<Integer> cancellationTill = new ArrayList<>();
    public boolean isEditable;
    String priceRatings;
    private int chargeType;
    private EditText etAddress, etLat, etLng, etFreeDeliveryPrice, etVerifyPassword, etSlogan, etWebsite;
    private CustomInputEditText etCancellationChargeAbovePrice, etCancellationChargeValue, etMaxQuantity, etMinimumOrderPrice,
            etScheduleOrderCreateAfterMinute, etInformScheduleOrderBeforeMinute, etDeliveryRadius, etFreeDeliveryRadius,
            etDeliveryTime, etDeliveryTimeMax;
    private SwitchCompat switchBusiness, switchPayDeliveryFees, switchOrderCancellationCharge, switchProviderDeliveryAnywhere,
            switchTakingScheduleOrder, switchBusy, switchAskEstimatedTime, switchProvidePickupDelivery, switchProvideDelivery,
            switchIsUseItemTax, switchIsTaxIncluded;
    private SwitchCompat switchIsSetDeliveryStoreTime;
    private BottomSheetDialog dialog;
    private CustomTextView tvScheduleStoreTime, tvCurrency, tvAddNewTag, tvCancellationMsg;
    private ArrayList<StoreTime> storeTimeList, storeDeliveryTimeList;
    private LatLng latLng;
    private ImageView ivStoreLocation;
    private Spinner spinnerPriceRatting, spinnerChargeType, spinnerCancellationStateFrom, spinnerCancellationStateTill;
    private LinearLayout llPayDeliveryFees, llScheduleOrder, llDeliveryAnyWhere, llCancellationCharge;
    private StoreData storeData;
    private CardView cvCancellationCharge;
    private LinearLayout llLangs;
    private List<Languages> selectedLanguages;
    private List<Languages> adminLanguagges;
    private TextView tvAddNewStoreDeliverySlot, tvSelectLanguages;
    private TagLayout tagViewTax;
    private CancellationSpinnerAdapter cancellationSpinnerAdapterTill;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(SettingsActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_settings));
        tvCurrency = findViewById(R.id.tvCurrency);
        switchPayDeliveryFees = findViewById(R.id.switchPayDeliveryFees);
        spinnerPriceRatting = findViewById(R.id.spinnerPriceRatting);
        etAddress = findViewById(R.id.etAddress);
        etLat = findViewById(R.id.etLat);
        etLng = findViewById(R.id.etLng);
        tagViewTax = findViewById(R.id.tagViewTax);
        etSlogan = findViewById(R.id.etSlogan);
        etWebsite = findViewById(R.id.etWebsite);
        etFreeDeliveryPrice = findViewById(R.id.etFreeDeliveryPrice);
        switchBusiness = findViewById(R.id.switchBusiness);
        ivStoreLocation = findViewById(R.id.ivStoreLocation);
        ivStoreLocation.setOnClickListener(this);
        tvScheduleStoreTime = findViewById(R.id.tvAddNewStoreTime);
        storeTimeList = new ArrayList<>();
        storeDeliveryTimeList = new ArrayList<>();
        tvScheduleStoreTime.setOnClickListener(this);
        tvCurrency.setText(String.format("(%s)", preferenceHelper.getCurrency()));
        switchPayDeliveryFees.setChecked(preferenceHelper.getIsPushNotificationSoundOn());
        etCancellationChargeAbovePrice = findViewById(R.id.etCancellationChargeAbovePrice);
        etCancellationChargeValue = findViewById(R.id.etCancellationChargeValue);
        etMaxQuantity = findViewById(R.id.etMaxQuantity);
        etMinimumOrderPrice = findViewById(R.id.etMinimumOrderPrice);
        etScheduleOrderCreateAfterMinute = findViewById(R.id.etScheduleOrderCreateAfterMinute);
        etInformScheduleOrderBeforeMinute = findViewById(R.id.etInformScheduleOrderBeforeMinute);
        etDeliveryRadius = findViewById(R.id.etDeliveryRadius);
        etDeliveryTime = findViewById(R.id.etDeliveryTime);
        etDeliveryTimeMax = findViewById(R.id.etDeliveryTimeMax);
        switchOrderCancellationCharge = findViewById(R.id.switchOrderCancellationCharge);
        switchProviderDeliveryAnywhere = findViewById(R.id.switchProviderDeliveryAnywhere);
        switchTakingScheduleOrder = findViewById(R.id.switchTakingScheduleOrder);
        switchIsSetDeliveryStoreTime = findViewById(R.id.switchIsSetDeliveryTime);
        spinnerChargeType = findViewById(R.id.spinnerChargeType);
        spinnerCancellationStateFrom = findViewById(R.id.spinnerCancellationStateFrom);
        spinnerCancellationStateTill = findViewById(R.id.spinnerCancellationStateTill);
        llPayDeliveryFees = findViewById(R.id.llPayDeliveryFees);
        llScheduleOrder = findViewById(R.id.llScheduleOrder);
        llDeliveryAnyWhere = findViewById(R.id.llDeliveryAnyWhere);
        llCancellationCharge = findViewById(R.id.llCancellationCharge);
        etFreeDeliveryRadius = findViewById(R.id.etFreeDeliveryRadius);
        switchBusy = findViewById(R.id.switchBusy);
        switchAskEstimatedTime = findViewById(R.id.switchAskEstimatedTime);
        tvAddNewTag = findViewById(R.id.tvAddNewTag);
        tvCancellationMsg = findViewById(R.id.tvCancellationMsg);
        switchProvidePickupDelivery = findViewById(R.id.switchProvidePickupDelivery);
        switchProvideDelivery = findViewById(R.id.switchProvideDelivery);
        tvAddNewStoreDeliverySlot = findViewById(R.id.tvAddNewStoreDeliverySlot);
        tvSelectLanguages = findViewById(R.id.tvSelectLanguages);
        tvSelectLanguages.setOnClickListener(this);
        tvAddNewTag.setOnClickListener(this);
        switchIsSetDeliveryStoreTime.setOnCheckedChangeListener(this);
        switchIsSetDeliveryStoreTime.setChecked(true);
        switchPayDeliveryFees.setOnCheckedChangeListener(this);
        switchOrderCancellationCharge.setOnCheckedChangeListener(this);
        switchProviderDeliveryAnywhere.setOnCheckedChangeListener(this);
        switchTakingScheduleOrder.setOnCheckedChangeListener(this);
        switchProvidePickupDelivery.setOnCheckedChangeListener(this);
        switchProvideDelivery.setOnCheckedChangeListener(this);
        switchAskEstimatedTime.setOnClickListener(this);

        etAddress.setOnClickListener(this);
        switchIsUseItemTax = findViewById(R.id.switchIsUseItemTax);
        switchIsTaxIncluded = findViewById(R.id.switchIsTaxIncluded);
        cvCancellationCharge = findViewById(R.id.cvCancellationCharge);

        cvCancellationCharge.setVisibility(PreferenceHelper.getPreferenceHelper(this).getIsStoreCanSetCancellationCharge() ? View.VISIBLE : View.GONE);
        selectedLanguages = Language.getInstance().getStoreLanguages();
        adminLanguagges = Language.getInstance().getAdminLanguages();

        initSpinnerCancellationChargeType();
        initSpinnerCancellationTill();
        initSpinnerCancellationFrom();
        initSpinnerForPriceRatings();
        setEnableView(false);
        getSettingsData();
    }


    private void setEnableView(boolean isEnable) {
        etFreeDeliveryPrice.setEnabled(isEnable);
        etSlogan.setEnabled(isEnable);
        etWebsite.setEnabled(isEnable);
        switchBusiness.setEnabled(isEnable);
        switchBusy.setEnabled(isEnable);
        switchPayDeliveryFees.setEnabled(isEnable);
        tvScheduleStoreTime.setEnabled(isEnable);
        tvAddNewStoreDeliverySlot.setEnabled(isEnable);
        tvSelectLanguages.setEnabled(isEnable);
        etLat.setFocusableInTouchMode(isEnable);
        etLng.setFocusableInTouchMode(isEnable);
        etFreeDeliveryPrice.setFocusableInTouchMode(isEnable);
        etSlogan.setFocusableInTouchMode(isEnable);
        etWebsite.setFocusableInTouchMode(isEnable);
        etDeliveryTime.setFocusableInTouchMode(isEnable);
        etDeliveryTimeMax.setFocusableInTouchMode(isEnable);
        etDeliveryTime.setEnabled(isEnable);
        etDeliveryTimeMax.setEnabled(isEnable);
        spinnerPriceRatting.setEnabled(isEnable);
        ivStoreLocation.setEnabled(isEnable);

        etFreeDeliveryRadius.setEnabled(isEnable);
        etCancellationChargeAbovePrice.setEnabled(isEnable);
        etCancellationChargeValue.setEnabled(isEnable);
        etMaxQuantity.setEnabled(isEnable);
        etMinimumOrderPrice.setEnabled(isEnable);
        etScheduleOrderCreateAfterMinute.setEnabled(isEnable);
        etInformScheduleOrderBeforeMinute.setEnabled(isEnable);
        etDeliveryRadius.setEnabled(isEnable);
        etAddress.setEnabled(isEnable);
        etFreeDeliveryRadius.setFocusableInTouchMode(isEnable);
        etCancellationChargeAbovePrice.setFocusableInTouchMode(isEnable);
        etCancellationChargeValue.setFocusableInTouchMode(isEnable);
        etMaxQuantity.setFocusableInTouchMode(isEnable);
        etMinimumOrderPrice.setFocusableInTouchMode(isEnable);
        etScheduleOrderCreateAfterMinute.setFocusableInTouchMode(isEnable);
        etInformScheduleOrderBeforeMinute.setFocusableInTouchMode(isEnable);
        etDeliveryRadius.setFocusableInTouchMode(isEnable);

        switchOrderCancellationCharge.setEnabled(isEnable);
        switchProviderDeliveryAnywhere.setEnabled(isEnable);
        switchTakingScheduleOrder.setEnabled(isEnable);

        spinnerChargeType.setEnabled(isEnable);
        spinnerCancellationStateFrom.setEnabled(isEnable);
        spinnerCancellationStateTill.setEnabled(isEnable);
        tvAddNewTag.setEnabled(isEnable);
        switchAskEstimatedTime.setEnabled(isEnable);
        switchProvidePickupDelivery.setEnabled(isEnable);
        switchProvideDelivery.setEnabled(isEnable);
        switchIsUseItemTax.setEnabled(isEnable);
        switchIsTaxIncluded.setEnabled(isEnable);
        switchIsSetDeliveryStoreTime.setEnabled(isEnable);
        tagViewTax.setTagMode(isEnable ? TagView.MODE_MULTI_CHOICE : TagView.MODE_NORMAL);
    }

    /**
     * this method call webservice for get setting detail
     */
    protected void getSettingsData() {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        Call<StoreDataResponse> call = ApiClient.getClient().create(ApiInterface.class).getStoreDate(map);

        call.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        storeData = response.body().getStoreDetail();
                        preferenceHelper.putIsStoreCanCreateGroup(storeData.getDeliveryDetails().isStoreCanCreateGroup());
                        storeTimeList.clear();
                        storeDeliveryTimeList.clear();
                        storeTimeList.addAll(response.body().getStoreDetail().getStoreTime());
                        storeDeliveryTimeList.addAll(response.body().getStoreDetail().getStoreDeliveryTime());
                        setSettingsData();
                    } else {
                        ParseContent.getInstance().showErrorMessage(SettingsActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SettingsActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @SuppressLint("Recycle")
    private void setSettingsData() {
        if (storeData != null) {
            etAddress.setText(storeData.getAddress());
            etLat.setText(String.valueOf(storeData.getLocation().get(0)));
            etLng.setText(String.valueOf(storeData.getLocation().get(1)));
            etSlogan.setText(storeData.getSlogan());
            etWebsite.setText(storeData.getWebsiteUrl());
            etFreeDeliveryPrice.setText(String.valueOf(storeData.getFreeDeliveryPrice()));

            priceRatings = String.valueOf(storeData.getPriceRating());

            TypedArray array2 = getResources().obtainTypedArray(R.array.price_rating);
            for (int i = 0; i < array2.length(); i++) {
                if (TextUtils.equals(priceRatings, array2.getString(i))) {
                    spinnerPriceRatting.setSelection(i);
                    break;
                }
            }

            etCancellationChargeAbovePrice.setText(String.valueOf(storeData.getOrderCancellationChargeForAboveOrderPrice()));
            etCancellationChargeValue.setText(String.valueOf(storeData.getOrderCancellationChargeValue()));
            etMaxQuantity.setText(String.valueOf(storeData.getMaxItemQuantityAddByUser()));
            etMinimumOrderPrice.setText(String.valueOf(storeData.getMinOrderPrice()));
            etScheduleOrderCreateAfterMinute.setText(String.valueOf(storeData.getScheduleOrderCreateAfterMinute()));
            etInformScheduleOrderBeforeMinute.setText(String.valueOf(storeData.getInformScheduleOrderBeforeMin()));
            etFreeDeliveryRadius.setText(String.valueOf(storeData.getFreeDeliveryWithinRadius()));
            etDeliveryRadius.setText(String.valueOf(storeData.getDeliveryRadius()));
            switchIsSetDeliveryStoreTime.setChecked(storeData.isStoreSetScheduleDeliveryTime());
            switchPayDeliveryFees.setChecked(storeData.isStorePayDeliveryFees());
            switchOrderCancellationCharge.setChecked(storeData.isIsOrderCancellationChargeApply());
            // when isIsOrderCancellationChargeApply true then it will called onCheckedChanged so no need to setup UI.
            if (!storeData.isIsOrderCancellationChargeApply()) {
                updateCancellationStatusUI(false);
            }
            switchProviderDeliveryAnywhere.setChecked(storeData.isIsProvideDeliveryAnywhere());
            switchTakingScheduleOrder.setChecked(storeData.isIsTakingScheduleOrder());
            switchAskEstimatedTime.setChecked(storeData.isAskEstimatedTimeForReadyOrder());
            switchBusiness.setChecked(storeData.isBusiness());
            switchBusy.setChecked(storeData.isBusy());
            switchProvidePickupDelivery.setChecked(storeData.isProvidePickupDelivery());
            switchProvideDelivery.setChecked(storeData.isProvideDelivery());
            scaleUpAndDown(llPayDeliveryFees, storeData.isStorePayDeliveryFees(), R.dimen.dimen_expand_penal_content_2);
            scaleUpAndDown(llCancellationCharge, storeData.isIsOrderCancellationChargeApply(), R.dimen.dimen_expand_penal_content_3);
            scaleUpAndDown(llDeliveryAnyWhere, !storeData.isIsProvideDeliveryAnywhere(), R.dimen.dimen_expand_penal_content_1);
            scaleUpAndDown(llScheduleOrder, storeData.isIsTakingScheduleOrder(), R.dimen.dimen_expand_penal_content_1);
            chargeType = storeData.getOrderCancellationChargeType();
            TypedArray array4 = getResources().obtainTypedArray(R.array.cancellation_charge_type_value);
            for (int i = 0; i < array4.length(); i++) {
                if (TextUtils.equals(String.valueOf(chargeType), array4.getString(i))) {
                    spinnerChargeType.setSelection(i);
                    break;
                }
            }
            etDeliveryTime.setText(String.valueOf(storeData.getDeliveryTime()));
            etDeliveryTimeMax.setText(String.valueOf(storeData.getDeliveryTimeMax()));
            switchIsUseItemTax.setChecked(storeData.isUseItemTax());
            switchIsTaxIncluded.setChecked(storeData.isTaxIncluded());
            setTaxTags(storeData.getStoreTaxesDetails());
        }
    }

    private void setTaxTags(List<TaxesDetail> storeTaxesDetails) {
        List<TaxesDetail> taxDetails = storeData.getTaxDetails();
        ArrayList<String> taxTags = new ArrayList<String>();
        ArrayList<Integer> selectedTags = new ArrayList<>();
        for (int i = 0; i < taxDetails.size(); i++) {
            TaxesDetail taxesDetail = taxDetails.get(i);
            for (TaxesDetail selected : storeTaxesDetails) {
                if (selected.getId().equals(taxesDetail.getId())) {
                    selectedTags.add(i);
                }
            }
            taxTags.add(Utilities.getDetailStringFromList(taxesDetail.getTaxName(), Language.getInstance().getStoreLanguageIndex()) + " " + taxesDetail.getTax() + "%");
        }
        tagViewTax.cleanTags();
        tagViewTax.setTags(taxTags);
        new Handler().postDelayed(() -> tagViewTax.setCheckTag(selectedTags), 200); // select tag with delay, it will take time to draw.
    }

    private void validate() {
        if (TextUtils.isEmpty(etAddress.getText().toString())) {
            etAddress.setError(this.getResources().getString(R.string.msg_empty_address));
        } else if (TextUtils.isEmpty(etLat.getText().toString())) {
            etAddress.setError(this.getResources().getString(R.string.msg_empty_address));
        } else if (TextUtils.isEmpty(etLng.getText().toString())) {
            etAddress.setError(this.getResources().getString(R.string.msg_empty_address));
        } else if (isInvalidNumber(etFreeDeliveryPrice, switchPayDeliveryFees.isChecked())) {
            etFreeDeliveryPrice.setError(getResources().getString(R.string.msg_plz_enter_valid_amount));
            etFreeDeliveryPrice.requestFocus();
        } else if (isInvalidNumber(etFreeDeliveryRadius, switchPayDeliveryFees.isChecked())) {
            etFreeDeliveryRadius.setError(getResources().getString(R.string.msg_invalid_data));
            etFreeDeliveryRadius.requestFocus();
        } else if (isInvalidNumber(etCancellationChargeAbovePrice, switchOrderCancellationCharge.isChecked())) {
            etCancellationChargeAbovePrice.setError(getResources().getString(R.string.msg_plz_enter_valid_amount));
            etCancellationChargeAbovePrice.requestFocus();
        } else if (isInvalidNumber(etCancellationChargeValue, switchOrderCancellationCharge.isChecked())) {
            etCancellationChargeValue.setError(getResources().getString(R.string.msg_plz_enter_valid_amount));
            etCancellationChargeValue.requestFocus();
        } else if (isInvalidPercentage(etCancellationChargeValue, chargeType == 1 && switchOrderCancellationCharge.isChecked())) {
            etCancellationChargeValue.setError(getResources().getString(R.string.msg_plz_enter_valid_value));
            etCancellationChargeValue.requestFocus();
        } else if (isInvalidNumber(etDeliveryRadius, !switchProviderDeliveryAnywhere.isChecked())) {
            etDeliveryRadius.setError(getResources().getString(R.string.msg_invalid_data));
            etDeliveryRadius.requestFocus();
        } else if (isInvalidNumber(etScheduleOrderCreateAfterMinute, switchTakingScheduleOrder.isChecked())) {
            etScheduleOrderCreateAfterMinute.setError(getResources().getString(R.string.msg_invalid_data));
            etScheduleOrderCreateAfterMinute.requestFocus();
        } else if (isInvalidNumber(etInformScheduleOrderBeforeMinute, switchTakingScheduleOrder.isChecked())) {
            etInformScheduleOrderBeforeMinute.setError(getResources().getString(R.string.msg_invalid_data));
            etInformScheduleOrderBeforeMinute.requestFocus();
        } else if (isInvalidNumber(etMinimumOrderPrice, true)) {
            etMinimumOrderPrice.setError(getResources().getString(R.string.msg_plz_enter_valid_amount));
            etMinimumOrderPrice.requestFocus();
        } else if (isInvalidNumber(etDeliveryTime, true)) {
            etDeliveryTime.setError(getResources().getString(R.string.msg_plz_enter_valid_time));
            etDeliveryTime.requestFocus();
        } else if (isInvalidNumber(etDeliveryTimeMax, true) || Integer.parseInt(etDeliveryTimeMax.getText().toString()) <= Integer.parseInt(etDeliveryTime.getText().toString())) {
            etDeliveryTimeMax.setError(getResources().getString(R.string.msg_plz_enter_valid_time_max));
            etDeliveryTimeMax.requestFocus();
        } else if (isInvalidNumber(etMaxQuantity, true)) {
            etMaxQuantity.setError(getResources().getString(R.string.msg_invalid_data));
            etMaxQuantity.requestFocus();
        } else if (isInvalidNumber(etDeliveryRadius, !switchProviderDeliveryAnywhere.isChecked()) && !switchProvidePickupDelivery.isChecked()) {
            Utilities.showToast(this, getResources().getString(R.string.msg_plz_enter_valid_radius));
        } else if (Double.parseDouble(etDeliveryRadius.getText().toString().trim()) <= 0 && !switchProviderDeliveryAnywhere.isChecked()) {
            Utilities.showToast(this, getResources().getString(R.string.msg_plz_enter_valid_radius));
        } else {
            showVerificationDialog();
        }
    }

    private boolean isInvalidNumber(EditText view, boolean isRequired) {
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

    private boolean isInvalidPercentage(EditText view, boolean isRequired) {
        if (isRequired) {
            try {
                return Double.parseDouble(view.getText().toString()) > 100;
            } catch (NumberFormatException e) {
                return true;
            }
        } else {
            return false;
        }
    }

    /**
     * this method call webservice for update setting detail
     *
     * @param currentPassword currentPassword
     */
    private void updateSettingsData(String currentPassword) {
        Utilities.showProgressDialog(this);

        StoreSettings storeDataSend = new StoreSettings();
        storeDataSend.setStoreSetScheduleDeliveryTime(switchIsSetDeliveryStoreTime.isChecked());
        storeDataSend.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
        storeDataSend.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
        storeDataSend.setAddress(etAddress.getText().toString().trim());
        storeDataSend.setLatitude(Double.parseDouble(etLat.getText().toString()));
        storeDataSend.setLongitude(Double.parseDouble(etLng.getText().toString()));
        storeDataSend.setBusiness(switchBusiness.isChecked());
        storeDataSend.setFreeDeliveryPrice(Utilities.roundDecimal(Double.parseDouble(etFreeDeliveryPrice.getText().toString())));
        storeDataSend.setSlogan(etSlogan.getText().toString().trim());
        storeDataSend.setWebsiteUrl(etWebsite.getText().toString().trim());
        storeDataSend.setStorePayDeliveryFees(switchPayDeliveryFees.isChecked());
        storeDataSend.setPriceRating(Integer.parseInt(priceRatings));
        storeDataSend.setMinOrderPrice(Utilities.roundDecimal(Double.parseDouble(etMinimumOrderPrice.getText().toString())));
        storeDataSend.setInformScheduleOrderBeforeMin(Integer.parseInt(etInformScheduleOrderBeforeMinute.getText().toString()));
        storeDataSend.setIsTakingScheduleOrder(switchTakingScheduleOrder.isChecked());
        storeDataSend.setDeliveryRadius(Utilities.roundDecimal(Double.parseDouble(etDeliveryRadius.getText().toString())));
        storeDataSend.setIsProvideDeliveryAnywhere(switchProviderDeliveryAnywhere.isChecked());
        storeDataSend.setScheduleOrderCreateAfterMinute(Integer.parseInt(etScheduleOrderCreateAfterMinute.getText().toString()));
        storeDataSend.setMaxItemQuantityAddByUser(Integer.parseInt(etMaxQuantity.getText().toString()));
        storeDataSend.setOrderCancellationChargeValue(Utilities.roundDecimal(Double.parseDouble(etCancellationChargeValue.getText().toString())));
        storeDataSend.setOrderCancellationChargeType(chargeType);
        storeDataSend.setOrderCancellationChargeForAboveOrderPrice(Utilities.roundDecimal(Double.parseDouble(etCancellationChargeAbovePrice.getText().toString())));
        storeDataSend.setIsOrderCancellationChargeApply(switchOrderCancellationCharge.isChecked());
        storeDataSend.setBusy(switchBusy.isChecked());
        storeDataSend.setFreeDeliveryWithinRadius(Utilities.roundDecimal(Double.parseDouble(etFreeDeliveryRadius.getText().toString())));
        storeDataSend.setAskEstimatedTimeForReadyOrder(switchAskEstimatedTime.isChecked());
        storeDataSend.setDeliveryTime(Integer.parseInt(etDeliveryTime.getText().toString()));
        storeDataSend.setDeliveryTimeMax(Integer.parseInt(etDeliveryTimeMax.getText().toString()));
        storeDataSend.setProvidePickupDelivery(switchProvidePickupDelivery.isChecked());
        storeDataSend.setProvideDelivery(switchProvideDelivery.isChecked());
        storeDataSend.setCancellationChargeApplyFrom(switchOrderCancellationCharge.isChecked() ? cancellationFrom.get(spinnerCancellationStateFrom.getSelectedItemPosition()) : 0);
        storeDataSend.setCancellationChargeApplyTill(cancellationTill.get(spinnerCancellationStateTill.getSelectedItemPosition()));
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            storeDataSend.setOldPassword(currentPassword);
            storeDataSend.setSocialId("");
            storeDataSend.setLoginBy(Constant.MANUAL);
        } else {
            storeDataSend.setOldPassword("");
            storeDataSend.setSocialId(preferenceHelper.getSocialId());
            storeDataSend.setLoginBy(Constant.SOCIAL);
        }
        storeDataSend.setStoreTime(storeTimeList);
        //TODO : TAG CHANGES
        storeDataSend.setFamousProductsTagIds(storeData.getFamousProductsTagIds());
        storeDataSend.setUseItemTax(switchIsUseItemTax.isChecked());
        storeDataSend.setTaxIncluded(switchIsTaxIncluded.isChecked());

        if (!tempSelectedLangs.isEmpty()) {
            for (Languages storeLanguage : selectedLanguages) {
                storeLanguage.setVisible(false);
            }
        }
        for (Languages language : tempSelectedLangs) {
            boolean isLanguageIncluded = false;
            for (Languages storeLanguage : selectedLanguages) {
                if (language.getCode().equals(storeLanguage.getCode())) {
                    storeLanguage.setVisible(true);
                    isLanguageIncluded = true;
                    break;
                }
            }
            if (!isLanguageIncluded) selectedLanguages.add(language);

        }
        storeDataSend.setLanguages(selectedLanguages);
        ArrayList<String> taxes = new ArrayList<>();
        for (int i = 0; i < storeData.getTaxDetails().size(); i++) {
            if (tagViewTax.getCheckedTagsPosition().contains(i)) {
                taxes.add(storeData.getTaxDetails().get(i).getId());
            }
        }
        storeDataSend.setTaxes(taxes);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<StoreDataResponse> call = apiInterface.updateSettings(ApiClient.makeGSONRequestBody(storeDataSend));
        call.enqueue(new Callback<StoreDataResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreDataResponse> call, @NonNull Response<StoreDataResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        parseContent.parseStoreData(response.body(), true);
                        setEnableView(false);
                        setTaxTags(response.body().getStoreData().getStoreTaxesDetails());
                        isEditable = false;
                        setToolbarEditIcon(true, R.drawable.ic_edit);
                        setToolbarSaveIcon(false);
                        ParseContent.getInstance().showMessage(SettingsActivity.this, response.body().getStatusPhrase());
                    } else {
                        ParseContent.getInstance().showErrorMessage(SettingsActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SettingsActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreDataResponse> call, @NonNull Throwable t) {
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
                        updateSettingsData(etVerifyPassword.getText().toString());
                        dialog.dismiss();
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
            updateSettingsData("");
        }


    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.tvAddNewStoreTime) {
            goToStoreTimeActivity();
        } else if (id == R.id.tvAddNewStoreDeliverySlot) {
            goToStoreDeliveryTimeActivity();
        } else if (id == R.id.tvSelectLanguages) {
            openAdminLanguageDialog();
        } else if (id == R.id.ivStoreLocation || id == R.id.etAddress) {
            setStoreAddressORLocation();
        } else if (id == R.id.tvAddNewTag) {
            goToFamousForActivity(storeData);
        }
    }

    private void initSpinnerCancellationChargeType() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.cancellation_charge_type, R.layout.spinner_view_big);
        final CharSequence[] chargeTypes = getResources().getTextArray(R.array.cancellation_charge_type_value);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerChargeType.setAdapter(adapter);
        spinnerChargeType.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                chargeType = Integer.parseInt((String) chargeTypes[i]);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void initSpinnerCancellationFrom() {
        cancellationFrom.addAll(getCancellationStatus(0));
        CancellationSpinnerAdapter cancellationSpinnerAdapterFrom = new CancellationSpinnerAdapter(this, cancellationFrom);
        spinnerCancellationStateFrom.setAdapter(cancellationSpinnerAdapterFrom);
        spinnerCancellationStateFrom.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                cancellationTill.clear();
                cancellationTill.addAll(getCancellationStatus(cancellationFrom.get(i)));
                cancellationSpinnerAdapterTill.notifyDataSetChanged();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    private void initSpinnerCancellationTill() {
        cancellationTill.addAll(getCancellationStatus(0));
        cancellationSpinnerAdapterTill = new CancellationSpinnerAdapter(this, cancellationTill);
        spinnerCancellationStateTill.setAdapter(cancellationSpinnerAdapterTill);
    }


    private void initSpinnerForPriceRatings() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.price_rating, R.layout.spinner_view_big);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_big);
        spinnerPriceRatting.setAdapter(adapter);
        spinnerPriceRatting.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                priceRatings = (String) adapterView.getItemAtPosition(i);
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case STORE_LOCATION_RESULT:
                    Bundle bundle = data.getExtras();
                    etAddress.setText(bundle.getString(Constant.ADDRESS));
                    etLat.setText(String.valueOf(bundle.getDouble(Constant.LATITUDE)));
                    etLng.setText(String.valueOf(bundle.getDouble(Constant.LONGITUDE)));
                    break;
                case REQUEST_STORE_TIME:
                    getSettingsData();
                    break;
                case FAMOUS_TAG_LIST:
                    Bundle bundle1 = data.getExtras();
                    storeData.setFamousProductsTagIds((ArrayList<String>) bundle1.getSerializable(Constant.BUNDLE));
                    break;
                default:
                    // result from facebook
                    break;
            }
        }
    }

    private void setStoreAddressORLocation() {
        Intent intent = new Intent(this, StoreLocationActivity.class);
        startActivityForResult(intent, STORE_LOCATION_RESULT);
    }

    private void goToStoreTimeActivity() {
        Intent intent = new Intent(this, StoreTimeActivity.class);
        intent.putExtra(Constant.STORE_TIME, storeTimeList);
        startActivityForResult(intent, Constant.REQUEST_STORE_TIME);
    }

    private void goToStoreDeliveryTimeActivity() {
        Intent intent = new Intent(this, StoreDeliveryTimeActivity.class);
        intent.putExtra(Constant.STORE_TIME, storeDeliveryTimeList);
        startActivityForResult(intent, Constant.REQUEST_STORE_TIME);
    }

    private void scaleUpAndDown(final View view, boolean isShow, int dimension) {
        if (isShow) {
            ResizeAnimation resizeAnimation = new ResizeAnimation(view, getResources().getDimensionPixelSize(dimension));
            resizeAnimation.setInterpolator(new LinearInterpolator());
            resizeAnimation.setDuration(300);
            view.startAnimation(resizeAnimation);
            view.setVisibility(View.VISIBLE);
        } else {
            ResizeAnimation resizeAnimation = new ResizeAnimation(view, 1);
            resizeAnimation.setInterpolator(new LinearInterpolator());
            resizeAnimation.setDuration(300);
            view.startAnimation(resizeAnimation);
            view.getAnimation().setAnimationListener(new Animation.AnimationListener() {
                @Override
                public void onAnimationStart(Animation animation) {

                }

                @Override
                public void onAnimationEnd(Animation animation) {
                    view.setVisibility(View.GONE);
                }

                @Override
                public void onAnimationRepeat(Animation animation) {

                }
            });
        }

    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        int id = buttonView.getId();
        if (id == R.id.switchPayDeliveryFees) {
            scaleUpAndDown(llPayDeliveryFees, isChecked, R.dimen.dimen_expand_penal_content_2);
        } else if (id == R.id.switchOrderCancellationCharge) {
            updateCancellationStatusUI(isChecked);
            scaleUpAndDown(llCancellationCharge, isChecked, R.dimen.dimen_expand_penal_content_3);
        } else if (id == R.id.switchProviderDeliveryAnywhere) {
            scaleUpAndDown(llDeliveryAnyWhere, !isChecked, R.dimen.dimen_expand_penal_content_1);
        } else if (id == R.id.switchTakingScheduleOrder) {
            scaleUpAndDown(llScheduleOrder, isChecked, R.dimen.dimen_expand_penal_content_1);
        } else if (id == R.id.switchIsSetDeliveryTime) {
            if (isChecked) {
                tvAddNewStoreDeliverySlot.setOnClickListener(SettingsActivity.this);
                tvAddNewStoreDeliverySlot.setAlpha(1f);
            } else {
                tvAddNewStoreDeliverySlot.setOnClickListener(null);
                tvAddNewStoreDeliverySlot.setAlpha(0.5f);
            }
        } else if (id == R.id.switchProvidePickupDelivery) {
            if (!isChecked) {
                switchProvideDelivery.setChecked(true);
            }
        } else if (id == R.id.switchProvideDelivery) {
            if (!isChecked) {
                switchProvidePickupDelivery.setChecked(true);
            }
        }
    }

    private void updateCancellationStatusUI(boolean isChecked) {
        if (isChecked) {
            spinnerCancellationStateFrom.setVisibility(View.VISIBLE);
            tvCancellationMsg.setText(getString(R.string.text_cancellation_charge_apply_between_states));
            for (int i = 0; i < cancellationFrom.size(); i++) {
                if (cancellationFrom.get(i) == storeData.getCancellationChargeApplyFrom()) {
                    spinnerCancellationStateFrom.setSelection(i);
                    break;
                }
            }
            new Handler(Looper.myLooper()).postDelayed(() -> {
                for (int i = 0; i < cancellationTill.size(); i++) {
                    if (cancellationTill.get(i) == storeData.getCancellationChargeApplyTill()) {
                        spinnerCancellationStateTill.setSelection(i);
                        break;
                    }
                }
            }, 100);
        } else {
            tvCancellationMsg.setText(getString(R.string.text_cancellation_charge_apply_till_state));
            cancellationTill.clear();
            cancellationTill.addAll(getCancellationStatus(0));
            cancellationSpinnerAdapterTill.notifyDataSetChanged();
            spinnerCancellationStateFrom.setVisibility(View.GONE);
            for (int i = 0; i < cancellationTill.size(); i++) {
                if (cancellationTill.get(i) == storeData.getCancellationChargeApplyTill()) {
                    spinnerCancellationStateTill.setSelection(i);
                    break;
                }
            }
        }
    }

    private void goToFamousForActivity(StoreData storeData) {
        Intent intent = new Intent(this, FamousForActivity.class);
        intent.putExtra(Constant.BUNDLE, storeData);
        startActivityForResult(intent, Constant.FAMOUS_TAG_LIST);
    }

    private void openAdminLanguageDialog() {
        final Dialog languageDialog = new BottomSheetDialog(this);
        languageDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        languageDialog.setContentView(R.layout.dialog_admin_language);
        llLangs = languageDialog.findViewById(R.id.llLangs);
        languageDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> languageDialog.dismiss());
        if (tempSelectedLangs.isEmpty()) {
            tempSelectedLangs.addAll(selectedLanguages);
        }
        for (Languages languages : adminLanguagges) {
            LinearLayout ll = new LinearLayout(this);
            ll.setOrientation(LinearLayout.VERTICAL);
            ll.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT));
            ll.setPadding(getResources().getDimensionPixelOffset(R.dimen.activity_horizontal_padding), 0, getResources().getDimensionPixelOffset(R.dimen.activity_horizontal_padding), 0);
            ll.setGravity(Gravity.START);
            final CustomCheckBox cb = new CustomCheckBox(this);
            cb.setCheckBoxColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_light, null), AppColor.COLOR_THEME);
            cb.setTextColor(AppColor.getThemeTextColor(this));
            cb.setText(languages.getName());
            cb.setPadding(getResources().getDimensionPixelOffset(R.dimen.dimen_app_edit_text_padding), 0, getResources().getDimensionPixelOffset(R.dimen.dimen_app_edit_text_padding), 0);
            cb.setTag(languages.getCode());
            cb.setEnabled(true);
            cb.setTextSize(TypedValue.COMPLEX_UNIT_PX, getResources().getDimension(R.dimen.size_app_text_medium));
            for (Languages languages1 : tempSelectedLangs) {
                if (languages1.getCode().equals(languages.getCode()) && languages1.isVisible()) {
                    cb.setChecked(true);
                    if (languages1.getCode().equals("en")) {
                        cb.setEnabled(false);
                    }
                }
            }

            ll.addView(cb);
            llLangs.addView(ll);
        }
        languageDialog.setOnDismissListener(dialog -> {
            tempSelectedLangs.clear();
            for (int i = 0; i < llLangs.getChildCount(); i++) {
                LinearLayout nextChildLayout = (LinearLayout) llLangs.getChildAt(i);
                View nextChild = nextChildLayout.getChildAt(0);
                if (nextChild instanceof CheckBox) {
                    CheckBox check = (CheckBox) nextChild;
                    for (Languages languages : adminLanguagges) {
                        if (check.getTag().equals(languages.getCode())) {
                            if (check.isChecked()) {
                                languages.setVisible(true);
                                tempSelectedLangs.add(languages);
                            }
                        }
                    }
                }
            }
        });

        WindowManager.LayoutParams params = languageDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        languageDialog.getWindow().setAttributes(params);
        languageDialog.show();
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
                if (storeData != null) {
                    setTaxTags(storeData.getStoreTaxesDetails());
                }
                setToolbarEditIcon(false, R.drawable.ic_edit);
                setToolbarSaveIcon(true);
            }
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            validate();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public ArrayList<Integer> getCancellationStatus(int max) {
        ArrayList<Integer> cancellationStatus = new ArrayList<>();
        cancellationStatus.add(3); //  STORE_ACCEPTED
        cancellationStatus.add(5); //  STORE_PREPARING_ORDER
        cancellationStatus.add(7); //  ORDER_READY
        cancellationStatus.add(17); //  DELIVERY_MAN_PICKED_ORDER
        cancellationStatus.add(21); //  DELIVERY_MAN_ARRIVED_AT_DESTINATION
        if (max == 0) {
            return cancellationStatus;
        } else {
            ArrayList<Integer> cancellationStatusMax = new ArrayList<>();
            for (int status : cancellationStatus) {
                if (status > max) {
                    cancellationStatusMax.add(status);
                }
            }
            return cancellationStatusMax;
        }
    }
}