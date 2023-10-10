package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.bumptech.glide.Glide;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.ImageSetting;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.ImageSettingsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
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

import org.json.JSONArray;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddProductActivity extends BaseActivity {

    private TextInputEditText etProductName, etProductDetail, etProSequenceNumber;
    private ImageView ivProductLogo;
    private SwitchCompat switchMakeVisible;
    private boolean isNewItem = true, isEditable;
    private Uri uri;
    private Product product;
    private ImageHelper imageHelper;
    private ImageSetting imageSetting;
    private String currentPhotoPath;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private CustomTextView tvSwitch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_product);

        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, android.R.color.transparent);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_Subcategory));

        ivProductLogo = findViewById(R.id.ivProductLogo);
        etProductName = findViewById(R.id.etProName);
        etProductDetail = findViewById(R.id.etProDetail);
        etProSequenceNumber = findViewById(R.id.etProSequenceNumber);
        switchMakeVisible = findViewById(R.id.switchMakeVisible);
        tvSwitch = findViewById(R.id.tvSwitch);
        tvSwitch.setText(getResources().getString(R.string.text_show_subcategory));
        switchMakeVisible.setChecked(true);
        imageHelper = new ImageHelper(this);
        if (getIntent() != null && getIntent().getParcelableExtra(Constant.PRODUCT_ITEM) != null) {
            product = getIntent().getParcelableExtra(Constant.PRODUCT_ITEM);
            Glide.with(this).load(IMAGE_URL + product.getImageUrl()).into(ivProductLogo);
            etProductName.setText(product.getName());
            etProductName.setTag(product.getNameList());
            etProductDetail.setText(product.getDetails());
            if (product.getSequenceNumber() != 0L) {
                etProSequenceNumber.setText(String.valueOf(product.getSequenceNumber()));
            }
            switchMakeVisible.setChecked(product.isIsVisibleInStore());
            isNewItem = false;
            etProductName.setEnabled(false);
            etProductDetail.setEnabled(false);
            switchMakeVisible.setEnabled(false);
            etProSequenceNumber.setEnabled(false);

        }
        etProductName.setOnClickListener(v -> addMultiLanguageDetail(etProductName.getHint().toString(), (List<String>) etProductName.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
            @Override
            public void onSave(List<String> detailList) {
                etProductName.setTag(detailList);
                etProductName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));

            }
        }));
        getImageSettings();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        if (isNewItem) {
            isEditable = true;
            setToolbarEditIcon(false, 0);
            setToolbarSaveIcon(true);
        } else {
            setToolbarEditIcon(true, 0);
            setToolbarSaveIcon(false);
        }

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.ivEditMenu) {
            isEditable = true;
            setToolbarEditIcon(false, 0);
            setToolbarSaveIcon(true);
            etProductName.setEnabled(true);
            etProductDetail.setEnabled(true);
            switchMakeVisible.setEnabled(true);
            etProSequenceNumber.setEnabled(true);
            return true;
        } else if (itemId == R.id.ivSaveMenu) {
            validate();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * this method check that all data which selected by store user is valid or not
     */
    private void validate() {
        if (etProductName.getTag() == null) {
            etProductName.setError(getString(R.string.msg_empty_product_name));
        } else {
            Call<IsSuccessResponse> call;
            if (isEditable && !isNewItem) {
                if (!TextUtils.isEmpty(currentPhotoPath)) {
                    call = ApiClient.getClient().create(ApiInterface.class).updateProduct(getMapWithData(), ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL));
                } else {
                    call = ApiClient.getClient().create(ApiInterface.class).updateProduct(getMapWithData());
                }
            } else {
                if (!TextUtils.isEmpty(currentPhotoPath)) {
                    call = ApiClient.getClient().create(ApiInterface.class).addProduct(getMapWithData(), ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL));
                } else {
                    call = ApiClient.getClient().create(ApiInterface.class).addProduct(getMapWithData());
                }

            }
            addNEditProduct(call);
        }
    }

    private HashMap<String, RequestBody> getMapWithData() {
        HashMap<String, RequestBody> map = new HashMap<>();
        map.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getStoreId()));
        map.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getPreferenceHelper(this).getServerToken()));
        map.put(Constant.NAME, ApiClient.makeTextRequestBody(new JSONArray((List<String>) etProductName.getTag())));
        map.put(Constant.DETAILS, ApiClient.makeTextRequestBody(etProductDetail.getText().toString().trim()));
        map.put(Constant.IS_VISIBLE_IN_STORE, ApiClient.makeTextRequestBody(String.valueOf(switchMakeVisible.isChecked())));
        map.put(Constant.SEQUENCE_NUMBER, ApiClient.makeTextRequestBody(TextUtils.isEmpty(etProSequenceNumber.getText().toString()) ? 0 : Long.parseLong(etProSequenceNumber.getText().toString())));

        if (isEditable && !isNewItem) {
            map.put(Constant.PRODUCT_ID, ApiClient.makeTextRequestBody(String.valueOf(product.getId())));
        }
        return map;
    }

    /**
     * this method call a webservice for Add and Update Product in Store
     *
     * @param call call
     */
    private void addNEditProduct(Call<IsSuccessResponse> call) {
        Utilities.showProgressDialog(this);

        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        finishAfterTransition();
                    } else {
                        ParseContent.getInstance().showErrorMessage(AddProductActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), AddProductActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
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
                        if (Utilities.checkImageFileType(AddProductActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getProductImageMaxWidth(), imageSetting.getProductImageMaxHeight(), imageSetting.getProductImageMinWidth(), imageSetting.getProductImageMinHeight(), imageSetting.getProductImageRatio())) {
                                setImage(uri);
                            } else {
                                beginCrop(uri);
                            }
                        }
                    }
                    break;
                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        if (Utilities.checkImageFileType(AddProductActivity.this, imageSetting.getImageType(), uri)) {
                            if (Utilities.checkIMGSize(uri, imageSetting.getProductImageMaxWidth(), imageSetting.getProductImageMaxHeight(), imageSetting.getProductImageMinWidth(), imageSetting.getProductImageMinHeight(), imageSetting.getProductImageRatio())) {
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
            GlideApp.with(AddProductActivity.this).load(uri).error(R.drawable.icon_default_profile).into(ivProductLogo);
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
        Crop.of(sourceUri, outputUri).withAspect(imageSetting.getProductImageMaxWidth(), imageSetting.getProductImageMaxHeight()).checkValidIMGCrop(true).setCropData(imageSetting.getProductImageMaxWidth(), imageSetting.getProductImageMaxHeight(), imageSetting.getProductImageMinWidth(), imageSetting.getProductImageMinHeight(), imageSetting.getProductImageRatio()).start(this);
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, false);
        addDetailInMultiLanguageDialog.show();
    }
}