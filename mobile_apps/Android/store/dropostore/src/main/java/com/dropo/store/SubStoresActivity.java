package com.dropo.store;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.SubStoresAdapter;
import com.dropo.store.models.datamodel.SubStore;
import com.dropo.store.models.responsemodel.SubStoresResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SubStoresActivity extends BaseActivity {

    private FloatingActionButton floatingBtn;
    private SubStoresAdapter subStoresAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sub_stores);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_sub_store));
        floatingBtn = findViewById(R.id.floatingBtn);
        floatingBtn.setOnClickListener(this);
        RecyclerView rcvSubStore = findViewById(R.id.rcvSubStore);
        subStoresAdapter = new SubStoresAdapter() {
            @Override
            public void onStoreSelect(SubStore subStore) {
                goToSubStoreActivity(subStore);
            }
        };
        rcvSubStore.setAdapter(subStoresAdapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        getSubStores();
    }

    private void getSubStores() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SubStoresResponse> responseCall = apiInterface.getSubStores(map);
        responseCall.enqueue(new Callback<SubStoresResponse>() {
            @Override
            public void onResponse(@NonNull Call<SubStoresResponse> call, @NonNull Response<SubStoresResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        subStoresAdapter.setSubStoreList(response.body().getSubStoreList());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<SubStoresResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(SubStoresActivity.class.getName(), t);
            }
        });
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.floatingBtn) {
            goToSubStoreActivity(null);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, R.drawable.ic_history_time);
        setToolbarSaveIcon(false);
        return true;
    }

    private void goToSubStoreActivity(SubStore subStore) {
        Intent intent = new Intent(this, AddSubStoreActivity.class);
        if (subStore != null) {
            intent.putExtra(Constant.SUB_STORE, subStore);
        }
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}