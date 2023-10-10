package com.dropo.provider;

import static com.dropo.provider.utils.Const.Params.REQUEST_ID;
import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.app.Dialog;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.adapter.DeliveryAddressAdapter;
import com.dropo.provider.adapter.HistoryDetailAdapter;
import com.dropo.provider.adapter.OrderDetailsAdapter;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.component.CustomImageView;
import com.dropo.provider.fragments.FeedbackFragment;
import com.dropo.provider.fragments.HistoryFragment;
import com.dropo.provider.fragments.InvoiceFragment;
import com.dropo.provider.models.datamodels.Addresses;
import com.dropo.provider.models.datamodels.OrderPayment;
import com.dropo.provider.models.datamodels.Status;
import com.dropo.provider.models.datamodels.StoreDetail;
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.models.responsemodels.OrderHistoryDetailResponse;
import com.dropo.provider.models.singleton.CurrentOrder;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class HistoryDetailActivity extends BaseAppCompatActivity {

    private OrderHistoryDetailResponse historyDetailResponse;
    private ImageView ivHistoryStoreImage, ivProviderImage;
    private RecyclerView rcvOrderItem;
    private CustomFontTextViewTitle tvHistoryOrderName, tvProviderName, tvDeliveryDate, tvRattingToStore, tvRattingToUser;
    private StoreDetail storesItem;
    private String payment;
    private CustomFontTextView tvEstTime, tvEstDistance, tvHistoryDetailOrderNumber;
    private CustomImageView tvStoreRatings, tvRatings;
    private ImageView ivOrderAccepted, ivOrderPrepared, ivOrderOnWay, ivOrderOnDoorstep;
    private CustomFontTextView tvOrderAcceptedDate, tvOrderReadyDate, tvOrderOnTheWayDate, tvPickUpImage, tvDeliveryImage, tvOrderReceiveDate;
    private String pickupImageUrl, deliveryImageUrl, unit;
    private RecyclerView rvAddress;
    private ArrayList<Addresses> addressesList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history_detail);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_history_detail));
        initViewById();
        setViewListener();
        setToolbarRightIcon(R.drawable.ic_invoice, view -> {
            if (historyDetailResponse.getOrderPaymentDetail() != null) {
                goToInvoiceFragment(historyDetailResponse.getOrderPaymentDetail(), payment, null, historyDetailResponse.getOrderPaymentDetail().getOrderId(), historyDetailResponse.getOrderRequestDetail().getDeliveryType());
            } else {
                Utils.showToast(getResources().getString(R.string.text_invoice_not_found), this);
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        loadExtraData();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        tvHistoryOrderName = findViewById(R.id.tvHistoryOrderName);
        tvProviderName = findViewById(R.id.tvCustomerName);
        rvAddress = findViewById(R.id.rvAddress);
        tvDeliveryDate = findViewById(R.id.tvDetailDate);
        rcvOrderItem = findViewById(R.id.rcvOrderItem);
        ivHistoryStoreImage = findViewById(R.id.ivHistoryStoreImage);
        ivProviderImage = findViewById(R.id.ivCustomerImage);
        tvEstDistance = findViewById(R.id.tvEstDistance);
        tvEstTime = findViewById(R.id.tvEstTime);
        tvStoreRatings = findViewById(R.id.tvStoreRatings);
        tvRatings = findViewById(R.id.tvRatings);
        tvHistoryDetailOrderNumber = findViewById(R.id.tvHistoryDetailOrderNumber);
        ivOrderAccepted = findViewById(R.id.ivOrderAccepted);
        ivOrderPrepared = findViewById(R.id.ivOrderPrepared);
        ivOrderOnWay = findViewById(R.id.ivOrderOnWay);
        ivOrderOnDoorstep = findViewById(R.id.ivOrderOnDoorstep);
        tvEstTime = findViewById(R.id.tvEstTime);
        tvOrderAcceptedDate = findViewById(R.id.tvOrderAcceptedDate);
        tvOrderReadyDate = findViewById(R.id.tvOrderReadyDate);
        tvOrderOnTheWayDate = findViewById(R.id.tvOrderOnTheWayDate);
        tvOrderReceiveDate = findViewById(R.id.tvOrderReceiveDate);
        tvPickUpImage = findViewById(R.id.tvPickUpImage);
        tvDeliveryImage = findViewById(R.id.tvDeliveryImage);
        tvRattingToUser = findViewById(R.id.tvRattingToUser);
        tvRattingToStore = findViewById(R.id.tvRattingToStore);
    }

    @Override
    protected void setViewListener() {
        tvRatings.setOnClickListener(this);
        tvStoreRatings.setOnClickListener(this);
        tvPickUpImage.setOnClickListener(this);
        tvDeliveryImage.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    private void loadExtraData() {
        if (getIntent().getExtras() != null) {
            getOrderHistoryDetail(getIntent().getExtras().getString(Const.Params.ORDER_ID));
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.tvStoreRatings) {
            if (!historyDetailResponse.getOrderDetail().isProviderRatedToStore()) {
                goToFeedbackFragment(null, storesItem, historyDetailResponse.getOrderRequestDetail().getId());
            }
        } else if (id == R.id.tvRatings) {
            if (!historyDetailResponse.getOrderDetail().isProviderRatedToUser()) {
                historyDetailResponse.getUser().setName(historyDetailResponse.getUser().getFirstName() + " " + historyDetailResponse.getUser().getLastName());
                goToFeedbackFragment(historyDetailResponse.getUser(), null, historyDetailResponse.getOrderRequestDetail().getId());
            }
        } else if (id == R.id.tvPickUpImage) {
            openDialogItemImage(pickupImageUrl, getResources().getString(R.string.text_pickup_image));
        } else if (id == R.id.tvDeliveryImage) {
            openDialogItemImage(deliveryImageUrl, getResources().getString(R.string.text_delivery_image));
        }
    }

    /**
     * this method called a webservice for get order history detail
     *
     * @param orderId order id in string
     */
    private void getOrderHistoryDetail(String orderId) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.REQUEST_ID, orderId);
        map.put(Const.Params.PROVIDER_ID, preferenceHelper.getProviderId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<OrderHistoryDetailResponse> responseCall = apiInterface.getOrderHistoryDetail(map);
        responseCall.enqueue(new Callback<OrderHistoryDetailResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderHistoryDetailResponse> call, @NonNull Response<OrderHistoryDetailResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        historyDetailResponse = response.body();
                        String orderNumber = getResources().getString(R.string.text_request_number) + " " + "#" + historyDetailResponse.getOrderRequestDetail().getUniqueId();
                        setTitleOnToolBar(orderNumber);
                        storesItem = response.body().getStoreDetail();
                        payment = response.body().getPayment();
                        initRcvOrder();
                        loadOrderData();
                        getDateAndTimeOnStatus(historyDetailResponse.getOrderDetail().getStatusTime(), historyDetailResponse.getOrderRequestDetail().getStatusTime());
                        int orderStatus = historyDetailResponse.getOrderDetail().getOrderStatus();
                        checkOrderStatus(orderStatus);
                        Utils.hideCustomProgressDialog();
                        if (response.body().getOrderPaymentDetail() != null) {
                            unit = response.body().getOrderPaymentDetail().isDistanceUnitMile() ? getResources().getString(R.string.unit_mile) : getResources().getString(R.string.unit_km);
                            tvEstDistance.setText(String.format("%s%s", parseContent.decimalTwoDigitFormat.format(historyDetailResponse.getOrderPaymentDetail().getTotalDistance()), unit));
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), HistoryDetailActivity.this);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderHistoryDetailResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(HistoryFragment.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method load order data in view
     */
    private void loadOrderData() {
        boolean isCourier = historyDetailResponse.getOrderRequestDetail().getDeliveryType() == Const.DeliveryType.COURIER;
        if (historyDetailResponse.getOrderPaymentDetail() != null) {
            tvEstTime.setText(Utils.minuteToHoursMinutesSeconds(historyDetailResponse.getOrderPaymentDetail().getTotalTime()));
        }
        intRVAddress();
        try {
            Date date = parseContent.webFormat.parse(historyDetailResponse.getOrderRequestDetail().getCompletedAt());
            if (date != null) {
                String dateCreated = parseContent.dateFormat.format(date);
                String currentDate = parseContent.dateFormat.format(new Date());

                if (dateCreated.equals(currentDate)) {
                    tvDeliveryDate.setText(this.getString(R.string.text_today));
                } else if (dateCreated.equals(getYesterdayDateString())) {
                    tvDeliveryDate.setText(this.getString(R.string.text_yesterday));
                } else {
                    tvDeliveryDate.setText(String.format("%s %s", Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))), parseContent.dateFormatMonth.format(date)));
                }
            }
        } catch (ParseException e) {
            AppLog.handleException(HistoryFragment.class.getName(), e);
        }

        if (historyDetailResponse.getOrderRequestDetail().getDeliveryType() == Const.DeliveryType.COURIER) {
            UserDetail userDetail = historyDetailResponse.getOrderRequestDetail().getDestinationAddresses().get(0).getUserDetails();
            tvProviderName.setText(userDetail.getName());
            GlideApp.with(this).load(IMAGE_URL + userDetail.getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivProviderImage);
        } else {
            tvProviderName.setText(String.format("%s %s", historyDetailResponse.getUser().getFirstName(), historyDetailResponse.getUser().getLastName()));
            GlideApp.with(this).load(IMAGE_URL + historyDetailResponse.getUser().getImageUrl()).dontAnimate().placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null)).into(ivProviderImage);
        }

        String orderNumber = getResources().getString(R.string.text_order_number) + " " + "#" + historyDetailResponse.getOrderDetail().getUniqueId();
        tvHistoryDetailOrderNumber.setText(orderNumber);
        GlideApp.with(this)
                .load(IMAGE_URL + storesItem.getImageUrl())
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                .into(ivHistoryStoreImage);

        if (isCourier) {
            tvHistoryOrderName.setText(Const.COURIER);
        } else {
            tvHistoryOrderName.setText(storesItem.getName());
        }

        if (isCourier) {
            tvStoreRatings.setVisibility(View.GONE);
        } else if (historyDetailResponse.getOrderDetail().isProviderRatedToStore()) {
            tvRattingToStore.setVisibility(View.VISIBLE);
            tvRattingToStore.setText(String.valueOf(historyDetailResponse.getProviderRattingToStore()));
        }

        if (historyDetailResponse.getOrderDetail().isProviderRatedToUser()) {
            tvRattingToUser.setVisibility(View.VISIBLE);
            tvRattingToUser.setText(String.valueOf(historyDetailResponse.getProviderRattingToUser()));
        }
    }

    private void intRVAddress() {
        if (historyDetailResponse.getOrderRequestDetail() != null) {
            addressesList = new ArrayList<>();
            addressesList.addAll(historyDetailResponse.getOrderRequestDetail().getPickupAddresses());
            addressesList.addAll(historyDetailResponse.getOrderRequestDetail().getDestinationAddresses());

            if (historyDetailResponse.getOrderRequestDetail().getStatusTime() != null && !historyDetailResponse.getOrderRequestDetail().getStatusTime().isEmpty()) {
                for (int i = 1; i < addressesList.size(); i++) {
                    for (Status status : historyDetailResponse.getOrderRequestDetail().getStatusTime()) {
                        if (status.getStopNo() == i) {
                            try {
                                Date date = parseContent.webFormat.parse(status.getDate());
                                if (date != null) {
                                    String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date))) + " " + parseContent.dateFormatMonth.format(date);
                                    addressesList.get(i).setArrivedTime(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date)));
                                }
                                break;
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }

            DeliveryAddressAdapter addressAdapter = new DeliveryAddressAdapter(this, addressesList);
            rvAddress.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvAddress.setNestedScrollingEnabled(false);
            rvAddress.setAdapter(addressAdapter);
        }
    }

    private void goToInvoiceFragment(OrderPayment orderPayment, String payment, UserDetail userDetail, String requestId, int deliveryType) {
        InvoiceFragment invoiceFragment = new InvoiceFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable(Const.ORDER_PAYMENT, orderPayment);
        bundle.putString(Const.PAYMENT, payment);
        bundle.putParcelable(Const.USER_DETAIL, userDetail);
        bundle.putString(Const.Params.REQUEST_ID, requestId);
        bundle.putBoolean(Const.BACK_TO_ACTIVE_DELIVERY, false);
        bundle.putInt(Const.Params.DELIVERY_TYPE, deliveryType);
        invoiceFragment.setArguments(bundle);
        invoiceFragment.show(getSupportFragmentManager(), invoiceFragment.getTag());
    }

    private void goToFeedbackFragment(UserDetail userDetail, StoreDetail storeDetail, String requestId) {
        FeedbackFragment feedbackFragment = new FeedbackFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable(Const.USER_DETAIL, userDetail);
        bundle.putParcelable(Const.STORE_DETAIL, storeDetail);
        bundle.putString(REQUEST_ID, requestId);
        bundle.putString(Const.Params.NEW_ORDER, null);
        feedbackFragment.setArguments(bundle);
        feedbackFragment.show(getSupportFragmentManager(), feedbackFragment.getTag());
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void initRcvOrder() {
        rcvOrderItem.setLayoutManager(new LinearLayoutManager(this));
        if (historyDetailResponse.getCartDetail() != null) {
            if (historyDetailResponse.getCartDetail().getDeliveryType() == Const.DeliveryType.COURIER) {
                OrderDetailsAdapter itemAdapter = new OrderDetailsAdapter(this, historyDetailResponse.getCartDetail().getOrderDetails(), CurrentOrder.getInstance().getCurrency(), false);
                rcvOrderItem.setAdapter(itemAdapter);
                itemAdapter.setDeliveryType(historyDetailResponse.getCartDetail().getDeliveryType());
            } else {
                rcvOrderItem.setAdapter(new HistoryDetailAdapter(historyDetailResponse.getCartDetail().getOrderDetails()));
            }
        }
        rcvOrderItem.setNestedScrollingEnabled(false);
    }

    private String getYesterdayDateString() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        return parseContent.dateFormat.format(cal.getTime());
    }

    private void checkOrderStatus(int orderStatus) {
        switch (orderStatus) {
            case Const.OrderStatus.WAITING_FOR_ACCEPT_STORE:
            case Const.OrderStatus.STORE_ORDER_ACCEPTED:
            case Const.OrderStatus.STORE_ORDER_PREPARING:
            case Const.OrderStatus.STORE_ORDER_READY:
            case Const.OrderStatus.DELIVERY_MAN_REJECTED:
            case Const.OrderStatus.DELIVERY_MAN_CANCELLED:
            case Const.OrderStatus.DELIVERY_MAN_NOT_FOUND:
                ivOrderAccepted.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_black_2, getTheme()));
                break;
            case Const.OrderStatus.DELIVERY_MAN_ACCEPTED:
            case Const.OrderStatus.DELIVERY_MAN_COMING:
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED:
                ivOrderAccepted.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderPrepared.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_black_2, getTheme()));
                break;

            case Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER:
            case Const.OrderStatus.DELIVERY_MAN_STARTED_DELIVERY:
                ivOrderAccepted.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderPrepared.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderOnWay.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_black_2, getTheme()));
                break;
            case Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION:
                ivOrderAccepted.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderPrepared.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderOnWay.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderOnDoorstep.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_black_2, getTheme()));
                break;
            case Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY:
                ivOrderAccepted.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderPrepared.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderOnWay.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                ivOrderOnDoorstep.setImageDrawable(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_checked, getTheme()));
                break;
            case Const.OrderStatus.STORE_ORDER_REJECTED:
                break;
            default:
                break;
        }
    }

    private void getDateAndTimeOnStatus(ArrayList<Status> orderStatusList, ArrayList<Status> deliveryStatusList) {
        List<Status> statusList = new ArrayList<>();
        statusList.addAll(orderStatusList);
        statusList.addAll(deliveryStatusList);
        for (Status status : statusList) {
            if (Const.OrderStatus.DELIVERY_MAN_ACCEPTED == status.getStatus()) {
                setDateAnTime(tvOrderAcceptedDate, status.getDate());
            } else if (Const.OrderStatus.DELIVERY_MAN_PICKED_ORDER == status.getStatus()) {
                setDateAnTime(tvOrderReadyDate, status.getDate());
                if (!TextUtils.isEmpty(status.getImageUrl())) {
                    tvPickUpImage.setVisibility(View.VISIBLE);
                    pickupImageUrl = status.getImageUrl();
                }
            } else if (Const.OrderStatus.DELIVERY_MAN_ARRIVED_AT_DESTINATION == status.getStatus()) {
                setDateAnTime(tvOrderOnTheWayDate, status.getDate());
                if (!TextUtils.isEmpty(status.getImageUrl())) {
                    tvDeliveryImage.setVisibility(View.VISIBLE);
                    deliveryImageUrl = status.getImageUrl();
                }
            } else if (Const.OrderStatus.DELIVERY_MAN_COMPLETE_DELIVERY == status.getStatus()) {
                setDateAnTime(tvOrderReceiveDate, status.getDate());
            }
        }
    }

    private void setDateAnTime(CustomFontTextView dateView, String date) {
        try {
            Date date1 = parseContent.webFormat.parse(date);
            if (date1 != null) {
                String dateString = Utils.getDayOfMonthSuffix(Integer.parseInt(parseContent.day.format(date1))) + " " + parseContent.dateFormatMonth.format(date1);
                dateView.setText(String.format("%s, %s", dateString, parseContent.timeFormat_am.format(date1)));
                dateView.setVisibility(View.VISIBLE);
            }
        } catch (ParseException e) {
            AppLog.handleException(HistoryDetailActivity.class.getSimpleName(), e);
        }
    }

    public void openDialogItemImage(String imageUrl, String title) {
        Dialog dialog = new BottomSheetDialog(this);
        dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        dialog.setContentView(R.layout.item_image_full_screen);
        TextView tvDialogAlertTitle = dialog.findViewById(R.id.tvDialogAlertTitle);
        tvDialogAlertTitle.setText(title);
        ImageView imageView = dialog.findViewById(R.id.itemImage);
        ImageView ivDelete = dialog.findViewById(R.id.ivDelete);

        GlideApp.with(this)
                .load(IMAGE_URL + imageUrl)
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(getResources(), R.drawable.placeholder, null))
                .into(imageView);

        ivDelete.setOnClickListener(v -> dialog.dismiss());

        WindowManager.LayoutParams params = dialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        dialog.getWindow().setAttributes(params);
        dialog.show();
    }

    public void submitStoreReview() {
        tvStoreRatings.setVisibility(View.VISIBLE);
        loadExtraData();
    }

    public void submitUserReview() {
        tvRatings.setVisibility(View.VISIBLE);
        loadExtraData();
    }
}