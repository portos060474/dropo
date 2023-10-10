package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.DocumentAdapter;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.Documents;
import com.dropo.store.models.responsemodel.AllDocumentsResponse;
import com.dropo.store.models.responsemodel.DocumentResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageCompression;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomEditText;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DocumentActivity extends BaseActivity {

    private BottomSheetDialog documentDialog;
    private Uri uri;
    private ImageView ivDocumentImage;
    private TextInputLayout tilExpireDate, tilNumberId;
    private CustomEditText etIdNumber, etExpireDate;
    private TextView tvDocumentTitle;
    private RecyclerView rcvDocument;
    private CustomButton btnDocumentSubmit;
    private String expireDate;
    private List<Documents> documentList;
    private boolean isApplicationStart;
    private DocumentAdapter documentAdapter;
    private PreferenceHelper preferenceHelper;
    private ImageHelper imageHelper;
    private String currentPhotoPath;
    private View rlEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document);
        imageHelper = new ImageHelper(this);
        preferenceHelper = PreferenceHelper.getPreferenceHelper(this);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_document));
        toolbar.setNavigationOnClickListener(v -> onBackPressed());
        rcvDocument = findViewById(R.id.rcvDocument);
        btnDocumentSubmit = findViewById(R.id.btnDocumentSubmit);
        rlEmpty = findViewById(R.id.rlEmpty);

        btnDocumentSubmit.setOnClickListener(this);
        getAllDocument();
        documentList = new ArrayList<>();
        getExtraData();
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
        if (view.getId() == R.id.btnDocumentSubmit) {
            submitDocument();
        }
    }

    private void showPhotoSelectionDialog() {
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
                        choosePhotoFromGallery();
                    }
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (grantResults.length > 0) {
                    if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        takePhotoFromCameraPermission();
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
        switch (requestCode) {
            case Constant.PERMISSION_CHOOSE_PHOTO:
                if (data != null) {
                    uri = data.getData();
                    setWithOutCropImage(uri);
                }
                break;
            case Constant.PERMISSION_TAKE_PHOTO:
                if (uri != null && resultCode == RESULT_OK) {
                    setWithOutCropImage(uri);
                }
                break;
            default:
                break;
        }
    }

    private void setWithOutCropImage(final Uri source) {
        if (documentDialog != null && documentDialog.isShowing()) {
            currentPhotoPath = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), source).getPath();
            new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
                currentPhotoPath = compressionImagePath;
                GlideApp.with(DocumentActivity.this).load(source).into(ivDocumentImage);
            }).execute(currentPhotoPath);
        }
    }


    private void openDocumentUploadDialog(final int position) {
        if (documentDialog != null && documentDialog.isShowing()) {
            return;
        }

        final Documents document = documentList.get(position);

        documentDialog = new BottomSheetDialog(this);
        documentDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        documentDialog.setContentView(R.layout.dialog_document_upload);
        ivDocumentImage = documentDialog.findViewById(R.id.ivDialogDocumentImage);
        etIdNumber = documentDialog.findViewById(R.id.etIdNumber);
        etExpireDate = documentDialog.findViewById(R.id.etExpireDate);
        tilExpireDate = documentDialog.findViewById(R.id.tilExpireDate);
        tilNumberId = documentDialog.findViewById(R.id.tilNumberId);
        tvDocumentTitle = documentDialog.findViewById(R.id.tvDialogAlertTitle);
        tvDocumentTitle.setText(document.getDocumentDetails().getDocumentName());
        GlideApp.with(this).load(IMAGE_URL + document.getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).into(ivDocumentImage);
        expireDate = "";
        if (document.getDocumentDetails().isIsExpiredDate()) {
            tilExpireDate.setVisibility(View.VISIBLE);
            String date = "";
            try {
                if (!TextUtils.isEmpty(document.getExpiredDate())) {
                    expireDate = document.getExpiredDate();
                    date = parseContent.dateFormat.format(parseContent.webFormat.parse(document.getExpiredDate()));
                    etExpireDate.setText(date);
                } else {
                    etExpireDate.setText(date);
                }
            } catch (ParseException e) {
                Utilities.handleThrowable(TAG, e);
            }
        } else {
            tilExpireDate.setVisibility(View.GONE);
        }
        if (document.getDocumentDetails().isIsUniqueCode()) {
            tilNumberId.setVisibility(View.VISIBLE);
            etIdNumber.setText(document.getUniqueCode());
        } else {
            tilNumberId.setVisibility(View.GONE);
        }

        documentDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            if (TextUtils.isEmpty(etExpireDate.getText().toString()) && document.getDocumentDetails().isIsExpiredDate()) {
                Utilities.showToast(DocumentActivity.this, getResources().getString(R.string.msg_plz_enter_document_expire_date));
            } else if (TextUtils.isEmpty(etIdNumber.getText().toString().trim()) && document.getDocumentDetails().isIsUniqueCode()) {
                etIdNumber.setError(getResources().getString(R.string.msg_plz_enter_document_unique_code));
            } else if (TextUtils.isEmpty(document.getImageUrl()) && TextUtils.isEmpty(currentPhotoPath)) {
                Utilities.showToast(DocumentActivity.this, getResources().getString(R.string.msg_plz_select_document_image));
            } else {
                documentDialog.dismiss();
                documentUpload(position);
            }
        });

        documentDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> documentDialog.dismiss());
        ivDocumentImage.setOnClickListener(view -> showPhotoSelectionDialog());
        etExpireDate.setOnClickListener(view -> openDatePickerDialog());

        documentDialog.setOnDismissListener(dialog -> getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN));
        WindowManager.LayoutParams params = documentDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        documentDialog.getWindow().setAttributes(params);
        documentDialog.setCancelable(false);
        documentDialog.show();
    }

    private void openDatePickerDialog() {
        final Calendar calendar = Calendar.getInstance();
        final int currentYear = calendar.get(Calendar.YEAR);
        final int currentMonth = calendar.get(Calendar.MONTH);
        final int currentDate = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog.OnDateSetListener onDateSetListener = (view, year, monthOfYear, dayOfMonth) -> {

        };

        final DatePickerDialog datePickerDialog = new DatePickerDialog(this, onDateSetListener, currentYear, currentMonth, currentDate);
        datePickerDialog.setButton(DialogInterface.BUTTON_POSITIVE, this.getResources().getString(R.string.text_select), (dialog, which) -> {
            if (documentDialog != null && datePickerDialog.isShowing()) {
                calendar.set(Calendar.YEAR, datePickerDialog.getDatePicker().getYear());
                calendar.set(Calendar.MONTH, datePickerDialog.getDatePicker().getMonth());
                calendar.set(Calendar.DAY_OF_MONTH, datePickerDialog.getDatePicker().getDayOfMonth());
                etExpireDate.setText(parseContent.dateFormat.format(calendar.getTime()));
                expireDate = parseContent.webFormat.format(calendar.getTime());
            }
        });

        datePickerDialog.getDatePicker().setMinDate(calendar.getTimeInMillis());
        datePickerDialog.show();
    }

    private void getAllDocument() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.ID, preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.TYPE_STORE);
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AllDocumentsResponse> responseCall = apiInterface.getAllDocument(map);
        responseCall.enqueue(new Callback<AllDocumentsResponse>() {
            @Override
            public void onResponse(@NonNull Call<AllDocumentsResponse> call, @NonNull Response<AllDocumentsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        documentList.addAll(response.body().getDocuments());
                        preferenceHelper.putIsUserAllDocumentsUpload(response.body().isDocumentUploaded());
                        initRcvDocument();
                        if (documentList.isEmpty()) {
                            preferenceHelper.putIsUserAllDocumentsUpload(true);
                        }
                    }
                    rlEmpty.setVisibility(documentList.isEmpty() ? View.VISIBLE : View.GONE);
                    if (isApplicationStart) {
                        btnDocumentSubmit.setVisibility(documentList.isEmpty() ? View.GONE : View.VISIBLE);
                    } else {
                        btnDocumentSubmit.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AllDocumentsResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvDocument() {
        rcvDocument.setLayoutManager(new LinearLayoutManager(this));
        documentAdapter = new DocumentAdapter(documentList);
        rcvDocument.setAdapter(documentAdapter);
        rcvDocument.addOnItemTouchListener(new RecyclerTouchListener(this, rcvDocument, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                openDocumentUploadDialog(position);
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }


    /**
     * this method call webservice for upload a document
     *
     * @param position position
     */
    private void documentUpload(final int position) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Constant.ID, ApiClient.makeTextRequestBody(preferenceHelper.getStoreId()));
        if (documentList.get(position).getDocumentDetails().isIsExpiredDate()) {
            hashMap.put(Constant.EXPIRED_DATE, ApiClient.makeTextRequestBody(expireDate));
        }
        hashMap.put(Constant.DOCUMENT_ID, ApiClient.makeTextRequestBody(documentList.get(position).getId()));
        hashMap.put(Constant.TYPE, ApiClient.makeTextRequestBody(Constant.TYPE_STORE));
        hashMap.put(Constant.UNIQUE_CODE, ApiClient.makeTextRequestBody(etIdNumber.getText().toString()));
        hashMap.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getServerToken()));
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DocumentResponse> responseCall;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            responseCall = apiInterface.uploadDocument(null, hashMap);
        } else {
            responseCall = apiInterface.uploadDocument(ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Constant.IMAGE_URL), hashMap);
        }
        responseCall.enqueue(new Callback<DocumentResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<DocumentResponse> call, @NonNull Response<DocumentResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        uri = null;
                        currentPhotoPath = "";
                        Documents documents = documentList.get(position);
                        documents.setImageUrl(response.body().getImageUrl());
                        documents.setUniqueCode(response.body().getUniqueCode());
                        documents.setExpiredDate(response.body().getExpiredDate());
                        documentList.set(position, documents);
                        preferenceHelper.putIsUserAllDocumentsUpload(response.body().isIsDocumentUploaded());
                        documentAdapter.notifyDataSetChanged();
                    } else {
                        uri = null;
                        currentPhotoPath = "";
                        ParseContent.getInstance().showErrorMessage(DocumentActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<DocumentResponse> call, @NonNull Throwable t) {
                uri = null;
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            isApplicationStart = getIntent().getExtras().getBoolean(Constant.DOCUMENT_ACTIVITY);
        }
    }

    @Override
    public void onBackPressed() {
        if (isApplicationStart) {
            openLogoutDialog();
        } else {
            super.onBackPressed();
            overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
        }
    }

    private void submitDocument() {
        if (preferenceHelper.getIsUserAllDocumentsUpload()) {
            goToHomeActivity();
        } else {
            Utilities.showToast(this, getResources().getString(R.string.msg_plz_upload_document));
        }
    }
}