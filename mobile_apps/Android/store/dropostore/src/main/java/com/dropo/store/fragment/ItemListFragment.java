package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.ActivityOptionsCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.AddItemActivity;
import com.dropo.store.AddProductActivity;
import com.dropo.store.adapter.ProductAdapter;
import com.dropo.store.adapter.ProductFilterAdapter;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.responsemodel.ProductResponse;
import com.dropo.store.models.singleton.CurrentProduct;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PinnedHeaderItemDecoration;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ItemListFragment extends BaseFragment {

    private final String TAG = this.getClass().getSimpleName();

    private final ArrayList<Product> productList = new ArrayList<>();
    private final ArrayList<TaxesDetail> taxesList = new ArrayList<>();
    private ProductAdapter productItemAdapter;
    private RecyclerView rcItemList;
    private String productFilterText;

    private FloatingActionButton fbAdd;
    private CustomTextView btnAddProduct, btnAddItem;
    private LinearLayout llFab;
    private PinnedHeaderItemDecoration pinnedHeaderItemDecoration;
    private Animation fabOpen, fabClose, rotateForward, rotateBackward;
    private boolean isFabOpen;
    private BottomSheetDialog filterItemDialog;
    private LinearLayout ivEmpty;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_list_item, container, false);
        swipeLayoutSetup();
        rcItemList = view.findViewById(R.id.recyclerView);
        fbAdd = view.findViewById(R.id.fbAdd);
        btnAddProduct = view.findViewById(R.id.btnAddProduct);
        btnAddItem = view.findViewById(R.id.btnAddItem);
        llFab = view.findViewById(R.id.llFab);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        activity.toolbar.setElevation(getResources().getDimensionPixelSize(R.dimen.dimen_app_toolbar_elevation));
        rcItemList.setLayoutManager(new LinearLayoutManager(activity));
        productItemAdapter = new ProductAdapter(activity, productList);
        rcItemList.setAdapter(productItemAdapter);
        pinnedHeaderItemDecoration = new PinnedHeaderItemDecoration();
        fabOpen = AnimationUtils.loadAnimation(activity, R.anim.fab_open);
        fabClose = AnimationUtils.loadAnimation(activity, R.anim.fab_closed);
        rotateForward = AnimationUtils.loadAnimation(activity, R.anim.rotate_forward);
        rotateBackward = AnimationUtils.loadAnimation(activity, R.anim.rotate_backward);
        fbAdd.setOnClickListener(this);
        btnAddItem.setOnClickListener(this);
        btnAddProduct.setOnClickListener(this);
        btnAddProduct.setVisibility(View.GONE);
        btnAddItem.setVisibility(View.GONE);
        fbAdd.setVisibility(PreferenceHelper.getPreferenceHelper(activity).getIsStoreEditItem() ? View.VISIBLE : View.GONE);
    }

    @Override
    public void onResume() {
        super.onResume();
        activity.mainSwipeLayout.setRefreshing(true);
        getItemList();
    }

    private void swipeLayoutSetup() {
        activity.mainSwipeLayout.setEnabled(true);
        activity.mainSwipeLayout.setOnRefreshListener(this::getItemList);
    }

    /**
     * this method call webservice for get all item in store
     */
    public void getItemList() {
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(activity).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(activity).getServerToken());

        Call<ProductResponse> call = ApiClient.getClient().create(ApiInterface.class).getItemList(map);

        call.enqueue(new Callback<ProductResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ProductResponse> call, @NonNull Response<ProductResponse> response) {
                activity.mainSwipeLayout.setRefreshing(false);
                if (isAdded()) {
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            productList.clear();
                            productList.addAll(response.body().getProducts());
                            taxesList.clear();
                            taxesList.addAll(response.body().getTaxDetails());
                            for (Product product : productList) {
                                Collections.sort(product.getItems());
                            }
                            Collections.sort(productList);
                            pinnedHeaderItemDecoration.disableCache();
                            productItemAdapter.setProductList(productList);
                            productItemAdapter.notifyDataSetChanged();
                            CurrentProduct.getInstance().setProductDataList(productList);
                        } else {
                            activity.setToolbarEditIcon(false, R.drawable.filter_store);
                        }
                        if (productList.isEmpty()) {
                            activity.setToolbarEditIcon(false, R.drawable.filter_store);
                            ivEmpty.setVisibility(View.VISIBLE);
                            rcItemList.setVisibility(View.GONE);
                        } else {
                            activity.setToolbarEditIcon(true, R.drawable.filter_store);
                            ivEmpty.setVisibility(View.GONE);
                            rcItemList.setVisibility(View.VISIBLE);
                        }
                    } else {
                        Utilities.showHttpErrorToast(response.code(), activity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProductResponse> call, @NonNull Throwable t) {
                activity.mainSwipeLayout.setRefreshing(false);
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void gotoAddItemActivity(Intent intent, Item item, String productName, String productId, View ivItem, boolean isShowTransition, String productImage) {
        intent.putExtra(Constant.ITEM, item);
        intent.putExtra(Constant.NAME, productName);
        intent.putExtra(Constant.PRODUCT_ID, productId);
        intent.putExtra(Constant.IMAGE_URL, productImage);
        intent.putExtra(Constant.TAXES, taxesList);

        if (isShowTransition) {
            ActivityOptionsCompat optionsCompat = ActivityOptionsCompat.makeSceneTransitionAnimation(activity, ivItem, ivItem.getTransitionName());
            ActivityCompat.startActivity(activity, intent, optionsCompat.toBundle());
        } else {
            startActivity(intent);
        }
    }

    public void gotoEditProductActivity(Product product) {
        Intent intent = new Intent(activity, AddProductActivity.class);
        intent.putExtra(Constant.PRODUCT_ITEM, product);
        startActivity(intent);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.fbAdd) {
            animateFAB();
        } else if (id == R.id.btnAddProduct) {
            animateFAB();
            goToAddProductActivity();
        } else if (id == R.id.btnAddItem) {
            animateFAB();
            goToAddItemActivity();
        }
    }

    public void openFilterDialog() {
        if (filterItemDialog != null && filterItemDialog.isShowing()) {
            return;
        }
        filterItemDialog = new BottomSheetDialog(activity);
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
        rcvFilterList.setLayoutManager(new LinearLayoutManager(activity));
        rcvFilterList.setAdapter(productFilterAdapter);
        filterItemDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> filterItemDialog.dismiss());
        filterItemDialog.findViewById(R.id.btnApplyProductFilter).setOnClickListener(view -> {
            if (!productList.isEmpty()) {
                pinnedHeaderItemDecoration.disableCache();
                productFilterText = etStoreSearch.getText().toString().trim();
                productItemAdapter.getFilter().filter(etStoreSearch.getText().toString().trim());
            }
            new Handler(Looper.myLooper()).postDelayed(() -> {
                if (productItemAdapter.getItemCount() > 0) {
                    ivEmpty.setVisibility(View.GONE);
                    rcItemList.setVisibility(View.VISIBLE);
                } else {
                    ivEmpty.setVisibility(View.VISIBLE);
                    rcItemList.setVisibility(View.GONE);
                }
            }, 200);
            filterItemDialog.dismiss();
        });

        WindowManager.LayoutParams params = filterItemDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        filterItemDialog.show();
        activity.floatingBtn.setOnClickListener(null);
        filterItemDialog.setOnDismissListener(dialogInterface -> activity.floatingBtn.setOnClickListener(activity));
    }

    private void goToAddItemActivity() {
        Intent intent = new Intent(activity, AddItemActivity.class);
        intent.putExtra(Constant.TAXES, taxesList);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.enter, R.anim.exit);
    }

    private void goToAddProductActivity() {
        Intent intent = new Intent(activity, AddProductActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    public void animateFAB() {
        if (btnAddProduct.getVisibility() == View.GONE) {
            btnAddItem.setVisibility(View.VISIBLE);
            btnAddProduct.setVisibility(View.VISIBLE);
        }
        if (isFabOpen) {
            llFab.setBackground(null);
            llFab.setClickable(false);
            fbAdd.startAnimation(rotateBackward);
            btnAddItem.startAnimation(fabClose);
            btnAddProduct.startAnimation(fabClose);
            btnAddItem.setClickable(false);
            btnAddProduct.setClickable(false);
            isFabOpen = false;
        } else {
            llFab.setBackgroundColor(ResourcesCompat.getColor(activity.getResources(), R.color.color_app_transparent_white, null));
            llFab.setClickable(false);
            fbAdd.startAnimation(rotateForward);
            btnAddItem.startAnimation(fabOpen);
            btnAddProduct.startAnimation(fabOpen);
            btnAddItem.setClickable(true);
            btnAddProduct.setClickable(true);
            isFabOpen = true;
        }
    }
}