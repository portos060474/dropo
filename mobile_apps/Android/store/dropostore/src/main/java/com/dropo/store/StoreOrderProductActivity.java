package com.dropo.store;

import static com.dropo.store.R.id.rcvStoreProduct;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.ProductFilterAdapter;
import com.dropo.store.adapter.StoreProductAdapter;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.ProductResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PinnedHeaderItemDecoration;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StoreOrderProductActivity extends BaseActivity {

    private final ArrayList<Product> productList = new ArrayList<>();
    private CustomButton btnGotoCart;
    private RecyclerView rcItemList;
    private StoreProductAdapter storeProductAdapter;
    private PinnedHeaderItemDecoration pinnedHeaderItemDecoration;
    private BottomSheetDialog filterItemDialog;
    private LinearLayout llEmpty;
    private String productFilterText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_product);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(StoreOrderProductActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_products));
        llEmpty = findViewById(R.id.ivEmpty);
        rcItemList = findViewById(rcvStoreProduct);
        btnGotoCart = findViewById(R.id.btnGotoCart);
        btnGotoCart.setOnClickListener(this);
        getItemList();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setCartItem();
    }

    private void setCartItem() {
        int cartCount = 0;
        for (CartProducts cartProducts : CurrentBooking.getInstance().getCartProductList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        if (cartCount > 0) {
            btnGotoCart.setVisibility(View.VISIBLE);
        } else {
            btnGotoCart.setVisibility(View.GONE);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(true, R.drawable.filter_store);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == R.id.ivEditMenu) {
            openFilterDialog();
        }
        return true;
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.btnGotoCart) {
            goToCartActivity();
        }
    }

    protected void goToCartActivity() {
        Intent intent = new Intent(this, CartActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method call webservice for get all item in store
     */
    public void getItemList() {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.IS_CHECK_CATEGORY_TIME, true);
        Call<ProductResponse> call = ApiClient.getClient().create(ApiInterface.class).getItemList(map);
        call.enqueue(new Callback<ProductResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProductResponse> call, @NonNull Response<ProductResponse> response) {
                if (response.isSuccessful()) {
                    if (Objects.requireNonNull(response.body()).isSuccess()) {
                        productList.clear();
                        productList.addAll(response.body().getProducts());
                        for (Product product : productList) {
                            Collections.sort(product.getItems());
                        }
                        Collections.sort(productList);

                        initRevStoreProductList();
                    } else {
                        ParseContent.getInstance().showErrorMessage(StoreOrderProductActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                    if (productList.isEmpty()) {
                        llEmpty.setVisibility(View.VISIBLE);
                    } else {
                        llEmpty.setVisibility(View.GONE);
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), StoreOrderProductActivity.this);
                }
                Utilities.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<ProductResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRevStoreProductList() {
        if (storeProductAdapter != null) {
            storeProductAdapter.notifyDataSetChanged();
        } else {
            storeProductAdapter = new StoreProductAdapter(this, productList, products -> {
                if (products.isEmpty()) {
                    llEmpty.setVisibility(View.VISIBLE);
                } else {
                    llEmpty.setVisibility(View.GONE);
                }
            });
            rcItemList.setAdapter(storeProductAdapter);
            rcItemList.setLayoutManager(new LinearLayoutManager(this));
            pinnedHeaderItemDecoration = new PinnedHeaderItemDecoration();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void goToSpecificationActivity(Product product, Item productItemsItem) {
        Intent intent;
        if (getIntent().getExtras() != null) {
            if (getIntent().getExtras().getBoolean(Constant.IS_ORDER_UPDATE)) {
                intent = new Intent(this, UpdateOrderProductSpecificationActivity.class);
                intent.putExtra(Constant.UPDATE_ITEM_INDEX, -1);
                intent.putExtra(Constant.UPDATE_ITEM_INDEX_SECTION, -1);
            } else {
                intent = new Intent(this, StoreOrderProductSpecificationActivity.class);
            }
            intent.putExtra(Constant.PRODUCT_DETAIL, product);
            intent.putExtra(Constant.PRODUCT_SPECIFICATION, productItemsItem);
            startActivity(intent);
            overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        }
    }

    public void openFilterDialog() {
        if (filterItemDialog != null && filterItemDialog.isShowing()) {
            return;
        }
        filterItemDialog = new BottomSheetDialog(this);
        filterItemDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        filterItemDialog.setContentView(R.layout.dialog_item_filter);
        ImageView ivClearText = filterItemDialog.findViewById(R.id.ivClearDeliveryAddressTextMap);
        ivClearText.setVisibility(View.GONE);

        EditText etStoreSearch = filterItemDialog.findViewById(R.id.etStoreSearch);
        etStoreSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() > 0) {
                    ivClearText.setVisibility(View.VISIBLE);
                } else {
                    ivClearText.setVisibility(View.GONE);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        if (!TextUtils.isEmpty(productFilterText)) {
            etStoreSearch.setText(productFilterText);
        }
        ivClearText.setOnClickListener(view -> etStoreSearch.getText().clear());
        ProductFilterAdapter productFilterAdapter = new ProductFilterAdapter(productList);
        RecyclerView rcvFilterList = filterItemDialog.findViewById(R.id.rcvFilterList);
        rcvFilterList.setLayoutManager(new LinearLayoutManager(this));
        rcvFilterList.setAdapter(productFilterAdapter);
        filterItemDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> filterItemDialog.dismiss());
        filterItemDialog.findViewById(R.id.btnApplyProductFilter).setOnClickListener(view -> {
            if (!productList.isEmpty()) {
                pinnedHeaderItemDecoration.disableCache();
                productFilterText = etStoreSearch.getText().toString().trim();
                storeProductAdapter.getFilter().filter(etStoreSearch.getText().toString().trim());
            }
            filterItemDialog.dismiss();
        });

        WindowManager.LayoutParams params = filterItemDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        filterItemDialog.show();
    }
}