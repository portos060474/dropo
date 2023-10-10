package com.dropo.store;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.store.adapter.ProductItemItemAdapter;
import com.dropo.store.adapter.ProductSpecificationItemAdapter;
import com.dropo.store.models.datamodel.CartProductItems;
import com.dropo.store.models.datamodel.CartProducts;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;

import java.util.ArrayList;

public class StoreOrderProductSpecificationActivity extends BaseActivity {

    private final CurrentBooking currentBooking = CurrentBooking.getInstance();
    private EditText etAddNote;
    private TextView tvProductName, tvProductDescription, btnDecrease, btnIncrease, tvItemQuantity, tvItemAmount;
    private LinearLayout llAddToCart;
    private RecyclerView rcvSpecificationItem;
    private ProductSpecificationItemAdapter productSpecificationItemAdapter;
    private int itemQuantity = 1;
    private double itemPriceAndSpecificationPriceTotal = 0;
    private int cartCount = 0;
    private final ArrayList<ItemSpecification> specificationsList = new ArrayList<>();
    private final ArrayList<ItemSpecification> mainSpecificationList = new ArrayList<>();
    private Item productItemsItem;
    private Product productDetail;
    private ViewPager imageViewPager, imageViewPagerDialog;
    private int requiredCount = 0;
    private LinearLayout llDots, llDotsDialog;
    private TextView[] dots, dots1;
    private NestedScrollView scrollView;
    private TextView tvToolbarTitle, tvCartCount;
    private ImageView ivToolbarRightIcon3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_order_product_specification);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        tvToolbarTitle = findViewById(R.id.tvToolbarTitle);
        tvCartCount = findViewById(R.id.tvCartCount);
        tvCartCount.setVisibility(View.VISIBLE);
        tvCartCount.getBackground().setTint(AppColor.COLOR_THEME);
        ivToolbarRightIcon3 = findViewById(R.id.ivToolbarRightIcon3);
        ivToolbarRightIcon3.setImageDrawable(AppColor.getThemeColorDrawable(R.drawable.ic_shopping_bag, this));
        ivToolbarRightIcon3.setOnClickListener(this);

        loadExtraData();
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
        btnDecrease.setOnClickListener(this);
        btnIncrease.setOnClickListener(this);
        Utilities.setLeftBackgroundRtlView(this, btnDecrease);
        Utilities.setRightBackgroundRtlView(this, btnIncrease);
        initImagePager();
        setData(itemQuantity);
        loadProductSpecification();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, R.drawable.filter_store);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.llAddToCart) {
            addToCart();
        } else if (id == R.id.btnIncrease) {
            increaseItemQuality();
        } else if (id == R.id.btnDecrease) {
            decreaseItemQuantity();
        } else if (id == R.id.ivToolbarRightIcon3) {
            goToCartActivity();
        }
    }

    private void loadProductSpecification() {
        tvProductName.setText(productItemsItem.getName());
        tvProductDescription.setText(productItemsItem.getDetails());
        specificationsList.addAll(productItemsItem.getSpecifications());
        mainSpecificationList.addAll(productItemsItem.getSpecifications());
        arrangeDataWithAssociateSpecification();
        modifyTotalItemAmount();

        productSpecificationItemAdapter = new ProductSpecificationItemAdapter(this, specificationsList) {
            @Override
            public void onSingleItemClick(int section, int relativePosition, int absolutePosition) {
                onSingleItemSelect(section, relativePosition);
            }

            @Override
            public void onMultipleItemClick() {
                modifyTotalItemAmount();
            }
        };
        rcvSpecificationItem.setLayoutManager(new LinearLayoutManager(this));
        rcvSpecificationItem.setNestedScrollingEnabled(false);
        rcvSpecificationItem.setAdapter(productSpecificationItemAdapter);
        scrollView.getParent().requestChildFocus(scrollView, scrollView);
        tvToolbarTitle.setText(productItemsItem.getName());
    }

    private void arrangeDataWithAssociateSpecification() {
        specificationsList.clear();

        for (ItemSpecification specifications : mainSpecificationList) {
            if (!specifications.isAssociated()) {
                specificationsList.add(specifications);
            }
        }

        ArrayList<String> itemIds = new ArrayList<>();
        for (ItemSpecification specifications : specificationsList) {
            itemIds.add(specifications.getId());
        }

        ArrayList<ProductSpecification> selectedSpecificationsList = new ArrayList<>();
        for (ItemSpecification specifications : specificationsList) {
            for (ProductSpecification specificationSubItem : specifications.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    selectedSpecificationsList.add(specificationSubItem);
                }
            }
        }

        for (ItemSpecification objMain : mainSpecificationList) {
            for (ProductSpecification obj : selectedSpecificationsList) {
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

    private void addBottomDots(int currentPage) {
        if (productItemsItem.getImageUrl().size() > 1) {
            dots = new TextView[productItemsItem.getImageUrl().size()];

            llDots.removeAllViews();
            for (int i = 0; i < dots.length; i++) {
                dots[i] = new TextView(this);
                dots[i].setText(Html.fromHtml("&#8226;"));
                dots[i].setTextSize(35);
                dots[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label, null));
                llDots.addView(dots[i]);
            }

            if (dots.length > 0)
                dots[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_text_light, null));
        }
    }

    private void dotColorChange(int currentPage) {
        if (llDots.getChildCount() > 0) {
            for (int i = 0; i < llDots.getChildCount(); i++) {
                TextView textView = (TextView) llDots.getChildAt(i);
                textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label, null));

            }
            TextView textView = (TextView) llDots.getChildAt(currentPage);
            textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_text_light, null));
        }
    }

    private void addBottomDotsDialog(int currentPage) {
        if (productItemsItem.getImageUrl().size() > 1) {
            dots1 = new TextView[productItemsItem.getImageUrl().size()];

            llDotsDialog.removeAllViews();
            for (int i = 0; i < dots1.length; i++) {
                dots1[i] = new TextView(this);
                dots1[i].setText(Html.fromHtml("&#8226;"));
                dots1[i].setTextSize(35);
                dots1[i].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label, null));
                llDotsDialog.addView(dots1[i]);
            }

            if (dots1.length > 0)
                dots1[currentPage].setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_text_light, null));
        }
    }

    private void dotColorChangeDialog(int currentPage) {
        if (llDotsDialog.getChildCount() > 0) {
            for (int i = 0; i < llDotsDialog.getChildCount(); i++) {
                TextView textView = (TextView) llDotsDialog.getChildAt(i);
                textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_label, null));

            }
            TextView textView = (TextView) llDotsDialog.getChildAt(currentPage);
            textView.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_text_light, null));
        }
    }

    private int getItem(int i) {
        return imageViewPager.getCurrentItem() + i;
    }

    private void initImagePager() {
        addBottomDots(0);
        ProductItemItemAdapter itemItemAdapter = new ProductItemItemAdapter(this, productItemsItem.getImageUrl(), R.layout.item_image_product, true) {
            @Override
            public void onItemClick(int position) {
                openDialogItemImage(position);
            }
        };
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

    private void loadExtraData() {
        if (getIntent() != null) {
            Bundle bundle = getIntent().getExtras();
            productItemsItem = bundle.getParcelable(Constant.PRODUCT_SPECIFICATION);
            productDetail = bundle.getParcelable(Constant.PRODUCT_DETAIL);
        }
    }

    /**
     * this method will manage total amount after change or modify
     */
    public void modifyTotalItemAmount() {
        itemPriceAndSpecificationPriceTotal = productItemsItem.getPrice();
        int requiredCountTemp = 0;
        for (ItemSpecification specificationsItem : specificationsList) {
            for (ProductSpecification listItem : specificationsItem.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    itemPriceAndSpecificationPriceTotal = itemPriceAndSpecificationPriceTotal + (listItem.getPrice() * listItem.getQuantity());
                }
            }
            if (specificationsItem.isRequired() && specificationsItem.getSelectedCount() >= specificationsItem.getRange() && specificationsItem.getMaxRange() == 0 && specificationsItem.getSelectedCount() != 0) {
                requiredCountTemp++;
            } else if (specificationsItem.isRequired() && specificationsItem.getSelectedCount() >= specificationsItem.getRange() && specificationsItem.getSelectedCount() <= specificationsItem.getMaxRange() && specificationsItem.getSelectedCount() != 0) {
                requiredCountTemp++;
            }
        }
        if (requiredCountTemp == requiredCount) {
            llAddToCart.setOnClickListener(this);
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
        for (ItemSpecification specificationsItem : specificationsList) {
            if (specificationsItem.isRequired()) {
                requiredCount++;
            }
            for (ProductSpecification specificationSubItem : specificationsItem.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    specificationsItem.setSelectedCount(specificationsItem.getSelectedCount() + 1);
                }
            }
            specificationsItem.setChooseMessage(getChooseMessage(specificationsItem.getRange(), specificationsItem.getMaxRange()));
        }
    }

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

    private void reloadAmountData(Double itemAmount) {
        String amount = preferenceHelper.getCurrency() + parseContent.decimalTwoDigitFormat.format(itemAmount);
        tvItemAmount.setText(amount);
    }

    private void setCartItem() {
        cartCount = 0;
        for (CartProducts cartProducts : currentBooking.getCartProductList()) {
            cartCount = cartCount + cartProducts.getItems().size();
        }
        tvCartCount.setText(String.valueOf(cartCount));
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

    private void setData(int itemQuantity) {
        tvItemQuantity.setText(String.valueOf(itemQuantity));
    }

    protected void goToCartActivity() {
        Intent intent = new Intent(this, CartActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    /**
     * this method to create cart structure witch is help to add item in cart
     */
    private void addToCart() {
        double specificationPriceTotal = 0;
        double specificationPrice = 0;

        ArrayList<ItemSpecification> specificationList = new ArrayList<>();
        for (ItemSpecification specificationListItem : specificationsList) {
            ArrayList<ProductSpecification> specificationItemCartList = new ArrayList<>();
            for (ProductSpecification listItem : specificationListItem.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    listItem.setNameListToString();
                    specificationPrice = specificationPrice + listItem.getPrice();
                    specificationPriceTotal = specificationPriceTotal + listItem.getPrice();
                    specificationItemCartList.add(listItem);
                }
            }

            if (!specificationItemCartList.isEmpty()) {
                ItemSpecification specificationsItem = new ItemSpecification();
                specificationsItem.setList(specificationItemCartList);
                specificationsItem.setName(specificationListItem.getName());
                specificationsItem.setPrice(specificationPrice);
                specificationsItem.setType(specificationListItem.getType());
                specificationsItem.setUniqueId(specificationListItem.getUniqueId());
                specificationsItem.setSequenceNumber(specificationListItem.getSequenceNumber());
                specificationList.add(specificationsItem);
            }
            specificationPrice = 0;
        }

        CartProductItems cartProductItems = new CartProductItems();
        cartProductItems.setItemId(productItemsItem.getId());
        cartProductItems.setUniqueId(productItemsItem.getUniqueId());
        cartProductItems.setItemName(productItemsItem.getName());
        cartProductItems.setQuantity(itemQuantity);
        cartProductItems.setImageUrl(productItemsItem.getImageUrl());
        cartProductItems.setDetails(productItemsItem.getDetails());
        cartProductItems.setSpecifications(specificationList);
        cartProductItems.setTotalSpecificationPrice(specificationPriceTotal);
        cartProductItems.setItemPrice(productItemsItem.getPrice());
        cartProductItems.setTaxesDetails(productItemsItem.getTaxesDetails());
        cartProductItems.setItemNote(etAddNote.getText().toString());
        cartProductItems.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);
        cartProductItems.setTotalPrice(cartProductItems.getItemPrice() + cartProductItems.getTotalSpecificationPrice());
        cartProductItems.setTax(preferenceHelper.getIsUseItemTax() ? productItemsItem.getTotalTaxes() : (double) preferenceHelper.getStoreTax());
        cartProductItems.setItemTax(getTaxableAmount(productItemsItem.getPrice(), cartProductItems.getTax()));
        cartProductItems.setTotalSpecificationTax(getTaxableAmount(specificationPriceTotal, cartProductItems.getTax()));
        cartProductItems.setTotalTax(cartProductItems.getItemTax() + cartProductItems.getTotalSpecificationTax());
        cartProductItems.setTotalItemTax(cartProductItems.getTotalTax() * cartProductItems.getQuantity());

        if (isProductExistInLocalCart(cartProductItems)) {
            // do somethings
        } else {
            ArrayList<CartProductItems> cartProductItemsList = new ArrayList<>();
            cartProductItemsList.add(cartProductItems);
            CartProducts cartProducts = new CartProducts();
            cartProducts.setItems(cartProductItemsList);
            cartProducts.setProductId(productItemsItem.getProductId());
            cartProducts.setTaxesDetails(productItemsItem.getTaxesDetails());
            cartProducts.setProductName(productDetail.getName());
            cartProducts.setUniqueId(productDetail.getUniqueId());
            cartProducts.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
            cartProducts.setTotalItemTax(cartProductItems.getTotalItemTax());
            currentBooking.setCartProduct(cartProducts);
        }
        setCartItem();
        Utilities.showToast(this, getResources().getString(R.string.msg_added_item_in_cart_successfully));
        onBackPressed();
    }

    /**
     * this method check product is exist in local cart
     *
     * @param cartProductItems cartProductItems
     * @return true if product exist otherwise false
     */
    private boolean isProductExistInLocalCart(CartProductItems cartProductItems) {
        boolean isExist = false;
        for (CartProducts cartProducts : currentBooking.getCartProductList()) {
            if (TextUtils.equals(cartProducts.getProductId(), productItemsItem.getProductId())) {
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
                cartProducts.setTotalItemTax(cartProducts.getTotalItemTax() + cartProducts.getTotalItemTax());
                return true;
            }
        }
        return false;
    }

    /**
     * this method manage single type specification click event
     *
     * @param section section
     * @param position position
     */
    @SuppressLint("NotifyDataSetChanged")
    public void onSingleItemSelect(int section, int position) {
        ItemSpecification selectedSpecification = specificationsList.get(section);

        for (ItemSpecification specifications : mainSpecificationList) {
            if (specifications.getId().equalsIgnoreCase(selectedSpecification.getId())) {
                specifications.setSelectedCount(1);
                for (ProductSpecification specificationSubItem : specifications.getList()) {
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

    public void openDialogItemImage(int position) {
        Dialog dialog = new Dialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_item_image);
        llDotsDialog = dialog.findViewById(R.id.llDotsDialog);
        imageViewPagerDialog = dialog.findViewById(R.id.dialogImageViewPager);
        addBottomDotsDialog(position);
        ProductItemItemAdapter itemItemAdapter = new ProductItemItemAdapter(this, productItemsItem.getImageUrl(), R.layout.item_image_full, false) {
            @Override
            public void onItemClick(int position) {

            }
        };
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

    @Override
    protected void onResume() {
        super.onResume();
        setCartItem();
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (preferenceHelper.getTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
        }
    }
}