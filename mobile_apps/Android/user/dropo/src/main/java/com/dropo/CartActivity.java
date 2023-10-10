package com.dropo;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.CartProductAdapter;
import com.dropo.component.CustomFontTextView;
import com.dropo.interfaces.OnSingleClickListener;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.ProductDetail;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CartActivity extends BaseAppCompatActivity {

    private RecyclerView rcvCart;
    private CustomFontTextView tvCartTotal;
    private LinearLayout btnCheckOut;
    private CartProductAdapter cartProductAdapter;
    private LinearLayout ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cart);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_basket));
        initViewById();
        setViewListener();
        initRcvCart();
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    protected void onResume() {
        super.onResume();
        getCart();
        if (cartProductAdapter != null) {
            modifyTotalAmount();
            cartProductAdapter.notifyDataSetChanged();
        }
        updateUiCartList();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvCart = findViewById(R.id.rcvCart);
        tvCartTotal = findViewById(R.id.tvCartTotal);
        btnCheckOut = findViewById(R.id.btnCheckOut);
        ivEmpty = findViewById(R.id.ivEmpty);
    }

    @Override
    protected void setViewListener() {
        btnCheckOut.setOnClickListener(new OnSingleClickListener() {
            @Override
            public void onSingleClick(View v) {
                CartActivity.this.onClick(v);
            }
        });
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnCheckOut) {
            if (currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
                Utils.showToast(getResources().getString(R.string.msg_no_in_cart), this);
            } else {
                addItemInServerCart(true);
            }
        }
    }

    private void initRcvCart() {
        cartProductAdapter = new CartProductAdapter(this, currentBooking.getCartProductWithSelectedSpecificationList());
        rcvCart.setLayoutManager(new LinearLayoutManager(this));
        rcvCart.setAdapter(cartProductAdapter);
        modifyTotalAmount();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    /**
     * this method id used to increase particular item quantity in cart
     *
     * @param cartProductItems cartProductItems
     */
    @SuppressLint("NotifyDataSetChanged")
    public void increaseItemQuantity(CartProductItems cartProductItems) {
        int quantity = cartProductItems.getQuantity();
        quantity++;
        cartProductItems.setQuantity(quantity);
        cartProductItems.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
        cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
        cartProductAdapter.notifyDataSetChanged();
        modifyTotalAmount();
        addItemInServerCart(false);
    }

    /**
     * this method id used to decrease particular item quantity in cart
     *
     * @param cartProductItems cartProductItems
     */
    @SuppressLint("NotifyDataSetChanged")
    public void decreaseItemQuantity(CartProductItems cartProductItems) {
        int quantity = cartProductItems.getQuantity();
        if (quantity > 1) {
            quantity--;
            cartProductItems.setQuantity(quantity);
            cartProductItems.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
            cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
            cartProductAdapter.notifyDataSetChanged();
            modifyTotalAmount();
            addItemInServerCart(false);
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
        currentBooking.getCartProductWithSelectedSpecificationList().get(position).getItems().remove(relativePosition);
        if (currentBooking.getCartProductWithSelectedSpecificationList().get(position).getItems().isEmpty()) {
            currentBooking.getCartProductWithSelectedSpecificationList().remove(position);
        }
        cartProductAdapter.notifyDataSetChanged();
        modifyTotalAmount();
        if (getCartItemCount() == 0) {
            clearCart();
        } else {
            addItemInServerCart(false);
        }
    }

    private int getCartItemCount() {
        int cartCount = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductWithSelectedSpecificationList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        return cartCount;
    }

    /**
     * this method id used to modify or change  total cart item  amount
     */
    public void modifyTotalAmount() {
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
        tvCartTotal.setText(String.format("%s%s", currentBooking.getCartCurrency(), parseContent.decimalTwoDigitFormat.format(totalCartAmountWithoutTax)));
    }

    private void goToCheckoutActivity() {
        Intent intent = new Intent(this, CheckoutActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void getCart() {
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CartResponse> orderCall = apiInterface.getCart(getCommonParam());
        orderCall.enqueue(new Callback<CartResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<CartResponse> call, @NonNull Response<CartResponse> response) {
                parseContent.parseCart(response);
                cartProductAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(@NonNull Call<CartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.HOME_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method called a webservice for clear cart
     */
    protected void clearCart() {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        HashMap<String, Object> map = getCommonParam();

        map.put(Const.Params.CART_ID, currentBooking.getCartId());
        Call<IsSuccessResponse> responseCall = apiInterface.clearCart(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        currentBooking.clearCart();
                        cartProductAdapter.notifyDataSetChanged();
                        updateUiCartList();
                        Utils.showMessageToast(response.body().getStatusPhrase(), CartActivity.this);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CartActivity.this);
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

    /**
     * this method called a webservice for add item in cart
     */
    private void addItemInServerCart(final boolean goToCheckout) {
        Utils.showCustomProgressDialog(this, false);

        CartOrder cartOrder = new CartOrder();
        cartOrder.setUserType(Const.Type.USER);
        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(currentBooking.getTaxesDetails());
        cartOrder.setServerToken(preferenceHelper.getSessionToken());
        cartOrder.setStoreId(currentBooking.getSelectedStoreId());
        cartOrder.setProducts(currentBooking.getCartProductWithSelectedSpecificationList());
        cartOrder.setDestinationAddresses(currentBooking.getDestinationAddresses());
        cartOrder.setPickupAddresses(currentBooking.getPickupAddresses());

        double totalCartPrice = 0, totalCartAmountWithoutTax = 0, totalCartTaxPrice = 0;
        for (CartProducts products : currentBooking.getCartProductWithSelectedSpecificationList()) {
            double totalItemPrice = 0, totalTaxPrice = 0;
            for (CartProductItems cartProductItems : products.getItems()) {
                totalTaxPrice = totalTaxPrice + cartProductItems.getTotalItemTax();
                totalItemPrice = totalItemPrice + cartProductItems.getTotalItemAndSpecificationPrice();
            }
            products.setTotalItemTax(totalTaxPrice);
            products.setTotalProductItemPrice(totalItemPrice);

            totalCartPrice = totalCartPrice + totalItemPrice;
            totalCartAmountWithoutTax = totalCartAmountWithoutTax + totalItemPrice;
            if (currentBooking.isTaxIncluded()) {
                totalCartPrice = totalCartPrice - totalTaxPrice;
            }
            totalCartTaxPrice = totalCartTaxPrice + totalTaxPrice;

        }
        cartOrder.setCartOrderTotalPrice(totalCartPrice);
        cartOrder.setCartOrderTotalTaxPrice(totalCartTaxPrice);
        cartOrder.setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);

        if (currentBooking.isTableBooking()) {
            cartOrder.setTableNo(currentBooking.getTableNumber());
            cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
            cartOrder.setBookingType(currentBooking.getTableBookingType());
            cartOrder.setDeliveryType(currentBooking.getDeliveryType());
        }

        if (preferenceHelper.getIsFromQRCode()) {
            cartOrder.setTableNo(currentBooking.getTableNumber());
            cartOrder.setNoOfPersons(currentBooking.getNumberOfPerson());
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
                        if (goToCheckout) {
                            goToCheckoutActivity();
                        }
                    } else {
                        if (response.body().getErrorCode() == Const.TAXES_DETAILS_CHANGED) {
                            clearCart();
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CartActivity.this);
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

    private void updateUiCartList() {
        if (currentBooking.getCartProductWithSelectedSpecificationList().isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvCart.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvCart.setVisibility(View.VISIBLE);
        }
    }

    public void goToProductSpecificationActivity(int section, int position, CartProductItems cartProductItems, ProductDetail productDetail) {
        Intent intent = new Intent(this, ProductSpecificationActivity.class);
        intent.putExtra(Const.UPDATE_ITEM_INDEX, position);
        intent.putExtra(Const.UPDATE_ITEM_INDEX_SECTION, section);
        intent.putExtra(Const.PRODUCT_DETAIL, productDetail);
        intent.putExtra(Const.PRODUCT_ITEM, matchSelectedCartProductItemToProductItem(cartProductItems));
        intent.putExtra(Const.STORE_INDEX, getLangIndxex(preferenceHelper.getLanguageCode(), currentBooking.getStoreLangs(), true));
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private ProductItem matchSelectedCartProductItemToProductItem(CartProductItems cartProductItems) {
        for (ProductItem saveProductItem : currentBooking.getCartProductItemWithAllSpecificationList()) {
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
}