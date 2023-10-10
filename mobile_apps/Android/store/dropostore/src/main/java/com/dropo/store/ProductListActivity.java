package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.dropo.store.adapter.ProductListAdapter;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.ProductResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;

import java.util.ArrayList;
import java.util.HashMap;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductListActivity extends BaseActivity {

    private SwipeRefreshLayout swipeRefreshLayout;
    private ProductListAdapter productListAdapter;
    private ArrayList<Product> productList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_list);

        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_products));

        RecyclerView rcProductList = findViewById(R.id.recyclerView);
        rcProductList.setNestedScrollingEnabled(false);
        rcProductList.setLayoutManager(new LinearLayoutManager(this));
        swipeRefreshLayout = findViewById(R.id.swipeRefreshLayout);
        productList = new ArrayList<>();
        productListAdapter = new ProductListAdapter(this, productList);
        rcProductList.setAdapter(productListAdapter);
        swipeRefreshLayout.setRefreshing(true);
        swipeLayoutSetup();

        findViewById(R.id.floatingBtn).setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.floatingBtn) {
            Intent intent = new Intent(this, AddProductActivity.class);
            startActivity(intent);
            overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        getProductList();
    }

    private void swipeLayoutSetup() {
        setColorSwipeToRefresh(swipeRefreshLayout);
        swipeRefreshLayout.setOnRefreshListener(() -> {
            swipeRefreshLayout.setRefreshing(true);
            getProductList();
        });
    }

    public void getProductList() {
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(preferenceHelper.getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getServerToken()));
        Call<ProductResponse> productsCall = ApiClient.getClient().create(ApiInterface.class).getProductList(map);

        productsCall.enqueue(new Callback<ProductResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ProductResponse> call, @NonNull Response<ProductResponse> response) {
                swipeRefreshLayout.setRefreshing(false);
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        productList.clear();
                        productList.addAll(response.body().getProducts());
                        productListAdapter.notifyDataSetChanged();
                    } else {
                        ParseContent.getInstance().showErrorMessage(ProductListActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), ProductListActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProductResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void gotoProductDetail(Intent intent, int position) {
        intent.putExtra(Constant.PRODUCT_ITEM, productList.get(position));
        startActivity(intent);
    }
}