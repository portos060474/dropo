package com.dropo;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.Html;
import android.text.TextUtils;
import android.transition.Transition;
import android.transition.TransitionInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.ProductItemItemAdapter;
import com.dropo.adapter.ProductSpecificationItemAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.interfaces.OnSingleClickListener;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.ProductDetail;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.datamodels.Store;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.SpecificationsResponse;
import com.dropo.models.singleton.OrderEdit;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.appbar.AppBarLayout;
import com.google.android.material.appbar.CollapsingToolbarLayout;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductSpecificationActivity extends BaseAppCompatActivity {

    public ProductItem productItem;
    private int requiredCount = 0;
    private CollapsingToolbarLayout collapsingToolbarLayout;
    private CustomFontEditTextView etAddNote;
    private TextView tvProductName, tvProductDescription, btnDecrease, btnIncrease, tvItemQuantity, tvItemAmount;
    private LinearLayout llAddToCart;
    private RecyclerView rcvSpecificationItem;
    private ProductSpecificationItemAdapter productSpecificationItemAdapter;
    private int itemQuantity = 1;
    private double itemPriceAndSpecificationPriceTotal = 0;
    private int cartCount = 0;
    private final List<Specifications> specificationsList = new ArrayList<>();
    private final List<Specifications> mainSpecificationList = new ArrayList<>();
    private ProductDetail productDetail;
    private ViewPager imageViewPager, imageViewPagerDialog;
    private LinearLayout llDots, llDotsDialog;
    private NestedScrollView scrollView;
    private boolean isScheduleStart;
    private ScheduledExecutorService tripStatusSchedule;
    private Handler handler;
    private int updateItemIndex = -1;
    private int updateItemSectionIndex = -1;
    private Store store;
    private int storeIndex;
    private boolean isOrderEdit;
    private TextView tvAddToCart;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupWindowAnimations();
        setContentView(R.layout.activity_product_specification);
        initToolBar();
        toolbar.setBackground(ResourcesCompat.getDrawable(getResources(), R.drawable.toolbar_transparent_2, getTheme()));
        ivToolbarBack.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_left_arrow, getTheme()));
        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, getTheme()));
        initViewById();
        setViewListener();
        loadExtraData();
        initImagePager();
        initAppBar();
        initCollapsingToolbar();
        itemQuantity = productItem.getCartItemQuantity() != 0 ? productItem.getCartItemQuantity() : itemQuantity;
        setData(itemQuantity);
        setTitleOnToolBar(productItem.getName());
        initHandler();
        getItemSpecificationList();
        updateUiEditOrder();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setCartItem();
        startAdsScheduled();
    }

    @Override
    protected void onPause() {
        stopAdsScheduled();
        super.onPause();
    }

    private void initImagePager() {
        findViewById(R.id.ivDefaultItemImage).setVisibility(productItem.getImageUrl().isEmpty() ? View.VISIBLE : View.GONE);
        addBottomDots(0);
        ProductItemItemAdapter itemItemAdapter = new ProductItemItemAdapter(this, productItem.getImageUrl(), R.layout.item_image, true);
        imageViewPager.setAdapter(itemItemAdapter);
        imageViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                dotColorChange(position);
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    private void addBottomDots(int currentPage) {
        if (productItem.getImageUrl().size() > 1) {
            TextView[] dots = new TextView[productItem.getImageUrl().size()];

            llDots.removeAllViews();
            for (int i = 0; i < dots.length; i++) {
                dots[i] = new TextView(this);
                dots[i].setText(Html.fromHtml("&#8226;"));
                dots[i].setTextSize(35);
                dots[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));
                llDots.addView(dots[i]);
            }

            if (dots.length > 0) {
                dots[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
            }
        }
    }

    private void dotColorChange(int currentPage) {
        if (llDots.getChildCount() > 0) {
            for (int i = 0; i < llDots.getChildCount(); i++) {
                TextView textView = (TextView) llDots.getChildAt(i);
                textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));

            }
            TextView textView = (TextView) llDots.getChildAt(currentPage);
            textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
        }
    }

    private void addBottomDotsDialog(int currentPage) {
        if (productItem.getImageUrl().size() > 1) {
            TextView[] dots1 = new TextView[productItem.getImageUrl().size()];

            llDotsDialog.removeAllViews();
            for (int i = 0; i < dots1.length; i++) {
                dots1[i] = new TextView(this);
                dots1[i].setText(Html.fromHtml("&#8226;"));
                dots1[i].setTextSize(35);
                dots1[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));
                llDotsDialog.addView(dots1[i]);
            }

            if (dots1.length > 0) {
                dots1[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
            }
        }
    }

    private void dotColorChangeDialog(int currentPage) {
        if (llDotsDialog.getChildCount() > 0) {
            for (int i = 0; i < llDotsDialog.getChildCount(); i++) {
                TextView textView = (TextView) llDotsDialog.getChildAt(i);
                textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));

            }
            TextView textView = (TextView) llDotsDialog.getChildAt(currentPage);
            textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        collapsingToolbarLayout = findViewById(R.id.specificationCollapsingToolBar);
        tvProductDescription = findViewById(R.id.tvCollapsingProductDescription);
        tvProductName = findViewById(R.id.tvCollapsingProductName);
        rcvSpecificationItem = findViewById(R.id.rcvSpecificationItem);
        btnIncrease = findViewById(R.id.btnIncrease);
        btnDecrease = findViewById(R.id.btnDecrease);
        tvItemQuantity = findViewById(R.id.tvItemQuantity);
        llAddToCart = findViewById(R.id.llAddToCart);
        tvItemAmount = findViewById(R.id.tvItemAmount);
        imageViewPager = findViewById(R.id.imageViewPager);
        llDots = findViewById(R.id.llDots);
        scrollView = findViewById(R.id.scrollView);
        etAddNote = findViewById(R.id.etAddNote);
        tvAddToCart = findViewById(R.id.tvAddToCart);

        Utils.setLeftBackgroundRtlView(this, btnIncrease);
        Utils.setRightBackgroundRtlView(this, btnDecrease);

    }

    @Override
    protected void setViewListener() {
        btnDecrease.setOnClickListener(this);
        btnIncrease.setOnClickListener(this);
    }

    private void setData(int itemQuantity) {
        tvItemQuantity.setText(String.valueOf(itemQuantity));
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.llAddToCart) {
            if (isOrderEdit) {
                addToOrder();
            } else {
                checkValidCartItem();
            }
        } else if (id == R.id.btnIncrease) {
            increaseItemQuality();
        } else if (id == R.id.btnDecrease) {
            decreaseItemQuantity();
        }
    }

    private void initCollapsingToolbar() {
        collapsingToolbarLayout.setTitleEnabled(false);
        collapsingToolbarLayout.setContentScrimColor(ResourcesCompat.getColor(getResources(), R.color.color_app_theme, null));
        collapsingToolbarLayout.setStatusBarScrimColor(ResourcesCompat.getColor(getResources(), R.color.color_app_theme, null));
        collapsingToolbarLayout.setCollapsedTitleTextAppearance(R.style.collapsedappbar);
        collapsingToolbarLayout.setExpandedTitleTextAppearance(R.style.expandedappbar);

    }

    private void initAppBar() {
        final Handler handler = new Handler(Looper.myLooper()) {
            @Override
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                switch (msg.what) {
                    case 1:
                        tvTitleToolbar.setTextColor(AppColor.getThemeTextColor(ProductSpecificationActivity.this));
                        ivToolbarBack.setImageDrawable(AppCompatResources.getDrawable(ProductSpecificationActivity.this, R.drawable.ic_left_arrow));
                        toolbar.setBackgroundColor(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(ProductSpecificationActivity.this) ? R.color.color_app_bg_dark : R.color.color_app_bg_light, null));
                        break;
                    case 2:
                        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
                        ivToolbarBack.setImageDrawable(AppCompatResources.getDrawable(ProductSpecificationActivity.this, R.drawable.ic_left_arrow));
                        tvTitleToolbar.setTextColor(ResourcesCompat.getColor(getResources(), android.R.color.transparent, null));
                        toolbar.setBackground(AppCompatResources.getDrawable(ProductSpecificationActivity.this, R.drawable.toolbar_transparent_2));
                        break;
                    default:
                        break;
                }
            }
        };

        AppBarLayout appBarLayout = findViewById(R.id.specificationAppBarLayout);
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

    private void loadProductSpecification() {
        tvProductName.setText(productItem.getName());
        tvProductDescription.setText(productItem.getDetails());
        specificationsList.addAll(productItem.getSpecifications());
        mainSpecificationList.addAll(productItem.getSpecifications());
        arrangeDataWithAssociateSpecification();
        modifyTotalItemAmount();

        productSpecificationItemAdapter = new ProductSpecificationItemAdapter(this, (ArrayList<Specifications>) specificationsList);
        rcvSpecificationItem.setLayoutManager(new LinearLayoutManager(this));
        rcvSpecificationItem.setNestedScrollingEnabled(false);
        rcvSpecificationItem.setAdapter(productSpecificationItemAdapter);
        scrollView.getParent().requestChildFocus(scrollView, scrollView);
    }

    private void arrangeDataWithAssociateSpecification() {
        specificationsList.clear();

        for (Specifications specifications : mainSpecificationList) {
            if (!specifications.isAssociated()) {
                specificationsList.add(specifications);
            }
        }

        ArrayList<String> itemIds = new ArrayList<>();
        for (Specifications specifications : specificationsList) {
            itemIds.add(specifications.getId());
        }

        ArrayList<SpecificationSubItem> selectedSpecificationsList = new ArrayList<>();
        for (Specifications specifications : specificationsList) {
            for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    selectedSpecificationsList.add(specificationSubItem);
                }
            }
        }

        for (Specifications objMain : mainSpecificationList) {
            for (SpecificationSubItem obj : selectedSpecificationsList) {
                if (obj.getId().equalsIgnoreCase(objMain.getModifierId()) && !itemIds.contains(objMain.getId())) {
                    specificationsList.add(objMain);
                } else if (obj.getId().equalsIgnoreCase(objMain.getModifierId()) && itemIds.contains(objMain.getId())) {
                    int index = -1;
                    for (int i = 0; i < specificationsList.size(); i++) {
                        if (specificationsList.get(i).getId().equalsIgnoreCase(objMain.getId())) {
                            index = i;
                            break;
                        }
                    }
                    if (index >= 0) {
                        specificationsList.remove(index);
                        specificationsList.add(index, objMain);
                    }
                }
            }
        }

        countIsRequiredAndDefaultSelected();
    }

    /**
     * this method manage single type specification click event
     *
     * @param section  section
     * @param position position
     */
    @SuppressLint("NotifyDataSetChanged")
    public void onSingleItemClick(int section, int position) {
        Specifications selectedSpecification = specificationsList.get(section);

        for (Specifications specifications : mainSpecificationList) {
            if (specifications.getId().equalsIgnoreCase(selectedSpecification.getId())) {
                specifications.setSelectedCount(1);
                for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                    specificationSubItem.setIsDefaultSelected(
                            specificationSubItem.getId().equalsIgnoreCase(selectedSpecification.getList().get(position).getId())
                    );
                }
            }
        }

        arrangeDataWithAssociateSpecification();
        productSpecificationItemAdapter.notifyDataSetChanged();
        modifyTotalItemAmount();
    }

    @Override
    public void onBackPressed() {
        try {
            super.onBackPressed();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        } catch (Exception e) {
            e.printStackTrace();
            finish();
        }
    }

    /**
     * this method to create cart structure witch is help to add item in cart
     */
    private void addToCart() {
        double specificationPriceTotal = 0;
        double specificationPrice = 0;
        currentBooking.setDeliveryLatLng(currentBooking.getCurrentLatLng());
        currentBooking.setDeliveryAddress(currentBooking.getCurrentAddress());
        ArrayList<Specifications> specificationList = new ArrayList<>();
        Utils.showCustomProgressDialog(this, false);
        for (Specifications specificationListItem : specificationsList) {
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
        cartProductItems.setQuantity(itemQuantity);
        cartProductItems.setImageUrl(productItem.getImageUrl());
        cartProductItems.setDetails(productItem.getDetails());
        cartProductItems.setSpecifications(specificationList);
        cartProductItems.setTotalSpecificationPrice(specificationPriceTotal);
        cartProductItems.setItemPrice(productItem.getPrice());
        cartProductItems.setItemNote(etAddNote.getText().toString());
        cartProductItems.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);

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
        if (isFromCartActivity()) {
            currentBooking.getCartProductWithSelectedSpecificationList().get(updateItemSectionIndex).getItems().set(updateItemIndex, cartProductItems);
            addItemInServerCart(currentBooking.getCartProductWithSelectedSpecificationList().get(updateItemSectionIndex));
        } else {
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
                cartProducts.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
                cartProducts.setTotalItemTax(cartProductItems.getTotalItemTax());
                currentBooking.setCartProduct(cartProducts);
                currentBooking.setSelectedStoreId(productItem.getStoreId());
                addItemInServerCart(cartProducts);
            }
        }
    }


    /**
     * this method check product is exist in local cart
     *
     * @param cartProductItems cartProductItems
     * @return true if product exist otherwise false
     */
    private boolean isProductExistInLocalCart(CartProductItems cartProductItems) {
        boolean isExist = false;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
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
                addItemInServerCart(cartProducts);
                return true;
            }
        }
        return false;
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
                        Utils.showMessageToast(response.body().getStatusPhrase(), ProductSpecificationActivity.this);
                        onBackPressed();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProductSpecificationActivity.this);
                        if (response.body().getErrorCode() == Const.TAXES_DETAILS_CHANGED) {
                            clearCart();
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

    private void openClearCartDialog() {
        final CustomDialogAlert dialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_other_store_item_in_cart), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                clearCart();
                dismiss();
            }
        };
        dialogAlert.show();
    }

    private void checkValidCartItem() {
        if (cartCount == 0) {
            addToCart();
        } else {
            if (TextUtils.equals(currentBooking.getSelectedStoreId(), productItem.getStoreId())) {
                addToCart();
            } else {
                openClearCartDialog();
            }
        }
    }

    private void increaseItemQuality() {
        itemQuantity++;
        setData(itemQuantity);
        modifyTotalItemAmount();
    }

    private void decreaseItemQuantity() {
        if (itemQuantity > 1) {
            itemQuantity--;
            setData(itemQuantity);
            modifyTotalItemAmount();
        }
    }

    /**
     * this method will manage total amount after change or modify
     */
    public void modifyTotalItemAmount() {
        itemPriceAndSpecificationPriceTotal = productItem.getPrice();
        int requiredCountTemp = 0;
        for (Specifications specifications : specificationsList) {
            for (SpecificationSubItem listItem : specifications.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    itemPriceAndSpecificationPriceTotal = itemPriceAndSpecificationPriceTotal + (listItem.getPrice() * listItem.getQuantity());
                }
            }

            if (specifications.isRequired() && specifications.getSelectedCount() >= specifications.getRange()
                    && (specifications.getMaxRange() == 0 || specifications.getSelectedCount() <= specifications.getMaxRange())
                    && specifications.getSelectedCount() != 0) {
                requiredCountTemp++;
            }
        }
        if (requiredCountTemp == requiredCount) {
            llAddToCart.setOnClickListener(new OnSingleClickListener() {
                @Override
                public void onSingleClick(View v) {
                    ProductSpecificationActivity.this.onClick(v);
                }
            });
            llAddToCart.setAlpha(1f);
        } else {
            llAddToCart.setOnClickListener(null);
            llAddToCart.setAlpha(0.5f);
        }

        itemPriceAndSpecificationPriceTotal = itemPriceAndSpecificationPriceTotal * itemQuantity;
        reloadAmountData(itemPriceAndSpecificationPriceTotal);
    }

    private void countIsRequiredAndDefaultSelected() {
        requiredCount = 0;
        for (Specifications specifications : specificationsList) {
            if (specifications.isRequired()) {
                requiredCount++;
            }

            specifications.setSelectedCount(0);
            for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    specifications.setSelectedCount(specifications.getSelectedCount() + 1);
                }
            }

            specifications.setChooseMessage(getChooseMessage(specifications.getRange(), specifications.getMaxRange()));
        }
    }

    private void reloadAmountData(Double itemAmount) {
        String amount = productItem.getCurrency() + parseContent.decimalTwoDigitFormat.format(itemAmount);
        tvItemAmount.setText(amount);
    }

    private void setCartItem() {
        cartCount = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
    }

    private void loadExtraData() {
        if (getIntent() != null) {
            Bundle bundle = getIntent().getExtras();
            updateItemIndex = bundle.getInt(Const.UPDATE_ITEM_INDEX);
            updateItemSectionIndex = bundle.getInt(Const.UPDATE_ITEM_INDEX_SECTION);
            productItem = bundle.getParcelable(Const.PRODUCT_ITEM);
            productDetail = bundle.getParcelable(Const.PRODUCT_DETAIL);
            store = bundle.getParcelable(Const.SELECTED_STORE);
            storeIndex = bundle.getInt(Const.STORE_INDEX);
            if (isFromCartActivity()) {
                if (productItem != null) {
                    itemQuantity = productItem.getQuantity();
                    etAddNote.setText(productItem.getInstruction());
                }
            }
            isOrderEdit = bundle.getBoolean(Const.Params.IS_ORDER_CHANGE, false);
        }
    }

    /**
     * this method called webservice for clear user cart
     */
    protected void clearCart() {
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
                        setCartItem();
                        addToCart();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProductSpecificationActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called webservice for getting specifications of item
     */
    protected void getItemSpecificationList() {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = new ApiClient().changeHeaderLang(storeIndex).create(ApiInterface.class);

        HashMap<String, Object> map = getCommonParam();
        map.put(Const.Params.ITEM_ID, productItem.getId());
        Call<SpecificationsResponse> responseCall = apiInterface.getItemSpecificationList(map);
        responseCall.enqueue(new Callback<SpecificationsResponse>() {
            @Override
            public void onResponse(@NonNull Call<SpecificationsResponse> call, @NonNull Response<SpecificationsResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        updateSpecificationSelection(response.body().getSpecifications());
                        loadProductSpecification();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), ProductSpecificationActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<SpecificationsResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
            }
        });
    }

    /**
     * this method updates selected specification into specifications got from service
     *
     * @param specifications Specifications object
     */

    private void updateSpecificationSelection(List<Specifications> specifications) {
        for (Specifications specification : specifications) {
            //For find same associated specification group
            List<SpecificationSubItem> cartSpecificationSubItemList = new ArrayList<>();
            for (Specifications cartSpecification : productItem.getSpecifications()) {
                if (specification.getUniqueId() == cartSpecification.getUniqueId()
                        && specification.isParentAssociate() == cartSpecification.isParentAssociate()
                        && specification.isAssociated() == cartSpecification.isAssociated()
                        && Objects.equals(specification.getModifierGroupId(), cartSpecification.getModifierGroupId())
                        && Objects.equals(specification.getModifierId(), cartSpecification.getModifierId())) {
                    cartSpecificationSubItemList.addAll(cartSpecification.getList());
                    break;
                }
            }

            for (SpecificationSubItem specificationSubItem : specification.getList()) {
                for (SpecificationSubItem cartSpecificationSubItem : cartSpecificationSubItemList) {
                    if (specificationSubItem.getUniqueId() == cartSpecificationSubItem.getUniqueId()) {
                        specificationSubItem.setIsDefaultSelected(cartSpecificationSubItem.isIsDefaultSelected());
                        specificationSubItem.setQuantity(cartSpecificationSubItem.getQuantity());
                    }
                }
            }
        }

        productItem.setSpecifications(specifications);
    }


    private void setupWindowAnimations() {
        getWindow().requestFeature(Window.FEATURE_CONTENT_TRANSITIONS);
        Transition transition;
        transition = TransitionInflater.from(this).inflateTransition(R.transition.slide_and_changebounds);
        getWindow().setSharedElementEnterTransition(transition);
    }

    public void openDialogItemImage(int position) {
        Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_item_image);
        llDotsDialog = dialog.findViewById(R.id.llDotsDialog);
        imageViewPagerDialog = dialog.findViewById(R.id.dialogImageViewPager);
        dialog.findViewById(R.id.ivClose).setOnClickListener(v -> dialog.dismiss());
        addBottomDotsDialog(position);
        ProductItemItemAdapter itemItemAdapter = new ProductItemItemAdapter(this, productItem.getImageUrl(), R.layout.item_image_full, false);
        imageViewPagerDialog.setAdapter(itemItemAdapter);
        imageViewPagerDialog.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                dotColorChangeDialog(position);
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        imageViewPagerDialog.setCurrentItem(position);
        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.show();
    }

    public void startAdsScheduled() {
        if (!isScheduleStart) {
            tripStatusSchedule = Executors.newSingleThreadScheduledExecutor();
            tripStatusSchedule.scheduleWithFixedDelay(new Runnable() {
                @Override
                public void run() {
                    Message message = handler.obtainMessage();
                    handler.sendMessage(message);
                }
            }, 0, Const.ADS_SCHEDULED_SECONDS, TimeUnit.SECONDS);
            isScheduleStart = true;
        }
    }

    private void initHandler() {
        handler = new Handler(Looper.myLooper()) {
            int position = 0;

            @Override
            public void handleMessage(Message msg) {
                if (imageViewPager.getChildCount() > 1) {
                    imageViewPager.setCurrentItem(position, true);
                    if (imageViewPager.getChildCount() == imageViewPager.getCurrentItem() + 1) {
                        position = 0;
                    } else {
                        position = imageViewPager.getCurrentItem() + 1;
                    }
                } else {
                    stopAdsScheduled();
                }
            }
        };
    }

    public void stopAdsScheduled() {
        if (isScheduleStart) {
            tripStatusSchedule.shutdown(); // Disable new tasks from being submitted
            // Wait a while for existing tasks to terminate
            try {
                if (!tripStatusSchedule.awaitTermination(60, TimeUnit.SECONDS)) {
                    tripStatusSchedule.shutdownNow(); // Cancel currently executing tasks
                    // Wait a while for tasks to respond to being cancelled
                    tripStatusSchedule.awaitTermination(60, TimeUnit.SECONDS);
                }
            } catch (InterruptedException e) {
                AppLog.handleException(ProductSpecificationActivity.class.getName(), e);
                // (Re-)Cancel if current thread also interrupted
                tripStatusSchedule.shutdownNow();
                // Preserve interrupt ProviderStatus
                Thread.currentThread().interrupt();
            }
            isScheduleStart = false;
        }
    }

    private boolean isFromCartActivity() {
        return updateItemIndex > -1;
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

    @SuppressLint("StringFormatInvalid")
    private String getChooseMessage(int startRange, int maxRange) {
        if (maxRange == 0 && startRange > 0) {
            return getResources().getString(R.string.text_choose, startRange);
        } else if (startRange > 0 && maxRange > 0) {
            return getResources().getString(R.string.text_choose_to, startRange, maxRange);
        } else if (startRange == 0 && maxRange > 0) {
            return getResources().getString(R.string.text_choose_up_to, maxRange);
        } else {
            return "";
        }
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (store != null && store.isTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }

    private void addToOrder() {
        double specificationPriceTotal = 0;
        double specificationPrice = 0;
        ArrayList<Specifications> specificationList = new ArrayList<>();
        for (Specifications specificationListItem : specificationsList) {
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
        cartProductItems.setQuantity(itemQuantity);
        cartProductItems.setImageUrl(productItem.getImageUrl());
        cartProductItems.setDetails(productItem.getDetails());
        cartProductItems.setSpecifications(specificationList);
        cartProductItems.setTotalSpecificationPrice(specificationPriceTotal);
        cartProductItems.setItemPrice(productItem.getPrice());
        cartProductItems.setItemNote(etAddNote.getText().toString());
        cartProductItems.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);

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

        if (isFromCartActivity()) {
            OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList().get(updateItemSectionIndex).getItems().set(updateItemIndex, cartProductItems);
        } else {
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

    private void updateUiEditOrder() {
        if (isOrderEdit) {
            tvAddToCart.setText(getString(R.string.text_update_cart));
            flCart.setVisibility(View.GONE);
        } else {
            flCart.setVisibility(View.VISIBLE);
            if (isFromCartActivity()) {
                tvAddToCart.setText(getString(R.string.text_update_cart));
            } else {
                tvAddToCart.setText(getString(R.string.text_add_to_cart));
            }
        }
    }
}