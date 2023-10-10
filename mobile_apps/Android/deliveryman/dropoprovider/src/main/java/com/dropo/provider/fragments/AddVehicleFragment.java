package com.dropo.provider.fragments;

import static com.dropo.provider.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.provider.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;
import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

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
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.VehicleDetailActivity;
import com.dropo.provider.adapter.DocumentAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.component.CustomPhotoDialog;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.Documents;
import com.dropo.provider.models.datamodels.Vehicle;
import com.dropo.provider.models.responsemodels.AllDocumentsResponse;
import com.dropo.provider.models.responsemodels.DocumentResponse;
import com.dropo.provider.models.responsemodels.VehicleAddResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppColor;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.ImageCompression;
import com.dropo.provider.utils.ImageHelper;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
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

public class AddVehicleFragment extends BottomSheetDialogFragment {
    public static final String TAG = AddVehicleFragment.class.getName();

    private final List<String> years = new ArrayList<>();
    private CustomFontEditTextView etVehicleName, etVehicleModel, etVehiclePlatNumber, etVehicleColorName;
    private Vehicle vehicle;
    private Dialog documentDialog;
    private Uri picUri;
    private ImageHelper imageHelper;
    private ImageView ivDocumentImage;
    private TextInputLayout tilExpireDate, tilNumberId;
    private CustomFontEditTextView etIdNumber, etExpireDate;
    private CustomFontTextViewTitle tvDocumentTitle;
    private RecyclerView rcvVehicleDocument;
    private CustomFontButton btnVehicleDocumentSubmit;
    private String expireDate;
    private List<Documents> documentList;
    private CustomDialogAlert closedPermissionDialog;
    private DocumentAdapter documentAdapter;
    private String currentPhotoPath;
    private VehicleDetailActivity vehicleDetailActivity;
    private TextView tagDocument, tagMandatory, tvDialogAlertTitle;
    private AutoCompleteTextView etYear;
    private TextInputLayout tilYear;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        vehicleDetailActivity = (VehicleDetailActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.activity_add_vehicle, container, false);
        etVehicleName = view.findViewById(R.id.etVehicleName);

