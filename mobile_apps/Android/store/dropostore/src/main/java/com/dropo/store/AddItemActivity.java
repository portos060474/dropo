package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.ItemImageAdapter;
import com.dropo.store.adapter.SpecificationListAdapter;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.component.CustomSelectProductDialog;
import com.dropo.store.component.CustomSelectSpecificationGroupDialog;
import com.dropo.store.component.tag.TagLayout;
import com.dropo.store.component.tag.TagView;
import com.dropo.store.models.datamodel.ImageSetting;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.responsemodel.AddOrUpdateItemResponse;
import com.dropo.store.models.responsemodel.ImageSettingsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.SpecificationGroupFroAddItemResponse;
import com.dropo.store.models.singleton.CurrentProduct;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageCompression;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.textfield.TextInputEditText;
import com.soundcloud.android.crop.Crop;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddItemActivity extends BaseActivity {

    private final ArrayList<ItemSpecification> itemSpecificationFinalList = new ArrayList<>();
    private final ArrayList<ItemSpecification> productSpecificationGroupOriginalList = new ArrayList<>();
    private final ArrayList<ItemSpecification> itemSpecificationRestList = new ArrayList<>();
    private final ArrayList<TaxesDetail> taxesList = new ArrayList<>();
    private final String TAG = "AddItemActivity";
    private final ArrayList<String> itemImageList = new ArrayList<>();
    private final ArrayList<String> itemImageListForAdapter = new ArrayList<>();
    private final ArrayList<String> deleteItemImage = new ArrayList<>();
    public boolean isEditable;
    public boolean isNewItem = true;
    private Uri uri;
    private TextInputEditText etItemName, etItemDetail;
    private EditText etItemPrice, etProductName, etItemPriceWithoutOffer, etOfferMessage, etSequenceNumber;
    private ImageView ivItem;
    private String productId;
    private SwitchCompat switchVisibility, switchInStoke;
    private TextView tvCurrency, tvCurrency2;
    private SpecificationListAdapter specificationListAdapter;
    private Item item = new Item();
    private CustomSelectProductDialog customSelectProductDialog;
    private RecyclerView rcSpecification;
    private RecyclerView rcvItemImage;
    private ItemImageAdapter itemImageAdapter;
    private ImageHelper imageHelper;
    private ImageSetting imageSetting;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private TagLayout tagViewTax;
    private LinearLayout llTax;
    private CustomTextView tvSwitch, tvSwitchStock;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_item);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, android.R.color.transparent);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_item));
        tvCurrency = findViewById(R.id.tvCurrency);
        tvCurrency2 = findViewById(R.id.tvCurrency2);
        etItemName = findViewById(R.id.etItemName);
        rcvItemImage = findViewById(R.id.rcvItemImage);
        etItemDetail = findViewById(R.id.etItemDetail);
        etItemPrice = findViewById(R.id.etItemPrice);
        etSequenceNumber = findViewById(R.id.etSequenceNumber);
        tagViewTax = findViewById(R.id.tagViewTax);
        llTax = findViewById(R.id.llTax);
        etItemPriceWithoutOffer = findViewById(R.id.etItemPriceWithoutOffer);
        etOfferMessage = findViewById(R.id.etOfferMessage);
        ivItem = findViewById(R.id.ivItem);
        etProductName = findViewById(R.id.etProductName);
        etProductName.setFocusableInTouchMode(false);
        etProductName.setOnClickListener(this);
        switchVisibility = findViewById(R.id.switchMakeVisible);
        switchVisibility.setChecked(true);
        switchInStoke = findViewById(R.id.switchInStock);
        switchInStoke.setChecked(true);
        rcSpecification = findViewById(R.id.rcSpecification);
        rcSpecification.setNestedScrollingEnabled(false);
        rcSpecification.setLayoutManager(new LinearLayoutManager(this));
        specificationListAdapter = new SpecificationListAdapter(this, itemSpecificationFinalList);
        rcSpecification.setAdapter(specificationListAdapter);
        tvSwitch = findViewById(R.id.tvSwitch);
        tvSwitch.setText(getResources().getText(R.string.text_is_your_item_visible));
        tvSwitchStock = findViewById(R.id.tvSwitchStock);
        tvSwitchStock.setText(getResources().getText(R.string.text_item_out_of_stock));
        initRcvImage();
        findViewById(R.id.tvAddItemSpecification).setOnClickListener(this);
        imageHelper = new ImageHelper(this);
        tvCurrency.setText(preferenceHelper.getCurrency());
        tvCurrency2.setText(preferenceHelper.getCurrency());
        taxesList.addAll(getIntent().getParcelableArrayListExtra(Constant.TAXES));
        if (getIntent() != null && getIntent().getParcelableExtra(Constant.ITEM) != null) {
            item = getIntent().getParcelableExtra(Constant.ITEM);
            isNewItem = false;
            etItemName.setText(item.getName());
            etItemName.setTag(item.getNameList());
            etItemDetail.setText(item.getDetails());
            etItemDetail.setTag(item.getDetailsList());
            if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) {
                GlideApp.with(this).load(getIntent().getStringExtra(Constant.IMAGE_URL)).dontAnimate().into(ivItem);
            }
            etItemPriceWithoutOffer.setText(String.valueOf(item.getItemPriceWithoutOffer()));
            etOfferMessage.setText(item.getOfferMessageOrPercentage());
            switchVisibility.setChecked(item.isIsVisibleInStore());
            switchInStoke.setChecked(item.isItemInStock());
            etProductName.setText(getIntent().getStringExtra(Constant.NAME));
            etProductName.setOnClickListener(null);
            etProductName.setEnabled(false);
            productId = getIntent().getStringExtra(Constant.PRODUCT_ID);
            etItemPrice.setText(parseContent.decimalTwoDigitFormat.format(item.getPrice()));
            if (item.getSequenceNumber() != 0) {
                etSequenceNumber.setText(String.valueOf(item.getSequenceNumber()));
            }
            itemImageListForAdapter.addAll(item.getImageUrl());
            setViewEnable(false);
            getProductSpecificationGroup(productId, true);
            initRcvImage();
        } else {
            setViewEnable(true);
        }

        etItemDetail.setOnClickListener(this);
        etItemName.setOnClickListener(this);
        getImageSettings();
    }

    @SuppressLint("NotifyDataSetChanged")
    private void initRcvImage() {
        if (itemImageAdapter == null) {
            rcvItemImage.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
            itemImageAdapter = new ItemImageAdapter(this, itemImageListForAdapter, deleteItemImage, itemImageList);
            rcvItemImage.setNestedScrollingEnabled(false);
            rcvItemImage.setAdapter(itemImageAdapter);
        } else {
            itemImageAdapter.notifyDataSetChanged();
        }
    }

    /**
     * this method call a webservice for getProductSpecificationGroup and sub specification
     * which is add by store user
     *
     * @param productId       productId in string
     * @param isAllowToModify is true when store add new specification otherwise false
     */
    private void getProductSpecificationGroup(final String productId, final boolean isAllowToModify) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.PRODUCT_ID, productId);
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SpecificationGroupFroAddItemResponse> responseCall = apiInterface.getSpecificationGroupFroAddItem(map);
        responseCall.enqueue(new Callback<SpecificationGroupFroAddItemResponse>() {
            @Override
            public void onResponse(@NonNull Call<SpecificationGroupFroAddItemResponse> call, @NonNull Response<SpecificationGroupFroAddItemResponse> response) {
                if (response.isSuccessful()) {
                    productSpecificationGroupOriginalList.clear();
                    if (response.body().isSuccess()) {
                        productSpecificationGroupOriginalList.addAll(response.body().getSpecificationGroup());
                        if (itemSpecificationFinalList.isEmpty() && isAllowToModify) {
                            new MatchSpecification().execute(productSpecificationGroupOriginalList);
                        } else {
                            Utilities.hideCustomProgressDialog();
                        }
                    } else {
                        if (isAllowToModify) {
                            loadItemSpecificationAll();
                        }
                        Utilities.hideCustomProgressDialog();
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddItemActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<SpecificationGroupFroAddItemResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }


    /**
     * load all data if no productGroup found
     **/
    @SuppressLint("NotifyDataSetChanged")
    private void loadItemSpecificationAll() {
        for (ItemSpecification itemSpecification : item.getSpecifications()) {
            for (ProductSpecification productSpecification : itemSpecification.getList()) {
                productSpecification.setIsUserSelected(true);
            }
        }
        itemSpecificationFinalList.addAll(item.getSpecifications());
        specificationListAdapter.notifyDataSetChanged();
    }

    @Override
    protected void onResume() {
        super.onResume();
        makeFinalListItemAndSpecification();
    }

    /**
     * this method used to make final list of product item specification
     */
    @SuppressLint("NotifyDataSetChanged")
    private void makeFinalListItemAndSpecification() {
        if (Constant.itemSpecification != null) {
            if (Constant.updateSpecificationPosition == -1) {
                // for add new specification
                item.setSpecificationsUniqueIdCount(item.getSpecificationsUniqueIdCount() + 1);
                Constant.itemSpecification.setUniqueId(item.getSpecificationsUniqueIdCount());
                itemSpecificationFinalList.add(Constant.itemSpecification);
                for (ItemSpecification specification : itemSpecificationFinalList) {
                    if (Constant.itemSpecification.getModifierGroupId() != null
                            && Constant.itemSpecification.getModifierGroupId().equalsIgnoreCase(specification.getId())) {
                        specification.setParentAssociate(true);
                        break;
                    }
                }
            } else if (Constant.updateSpecificationPosition > -1 && itemSpecificationFinalList.size() > 0) {
                // for update current specification
                ItemSpecification updateSpecification = itemSpecificationFinalList.get(Constant.updateSpecificationPosition);
                if (updateSpecification.isParentAssociate() && Constant.itemSpecification.getType() != Constant.TYPE_SPECIFICATION_SINGLE) {
                    ArrayList<ItemSpecification> tempItemSpecificationsList = new ArrayList<>(itemSpecificationFinalList);
                    for (ItemSpecification specification : itemSpecificationFinalList) {
                        if (Constant.itemSpecification.getId().equalsIgnoreCase(specification.getModifierGroupId())) {
                            tempItemSpecificationsList.remove(specification);
                        }
                    }
                    for (int i = 0; i < tempItemSpecificationsList.size(); i++) {
                        if (Constant.itemSpecification.getId().equalsIgnoreCase(tempItemSpecificationsList.get(i).getId())) {
                            tempItemSpecificationsList.get(i).setParentAssociate(Constant.itemSpecification.isParentAssociate());
                            break;
                        }
                    }
                    itemSpecificationFinalList.clear();
                    itemSpecificationFinalList.addAll(tempItemSpecificationsList);
                } else {
                    itemSpecificationFinalList.remove(Constant.updateSpecificationPosition);
                    itemSpecificationFinalList.add(Constant.updateSpecificationPosition, Constant.itemSpecification);
                    Constant.updateSpecificationPosition = -1;
                }
            }
            specificationListAdapter.notifyDataSetChanged();
        }
        Constant.itemSpecification = null;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        if (PreferenceHelper.getPreferenceHelper(this).getIsStoreEditItem()) {
            if (isNewItem) {
                setToolbarSaveIcon(true);
                setToolbarEditIcon(false, 0);
            } else {
                setToolbarSaveIcon(false);
                setToolbarEditIcon(true, 0);
            }
        } else {
            setToolbarSaveIcon(false);
            setToolbarEditIcon(true, 0);
        }
        return true;
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.tvAddItemSpecification) {
            if (isNewItem || isEditable) {
                if (TextUtils.isEmpty(etProductName.getText().toString())) {
                    new CustomAlterDialog(this, null, getString(R.string.msg_plz_select_product_first)) {
                        @Override
                        public void btnOnClick(int btnId) {
                            dismiss();
                        }
                    }.show();
                } else if (productSpecificationGroupOriginalList.isEmpty()) {
                    new CustomAlterDialog(this, null, getString(R.string.msg_plz_specification_in_product)) {
                        @Override
                        public void btnOnClick(int btnId) {
                            dismiss();
                        }
                    }.show();
                } else {
                    openSpecificationGroupDialog();
                }
            }
        } else if (id == R.id.etProductName) {
            openProductDialog();
        } else if (id == R.id.etItemName) {
            addMultiLanguageDetail(etItemName.getHint().toString(), (List<String>) etItemName.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
                @Override
                public void onSave(List<String> detailList) {
                    etItemName.setTag(detailList);
                    item.setNameList((List<String>) etItemName.getTag());
                    etItemName.setText(item.getName());
                }
            });
        } else if (id == R.id.etItemDetail) {
            addMultiLanguageDetail(etItemDetail.getHint().toString(), (List<String>) etItemDetail.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
                @Override
                public void onSave(List<String> detailList) {
                    etItemDetail.setTag(detailList);
                    item.setDetailsList((List<String>) etItemDetail.getTag());
                    etItemDetail.setText(item.getDetails());
                }
            });
        }
    }

    private void openSpecificationGroupDialog() {
        itemSpecificationRestList.clear();
        itemSpecificationRestList.addAll(productSpecificationGroupOriginalList);

        if (itemSpecificationFinalList.size() == 1) {
            for (ItemSpecification specificationOriginal : productSpecificationGroupOriginalList) {
                if (itemSpecificationFinalList.get(0).getId().equalsIgnoreCase(specificationOriginal.getId())) {
                    itemSpecificationRestList.remove(specificationOriginal);
                    break;
                }
            }
        } else {
            int cntTotalAddedInList, cntMaxAddedInList, cntEligibleForParent = 0;
            boolean isAnyParentAvailable = false;
            boolean isAnyEligibleForParent = false;
            ArrayList<String> removeItemIds = new ArrayList<>();

            for (ItemSpecification specification : itemSpecificationFinalList) {
                if (specification.isParentAssociate()) {
                    isAnyParentAvailable = true;
                    break;
                }
            }

            for (ItemSpecification specification : itemSpecificationFinalList) {
                if (specification.getType() == Constant.TYPE_SPECIFICATION_SINGLE) {
                    cntEligibleForParent++;
                    if (!removeItemIds.contains(specification.getId())) {
                        removeItemIds.add(specification.getId());
                    }
                }
            }

            if (cntEligibleForParent > 0) {
                isAnyEligibleForParent = true;
            }

            for (ItemSpecification specificationOriginal : productSpecificationGroupOriginalList) {
                cntTotalAddedInList = cntMaxAddedInList = 0;
                ItemSpecification foundSpecification = null;
                for (ItemSpecification specification : itemSpecificationFinalList) {
                    if (specificationOriginal.getId().equalsIgnoreCase(specification.getId())) {
                        cntTotalAddedInList++;
                        if (specification.isAssociated() && foundSpecification == null) {
                            foundSpecification = specification;
                        }
                    }
                }

                if (cntTotalAddedInList == 1 && foundSpecification != null) {
                    for (ItemSpecification specification : itemSpecificationFinalList) {
                        if (foundSpecification.getModifierGroupId().equalsIgnoreCase(specification.getId())) {
                            cntMaxAddedInList = specification.getList().size() + 1;
                            break;
                        }
                    }
                } else if (cntTotalAddedInList == 1) {
                    cntMaxAddedInList = cntTotalAddedInList;
                } else if (cntTotalAddedInList > 0 && foundSpecification != null) {
                    for (ItemSpecification specification : itemSpecificationFinalList) {
                        if (foundSpecification.getModifierGroupId().equalsIgnoreCase(specification.getId())) {
                            cntMaxAddedInList = specification.getList().size() + 1;
                            break;
                        }
                    }
                } else {
                    cntMaxAddedInList = cntTotalAddedInList;
                }

                for (ItemSpecification specificationFinal : itemSpecificationFinalList) {
                    if (specificationOriginal.getId().equalsIgnoreCase(specificationFinal.getId())) {
                        if (isAnyParentAvailable && specificationFinal.isParentAssociate()) {
                            itemSpecificationRestList.remove(specificationOriginal);
                        } else if (!isAnyParentAvailable && isAnyEligibleForParent && cntEligibleForParent == itemSpecificationFinalList.size()) {
                            //itemSpecificationRestList.remove(specificationOriginal);
                        } else if (!isAnyParentAvailable && isAnyEligibleForParent && cntTotalAddedInList > 0 && removeItemIds.contains(specificationOriginal.getId())) {
                            itemSpecificationRestList.remove(specificationOriginal);
                        } else if (!isAnyEligibleForParent && cntTotalAddedInList > 0 && cntTotalAddedInList == cntMaxAddedInList) {
                            itemSpecificationRestList.remove(specificationOriginal);
                        } else if (isAnyEligibleForParent && cntTotalAddedInList > 1 && cntTotalAddedInList == cntMaxAddedInList) {
                            itemSpecificationRestList.remove(specificationOriginal);
                        }
                    }
                }
            }
        }

        if (!itemSpecificationRestList.isEmpty()) {
            CustomSelectSpecificationGroupDialog customSelectProductDialog = new CustomSelectSpecificationGroupDialog(this, itemSpecificationRestList) {
                @Override
                public void onItemSelected(ItemSpecification specificationGroupItem) {
                    gotoAddItemSpecification(specificationGroupItem, -1);
                    dismiss();
                }
            };
            customSelectProductDialog.show();
        } else {
            Utilities.showToast(this, getString(R.string.text_no_specifications_are_left_to_add));
        }
    }

    private void openProductDialog() {
        customSelectProductDialog = new CustomSelectProductDialog(this, CurrentProduct.getInstance().getProductDataList()) {
            @Override
            public void onProductItemSelected(Product product) {
                etProductName.setText(product.getName());
                productId = product.getId();
                GlideApp.with(AddItemActivity.this).load(IMAGE_URL + product.getImageUrl()).dontAnimate().into(ivItem);
                getProductSpecificationGroup(productId, false);
                dismiss();
            }
        };
        customSelectProductDialog.show();
    }

    @SuppressLint("NotifyDataSetChanged")
    private void setViewEnable(boolean enabled) {
        if (isNewItem) {
            etProductName.setEnabled(enabled);
        }
        etItemName.setEnabled(enabled);
        etItemDetail.setEnabled(enabled);
        etItemPrice.setEnabled(enabled);
        etSequenceNumber.setEnabled(enabled);
        switchVisibility.setEnabled(enabled);
        switchInStoke.setEnabled(enabled);
        specificationListAdapter.setClickableView(enabled);
        isEditable = enabled;
        itemImageAdapter.setIsEnable(enabled);
        itemImageAdapter.notifyDataSetChanged();
        if (enabled) {
            rcvItemImage.setVisibility(View.VISIBLE);
        } else if (itemImageListForAdapter.isEmpty()) {
            rcvItemImage.setVisibility(View.GONE);
        } else {
            rcvItemImage.setVisibility(View.VISIBLE);
        }
        etItemPriceWithoutOffer.setEnabled(enabled);
        etOfferMessage.setEnabled(enabled);
        tagViewTax.setTagMode(enabled ? TagView.MODE_MULTI_CHOICE : TagView.MODE_NORMAL);
        setTaxTags();
    }

    private void validate() {
        if (TextUtils.isEmpty(etProductName.getText().toString().trim())) {
            new CustomAlterDialog(this, null, getString(R.string.msg_product_category)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else if (TextUtils.isEmpty(etItemName.getText().toString().trim())) {
            new CustomAlterDialog(this, null, getString(R.string.msg_empty_item_title)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else if (!Utilities.isValidPrice(etItemPrice.getText().toString().trim())) {
            new CustomAlterDialog(this, null, getString(R.string.msg_empty_price)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else {
            addAndUpdateItem();
        }
    }

    /**
     * this method call a webservice for ADD and Update  item
     */
    private void addAndUpdateItem() {
        Utilities.showProgressDialog(this);
        for (ItemSpecification itemSpecification : itemSpecificationFinalList) {
            ArrayList<ProductSpecification> productSpecificationsFinal = new ArrayList<>();
            for (ProductSpecification productSpecification : itemSpecification.getList()) {
                if (productSpecification.isIsUserSelected()) {
                    productSpecificationsFinal.add(productSpecification);
                }
            }
            itemSpecification.setList(productSpecificationsFinal);
        }
        Item item = new Item();
        item.setStoreId(preferenceHelper.getStoreId());
        item.setServerToken(preferenceHelper.getServerToken());
        item.setProductId(productId);
        item.setNameList((List<String>) etItemName.getTag());
        item.setDetailsList((List<String>) etItemDetail.getTag());
        item.setPrice(Utilities.roundDecimal(Double.valueOf(etItemPrice.getText().toString())));
        item.setSequenceNumber(TextUtils.isEmpty(etSequenceNumber.getText().toString()) ? 0 : Long.parseLong(etSequenceNumber.getText().toString()));
        item.setItemInStock(switchInStoke.isChecked());
        item.setIsVisibleInStore(switchVisibility.isChecked());
        item.setSpecifications(itemSpecificationFinalList);
        item.setOfferMessageOrPercentage(etOfferMessage.getText().toString());
        item.setSpecificationsUniqueIdCount(this.item.getSpecificationsUniqueIdCount());
        if (Utilities.isDecimalAndGraterThenZero(etItemPriceWithoutOffer.getText().toString())) {
            item.setItemPriceWithoutOffer(Utilities.roundDecimal(Double.valueOf(etItemPriceWithoutOffer.getText().toString())));
        }
        ArrayList<String> taxes = new ArrayList<>();
        for (int i = 0; i < taxesList.size(); i++) {
            if (tagViewTax.getCheckedTagsPosition().contains(i)) {
                taxes.add(taxesList.get(i).getId());
            }
        }
        item.setTaxes(taxes);
        Call<AddOrUpdateItemResponse> call;
        if (isNewItem) {
            call = ApiClient.getClient().create(ApiInterface.class).addItem(ApiClient.makeGSONRequestBody(item));
        } else {
            item.setItemId(this.item.getId());
            call = ApiClient.getClient().create(ApiInterface.class).updateItem(ApiClient.makeGSONRequestBody(item));
        }
        call.enqueue(new Callback<AddOrUpdateItemResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddOrUpdateItemResponse> call, @NonNull Response<AddOrUpdateItemResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        if (itemImageList.size() > 0) {
                            addAndUpdateItemImage(response.body().getItem().getId());
                        } else if (deleteItemImage.size() > 0 && !isNewItem) {
                            deleteItemImage();
                        } else {
                            Utilities.removeProgressDialog();
                            onBackPressed();
                        }
                    } else {
                        Utilities.removeProgressDialog();
                        ParseContent.getInstance().showErrorMessage(AddItemActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.removeProgressDialog();
                    Utilities.showHttpErrorToast(response.code(), AddItemActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddOrUpdateItemResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("Exception", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call a webservice for ADD and Update  item image
     */
    private void addAndUpdateItemImage(String itemId) {
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getServerToken()));
        map.put(Constant.ITEM_ID, ApiClient.makeTextRequestBody(itemId));
        Call<AddOrUpdateItemResponse> call;
        if (isNewItem) {
            call = ApiClient.getClient().create(ApiInterface.class).addItemImage(map, ApiClient.addMultipleImage(itemImageListForAdapter));
        } else {
            call = ApiClient.getClient().create(ApiInterface.class).addItemImage(map, ApiClient.addMultipleImage(itemImageList));
        }
        call.enqueue(new Callback<AddOrUpdateItemResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddOrUpdateItemResponse> call, @NonNull Response<AddOrUpdateItemResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        if (isNewItem) {
                            itemImageList.clear();
                            itemImageList.addAll(response.body().getItem().getImageUrl());
                            onBackPressed();
                        } else if (deleteItemImage.size() > 0) {
                            deleteItemImage();
                        } else {
                            onBackPressed();
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddItemActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddItemActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddOrUpdateItemResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @SuppressLint("NotifyDataSetChanged")
    public void deleteSpecification(ItemSpecification itemSpecification) {
        if (itemSpecification.isParentAssociate()) {
            new CustomAlterDialog(this, getString(R.string.text_attention), getString(R.string.msg_already_modifier_associated_delete),
                    true, getString(R.string.text_remove)) {
                @Override
                public void btnOnClick(int btnId) {
                    if (btnId == R.id.btnPositive) {
                        ArrayList<ItemSpecification> tempItemSpecificationsList = new ArrayList<>(itemSpecificationFinalList);
                        tempItemSpecificationsList.remove(itemSpecification);
                        for (ItemSpecification specification : itemSpecificationFinalList) {
                            if (itemSpecification.getId().equalsIgnoreCase(specification.getModifierGroupId())) {
                                tempItemSpecificationsList.remove(specification);
                            }
                        }
                        itemSpecificationFinalList.clear();
                        itemSpecificationFinalList.addAll(tempItemSpecificationsList);

                        specificationListAdapter.notifyDataSetChanged();
                    }
                    dismiss();
                }
            }.show();
        } else if (itemSpecification.isAssociated()) {
            int cntChildCount = 0;
            for (ItemSpecification specification : itemSpecificationFinalList) {
                if (itemSpecification.getModifierGroupId().equalsIgnoreCase(specification.getModifierGroupId())) {
                    cntChildCount++;
                }
            }

            if (cntChildCount == 1) {
                for (ItemSpecification specification : itemSpecificationFinalList) {
                    if (itemSpecification.getModifierGroupId().equalsIgnoreCase(specification.getId())) {
                        specification.setParentAssociate(false);
                        break;
                    }
                }
            }
            itemSpecificationFinalList.remove(itemSpecification);
            specificationListAdapter.notifyDataSetChanged();
        } else {
            itemSpecificationFinalList.remove(itemSpecification);
            specificationListAdapter.notifyDataSetChanged();
        }
    }

    public void gotoAddItemSpecification(ItemSpecification specificationGroupItem, int position) {
        Constant.updateSpecificationPosition = position;

        Bundle bundle = new Bundle();
        bundle.putString(Constant.FRAGMENT_TYPE, Constant.FRAGMENT_ADD_ITEM_SPECIFICATION);
        bundle.putString(Constant.TOOLBAR_TITLE, getString(R.string.text_add_item_specification));
        if (position != -1) {
            bundle.putParcelable(Constant.SPECIFICATIONS, itemSpecificationFinalList.get(position));
            bundle.putParcelable(Constant.PRODUCT_SPECIFICATION, null);
        } else {
            bundle.putParcelable(Constant.SPECIFICATIONS, null);
            bundle.putParcelable(Constant.PRODUCT_SPECIFICATION, specificationGroupItem);
        }
        bundle.putParcelableArrayList(Constant.PRODUCT_SPECIFICATION_LIST, itemSpecificationFinalList);

        Intent intent = new Intent(this, AddItemSpecificationActivity.class);
        intent.putExtras(bundle);
        startActivity(intent);
        overridePendingTransition(R.anim.enter, R.anim.exit);
    }

    private void showPictureDialog() {
        new CustomPhotoDialog(this) {
            @Override
            public void gallery() {
                choosePhotoFromGallery();
            }

            @Override
            public void camera() {
                takePhotoFromCameraPermission();
            }
        }.show();
    }

    private void choosePhotoFromGallery() {
        if (ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_CHOOSE_PHOTO);
        } else {
            Intent galleryIntent = new Intent();
            galleryIntent.setType("image/*");
            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(galleryIntent, Constant.PERMISSION_CHOOSE_PHOTO);
        }
    }

    private void takePhotoFromCameraPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_TAKE_PHOTO);
        } else {
            takePhotoFromCamera();
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        uri = imageHelper.createTakePictureUri();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        startActivityForResult(intent, Constant.PERMISSION_TAKE_PHOTO);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        switch (requestCode) {
            case Constant.PERMISSION_CHOOSE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        if (ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                            ActivityCompat.requestPermissions(this, new String[]{Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Constant.PERMISSION_CHOOSE_PHOTO);
                        } else {
                            Intent galleryIntent = new Intent();
                            galleryIntent.setType("image/*");
                            galleryIntent.setAction(Intent.ACTION_GET_CONTENT);
                            startActivityForResult(galleryIntent, Constant.PERMISSION_CHOOSE_PHOTO);
                        }
                    }
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        takePhotoFromCamera();
                    }
                }
                break;
            default:
                break;
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case Constant.PERMISSION_CHOOSE_PHOTO:
                    if (data != null) {
                        uri = data.getData();
                        if (Utilities.checkImageFileType(AddItemActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getItemImageMaxWidth(), imageSetting.getItemImageMaxHeight(),
                                    imageSetting.getItemImageMinWidth(), imageSetting.getItemImageMinHeight(), imageSetting.getItemImageRatio())) {
                                setImage(uri);
                            } else {
                                beginCrop(uri);
                            }
                        }
                    }
                    break;
                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        if (Utilities.checkImageFileType(AddItemActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getItemImageMaxWidth(), imageSetting.getItemImageMaxHeight(),
                                    imageSetting.getItemImageMinWidth(), imageSetting.getItemImageMinHeight(), imageSetting.getItemImageRatio())) {
                                setImage(uri);
                            } else {
                                beginCrop(uri);
                            }
                        }
                    }
                    break;
                case Crop.REQUEST_CROP:
                    setImage(Crop.getOutput(data));
                    break;
                default:
                    break;
            }
        }
    }

    private void setImage(final Uri uri) {
        date = new Date();
        imageName = simpleDateFormat.format(date);
        final String path = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), uri).getPath();
        new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
            if (isNewItem) {
                GlideApp.with(AddItemActivity.this).load(uri).error(R.drawable.icon_default_profile).override(300, 300).into(ivItem);
            }
            itemImageList.add(compressionImagePath);
            itemImageListForAdapter.add(compressionImagePath);
            initRcvImage();
        }).execute(path);
    }

    /**
     * this method call a webservice for delete item image in list
     */
    private void deleteItemImage() {
        Item deleteItem = new Item();
        deleteItem.setServerToken(preferenceHelper.getServerToken());
        deleteItem.setImageUrl(deleteItemImage);
        deleteItem.setId(item.getId());
        deleteItem.setStoreId(preferenceHelper.getStoreId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteItemImage((ApiClient.makeGSONRequestBody(deleteItem)));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddItemActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddItemActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    public void addItemImage() {
        if (isNewItem || isEditable) {
            showPictureDialog();
        }
    }

    private void getImageSettings() {
        Utilities.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ImageSettingsResponse> call = apiInterface.getImageSettings();
        call.enqueue(new Callback<ImageSettingsResponse>() {
            @Override
            public void onResponse(@NonNull Call<ImageSettingsResponse> call, @NonNull Response<ImageSettingsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        imageSetting = response.body().getImageSetting();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ImageSettingsResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        Uri outputUri = Uri.fromFile(imageHelper.createImageFile());
        Crop.of(sourceUri, outputUri).withAspect(imageSetting.getItemImageMaxWidth(), imageSetting.getItemImageMaxHeight()).checkValidIMGCrop(true).setCropData(imageSetting.getItemImageMaxWidth(), imageSetting.getItemImageMaxHeight(), imageSetting.getItemImageMinWidth(), imageSetting.getItemImageMinHeight(), imageSetting.getItemImageRatio()).start(this);
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, false);
        addDetailInMultiLanguageDialog.show();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ivEditMenu) {
            isEditable = true;
            setViewEnable(true);
            setToolbarEditIcon(false, 0);
            setToolbarSaveIcon(true);
            specificationListAdapter.notifyDataSetChanged();
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            if (isNewItem || isEditable) {
                validate();
            }
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    private void setTaxTags() {
        ArrayList<TaxesDetail> taxes = new ArrayList<>();
        if (item.getTaxesDetails() != null) {
            taxes.addAll(item.getTaxesDetails());
        }
        if (taxesList.isEmpty()) {
            llTax.setVisibility(View.GONE);
            return; // there is no taxes.
        } else {
            llTax.setVisibility(View.VISIBLE);
        }
        ArrayList<String> taxTags = new ArrayList<String>();
        ArrayList<Integer> selectedTags = new ArrayList<>();
        for (int i = 0; i < taxesList.size(); i++) {
            TaxesDetail taxesDetail = taxesList.get(i);
            for (TaxesDetail selected : taxes) {
                if (selected.getId().equals(taxesDetail.getId())) {
                    selectedTags.add(i);
                }
            }
            taxTags.add(Utilities.getDetailStringFromList(taxesDetail.getTaxName(), Language.getInstance().getStoreLanguageIndex()) + " " + taxesDetail.getTax() + "%");
        }
        tagViewTax.cleanTags();
        tagViewTax.setTags(taxTags);
        new Handler().postDelayed(() -> tagViewTax.setCheckTag(selectedTags), 300);
    }

    /**
     * Match specification from particular item and product specification and
     * it make a new list of specification
     */
    @SuppressLint("StaticFieldLeak")
    private class MatchSpecification extends AsyncTask<ArrayList<ItemSpecification>, Void, ArrayList<ItemSpecification>> {

        @SafeVarargs
        @Override
        protected final ArrayList<ItemSpecification> doInBackground(ArrayList<ItemSpecification>... arrayLists) {
            ArrayList<ProductSpecification> matchList = new ArrayList<>();
            ArrayList<ProductSpecification> tempList = null;
            for (ItemSpecification itemSpecification : item.getSpecifications()) {
                for (ItemSpecification productSpecification : arrayLists[0]) {
                    if (TextUtils.equals(itemSpecification.getId(), productSpecification.getId())) {
                        matchList.clear();
                        for (ProductSpecification productSubSpecification : productSpecification.getList()) {
                            tempList = new ArrayList<>(productSpecification.getList());
                            for (ProductSpecification itemSubSpecification : itemSpecification.getList()) {
                                itemSubSpecification.setIsUserSelected(true);
                                if (TextUtils.equals(productSubSpecification.getId(), itemSubSpecification.getId())) {
                                    matchList.add(productSubSpecification);
                                    break;
                                }
                            }
                        }
                        if (tempList != null) {
                            for (ProductSpecification match : matchList) {
                                tempList.remove(match);
                            }
                            itemSpecification.getList().addAll(tempList);
                        }
                    }
                }
            }
            return item.getSpecifications();
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void onPostExecute(ArrayList<ItemSpecification> itemSpecifications) {
            super.onPostExecute(itemSpecifications);
            itemSpecificationFinalList.addAll(itemSpecifications);

            specificationListAdapter.notifyDataSetChanged();
            Utilities.hideCustomProgressDialog();
        }
    }
}
