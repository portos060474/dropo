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
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;
import androidx.core.widget.NestedScrollView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;

import com.dropo.store.adapter.ProductItemItemAdapter;
import com.dropo.store.adapter.ProductSpecificationItemAdapter;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.models.singleton.UpdateOrder;
import com.dropo.store.utils.Constant;


import java.util.ArrayList;

public class UpdateOrderProductSpecificationActivity extends BaseActivity {

    private TextView tvProductName, tvProductDescription, btnDecrease, btnIncrease, tvItemQuantity, tvItemAmount;
    private LinearLayout llAddToCart;
    private RecyclerView rcvSpecificationItem;
    private ProductSpecificationItemAdapter productSpecificationItemAdapter;
    private int itemQuantity = 1;
    private double itemPriceAndSpecificationPriceTotal = 0;
    private final ArrayList<ItemSpecification> specificationsList = new ArrayList<>();
    private final ArrayList<ItemSpecification> mainSpecificationList = new ArrayList<>();
    private Item productItemsItem;
    private Product productDetail;
    private ViewPager imageViewPager, imageViewPagerDialog;
    private int requiredCount = 0;
    private LinearLayout llDots, llDotsDialog;
    private TextView[] dots, dots1;
    private NestedScrollView scrollView;
    private TextView tvToolbarTitle;
    private int updateItemIndex = -1;
    private int updateItemSectionIndex = -1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_store_order_product_specification);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        tvToolbarTitle = findViewById(R.id.tvToolbarTitle);
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
        btnDecrease.setOnClickListener(this);
        btnIncrease.setOnClickListener(this);
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
            addOrUpdateOrder();
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
        if (getIntent().getExtras() != null) {
            Bundle bundle = getIntent().getExtras();
            updateItemIndex = bundle.getInt(Constant.UPDATE_ITEM_INDEX);
            updateItemSectionIndex = bundle.getInt(Constant.UPDATE_ITEM_INDEX_SECTION);
            if (updateItemIndex > -1) {
                productItemsItem = bundle.getParcelable(Constant.ITEM);
                productDetail = new Product();
                productDetail.setSequenceNumber(0L);
                productDetail.setName(UpdateOrder.getInstance().getOrderDetails().get(updateItemSectionIndex).getProductName());
                productDetail.setUniqueId(UpdateOrder.getInstance().getOrderDetails().get(updateItemSectionIndex).getUniqueId());
                itemQuantity = UpdateOrder.getInstance().getOrderDetails().get(updateItemSectionIndex).getItems().get(updateItemIndex).getQuantity();

            } else {
                productItemsItem = bundle.getParcelable(Constant.PRODUCT_SPECIFICATION);
                productDetail = bundle.getParcelable(Constant.PRODUCT_DETAIL);
            }
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
            if (specificationsItem.isRequired() && specificationsItem.getSelectedCount() >= specificationsItem.getRange() && specificationsItem.getMaxRange() == 0) {
                requiredCountTemp++;
            } else if (specificationsItem.isRequired() && specificationsItem.getSelectedCount() >= specificationsItem.getRange() && specificationsItem.getSelectedCount() <= specificationsItem.getMaxRange()) {
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

    private void reloadAmountData(Double itemAmount) {
        String amount = preferenceHelper.getCurrency() + parseContent.decimalTwoDigitFormat.format(itemAmount);
        tvItemAmount.setText(amount);
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
    private void addOrUpdateOrder() {
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
                    listItem.setName(listItem.getName());
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

        Item items = new Item();
        items.setItemId(productItemsItem.getId());
        items.setUniqueId(productItemsItem.getUniqueId());
        items.setItemName(productItemsItem.getName());
        items.setQuantity(itemQuantity);
        items.setImageUrl(productItemsItem.getImageUrl());
        items.setDetails(productItemsItem.getDetails());
        items.setSpecifications(specificationList);
        items.setItemPrice(productItemsItem.getPrice());
        items.setTotalSpecificationPrice(specificationPriceTotal);
        items.setNoteForItem("");
        items.setTotalItemAndSpecificationPrice(itemPriceAndSpecificationPriceTotal);
        items.setTotalPrice(items.getItemPrice() + items.getTotalSpecificationPrice());
        items.setTax(preferenceHelper.getIsUseItemTax() ? productItemsItem.getTotalTax() : (double) preferenceHelper.getStoreTax());
        items.setItemTax(getTaxableAmount(productItemsItem.getPrice(), items.getTax()));
        items.setTotalSpecificationTax(getTaxableAmount(specificationPriceTotal, items.getTax()));
        items.setTotalTax(items.getItemTax() + items.getTotalSpecificationTax());
        items.setTotalItemTax(items.getTotalTax() * items.getQuantity());

        if (updateItemIndex > -1) {
            UpdateOrder.getInstance().getOrderDetails().get(updateItemSectionIndex).getItems().set(updateItemIndex, items);
        } else {
            productItemsItem.setItemId(productItemsItem.getId());
            UpdateOrder.getInstance().setSaveNewItem(productItemsItem);
            if (isProductExistInOrder(items)) {
                // do somethings
            } else {
                ArrayList<Item> itemsList = new ArrayList<>();
                itemsList.add(items);
                OrderDetails orderDetails = new OrderDetails();
                orderDetails.setItems(itemsList);
                orderDetails.setProductId(productItemsItem.getProductId());
                orderDetails.setProductName(productDetail.getName());
                orderDetails.setUniqueId(productDetail.getUniqueId());
                UpdateOrder.getInstance().getOrderDetails().add(orderDetails);
            }
        }
        onBackPressed();
    }

    /**
     * this method check product is exist in local cart
     *
     * @param cartProductItems cartProductItems
     * @return true if product exist otherwise false
     */
    private boolean isProductExistInOrder(Item cartProductItems) {
        boolean isExist = false;
        for (OrderDetails orderDetails : UpdateOrder.getInstance().getOrderDetails()) {
            if (TextUtils.equals(orderDetails.getProductId(), productItemsItem.getProductId())) {
                for (Item item : orderDetails.getItems()) {
                    if (cartProductItems.equals(item)) {
                        int quantity = itemQuantity + item.getQuantity();
                        item.setQuantity(itemQuantity + item.getQuantity());
                        item.setTotalItemAndSpecificationPrice((cartProductItems.getTotalSpecificationPrice() + cartProductItems.getItemPrice()) * quantity);
                        item.setTotalItemTax(cartProductItems.getTotalTax() * quantity);
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) {
                    orderDetails.getItems().add(cartProductItems);
                }
                itemPriceAndSpecificationPriceTotal = orderDetails.getTotalProductItemPrice() + itemPriceAndSpecificationPriceTotal;
                orderDetails.setTotalProductItemPrice(itemPriceAndSpecificationPriceTotal);
                orderDetails.setTotalItemTax(orderDetails.getTotalItemTax() + cartProductItems.getTotalItemTax());
                return true;
            }
        }
        return false;
    }

    /**
     * this method manage single type specification click event
     *
     * @param section  section
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
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private double getTaxableAmount(double amount, double taxValue) {
        if (preferenceHelper.getTaxIncluded()) {
            return amount - (100 * amount) / (100 + taxValue);
        } else {
            return amount * taxValue * 0.01;
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
}