        etVehicleModel = view.findViewById(R.id.etVehicleModel);
        etVehiclePlatNumber = view.findViewById(R.id.etVehiclePlatNumber);
        etVehicleColorName = view.findViewById(R.id.etVehicleColorName);
        rcvVehicleDocument = view.findViewById(R.id.rcvVehicleDocument);
        btnVehicleDocumentSubmit = view.findViewById(R.id.btnVehicleDocumentSubmit);
        btnVehicleDocumentSubmit.setVisibility(View.GONE);
        tagDocument = view.findViewById(R.id.tagDocument);
        tagMandatory = view.findViewById(R.id.tagMandatory);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> {
            this.vehicleDetailActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            dismiss();
        });
        tvDialogAlertTitle = view.findViewById(R.id.tvDialogAlertTitle);
        etYear = view.findViewById(R.id.etYear);
        tilYear = view.findViewById(R.id.tilYear);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        imageHelper = new ImageHelper(getContext());
        documentList = new ArrayList<>();
        initYearSpinner();
        initRcvDocument();
        getExtraData();
    }

    private void setDataEnable(boolean isEnable) {
        etVehicleName.setEnabled(isEnable);
        etVehicleModel.setEnabled(isEnable);
        etVehiclePlatNumber.setEnabled(isEnable);
        etVehicleColorName.setEnabled(isEnable);
        etYear.setEnabled(isEnable);
        tilYear.setEndIconVisible(isEnable);
        etVehicleName.setFocusableInTouchMode(isEnable);
        etVehicleModel.setFocusableInTouchMode(isEnable);
        etVehiclePlatNumber.setFocusableInTouchMode(isEnable);
        etVehicleColorName.setFocusableInTouchMode(isEnable);
    }

    protected boolean isValidate() {
        String msg = null;

        if (TextUtils.isEmpty(etVehicleName.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_plz_add_vehicle_name);
            etVehicleName.setError(msg);
        } else if (TextUtils.isEmpty(etVehicleModel.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_plz_add_vehicle_model_name);
            etVehicleModel.setError(msg);
        } else if (TextUtils.isEmpty(etVehiclePlatNumber.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_plz_add_vehicle_plate_number);
            etVehiclePlatNumber.setError(msg);
        } else if (TextUtils.isEmpty(etVehicleColorName.getText().toString().trim())) {
            msg = getResources().getString(R.string.msg_plz_add_vehicle_color_name);
            etVehicleColorName.setError(msg);
        }
        return TextUtils.isEmpty(msg);
    }

    protected boolean isRequiredVehicleUploaded() {
        String msg = null;
        for (Documents documents : documentList) {
            if (documents.getDocumentDetails().isIsMandatory() && TextUtils.isEmpty(documents.getImageUrl())) {
                msg = getResources().getString(R.string.msg_plz_upload_all_required_documents);
                Utils.showToast(msg, vehicleDetailActivity);
                break;
            }
        }
        return TextUtils.isEmpty(msg);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        vehicleDetailActivity.getVehicleDetail();
        vehicleDetailActivity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
    }


    /**
     * this method call webservice for add or update vehicle detail
     */
    private void addOrUpdateVehicleDetail() {
        Utils.showCustomProgressDialog(getContext(), false);
        Vehicle vehicle = new Vehicle();
        if (this.vehicle != null) {
            vehicle.setVehicleId(this.vehicle.getId());
            vehicle.setIsDocumentUploaded(vehicle.isIsDocumentUploaded());
        }
        vehicle.setProviderId(PreferenceHelper.getInstance(requireContext()).getProviderId());
        vehicle.setServerToken(PreferenceHelper.getInstance(requireContext()).getSessionToken());
        vehicle.setVehicleName(etVehicleName.getText().toString());
        vehicle.setVehicleModel(etVehicleModel.getText().toString());
        vehicle.setVehiclePlateNo(etVehiclePlatNumber.getText().toString());
        vehicle.setVehicleColor(etVehicleColorName.getText().toString());
        vehicle.setVehiclePassingYear(etYear.getText().toString());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<VehicleAddResponse> responseCall;
        if (this.vehicle != null) {
            responseCall = apiInterface.updateVehicle(ApiClient.makeGSONRequestBody(vehicle));
        } else {
            responseCall = apiInterface.addVehicle(ApiClient.makeGSONRequestBody(vehicle));
        }
        responseCall.enqueue(new Callback<VehicleAddResponse>() {
            @Override
            public void onResponse(@NonNull Call<VehicleAddResponse> call, @NonNull Response<VehicleAddResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        if (AddVehicleFragment.this.vehicle == null) {
                            AddVehicleFragment.this.vehicle = response.body().getVehicle();
                            getAllDocument();
                            vehicleDetailActivity.getVehicleDetail();
                        } else {
                            dismiss();
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), getContext());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<VehicleAddResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getExtraData() {
        if (getArguments() != null) {
            Bundle bundle = getArguments();
            vehicle = bundle.getParcelable(Const.BUNDLE);
            setEditButton(false);
            setDataEnable(true);
            tvDialogAlertTitle.setText(R.string.text_add_vehicle_detail);
            if (vehicle != null) {
                tvDialogAlertTitle.setText(R.string.text_vehicle_detail);
                etVehicleName.setText(vehicle.getVehicleName());
                etVehicleModel.setText(vehicle.getVehicleModel());
                etVehiclePlatNumber.setText(vehicle.getVehiclePlateNo());
                etYear.setText(String.valueOf(vehicle.getVehiclePassingYear()), false);
                etVehicleColorName.setText(vehicle.getVehicleColor());
                getAllDocument();
                setDataEnable(false);
                setEditButton(true);
            }
        } else {
            tvDialogAlertTitle.setText(R.string.text_add_vehicle_detail);
        }
    }

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = imageHelper.createImageFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            picUri = FileProvider.getUriForFile(vehicleDetailActivity, vehicleDetailActivity.getPackageName(), file);
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
            currentPhotoPath = ImageHelper.getFromMediaUriPfd(vehicleDetailActivity, vehicleDetailActivity.getContentResolver(), picUri).getPath();
            new ImageCompression(vehicleDetailActivity).setImageCompressionListener(compressionImagePath -> {
                currentPhotoPath = compressionImagePath;
                GlideApp.with(vehicleDetailActivity).load(picUri).into(ivDocumentImage);
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
            if (ActivityCompat.shouldShowRequestPermissionRationale(vehicleDetailActivity, android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (ActivityCompat.shouldShowRequestPermissionRationale(vehicleDetailActivity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else {
            openPhotoSelectDialog();
        }
    }

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(vehicleDetailActivity, getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                ActivityCompat.requestPermissions(vehicleDetailActivity, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
                closedPermissionDialog();
            }

        };
        closedPermissionDialog.show();
    }

    private void closedPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            closedPermissionDialog.dismiss();
            closedPermissionDialog = null;
        }
    }

    public void openPhotoSelectDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(vehicleDetailActivity, getResources().getString(R.string.text_set_profile_photos)) {
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

    public void checkPermission() {
        if (ContextCompat.checkSelfPermission(vehicleDetailActivity, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(vehicleDetailActivity, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(vehicleDetailActivity, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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
                if (resultCode == Activity.RESULT_OK) {
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

        documentDialog = new BottomSheetDialog(vehicleDetailActivity);
        documentDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        documentDialog.setContentView(R.layout.dialog_document_upload);
        ivDocumentImage = documentDialog.findViewById(R.id.ivDialogDocumentImage);
        etIdNumber = documentDialog.findViewById(R.id.etIdNumber);
        etExpireDate = documentDialog.findViewById(R.id.etExpireDate);
        tilExpireDate = documentDialog.findViewById(R.id.tilExpireDate);
        tilNumberId = documentDialog.findViewById(R.id.tilNumberId);
        tvDocumentTitle = documentDialog.findViewById(R.id.tvDialogAlertTitle);
        tvDocumentTitle.setText(document.getDocumentDetails().getDocumentName());
        CustomFontTextView tvOption = documentDialog.findViewById(R.id.tvOption);
        if (document.getDocumentDetails().isIsMandatory()) {
            tvOption.setVisibility(View.VISIBLE);
        }
        GlideApp.with(this)
                .load(IMAGE_URL + document.getImageUrl()).dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null))
                .fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.uploading, null))
                .into(ivDocumentImage);
        expireDate = "";
        if (document.getDocumentDetails().isIsExpiredDate()) {
            tilExpireDate.setVisibility(View.VISIBLE);
            String date = "";
            try {
                if (!TextUtils.isEmpty(document.getExpiredDate())) {
                    expireDate = document.getExpiredDate();
                    date = vehicleDetailActivity.parseContent.dateFormat.format(vehicleDetailActivity.parseContent.webFormat.parse(document.getExpiredDate()));
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

        documentDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            if (TextUtils.isEmpty(etExpireDate.getText().toString()) && document.getDocumentDetails().isIsExpiredDate()) {
                Utils.showToast(getResources().getString(R.string.msg_plz_enter_document_expire_date), vehicleDetailActivity);
            } else if (TextUtils.isEmpty(etIdNumber.getText().toString().trim()) && document.getDocumentDetails().isIsUniqueCode()) {
                etIdNumber.setError(getResources().getString(R.string.msg_plz_enter_document_unique_code));
            } else if (TextUtils.isEmpty(IMAGE_URL + document.getImageUrl())) {
                Utils.showToast(getResources().getString(R.string.msg_plz_select_document_image), vehicleDetailActivity);
            } else {
                documentDialog.dismiss();
                documentUpload(position);
            }
        });

        documentDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> documentDialog.dismiss());

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

        final DatePickerDialog datePickerDialog = new DatePickerDialog(vehicleDetailActivity, onDateSetListener, currentYear, currentMonth, currentDate);
        datePickerDialog.setButton(DialogInterface.BUTTON_POSITIVE, this.getResources().getString(R.string.text_select), (dialog, which) -> {
            if (documentDialog != null && datePickerDialog.isShowing()) {
                calendar.set(Calendar.YEAR, datePickerDialog.getDatePicker().getYear());
                calendar.set(Calendar.MONTH, datePickerDialog.getDatePicker().getMonth());
                calendar.set(Calendar.DAY_OF_MONTH, datePickerDialog.getDatePicker().getDayOfMonth());
                etExpireDate.setText(vehicleDetailActivity.parseContent.dateFormat.format(calendar.getTime()));
                expireDate = vehicleDetailActivity.parseContent.webFormat.format(calendar.getTime());
            }
        });

        datePickerDialog.getDatePicker().setMinDate(calendar.getTimeInMillis());
        datePickerDialog.show();
    }

    /**
     * this method call webservice for get all required document list
     */
    private void getAllDocument() {
        Utils.showCustomProgressDialog(vehicleDetailActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.ID, vehicle.getId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER_VEHICLE);
        map.put(Const.Params.SERVER_TOKEN, "");
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AllDocumentsResponse> responseCall = apiInterface.getAllDocument(map);
        responseCall.enqueue(new Callback<AllDocumentsResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<AllDocumentsResponse> call, @NonNull Response<AllDocumentsResponse> response) {
                if (vehicleDetailActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        documentList.addAll(response.body().getDocuments());
                        if (!documentList.isEmpty()) {
                            tagDocument.setVisibility(View.VISIBLE);
                            tagMandatory.setVisibility(View.VISIBLE);
                        }
                        vehicleDetailActivity.preferenceHelper.putIsProviderAllVehicleDocumentsUpload(response.body().isDocumentUploaded());
                        documentAdapter.notifyDataSetChanged();
                        btnVehicleDocumentSubmit.setVisibility(View.VISIBLE);
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
        rcvVehicleDocument.setLayoutManager(new LinearLayoutManager(vehicleDetailActivity));
        documentAdapter = new DocumentAdapter(documentList);
        rcvVehicleDocument.setAdapter(documentAdapter);
        rcvVehicleDocument.addOnItemTouchListener(new RecyclerTouchListener(vehicleDetailActivity, rcvVehicleDocument, new ClickListener() {

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
        Utils.showCustomProgressDialog(vehicleDetailActivity, false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.DOCUMENT_ID, ApiClient.makeTextRequestBody(documentList.get(position).getId()));
        if (documentList.get(position).getDocumentDetails().isIsExpiredDate()) {
            hashMap.put(Const.Params.EXPIRED_DATE, ApiClient.makeTextRequestBody(expireDate));
        }
        hashMap.put(Const.Params.ID, ApiClient.makeTextRequestBody(vehicle.getId()));
        hashMap.put(Const.Params.UNIQUE_CODE, ApiClient.makeTextRequestBody(etIdNumber.getText().toString()));
        hashMap.put(Const.Params.TYPE, ApiClient.makeTextRequestBody(Const.TYPE_PROVIDER_VEHICLE));
        hashMap.put(Const.Params.USER_TYPE_ID, ApiClient.makeTextRequestBody(vehicleDetailActivity.preferenceHelper.getProviderId()));
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DocumentResponse> responseCall;
        if (TextUtils.isEmpty(currentPhotoPath)) {
            responseCall = apiInterface.uploadDocument(null, hashMap);
        } else {
            responseCall = apiInterface.uploadDocument(ApiClient.makeMultipartRequestBody(currentPhotoPath, Const.Params.IMAGE_URL), hashMap);
        }
        responseCall.enqueue(new Callback<DocumentResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<DocumentResponse> call, @NonNull Response<DocumentResponse> response) {
                if (vehicleDetailActivity.parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        picUri = null;
                        currentPhotoPath = "";
                        Documents documents = documentList.get(position);
                        documents.setImageUrl(response.body().getImageUrl());
                        documents.setUniqueCode(response.body().getUniqueCode());
                        documents.setExpiredDate(response.body().getExpiredDate());
                        documentList.set(position, documents);
                        vehicleDetailActivity.preferenceHelper.putIsProviderAllVehicleDocumentsUpload(response.body().isIsDocumentUploaded());
                        documentAdapter.notifyDataSetChanged();
                        if (response.body().isIsDocumentUploaded()) {
                            Utils.showToast(getResources().getString(R.string.msg_all_document_upload_successfully), vehicleDetailActivity);
                        } else {
                            Utils.showMessageToast(response.body().getStatusPhrase(), vehicleDetailActivity);
                        }
                    } else {
                        picUri = null;
                        currentPhotoPath = "";
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), vehicleDetailActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<DocumentResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                picUri = null;
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initYearSpinner() {
        Calendar calendar = Calendar.getInstance();
        calendar.get(Calendar.YEAR);
        for (int i = 0; i < 20; i++) {
            years.add(String.valueOf(calendar.get(Calendar.YEAR) - i));
        }
        ArrayAdapter<String> dataAdapter = new ArrayAdapter<>(vehicleDetailActivity, R.layout.item_spiner_view_big, years);
        etYear.setAdapter(dataAdapter);
        etYear.setDropDownBackgroundResource(AppColor.isDarkTheme(vehicleDetailActivity) ? R.color.color_app_bg_dark : R.color.color_app_bg_light);
        etYear.setText(years.get(0), false);
    }

    private void setEditButton(boolean isEdit) {
        btnVehicleDocumentSubmit.setOnClickListener(view -> {
            if (isValidate()) {
                if (vehicle != null) {
                    if (isEdit && !etVehicleName.isEnabled()) {
                        setDataEnable(true);
                    } else if (isRequiredVehicleUploaded()) {
                        addOrUpdateVehicleDetail();
                    }
                } else {
                    addOrUpdateVehicleDetail();
                }
            }
        });
        btnVehicleDocumentSubmit.setVisibility(View.VISIBLE);
        btnVehicleDocumentSubmit.setText(isEdit ? R.string.text_vehicle_edit : R.string.text_save);
    }
}