package com.dropo;

import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.transition.Transition;
import android.transition.TransitionInflater;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.app.ActivityCompat;
import androidx.core.app.ActivityOptionsCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.util.Pair;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.ProductGroupAdapter;
import com.dropo.adapter.StoreProductAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.component.DialogChooseAndRepeat;
import com.dropo.component.DialogProductFilter;
import com.dropo.component.DialogTableBooking;
import com.dropo.fragments.OverviewFragment;
import com.dropo.fragments.ReviewFragment;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.Product;
import com.dropo.models.datamodels.ProductDetail;
import com.dropo.models.datamodels.ProductGroup;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.RemoveFavourite;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.StoreClosedResult;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.ProductGroupsResponse;
import com.dropo.models.responsemodels.SetFavouriteResponse;
import com.dropo.models.responsemodels.StoreProductResponse;
import com.dropo.models.responsemodels.TableDetailResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.models.singleton.OrderEdit;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.PinnedHeaderItemDecoration;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;
import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.appbar.CollapsingToolbarLayout;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class StoreProductActivity extends BaseAppCompatActivity {

    public Store store;
    private CollapsingToolbarLayout collapsingToolbarLayout;
    private RecyclerView rcvStoreProduct, rcvProductGroup;
    private StoreProductAdapter storeProductAdapter;

    private ProductGroupAdapter productGroupAdapter;
    private ArrayList<Product> storeProductList;
    private ArrayList<ProductGroup> storeProductGroupList;
    private CustomFontTextViewTitle tvSelectedStoreName;
    private CustomFontTextView tvSelectedStoreRatings, tvSelectedStoreApproxTime, tvSelectedStorePricing, tvStoreTags;
    private ImageView ivStoreImage;
    private String storeId, filter, tableId;
    private CustomFontTextView tvStoreReOpenTime;
    private FrameLayout flStoreClosed;
    private LinearLayout llProductGroupDetail;
    private ToggleButton ivFavourites;
    private FrameLayout flFavourite;
    private LinearLayout btnGotoCart;
    private CustomFontTextView tvTag, tvTax;
    private PinnedHeaderItemDecoration pinnedHeaderItemDecoration;
    private int storeIndex;
    private boolean isStoreCanCreateGroup;
    private boolean isOrderChange;
    private TextView tvCartCount;
    private DialogProductFilter dialogProductFilter;
    private CustomFontTextView btnBookTable;
    private CustomDialogAlert qrCodeOrderAlertDialog;
    public int itemQuantity = 0;
    private double itemPriceAndSpecificationPriceTotal = 0;
    private ProductItem productItem;
    int cartCount = 0;
    private ProductDetail productDetail;
    private DialogChooseAndRepeat dialogChooseAndRepeat;
    private CustomDialogAlert multipleItemAddedDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupWindowAnimations();
        setContentView(R.layout.activity_store_product);
        loadExtraData();
        initToolBar();
        tvTitleToolbar.setTextAlignment(View.TEXT_ALIGNMENT_VIEW_START);
        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
        toolbar.setBackground(AppCompatResources.getDrawable(this, R.drawable.toolbar_transparent_2));
        ivToolbarRightIcon3.setOnClickListener(this);
        ivToolbarRightIcon3.setImageDrawable(Utils.getLayerDrawableRoundIconFill(this, R.drawable.ic_filter_small));
        ivToolbarRightIcon2.setImageDrawable(Utils.getLayerDrawableRoundIconFill(this, R.drawable.ic_info));
        ivToolbarRightIcon2.setOnClickListener(this);
        ivToolbarBack.setImageDrawable(AppColor.getDarkModeDrawable(R.drawable.ic_left_arrow, StoreProductActivity.this));
        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
        initViewById();
        setViewListener();
        storeProductList = new ArrayList<>();
        storeProductGroupList = new ArrayList<>();
        initAppBar();
        initCollapsingToolbar();
        initRevStoreProductList();
        if (store != null) {
            storeId = store.getId();
            loadStoreProductData(store);
        }

        if (isStoreCanCreateGroup) {
            getProductGroupList(storeId);
        } else {
            llProductGroupDetail.setVisibility(View.GONE);
            getStoreProductList(storeId, null);
        }
        updateUiEditOrder();
    }

    @Override
    protected void onResume() {
        super.onResume();
        currentBooking.setApplication(true);
        if (!storeProductList.isEmpty()) {
            updateStoreItemListAsCart();
        }
        setCartItem();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        collapsingToolbarLayout = findViewById(R.id.productCollapsingToolBar);
        rcvProductGroup = findViewById(R.id.rcvProductGroup2);
        rcvStoreProduct = findViewById(R.id.rcvStoreProduct);
        tvSelectedStorePricing = findViewById(R.id.tvStorePricing);
        tvSelectedStoreName = findViewById(R.id.tvStoreName);
        tvSelectedStoreRatings = findViewById(R.id.tvStoreRatings);
        tvSelectedStoreApproxTime = findViewById(R.id.tvStoreApproxTime);
        ivStoreImage = findViewById(R.id.ivStoreImage);
        flStoreClosed = findViewById(R.id.flStoreClosed);
        tvStoreReOpenTime = findViewById(R.id.tvStoreReOpenTime);
        llProductGroupDetail = findViewById(R.id.llCategoryDetail);
        ivFavourites = findViewById(R.id.ivFavourites);
        flFavourite = findViewById(R.id.flFavourite);
        btnGotoCart = findViewById(R.id.btnGotoCart);
        if (TextUtils.isEmpty(preferenceHelper.getUserId())) {
            ivFavourites.setVisibility(View.GONE);
            flFavourite.setVisibility(View.GONE);
        } else {
            ivFavourites.setVisibility(View.VISIBLE);
            flFavourite.setVisibility(View.VISIBLE);
        }
        tvTag = findViewById(R.id.tvTag);
        tvTax = findViewById(R.id.tvTax);
        tvStoreTags = findViewById(R.id.tvStoreTags);
        tvCartCount = findViewById(R.id.tvCartCount);
        btnBookTable = findViewById(R.id.btnBookTable);
        updateTableBookingUI(store);
    }

    private void updateTableBookingUI(Store store) {
        if (store != null) {
            if (store.isProvideTableBooking() && (store.isTableReservation() || store.isTableReservationWithOrder())) {
                btnBookTable.setVisibility(View.VISIBLE);
                if (currentBooking.isTableBooking()) {
                    btnBookTable.setText(getString(R.string.btn_edit_table));
                } else {
                    btnBookTable.setText(getString(R.string.store_filter_book_a_table));
                }
                btnBookTable.setOnClickListener(this);
            } else {
                btnBookTable.setVisibility(View.GONE);
            }
        }

        if (storeId != null && tableId != null && !TextUtils.isEmpty(storeId) && !TextUtils.isEmpty(tableId)) {
            btnBookTable.setVisibility(View.GONE);
        }
    }

    @Override
    protected void setViewListener() {
        ivFavourites.setOnClickListener(this);
        btnGotoCart.setOnClickListener(this);
        tvSelectedStoreRatings.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.ivToolbarRightIcon3) {
            openProductFilter();
        } else if (id == R.id.ivToolbarRightIcon2) {
            OverviewFragment overviewFragment = new OverviewFragment();
            overviewFragment.show(getSupportFragmentManager(), overviewFragment.getTag());
        } else if (id == R.id.tvStoreRatings) {
            ReviewFragment reviewFragment = new ReviewFragment();
            reviewFragment.show(getSupportFragmentManager(), reviewFragment.getTag());
        } else if (id == R.id.ivFavourites) {
            if (store != null) {
                if (store.isFavourite()) {
                    removeAsFavoriteStore(store.getId());
                } else {
                    setFavoriteStore(store.getId());
                }
            }
        } else if (id == R.id.btnGotoCart) {
            if (isOrderChange) {
                onBackNavigation();
            } else {
                goToCartActivity();
            }
        } else if (id == R.id.btnBookTable) {
            if (!currentBooking.isTableBooking() && !currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
                openClearCartDialog(false);
            } else {
                openTableBooking(store);
            }
        }
    }

    private void initCollapsingToolbar() {
        collapsingToolbarLayout.setTitleEnabled(false);
        collapsingToolbarLayout.setContentScrimColor(AppColor.getThemeTextColor(this));
        collapsingToolbarLayout.setStatusBarScrimColor(AppColor.getThemeTextColor(this));
    }

    private void initAppBar() {
        final Handler handler = new Handler(Looper.myLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                switch (msg.what) {
                    case 1:
                        tvTitleToolbar.setTextColor(AppColor.getThemeTextColor(StoreProductActivity.this));
                        toolbar.setBackgroundColor(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(StoreProductActivity.this) ? R.color.color_app_bg_dark : R.color.color_app_bg_light, null));
                        ivToolbarBack.setImageDrawable(AppColor.getThemeModeDrawable(R.drawable.ic_left_arrow, StoreProductActivity.this));
                        break;
                    case 2:
                        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
                        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
                        toolbar.setBackground(AppCompatResources.getDrawable(StoreProductActivity.this, R.drawable.toolbar_transparent_2));
                        ivToolbarBack.setImageDrawable(AppColor.getDarkModeDrawable(R.drawable.ic_left_arrow, StoreProductActivity.this));
                        break;
                    default:
                        break;
                }
            }
        };

        AppBarLayout appBarLayout = findViewById(R.id.productAppBarLayout);
        appBarLayout.addOnOffsetChangedListener(new AppBarLayout.OnOffsetChangedListener() {
            boolean isShow = false;
            int scrollRange = -1;

            @Override
            public void onOffsetChanged(AppBarLayout appBarLayout, int verticalOffset) {
                if (scrollRange == -1) {
                    scrollRange = appBarLayout.getTotalScrollRange();
                }
                if (scrollRange + verticalOffset == 0) {
                    handler.sendEmptyMessage(1);
                    isShow = true;
                } else if (isShow) {
                    handler.sendEmptyMessage(2);
                    isShow = false;
                }
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRevStoreProductList() {
        if (storeProductAdapter != null) {
            pinnedHeaderItemDecoration.disableCache();
            storeProductAdapter.setProductList(storeProductList);
            storeProductAdapter.notifyDataSetChanged();
        } else {
            storeProductAdapter = new StoreProductAdapter(this, storeProductList, !isOrderChange);
            rcvStoreProduct.setAdapter(storeProductAdapter);
            rcvStoreProduct.setLayoutManager(new LinearLayoutManager(this));
            pinnedHeaderItemDecoration = new PinnedHeaderItemDecoration();
            if (!TextUtils.isEmpty(filter)) {
                pinnedHeaderItemDecoration.disableCache();
                storeProductAdapter.getFilter().filter(filter.trim());
            }
        }
    }

    /**
     * this method call a webservice for get particular store product list according to store
     *
     * @param storeId store in string
     */
    private void getStoreProductList(String storeId, List<String> productIds) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        if (productIds != null) {
            map.put(Const.Params.PRODUCT_IDS, productIds);
        }
        map.put(Const.Params.STORE_ID, storeId);
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        ApiInterface apiInterface = new ApiClient().changeHeaderLang(storeIndex).create(ApiInterface.class);
        Call<StoreProductResponse> responseCall = apiInterface.getStoreProductList(map);
        responseCall.enqueue(new Callback<StoreProductResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreProductResponse> call, @NonNull Response<StoreProductResponse> response) {
                Utils.hideCustomProgressDialog();
                storeProductList.clear();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        if (response.body().getProducts() != null) {
                            storeProductList.addAll(response.body().getProducts());

                            if (response.body().getStore().isTaxIncluded()) {
                                tvTax.setText(getString(R.string.all_items_are_inclusive_of_all_taxes));
                            } else {
                                tvTax.setText(getString(R.string.all_items_are_exclusive_of_all_taxes));
                            }
                            if (store == null) {
                                store = response.body().getStore();
                                store.setCurrency(response.body().getCurrency());
                                store.setTags(Utils.getStoreTag(store.getFamousProductsTags()));
                                store.setPriceRattingTag(Utils.getStringPrice(store.getPriceRating(), store.getCurrency()));
                                StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(StoreProductActivity.this, store.getStoreTime(), response.body().getServerTime(), CurrentBooking.getInstance().getTimeZone(), false, null);
                                store.setStoreClosed(storeClosedResult.isStoreClosed());
                                store.setReOpenTime(storeClosedResult.getReOpenAt());
                                loadStoreProductData(store);
                            } else {
                                store.setTaxIncluded(response.body().getStore().isTaxIncluded());
                                store.setTaxDetails(response.body().getStore().getTaxDetails());
                                store.setUseItemTax(response.body().getStore().isUseItemTax());
                            }

                            currentBooking.setTaxIncluded(response.body().getStore().isTaxIncluded());
                            currentBooking.setUseItemTax(response.body().getStore().isUseItemTax());
                            currentBooking.setTaxesDetails(response.body().getStore().getTaxDetails());

                            initRevStoreProductList();
                            updateStoreItemListAsCart();

                            updateTableBookingUI(response.body().getStore());

                            if (store != null && store.isProvideTableBooking() && (store.isTableReservationWithOrder() || store.isTableReservation()) && tableId != null && !TextUtils.isEmpty(tableId)) {
                                getTableDetail();
                                checkQRCodeOrderAvailable(response.body().getStore());
                            }
                        }
                    } else {
                        initRevStoreProductList();
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), StoreProductActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreProductResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void checkQRCodeOrderAvailable(Store store) {
        if (store != null) {
            if (!store.isApproved() || !store.isBusiness() || !store.isCountryBusiness()
                    || !store.isCityBusiness() || !store.isDeliveryBusiness() || store.isStoreClosed()
                    || store.isBusy()) {
                showQRCodeOrderAlertDialog(getString(R.string.text_qr_code_order_not_available));
            } else if (!store.isTableReservationWithOrder()) {
                showQRCodeOrderAlertDialog(getString(R.string.text_qr_code_table_order_not_available));
            }
        }
    }

    private void showQRCodeOrderAlertDialog(String message) {
        if (qrCodeOrderAlertDialog != null && qrCodeOrderAlertDialog.isShowing()) {
            return;
        }
        qrCodeOrderAlertDialog = new CustomDialogAlert(this, getString(R.string.text_alert), message, getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
                onBackNavigation();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                onBackNavigation();
            }
        };
        qrCodeOrderAlertDialog.show();
    }

    private void getTableDetail() {
        if (tableId != null && !TextUtils.isEmpty(tableId)) {
            Utils.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.TABLE_ID, tableId);
            map.put(Const.Params.STORE_ID, store.getId());

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<TableDetailResponse> responseCall = apiInterface.getTableDetails(map);
            responseCall.enqueue(new Callback<TableDetailResponse>() {
                @Override
                public void onResponse(@NonNull Call<TableDetailResponse> call, @NonNull Response<TableDetailResponse> response) {
                    Utils.hideCustomProgressDialog();
                    if (parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            if (response.body().getTable() != null && response.body().getTable().isIsUserCanBook() && response.body().getTable().isBusiness()) {
                                currentBooking.setTableNumber(Integer.parseInt(response.body().getTable().getTableNo()));
                                currentBooking.setNumberOfPerson(response.body().getTable().getTableMaxPerson());
                                currentBooking.setDeliveryType(Const.DeliveryType.TABLE_BOOKING);
                                preferenceHelper.putIsFromQRCode(true);
                                btnBookTable.setVisibility(View.GONE);
                            } else {
                                showQRCodeOrderAlertDialog(getString(R.string.text_qr_code_table_order_not_available));
                            }
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<TableDetailResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvStoreProductGroupList() {
        if (productGroupAdapter != null) {
            productGroupAdapter.notifyDataSetChanged();
        } else {
            productGroupAdapter = new ProductGroupAdapter(this, storeProductGroupList) {
                @Override
                public void onSelect(int selectedPosition) {
                    if (selectedPosition < storeProductGroupList.size()) {
                        getStoreProductList(storeId, storeProductGroupList.get(selectedPosition).getProductIds());
                    }
                }
            };
            productGroupAdapter.setHasStableIds(true);
            rcvProductGroup.setAdapter(productGroupAdapter);
            rcvProductGroup.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
            productGroupAdapter.setSelectedCategory(0);
        }
    }

    /**
     * this method call a webservice for get particular store product list according to store
     *
     * @param storeId store in string
     */
    private void getProductGroupList(String storeId) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.STORE_ID, storeId);
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        map.put(Const.Params.CITY_ID, currentBooking.getBookCityId());
        ApiInterface apiInterface = new ApiClient().changeHeaderLang(storeIndex).create(ApiInterface.class);
        Call<ProductGroupsResponse> responseCall = apiInterface.getProductGroupList(map);
        responseCall.enqueue(new Callback<ProductGroupsResponse>() {
            @Override
            public void onResponse(@NonNull Call<ProductGroupsResponse> call, @NonNull Response<ProductGroupsResponse> response) {
                Utils.hideCustomProgressDialog();
                storeProductGroupList.clear();
                if (parseContent.isSuccessful(response)) {
                    if (Objects.requireNonNull(response.body()).isSuccess()) {
                        if (response.body().getProductGroups() != null) {
                            for (ProductGroup productGroup : response.body().getProductGroups()) {
                                if (!Utils.checkCategoryOpenAndClosed(productGroup.getCategoryTime(), CurrentBooking.getInstance().getServerTime(), currentBooking.isFutureOrder(), currentBooking.isFutureOrder() ? currentBooking.getSchedule().getScheduleCalendar() : null)) {
                                    storeProductGroupList.add(productGroup);
                                }
                            }
                            Collections.sort(storeProductGroupList);
                            initRcvStoreProductGroupList();
                            llProductGroupDetail.setVisibility(View.VISIBLE);
                            if (TextUtils.isEmpty(preferenceHelper.getUserId())) {
                                ivFavourites.setVisibility(View.GONE);
                                flFavourite.setVisibility(View.GONE);
                            } else {
                                ivFavourites.setVisibility(View.VISIBLE);
                                flFavourite.setVisibility(View.VISIBLE);
                            }
                        }
                    }
                    if (storeProductGroupList.isEmpty()) {
                        llProductGroupDetail.setVisibility(View.GONE);
                        getStoreProductList(storeId, null);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProductGroupsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void loadStoreProductData(Store store) {
        if (store != null) {
            tvSelectedStoreName.setText(store.getName());
            tvSelectedStoreRatings.setText(String.valueOf(store.getRate()));
            tvSelectedStorePricing.setText(store.getPriceRattingTag());
            tvStoreTags.setText(store.getTags());

            if (store.getDeliveryTimeMax() > store.getDeliveryTime()) {
                tvSelectedStoreApproxTime.setText(String.format("%s %s - %s %s %s", "|", store.getDeliveryTime(), store.getDeliveryTimeMax(), getResources().getString(R.string.unit_mins), "|"));
            } else {
                tvSelectedStoreApproxTime.setText(String.format("%s %s %s %s", "|", store.getDeliveryTime(), getResources().getString(R.string.unit_mins), "|"));
            }

            ivFavourites.setChecked(store.isFavourite());
            if (store.isStoreClosed()) {
                flStoreClosed.setVisibility(View.VISIBLE);
                tvStoreReOpenTime.setVisibility(View.VISIBLE);
                tvStoreReOpenTime.setText(store.getReOpenTime());
            } else {
                if (store.isBusy()) {
                    flStoreClosed.setVisibility(View.VISIBLE);
                    tvTag.setText(getResources().getText(R.string.text_store_busy));
                    tvStoreReOpenTime.setVisibility(View.GONE);
                } else {
                    flStoreClosed.setVisibility(View.GONE);
                }
            }
            setTitleOnToolBar(store.getName());
            if (PreferenceHelper.getInstance(this).getIsLoadStoreImage()) {
                GlideApp.with(StoreProductActivity.this)
                        .load(IMAGE_URL + store.getImageUrl())
                        .placeholder(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                        .fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                        .dontAnimate()
                        .into(ivStoreImage);
            }
            supportPostponeEnterTransition();
            ivStoreImage.getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    ivStoreImage.getViewTreeObserver().removeOnPreDrawListener(this);
                    supportStartPostponedEnterTransition();
                    return true;
                }
            });
        }
    }

    public void goToProductSpecificationActivity(ProductDetail productDetail, ProductItem productItem, View view, boolean isAnimated) {
        int updateItemIndex = -1;
        int updateItemIndexSection = -1;
        CartProducts cartProducts;
        CartProductItems cartProductItems;

        for (int i = 0; i < currentBooking.getCartProductWithSelectedSpecificationList().size(); i++) {
            cartProducts = currentBooking.getCartProductWithSelectedSpecificationList().get(i);
            if (cartProducts.getProductId().equals(productDetail.getId())) {
                updateItemIndexSection = i;
                for (int j = 0; j < cartProducts.getItems().size(); j++) {
                    cartProductItems = cartProducts.getItems().get(j);
                    if (cartProductItems.getItemId().equals(productItem.getId()) && productItem.getSpecifications().isEmpty()) {
                        updateItemIndex = j;
                        break;
                    }
                }
            }
        }

        Intent intent = new Intent(this, ProductSpecificationActivity.class);
        intent.putExtra(Const.Params.IS_ORDER_CHANGE, isOrderChange);
        intent.putExtra(Const.UPDATE_ITEM_INDEX, updateItemIndex);
        intent.putExtra(Const.UPDATE_ITEM_INDEX_SECTION, updateItemIndexSection);
        intent.putExtra(Const.PRODUCT_DETAIL, productDetail);
        intent.putExtra(Const.PRODUCT_ITEM, productItem);
        intent.putExtra(Const.SELECTED_STORE, store);
        intent.putExtra(Const.STORE_INDEX, storeIndex);

        if (isAnimated) {
            Pair<View, String> p1 = Pair.create(view.findViewById(R.id.ivProductImage), getResources().getString(R.string.transition_string_store_product));
            ActivityOptionsCompat options = ActivityOptionsCompat.makeSceneTransitionAnimation(this, p1);
            ActivityCompat.startActivity(this, intent, options.toBundle());
        } else {
            startActivity(intent);
            overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
        }
    }

    private void setCartItem() {
        cartCount = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }

        if (cartCount > 0 && !isOrderChange) {
            tvCartCount.setText(String.valueOf(cartCount));
            btnGotoCart.setVisibility(View.VISIBLE);
        } else {
            btnGotoCart.setVisibility(View.GONE);
        }
    }

    private void loadExtraData() {
        if (getIntent() != null) {
            store = getIntent().getExtras().getParcelable(Const.SELECTED_STORE);
            storeId = getIntent().getExtras().getString(Const.STORE_DETAIL);
            tableId = getIntent().getExtras().getString(Const.TABLE_DETAIL);
            filter = getIntent().getExtras().getString(Const.FILTER);
            storeIndex = getIntent().getExtras().getInt(Const.STORE_INDEX);
            isOrderChange = getIntent().getExtras().getBoolean(Const.Params.IS_ORDER_CHANGE, false);

            if (getIntent().hasExtra(Const.IS_STORE_CAN_CREATE_GROUP)) {
                isStoreCanCreateGroup = getIntent().getBooleanExtra(Const.IS_STORE_CAN_CREATE_GROUP, false);
            } else {
                isStoreCanCreateGroup = currentBooking.isStoreCanCreateGroup();
            }
        }
    }

    private void setupWindowAnimations() {
        getWindow().requestFeature(Window.FEATURE_CONTENT_TRANSITIONS);
        Transition transition;
        transition = TransitionInflater.from(this).inflateTransition(R.transition.slide_and_changebounds);
        getWindow().setSharedElementEnterTransition(transition);
    }

    private void setFavoriteStore(String storeId) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.STORE_ID, storeId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SetFavouriteResponse> call = apiInterface.setFavouriteStore(map);
        call.enqueue(new Callback<SetFavouriteResponse>() {
            @Override
            public void onResponse(@NonNull Call<SetFavouriteResponse> call, @NonNull Response<SetFavouriteResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.getFavourite().clear();
                        currentBooking.setFavourite(response.body().getFavouriteStores());
                        store.setFavourite(true);
                        ivFavourites.setChecked(true);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<SetFavouriteResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void removeAsFavoriteStore(String storeId) {
        Utils.showCustomProgressDialog(this, false);
        ArrayList<String> storeList = new ArrayList<>();
        storeList.add(storeId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SetFavouriteResponse> call = apiInterface.removeAsFavouriteStore(ApiClient.makeGSONRequestBody(new RemoveFavourite(preferenceHelper.getSessionToken(), preferenceHelper.getUserId(), storeList)));
        call.enqueue(new Callback<SetFavouriteResponse>() {
            @Override
            public void onResponse(@NonNull Call<SetFavouriteResponse> call, @NonNull Response<SetFavouriteResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.getFavourite().clear();
                        currentBooking.setFavourite(response.body().getFavouriteStores());
                        store.setFavourite(false);
                        ivFavourites.setChecked(false);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<SetFavouriteResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void updateUiEditOrder() {
        if (isOrderChange) {
            flCart.setVisibility(View.GONE);
        } else {
            flCart.setVisibility(View.VISIBLE);
        }
    }

    private void openProductFilter() {
        if (dialogProductFilter != null && dialogProductFilter.isShowing()) {
            return;
        }
        dialogProductFilter = new DialogProductFilter(this, storeProductList, filter, itemName -> {
            pinnedHeaderItemDecoration.disableCache();
            storeProductAdapter.getFilter().filter(itemName);
            dialogProductFilter.dismiss();
            new Handler(Looper.myLooper()).postDelayed(() -> {
                if (storeProductAdapter.getStoreProductList().isEmpty()) {
                    Utils.showToast(getString(R.string.searched_item_not_available), StoreProductActivity.this);
                }
            }, 200);
        });
        dialogProductFilter.show();
    }

    private void openTableBooking(Store store) {
        DialogTableBooking dialogTableBooking = new DialogTableBooking(this, preferenceHelper, parseContent, store, null, this.currentBooking.getServerTime()) {
            @Override
            public void doWithEnable(Store store, int tableBookingType) {
                dismiss();
                currentBooking.setCartCurrency(currentBooking.getCurrency());
                if (tableBookingType == Const.TableBookingType.BOOK_AT_REST) {
                    addItemInServerCart(store);
                }
            }
        };
        dialogTableBooking.show();
    }

    private void addItemInServerCart(Store store) {
        Utils.showCustomProgressDialog(this, false);
        currentBooking.setDeliveryLatLng(currentBooking.getCurrentLatLng());
        currentBooking.setDeliveryAddress(currentBooking.getCurrentAddress());
        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setServerToken(preferenceHelper.getSessionToken());
        cartOrder.setStoreId(currentBooking.getSelectedStoreId());
        cartOrder.setProducts(new ArrayList<>());
        currentBooking.setTaxIncluded(store.isTaxIncluded());
        currentBooking.setUseItemTax(store.isUseItemTax());
        currentBooking.setTaxesDetails(store.getTaxDetails());
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(new ArrayList<>());

        if (currentBooking.getDestinationAddresses().isEmpty() || !TextUtils.equals(currentBooking.getDestinationAddresses().get(0).getAddress(), currentBooking.getDeliveryAddress())) {
            Addresses addresses = new Addresses();
            addresses.setAddress(currentBooking.getDeliveryAddress());
            addresses.setCity(currentBooking.getCity1());
            addresses.setAddressType(Const.Type.DESTINATION);
            addresses.setNote("");
            addresses.setUserType(Const.Type.USER);
            ArrayList<Double> location = new ArrayList<>();
            location.add(currentBooking.getDeliveryLatLng().latitude);
            location.add(currentBooking.getDeliveryLatLng().longitude);
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(isCurrentLogin() ? preferenceHelper.getEmail() : "");
            cartUserDetail.setCountryPhoneCode(isCurrentLogin() ? preferenceHelper.getCountryCode() : "");
            cartUserDetail.setName(isCurrentLogin() ? preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName() : "");
            cartUserDetail.setPhone(isCurrentLogin() ? preferenceHelper.getPhoneNumber() : "");
            cartUserDetail.setImageUrl(isCurrentLogin() ? preferenceHelper.getProfilePic() : "");
            addresses.setUserDetails(cartUserDetail);
            currentBooking.setDestinationAddresses(addresses);
        }

        if (currentBooking.getPickupAddresses().isEmpty()) {
            Addresses addresses = new Addresses();
            addresses.setAddress(store.getAddress());
            addresses.setCity("");
            addresses.setAddressType(Const.Type.PICKUP);
            addresses.setNote("");
            addresses.setUserType(Const.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(store.getLocation().get(0));
            location.add(store.getLocation().get(1));
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(store.getEmail());
            cartUserDetail.setCountryPhoneCode(store.getCountryPhoneCode());
            cartUserDetail.setName(store.getName());
            cartUserDetail.setPhone(store.getPhone());
            cartUserDetail.setImageUrl(store.getImageUrl());
            addresses.setUserDetails(cartUserDetail);
            currentBooking.setPickupAddresses(addresses);
        }

        cartOrder.setDestinationAddresses(currentBooking.getDestinationAddresses());
        cartOrder.setPickupAddresses(currentBooking.getPickupAddresses());

        double cartOrderTotalPrice = 0, totalCartAmountWithoutTax = 0, cartOrderTotalTaxPrice = 0;
        cartOrder.setCartOrderTotalPrice(cartOrderTotalPrice);
        cartOrder.setCartOrderTotalTaxPrice(cartOrderTotalTaxPrice);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);
        cartOrder.setTableNo(currentBooking.getTableNumber());
        cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
        cartOrder.setBookingType(currentBooking.getTableBookingType());
        cartOrder.setDeliveryType(currentBooking.getDeliveryType());

        if (currentBooking.isTableBooking() && currentBooking.getSchedule() != null) {
            cartOrder.setOrderStartAt(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli());
            cartOrder.setOrderStartAt2(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli());
            cartOrder.setTableId(currentBooking.getTableId());
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.setCartId(response.body().getCartId());
                        currentBooking.setCartCityId(response.body().getCityId());
                        goToCheckoutActivity();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), StoreProductActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddCartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void goToCheckoutActivity() {
        Intent intent = new Intent(this, CheckoutActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void openClearCartDialog(boolean isAddToCart) {
        final CustomDialogAlert dialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_other_store_item_in_cart), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                clearCart(isAddToCart);
                dismiss();
            }
        };
        dialogAlert.show();
    }

    public void clearCart(boolean isAddToCart) {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        HashMap<String, Object> map = getCommonParam();
        map.put(Const.Params.CART_ID, currentBooking.getCartId());
        Call<IsSuccessResponse> responseCall = apiInterface.clearCart(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.clearCart();
                        updateStoreItemListAsCart();
                        setCartItem();
                        if (isAddToCart && productItem != null && productDetail != null) {
                            addToCart(productItem, productDetail);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), StoreProductActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CART_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void increaseItemQuality(ProductItem productItem, int section, int relativePosition) {
        this.productItem = productItem;

        CartProductItems foundCartProductItem = null;
        int itemCount = 0;
        for (CartProducts cartProduct : currentBooking.getCartProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItem : cartProduct.getItems()) {
                if (cartProductItem.getItemId().equals(productItem.getId())) {
                    foundCartProductItem = cartProductItem;
                    itemCount++;
                }
            }
        }

        if (foundCartProductItem != null && itemCount > 0) {
            if (productItem.getSpecifications().isEmpty()) {
                int quantity = foundCartProductItem.getQuantity();
                quantity++;
                foundCartProductItem.setQuantity(quantity);
                foundCartProductItem.setTotalItemAndSpecificationPrice((foundCartProductItem.getTotalSpecificationPrice() + foundCartProductItem.getItemPrice()) * quantity);
                foundCartProductItem.setTotalItemTax(foundCartProductItem.getTotalTax() * quantity);

                storeProductList.get(section).getItems().get(relativePosition).setCartItemQuantity(quantity);

                modifyTotalItemAmount();
                addItemInServerCart((CartProducts) null);
            } else {
                StringBuilder strSpecifications = new StringBuilder();
                for (Specifications specifications : foundCartProductItem.getSpecifications()) {
                    for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                        strSpecifications.append(specificationSubItem.getName())
                                .append(specificationSubItem.getQuantity() > 1 ?
                                        String.format(Locale.getDefault(), " (%d), ", specificationSubItem.getQuantity()) : ", ");
                    }
                }
                openChooseAndRepeatDialog(strSpecifications.substring(0, strSpecifications.toString().lastIndexOf(", ")), storeProductList.get(section).getProductDetail(),
                        productItem, foundCartProductItem, section, relativePosition);
            }
        }
    }

    public void decreaseItemQuantity(ProductItem productItem, int section, int relativePosition) {
        this.productItem = productItem;

        int quantity, itemCount = 0;
        CartProductItems foundCartProductItem = null;
        CartProducts foundCartProduct = null;
        for (CartProducts cartProduct : currentBooking.getCartProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItem : cartProduct.getItems()) {
                if (cartProductItem.getItemId().equals(productItem.getId())) {
                    foundCartProductItem = cartProductItem;
                    foundCartProduct = cartProduct;
                    itemCount++;
                }
            }
        }

        if (foundCartProductItem != null && itemCount > 0) {
            if (itemCount == 1) {
                quantity = foundCartProductItem.getQuantity();
                if (quantity > 0) {
                    quantity--;
                    foundCartProductItem.setQuantity(quantity);
                    foundCartProductItem.setTotalItemAndSpecificationPrice((foundCartProductItem.getTotalSpecificationPrice() + foundCartProductItem.getItemPrice()) * quantity);
                    foundCartProductItem.setTotalItemTax(foundCartProductItem.getTotalTax() * quantity);
                }
                storeProductList.get(section).getItems().get(relativePosition).setCartItemQuantity(quantity);
                if (quantity == 0) {
                    foundCartProduct.getItems().remove(foundCartProductItem);
                    if (foundCartProduct.getItems().isEmpty()) {
                        currentBooking.getCartProductWithSelectedSpecificationList().remove(foundCartProduct);
                    }
                }

                modifyTotalItemAmount();
                if (getCartItemCount() == 0) {
                    clearCart(false);
                } else {
                    addItemInServerCart((CartProducts) null);
                }
            } else {
                openMultipleItemAddedDialog();
            }
        }
    }

    private void openChooseAndRepeatDialog(String message, ProductDetail productDetail, ProductItem productItem,
                                           CartProductItems foundCartProductItem, int section, int relativePosition) {
        if (dialogChooseAndRepeat != null && dialogChooseAndRepeat.isShowing()) {
            return;
        }
        dialogChooseAndRepeat = new DialogChooseAndRepeat(this, message) {
            @Override
            public void onClickIWllChooseButton() {
                dismiss();
                productItem.setCartItemQuantity(1);
                goToProductSpecificationActivity(productDetail, productItem, null, false);
            }

            @Override
            public void onClickRepeatLastButton() {
                dismiss();
                int quantity = foundCartProductItem.getQuantity();
                quantity++;
                foundCartProductItem.setQuantity(quantity);
                foundCartProductItem.setTotalItemAndSpecificationPrice((foundCartProductItem.getTotalSpecificationPrice() + foundCartProductItem.getItemPrice()) * quantity);
                foundCartProductItem.setTotalItemTax(foundCartProductItem.getTotalTax() * quantity);

                storeProductList.get(section).getItems().get(relativePosition).setCartItemQuantity(quantity);

                modifyTotalItemAmount();
                addItemInServerCart((CartProducts) null);
            }
        };
        dialogChooseAndRepeat.show();
    }

    private void openMultipleItemAddedDialog() {
        if (multipleItemAddedDialog != null && multipleItemAddedDialog.isShowing()) {
            return;
        }
        multipleItemAddedDialog = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.mag_multiple_customize_item_in_cart), getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                if (isOrderChange) {
                    onBackNavigation();
                } else {
                    goToCartActivity();
                }
            }
        };
        multipleItemAddedDialog.show();
    }

    /**
     * this method id used to remove particular item quantity in cart
     */
    public void removeItem(ProductItem productItem) {
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                if (cartProductItems.getItemId().equals(productItem.getId())) {
                    cartProducts.getItems().remove(cartProductItems);
                    if (cartProducts.getItems().isEmpty()) {
                        currentBooking.getCartProductWithSelectedSpecificationList().remove(cartProducts);
                    }
                }
            }
        }
        if (getCartItemCount() == 0) {
            clearCart(false);
        } else {
            addItemInServerCart((CartProducts) null);
        }
    }

    /**
     * this method will manage total amount after change or modify
     */
    public void modifyTotalItemAmount() {
        double totalAmount = 0;
        double totalCartAmountWithoutTax = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                totalAmount = totalAmount + cartProductItems.getTotalItemAndSpecificationPrice();
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + cartProductItems.getTotalItemAndSpecificationPrice();
                if (currentBooking.isTaxIncluded()) {
                    totalAmount = totalAmount - cartProductItems.getTotalItemTax();
                }
            }
        }
        currentBooking.setTotalCartAmount(totalAmount);
        currentBooking.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);
    }

    private int getCartItemCount() {
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        return cartCount;
    }

    public void checkValidCartItem(ProductItem productItem, ProductDetail productDetail) {
        this.productItem = productItem;
        this.productDetail = productDetail;

        if (isOrderChange) {
            addToOrder();
        } else {
            if (cartCount == 0) {
                addToCart(productItem, productDetail);
            } else if (TextUtils.equals(currentBooking.getSelectedStoreId(), productItem.getStoreId())) {
                addToCart(productItem, productDetail);
            } else {
                openClearCartDialog(true);
            }
        }
    }

    /**
     * this method to create cart structure witch is help to add item in cart
     */
    public void addToCart(ProductItem productItem, ProductDetail productDetail) {
        double specificationPriceTotal = 0;
        double specificationPrice = 0;
        currentBooking.setDeliveryLatLng(currentBooking.getCurrentLatLng());
        currentBooking.setDeliveryAddress(currentBooking.getCurrentAddress());
        ArrayList<Specifications> specificationList = new ArrayList<>();
        Utils.showCustomProgressDialog(this, false);
        for (Specifications specificationListItem : productItem.getSpecifications()) {
            ArrayList<SpecificationSubItem> specificationItemCartList = new ArrayList<>();
            for (SpecificationSubItem listItem : specificationListItem.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    specificationPrice = specificationPrice + (listItem.getPrice() * listItem.getQuantity());
                    specificationPriceTotal = specificationPriceTotal + (listItem.getPrice() * listItem.getQuantity());
                    specificationItemCartList.add(listItem);
                }
            }

            if (!specificationItemCartList.isEmpty()) {
                Specifications specifications = new Specifications();
                specifications.setList(specificationItemCartList);
                specifications.setName(specificationListItem.getName());
                specifications.setPrice(specificationPrice);
                specifications.setType(specificationListItem.getType());
                specifications.setUniqueId(specificationListItem.getUniqueId());
                specificationList.add(specifications);
            }
            specificationPrice = 0;
        }

        CartProductItems cartProductItems = new CartProductItems();
        cartProductItems.setItemId(productItem.getId());
        cartProductItems.setUniqueId(productItem.getUniqueId());
        cartProductItems.setItemName(productItem.getName());
        cartProductItems.setQuantity(1);
        cartProductItems.setImageUrl(productItem.getImageUrl());
        cartProductItems.setDetails(productItem.getDetails());
        cartProductItems.setSpecifications(specificationList);
        cartProductItems.setTotalSpecificationPrice(specificationPriceTotal);
        cartProductItems.setItemPrice(productItem.getPrice());
        cartProductItems.setItemNote("");
        cartProductItems.setTotalItemAndSpecificationPrice(productItem.getPrice());
        if (store != null) {
            cartProductItems.setTax(store.isUseItemTax() ? productItem.getTotalTax() : store.getTotalTaxes());
        } else {
            cartProductItems.setTax(productItem.getTotalTax());
        }
        cartProductItems.setTotalPrice(cartProductItems.getItemPrice() + cartProductItems.getTotalSpecificationPrice());
        cartProductItems.setItemTax(getTaxableAmount(productItem.getPrice(), cartProductItems.getTax()));
        cartProductItems.setTotalSpecificationTax(getTaxableAmount(specificationPriceTotal, cartProductItems.getTax()));
        cartProductItems.setTotalTax(cartProductItems.getItemTax() + cartProductItems.getTotalSpecificationTax());
        cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * cartProductItems.getQuantity());
        cartProductItems.setTaxesDetails(productItem.getTaxesDetails());

        if (!currentBooking.getCartProductItemWithAllSpecificationList().contains(productItem)) {
            currentBooking.setCartProductItemWithAllSpecificationList(productItem);
        }
        if (isProductExistInLocalCart(cartProductItems)) {

        } else {
            ArrayList<CartProductItems> cartProductItemsList = new ArrayList<>();
            cartProductItemsList.add(cartProductItems);
            CartProducts cartProducts = new CartProducts();
            cartProducts.setItems(cartProductItemsList);
            cartProducts.setProductId(productItem.getProductId());
            cartProducts.setProductName(productDetail.getName());
            cartProducts.setUniqueId(productDetail.getUniqueId());
            cartProducts.setTotalProductItemPrice(productItem.getPrice());
            cartProducts.setTotalItemTax(cartProductItems.getTotalItemTax());
            currentBooking.setCartProduct(cartProducts);
            currentBooking.setSelectedStoreId(productItem.getStoreId());
            addItemInServerCart(cartProducts);
        }
    }

    /**
     * this method check product is exist in local cart
     *
     * @param cartProductItems cartProductItems
     * @return true if product exist otherwise false
     */
    private boolean isProductExistInLocalCart(CartProductItems cartProductItems) {
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            if (TextUtils.equals(cartProducts.getProductId(), productItem.getProductId())) {
                cartProducts.getItems().add(cartProductItems);
                itemPriceAndSpecificationPriceTotal = cartProducts.getTotalProductItemPrice() + itemPriceAndSpecificationPriceTotal;
                cartProducts.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
                cartProducts.setTotalItemTax(cartProducts.getTotalItemTax() + cartProductItems.getTotalItemTax());
                addItemInServerCart(cartProducts);
                return true;
            }
        }
        return false;
    }

    private void addToOrder() {
        itemQuantity = productItem.getQuantity() + 1;

        CartProductItems cartProductItems = new CartProductItems();
        cartProductItems.setItemId(productItem.getId());
        cartProductItems.setUniqueId(productItem.getUniqueId());
        cartProductItems.setItemName(productItem.getName());
        cartProductItems.setQuantity(itemQuantity);
        cartProductItems.setImageUrl(productItem.getImageUrl());
        cartProductItems.setDetails(productItem.getDetails());
        cartProductItems.setSpecifications(new ArrayList<>());
        cartProductItems.setTotalSpecificationPrice(0);
        cartProductItems.setItemPrice(productItem.getPrice());
        cartProductItems.setItemNote("");
        cartProductItems.setTotalItemAndSpecificationPrice(productItem.getPrice());

        if (store != null) {
            cartProductItems.setTax(store.isUseItemTax() ? productItem.getTotalTax() : store.getTotalTaxes());
        } else {
            cartProductItems.setTax(productItem.getTotalTax());
        }
        cartProductItems.setTotalPrice(cartProductItems.getItemPrice() + cartProductItems.getTotalSpecificationPrice());

        cartProductItems.setItemTax(getTaxableAmount(productItem.getPrice(), cartProductItems.getTax()));
        cartProductItems.setTotalSpecificationTax(getTaxableAmount(0, cartProductItems.getTax()));
        cartProductItems.setTotalTax(cartProductItems.getItemTax() + cartProductItems.getTotalSpecificationTax());
        cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * cartProductItems.getQuantity());
        cartProductItems.setTaxesDetails(productItem.getTaxesDetails());

        if (!OrderEdit.getInstance().getOrderEditedProductItemWithAllSpecificationList().contains(productItem)) {
            OrderEdit.getInstance().setOrderEditedProductItemWithAllSpecificationList(productItem);
        }

        // product exist in order
        if (isProductExistInOrder(cartProductItems)) {

        } else {
            ArrayList<CartProductItems> cartProductItemsList = new ArrayList<>();
            cartProductItemsList.add(cartProductItems);
            CartProducts cartProducts = new CartProducts();
            cartProducts.setItems(cartProductItemsList);
            cartProducts.setProductId(productItem.getProductId());
            cartProducts.setProductName(productDetail.getName());
            cartProducts.setUniqueId(productDetail.getUniqueId());
            cartProducts.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
            cartProducts.setTotalItemTax(cartProductItems.getTotalItemTax());
            OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList().add(cartProducts);
        }

        onBackNavigation();
    }

    private boolean isProductExistInOrder(CartProductItems cartProductItems) {
        boolean isExist = false;
        for (CartProducts cartProducts : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
            if (TextUtils.equals(cartProducts.getProductId(), productItem.getProductId())) {
                for (CartProductItems cartProductItems1 : cartProducts.getItems()) {
                    if (cartProductItems.equals(cartProductItems1)) {
                        int quantity = itemQuantity + cartProductItems1.getQuantity();
                        cartProductItems1.setQuantity(itemQuantity + cartProductItems1.getQuantity());
                        cartProductItems1.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
                        cartProductItems1.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) {
                    cartProducts.getItems().add(cartProductItems);
                }
                itemPriceAndSpecificationPriceTotal = cartProducts.getTotalProductItemPrice() + itemPriceAndSpecificationPriceTotal;
                cartProducts.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
                cartProducts.setTotalItemTax(cartProducts.getTotalItemTax() + cartProductItems.getTotalItemTax());
                return true;
            }
        }
        return false;
    }

    @SuppressLint("NotifyDataSetChanged")
    private void updateStoreItemListAsCart() {
        for (Product product : storeProductList) {
            for (ProductItem productItem : product.getItems()) {
                productItem.setCartItemQuantity(0);
            }
        }

        if (!currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
            for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
                for (Product product : storeProductList) {
                    if (cartProducts.getProductId().equals(product.getProductDetail().getId())) {
                        for (CartProductItems cartProductItems : cartProducts.getItems()) {
                            for (ProductItem productItem1 : product.getItems()) {
                                if (cartProductItems.getItemId().equals(productItem1.getId())) {
                                    productItem1.setCartItemQuantity(cartProductItems.getQuantity() + productItem1.getCartItemQuantity());
                                }
                            }
                        }
                    }
                }
            }
        }

        storeProductAdapter.notifyDataSetChanged();
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (store != null && store.isTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }


    /**
     * this method called webservice for add product in cart
     *
     * @param cartProducts CartProducts object
     */
    private void addItemInServerCart(final CartProducts cartProducts) {
        Utils.showCustomProgressDialog(this, false);

        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(currentBooking.getTaxesDetails());
        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setServerToken(preferenceHelper.getSessionToken());
        cartOrder.setStoreId(currentBooking.getSelectedStoreId());
        cartOrder.setProducts(currentBooking.getCartProductWithSelectedSpecificationList());
        cartOrder.setTableNo(currentBooking.getTableNumber());
        cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
        cartOrder.setBookingType(currentBooking.getTableBookingType());
        cartOrder.setDeliveryType(currentBooking.getDeliveryType());

        if (currentBooking.getDestinationAddresses().isEmpty() || !TextUtils.equals(currentBooking.getDestinationAddresses().get(0).getAddress(), currentBooking.getDeliveryAddress())) {
            Addresses addresses = new Addresses();
            addresses.setAddress(currentBooking.getDeliveryAddress());
            addresses.setCity(currentBooking.getCity1());
            addresses.setAddressType(Const.Type.DESTINATION);
            addresses.setNote("");
            addresses.setUserType(Const.Type.USER);
            ArrayList<Double> location = new ArrayList<>();
            location.add(currentBooking.getDeliveryLatLng().latitude);
            location.add(currentBooking.getDeliveryLatLng().longitude);
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(preferenceHelper.getEmail());
            cartUserDetail.setCountryPhoneCode(preferenceHelper.getCountryPhoneCode());
            cartUserDetail.setName(preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName());
            cartUserDetail.setPhone(preferenceHelper.getPhoneNumber());
            cartUserDetail.setImageUrl(preferenceHelper.getProfilePic());
            addresses.setUserDetails(cartUserDetail);
            if (!currentBooking.getDestinationAddresses().isEmpty()) {
                addresses.setFlatNo(currentBooking.getDestinationAddresses().get(0).getFlatNo());
                addresses.setStreet(currentBooking.getDestinationAddresses().get(0).getStreet());
                addresses.setLandmark(currentBooking.getDestinationAddresses().get(0).getLandmark());
            }
            currentBooking.setDestinationAddresses(addresses);
        }

        if (currentBooking.getPickupAddresses().isEmpty() && store != null) {
            Addresses addresses = new Addresses();
            addresses.setAddress(store.getAddress());
            addresses.setCity("");
            addresses.setAddressType(Const.Type.PICKUP);
            addresses.setNote("");
            addresses.setUserType(Const.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(store.getLocation().get(0));
            location.add(store.getLocation().get(1));
            addresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(store.getEmail());
            cartUserDetail.setCountryPhoneCode(store.getCountryPhoneCode());
            cartUserDetail.setName(store.getName());
            cartUserDetail.setPhone(store.getPhone());
            cartUserDetail.setImageUrl(store.getImageUrl());
            addresses.setUserDetails(cartUserDetail);
            currentBooking.setPickupAddresses(addresses);
        }
        cartOrder.setDestinationAddresses(currentBooking.getDestinationAddresses());
        cartOrder.setPickupAddresses(currentBooking.getPickupAddresses());

        double cartOrderTotalPrice = 0, totalCartAmountWithoutTax = 0, cartOrderTotalTaxPrice = 0;
        for (CartProducts products : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartOrderTotalPrice = cartOrderTotalPrice + products.getTotalProductItemPrice();
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + products.getTotalProductItemPrice();
            if (store != null && store.isTaxIncluded()) {
                cartOrderTotalPrice = cartOrderTotalPrice - products.getTotalItemTax();
            }
            cartOrderTotalTaxPrice = cartOrderTotalTaxPrice + products.getTotalItemTax();
        }
        cartOrder.setCartOrderTotalPrice(cartOrderTotalPrice);
        cartOrder.setCartOrderTotalTaxPrice(cartOrderTotalTaxPrice);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);
        if (currentBooking.isTableBooking()) {
            cartOrder.setTableNo(currentBooking.getTableNumber());
            cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
            cartOrder.setBookingType(currentBooking.getTableBookingType());
            cartOrder.setDeliveryType(currentBooking.getDeliveryType());
        }

        if (currentBooking.isTableBooking() && currentBooking.getSchedule() != null) {
            cartOrder.setOrderStartAt(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli());
            cartOrder.setOrderStartAt2(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli());
            cartOrder.setTableId(currentBooking.getTableId());
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.setCartId(response.body().getCartId());
                        currentBooking.setCartCityId(response.body().getCityId());
                        currentBooking.setCartCurrency(productItem.getCurrency());
                        if (store != null) {
                            currentBooking.setStoreLangs(store.getLang());
                        }
                        setCartItem();
                        updateStoreItemListAsCart();
                        Utils.showMessageToast(response.body().getStatusPhrase(), StoreProductActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), StoreProductActivity.this);
                        if (response.body().getErrorCode() == Const.TAXES_DETAILS_CHANGED) {
                            clearCart(false);
                        } else {
                            getCart();
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddCartResponse> call, @NonNull Throwable t) {
                currentBooking.getCartProductWithSelectedSpecificationList().remove(cartProducts);
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getCart() {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CartResponse> orderCall = apiInterface.getCart(getCommonParam());
        orderCall.enqueue(new Callback<CartResponse>() {
            @Override
            public void onResponse(@NonNull Call<CartResponse> call, @NonNull Response<CartResponse> response) {
                Utils.hideCustomProgressDialog();
                parseContent.parseCart(response);
                onBackPressed();
            }

            @Override
            public void onFailure(@NonNull Call<CartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.HOME_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }
}