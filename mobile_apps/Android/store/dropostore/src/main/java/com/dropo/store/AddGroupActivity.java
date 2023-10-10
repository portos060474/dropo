package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.dropo.store.adapter.ProductsAdapter;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.CategoryTime;
import com.dropo.store.models.datamodel.ImageSetting;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.ProductGroup;
import com.dropo.store.models.responsemodel.ImageSettingsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.ProductListResponse;
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

import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import com.soundcloud.android.crop.Crop;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddGroupActivity extends BaseActivity {

    private ImageView ivProductLogo;
    private TextInputLayout inputLayoutProName;
    private TextInputEditText etGroupName, etGroupSequenceNumber;
    private boolean isNewItem = true;
    private ProductGroup productGroup;
    private List<Product> productList;
    private List<Product> selectedProductList;
    private List<String> selectedProductIds;
    private Uri uri;
    private ImageHelper imageHelper;
    private ImageSetting imageSetting;
    private String currentPhotoPath;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private RecyclerView rcvProducts;
    private ProductsAdapter productsAdapter;
    private final ArrayList<CategoryTime> categoryTimeList = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_group);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_add_category));
        ivProductLogo = findViewById(R.id.ivProductLogo);
        inputLayoutProName = findViewById(R.id.inputLayoutProName);
        etGroupName = findViewById(R.id.etGroupName);
        etGroupSequenceNumber = findViewById(R.id.etGroupSequenceNumber);
        rcvProducts = findViewById(R.id.rcvProducts);

        findViewById(R.id.ivImageSelect).setOnClickListener(this);
        findViewById(R.id.tvCategoryTiming).setOnClickListener(this);

        imageHelper = new ImageHelper(this);
        productList = new ArrayList<>();
        selectedProductList = new ArrayList<>();
        selectedProductIds = new ArrayList<>();

        initRcvProductGroups();

        if (getIntent() != null && getIntent().getParcelableExtra(Constant.PRODUCT_GROUP) != null) {
            productGroup = getIntent().getParcelableExtra(Constant.PRODUCT_GROUP);
            Glide.with(this)
                    .load(IMAGE_URL + productGroup.getImageUrl())
                    .placeholder(R.drawable.placeholder)
                    .fallback(R.drawable.placeholder)
                    .into(ivProductLogo);
            etGroupName.setText(productGroup.getName());
            etGroupSequenceNumber.setText(String.valueOf(productGroup.getSequenceNumber()));
            etGroupName.setTag(productGroup.getNameList());
            selectedProductIds.addAll(productGroup.getProductIds());
            isNewItem = false;
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_update_category));
            if (productGroup.getCategoryTime() != null && !productGroup.getCategoryTime().isEmpty()) {
                categoryTimeList.clear();
                categoryTimeList.addAll(productGroup.getCategoryTime());
            } else {
                addEmptyDataForCategoryTiming();
            }
        } else {
            addEmptyDataForCategoryTiming();
        }

        etGroupName.setOnClickListener(v -> addMultiLanguageDetail(etGroupName.getHint().toString(), (List<String>) etGroupName.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
            @Override
            public void onSave(List<String> detailList) {
                etGroupName.setTag(detailList);
                etGroupName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
            }
        }));

        getImageSettings();
    }

    /**
     * add day timing for empty data
     */
    private void addEmptyDataForCategoryTiming() {
        categoryTimeList.clear();
        for (int i = 0; i < 7; i++) {
            categoryTimeList.add(new CategoryTime(i));
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, R.drawable.filter_store);
        setToolbarSaveIcon(true);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivSaveMenu) {
            validate();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    private void getProductGroupList() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ProductListResponse> call = apiInterface.getGroupProductList(map);
        call.enqueue(new Callback<ProductListResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ProductListResponse> call, @NonNull Response<ProductListResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        productList = response.body().getProducts();
                        selectedProductList.clear();
                        for (Product product : productList) {
                            if (selectedProductIds.contains(product.getId())) {
                                product.setSelected(true);
                                selectedProductList.add(product);
                            }
                        }

                        productsAdapter.setProducts(productList);
                        productsAdapter.notifyDataSetChanged();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ProductListResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable("ADD_GROUP_ACTIVITY", t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvProductGroups() {
        rcvProducts.setLayoutManager(new LinearLayoutManager(this));
        productsAdapter = new ProductsAdapter(productList);
        rcvProducts.setAdapter(productsAdapter);
    }

    private String getProducts() {
        String products = "";
        for (Product product1 : selectedProductList) {
            if (TextUtils.isEmpty(products)) {
                products += product1.getId();
            } else {
                products += "," + product1.getId();
            }
        }
        return products;
    }


    /**
     * this method check that all data which selected by store user is valid or not
     */
    private void validate() {
        clearError();
        selectedProductList.clear();
        for (Product product : productList) {
            if (product.isSelected()) selectedProductList.add(product);
        }
        if (etGroupName.getTag() == null) {
            inputLayoutProName.setError(getString(R.string.msg_empty_group_name));
        } else if (selectedProductList.isEmpty()) {
            Utilities.showToast(this, getString(R.string.msg_empty_product_groups));
        } else {
            Call<IsSuccessResponse> call;
            if (!isNewItem) {
                if (!TextUtils.isEmpty(currentPhotoPath)) {
                    call = ApiClient.getClient().create(ApiInterface.class).updateProductGroup(getMapWithData(), ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL));
                } else {
                    call = ApiClient.getClient().create(ApiInterface.class).updateProductGroup(getMapWithData());
                }
            } else {
                if (!TextUtils.isEmpty(currentPhotoPath)) {
                    call = ApiClient.getClient().create(ApiInterface.class).addProductGroup(getMapWithData(), ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL));
                } else {
                    call = ApiClient.getClient().create(ApiInterface.class).addProductGroup(getMapWithData());
                }

            }
            addNEditGroup(call);
        }
    }

    public void clearError() {
        inputLayoutProName.setError(null);
    }


    private HashMap<String, RequestBody> getMapWithData() {
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getServerToken()));
        map.put(Constant.NAME, ApiClient.makeTextRequestBody(new JSONArray((List<String>) etGroupName.getTag())));

        map.put(Constant.PRODUCT_IDS, ApiClient.makeTextRequestBody(getProducts()));
        map.put(Constant.SEQUENCE_NUMBER, ApiClient.makeTextRequestBody(TextUtils.isEmpty(etGroupSequenceNumber.getText().toString()) ? 0 : Long.parseLong(etGroupSequenceNumber.getText().toString())));

        map.put(Constant.CATEGORY_TIME, ApiClient.makeTextRequestBody(ApiClient.JSONResponse(categoryTimeList)));

        if (!isNewItem) {
            map.put(Constant.PRODUCT_GROUP_ID, ApiClient.makeTextRequestBody(String.valueOf(productGroup.getId())));
        }
        return map;
    }

    /**
     * this method call a webservice for Add and Update Product in Store
     */
    private void addNEditGroup(Call<IsSuccessResponse> call) {
        Utilities.showProgressDialog(this);

        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        parseContent.showMessage(AddGroupActivity.this, response.body().getStatusPhrase());
                        finishAfterTransition();
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddGroupActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddGroupActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.ivImageSelect) {
            showPictureDialog();
        } else if (id == R.id.tvCategoryTiming) {
            goToCategoryTimeActivity();
        }
    }

    /**
     * Go to category time activity.
     */
    public void goToCategoryTimeActivity() {
        Intent intent = new Intent(this, CategoryTimeActivity.class);
        intent.putExtra(Constant.CATEGORY_TIME, categoryTimeList);
        activityResultLauncher.launch(intent);
    }

    final private ActivityResultLauncher<Intent> activityResultLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(), result -> {
                if (result.getResultCode() == Activity.RESULT_OK) {
                    Intent data = result.getData();
                    if (data != null) {
                        ArrayList<CategoryTime> categoryTimeArrayList = data.getParcelableArrayListExtra(Constant.CATEGORY_TIME);
                        if (categoryTimeArrayList != null) {
                            categoryTimeList.clear();
                            categoryTimeList.addAll(categoryTimeArrayList);
                        }
                    }
                }
            });

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
                        if (Utilities.checkImageFileType(AddGroupActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getDeliveryImageMaxWidth(), imageSetting.getDeliveryImageMaxHeight(), imageSetting.getDeliveryImageMinWidth(), imageSetting.getDeliveryImageMinHeight(), imageSetting.getDeliveryImageRatio())) {
                                setImage(uri);
                            } else {
                                beginCrop(uri);
                            }
                        }
                    }
                    break;
                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        if (Utilities.checkImageFileType(AddGroupActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getDeliveryImageMaxWidth(), imageSetting.getDeliveryImageMaxHeight(), imageSetting.getDeliveryImageMinWidth(), imageSetting.getDeliveryImageMinHeight(), imageSetting.getDeliveryImageRatio())) {
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
        currentPhotoPath = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), uri).getPath();
        new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
            currentPhotoPath = compressionImagePath;
            GlideApp.with(AddGroupActivity.this)
                    .load(uri)
                    .error(R.drawable.icon_default_profile)
                    .into(ivProductLogo);
        }).execute(currentPhotoPath);
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
                        getProductGroupList();
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
        Crop.of(sourceUri, outputUri).withAspect(imageSetting.getDeliveryImageMaxWidth(), imageSetting.getDeliveryImageMaxHeight()).checkValidIMGCrop(true).setCropData(imageSetting.getDeliveryImageMaxWidth(), imageSetting.getDeliveryImageMaxHeight(), imageSetting.getDeliveryImageMinWidth(), imageSetting.getDeliveryImageMinHeight(), imageSetting.getDeliveryImageRatio()).start(this);
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, false);
        addDetailInMultiLanguageDialog.show();
    }
}
