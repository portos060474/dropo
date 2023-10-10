package com.dropo.store;

import static com.dropo.store.utils.Utilities.showCustomProgressDialog;

import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.OrderInvoiceAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.datamodel.CartProductItems;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.datamodel.UnavailableItems;
import com.dropo.store.models.responsemodel.CheckAvailableItemResponse;
import com.dropo.store.models.responsemodel.InvoiceResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomFontTextViewTitle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Objects;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrderInvoiceActivity extends BaseActivity {

    public static final String TAG = "OrderInvoiceActivity";
    private final List<TaxesDetail> taxesDetails = new ArrayList<>();
    private CustomButton btnPlaceOrder;
    private CustomFontTextViewTitle tvInvoiceOderTotal;
    private RecyclerView rcvInvoice;
    private int totalItemCount = 0;
    private int totalSpecificationCount = 0;
    private double totalItemPriceWithQuantity = 0;
    private double totalSpecificationPriceWithQuantity = 0;
    private ImageView ivFreeShipping;
    private boolean isSelfDelivery;
    private OrderPaymentDetail orderPayment;
    private CustomAlterDialog unavailableCartItemsDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_invoice);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(OrderInvoiceActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_invoice));
        btnPlaceOrder = findViewById(R.id.btnPlaceOrder);
        tvInvoiceOderTotal = findViewById(R.id.tvInvoiceOderTotal);
        rcvInvoice = findViewById(R.id.rcvInvoice);
        btnPlaceOrder.setText(getResources().getString(R.string.text_place_order));
        ivFreeShipping = findViewById(R.id.ivFreeShipping);
        btnPlaceOrder.setOnClickListener(this);
        loadCheckOutData();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnPlaceOrder) {
            checkAvailableItem();
        }
    }

    private void loadCheckOutData() {
        if (getIntent().getExtras() != null) {
            isSelfDelivery = getIntent().getExtras().getBoolean(Constant.IS_USER_PICK_UP_ORDER);
        }

        for (CartProducts cartProducts : CurrentBooking.getInstance().getCartProductList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                if (preferenceHelper.getIsUseItemTax()) {
                    for (TaxesDetail taxesDetail : cartProductItems.getTaxesDetails()) {
                        if (taxesDetails.isEmpty()) {
                            taxesDetail.setTaxAmount(taxesDetail.getTax());
                            taxesDetails.add(taxesDetail);
                        } else {
                            boolean isAlreadyAdded = false;
                            for (TaxesDetail detail : taxesDetails) {
                                if (detail.getId().equals(taxesDetail.getId())) {
                                    isAlreadyAdded = true;
                                    detail.setTaxAmount(detail.getTaxAmount() + taxesDetail.getTax());
                                }
                            }
                            if (!isAlreadyAdded) {
                                taxesDetail.setTaxAmount(taxesDetail.getTax());
                                taxesDetails.add(taxesDetail);
                            }
                        }
                    }
                } else {
                    for (TaxesDetail taxesDetail : CurrentBooking.getInstance().getStoreTaxesDetails()) {
                        if (taxesDetails.isEmpty()) {
                            taxesDetail.setTaxAmount(taxesDetail.getTax());
                            taxesDetails.add(taxesDetail);
                        } else {
                            boolean isAlreadyAdded = false;
                            for (TaxesDetail detail : taxesDetails) {
                                if (detail.getId().equals(taxesDetail.getId())) {
                                    isAlreadyAdded = true;
                                    detail.setTaxAmount(detail.getTaxAmount() + taxesDetail.getTax());
                                }
                            }
                            if (!isAlreadyAdded) {
                                taxesDetail.setTaxAmount(taxesDetail.getTax());
                                taxesDetails.add(taxesDetail);
                            }
                        }
                    }
                }
                totalItemPriceWithQuantity = totalItemPriceWithQuantity + (cartProductItems.getItemPrice() * cartProductItems.getQuantity());
                totalSpecificationPriceWithQuantity = totalSpecificationPriceWithQuantity + (cartProductItems.getTotalSpecificationPrice() * cartProductItems.getQuantity());
                totalItemCount = totalItemCount + cartProductItems.getQuantity();
                for (ItemSpecification specificationsItem : cartProductItems.getSpecifications()) {
                    totalSpecificationCount = totalSpecificationCount + specificationsItem.getList().size();
                }
            }
        }

        checkIsPickUpDeliveryByUser(isSelfDelivery);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void checkIsPickUpDeliveryByUser(boolean isChecked) {
        if (CurrentBooking.getInstance().getStoreLatLng() != null && CurrentBooking.getInstance().getDeliveryLatLng() != null && !isChecked) {
            getDistanceMatrix();
        } else {
            getDeliveryInvoice(0, 0);
        }
    }

    /**
     * this method called a webservice for get distance and time witch is provided by Google
     */
    private void getDistanceMatrix() {
        showCustomProgressDialog(this, false);
        HashMap<String, String> hashMap = new HashMap<>();
        String origins = CurrentBooking.getInstance().getStoreLatLng().latitude + "," + CurrentBooking.getInstance().getStoreLatLng().longitude;
        hashMap.put(Constant.Google.ORIGINS, origins);
        String destination = CurrentBooking.getInstance().getDeliveryLatLng().latitude + "," + CurrentBooking.getInstance().getDeliveryLatLng().longitude;
        hashMap.put(Constant.Google.DESTINATIONS, destination);
        hashMap.put(Constant.Google.KEY, preferenceHelper.getGoogleKey());
        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Constant.GOOGLE_API_URL).create(ApiInterface.class);

        Call<ResponseBody> call = apiInterface.getGoogleDistanceMatrix(hashMap);
        call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                HashMap<String, String> map = parseContent.parsDistanceMatrix(response);
                if (map != null && !map.isEmpty()) {
                    String distance = map.get(Constant.Google.DISTANCE);
                    String timeSecond = map.get(Constant.Google.DURATION);
                    double tripDistance = Double.parseDouble(distance);
                    getDeliveryInvoice(Integer.parseInt(timeSecond), tripDistance);
                }
            }

            @Override
            public void onFailure(@NonNull Call<ResponseBody> call, Throwable t) {
                Utilities.handleThrowable("CHECKOUT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();

            }
        });

    }

    /**
     * this method called a webservice to get delivery invoice or bill
     */
    private void getDeliveryInvoice(int timeSeconds, double tripDistance) {
        HashMap<String, Object> map = new HashMap<>();

        if (getIntent().getExtras() != null) {
            map.put(Constant.USER_ID, getIntent().getExtras().getString(Constant.USER_ID));
        }
        map.put(Constant.IS_USER_PICK_UP_ORDER, isSelfDelivery);
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.TOTAL_ITEM_COUNT, totalItemCount);
        map.put(Constant.TOTAL_CART_PRICE, CurrentBooking.getInstance().getTotalCartAmount());
        map.put(Constant.TOTAL_ITEM_PRICE, totalItemPriceWithQuantity);
        map.put(Constant.TOTAL_SPECIFICATION_PRICE, totalSpecificationPriceWithQuantity);
        map.put(Constant.TOTAL_DISTANCE, tripDistance);
        map.put(Constant.TOTAL_TIME, timeSeconds);
        map.put(Constant.TOTAL_SPECIFICATION_COUNT, totalSpecificationCount);
        map.put(Constant.CART_UNIQUE_TOKEN, preferenceHelper.getAndroidId());
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.TOTAL_CART_AMOUNT_WITHOUT_TAX, CurrentBooking.getInstance().getTotalCartAmountWithoutTax());
        map.put(Constant.TAX_DETAILS, taxesDetails);
        map.put(Constant.IS_TAX_INCLUDED, preferenceHelper.getTaxIncluded());
        map.put(Constant.IS_USE_ITEM_TAX, preferenceHelper.getIsUseItemTax());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<InvoiceResponse> responseCall = apiInterface.getDeliveryInvoice(map);
        responseCall.enqueue(new Callback<InvoiceResponse>() {
            @Override
            public void onResponse(@NonNull Call<InvoiceResponse> call, @NonNull Response<InvoiceResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (Objects.requireNonNull(response.body()).isSuccess()) {
                        setInvoiceData(response);
                        parseContent.showMessage(OrderInvoiceActivity.this, response.body().getStatusPhrase());
                        if (response.body().getOrderPayment().isStorePayDeliveryFees()) {
                            ivFreeShipping.setVisibility(View.VISIBLE);
                        } else {
                            ivFreeShipping.setVisibility(View.GONE);
                        }
                        btnPlaceOrder.setVisibility(View.VISIBLE);

                        if (response.body().getUnavailableItems() != null && !response.body().getUnavailableItems().isEmpty()) {
                            showUnavailableCartItemsDialog(response.body().getUnavailableItems(), response.body().getUnavailableProducts());
                        }
                    } else {
                        btnPlaceOrder.setVisibility(View.GONE);
                        if (557 == response.body().getErrorCode()) {
                            String message = getResources().getString(R.string.msg_minimum_order_amount) + " " + preferenceHelper.getCurrency() + response.body().getMinOrderPrice();
                            CustomAlterDialog customDialogAlert = new CustomAlterDialog(OrderInvoiceActivity.this, getResources().getString(R.string.text_alert), message, false, getResources().getString(R.string.text_ok)) {
                                @Override
                                public void btnOnClick(int btnId) {
                                    if (R.id.btnPositive == btnId) {
                                        OrderInvoiceActivity.this.onBackPressed();
                                    }
                                    dismiss();
                                }
                            };
                            customDialogAlert.show();

                        } else {
                            parseContent.showErrorMessage(OrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<InvoiceResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * Unavailable item dialog
     */
    private void showUnavailableCartItemsDialog(List<UnavailableItems> unavailableItemsList, List<UnavailableItems> unavailableProductsList) {
        if (unavailableCartItemsDialog != null && unavailableCartItemsDialog.isShowing() && !isFinishing()) {
            return;
        }

        StringBuilder message = new StringBuilder();
        message.append(getString(R.string.text_following_items_are_not_available)).append("\n\n");
        for (int i = 0; i < unavailableItemsList.size(); i++) {
            if (unavailableItemsList.size() - 1 == i) {
                message.append(unavailableItemsList.get(i).getItemName());
            } else {
                message.append(unavailableItemsList.get(i).getItemName()).append(", ");
            }
        }

        unavailableCartItemsDialog = new CustomAlterDialog(this, getString(R.string.text_alert), message.toString(), false, getString(R.string.text_remove_and_continue)) {
            @Override
            public void btnOnClick(int btnId) {
                //removeUnavailableItemsFromCart(unavailableProductsList);
                goToHomeActivity();
            }
        };

        unavailableCartItemsDialog.show();
    }

    /**
     * remove unavailable items from cart
     */
    private void removeUnavailableItemsFromCart(List<UnavailableItems> unavailableProductsList) {
        List<String> productIds = new ArrayList<>();

        for (UnavailableItems unavailableItems : unavailableProductsList) {
            if (!productIds.contains(unavailableItems.getProductId())) {
                productIds.add(unavailableItems.getProductId());
            }
        }

        for (Iterator<CartProducts> iterator = CurrentBooking.getInstance().getCartProductList().iterator(); iterator.hasNext(); ) {
            CartProducts fruit = iterator.next();
            if (productIds.contains(fruit.getProductId())) {
                iterator.remove();
            }
        }
    }

    /**
     * Check all items are available to place order
     */
    private void checkAvailableItem() {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> hashMap = new HashMap<>();
        hashMap.put(Constant.CART_ID, preferenceHelper.getCartId());

        Call<CheckAvailableItemResponse> call = ApiClient.getClient().create(ApiInterface.class).checkAvailableItem(hashMap);
        call.enqueue(new Callback<CheckAvailableItemResponse>() {
            @Override
            public void onResponse(@NonNull Call<CheckAvailableItemResponse> call, @NonNull Response<CheckAvailableItemResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (Objects.requireNonNull(response.body()).isSuccess()) {
                    if (response.body().getUnavailableItems() != null && response.body().getUnavailableItems().isEmpty()) {
                        payOrderPayment();
                    } else {
                        showUnavailableCartItemsDialog(response.body().getUnavailableItems(), response.body().getUnavailableProducts());
                    }
                } else {
                    ParseContent.getInstance().showErrorMessage(OrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CheckAvailableItemResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(TAG, t);
            }
        });
    }

    private void setInvoiceData(Response<InvoiceResponse> response) {
        orderPayment = response.body().getOrderPayment();
        orderPayment.setTaxIncluded(response.body().isTaxIncluded());
        String currency = preferenceHelper.getCurrency();

        rcvInvoice.setLayoutManager(new LinearLayoutManager(this));
        rcvInvoice.setNestedScrollingEnabled(false);
        rcvInvoice.setAdapter(new OrderInvoiceAdapter(parseContent.parseInvoice(orderPayment, currency)));
        tvInvoiceOderTotal.setText(currency + parseContent.decimalTwoDigitFormat.format(orderPayment.getUserPayPayment()));
        CurrentBooking.getInstance().setTotalInvoiceAmount(orderPayment.getUserPayPayment());
        CurrentBooking.getInstance().setOrderPaymentId(orderPayment.getId());
    }

    /**
     * this method called a webservice fro make payment for delivery order
     */
    private void payOrderPayment() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, orderPayment.getUserId());
        map.put(Constant.IS_PAYMENT_MODE_CASH, true);
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.ORDER_PAYMENT_ID, CurrentBooking.getInstance().getOrderPaymentId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.payOrderPayment(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        createOrder();
                    } else {
                        Utilities.hideCustomProgressDialog();
                        parseContent.showErrorMessage(OrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called a webservice for create delivery order
     */
    private void createOrder() {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.USER_ID, orderPayment.getUserId());
        map.put(Constant.CART_ID, preferenceHelper.getCartId());
        map.put(Constant.ORDER_TYPE, Constant.Type.STORE);
        map.put(Constant.ORDER_PAYMENT_ID, CurrentBooking.getInstance().getOrderPaymentId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.createOrder(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(Call<IsSuccessResponse> call, Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        parseContent.showMessage(OrderInvoiceActivity.this, response.body().getStatusPhrase());
                        CurrentBooking.getInstance().clearCart();
                        preferenceHelper.putCartId("");
                        preferenceHelper.putAndroidId(Utilities.generateRandomString());
                        goToHomeActivity();
                    } else {
                        parseContent.showErrorMessage(OrderInvoiceActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }

            }

            @Override
            public void onFailure(Call<IsSuccessResponse> call, Throwable t) {
                Utilities.handleThrowable("PAYMENT_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}
