package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.CartProductAdapter;
import com.dropo.store.models.datamodel.CartProductItems;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;


public class CartActivity extends BaseActivity {

    private RecyclerView rcvCart;
    private CustomTextView tvCartTotal, btnSubmit;
    private LinearLayout btnCheckOut;
    private CartProductAdapter cartProductAdapter;
    private LinearLayout ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cart);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_cart));

        rcvCart = findViewById(R.id.rcvCart);
        tvCartTotal = findViewById(R.id.tvCartTotal);
        btnCheckOut = findViewById(R.id.btnCheckOut);
        ivEmpty = findViewById(R.id.ivEmpty);
        btnCheckOut.setOnClickListener(this);
        btnSubmit = findViewById(R.id.btnSubmit);
        btnSubmit.setText(getResources().getString(R.string.text_checkout));
        initRcvCart();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        setToolbarEditIcon(!CurrentBooking.getInstance().getCartProductList().isEmpty(), R.drawable.ic_cancel);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            clearCart();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        updateUiCartList();
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnCheckOut) {
            if (CurrentBooking.getInstance().getCartProductList().isEmpty()) {
                Utilities.showToast(this, getResources().getString(R.string.msg_no_in_cart));
            } else {
                goToCheckoutActivity();
            }
        }
    }

    private void initRcvCart() {
        cartProductAdapter = new CartProductAdapter(this, CurrentBooking.getInstance().getCartProductList());
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
        CurrentBooking.getInstance().getCartProductList().get(position).getItems().remove(relativePosition);
        if (CurrentBooking.getInstance().getCartProductList().get(position).getItems().isEmpty()) {
            CurrentBooking.getInstance().getCartProductList().remove(position);
        }
        updateUiCartList();
        cartProductAdapter.notifyDataSetChanged();
        modifyTotalAmount();
        setToolbarEditIcon(!CurrentBooking.getInstance().getCartProductList().isEmpty(), R.drawable.ic_cancel);
    }

    /**
     * this method id used to modify or change  total cart item  amount
     */
    public void modifyTotalAmount() {
        double totalAmount = 0;
        double totalCartAmountWithoutTax = 0;

        for (CartProducts cartProducts : CurrentBooking.getInstance().getCartProductList()) {
            for (CartProductItems cartProductItems : cartProducts.getItems()) {
                totalAmount = totalAmount + cartProductItems.getTotalItemAndSpecificationPrice();
                totalCartAmountWithoutTax = totalCartAmountWithoutTax + cartProductItems.getTotalItemAndSpecificationPrice();
                if (preferenceHelper.getTaxIncluded()) {
                    totalAmount = totalAmount - cartProductItems.getTotalItemTax();
                }
            }
        }
        CurrentBooking.getInstance().setTotalCartAmount(totalAmount);
        CurrentBooking.getInstance().setTotalCartAmountWithoutTax(totalCartAmountWithoutTax);
        tvCartTotal.setText(String.format("%s%s", preferenceHelper.getCurrency(), parseContent.decimalTwoDigitFormat.format(totalCartAmountWithoutTax)));
        updateUiCartList();
    }

    private void goToCheckoutActivity() {
        Intent intent = new Intent(this, CheckoutActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method called a webservice for clear cart
     */
    @SuppressLint("NotifyDataSetChanged")
    protected void clearCart() {
        CurrentBooking.getInstance().clearCart();
        cartProductAdapter.notifyDataSetChanged();
        setToolbarEditIcon(false, R.drawable.ic_cancel);
        updateUiCartList();
    }

    private void updateUiCartList() {
        if (CurrentBooking.getInstance().getCartProductList().isEmpty()) {
            ivEmpty.setVisibility(View.VISIBLE);
            rcvCart.setVisibility(View.GONE);
        } else {
            ivEmpty.setVisibility(View.GONE);
            rcvCart.setVisibility(View.VISIBLE);
        }
    }
}