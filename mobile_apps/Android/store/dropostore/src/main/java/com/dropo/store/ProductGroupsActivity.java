package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.ProductGroupListAdapter;
import com.dropo.store.models.datamodel.ProductGroup;
import com.dropo.store.models.responsemodel.ProductGroupsResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductGroupsActivity extends BaseActivity {

    private final ArrayList<ProductGroup> productGroups = new ArrayList<>();
    private RecyclerView rcvGroups;
    private ProductGroupListAdapter productGroupListAdapter;
    private FloatingActionButton floatingBtn;
    private boolean isSave;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_list);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_group_of_category));
        rcvGroups = findViewById(R.id.rcvGroups);
        floatingBtn = findViewById(R.id.floatingBtn);
        floatingBtn.setOnClickListener(this);
        initRcvGroups();
    }

    @Override
    protected void onResume() {
        super.onResume();
        getProductGroupList();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(true, R.drawable.ic_cancel);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ivEditMenu) {
            if (productGroupListAdapter != null) {
                productGroupListAdapter.setIsDelete(!isSave);
                isSave = true;
                setToolbarEditIcon(false, R.drawable.ic_cancel);
                floatingBtn.hide();
                setToolbarSaveIcon(true);
            }
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            if (productGroupListAdapter != null) {
                productGroupListAdapter.setIsDelete(!isSave);
                isSave = false;
                setToolbarEditIcon(true, R.drawable.ic_cancel);
                setToolbarSaveIcon(false);
                floatingBtn.show();
            }
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * this method call webservice for all product groups
     */
    private void getProductGroupList() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProductGroupsResponse> responseCall = apiInterface.getProductGroupList(map);
        responseCall.enqueue(new Callback<ProductGroupsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ProductGroupsResponse> call, @NonNull Response<ProductGroupsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.isSuccessful()) {
                    productGroups.clear();
                    if (response.body().isSuccess()) {
                        productGroups.addAll(response.body().getProductGroups());
                    } else {
                        parseContent.showErrorMessage(ProductGroupsActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), ProductGroupsActivity.this);
                }
                if (productGroupListAdapter != null) {
                    productGroupListAdapter.notifyDataSetChanged();
                }
                setToolbarEditIcon(!productGroups.isEmpty(), R.drawable.ic_cancel);
            }

            @Override
            public void onFailure(@NonNull Call<ProductGroupsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for delete product group
     */
    private void deleteProductGroup(String productGroupId, final int position) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.PRODUCT_GROUP_ID, productGroupId);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProductGroupsResponse> responseCall = apiInterface.deleteProductGroup(map);
        responseCall.enqueue(new Callback<ProductGroupsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ProductGroupsResponse> call, @NonNull Response<ProductGroupsResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    productGroups.remove(position);
                } else {
                    Utilities.showHttpErrorToast(response.code(), ProductGroupsActivity
                            .this);
                }
                if (productGroupListAdapter != null) {
                    productGroupListAdapter.notifyDataSetChanged();
                }
                if (productGroups.isEmpty()) setToolbarEditIcon(false, 0);
            }

            @Override
            public void onFailure(@NonNull Call<ProductGroupsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvGroups() {
        productGroupListAdapter = new ProductGroupListAdapter(productGroups, false) {
            @Override
            public void onSelect(int position) {
                gotoAddItemActivity(productGroups.get(position));
            }

            @Override
            public void onDelete(String productGroupId, int position) {
                deleteProductGroup(productGroupId, position);
            }
        };
        rcvGroups.setLayoutManager(new LinearLayoutManager(this));
        rcvGroups.setAdapter(productGroupListAdapter);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.floatingBtn) {
            goToAddGroupActivity();
        }
    }

    private void goToAddGroupActivity() {
        Intent intent = new Intent(this, AddGroupActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    public void gotoAddItemActivity(ProductGroup productGroup) {
        Intent intent = new Intent(this, AddGroupActivity.class);
        intent.putExtra(Constant.PRODUCT_GROUP, productGroup);
        startActivity(intent);
    }
}