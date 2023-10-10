package com.dropo;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.InvoiceAdapter;
import com.dropo.adapter.ProductSpecificationCourierItemAdapter;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.interfaces.OnSingleClickListener;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.OrderPayment;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.InvoiceResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CourierOrderInvoiceActivity extends BaseAppCompatActivity {

    private CustomFontButton btnPlaceOrder, btnShowInvoice;
    private CustomFontTextViewTitle tvInvoiceOderTotal;
    private CustomFontTextView tvMinFare;
    private RecyclerView rcvInvoice, rcvSpecificationItem;
    private LinearLayout llInvoice, llInvoiceTotal;
    private NestedScrollView nsvCourierData;
    private View divProductSpecification;

    private final ArrayList<Specifications> specificationsList = new ArrayList<>();
    private final List<Specifications> mainSpecificationList = new ArrayList<>();
    private ProductSpecificationCourierItemAdapter productSpecificationItemAdapter;

    private double itemPriceAndSpecificationPriceTotal;
    private int requiredCount;
    private ProductItem productItem;

    private String vehicleId;
    private ArrayList<Addresses> courierAddressList;
    private long totalTimeInSeconds;
    private double totalDistance;
    private boolean isRoundTrip;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_courier_order_invoice);
        initToolBar();
        setTitleOnToolBar(getString(R.string.text_courier_order_invoice));
        initViewById();
        setViewListener();
        loadExtraData();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        btnPlaceOrder = findViewById(R.id.btnPlaceOrder);
        btnShowInvoice = findViewById(R.id.btnShowInvoice);
        tvInvoiceOderTotal = findViewById(R.id.tvInvoiceOderTotal);
        rcvInvoice = findViewById(R.id.rcvInvoice);
        rcvSpecificationItem = findViewById(R.id.rcvSpecificationItem);
        llInvoiceTotal = findViewById(R.id.llInvoiceTotal);
        llInvoice = findViewById(R.id.llInvoice);
        tvMinFare = findViewById(R.id.tvMinFare);
        nsvCourierData = findViewById(R.id.nsvCourierData);
        divProductSpecification = findViewById(R.id.divProductSpecification);

        btnShowInvoice.setVisibility(View.GONE);
    }

    @Override
    protected void setViewListener() {
        btnPlaceOrder.setOnClickListener(this);
        btnShowInvoice.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnPlaceOrder) {
            goToPaymentActivity();
        } else if (id == R.id.btnShowInvoice) {
            addCourierItemInServerCart(vehicleId, isRoundTrip);
        }
    }

    private void loadExtraData() {
        if (getIntent().getExtras() != null) {
            vehicleId = getIntent().getExtras().getString(Const.Params.VEHICLE_ID, "");
            courierAddressList = getIntent().getExtras().getParcelableArrayList(Const.Params.ADDRESS);
            totalTimeInSeconds = getIntent().getExtras().getLong(Const.Params.TOTAL_TIME, 0);
            totalDistance = getIntent().getExtras().getDouble(Const.Params.TOTAL_DISTANCE, 0);
            isRoundTrip = getIntent().getExtras().getBoolean(Const.Params.IS_ROUND_TRIP, false);
            getCourierInvoice(totalTimeInSeconds, totalDistance, vehicleId, isRoundTrip, courierAddressList.size() - 2);
        }
    }

    private void intiRVSpecificationItem() {
        productSpecificationItemAdapter = new ProductSpecificationCourierItemAdapter(this, specificationsList);
        rcvSpecificationItem.setLayoutManager(new LinearLayoutManager(this));
        rcvSpecificationItem.setNestedScrollingEnabled(false);
        rcvSpecificationItem.setAdapter(productSpecificationItemAdapter);
    }

    /**
     * this method manag single type specification click event
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

        itemPriceAndSpecificationPriceTotal = itemPriceAndSpecificationPriceTotal * 1;

        mangeInvoiceAccordingToSelection(false);

        if (requiredCountTemp == requiredCount) {
            btnPlaceOrder.setOnClickListener(new OnSingleClickListener() {
                @Override
                public void onSingleClick(View v) {
                    CourierOrderInvoiceActivity.this.onClick(v);
                }
            });
            btnPlaceOrder.setAlpha(1f);
            btnShowInvoice.setOnClickListener(new OnSingleClickListener() {
                @Override
                public void onSingleClick(View v) {
                    CourierOrderInvoiceActivity.this.onClick(v);
                }
            });
            btnShowInvoice.setAlpha(1f);
        } else {
            btnPlaceOrder.setOnClickListener(null);
            btnPlaceOrder.setAlpha(0.5f);
            btnShowInvoice.setOnClickListener(null);
            btnShowInvoice.setAlpha(0.5f);
        }
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

    /**
     * this method updates selected specification into specifications got from service
     *
     * @param specifications Specifications object
     */
    private void updateSpecificationSelection(List<Specifications> specifications) {
        if (productItem != null) {
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

            specificationsList.addAll(productItem.getSpecifications());
            mainSpecificationList.addAll(productItem.getSpecifications());
            arrangeDataWithAssociateSpecification();
            modifyTotalItemAmount();
        }
    }

    private void mangeInvoiceAccordingToSelection(boolean isShowInvoice) {
        if (isShowInvoice) {
            llInvoiceTotal.setVisibility(View.VISIBLE);
            llInvoice.setVisibility(View.VISIBLE);
            btnPlaceOrder.setVisibility(View.VISIBLE);
            btnShowInvoice.setVisibility(View.GONE);
        } else {
            llInvoiceTotal.setVisibility(View.GONE);
            llInvoice.setVisibility(View.GONE);
            tvMinFare.setVisibility(View.GONE);
            btnPlaceOrder.setVisibility(View.GONE);
            btnShowInvoice.setVisibility(View.VISIBLE);
        }
    }

    private void setInvoiceData(InvoiceResponse invoiceResponse) {
        OrderPayment orderPayment = invoiceResponse.getOrderPayment();
        orderPayment.setTaxIncluded(invoiceResponse.isTaxIncluded());
        String currency = currentBooking.getCurrency();
        rcvInvoice.setLayoutManager(new LinearLayoutManager(this));
        rcvInvoice.setNestedScrollingEnabled(false);
        rcvInvoice.setAdapter(new InvoiceAdapter(parseContent.parseInvoice(orderPayment, currency, false)));
        CurrentBooking.getInstance().setTotalInvoiceAmount(orderPayment.getTotal());
        tvInvoiceOderTotal.setText(String.format("%s%s", currency, parseContent.decimalTwoDigitFormat.format(currentBooking.getTotalInvoiceAmount())));
        tvMinFare.setVisibility(orderPayment.isMinFareApplied() ? View.VISIBLE : View.GONE);
    }

    /**
     * this method called webservice for add product in cart
     */
    private void addCourierItemInServerCart(String vehicleId, boolean isRoundTrip) {
        Utils.showCustomProgressDialog(this, false);

        double specificationPriceTotal = 0;
        double specificationPrice = 0;
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
        cartProductItems.setTotalPrice(cartProductItems.getItemPrice() + cartProductItems.getTotalSpecificationPrice());

        CartOrder cartOrder = new CartOrder();
        cartOrder.setCityId(currentBooking.getBookCityId());
        cartOrder.setCountryId(currentBooking.getBookCountryId());
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(currentBooking.getTaxesDetails());
        cartOrder.setDeliveryType(Const.DeliveryType.COURIER);
        cartOrder.setUserType(Const.Type.USER);
        cartOrder.setStoreId("");

        ArrayList<CartProductItems> cartProductItemsList = new ArrayList<>();
        cartProductItemsList.add(cartProductItems);
        CartProducts cartProducts = new CartProducts();
        cartProducts.setItems(cartProductItemsList);
        cartProducts.setProductId(productItem.getProductId());
        cartProducts.setProductName(productItem.getName());
        cartProducts.setUniqueId(productItem.getUniqueId());
        cartProducts.setTotalItemTax(cartProductItems.getTotalItemTax());
        ArrayList<CartProducts> cartProductsList = new ArrayList<>();
        cartProductsList.add(cartProducts);
        cartOrder.setProducts(cartProductsList);
        cartProductItems.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);

        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setServerToken(preferenceHelper.getSessionToken());

        if (courierAddressList != null && courierAddressList.size() >= 2) {
            //pickup address
            Addresses pickupAddresses = new Addresses();
            pickupAddresses.setAddress(courierAddressList.get(0).getAddress());
            pickupAddresses.setCity("");
            pickupAddresses.setAddressType(Const.Type.PICKUP);
            pickupAddresses.setNote(courierAddressList.get(0).getNote());
            pickupAddresses.setUserType(Const.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(courierAddressList.get(0).getLocation().get(0));
            location.add(courierAddressList.get(0).getLocation().get(1));
            pickupAddresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(preferenceHelper.getEmail());
            cartUserDetail.setCountryPhoneCode(courierAddressList.get(0).getUserDetails().getCountryPhoneCode());
            cartUserDetail.setName(courierAddressList.get(0).getUserDetails().getName());
            cartUserDetail.setImageUrl(preferenceHelper.getProfilePic());
            cartUserDetail.setPhone(courierAddressList.get(0).getUserDetails().getPhone());
            pickupAddresses.setUserDetails(cartUserDetail);

            final ArrayList<Addresses> pickupsAddressList = new ArrayList<>();
            pickupsAddressList.add(pickupAddresses);

            // destination address
            final ArrayList<Addresses> destinationsAddressList = new ArrayList<>();
            for (int i = 1; i < courierAddressList.size(); i++) {
                Addresses destAddresses = new Addresses();
                destAddresses.setAddress(courierAddressList.get(i).getAddress());
                destAddresses.setCity("");
                destAddresses.setAddressType(Const.Type.DESTINATION);
                destAddresses.setNote(courierAddressList.get(i).getNote());
                destAddresses.setUserType(Const.Type.USER);
                ArrayList<Double> location1 = new ArrayList<>();
                location1.add(courierAddressList.get(i).getLocation().get(0));
                location1.add(courierAddressList.get(i).getLocation().get(1));
                destAddresses.setLocation(location1);
                CartUserDetail cartUserDetail1 = new CartUserDetail();
                cartUserDetail1.setEmail("");
                cartUserDetail1.setCountryPhoneCode(courierAddressList.get(i).getUserDetails().getCountryPhoneCode());
                cartUserDetail1.setName(courierAddressList.get(i).getUserDetails().getName());
                cartUserDetail1.setPhone(courierAddressList.get(i).getUserDetails().getPhone());
                destAddresses.setUserDetails(cartUserDetail1);

                destinationsAddressList.add(destAddresses);
            }

            cartOrder.setPickupAddresses(pickupsAddressList);
            cartOrder.setDestinationAddresses(destinationsAddressList);
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
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            currentBooking.setCartId(response.body().getCartId());
                            currentBooking.setCartCityId(response.body().getCityId());
                            currentBooking.setDeliveryType(Const.DeliveryType.COURIER);
                            getCourierInvoice(totalTimeInSeconds, totalDistance, vehicleId, isRoundTrip, courierAddressList.size() - 2);
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CourierOrderInvoiceActivity.this);
                        }
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

    private void getCourierInvoice(long totalTimeInSeconds, double totalDistance, String vehicleId, boolean isRoundTrip, int noOfStop) {
        HashMap<String, Object> map = new HashMap<>();
        if (isCurrentLogin()) {
            map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        } else {
            map.put(Const.Params.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        }
        map.put(Const.Params.TOTAL_DISTANCE, totalDistance);
        map.put(Const.Params.TOTAL_TIME, totalTimeInSeconds);
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.CITY_ID, currentBooking.getBookCityId());
        map.put(Const.Params.COUNTRY_ID, currentBooking.getBookCountryId());
        map.put(Const.Params.CART_ID, currentBooking.getCartId());
        map.put(Const.Params.VEHICLE_ID, vehicleId);
        map.put(Const.Params.IS_ROUND_TRIP, isRoundTrip);
        map.put(Const.Params.NO_OF_STOP, noOfStop);
        map.put(Const.Params.TOTAL_CART_PRICE, itemPriceAndSpecificationPriceTotal);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> responseCall = apiInterface.getCourierOrderInvoice(map);
        responseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull final Response<InvoiceResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            setInvoiceData(response.body());
                            if (specificationsList.isEmpty()) {
                                if (response.body().getProductItem() != null) {
                                    productItem = response.body().getProductItem();
                                    if (response.body().getProductItem().getSpecifications() != null
                                            && !response.body().getProductItem().getSpecifications().isEmpty()) {
                                        updateSpecificationSelection(response.body().getProductItem().getSpecifications());
                                    }
                                }

                                intiRVSpecificationItem();
                            }

                            checkRequiredSpecificationCount();
                            divProductSpecification.setVisibility(specificationsList.isEmpty() ? View.GONE : View.VISIBLE);
                            nsvCourierData.post(() -> nsvCourierData.fullScroll(View.FOCUS_DOWN));
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CourierOrderInvoiceActivity.this);
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(Const.Tag.CHECKOUT_ACTIVITY, t);
            }
        });
    }

    private void checkRequiredSpecificationCount() {
        int requiredCountTemp = 0;
        for (Specifications specifications : specificationsList) {
            if (specifications.isRequired() && specifications.getSelectedCount() >= specifications.getRange()
                    && (specifications.getMaxRange() == 0 || specifications.getSelectedCount() <= specifications.getMaxRange())
                    && specifications.getSelectedCount() != 0) {
                requiredCountTemp++;
            }
        }

        mangeInvoiceAccordingToSelection(requiredCountTemp == requiredCount);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void goToPaymentActivity() {
        final Intent homeIntent = new Intent(this, PaymentActivity.class);
        homeIntent.putExtra(Const.Tag.PAYMENT_ACTIVITY, true);
        homeIntent.putExtra(Const.Params.DELIVERY_TYPE, Const.DeliveryType.COURIER);
        startActivity(homeIntent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }
}