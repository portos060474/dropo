package com.dropo.provider.fragments;

import static android.app.Activity.RESULT_OK;
import static com.dropo.provider.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.provider.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.app.DatePickerDialog;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.InputType;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import com.dropo.provider.BankDetailActivity;
import com.dropo.provider.R;
import com.dropo.provider.WithdrawalActivity;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.component.CustomDialogVerification;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomPhotoDialog;
import com.dropo.provider.models.datamodels.PaymentGateway;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.ImageHelper;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
import com.google.android.material.textfield.TextInputLayout;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.util.Calendar;
import java.util.HashMap;

import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddBankDetailFragment extends BottomSheetDialogFragment implements View.OnClickListener {
    private final String TAG = this.getClass().getSimpleName();

    private CustomFontEditTextView etAccountNumber, etAccountHolderName, etRoutingNumber, etPersonalIdNumber;
    private CustomFontTextView tvDob;
    private Uri picUri;
    private ImageHelper imageHelper;
    private CustomDialogAlert closedPermissionDialog;
    private ImageView ivFrontDocumentImage, ivBackDocumentImage, ivAdditionDocumentImage;
    private RadioButton rbMale;
    private EditText etAddress, etState, etPostalCode;
    private PaymentGateway paymentGateway;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments().getParcelable(Const.PAYMENT) != null) {
            paymentGateway = getArguments().getParcelable(Const.PAYMENT);
        }
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.activity_bank_detail, container, false);
        etRoutingNumber = view.findViewById(R.id.etRoutingNumber);
        etAccountNumber = view.findViewById(R.id.etBankAccountNumber);
        etPersonalIdNumber = view.findViewById(R.id.etPersonalIdNumber);
        etAccountHolderName = view.findViewById(R.id.etAccountHolderName);
        tvDob = view.findViewById(R.id.tvDob);
        ivFrontDocumentImage = view.findViewById(R.id.ivFrontDocumentImage);
        ivBackDocumentImage = view.findViewById(R.id.ivBackDocumentImage);
        ivAdditionDocumentImage = view.findViewById(R.id.ivAdditionDocumentImage);
        rbMale = view.findViewById(R.id.rbMale);
        etAddress = view.findViewById(R.id.etAddress);
        etState = view.findViewById(R.id.etState);
        etPostalCode = view.findViewById(R.id.etPostalCode);
        view.findViewById(R.id.btnSave).setOnClickListener(this);
        view.findViewById(R.id.btnClose).setOnClickListener(view1 -> {
            this.getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
            dismiss();
        });
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
        tvDob.setOnClickListener(this);
        ivFrontDocumentImage.setOnClickListener(this);
        ivBackDocumentImage.setOnClickListener(this);
        ivAdditionDocumentImage.setOnClickListener(this);
        imageHelper = new ImageHelper(getActivity());
        if (paymentGateway != null && paymentGateway.getId().equals(Const.Payment.PAYSTACK)) {
            updateUIForPaystack(view);
        }
    }

    private void updateUIForPaystack(View view) {
        view.findViewById(R.id.clPhotos).setVisibility(View.GONE);
        view.findViewById(R.id.tilPersonalId).setVisibility(View.GONE);
        view.findViewById(R.id.llDob).setVisibility(View.GONE);
        view.findViewById(R.id.tilAddress).setVisibility(View.GONE);
        view.findViewById(R.id.tilState).setVisibility(View.GONE);
        view.findViewById(R.id.tilPostalCode).setVisibility(View.GONE);
        ((TextInputLayout) view.findViewById(R.id.tilRouteNumber)).setHint(getString(R.string.hint_bank_code));
        etRoutingNumber.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
    }

    protected boolean isValidate() {
        String msg = null;
        if (paymentGateway != null && paymentGateway.getId().equals(Const.Payment.PAYSTACK)) {
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
                Utils.showToast(msg, getContext());
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
                Utils.showToast(msg, getContext());
            } else if (ivBackDocumentImage.getTag(R.drawable.placeholder) == null) {
                msg = getString(R.string.text_upload_photo_id_back);
                Utils.showToast(msg, getContext());
            } else if (ivAdditionDocumentImage.getTag(R.drawable.placeholder) == null) {
                msg = getString(R.string.text_upload_photo_additional);
                Utils.showToast(msg, getContext());
            }
        }
        return TextUtils.isEmpty(msg);
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.tvDob) {
            openDatePickerDialog();
        } else if (id == R.id.ivFrontDocumentImage) {
            checkPermission(ivFrontDocumentImage);
        } else if (id == R.id.ivBackDocumentImage) {
            checkPermission(ivBackDocumentImage);
        } else if (id == R.id.ivAdditionDocumentImage) {
            checkPermission(ivAdditionDocumentImage);
        } else if (id == R.id.btnSave) {
            if (isValidate()) {
                openVerifyAccountDialog();
            }
        }
    }

    private void openVerifyAccountDialog() {
        if (TextUtils.isEmpty(PreferenceHelper.getInstance(requireContext()).getSocialId())) {
            CustomDialogVerification customDialogVerification = new CustomDialogVerification(getContext(), getResources().getString(R.string.text_verify_account), getResources().getString(R.string.msg_enter_password_which_used_in_register), getResources().getString(R.string.text_ok), "", getResources().getString(R.string.text_password), false, InputType.TYPE_CLASS_TEXT, InputType.TYPE_TEXT_VARIATION_PASSWORD, false) {
                @Override
                protected void resendOtp() {

                }

                @Override
                public void onClickLeftButton() {
                    dismiss();

                }

                @Override
                public void onClickRightButton(CustomFontEditTextView etDialogEditTextOne, CustomFontEditTextView etDialogEditTextTwo) {
                    if (!etDialogEditTextTwo.getText().toString().isEmpty()) {
                        addBankDetail(etDialogEditTextTwo.getText().toString());
                        dismiss();
                    } else {
                        etDialogEditTextTwo.setError(getString(R.string.msg_enter_password));
                    }
                }
            };
            customDialogVerification.show();
        } else {
            addBankDetail("");
        }
    }

    /**
     * this method call webservice for add or update bank detail;
     *
     * @param pass string
     */
    private void addBankDetail(String pass) {
        Utils.showCustomProgressDialog(getContext(), false);
        HashMap<String, RequestBody> hashMap = new HashMap<>();
        hashMap.put(Const.Params.BUSINESS_NAME, ApiClient.makeTextRequestBody("Deliveryman"));
        hashMap.put(Const.Params.BANK_HOLDER_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getInstance(requireContext()).getProviderId()));
        hashMap.put(Const.Params.ACCOUNT_HOLDER_NAME, ApiClient.makeTextRequestBody(etAccountHolderName.getText().toString().trim()));
        hashMap.put(Const.Params.BANK_ACCOUNT_HOLDER_NAME, ApiClient.makeTextRequestBody(etAccountHolderName.getText().toString().trim()));
        hashMap.put(Const.Params.BANK_ACCOUNT_NUMBER, ApiClient.makeTextRequestBody(etAccountNumber.getText().toString()));
        hashMap.put(Const.Params.BANK_PERSONAL_ID_NUMBER, ApiClient.makeTextRequestBody(etPersonalIdNumber.getText().toString()));
        hashMap.put(Const.Params.BANK_ACCOUNT_HOLDER_TYPE, ApiClient.makeTextRequestBody(Const.Bank.BANK_ACCOUNT_HOLDER_TYPE));
        hashMap.put(Const.Params.BANK_HOLDER_TYPE, ApiClient.makeTextRequestBody(Const.TYPE_PROVIDER));
        hashMap.put(Const.Params.BANK_ROUTING_NUMBER, ApiClient.makeTextRequestBody(etRoutingNumber.getText().toString()));
        hashMap.put(Const.Params.DOB, ApiClient.makeTextRequestBody(tvDob.getText().toString()));
        hashMap.put(Const.Params.ADDRESS, ApiClient.makeTextRequestBody(etAddress.getText().toString()));
        hashMap.put(Const.Params.GENDER, ApiClient.makeTextRequestBody(rbMale.isChecked() ? "male" : "female"));
        hashMap.put(Const.Params.POSTAL_CODE, ApiClient.makeTextRequestBody(etPostalCode.getText().toString()));

        hashMap.put(Const.Params.SOCIAL_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getInstance(requireContext()).getSocialId()));
        hashMap.put(Const.Params.PASS_WORD, ApiClient.makeTextRequestBody(pass));
        hashMap.put(Const.Params.SERVER_TOKEN, ApiClient.makeTextRequestBody(PreferenceHelper.getInstance(requireContext()).getSessionToken()));
        hashMap.put(Const.Params.PROVIDER_ID, ApiClient.makeTextRequestBody(PreferenceHelper.getInstance(requireContext()).getProviderId()));

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        if (paymentGateway != null && paymentGateway.getId().equals(Const.Payment.PAYSTACK)) {
            responseCall = apiInterface.addBankDetail(hashMap, null, null, null);
        } else {
            responseCall = apiInterface.addBankDetail(hashMap, ApiClient.makeMultipartRequestBody((String) ivFrontDocumentImage.getTag(R.drawable.placeholder), "front"), ApiClient.makeMultipartRequestBody((String) ivBackDocumentImage.getTag(R.drawable.placeholder), "back"), ApiClient.makeMultipartRequestBody((String) ivAdditionDocumentImage.getTag(R.drawable.placeholder), "additional"));
        }

        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body().isSuccess()) {
                        dismiss();
                        if (getActivity() instanceof BankDetailActivity) {
                            BankDetailActivity bankDetailActivity = (BankDetailActivity) getActivity();
                            bankDetailActivity.getBankDetail();
                        } else if (getActivity() instanceof WithdrawalActivity) {
                            WithdrawalActivity withdrawalActivity = (WithdrawalActivity) getActivity();
                            withdrawalActivity.getBankDetail();
                        }
                    } else {
                        if (TextUtils.isEmpty(response.body().getStripeError())) {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), getContext());
                        } else {
                            openBankDetailErrorDialog(response.body().getStripeError());
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void openDatePickerDialog() {
        final Calendar calendar = Calendar.getInstance();
        final int currentYear = calendar.get(Calendar.YEAR);
        final int currentMonth = calendar.get(Calendar.MONTH);
        final int currentDate = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog.OnDateSetListener onDateSetListener = (view, year, monthOfYear, dayOfMonth) -> tvDob.setText(String.format("%s-%s-%s", dayOfMonth, (monthOfYear + 1), year));
        final DatePickerDialog datePickerDialog = new DatePickerDialog(getContext(), onDateSetListener, currentYear, currentMonth, currentDate);
        // DOB for stripe we only allow 13 year ago date
        Calendar calendar1 = Calendar.getInstance();
        calendar1.set(Calendar.YEAR, calendar1.get(Calendar.YEAR) - 13);
        datePickerDialog.getDatePicker().setMaxDate(calendar1.getTimeInMillis());
        datePickerDialog.show();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case TAKE_PHOTO_FROM_CAMERA:
                    onCaptureImageResult();
                    break;
                case CHOOSE_PHOTO_FROM_GALLERY:
                    onSelectFromGalleryResult(data);
                    break;
                case CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE:
                    handleCrop(resultCode, data, (ImageView) tvDob.getTag());
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    public void beginCrop(Uri sourceUri) {
        CropImage.activity(sourceUri).setGuidelines(com.theartofdev.edmodo.cropper.CropImageView.Guidelines.ON).start(requireContext(), this);
    }

    /**
     * This method is used for handel result after select placeholder from gallery .
     */
    private void onSelectFromGalleryResult(Intent data) {
        if (data != null) {
            picUri = data.getData();
            //beginCrop(picUri);
            setImage(picUri, (ImageView) tvDob.getTag());
        }
    }

    /**
     * This method is used for handel result after captured placeholder from camera .
     */
    private void onCaptureImageResult() {
        //beginCrop(picUri);
        setImage(picUri, (ImageView) tvDob.getTag());
    }

    /**
     * This method is used for  handel crop result after crop the placeholder.
     */
    private void handleCrop(int resultCode, Intent result, ImageView imageView) {
        CropImage.ActivityResult activityResult = CropImage.getActivityResult(result);
        if (resultCode == RESULT_OK) {
            picUri = activityResult.getUri();
            File file = ImageHelper.getFromMediaUriPfd(getContext(), requireContext().getContentResolver(), picUri);
            if (file != null) {
                GlideApp.with(this).load(picUri).into(imageView);
                imageView.setTag(R.drawable.placeholder, file.getPath());
            }
        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), getContext());
        }
    }

    private void setImage(Uri uri, ImageView imageView) {
        File file = ImageHelper.getFromMediaUriPfd(getContext(), requireContext().getContentResolver(), uri);
        if (file != null) {
            GlideApp.with(this).load(picUri).into(imageView);
            imageView.setTag(R.drawable.placeholder, file.getPath());
        }
    }

    private void goWithCameraAndStoragePermission(int[] grantResults) {
        if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (shouldShowRequestPermissionRationale(android.Manifest.permission.CAMERA)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else if (grantResults[1] == PackageManager.PERMISSION_DENIED) {
            // Should we show an explanation?
            if (shouldShowRequestPermissionRationale(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE)) {
                openCameraPermissionDialog();
            } else {
                closedPermissionDialog();
            }
        } else {
            openPhotoSelectDialog();
        }
    }

    public void openPhotoSelectDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(getContext(), getResources().getString(R.string.text_set_profile_photos)) {
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

    private void openCameraPermissionDialog() {
        if (closedPermissionDialog != null && closedPermissionDialog.isShowing()) {
            return;
        }
        closedPermissionDialog = new CustomDialogAlert(getContext(), getResources().getString(R.string.text_attention), getResources().getString(R.string.msg_reason_for_camera_permission), getString(R.string.text_re_try)) {
            @Override
            public void onClickLeftButton() {
                closedPermissionDialog();
            }

            @Override
            public void onClickRightButton() {
                requestPermissions(new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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

    public void checkPermission(ImageView imageView) {
        tvDob.setTag(imageView);
        if (ContextCompat.checkSelfPermission(requireContext(), android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(requireContext(), Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissions(new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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

    private void takePhotoFromCamera() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        File file = imageHelper.createImageFile();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            picUri = FileProvider.getUriForFile(requireContext(), requireContext().getPackageName(), file);
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

    protected void openBankDetailErrorDialog(String message) {
        CustomDialogAlert exitDialog = new CustomDialogAlert(getContext(), this.getResources().getString(R.string.text_error), message, this.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();
            }

            @Override
            public void onClickRightButton() {
                dismiss();
            }
        };
        exitDialog.btnDialogEditTextLeft.setVisibility(View.GONE);
        exitDialog.show();
    }
}