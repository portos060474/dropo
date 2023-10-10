package com.dropo.fragments;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.CartActivity;
import com.dropo.OrderDetailActivity;
import com.dropo.ProductSpecificationActivity;
import com.dropo.user.R;
import com.dropo.StoreProductActivity;
import com.dropo.adapter.CourierItemAdapter;
import com.dropo.adapter.CourierItemDetailAdapter;
import com.dropo.adapter.OrderDetailsAdapter;
import com.dropo.adapter.OrderProductAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.Order;
import com.dropo.models.datamodels.Product;
import com.dropo.models.datamodels.ProductDetail;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.TaxesDetail;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OrderHistoryDetailResponse;
import com.dropo.models.responsemodels.OrderResponse;
import com.dropo.models.responsemodels.StoreProductResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.models.singleton.OrderEdit;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PinnedHeaderItemDecoration;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.List;
import java.util.Objects;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrderPreparedFragment extends BottomSheetDialogFragment implements View.OnClickListener {

    public CustomDialogAlert changesWarningDialog;
    private RecyclerView rcvOrderProductItem, rcvOrderCourierItems;
    private boolean isOrderChange;
    private OrderDetailActivity orderDetailActivity;
    private ImageView btnCancel;
    private RecyclerView rcvCart;
    private OrderProductAdapter orderProductAdapter;
    private Button btnReorder, btnApproveEditOrder;
    private LinearLayout btnConfirmDetail;
    private TextView btnAddItem;
    private TextView tvCartTotal, tvReceivedBy;
    private LinearLayout llReceivedBy, llDotsDialog;
    private View view;
    private ViewPager imageViewPagerDialog;

    public OrderPreparedFragment() {
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        orderDetailActivity = (OrderDetailActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.activity_order_prepared, container, false);
        return view;
    }

    @Override
    public void onDestroyView() {
        view = null;
        super.onDestroyView();
    }

    @Override
    public void onViewCreated(@NonNull @NotNull View view, @Nullable @org.jetbrains.annotations.Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        rcvOrderProductItem = view.findViewById(R.id.rcvOrderProductItem);
        rcvOrderCourierItems = view.findViewById(R.id.rcvOrderCourierItems);
        btnConfirmDetail = view.findViewById(R.id.btnConfirmDetail);
        btnCancel = view.findViewById(R.id.btnCancel);
        btnAddItem = view.findViewById(R.id.btnAddItem);
        rcvCart = view.findViewById(R.id.rcvCart);
        tvCartTotal = view.findViewById(R.id.tvCartTotal);
        btnReorder = view.findViewById(R.id.btnReorder);
        btnApproveEditOrder = view.findViewById(R.id.btnApproveEditOrder);
        llReceivedBy = view.findViewById(R.id.llReceivedBy);
        tvReceivedBy = view.findViewById(R.id.tvReceivedBy);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        btnConfirmDetail.setOnClickListener(this);
        btnCancel.setOnClickListener(this);
        btnApproveEditOrder.setOnClickListener(this);
        btnReorder.setOnClickListener(this);
        btnAddItem.setOnClickListener(this);
        getExtraData();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnConfirmDetail) {
            updateOrder();
        } else if (id == R.id.btnApproveEditOrder) {
            approveEditOrder(orderDetailActivity.orderDetail);
        } else if (id == R.id.btnCancel) {
            dismiss();
        } else if (id == R.id.btnReorder) {
            if (orderDetailActivity.currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
                addItemInServerCart();
            } else {
                openClearCartDialog();
            }
        } else if (id == R.id.btnAddItem) {
            if (rcvOrderProductItem.getVisibility() == View.VISIBLE) {
                if (isShowTaxSettingWaringDialog()) {
                    openChangesWarningDialog();
                } else {
                    rcvCart.setVisibility(View.VISIBLE);
                    rcvOrderProductItem.setVisibility(View.GONE);
                    btnApproveEditOrder.setVisibility(View.GONE);
                    btnConfirmDetail.setVisibility(View.VISIBLE);
                    btnAddItem.setText(R.string.text_add_item);
                }
            } else {
                goToStoreProductActivity(OrderEdit.getInstance().getStore());
            }
        }
    }

    private void getExtraData() {
        if (orderDetailActivity.isShowHistory) {
            isOrderChange = false;
            setOrderData(null, orderDetailActivity.historyDetailResponse);
        } else {
            isOrderChange = orderDetailActivity.activeOrderResponse.isOrderChange();
            getOrderDetail(orderDetailActivity.order);
        }

    }

    private void setOrderData(Order order, OrderHistoryDetailResponse detailResponse) {
        if (detailResponse == null ? order.getDeliveryType() == Const.DeliveryType.COURIER : detailResponse.getOrderDetail().getDeliveryType() == Const.DeliveryType.COURIER) {
            GridLayoutManager gridLayoutManager = new GridLayoutManager(orderDetailActivity, 3);
            rcvOrderProductItem.setLayoutManager(gridLayoutManager);

            if (order != null && order.getCourierItemsImages() != null) {
                rcvOrderProductItem.setAdapter(new CourierItemDetailAdapter(OrderPreparedFragment.this, order.getCourierItemsImages()));
            } else if (detailResponse != null && detailResponse.getOrderDetail().getCourierItemsImages() != null) {
                rcvOrderProductItem.setAdapter(new CourierItemDetailAdapter(OrderPreparedFragment.this, detailResponse.getOrderDetail().getCourierItemsImages()));
            }

            rcvOrderCourierItems.setVisibility(View.VISIBLE);
            LinearLayoutManager layoutManager = new LinearLayoutManager(orderDetailActivity);
            rcvOrderCourierItems.setLayoutManager(layoutManager);
            OrderDetailsAdapter orderDetailsAdapter = new OrderDetailsAdapter(orderDetailActivity, detailResponse == null ? order.getOrderData().getOrderDetails() : detailResponse.getCartDetail().getOrderDetails(), detailResponse == null ? orderDetailActivity.activeOrderResponse.getCurrency() : detailResponse.getCurrency());
            rcvOrderCourierItems.setAdapter(orderDetailsAdapter);
            orderDetailsAdapter.setDeliveryType(Const.DeliveryType.COURIER);
            rcvOrderCourierItems.addItemDecoration(new PinnedHeaderItemDecoration());
        } else {
            rcvOrderCourierItems.setVisibility(View.GONE);
            LinearLayoutManager layoutManager = new LinearLayoutManager(orderDetailActivity);
            rcvOrderProductItem.setLayoutManager(layoutManager);
            OrderDetailsAdapter orderDetailsAdapter = new OrderDetailsAdapter(orderDetailActivity, detailResponse == null ? order.getOrderData().getOrderDetails() : detailResponse.getCartDetail().getOrderDetails(), detailResponse == null ? orderDetailActivity.activeOrderResponse.getCurrency() : detailResponse.getCurrency());
            rcvOrderProductItem.setAdapter(orderDetailsAdapter);
            rcvOrderProductItem.addItemDecoration(new PinnedHeaderItemDecoration());
        }
        if (isOrderChange && !orderDetailActivity.isShowHistory) {
            OrderEdit.getInstance().setOrderId(order.getId());
            OrderEdit.getInstance().setOrderEditedProductWithSelectedSpecificationList(order.getOrderData().getOrderDetails());
            OrderEdit.getInstance().setOrderCurrency(order.getCountries().getCurrencySign());
            OrderEdit.getInstance().setStore(order.getStore());
            OrderEdit.getInstance().setOrderDetail(order.getOrderData());
            getStoreProductList(OrderEdit.getInstance().getStore().getId(), null);
            btnAddItem.setVisibility(View.VISIBLE);
            btnConfirmDetail.setVisibility(View.GONE);
            rcvCart.setVisibility(View.GONE);
            rcvOrderProductItem.setVisibility(View.VISIBLE);
            btnApproveEditOrder.setVisibility(View.VISIBLE);
        } else {
            btnAddItem.setVisibility(View.GONE);
            rcvCart.setVisibility(View.GONE);
            btnConfirmDetail.setVisibility(View.GONE);
            btnApproveEditOrder.setVisibility(View.GONE);
            rcvOrderProductItem.setVisibility(View.VISIBLE);
        }
        if (orderDetailActivity.isShowHistory) {
            llReceivedBy.setVisibility(View.VISIBLE);
            btnReorder.setVisibility(View.VISIBLE);
            if (detailResponse != null && detailResponse.getOrderDetail().getDeliveryType() != Const.DeliveryType.COURIER) {
                btnReorder.setVisibility(View.VISIBLE);
            }
            if (detailResponse != null) {
                tvReceivedBy.setText(detailResponse.getStore().getName());
            }
        } else {
            btnReorder.setVisibility(View.GONE);
            llReceivedBy.setVisibility(View.GONE);
        }
    }

    private void getOrderDetail(final Order order) {
        if (orderDetailActivity.orderDetail == null) {
            Utils.showCustomProgressDialog(orderDetailActivity, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
            map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
            map.put(Const.Params.ORDER_ID, order.getId());
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<OrderResponse> call = apiInterface.getOrderDetail(map);
            call.enqueue(new Callback<OrderResponse>() {
                @Override
                public void onResponse(Call<OrderResponse> call, Response<OrderResponse> response) {
                    Utils.hideCustomProgressDialog();
                    if (orderDetailActivity.parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            orderDetailActivity.orderDetail = response.body().getOrder();
                            setOrderData(orderDetailActivity.orderDetail, null);
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                        }
                    }
                }

                @Override
                public void onFailure(Call<OrderResponse> call, Throwable t) {
                    AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        } else {
            setOrderData(orderDetailActivity.orderDetail, null);
        }
    }

    private void approveEditOrder(final Order order) {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.ORDER_ID, order.getId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> call = apiInterface.approveEditOrder(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(Call<IsSuccessResponse> call, Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), orderDetailActivity);
                        dismiss();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(Call<IsSuccessResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call a webservice for get particular store product list according to store
     *
     * @param storeId store in string
     */
    private void getStoreProductList(String storeId, List<String> productIds) {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        if (productIds != null) {
            map.put(Const.Params.PRODUCT_IDS, productIds);
        }
        map.put(Const.Params.STORE_ID, storeId);
        map.put(Const.Params.SERVER_TOKEN, orderDetailActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, orderDetailActivity.preferenceHelper.getUserId());
        map.put(Const.Params.CART_UNIQUE_TOKEN, orderDetailActivity.preferenceHelper.getAndroidId());
        ApiInterface apiInterface = new ApiClient().changeHeaderLang(orderDetailActivity.getLangIndxex(orderDetailActivity.preferenceHelper.getLanguageCode(), OrderEdit.getInstance().getStore().getLang(), true)).create(ApiInterface.class);
        Call<StoreProductResponse> responseCall = apiInterface.getStoreProductList(map);
        responseCall.enqueue(new Callback<StoreProductResponse>() {
            @Override
            public void onResponse(Call<StoreProductResponse> call, Response<StoreProductResponse> response) {
                Utils.hideCustomProgressDialog();
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        OrderEdit.getInstance().getStore().setCurrency(response.body().getCurrency());
                        OrderEdit.getInstance().getOrderEditedProductItemWithAllSpecificationList().clear();
                        if (response.body().getProducts() != null) {
                            List<Product> products = response.body().getProducts();
                            for (Product product : products) {
                                for (CartProducts cartProducts : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
                                    if (TextUtils.equals(product.getProductDetail().getId(), cartProducts.getProductId())) {
                                        List<ProductItem> productItem = product.getItems();
                                        List<CartProductItems> cartProductItems = cartProducts.getItems();
                                        for (ProductItem item : productItem) {
                                            for (CartProductItems cartProductItem : cartProductItems) {
                                                if (TextUtils.equals(item.getId(), cartProductItem.getItemId())) {
                                                    item.setCurrency(OrderEdit.getInstance().getStore().getCurrency());
                                                    OrderEdit.getInstance().setOrderEditedProductItemWithAllSpecificationList(item);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        initRcvOrder();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(Call<StoreProductResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_PRODUCT_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void goToProductSpecificationActivity(int section, int position, CartProductItems cartProductItems, ProductDetail productDetail) {
        Intent intent = new Intent(orderDetailActivity, ProductSpecificationActivity.class);
        intent.putExtra(Const.Params.IS_ORDER_CHANGE, true);
        intent.putExtra(Const.UPDATE_ITEM_INDEX, position);
        intent.putExtra(Const.UPDATE_ITEM_INDEX_SECTION, section);
        intent.putExtra(Const.PRODUCT_DETAIL, productDetail);
        intent.putExtra(Const.PRODUCT_ITEM, matchSelectedOrderProductItemToProductItem(cartProductItems));
        intent.putExtra(Const.STORE_INDEX, orderDetailActivity.getLangIndxex(orderDetailActivity.preferenceHelper.getLanguageCode(), OrderEdit.getInstance().getStore().getLang(), true));
        startActivity(intent);
        orderDetailActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method id used to increase particular item quantity in cart
     *
     * @param cartProductItems
     */
    public void increaseItemQuantity(CartProductItems cartProductItems) {
        int quantity = cartProductItems.getQuantity();
        quantity++;
        cartProductItems.setQuantity(quantity);
        cartProductItems.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
        cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
        orderProductAdapter.notifyDataSetChanged();
        modifyTotalAmount();
    }

    /**
     * this method id used to decrease particular item quantity in cart
     *
     * @param cartProductItems
     */
    public void decreaseItemQuantity(CartProductItems cartProductItems) {
        int quantity = cartProductItems.getQuantity();
        if (quantity > 1) {
            quantity--;
            cartProductItems.setQuantity(quantity);
            cartProductItems.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
            cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
            orderProductAdapter.notifyDataSetChanged();
            modifyTotalAmount();
        }
    }

    /**
     * this method id used to remove particular item quantity in cart
     *
     * @param position
     * @param relativePosition
     */
    public void removeItem(int position, int relativePosition) {
        if (getOrderItemCount() <= 1) {
            Utils.showToast(getString(R.string.msg_can_not_remove_all_item_order), orderDetailActivity);
        } else {
            OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList().get(position).getItems().remove(relativePosition);
            if (OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList().get(position).getItems().isEmpty()) {
                OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList().remove(position);
            }
            orderProductAdapter.notifyDataSetChanged();
            modifyTotalAmount();
        }
    }

    private int getOrderItemCount() {
        int cartCount = 0;
        for (CartProducts cartProducts : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        return cartCount;
    }

    private ProductItem matchSelectedOrderProductItemToProductItem(CartProductItems cartProductItems) {
        for (ProductItem saveProductItem : OrderEdit.getInstance().getOrderEditedProductItemWithAllSpecificationList()) {
            if (saveProductItem.getUniqueId() == cartProductItems.getUniqueId()) {
                saveProductItem.setTax(cartProductItems.getTax());
                saveProductItem.setInstruction(cartProductItems.getItemNote());
                saveProductItem.setQuantity(cartProductItems.getQuantity());
                for (Specifications saveSpecification : saveProductItem.getSpecifications()) {
                    for (SpecificationSubItem saveSubSpecification : saveSpecification.getList()) {
                        saveSubSpecification.setIsDefaultSelected(false);
                    }

                    for (Specifications specification : cartProductItems.getSpecifications()) {
                        if (saveSpecification.getUniqueId() == specification.getUniqueId()) {
                            for (SpecificationSubItem saveSubSpecification : saveSpecification.getList()) {
                                for (SpecificationSubItem specificationSubItem : specification.getList()) {
                                    if (saveSubSpecification.getUniqueId() == specificationSubItem.getUniqueId()) {
                                        saveSubSpecification.setIsDefaultSelected(true);
                                        saveSubSpecification.setQuantity(specificationSubItem.getQuantity());
                                    }
                                }
                            }
                        }
                    }
                }
                return saveProductItem;
            }
        }
        return null;
    }

    public void modifyTotalAmount() {
        double totalAmount = 0;
        for (CartProducts cartProducts : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                totalAmount = totalAmount + cartProductItems.getTotalItemAndSpecificationPrice();
            }
        }
        OrderEdit.getInstance().setTotalOrderAmount(totalAmount);
        tvCartTotal.setText(String.format("%s%s", OrderEdit.getInstance().getOrderCurrency(), orderDetailActivity.parseContent.decimalTwoDigitFormat.format(totalAmount)));
    }


    private void updateOrder() {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        if (orderDetailActivity.isCurrentLogin()) {
            cartOrder.setUserId(orderDetailActivity.preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(orderDetailActivity.preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setOrderId(OrderEdit.getInstance().getOrderId());
        cartOrder.setServerToken(orderDetailActivity.preferenceHelper.getSessionToken());
        cartOrder.setStoreId(OrderEdit.getInstance().getStore().getId());
        cartOrder.setProducts(OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList());
        cartOrder.setDestinationAddresses(OrderEdit.getInstance().getOrderDetail().getDestinationAddresses());
        cartOrder.setPickupAddresses(OrderEdit.getInstance().getOrderDetail().getPickupAddresses());
        cartOrder.setUseItemTax(orderDetailActivity.orderDetail.getStore().isUseItemTax());
        cartOrder.setTaxIncluded(orderDetailActivity.orderDetail.getStore().isTaxIncluded());
        cartOrder.setTaxesDetails(orderDetailActivity.orderDetail.getStore().getStoreTaxDetails());
        double totalCartPrice = 0, totalCartAmountWithoutTax = 0, totalCartTaxPrice = 0;
        long totalItemCount = 0;
        for (CartProducts products : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            totalItemCount = totalItemCount + products.getItems().size();
            for (CartProductItems cartProductItems : products.getItems()) {
                totalTaxPrice = totalTaxPrice + cartProductItems.getTotalItemTax();
                totalItemPrice = totalItemPrice + cartProductItems.getTotalItemAndSpecificationPrice();
            }
            products.setTotalItemTax(totalTaxPrice);
            products.setTotalProductItemPrice(totalItemPrice);
            totalCartPrice = totalCartPrice + totalItemPrice;
            if (orderDetailActivity.orderDetail.getStore().isTaxIncluded()) {
                totalCartPrice = totalCartPrice - totalTaxPrice;
            }
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + totalItemPrice;
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;

        }
        cartOrder.setCartOrderTotalPrice(totalCartPrice);
        cartOrder.setCartOrderTotalTaxPrice(totalCartTaxPrice);
        cartOrder.setTotalItemCount(totalItemCount);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.updateOrder(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(Call<IsSuccessResponse> call, Response<IsSuccessResponse> response) {
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        dismiss();
                        orderDetailActivity.getOrderStatus(orderDetailActivity.orderDetail.getId());
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(Call<IsSuccessResponse> call, Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvOrder() {
        orderProductAdapter = new OrderProductAdapter(this, OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList());
        rcvCart.setLayoutManager(new LinearLayoutManager(orderDetailActivity));
        rcvCart.setAdapter(orderProductAdapter);
        modifyTotalAmount();
    }

    private void goToStoreProductActivity(Store store) {
        Intent intent = new Intent(orderDetailActivity, StoreProductActivity.class);
        intent.putExtra(Const.SELECTED_STORE, store);
        intent.putExtra(Const.Params.IS_ORDER_CHANGE, true);
        intent.putExtra(Const.IS_STORE_CAN_CREATE_GROUP, CurrentBooking.getInstance().isStoreCanCreateGroup());
        intent.putExtra(Const.STORE_INDEX, orderDetailActivity.getLangIndxex(orderDetailActivity.preferenceHelper.getLanguageCode(), store.getLang(), true));
        intent.putExtra(Const.FILTER, (String) null);
        startActivity(intent);
        orderDetailActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method called a webservice for add item in cart
     */
    private void addItemInServerCart() {
        Utils.showCustomProgressDialog(orderDetailActivity, false);

        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        if (orderDetailActivity.isCurrentLogin()) {
            cartOrder.setUserId(orderDetailActivity.preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(orderDetailActivity.preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setUseItemTax(orderDetailActivity.historyDetailResponse.getStore().isUseItemTax());
        cartOrder.setTaxIncluded(orderDetailActivity.historyDetailResponse.getStore().isTaxIncluded());
        cartOrder.setTaxesDetails(orderDetailActivity.historyDetailResponse.getStore().getStoreTaxDetails());
        cartOrder.setServerToken(orderDetailActivity.preferenceHelper.getSessionToken());
        cartOrder.setStoreId(orderDetailActivity.historyDetailResponse.getOrderDetail().getStoreId());
        cartOrder.setProducts(orderDetailActivity.historyDetailResponse.getCartDetail().getOrderDetails());
        cartOrder.setPickupAddresses(orderDetailActivity.historyDetailResponse.getCartDetail().getPickupAddresses());
        Addresses destinationAddress = orderDetailActivity.historyDetailResponse.getCartDetail().getDestinationAddresses().get(0);
        CartUserDetail cartUserDetail = destinationAddress.getUserDetails();
        if (TextUtils.isEmpty(cartUserDetail.getName()) || TextUtils.isEmpty(cartUserDetail.getEmail())) {
            cartUserDetail.setEmail(orderDetailActivity.preferenceHelper.getEmail());
            cartUserDetail.setName(orderDetailActivity.preferenceHelper.getFirstName() + " " + orderDetailActivity.preferenceHelper.getLastName());
            cartUserDetail.setCountryPhoneCode(orderDetailActivity.preferenceHelper.getCountryPhoneCode());
            cartUserDetail.setImageUrl(orderDetailActivity.preferenceHelper.getProfilePic());
        }
        cartOrder.setDestinationAddresses(orderDetailActivity.historyDetailResponse.getCartDetail().getDestinationAddresses());

        double cartOrderTotalPrice = 0, totalCartAmountWithoutTax = 0, cartOrderTotalTaxPrice = 0;
        for (CartProducts products : orderDetailActivity.historyDetailResponse.getCartDetail().getOrderDetails()) {
            cartOrderTotalPrice = cartOrderTotalPrice + products.getTotalProductItemPrice();
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + products.getTotalProductItemPrice();
            if (orderDetailActivity.historyDetailResponse.getStore().isTaxIncluded()) {
                cartOrderTotalPrice = cartOrderTotalPrice - products.getTotalItemTax();
            }
            cartOrderTotalTaxPrice = cartOrderTotalTaxPrice + products.getTotalItemTax();
        }

        cartOrder.setCartOrderTotalPrice(cartOrderTotalPrice);
        cartOrder.setCartOrderTotalTaxPrice(cartOrderTotalTaxPrice);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        getCart();
                    } else {
                        Utils.hideCustomProgressDialog();
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
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

    private void getCart() {
        Utils.showCustomProgressDialog(orderDetailActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CartResponse> orderCall = apiInterface.getCart(orderDetailActivity.getCommonParam());
        orderCall.enqueue(new Callback<CartResponse>() {
            @Override
            public void onResponse(@NonNull Call<CartResponse> call, @NonNull Response<CartResponse> response) {
                Utils.hideCustomProgressDialog();
                orderDetailActivity.parseContent.parseCart(response);
                goToCartActivity();
            }

            @Override
            public void onFailure(@NonNull Call<CartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.HOME_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void goToCartActivity() {
        Intent intent = new Intent(orderDetailActivity, CartActivity.class);
        startActivity(intent);
        orderDetailActivity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void openClearCartDialog() {
        final CustomDialogAlert dialogAlert = new CustomDialogAlert(orderDetailActivity, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_other_store_item_in_cart), getResources().getString(R.string.text_ok)) {
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

    /**
     * this method called webservice for clear user cart
     */
    protected void clearCart() {
        Utils.showCustomProgressDialog(orderDetailActivity, false);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        HashMap<String, Object> map = orderDetailActivity.getCommonParam();
        map.put(Const.Params.CART_ID, orderDetailActivity.currentBooking.getCartId());
        Call<IsSuccessResponse> responseCall = apiInterface.clearCart(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (orderDetailActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        orderDetailActivity.currentBooking.clearCart();
                        addItemInServerCart();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), orderDetailActivity);
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

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onResume() {
        super.onResume();
        if (orderProductAdapter != null) {
            orderProductAdapter.notifyDataSetChanged();
        }
        modifyTotalAmount();
    }

    private boolean isShowTaxSettingWaringDialog() {
        if (orderDetailActivity.orderDetail.getStore().isTaxIncluded() == orderDetailActivity.orderDetail.getOrderData().getTaxIncluded() && orderDetailActivity.orderDetail.getStore().isUseItemTax() == orderDetailActivity.orderDetail.getOrderData().getUseItemTax()) {
            if (orderDetailActivity.orderDetail.getStore().getStoreTaxDetails().size() != orderDetailActivity.orderDetail.getOrderData().getStoreTaxDetails().size()) {
                return true;
            } else {
                for (TaxesDetail cartTax : orderDetailActivity.orderDetail.getOrderData().getStoreTaxDetails()) {
                    boolean isTax = false;
                    for (TaxesDetail storeTax : orderDetailActivity.orderDetail.getStore().getStoreTaxDetails()) {
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
            for (CartProducts orderDetails : orderDetailActivity.orderDetail.getOrderData().getOrderDetails()) {
                for (CartProductItems item : orderDetails.getItems()) {
                    for (ProductItem serverItem : OrderEdit.getInstance().getOrderEditedProductItemWithAllSpecificationList()) {
                        if (item.getItemId().equals(serverItem.getId())) {
                            if (item.getItemPrice() != serverItem.getPrice()) {
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
                                for (Specifications itemResSpecification : serverItem.getSpecifications()) {
                                    for (Specifications specification : item.getSpecifications()) {
                                        if (itemResSpecification.getUniqueId() == specification.getUniqueId()) {
                                            for (SpecificationSubItem productResSpecification : itemResSpecification.getList()) {
                                                for (SpecificationSubItem productSpecification : specification.getList()) {
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
        changesWarningDialog = new CustomDialogAlert(requireActivity(), getString(R.string.text_warning), getString(R.string.text_tax_change_message), getString(R.string.btn_continue)) {

            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
                updateOrderPricing();
                rcvCart.setVisibility(View.VISIBLE);
                rcvOrderProductItem.setVisibility(View.GONE);
                btnApproveEditOrder.setVisibility(View.GONE);
                btnConfirmDetail.setVisibility(View.VISIBLE);
                btnAddItem.setText(R.string.text_add_item);
            }
        };
        changesWarningDialog.setCancelable(false);
        changesWarningDialog.show();
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (orderDetailActivity.orderDetail.getStore().isTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void updateOrderPricing() {
        double totalCartPrice = 0, totalCartTaxPrice = 0;
        int totalItemCount = 0, totalSpecificationCount = 0;

        List<TaxesDetail> storeTaxDetails = orderDetailActivity.orderDetail.getStore().getStoreTaxDetails();
        double storeTax = 0.0;
        for (TaxesDetail taxesDetail : storeTaxDetails) {
            storeTax = storeTax + taxesDetail.getTax();
        }
        for (CartProducts orderDetails : OrderEdit.getInstance().getOrderEditedProductWithSelectedSpecificationList()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            for (CartProductItems item : orderDetails.getItems()) {
                totalItemCount = totalItemCount + item.getQuantity();
                double totalSpecificationPrice = 0.0;
                for (ProductItem serverItem : OrderEdit.getInstance().getOrderEditedProductItemWithAllSpecificationList()) {
                    if (item.getItemId().equals(serverItem.getId())) {
                        item.setItemPrice(serverItem.getPrice());
                        item.setTaxesDetails(serverItem.getTaxesDetails());
                        item.setTotalSpecificationPrice(serverItem.getTotalSpecificationPrice());
                        for (Specifications itemSpecification : item.getSpecifications()) {
                            totalSpecificationCount = totalSpecificationCount + itemSpecification.getList().size();
                            for (Specifications serverItemSpecification : serverItem.getSpecifications()) {
                                if (itemSpecification.getUniqueId() == serverItemSpecification.getUniqueId()) {
                                    double specificationPrice = 0;
                                    for (SpecificationSubItem productSpecification : itemSpecification.getList()) {
                                        for (SpecificationSubItem serverProductSpecification : serverItemSpecification.getList()) {
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
                item.setTax(orderDetailActivity.orderDetail.getStore().isUseItemTax() ? item.getTotalTaxes() : storeTax);
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
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;
        }
        modifyTotalAmount();
        Objects.requireNonNull(rcvOrderProductItem.getAdapter()).notifyDataSetChanged();
    }

    public void openDialogCourierItemImage(int position) {
        if (orderDetailActivity.orderDetail == null) {
            if (rcvOrderProductItem.getAdapter() instanceof CourierItemDetailAdapter) {
                CourierItemDetailAdapter adapter = (CourierItemDetailAdapter) rcvOrderProductItem.getAdapter();
                orderDetailActivity.orderDetail = new Order();
                orderDetailActivity.orderDetail.setCourierItemsImages(adapter.getImageList());
            }
        }
        Dialog dialog = new Dialog(orderDetailActivity);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_item_image);
        llDotsDialog = dialog.findViewById(R.id.llDotsDialog);
        imageViewPagerDialog = dialog.findViewById(R.id.dialogImageViewPager);
        dialog.findViewById(R.id.ivClose).setOnClickListener(v -> dialog.dismiss());
        addBottomDotsDialog(position);
        CourierItemAdapter courierItemAdapter = new CourierItemAdapter(orderDetailActivity, orderDetailActivity.orderDetail.getCourierItemsImages(), R.layout.item_image_full);
        imageViewPagerDialog.setAdapter(courierItemAdapter);
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

    private void addBottomDotsDialog(int currentPage) {
        if (orderDetailActivity.orderDetail.getCourierItemsImages().size() > 1) {
            TextView[] dots = new TextView[orderDetailActivity.orderDetail.getCourierItemsImages().size()];

            llDotsDialog.removeAllViews();
            for (int i = 0; i < dots.length; i++) {
                dots[i] = new TextView(orderDetailActivity);
                dots[i].setText(Html.fromHtml("&#8226;"));
                dots[i].setTextSize(35);
                dots[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label_dark, null));
                llDotsDialog.addView(dots[i]);
            }

            if (dots.length > 0) {
                dots[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_tag_dark, null));
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
}