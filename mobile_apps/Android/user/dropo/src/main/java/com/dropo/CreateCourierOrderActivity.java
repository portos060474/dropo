package com.dropo;

import static com.dropo.utils.ImageHelper.CHOOSE_PHOTO_FROM_GALLERY;
import static com.dropo.utils.ImageHelper.TAKE_PHOTO_FROM_CAMERA;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.appcompat.widget.LinearLayoutCompat;
import androidx.appcompat.widget.SwitchCompat;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.ItemTouchHelper;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.CourierAddressAdapter;
import com.dropo.adapter.CourierItemImageAdapter;
import com.dropo.adapter.DeliveryVehicleAdapter;
import com.dropo.component.CustomDialogAlert;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontCheckBox;
import com.dropo.component.CustomPhotoDialog;
import com.dropo.component.SwipeAndDragHelper;
import com.dropo.fragments.AddCourierAddressDialogFragment;
import com.dropo.fragments.CourierMapLocationFragment;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.datamodels.CartOrder;
import com.dropo.models.datamodels.CartUserDetail;
import com.dropo.models.datamodels.LegsItem;
import com.dropo.models.datamodels.RoutesItem;
import com.dropo.models.datamodels.StepsItem;
import com.dropo.models.datamodels.Vehicle;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.GoogleDirectionResponse;
import com.dropo.models.responsemodels.VehiclesResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.ImageCompression;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.Utils;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.PolylineOptions;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.gson.Gson;
import com.google.maps.android.PolyUtil;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class CreateCourierOrderActivity extends BaseAppCompatActivity {

    private Uri picUri;
    private CustomDialogAlert closedPermissionDialog;
    private ImageHelper imageHelper;
    private CourierItemImageAdapter courierItemImageAdapter;
    private RecyclerView rvCourierAddress, rcvItemImage;
    private CustomFontButton btnSubmitDetail;
    private AppCompatImageView ivAddCourierAddress;
    private LinearLayoutCompat llContactLess, llOptimizedRoute;
    private CustomFontCheckBox cbContactLess;

    private CourierAddressAdapter courierAddressAdapter;
    private final ArrayList<Addresses> courierAddressList = new ArrayList<>();
    private final ArrayList<Addresses> tempCourierAddressList = new ArrayList<>();

    private SwitchCompat switchOptimizedRoute;
    public PolylineOptions polylineOptions, optimizePolylineOptions;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_courier_order);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_courier_order));
        setToolbarRightIcon1(R.drawable.ic_map, this);
        initViewById();
        setViewListener();
        initRvCourierAddress();
        initCourierItemImageRcv();
        imageHelper = new ImageHelper(this);
        loadData();
    }

    @Override
    protected boolean isValidate() {
        String msg = null;
        if (courierAddressList.size() < 2) {
            msg = getString(R.string.msg_plz_add_at_least_pickup_and_destination_address);
            Utils.showMessageToast(msg, this);
        }

        return TextUtils.isEmpty(msg);
    }

    @Override
    protected void initViewById() {
        btnSubmitDetail = findViewById(R.id.btnSubmitDetail);
        ivAddCourierAddress = findViewById(R.id.ivAddCourierAddress);
        llContactLess = findViewById(R.id.llContactLess);
        cbContactLess = findViewById(R.id.cbContactLess);
        llOptimizedRoute = findViewById(R.id.llOptimizedRoute);
        switchOptimizedRoute = findViewById(R.id.switchOptimizedRoute);
    }

    @Override
    protected void setViewListener() {
        ivAddCourierAddress.setOnClickListener(this);
        btnSubmitDetail.setOnClickListener(this);
        switchOptimizedRoute.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                if (tempCourierAddressList.isEmpty() || tempCourierAddressList.size() != courierAddressList.size()) {
                    getGoogleDirection(getPickupLatLng(), getDestinationLatLng(), true, false, false, false);
                } else {
                    swapList(courierAddressList, tempCourierAddressList);
                    refreshRvCourierAddress();
                }
            } else {
                swapList(courierAddressList, tempCourierAddressList);
                refreshRvCourierAddress();
            }
        });
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnSubmitDetail) {
            if (isValidate()) {
                getDeliveryVehicle(currentBooking.getBookCityId());
            }
        } else if (id == R.id.ivAddCourierAddress) {
            openAddCourierAddressDialog(null, -1);
        } else if (id == R.id.ivToolbarRightIcon1) {
            if (isValidate()) {
                if (switchOptimizedRoute.isChecked() && optimizePolylineOptions != null) {
                    openCourierMapLocationDialog(true);
                } else {
                    if (polylineOptions != null) {
                        openCourierMapLocationDialog(false);
                    } else {
                        getGoogleDirection(getPickupLatLng(), getDestinationLatLng(), false, false, false, true);
                    }
                }
            }
        }
    }

    private void openAddCourierAddressDialog(Addresses addresses, int position) {
        AddCourierAddressDialogFragment addCourierAddressDialogFragment = new AddCourierAddressDialogFragment(new AddCourierAddressDialogFragment.OnSubmitListener() {
            @Override
            public void onSubmit(Addresses addresses) {
                addOrEditAddress(addresses, position);
            }
        });
        Bundle bundle = new Bundle();
        if (addresses != null) {
            bundle.putParcelable(Const.BUNDLE, addresses);
        }
        addCourierAddressDialogFragment.setArguments(bundle);
        addCourierAddressDialogFragment.show(getSupportFragmentManager(), addCourierAddressDialogFragment.getTag());
    }

    private void openCourierMapLocationDialog(boolean isOptimize) {
        CourierMapLocationFragment courierMapLocationFragment = new CourierMapLocationFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelableArrayList(Const.Params.ADDRESS, courierAddressList);
        bundle.putBoolean(Const.BUNDLE, isOptimize);
        courierMapLocationFragment.setArguments(bundle);
        courierMapLocationFragment.show(getSupportFragmentManager(), courierMapLocationFragment.getTag());
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
                    handleCrop(resultCode, data);
                    break;
                default:
                    break;
            }
        }
    }

    /**
     * This method is used for crop the placeholder which selected or captured
     */
    private void beginCrop(Uri sourceUri) {
        CropImage.activity(sourceUri).setGuidelines(com.theartofdev.edmodo.cropper.CropImageView.Guidelines.ON).start(this);
    }

    /**
     * This method is used for handel result after select placeholder from gallery .
     */
    private void onSelectFromGalleryResult(Intent data) {
        if (data != null) {
            picUri = data.getData();
            beginCrop(picUri);
        }
    }

    /**
     * This method is used for handel result after captured placeholder from camera .
     */
    private void onCaptureImageResult() {
        beginCrop(picUri);
    }

    /**
     * This method is used for  handel crop result after crop the placeholder.
     */
    private void handleCrop(int resultCode, Intent result) {
        CropImage.ActivityResult activityResult = CropImage.getActivityResult(result);
        if (resultCode == RESULT_OK) {
            if (courierItemImageAdapter != null) {
                setImage(activityResult.getUri());
            }


        } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
            Utils.showToast(activityResult.getError().getMessage(), this);
        }
    }

    private void setImage(final Uri uri) {
        final String path = ImageHelper.getFromMediaUriPfd(this, getContentResolver(), uri).getPath();
        new ImageCompression(this).setImageCompressionListener(compressionImagePath -> {
            courierItemImageAdapter.addCourierItemImage(compressionImagePath);
            rcvItemImage.scrollToPosition(courierItemImageAdapter.getItemCount() - 1);
        }).execute(path);
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
            //
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
                ActivityCompat.requestPermissions(CreateCourierOrderActivity.this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
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

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE) {
                goWithCameraAndStoragePermission(grantResults);
            }
        }
    }

    private void openPhotoSelectDialog() {
        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED || ContextCompat.checkSelfPermission(this, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.CAMERA, Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU ? Manifest.permission.READ_MEDIA_IMAGES : Manifest.permission.READ_EXTERNAL_STORAGE}, Const.PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE);
        } else {
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
    }

    private void initRvCourierAddress() {
        if (courierAddressAdapter == null) {

            Addresses addresses = new Addresses();
            addresses.setAddress(currentBooking.getCurrentAddress());
            List<Double> locationList = new ArrayList<>();
            locationList.add(currentBooking.getCurrentLatLng().latitude);
            locationList.add(currentBooking.getCurrentLatLng().longitude);
            addresses.setLocation(locationList);
            addresses.setNote("");
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setName(preferenceHelper.getFirstName() + " " + preferenceHelper.getLastName());
            cartUserDetail.setCountryPhoneCode(preferenceHelper.getCountryPhoneCode());
            cartUserDetail.setPhone(preferenceHelper.getPhoneNumber());
            addresses.setUserDetails(cartUserDetail);
            addOrEditAddress(addresses, -1);

            courierAddressAdapter = new CourierAddressAdapter(this, courierAddressList) {
                @Override
                public void onViewMoved(int oldPosition, int newPosition) {
                    Collections.swap(courierAddressList, oldPosition, newPosition);
                    notifyItemMoved(oldPosition, newPosition);
                    switchOptimizedRoute.setChecked(false);
                    polylineOptions = null;
                    optimizePolylineOptions = null;
                    tempCourierAddressList.clear();
                    rvCourierAddress.post(() -> new Handler().postDelayed(() -> refreshRvCourierAddress(), 1000));
                }

                @Override
                public void onViewSwiped(int position) {
                    removeAddress(position);
                    rvCourierAddress.post(() -> new Handler().postDelayed(() -> refreshRvCourierAddress(), 100));
                }

                @Override
                public void onSelect(int position) {
                    openAddCourierAddressDialog(courierAddressList.get(position), position);
                }

                @Override
                public void onDelete(int position) {
                    removeAddress(position);
                    rvCourierAddress.post(() -> new Handler().postDelayed(() -> refreshRvCourierAddress(), 100));
                }
            };

            rvCourierAddress = findViewById(R.id.rvCourierAddress);
            rvCourierAddress.setLayoutManager(new LinearLayoutManager(this, RecyclerView.VERTICAL, false));
            SwipeAndDragHelper swipeAndDragHelper = new SwipeAndDragHelper(courierAddressAdapter);
            ItemTouchHelper touchHelper = new ItemTouchHelper(swipeAndDragHelper);
            rvCourierAddress.setAdapter(courierAddressAdapter);
            touchHelper.attachToRecyclerView(rvCourierAddress);

            setViewAccordingToAddress();
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private void refreshRvCourierAddress() {
        if (courierAddressAdapter != null) {
            courierAddressAdapter.notifyDataSetChanged();
            setViewAccordingToAddress();
        }
        ivAddCourierAddress.setVisibility(preferenceHelper.getMaxCourierStopLimit() > courierAddressList.size() - 2 ? View.VISIBLE : View.GONE);
    }

    private void setViewAccordingToAddress() {
        llOptimizedRoute.setVisibility(courierAddressList.size() >= 4 ? View.VISIBLE : View.GONE);
        setSubmitButton(courierAddressList.size() >= 2);
        if (courierAddressList.size() <= 2) {
            switchOptimizedRoute.setChecked(false);
        }
    }

    private void setSubmitButton(boolean isEnable) {
        btnSubmitDetail.setEnabled(isEnable);
        btnSubmitDetail.setAlpha(isEnable ? 1.0F : 0.5F);
    }

    private void addOrEditAddress(Addresses addresses, int position) {
        polylineOptions = null;
        optimizePolylineOptions = null;

        if (position >= 0 && position < courierAddressList.size()) {
            courierAddressList.remove(position);
            courierAddressList.add(position, addresses);
        } else {
            courierAddressList.add(addresses);
        }
        if (switchOptimizedRoute.isChecked() && courierAddressList.size() > 2) {
            getGoogleDirection(getPickupLatLng(), getDestinationLatLng(), true, false, false, false);
        } else {
            refreshRvCourierAddress();
        }
    }

    private void removeAddress(int position) {
        polylineOptions = null;
        optimizePolylineOptions = null;

        courierAddressList.remove(position);
        if (courierAddressAdapter != null) {
            courierAddressAdapter.notifyItemRemoved(position);
        }
        if (switchOptimizedRoute.isChecked() && courierAddressList.size() > 2) {
            getGoogleDirection(getPickupLatLng(), getDestinationLatLng(), true, false, false, false);
        }

        setViewAccordingToAddress();
    }

    private void initCourierItemImageRcv() {
        rcvItemImage = findViewById(R.id.rcvItemImage);
        rcvItemImage.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
        courierItemImageAdapter = new CourierItemImageAdapter() {
            @Override
            public void addImage() {
                openPhotoSelectDialog();
            }
        };
        rcvItemImage.setAdapter(courierItemImageAdapter);
    }

    private void getGoogleDirection(LatLng pickUpLatLng, LatLng destinationLatLng, boolean isOptimize, boolean isRoundTrip, boolean isGotoInvoice, boolean isGotoMap) {
        Utils.showCustomProgressDialog(this, false);
        if (pickUpLatLng != null && destinationLatLng != null) {
            String origins = pickUpLatLng.latitude + "," + pickUpLatLng.longitude;
            String destination = destinationLatLng.latitude + "," + destinationLatLng.longitude;
            HashMap<String, String> hashMap = new HashMap<>();
            hashMap.put(Const.Google.ORIGIN, origins);
            hashMap.put(Const.Google.DESTINATION, destination);

            StringBuilder wayPoints = new StringBuilder();
            for (int i = 0; i < courierAddressList.size(); i++) {
                if (i != 0 && i != courierAddressList.size() - 1) {
                    wayPoints.append(courierAddressList.get(i).getLocation().get(0)).append(",").append(courierAddressList.get(i).getLocation().get(1)).append("|");
                }
            }
            if (!wayPoints.toString().isEmpty()) {
                hashMap.put(Const.Google.WAYPOINTS, Const.Google.OPTIMIZE + ":" + isOptimize + "|" + wayPoints);
            }

            hashMap.put(Const.Google.KEY, preferenceHelper.getGoogleKey());

            ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(Const.GOOGLE_API_URL).create(ApiInterface.class);
            Call<ResponseBody> call = apiInterface.getGoogleDirection(hashMap);
            call.enqueue(new Callback<ResponseBody>() {
                @Override
                public void onResponse(@NonNull Call<ResponseBody> call, @NonNull Response<ResponseBody> response) {
                    Utils.hideCustomProgressDialog();
                    if (ParseContent.getInstance().isSuccessful(response)) {
                        try {
                            if (response.body() != null) {
                                String googleResponse = response.body().string();
                                GoogleDirectionResponse googleDirectionResponse = new Gson().fromJson(googleResponse, GoogleDirectionResponse.class);

                                long totalTimeInSeconds = 0;
                                double totalDistanceInMeters = 0;

                                if (!googleDirectionResponse.getRoutes().isEmpty()) {
                                    if (isOptimize) {

                                        optimizePolylineOptions = new PolylineOptions();
                                        for (RoutesItem routesItem : googleDirectionResponse.getRoutes()) {
                                            for (LegsItem legsItem : routesItem.getLegs()) {
                                                totalTimeInSeconds += legsItem.getDuration().getValue();
                                                totalDistanceInMeters += legsItem.getDistance().getValue();
                                                for (StepsItem stepsItem : legsItem.getSteps()) {
                                                    optimizePolylineOptions.addAll(PolyUtil.decode(stepsItem.getPolyline().getPoints()));
                                                }
                                            }
                                        }

                                        optimizePolylineOptions.width(15);
                                        optimizePolylineOptions.color(ResourcesCompat.getColor(getResources(), R.color.color_app_path, null));

                                        tempCourierAddressList.clear();
                                        tempCourierAddressList.add(courierAddressList.get(0));
                                        List<Integer> waypointOrderIndex = googleDirectionResponse.getRoutes().get(0).getWaypointOrder();
                                        for (int i = 0; i < waypointOrderIndex.size(); i++) {
                                            tempCourierAddressList.add(courierAddressList.get(waypointOrderIndex.get(i) + 1));
                                        }
                                        tempCourierAddressList.add(courierAddressList.get(courierAddressList.size() - 1));

                                        swapList(courierAddressList, tempCourierAddressList);
                                        refreshRvCourierAddress();
                                    } else {
                                        polylineOptions = new PolylineOptions();
                                        for (RoutesItem routesItem : googleDirectionResponse.getRoutes()) {
                                            for (LegsItem legsItem : routesItem.getLegs()) {
                                                totalTimeInSeconds += legsItem.getDuration().getValue();
                                                totalDistanceInMeters += legsItem.getDistance().getValue();
                                                for (StepsItem stepsItem : legsItem.getSteps()) {
                                                    polylineOptions.addAll(PolyUtil.decode(stepsItem.getPolyline().getPoints()));
                                                }
                                            }
                                        }

                                        polylineOptions.width(15);
                                        polylineOptions.color(ResourcesCompat.getColor(getResources(), R.color.color_app_path, null));
                                    }
                                }

                                if (isGotoInvoice) {
                                    goToCourierOrderInvoiceActivity(CurrentBooking.getInstance().getVehicleId(), courierAddressList, totalTimeInSeconds, totalDistanceInMeters, isRoundTrip);
                                } else if (isGotoMap) {
                                    openCourierMapLocationDialog(isOptimize);
                                }
                            }
                        } catch (Exception e) {
                            AppLog.handleException(TAG, e);
                            e.printStackTrace();
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<ResponseBody> call, @NonNull Throwable t) {
                    Utils.hideCustomProgressDialog();
                    AppLog.handleThrowable(TAG, t);
                }
            });
        }
    }

    private void swapList(List<Addresses> list1, List<Addresses> list2) {
        List<Addresses> tmpList = new ArrayList<>(list1);
        list1.clear();
        list1.addAll(list2);
        list2.clear();
        list2.addAll(tmpList);
    }

    private LatLng getPickupLatLng() {
        return new LatLng(courierAddressList.get(0).getLocation().get(0), courierAddressList.get(0).getLocation().get(1));
    }

    private LatLng getDestinationLatLng() {
        return new LatLng(courierAddressList.get(courierAddressList.size() - 1).getLocation().get(0), courierAddressList.get(courierAddressList.size() - 1).getLocation().get(1));
    }

    private void getDeliveryVehicle(String cityId) {
        Utils.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.CITY_ID, cityId);
        map.put(Const.Params.DELIVERY_TYPE, Const.DeliveryType.COURIER);

        Call<VehiclesResponse> call = ApiClient.getClient().create(ApiInterface.class).getVehiclesList(map);
        call.enqueue(new Callback<VehiclesResponse>() {
            @Override
            public void onResponse(@NonNull Call<VehiclesResponse> call, @NonNull Response<VehiclesResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            if (response.body().getAdminVehicles() != null && !response.body().getAdminVehicles().isEmpty()) {
                                openCourierVehicleSelectDialog((ArrayList<Vehicle>) response.body().getAdminVehicles());
                            } else {
                                Utils.showToast(getString(R.string.text_no_vehicel), CreateCourierOrderActivity.this);
                            }
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CreateCourierOrderActivity.this);
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<VehiclesResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(CreateCourierOrderActivity.class.getSimpleName(), t);
            }
        });
    }

    private void loadData() {
        llContactLess.setVisibility(currentBooking.isAdminAllowContactLessDelivery() ? View.VISIBLE : View.GONE);
    }

    private void openCourierVehicleSelectDialog(ArrayList<Vehicle> vehicleArrayList) {
        final TextView tvPrice, tvDescription, tvLWH, tvWeight;
        final LinearLayout llRoundTrip, llLWH, llWeight;
        final SwitchCompat switchRoundTrip;
        final BottomSheetDialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.dialog_courier_vehicle_select);
        tvPrice = dialog.findViewById(R.id.tvPrice);
        tvDescription = dialog.findViewById(R.id.tvDescription);
        llRoundTrip = dialog.findViewById(R.id.llRoundTrip);
        switchRoundTrip = dialog.findViewById(R.id.switchRoundTrip);
        llLWH = dialog.findViewById(R.id.llLWH);
        tvLWH = dialog.findViewById(R.id.tvLWH);
        llWeight = dialog.findViewById(R.id.llWeight);
        tvWeight = dialog.findViewById(R.id.tvWeight);
        RecyclerView recyclerView = dialog.findViewById(R.id.rcvVehicle);
        final DeliveryVehicleAdapter deliveryVehicleAdapter = new DeliveryVehicleAdapter(this, vehicleArrayList) {
            @Override
            public void onSelect(Vehicle vehicle) {
                setVehicleData(vehicle, tvDescription, tvPrice, llRoundTrip, switchRoundTrip, llLWH, tvLWH, llWeight, tvWeight);
            }
        };

        recyclerView.setLayoutManager(new LinearLayoutManager(dialog.getContext(), LinearLayoutManager.HORIZONTAL, false));
        recyclerView.setAdapter(deliveryVehicleAdapter);

        dialog.findViewById(R.id.btnCancelOrder).setOnClickListener(v -> dialog.dismiss());
        dialog.findViewById(R.id.btnConfirmOrder).setOnClickListener(v -> {
            CurrentBooking.getInstance().setCourierItems(courierItemImageAdapter.getCourierItemImageList());
            addCourierItemInServerCart(deliveryVehicleAdapter.getVehicle().getId(), switchRoundTrip.isChecked());
            dialog.dismiss();
        });

        setVehicleData(vehicleArrayList.get(0), tvDescription, tvPrice, llRoundTrip, switchRoundTrip, llLWH, tvLWH, llWeight, tvWeight);

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.setCancelable(false);
        BottomSheetBehavior<?> behavior = dialog.getBehavior();
        behavior.setDraggable(false);
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        dialog.show();
    }

    private void setVehicleData(Vehicle vehicle, TextView tvDescription, TextView tvPrice, LinearLayout llRoundTrip, SwitchCompat switchRoundTrip, LinearLayout llLWH, TextView tvLWH, LinearLayout llWeight, TextView tvWeight) {
        tvDescription.setText(vehicle.getDescription());
        tvPrice.setText(String.format("%s%s", CurrentBooking.getInstance().getCurrency(), vehicle.getPricePerUnitDistance()));
        llRoundTrip.setVisibility(vehicle.isRoundTrip() ? View.VISIBLE : View.GONE);
        if (!vehicle.isRoundTrip()) {
            switchRoundTrip.setChecked(false);
        }
        int length = (int) vehicle.getLength();
        int width = (int) vehicle.getWidth();
        int height = (int) vehicle.getHeight();
        if (length > 0 && width > 0 && height > 0) {
            llLWH.setVisibility(View.VISIBLE);
            if (vehicle.getSizeType() == Const.Size.METER) {
                tvLWH.setText(String.format("%s * %s * %s " + getString(R.string.text_meter), length, width, height));
            } else if (vehicle.getSizeType() == Const.Size.CENTIMETER) {
                tvLWH.setText(String.format("%s * %s * %s " + getString(R.string.text_centimeter), length, width, height));
            } else {
                tvLWH.setText(String.format("%s * %s * %s", length, width, height));
            }
        } else {
            llLWH.setVisibility(View.GONE);
        }

        int minWeight = (int) vehicle.getMinWeight();
        int maxWeight = (int) vehicle.getMaxWeight();
        if (minWeight > 0 && maxWeight > 0) {
            llWeight.setVisibility(View.VISIBLE);
            if (vehicle.getWeightType() == Const.Weight.KG) {
                tvWeight.setText(String.format("%s - %s " + getString(R.string.text_kilogram), minWeight, maxWeight));
            } else if (vehicle.getSizeType() == Const.Weight.GRAM) {
                tvWeight.setText(String.format("%s - %s " + getString(R.string.text_gram), minWeight, maxWeight));
            } else {
                tvWeight.setText(String.format("%s - %s", minWeight, maxWeight));
            }
        } else {
            llWeight.setVisibility(View.GONE);
        }
    }

    /**
     * this method called webservice for add product in cart
     */
    private void addCourierItemInServerCart(String vehicleId, boolean isRoundTrip) {
        Utils.showCustomProgressDialog(this, false);

        CurrentBooking.getInstance().setVehicleId(vehicleId);
        CartOrder cartOrder = new CartOrder();
        cartOrder.setCityId(currentBooking.getBookCityId());
        cartOrder.setCountryId(currentBooking.getBookCountryId());
        cartOrder.setTaxIncluded(currentBooking.isTaxIncluded());
        cartOrder.setUseItemTax(currentBooking.isUseItemTax());
        cartOrder.setTaxesDetails(currentBooking.getTaxesDetails());
        cartOrder.setDeliveryType(Const.DeliveryType.COURIER);
        cartOrder.setUserType(Const.Type.USER);
        cartOrder.setStoreId("");
        if (isCurrentLogin()) {
            cartOrder.setUserId(preferenceHelper.getUserId());
            cartOrder.setAndroidId("");
        } else {
            cartOrder.setAndroidId(preferenceHelper.getAndroidId());
            cartOrder.setUserId("");
        }
        cartOrder.setServerToken(preferenceHelper.getSessionToken());

        if (courierAddressList.size() >= 2) {
            //pickup address
            Addresses pickupAddresses = new Addresses();
            pickupAddresses.setAddress(courierAddressList.get(0).getAddress());
            pickupAddresses.setCity("");
            pickupAddresses.setAddressType(Const.Type.PICKUP);
            pickupAddresses.setNote(courierAddressList.get(0).getNote());
            pickupAddresses.setUserType(Const.Type.STORE);
            ArrayList<Double> location = new ArrayList<>();
            location.add(courierAddressList.get(0).getLocation().get(0));
            location.add(courierAddressList.get(0).getLocation().get(1));
            pickupAddresses.setLocation(location);
            CartUserDetail cartUserDetail = new CartUserDetail();
            cartUserDetail.setEmail(preferenceHelper.getEmail());
            cartUserDetail.setCountryPhoneCode(courierAddressList.get(0).getUserDetails().getCountryPhoneCode());
            cartUserDetail.setName(courierAddressList.get(0).getUserDetails().getName());
            cartUserDetail.setImageUrl(preferenceHelper.getProfilePic());
            cartUserDetail.setPhone(courierAddressList.get(0).getUserDetails().getPhone());
            pickupAddresses.setUserDetails(cartUserDetail);

            final ArrayList<Addresses> pickupsAddressList = new ArrayList<>();
            pickupsAddressList.add(pickupAddresses);

            // destination address
            final ArrayList<Addresses> destinationsAddressList = new ArrayList<>();
            for (int i = 1; i < courierAddressList.size(); i++) {
                Addresses destAddresses = new Addresses();
                destAddresses.setAddress(courierAddressList.get(i).getAddress());
                destAddresses.setCity("");
                destAddresses.setAddressType(Const.Type.DESTINATION);
                destAddresses.setNote(courierAddressList.get(i).getNote());
                destAddresses.setUserType(Const.Type.USER);
                ArrayList<Double> location1 = new ArrayList<>();
                location1.add(courierAddressList.get(i).getLocation().get(0));
                location1.add(courierAddressList.get(i).getLocation().get(1));
                destAddresses.setLocation(location1);
                CartUserDetail cartUserDetail1 = new CartUserDetail();
                cartUserDetail1.setEmail("");
                cartUserDetail1.setCountryPhoneCode(courierAddressList.get(i).getUserDetails().getCountryPhoneCode());
                cartUserDetail1.setName(courierAddressList.get(i).getUserDetails().getName());
                cartUserDetail1.setPhone(courierAddressList.get(i).getUserDetails().getPhone());
                destAddresses.setUserDetails(cartUserDetail1);

                destinationsAddressList.add(destAddresses);
            }

            cartOrder.setPickupAddresses(pickupsAddressList);
            cartOrder.setDestinationAddresses(destinationsAddressList);
        }

        if (currentBooking.isTableBooking() && currentBooking.getSchedule() != null) {
            cartOrder.setOrderStartAt(currentBooking.getSchedule().getScheduleDateAndStartTimeMilli());
            cartOrder.setOrderStartAt2(currentBooking.getSchedule().getScheduleDateAndEndTimeMilli());
            cartOrder.setTableId(currentBooking.getTableId());
        }

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddCartResponse> responseCall = apiInterface.addItemInCart(ApiClient.makeGSONRequestBody(cartOrder));
        responseCall.enqueue(new Callback<AddCartResponse>() {
            @Override
            public void onResponse(@NonNull Call<AddCartResponse> call, @NonNull Response<AddCartResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    Utils.hideCustomProgressDialog();
                    if (response.body() != null) {
                        if (response.body().isSuccess()) {
                            currentBooking.setCartId(response.body().getCartId());
                            currentBooking.setCartCityId(response.body().getCityId());
                            currentBooking.setDeliveryType(Const.DeliveryType.COURIER);
                            getGoogleDirection(getPickupLatLng(), getDestinationLatLng(), false, isRoundTrip, true, false);
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), CreateCourierOrderActivity.this);
                        }
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddCartResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.PRODUCT_SPE_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void goToCourierOrderInvoiceActivity(String vehicleId, ArrayList<Addresses> addressesList, long totalTimeInSeconds, double totalDistanceInMeters, boolean isRoundTrip) {
        currentBooking.setAllowContactLessDelivery(cbContactLess.isChecked());
        Intent intent = new Intent(this, CourierOrderInvoiceActivity.class);
        intent.putExtra(Const.Params.VEHICLE_ID, vehicleId);
        intent.putExtra(Const.Params.ADDRESS, addressesList);
        intent.putExtra(Const.Params.TOTAL_TIME, totalTimeInSeconds);
        intent.putExtra(Const.Params.TOTAL_DISTANCE, totalDistanceInMeters);
        intent.putExtra(Const.Params.IS_ROUND_TRIP, isRoundTrip);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}
