package com.dropo.provider;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.adapter.VehicleDetailAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.fragments.AddVehicleFragment;
import com.dropo.provider.models.datamodels.Vehicle;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.VehicleDetailResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class VehicleDetailActivity extends BaseAppCompatActivity {
    public static final String TAG = VehicleDetailActivity.class.getName();

    private RecyclerView rcvVehicleDetail;
    private VehicleDetailAdapter vehicleDetailAdapter;
    private ArrayList<Vehicle> vehicleDetail;
    private FloatingActionButton floatingBtnAddVehicleDetail;
    private boolean isApplicationStart;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_vehicle_detail);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_vehicle));
        initViewById();
        setViewListener();
        getExtraData();
        vehicleDetail = new ArrayList<>();
        initRcvVehicle();
        getVehicleDetail();
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            isApplicationStart = getIntent().getExtras().getBoolean(Const.APP_START);
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvVehicleDetail = findViewById(R.id.rcvVehicleDetail);
        floatingBtnAddVehicleDetail = findViewById(R.id.floatingBtnAddVehicleDetail);
    }

    @Override
    protected void setViewListener() {
        floatingBtnAddVehicleDetail.setOnClickListener(this);
        if (preferenceHelper.getProviderType() == Const.ProviderType.STORE) {
            floatingBtnAddVehicleDetail.setVisibility(View.GONE);
        }
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onBackPressed() {
        if (isApplicationStart && vehicleDetail.isEmpty()) {
            openLogoutDialog();
        } else {
            super.onBackPressed();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.floatingBtnAddVehicleDetail) {
            goToAddVehicleDetailFragment(null);
        }
    }

    /**
     * this method  call webservice for get bank detail
     */
    public void getVehicleDetail() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<VehicleDetailResponse> responseCall = apiInterface.getVehicleDetail(map);
        responseCall.enqueue(new Callback<VehicleDetailResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<VehicleDetailResponse> call, @NonNull Response<VehicleDetailResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        vehicleDetail.clear();
                        vehicleDetail.addAll(response.body().getVehicleList());
                        vehicleDetailAdapter.notifyDataSetChanged();
                        if (isApplicationStart && preferenceHelper.getIsProviderAllVehicleDocumentsUpload()) {
                            goToHomeActivity();
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), VehicleDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<VehicleDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method  call webservice for get bank detail
     */
    public void selectVehicle(final int position) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.VEHICLE_ID, vehicleDetail.get(position).getId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.selectVehicle(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        for (Vehicle vehicle : vehicleDetail) {
                            vehicle.setSelected(false);
                        }
                        vehicleDetail.get(position).setSelected(true);
                        preferenceHelper.putSelectedVehicleId(vehicleDetail.get(position).getId());
                        vehicleDetailAdapter.notifyDataSetChanged();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), VehicleDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvVehicle() {
        rcvVehicleDetail.setLayoutManager(new LinearLayoutManager(this));
        vehicleDetailAdapter = new VehicleDetailAdapter(this, vehicleDetail);
        rcvVehicleDetail.setAdapter(vehicleDetailAdapter);
    }

    public void goToAddVehicleDetailFragment(Vehicle vehicle) {
        AddVehicleFragment addVehicleFragment = new AddVehicleFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable(Const.BUNDLE, vehicle);
        addVehicleFragment.setArguments(bundle);
        addVehicleFragment.show(getSupportFragmentManager(), addVehicleFragment.getTag());
    }

    private void openLogoutDialog() {
        CustomDialogAlert customDialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_log_out), getResources().getString(R.string.msg_are_you_sure), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                logOut(false);
                dismiss();
            }
        };
        customDialogAlert.show();
    }
}