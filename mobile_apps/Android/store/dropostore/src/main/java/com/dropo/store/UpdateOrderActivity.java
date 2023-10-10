package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.OrderUpdateAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.OrderDetail;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.ItemsResponse;
import com.dropo.store.models.responsemodel.OrderDetailResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.models.singleton.UpdateOrder;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class UpdateOrderActivity extends BaseActivity {

    public String TAG = this.getClass().getSimpleName();
    public CustomAlterDialog changesWarningDialog;
    private RecyclerView rcvOrder;
    private CustomTextView tvOrderTotal;
    private LinearLayout btnCheckOut;
    private OrderUpdateAdapter orderUpdateAdapter;
    private LinearLayout ivEmpty;
    private ItemsResponse itemsResponse;
    private OrderDetail orderDetail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_order);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_update_order));

        rcvOrder = findViewById(R.id.rcvUpdateOrder);
        tvOrderTotal = findViewById(R.id.tvOrderTotal);
        btnCheckOut = findViewById(R.id.btnCheckOut);
        ivEmpty = findViewById(R.id.ivEmpty);
        btnCheckOut.setOnClickListener(this);
        initRcvOrder();
        getOrderDetail();
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    protected void onResume() {
        super.onResume();
        if (orderUpdateAdapter != null) {
            modifyTotalAmount();
            orderUpdateAdapter.notifyDataSetChanged();
        }
        updateUiOrderItemList();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(true, R.drawable.ic_add_black_24dp);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            goToStoreOrderProductActivity();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnCheckOut) {
            updateOrder();
        }
    }

    private void initRcvOrder() {
        orderUpdateAdapter = new OrderUpdateAdapter(this, UpdateOrder.getInstance().getOrderDetails());
        rcvOrder.setLayoutManager(new LinearLayoutManager(this));
        rcvOrder.setAdapter(orderUpdateAdapter);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    /**
     * this method id used to increase particular item quantity in cart
     *
     * @param item item
     */
    @SuppressLint("NotifyDataSetChanged")
    public void increaseItemQuantity(Item item) {
        int quantity = item.getQuantity();
        quantity++;
        item.setQuantity(quantity);
        item.setTotalItemAndSpecificationPrice((item.getTotalSpecificationPrice() + item.getItemPrice()) * quantity);
        item.setTotalItemTax(item.getTotalTax() * quantity);
        orderUpdateAdapter.notifyDataSetChanged();
        modifyTotalAmount();
    }

    /**
     * this method id used to decrease particular item quantity in cart
     *
     * @param item item
     */
    @SuppressLint("NotifyDataSetChanged")
    public void decreaseItemQuantity(Item item) {
        int quantity = item.getQuantity();
        if (quantity > 1) {
            quantity--;
            item.setQuantity(quantity);
            item.setTotalItemAndSpecificationPrice((item.getTotalSpecificationPrice() + item.getItemPrice()) * quantity);
            item.setTotalItemTax(item.getTotalTax() * quantity);
            orderUpdateAdapter.notifyDataSetChanged();
            modifyTotalAmount();
        }
    }

    /**
     * this method id used to remove particular item quantity in cart
     *
     * @param position         position
     * @param relativePosition relativePosition
     */
    @SuppressLint("NotifyDataSetChanged")
    public void removeItem(int position, int relativePosition) {
        UpdateOrder.getInstance().getOrderDetails().get(position).getItems().remove(relativePosition);
        if (UpdateOrder.getInstance().getOrderDetails().get(position).getItems().isEmpty()) {
            UpdateOrder.getInstance().getOrderDetails().remove(position);
        }
        updateUiOrderItemList();
        orderUpdateAdapter.notifyDataSetChanged();
        modifyTotalAmount();
    }

    /**
     * this method id used to modify or change  total cart item  amount
     */
    public void modifyTotalAmount() {
        double totalAmount = 0;
        for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
            for (Item item : orderDetails.getItems()) {
                totalAmount = totalAmount + item.getTotalItemAndSpecificationPrice();
            }
        }
        tvOrderTotal.setText(String.format("%s%s", preferenceHelper.getCurrency(), parseContent.decimalTwoDigitFormat.format(totalAmount)));
    }

    /**
     * this method called webservice for add product in cart
     */
    private void updateOrder() {
        List<TaxesDetail> taxesDetails = new ArrayList<>();
        Utilities.showCustomProgressDialog(this, false);
        UpdateOrder.getInstance().setServerToken(preferenceHelper.getServerToken());
        UpdateOrder.getInstance().setStoreId(preferenceHelper.getStoreId());
        double totalCartPrice = 0, totalCartAmountWithoutTax = 0, totalCartTaxPrice = 0;
        int totalItemCount = 0, totalSpecificationCount = 0;
        for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            for (Item cartProductItems : orderDetails.getItems()) {
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
                totalItemCount = totalItemCount + cartProductItems.getQuantity();
                for (ItemSpecification specifications : cartProductItems.getSpecifications()) {
                    totalSpecificationCount = totalSpecificationCount + specifications.getList().size();
                }
                totalItemPrice = totalItemPrice + cartProductItems.getTotalItemAndSpecificationPrice();
                totalTaxPrice = totalTaxPrice + cartProductItems.getTotalItemTax();
            }
            orderDetails.setTotalProductItemPrice(totalItemPrice);
            orderDetails.setTotalItemTax(totalTaxPrice);
            totalCartPrice = totalCartPrice + totalItemPrice;
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + totalItemPrice;
            if (preferenceHelper.getTaxIncluded()) {
                totalCartPrice = totalCartPrice - totalTaxPrice;
            }
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;
        }
        UpdateOrder.getInstance().setTaxesDetails(taxesDetails);
        UpdateOrder.getInstance().setCartOrderTotalPrice(totalCartPrice);
        UpdateOrder.getInstance().setTotalCartAmoutWithoutTax(totalCartAmountWithoutTax);
        UpdateOrder.getInstance().setCartOrderTotalTaxPrice(totalCartTaxPrice);
        UpdateOrder.getInstance().setTotalItemCount(totalItemCount);
        UpdateOrder.getInstance().setTotalSpecificationCount(totalSpecificationCount);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.updateOrder(ApiClient.makeGSONRequestBody(UpdateOrder.getInstance()));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        ParseContent.getInstance().showMessage(UpdateOrderActivity.this, response.body().getStatusPhrase());
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
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

    private void getOrderDetail() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.ORDER_ID, UpdateOrder.getInstance().getOrderId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderDetailResponse> responseCall = apiInterface.getOrderDetail(map);
        responseCall.enqueue(new Callback<OrderDetailResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderDetailResponse> call, @NonNull Response<OrderDetailResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        orderDetail = response.body().getOrderDetail();
                        UpdateOrder.getInstance().setOrderDetails(response.body().getOrderDetail().getCartDetail().getOrderDetails());
                        modifyTotalAmount();
                        getStoreProductItems();
                    } else {
                        parseContent.showErrorMessage(UpdateOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderDetailResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void getStoreProductItems() {
        Utilities.showCustomProgressDialog(this, false);
        ArrayList<String> itemIds = new ArrayList<>();
        for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
            for (Item item : orderDetails.getItems()) {
                itemIds.add(item.getItemId());
            }
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.TYPE, Constant.Type.STORE);
        map.put(Constant.ID, preferenceHelper.getStoreId());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.ITEM_ARRAY, new Gson().toJsonTree(itemIds));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ItemsResponse> call = apiInterface.getItems(map);
        call.enqueue(new Callback<ItemsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ItemsResponse> call, @NonNull Response<ItemsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        itemsResponse = response.body();
                        updateUiOrderItemList();
                        orderUpdateAdapter.notifyDataSetChanged();
                        if (isShowTaxSettingWaringDialog()) {
                            openChangesWarningDialog();
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(UpdateOrderActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ItemsResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private Item matchSelectedItem(Item item) {
        itemsResponse.getItems().addAll(UpdateOrder.getInstance().getSaveNewItem());
        for (Item responseItem : itemsResponse.getItems()) {
            if (responseItem.getUniqueId() == item.getUniqueId()) {
                item.setTax(responseItem.getTax());
                for (ItemSpecification itemResSpecification : responseItem.getSpecifications()) {
                    for (ItemSpecification specification : item.getSpecifications()) {
                        if (itemResSpecification.getUniqueId() == specification.getUniqueId()) {
                            for (ProductSpecification productResSpecification : itemResSpecification.getList()) {
                                productResSpecification.setIsDefaultSelected(false);
                                for (ProductSpecification productSpecification : specification.getList()) {
                                    if (productResSpecification.getUniqueId() == productSpecification.getUniqueId()) {
                                        productResSpecification.setIsDefaultSelected(true);
                                        productResSpecification.setQuantity(productSpecification.getQuantity());
                                    }
                                }
                            }
                        }
                    }
                }
                UpdateOrder.getInstance().clearSaveNewItem();
                return responseItem;
            }
        }
        UpdateOrder.getInstance().clearSaveNewItem();
        return null;
    }

    public void goToUpdateOrderProductSpecificationActivity(int section, int position) {
        Intent intent = new Intent(this, UpdateOrderProductSpecificationActivity.class);
        intent.putExtra(Constant.UPDATE_ITEM_INDEX, position);
        intent.putExtra(Constant.UPDATE_ITEM_INDEX_SECTION, section);
        intent.putExtra(Constant.ITEM, matchSelectedItem(UpdateOrder.getInstance().getOrderDetails().get(section).getItems().get(position)));
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToStoreOrderProductActivity() {
        Intent intent = new Intent(this, StoreOrderProductActivity.class);
        intent.putExtra(Constant.IS_ORDER_UPDATE, true);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void updateUiOrderItemList() {
        if (UpdateOrder.getInstance().getOrderDetails().isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvOrder.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvOrder.setVisibility(View.VISIBLE);
        }
    }

    private boolean isShowTaxSettingWaringDialog() {
        if (orderDetail.getTaxIncluded() == orderDetail.getCartDetail().isTaxIncluded() && orderDetail.getUseItemTax() == orderDetail.getCartDetail().isUseItemTax()) {
            if (orderDetail.getStoreTaxDetails().size() != orderDetail.getCartDetail().getStoreTaxes().size()) {
                return true;
            } else {
                for (TaxesDetail cartTax : orderDetail.getCartDetail().getStoreTaxes()) {
                    boolean isTax = false;
                    for (TaxesDetail storeTax : orderDetail.getStoreTaxDetails()) {
                        if (storeTax.getId().equals(cartTax.getId())) {
                            isTax = true;
                            if (storeTax.getTax() != cartTax.getTax()) {
                                return true;
                            }
                        }
                    }
                    if (!isTax) {
                        return true;
                    }
                }
            }
            for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
                for (Item item : orderDetails.getItems()) {
                    for (Item serverItem : itemsResponse.getItems()) {
                        if (item.getItemId().equals(serverItem.getId())) {
                            if (item.getItemPrice() != serverItem.getItemPrice()) {
                                return true;
                            } else if (serverItem.getTaxesDetails().size() != item.getTaxesDetails().size()) {
                                return true;
                            } else {
                                for (TaxesDetail cartItemTax : serverItem.getTaxesDetails()) {
                                    boolean isTax = false;
                                    for (TaxesDetail serverItemTax : item.getTaxesDetails()) {
                                        if (serverItemTax.getId().equals(cartItemTax.getId())) {
                                            isTax = true;
                                            if (serverItemTax.getTax() != cartItemTax.getTax()) {
                                                return true;
                                            }
                                        }
                                    }
                                    if (!isTax) {
                                        return true;
                                    }
                                }
                                for (ItemSpecification itemResSpecification : serverItem.getSpecifications()) {
                                    for (ItemSpecification specification : item.getSpecifications()) {
                                        if (itemResSpecification.getUniqueId() == specification.getUniqueId()) {
                                            for (ProductSpecification productResSpecification : itemResSpecification.getList()) {
                                                for (ProductSpecification productSpecification : specification.getList()) {
                                                    if (productResSpecification.getUniqueId() == productSpecification.getUniqueId()) {
                                                        if (productResSpecification.getPrice() != productSpecification.getPrice()) {
                                                            return true;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return false;
        } else {
            return true;
        }
    }

    private void openChangesWarningDialog() {
        if (changesWarningDialog != null && changesWarningDialog.isShowing()) {
            return;
        }
        changesWarningDialog = new CustomAlterDialog(this, "Warning!", "Item price or tax settings are changed. Updated figures will be applied in the following order.", true, "CONTINUE") {

            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    dismiss();
                    updateOrderPricing();
                } else {
                    dismiss();
                    UpdateOrderActivity.this.onBackPressed();
                }
            }
        };
        changesWarningDialog.setCancelable(false);
        changesWarningDialog.show();
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (orderDetail.getTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void updateOrderPricing() {
        double totalCartPrice = 0, totalCartTaxPrice = 0, totalCartAmountWithoutTax = 0;
        int totalItemCount = 0, totalSpecificationCount = 0;

        UpdateOrder.getInstance().setTaxIncluded(orderDetail.getTaxIncluded());
        UpdateOrder.getInstance().setUseItemTax(orderDetail.getUseItemTax());
        List<TaxesDetail> storeTaxDetails = orderDetail.getStoreTaxDetails();
        double storeTax = 0.0;
        for (TaxesDetail taxesDetail : storeTaxDetails) {
            storeTax = storeTax + taxesDetail.getTax();
        }
        for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            for (Item item : orderDetails.getItems()) {
                totalItemCount = totalItemCount + item.getQuantity();
                double totalSpecificationPrice = 0.0;
                for (Item serverItem : itemsResponse.getItems()) {
                    if (item.getItemId().equals(serverItem.getId())) {
                        item.setItemPrice(serverItem.getItemPrice());
                        item.setTaxesDetails(serverItem.getTaxesDetails());
                        for (ItemSpecification itemSpecification : item.getSpecifications()) {
                            totalSpecificationCount = totalSpecificationCount + itemSpecification.getList().size();
                            for (ItemSpecification serverItemSpecification : serverItem.getSpecifications()) {
                                if (itemSpecification.getUniqueId() == serverItemSpecification.getUniqueId()) {
                                    double specificationPrice = 0;
                                    for (ProductSpecification productSpecification : itemSpecification.getList()) {
                                        for (ProductSpecification serverProductSpecification : serverItemSpecification.getList()) {
                                            if (productSpecification.getUniqueId() == serverProductSpecification.getUniqueId()) {
                                                productSpecification.setPrice(serverProductSpecification.getPrice());
                                                specificationPrice = specificationPrice + serverProductSpecification.getPrice();
                                                totalSpecificationPrice = totalSpecificationPrice + serverProductSpecification.getPrice();
                                            }
                                        }
                                    }
                                    itemSpecification.setPrice(specificationPrice);
                                }
                            }
                        }
                        item.setTotalSpecificationPrice(totalSpecificationPrice);
                    }
                }

                item.setTotalPrice(item.getItemPrice() + item.getTotalSpecificationPrice());
                item.setTax(orderDetail.getUseItemTax() ? item.getTotalTaxes() : storeTax);
                item.setItemTax(getTaxableAmount(item.getItemPrice(), item.getTax()));
                item.setTotalItemAndSpecificationPrice((item.getTotalSpecificationPrice() + item.getItemPrice()) * item.getQuantity());
                item.setTotalSpecificationTax(getTaxableAmount(totalSpecificationPrice, item.getTax()));
                item.setTotalTax(item.getItemTax() + item.getTotalSpecificationTax());
                item.setTotalItemTax(item.getTotalTax() * item.getQuantity());
                totalItemPrice = totalItemPrice + item.getTotalItemAndSpecificationPrice();
                totalTaxPrice = totalTaxPrice + item.getTotalItemTax();
            }
            orderDetails.setTotalProductItemPrice(totalItemPrice);
            orderDetails.setTotalItemTax(totalTaxPrice);
            totalCartPrice = totalCartPrice + totalItemPrice;
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + totalItemPrice;
            if (preferenceHelper.getTaxIncluded()) {
                totalCartPrice = totalCartPrice - totalTaxPrice;
            }
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;
        }
        UpdateOrder.getInstance().setCartOrderTotalPrice(totalCartPrice);
        UpdateOrder.getInstance().setTotalCartAmoutWithoutTax(totalCartAmountWithoutTax);
        UpdateOrder.getInstance().setCartOrderTotalTaxPrice(totalCartTaxPrice);
        UpdateOrder.getInstance().setTotalItemCount(totalItemCount);
        UpdateOrder.getInstance().setTotalSpecificationCount(totalSpecificationCount);
        modifyTotalAmount();
        orderUpdateAdapter.notifyDataSetChanged();
    }
}