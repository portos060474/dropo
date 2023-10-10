package com.dropo.store;

import android.Manifest;
import android.app.Activity;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.InputType;
import android.text.TextUtils;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomPhotoDialog;
import com.dropo.store.models.datamodel.PaymentGateway;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;
import com.soundcloud.android.crop.Crop;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddBankDetailActivity extends BaseActivity {

    public static final String TAG = AddBankDetailActivity.class.getName();

    private CustomInputEditText etAccountNumber, etAccountHolderName, etRoutingNumber, etPersonalIdNumber;
    private EditText etVerifyPassword, etAddress, etState, etPostalCode;
    private BottomSheetDialog dialog;
    private CustomTextView tvDob;
    private Uri uri;
    private ImageHelper imageHelper;
    private ImageView ivFrontDocumentImage, ivBackDocumentImage, ivAdditionDocumentImage;
    private RadioButton rbMale;
    private PaymentGateway paymentGateway;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_bank_detail);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(AddBankDetailActivity.this);
            onBackPressed();
        });
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_bank_detail));
        imageHelper = new ImageHelper(this);
        etRoutingNumber = findViewById(R.id.etRoutingNumber);
        etAccountNumber = findViewById(R.id.etBankAccountNumber);
        etPersonalIdNumber = findViewById(R.id.etPersonalIdNumber);
        etAccountHolderName = findViewById(R.id.etAccountHolderName);
        tvDob = findViewById(R.id.tvDob);
        ivFrontDocumentImage = findViewById(R.id.ivFrontDocumentImage);
        ivBackDocumentImage = findViewById(R.id.ivBackDocumentImage);
        ivAdditionDocumentImage = findViewById(R.id.ivAdditionDocumentImage);
        tvDob.setOnClickListener(this);
        ivFrontDocumentImage.setOnClickListener(this);
        ivBackDocumentImage.setOnClickListener(this);
        ivAdditionDocumentImage.setOnClickListener(this);
        rbMale = findViewById(R.id.rbMale);
        etAddress = findViewById(R.id.etAddress);
        etState = findViewById(R.id.etState);
        etPostalCode = findViewById(R.id.etPostalCode);
        if (getIntent().getParcelableExtra(Constant.BUNDLE) != null) {
            paymentGateway = getIntent().getParcelableExtra(Constant.BUNDLE);
        }
        if (paymentGateway != null && paymentGateway.getId().equals(Constant.Payment.PAYSTACK)) {
            updateUIForPayStack();
        }
    }

    private void updateUIForPayStack() {
        findViewById(R.id.clPhotos).setVisibility(View.GONE);
        findViewById(R.id.tilPersonalId).setVisibility(View.GONE);
        findViewById(R.id.llDob).setVisibility(View.GONE);
        findViewById(R.id.tilAddress).setVisibility(View.GONE);
        findViewById(R.id.tilState).setVisibility(View.GONE);
        findViewById(R.id.tilPostalCode).setVisibility(View.GONE);
        ((TextInputLayout) findViewById(R.id.tilRouteNumber)).setHint(getString(R.string.hint_bank_code));
        etRoutingNumber.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
    }

    private void openDatePickerDialog() {
        final Calendar calendar = Calendar.getInstance();
        final int currentYear = calendar.get(Calendar.YEAR);
        final int currentMonth = calendar.get(Calendar.MONTH);
        final int currentDate = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog.OnDateSetListener onDateSetListener = (view, year, monthOfYear, dayOfMonth) -> {
            //tvDob.setText((monthOfYear + 1) + "-" + dayOfMonth + "-" + year);
            tvDob.setText(String.format("%s-%s-%s", dayOfMonth, (monthOfYear + 1), year));
            tvDob.setTextColor(ResourcesCompat.getColor(getResources(), R.color.color_app_text_light, null));
        };
        final DatePickerDialog datePickerDialog = new DatePickerDialog(this, onDateSetListener, currentYear, currentMonth, currentDate);
        // DOB for stripe we only allow 13 year ago date
        Calendar calendar1 = Calendar.getInstance();
        calendar1.set(Calendar.YEAR, calendar1.get(Calendar.YEAR) - 13);
        datePickerDialog.getDatePicker().setMaxDate(calendar1.getTimeInMillis());
        datePickerDialog.show();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(true);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivSaveMenu) {
            if (isValidate()) {
                showVerificationDialog();
            }
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    protected boolean isValidate() {
        String msg = null;
        if (paymentGateway != null && paymentGateway.getId().equals(Constant.Payment.PAYSTACK)) {
            if (TextUtils.isEmpty(etAccountHolderName.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_account_name);
                etAccountHolderName.requestFocus();
                etAccountHolderName.setError(msg);
            } else if (TextUtils.isEmpty(etAccountNumber.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_valid_account_number);
                etAccountNumber.requestFocus();
                etAccountNumber.setError(msg);
            } else if (TextUtils.isEmpty(etRoutingNumber.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_valid_bank_code);
                etRoutingNumber.requestFocus();
                etRoutingNumber.setError(msg);
            }
        } else {
            if (TextUtils.isEmpty(etAccountHolderName.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_account_name);
                etAccountHolderName.requestFocus();
                etAccountHolderName.setError(msg);
            } else if (TextUtils.isEmpty(etAccountNumber.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_valid_account_number);
                etAccountNumber.requestFocus();
                etAccountNumber.setError(msg);
            } else if (TextUtils.isEmpty(etRoutingNumber.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_valid_routing_number);
                etRoutingNumber.requestFocus();
                etRoutingNumber.setError(msg);
            } else if (TextUtils.isEmpty(etPersonalIdNumber.getText().toString().trim())) {
                msg = getString(R.string.msg_plz_valid_personal_id_number);
                etPersonalIdNumber.requestFocus();
                etPersonalIdNumber.setError(msg);
            } else if (TextUtils.equals(tvDob.getText().toString(), getResources().getString(R.string.text_dob))) {
                msg = getString(R.string.msg_add_dob);
                Utilities.showToast(this, msg);
            } else if (TextUtils.isEmpty(etAddress.getText().toString().trim())) {
                msg = getString(R.string.msg_valid_address);
                etAddress.requestFocus();
                etAddress.setError(msg);
            } else if (TextUtils.isEmpty(etState.getText().toString().trim())) {
                msg = getString(R.string.msg_valid_state);
                etState.requestFocus();
                etState.setError(msg);
            } else if (TextUtils.isEmpty(etPostalCode.getText().toString().trim())) {
                msg = getString(R.string.msg_valid_postal_code);
                etPostalCode.requestFocus();
                etPostalCode.setError(msg);
            } else if (ivFrontDocumentImage.getTag(R.drawable.placeholder) == null) {
                msg = getString(R.string.text_upload_photo_id_front);
                Utilities.showToast(this, msg);
            } else if (ivBackDocumentImage.getTag(R.drawable.placeholder) == null) {
                msg = getString(R.string.text_upload_photo_id_back);
                Utilities.showToast(this, msg);
            } else if (ivAdditionDocumentImage.getTag(R.drawable.placeholder) == null) {
                msg = getString(R.string.text_upload_photo_additional);
                Utilities.showToast(this, msg);
            }
        }
        return TextUtils.isEmpty(msg);
    }

    private void showVerificationDialog() {
        if (TextUtils.isEmpty(preferenceHelper.getSocialId())) {
            dialog = new BottomSheetDialog(this);
            dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            dialog.setContentView(R.layout.dialog_account_verification);
            etVerifyPassword = dialog.findViewById(R.id.etCurrentPassword);

            dialog.findViewById(R.id.btnPositive).setOnClickListener(this);
            dialog.findViewById(R.id.btnNegative).setOnClickListener(this);

            WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
            params.width = WindowManager.LayoutParams.MATCH_PARENT;
            dialog.show();
        } else {
            addBankDetail("");
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.btnPositive) {
            if (!TextUtils.isEmpty(etVerifyPassword.getText().toString())) {
                if (dialog != null && dialog.isShowing()) {
                    dialog.dismiss();
                }
                addBankDetail(etVerifyPassword.getText().toString());
            } else {
                etVerifyPassword.setError(getString(R.string.msg_empty_password));
            }
        } else if (id == R.id.btnNegative) {
            if (dialog != null && dialog.isShowing()) {
                dialog.dismiss();
            }
        } else if (id == R.id.ivFrontDocumentImage) {
            showPhotoSelectionDialog(ivFrontDocumentImage);
        } else if (id == R.id.ivBackDocumentImage) {
            showPhotoSelectionDialog(ivBackDocumentImage);
        } else if (id == R.id.ivAdditionDocumentImage) {
            showPhotoSelectionDialog(ivAdditionDocumentImage);
        } else if (id == R.id.tvDob) {
            openDatePickerDialog();
        }
    }

    /**
     * this method call webservice for add or update bank detail;
     *
     * @param pass string
     */
    private void addBankDetail(String pass) {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Constant.BUSINESS_NAME, ApiClient.makeTextRequestBody("Store"));
        hashMap.put(Constant.BANK_HOLDER_ID, ApiClient.makeTextRequestBody(preferenceHelper.getStoreId()));
        hashMap.put(Constant.ACCOUNT_HOLDER_NAME, ApiClient.makeTextRequestBody(etAccountHolderName.getText().toString().trim()));
        hashMap.put(Constant.BANK_ACCOUNT_HOLDER_NAME, ApiClient.makeTextRequestBody(etAccountHolderName.getText().toString().trim()));
        hashMap.put(Constant.BANK_ACCOUNT_NUMBER, ApiClient.makeTextRequestBody(etAccountNumber.getText().toString()));
        hashMap.put(Constant.BANK_PERSONAL_ID_NUMBER, ApiClient.makeTextRequestBody(etPersonalIdNumber.getText().toString()));
        hashMap.put(Constant.BANK_ACCOUNT_HOLDER_TYPE, ApiClient.makeTextRequestBody(Constant.Bank.BANK_ACCOUNT_HOLDER_TYPE));
        hashMap.put(Constant.BANK_HOLDER_TYPE, ApiClient.makeTextRequestBody(Constant.TYPE_STORE));
        hashMap.put(Constant.BANK_ROUTING_NUMBER, ApiClient.makeTextRequestBody(etRoutingNumber.getText().toString()));
        hashMap.put(Constant.DOB, ApiClient.makeTextRequestBody(tvDob.getText().toString()));
        hashMap.put(Constant.ADDRESS, ApiClient.makeTextRequestBody(etAddress.getText().toString()));
        hashMap.put(Constant.STATE, ApiClient.makeTextRequestBody(etState.getText().toString().trim()));
        hashMap.put(Constant.GENDER, ApiClient.makeTextRequestBody(rbMale.isChecked() ? "male" : "female"));
        hashMap.put(Constant.POSTAL_CODE, ApiClient.makeTextRequestBody(etPostalCode.getText().toString()));

        hashMap.put(Constant.SOCIAL_ID, ApiClient.makeTextRequestBody(preferenceHelper.getSocialId()));
        hashMap.put(Constant.PASS_WORD, ApiClient.makeTextRequestBody(pass));
        hashMap.put(Constant.SERVER_TOKEN, ApiClient.makeTextRequestBody(preferenceHelper.getServerToken()));
        hashMap.put(Constant.STORE_ID, ApiClient.makeTextRequestBody(preferenceHelper.getStoreId()));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        if (paymentGateway != null && paymentGateway.getId().equals(Constant.Payment.PAYSTACK)) {
            responseCall = apiInterface.addBankDetail(hashMap, null, null, null);
        } else {
            responseCall = apiInterface.addBankDetail(hashMap, ApiClient.makeMultipartRequestBody(this, (String) ivFrontDocumentImage.getTag(R.drawable.placeholder), "front"), ApiClient.makeMultipartRequestBody(this, (String) ivBackDocumentImage.getTag(R.drawable.placeholder), "back"), ApiClient.makeMultipartRequestBody(this, (String) ivAdditionDocumentImage.getTag(R.drawable.placeholder), "additional"));
        }
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utilities.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        setResult(Activity.RESULT_OK);
                        finish();
                    } else {
                        if (TextUtils.isEmpty(response.body().getStripeError())) {
                            ParseContent.getInstance().showErrorMessage(AddBankDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        } else {
                            openBankDetailErrorDialog(response.body().getStripeError());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(TAG, t);
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void openBankDetailErrorDialog(String message) {
        CustomAlterDialog customExitDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_error), message, false, getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                dismiss();
            }
        };
        customExitDialog.show();
    }

    private void showPhotoSelectionDialog(ImageView imageView) {
        tvDob.setTag(imageView);
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
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case Constant.PERMISSION_CHOOSE_PHOTO:
                    if (data != null) {
                        uri = data.getData();
                        //beginCrop(uri);
                        setImage(uri, (ImageView) tvDob.getTag());
                    }
                    break;

                case Constant.PERMISSION_TAKE_PHOTO:
                    if (uri != null) {
                        //beginCrop(uri);
                        setImage(uri, (ImageView) tvDob.getTag());
                    }
                    break;
                case Crop.REQUEST_CROP:
                    setImage(Crop.getOutput(data), (ImageView) tvDob.getTag());
                    break;
                default:
                    break;
            }
        }
    }

    private void setImage(Uri uri, ImageView imageView) {
        File file = ImageHelper.getFromMediaUriPfd(this, this.getContentResolver(), uri);
        if (file != null) {
            GlideApp.with(this)
                    .load(uri)
                    .error(R.drawable.icon_default_profile)
                    .into(imageView);
            imageView.setTag(R.drawable.placeholder, file.getPath());
        }
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        Uri outputUri = Uri.fromFile(imageHelper.createImageFile());
        Crop.of(sourceUri, outputUri).start(this);
    }
}
