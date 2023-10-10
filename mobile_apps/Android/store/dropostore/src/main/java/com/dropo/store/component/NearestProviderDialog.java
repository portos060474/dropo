package com.dropo.store.component;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.NearestProviderAdapter;
import com.dropo.store.models.datamodel.ProviderDetail;
import com.dropo.store.models.responsemodel.NearestProviderResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class NearestProviderDialog extends BottomSheetDialog {
    private final NearestProviderAdapter nearestProviderAdapter;
    private CustomButton btnPositive;

    public NearestProviderDialog(@NonNull Context context, String orderId, String vehicleId) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_nearest_provider);
        nearestProviderAdapter = new NearestProviderAdapter();
        RecyclerView rcvProvider = findViewById(R.id.rcvProvider);
        btnPositive = findViewById(R.id.btnPositive);
        rcvProvider.setAdapter(nearestProviderAdapter);
        EditText searchProvider = findViewById(R.id.etSearchProvider);
        searchProvider.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                nearestProviderAdapter.getFilter().filter(s);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });


        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(params);
        getNearestProvider(context, orderId, vehicleId);
    }

    private void getNearestProvider(final Context context, String orderId, String vehicleId) {
        Utilities.showCustomProgressDialog(context, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(context).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(context).getServerToken());
        map.put(Constant.ORDER_ID, orderId);
        map.put(Constant.VEHICLE_ID, vehicleId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<NearestProviderResponse> responseCall = apiInterface.getNearestProviders(map);
        responseCall.enqueue(new Callback<NearestProviderResponse>() {
            @Override
            public void onResponse(@NonNull Call<NearestProviderResponse> call, @NonNull Response<NearestProviderResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        nearestProviderAdapter.setProviderDetails(response.body().getProviders());
                        getBehavior().setState(BottomSheetBehavior.STATE_EXPANDED);
                        if (response.body().getProviders().isEmpty()) {
                            btnPositive.setAlpha(0.5f);
                            btnPositive.setEnabled(false);
                        } else {
                            btnPositive.setAlpha(1f);
                            btnPositive.setEnabled(true);
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<NearestProviderResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(NearestProviderDialog.class.getSimpleName(), t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public ProviderDetail getSelectedProvider() {
        return nearestProviderAdapter.getSelectedProvider();
    }
}