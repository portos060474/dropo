package com.dropo;

import static com.dropo.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.DocumentAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomPhotoDialog;
import com.dropo.interfaces.ClickListener;
import com.dropo.interfaces.RecyclerTouchListener;
import com.dropo.models.datamodels.Documents;
import com.dropo.models.responsemodels.AllDocumentsResponse;
import com.dropo.models.responsemodels.DocumentResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageCompression;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.ServerConfig;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.io.File;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class DocumentActivity extends BaseAppCompatActivity {

    private Dialog documentDialog;
    private Uri picUri;
    private ImageHelper imageHelper;
    private ImageView ivDocumentImage;
    private TextInputLayout tilExpireDate, tilNumberId;
    private CustomFontEditTextView etIdNumber, etExpireDate;
    private TextView tvDocumentTitle;
    private RecyclerView rcvDocument;
    private CustomFontButton btnDocumentSubmit;
    private String expireDate;
    private List<Documents> documentList;
    private CustomDialogAlert closedPermissionDialog;
    private boolean isApplicationStart, isFromCheckOut;
    private DocumentAdapter documentAdapter;
    private String currentPhotoPath;
    private View rlEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_documents));
        initViewById();
        setViewListener();
        getAllDocument();
        imageHelper = new ImageHelper(this);
        documentList = new ArrayList<>();
        getExtraData();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvDocument = findViewById(R.id.rcvDocument);
        btnDocumentSubmit = findViewById(R.id.btnDocumentSubmit);
        rlEmpty = findViewById(R.id.rlEmpty);
    }

    @Override
    protected void setViewListener() {
        btnDocumentSubmit.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnDocumentSubmit) {
            submitDocument();
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = imageHelper.createImageFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            picUri = FileProvider.getUriForFile(this, getPackageName(), file);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        } else {
            picUri = Uri.fromFile(file);
        }
        intent.putExtra(MediaStore.EXTRA_OUTPUT, picUri);
        startActivityForResult(intent, TAKE_PHOTO_FROM_CAMERA);
    }

    private void choosePhotoFromGallery() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(intent, CHOOSE_PHOTO_FROM_GALLERY);
    }

    /**
     * This method is used for handel result after select placeholder from gallery .
     */
    private void onSelectFromGalleryResult(Intent data) {
        if (data != null) {
            picUri = data.getData();
            setWithOutCropImage();
        }
    }

    private void setWithOutCropImage() {
        if (documentDialog != null && documentDialog.isShowing()) {
            currentPhotoPath = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), picUri).getPath();
            new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
                currentPhotoPath = compressionImagePath;
                GlideApp.with(DocumentActivity.this).load(picUri).into(ivDocumentImage);
            }).execute(currentPhotoPath);
        }
    }

    /**
     * this method will make decision according to permission result
     *
     * @param grantResults set result from system or OS
     */
    private void goWithCameraAndStoragePermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closePermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closePermissionDialog();
            }
        } else {
            openPhotoSelectDialog();
        }
    }

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(this, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closePermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                ActivityCompat.requestPermissions(DocumentActivity.this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
                closePermissionDialog();
            }
        };
        closedPermissionDialog.show();
    }

    private void closePermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            closedPermissionDialog.dismiss();
            closedPermissionDialog = null;
        }
    }

    public void openPhotoSelectDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(this, getResources().getString(R.string.text_set_profile_photos)) {
            @Override
            public void clickedOnCamera() {
                takePhotoFromCamera();
                dismiss();
            }

            @Override
            public void clickedOnGallery() {
                choosePhotoFromGallery();
                dismiss();
            }
        };
        customPhotoDialog.show();
    }

    /**
     * this method will check particular  permission will be granted by user or not
     */
    public void checkPermission() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
        } else {
            openPhotoSelectDialog();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE) {
                goWithCameraAndStoragePermission(grantResults);
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case TAKE_PHOTO_FROM_CAMERA:
                if (resultCode == RESULT_OK) {
                    setWithOutCropImage();
                }
                break;
            case CHOOSE_PHOTO_FROM_GALLERY:
                onSelectFromGalleryResult(data);
                break;
            default:
                break;
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
        tvDocumentTitle = documentDialog.findViewById(R.id.tvDialogDocumentTitle);
        tvDocumentTitle.setText(document.getDocumentDetails().getDocumentName());
        GlideApp.with(this).load(ServerConfig.IMAGE_URL + document.getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null)).into(ivDocumentImage);
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
                AppLog.handleException(DocumentAdapter.class.getName(), e);
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

        documentDialog.findViewById(R.id.btnDialogDocumentSubmit).setOnClickListener(view -> {
            if (TextUtils.isEmpty(etIdNumber.getText().toString().trim()) && document.getDocumentDetails().isIsUniqueCode()) {
                etIdNumber.setError(getResources().getString(R.string.msg_plz_enter_document_unique_code));
            } else if (TextUtils.isEmpty(etExpireDate.getText().toString()) && document.getDocumentDetails().isIsExpiredDate()) {
                Utils.showToast(getResources().getString(R.string.msg_plz_enter_document_expire_date), DocumentActivity.this);
            } else if (TextUtils.isEmpty(document.getImageUrl()) && TextUtils.isEmpty(currentPhotoPath)) {
                Utils.showToast(getResources().getString(R.string.msg_plz_select_document_image), DocumentActivity.this);
            } else {
                documentDialog.dismiss();
                documentUpload(position);
            }
        });

        documentDialog.findViewById(R.id.btnDialogDocumentCancel).setOnClickListener(view -> {
            DocumentActivity.this.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            documentDialog.dismiss();
        });

        ivDocumentImage.setOnClickListener(view -> checkPermission());
        etExpireDate.setOnClickListener(view -> openDatePickerDialog());
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

    /**
     * this method call webservice for get all required document list
     */
    private void getAllDocument() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.ID, preferenceHelper.getUserId());
        map.put(Const.Params.TYPE, Const.Type.USER);
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AllDocumentsResponse> responseCall = apiInterface.getAllDocument(map);
        responseCall.enqueue(new Callback<AllDocumentsResponse>() {
            @Override
            public void onResponse(@NonNull Call<AllDocumentsResponse> call, @NonNull Response<AllDocumentsResponse> response) {
                Utils.hideCustomProgressDialog();
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
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvDocument() {
        rcvDocument.setLayoutManager(new LinearLayoutManager(this));
        documentAdapter = new DocumentAdapter(documentList);
        rcvDocument.setAdapter(documentAdapter);
        DividerItemDecoration dividerItemDecoration = new DividerItemDecoration(this, DividerItemDecoration.VERTICAL);
        dividerItemDecoration.getDrawable().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(this) ? R.color.color_app_tag_dark : R.color.color_app_tag_light, null));
        rcvDocument.addItemDecoration(dividerItemDecoration);
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
     * this method call webservice for upload document
     *
     * @param position position
     */
    private void documentUpload(final int position) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.ID, ApiClient.makeTextRequestBody(preferenceHelper.getUserId()));
        if (documentList.get(position).getDocumentDetails().isIsExpiredDate()) {
            hashMap.put(Const.Params.EXPIRED_DATE, ApiClient.makeTextRequestBody(expireDate));
        }
        hashMap.put(Const.Params.DOCUMENT_ID, ApiClient.makeTextRequestBody(documentList.get(position).getId()));
        hashMap.put(Const.Params.TYPE, ApiClient.makeTextRequestBody(Const.Type.USER));
        hashMap.put(Const.Params.UNIQUE_CODE, ApiClient.makeTextRequestBody(etIdNumber.getText().toString()));
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getSessionToken()));
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DocumentResponse> responseCall;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            responseCall = apiInterface.uploadDocument(null, hashMap);
        } else {
            responseCall = apiInterface.uploadDocument(ApiClient.makeMultipartRequestBody(this, currentPhotoPath, Const.Params.IMAGE_URL), hashMap);
        }
        responseCall.enqueue(new Callback<DocumentResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<DocumentResponse> call, @NonNull Response<DocumentResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        picUri = null;
                        currentPhotoPath = "";
                        Documents documents = documentList.get(position);
                        documents.setImageUrl(response.body().getImageUrl());
                        documents.setUniqueCode(response.body().getUniqueCode());
                        documents.setExpiredDate(response.body().getExpiredDate());
                        documentList.set(position, documents);
                        preferenceHelper.putIsUserAllDocumentsUpload(response.body().isIsDocumentUploaded());
                        documentAdapter.notifyDataSetChanged();
                        Utils.showMessageToast(response.body().getStatusPhrase(), DocumentActivity.this);
                    } else {
                        picUri = null;
                        currentPhotoPath = "";
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), DocumentActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<DocumentResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.REGISTER_FRAGMENT, t);
                picUri = null;
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getExtraData() {
        if (getIntent().getExtras() != null) {
            isApplicationStart = getIntent().getExtras().getBoolean(Const.Tag.DOCUMENT_ACTIVITY);
            isFromCheckOut = getIntent().getBooleanExtra(Const.IS_FROM_CHECKOUT, false);
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

    private void openLogoutDialog() {
        CustomDialogAlert customDialogAlert = new CustomDialogAlert(this, getResources().getString(R.string.text_log_out), getResources().getString(R.string.msg_are_you_sure_to_logout), getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                logOut(false);
                dismiss();
            }
        };
        customDialogAlert.show();
    }

    private void submitDocument() {
        if (preferenceHelper.getIsUserAllDocumentsUpload()) {
            if (isFromCheckOut) {
                setResult(Activity.RESULT_OK);
                finish();
            } else if (getCallingActivity() == null) {
                goToHomeActivity();
            } else {
                setResult(Activity.RESULT_OK);
                finish();
            }
        } else {
            Utils.showToast(getResources().getString(R.string.msg_plz_upload_document), this);
        }
    }
}