package com.dropo.fragments;

import static android.app.Activity.RESULT_OK;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.CheckoutDeliveryLocationActivity;
import com.dropo.user.R;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomImageView;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.FieldValidation;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddCourierAddressDialogFragment extends BottomSheetDialogFragment implements View.OnClickListener {

    private Activity activity;
    private PreferenceHelper preferenceHelper;

    private CustomFontEditTextView etAddress, etName, etCountryCode, etPhone, etNote;
    private CustomImageView btnDialogAlertLeft;
    private CustomFontButton btnConfirm;

    private String address;
    private LatLng latLng;

    private Addresses addresses;

    private final OnSubmitListener onSubmitListener;

    public AddCourierAddressDialogFragment(OnSubmitListener onSubmitListener) {
        this.onSubmitListener = onSubmitListener;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = getActivity();
        preferenceHelper = PreferenceHelper.getInstance(requireActivity());
        if (getArguments() != null) {
            addresses = getArguments().getParcelable(Const.BUNDLE);
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_dialog_add_courier_address, container, false);
        etAddress = view.findViewById(R.id.etAddress);
        etName = view.findViewById(R.id.etName);
        etCountryCode = view.findViewById(R.id.etCountryCode);
        etPhone = view.findViewById(R.id.etPhone);
        FieldValidation.setMaxPhoneNumberInputLength(activity, etPhone);
        etNote = view.findViewById(R.id.etNote);
        btnConfirm = view.findViewById(R.id.btnConfirm);
        btnDialogAlertLeft = view.findViewById(R.id.btnDialogAlertLeft);
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

        etName.setText(String.format("%s %s", preferenceHelper.getFirstName(), preferenceHelper.getLastName()));
        etPhone.setText(preferenceHelper.getPhoneNumber());
        etCountryCode.setText(preferenceHelper.getCountryPhoneCode());

        if (addresses != null) {
            etAddress.setText(addresses.getAddress());
            if (addresses.getLocation().size() >= 2) {
                address = addresses.getAddress();
                latLng = new LatLng(addresses.getLocation().get(0), addresses.getLocation().get(1));
            }
            etName.setText(addresses.getUserDetails().getName());
            etCountryCode.setText(addresses.getUserDetails().getCountryPhoneCode());
            etPhone.setText(addresses.getUserDetails().getPhone());
            etNote.setText(addresses.getNote());
        }

        etAddress.setOnClickListener(this);
        btnDialogAlertLeft.setOnClickListener(this);
        btnConfirm.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.etAddress) {
            goToCheckoutDeliveryLocationActivity(etAddress.getText().toString());
        } else if (id == R.id.btnConfirm) {
            if (isValidate()) {
                Addresses addresses = new Addresses();
                addresses.setAddress(address);
                List<Double> locationList = new ArrayList<>();
                locationList.add(latLng.latitude);
                locationList.add(latLng.longitude);
                addresses.setLocation(locationList);
                addresses.setNote(etNote.getText().toString());
                CartUserDetail cartUserDetail = new CartUserDetail();
                cartUserDetail.setName(etName.getText().toString());
                cartUserDetail.setCountryPhoneCode(etCountryCode.getText().toString());
                cartUserDetail.setPhone(etPhone.getText().toString());
                addresses.setUserDetails(cartUserDetail);
                onSubmitListener.onSubmit(addresses);
                dismiss();
            }
        } else if (id == R.id.btnDialogAlertLeft) {
            dismiss();
        }
    }

    private boolean isValidate() {
        if (TextUtils.isEmpty(etAddress.getText()) || latLng == null) {
            Utils.showToast(getString(R.string.msg_please_enter_valid_address), activity);
            etAddress.requestFocus();
            return false;
        } else if (TextUtils.isEmpty(etName.getText())) {
            Utils.showToast(getString(R.string.msg_please_enter_valid_name), activity);
            etName.requestFocus();
            return false;
        } else if (TextUtils.isEmpty(etCountryCode.getText())) {
            Utils.showToast(getString(R.string.msg_please_enter_valid_country_code), activity);
            etCountryCode.requestFocus();
            return false;
        } else if (FieldValidation.isValidPhoneNumber(activity, etPhone.getText().toString())) {
            Utils.showToast(FieldValidation.getPhoneNumberValidationMessage(activity), activity);
            etPhone.requestFocus();
            return false;
        }
        return true;
    }

    private void checkCourierDeliveryAvailable(LatLng latLng, String cityId) {
        if (latLng == null) {
            return;
        }

        Utils.showCustomProgressDialog(activity, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.LATITUDE, latLng.latitude);
        map.put(Const.Params.LONGITUDE, latLng.longitude);
        map.put(Const.Params.CITY_ID, cityId);

        Call<IsSuccessResponse> responseCall = ApiClient.getClient().create(ApiInterface.class).checkCourierDeliveryAvailable(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (ParseContent.getInstance().isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body() != null) {
                        if (!response.body().isSuccess()) {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), activity);
                            etAddress.getText().clear();
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(AddCourierAddressDialogFragment.class.getSimpleName(), t);
            }
        });
    }

    private void goToCheckoutDeliveryLocationActivity(String address) {
        Intent intent = new Intent(activity, CheckoutDeliveryLocationActivity.class);
        intent.putExtra(Const.Params.ADDRESS, address);
        intent.putExtra(Const.REQUEST_CODE, Const.REQUEST_CODE_COURIER_ADDRESS);
        startActivityForResult(intent, Const.REQUEST_CODE_COURIER_ADDRESS);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && data != null) {
            if (requestCode == Const.REQUEST_CODE_COURIER_ADDRESS) {
                latLng = data.getExtras().getParcelable(Const.Params.LOCATION);
                address = data.getExtras().getString(Const.Params.ADDRESS);
                etAddress.setText(address);
                checkCourierDeliveryAvailable(latLng, CurrentBooking.getInstance().getBookCityId());
            }
        }
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        super.onDismiss(dialog);
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
    }

    public interface OnSubmitListener {
        void onSubmit(Addresses addresses);
    }
}
