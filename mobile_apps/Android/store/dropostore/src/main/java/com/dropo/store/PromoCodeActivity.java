package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.PromoCodeAdapter;
import com.dropo.store.models.datamodel.PromoCodes;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.PromoCodeResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PromoCodeActivity extends BaseActivity {

    private RecyclerView rcvPromoCode;
    private PromoCodeAdapter promoCodeAdapter;
    private ArrayList<PromoCodes> promoCodes;
    private FloatingActionButton floatingBtnAddPromo;
    private View ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_promo_code);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_promo));
        promoCodes = new ArrayList<>();
        rcvPromoCode = findViewById(R.id.rcvPromoCode);
        floatingBtnAddPromo = findViewById(R.id.floatingBtnAddPromo);
        ivEmpty = findViewById(R.id.ivEmpty);
        floatingBtnAddPromo.setOnClickListener(this);
        initRcvPromo();
        getPromoCodeDetail();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    private void initRcvPromo() {
        rcvPromoCode.setLayoutManager(new LinearLayoutManager(this));
        promoCodeAdapter = new PromoCodeAdapter(this, promoCodes);
        rcvPromoCode.setAdapter(promoCodeAdapter);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.floatingBtnAddPromo) {
            goToAddPromoActivity(null);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == Constant.REQUEST_PROMO_CODE) {
                getPromoCodeDetail();
            }
        }
    }

    private void getPromoCodeDetail() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<PromoCodeResponse> responseCall = apiInterface.getPromoCodes(map);
        responseCall.enqueue(new Callback<PromoCodeResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<PromoCodeResponse> call, @NonNull Response<PromoCodeResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        promoCodes.clear();
                        promoCodes.addAll(response.body().getPromoCodes());
                        promoCodeAdapter.notifyDataSetChanged();
                    }
                }
                ivEmpty.setVisibility(promoCodes.isEmpty() ? View.VISIBLE : View.GONE);
            }

            @Override
            public void onFailure(@NonNull Call<PromoCodeResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(PromoCodeActivity.class.getName(), t);
                Utilities.hideCustomProgressDialog();
                ivEmpty.setVisibility(promoCodes.isEmpty() ? View.VISIBLE : View.GONE);
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void goToAddPromoActivity(PromoCodes promoCodes) {
        Intent intent = new Intent(this, AddPromoCodeActivity.class);
        intent.putExtra(Constant.PROMO_DETAIL, promoCodes);
        startActivityForResult(intent, Constant.REQUEST_PROMO_CODE);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void updatePromoCode(final PromoCodes promoCodes) {
        Utilities.showCustomProgressDialog(this, false);
        PromoCodes promoCodes2 = new PromoCodes();
        promoCodes2.setIsPromoForDeliveryService(false);
        promoCodes2.setServerToken(preferenceHelper.getServerToken());
        promoCodes2.setStoreId(preferenceHelper.getStoreId());
        promoCodes2.setPromoStartDate(promoCodes.getPromoStartDate());
        promoCodes2.setPromoCodeName(null);
        promoCodes2.setPromoDetails(promoCodes.getPromoDetails());
        promoCodes2.setPromoCodeType(promoCodes.getPromoCodeType());
        promoCodes2.setPromoCodeValue(promoCodes.getPromoCodeValue());
        promoCodes2.setIsActive(promoCodes.isIsActive());
        promoCodes2.setIsPromoHaveMinimumAmountLimit(promoCodes.isIsPromoHaveMinimumAmountLimit());
        promoCodes2.setIsPromoRequiredUses(promoCodes.isIsPromoRequiredUses());
        promoCodes2.setIsPromoHaveMaxDiscountLimit(promoCodes.isIsPromoHaveMaxDiscountLimit());
        promoCodes2.setPromoExpireDate(promoCodes.getPromoExpireDate());
        promoCodes2.setPromoCodeApplyOnMinimumAmount(promoCodes.getPromoCodeApplyOnMinimumAmount());
        promoCodes2.setPromoCodeUses(promoCodes.getPromoCodeUses());
        promoCodes2.setPromoCodeMaxDiscountAmount(promoCodes.getPromoCodeMaxDiscountAmount());
        promoCodes2.setPromoId(promoCodes.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);

        HashMap<String, String> hashMap = new Gson().fromJson(ApiClient.JSONResponse(promoCodes2), HashMap.class);
        Call<IsSuccessResponse> responseCall;
        responseCall = apiInterface.updatePromoCodes(hashMap, null);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        promoCodeAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(PromoCodeActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        promoCodes.setIsActive(!promoCodes.isIsActive());
                        promoCodeAdapter.notifyDataSetChanged();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(PromoCodes.class.getName(), t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}