package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.CancellationReasonAdapter;
import com.dropo.store.adapter.InvoiceAdapter;
import com.dropo.store.adapter.OrderListAdapter;
import com.dropo.store.bluetoothprinter.BluetoothDeviceManager;
import com.dropo.store.bluetoothprinter.PrintManager;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.component.CustomEditTextDialog;
import com.dropo.store.component.NearestProviderDialog;
import com.dropo.store.component.VehicleDialog;
import com.dropo.store.models.datamodel.Invoice;
import com.dropo.store.models.datamodel.InvoicePayment;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.datamodel.OrderDetail;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.OrderPaymentDetail;
import com.dropo.store.models.datamodel.TaxesDetail;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.models.responsemodel.CancellationReasonsResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.OrderDetailResponse;
import com.dropo.store.models.responsemodel.OrderStatusResponse;
import com.dropo.store.models.singleton.CurrentBooking;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.singleton.UpdateOrder;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.section.OrderDetailsSection;
import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.TwilioCallHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputEditText;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.TimeZone;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class OrderDetailActivity extends BaseActivity implements BaseActivity.OrderListener {

    private final ArrayList<OrderDetails> orderDetailList = new ArrayList<>();
    private OrderDetail orderDetail;
    private OrderDetailsSection orderItemSectionDetailAdapter;
    private Button btnAction, btnReject;
    private Button ivBtnCancel;
    private TextView tvClientName, tvTotalItemPrice, tvOrderNo, tvPickupType;
    private ImageView ivClient;
    private LinearLayout llBtn;
    private String cancelReason, userPhone;
    private int currentPosition = -1;
    private BottomSheetDialog cancelOrderDialog;
    private CustomEditTextDialog customEditTextDialog;
    private int orderStatus;
    private TextView tvOrderSchedule;
    private CustomTextView tvDeliveryAddress;
    private ImageView ivToolbarRightIcon3;
    private TextView tvPaymentMode;
    private LinearLayout llCallUser, llEditOrder, llInvoice, llScheduleOrder, llNote;
    private BottomSheetDialog chatDialog;
    private CustomAlterDialog noteDialog;
    private BluetoothDeviceManager bluetoothDeviceManager;
    private FrameLayout flCart;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_detail);

        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_order));
        ivToolbarRightIcon3 = findViewById(R.id.ivToolbarRightIcon3);
        ivToolbarRightIcon3.setImageDrawable(AppColor.getThemeColorDrawable(R.drawable.ic_chat, this));
        checkPermission();
        tvClientName = findViewById(R.id.tvClientName);
        tvTotalItemPrice = findViewById(R.id.tvTotalItemPrice);
        tvPaymentMode = findViewById(R.id.tvPaymentMode);
        ivClient = findViewById(R.id.ivClient);
        btnAction = findViewById(R.id.btnAction);
        btnReject = findViewById(R.id.btnReject);
        ivBtnCancel = findViewById(R.id.ivBtnCancel);
        llBtn = findViewById(R.id.llBtn);
        tvDeliveryAddress = findViewById(R.id.tvDeliveryAddress);
        flCart = findViewById(R.id.flCart);
        flCart.setVisibility(View.VISIBLE);

        tvOrderNo = findViewById(R.id.tvOrderNo);
        RecyclerView rcItemList = findViewById(R.id.recyclerView);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        rcItemList.setLayoutManager(linearLayoutManager);
        rcItemList.setDescendantFocusability(ViewGroup.FOCUS_BLOCK_DESCENDANTS);
        orderItemSectionDetailAdapter = new OrderDetailsSection(orderDetailList, this);
        rcItemList.setAdapter(orderItemSectionDetailAdapter);
        llCallUser = findViewById(R.id.llCallUser);
        llEditOrder = findViewById(R.id.llEditOrder);
        llInvoice = findViewById(R.id.llInvoice);
        llNote = findViewById(R.id.llNote);
        tvOrderSchedule = findViewById(R.id.tvOrderSchedule);
        tvPickupType = findViewById(R.id.tvPickupType);
        llScheduleOrder = findViewById(R.id.llScheduleOrder);
    }

    private void setUpClickListeners() {
        ivBtnCancel.setOnClickListener(this);
        btnAction.setOnClickListener(this);
        btnReject.setOnClickListener(this);
        llCallUser.setOnClickListener(this);
        llEditOrder.setOnClickListener(this);
        llInvoice.setOnClickListener(this);
        llNote.setOnClickListener(this);
        ivToolbarRightIcon3.setOnClickListener(this);
    }

    private void checkPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED
                && ContextCompat.checkSelfPermission(this, Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.BLUETOOTH_SCAN, Manifest.permission.BLUETOOTH_ADVERTISE, Manifest.permission.BLUETOOTH_CONNECT}, Constant.PERMISSION_FOR_BLUETOOTH);
        } else {
            initPrinter();
        }
    }

    @Override
    protected void onStart() {
        super.onStart();
        getOrderDetail();
        setOrderListener(this);
    }

    @Override
    protected void onStop() {
        super.onStop();
        setOrderListener(null);
        if (bluetoothDeviceManager != null)
            bluetoothDeviceManager.stopDiscoveryOfDevices();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        updateUiPrinterButton(true);
        return true;
    }

    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == Constant.PERMISSION_FOR_BLUETOOTH) {
            if (grantResults.length > 0) {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    initPrinter();
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.llEditOrder) {
            if (orderDetail.getOrder() != null) {
                goToOrderUpdateActivity(orderDetail.getOrder());
            } else {
                Utilities.showToast(OrderDetailActivity.this, getString(R.string.something_went_wrong));
            }
        } else if (id == R.id.btnAction) {
            handleActionBtnClick(orderStatus);
        } else if (id == R.id.btnReject) {
            if (orderStatus == Constant.STORE_ORDER_READY) {
                openCompleteDeliveryDialog();
            } else {
                getCancellationReasons(Constant.STORE_ORDER_REJECTED);
            }
        } else if (id == R.id.ivBtnCancel) {
            getCancellationReasons(Constant.STORE_ORDER_CANCELLED);
        } else if (id == R.id.llCallUser) {
            if (preferenceHelper.getIsEnableTwilioCallMasking()) {
                TwilioCallHelper.callViaTwilio(OrderDetailActivity.this, llCallUser, orderDetail.getOrder().getId(), String.valueOf(Constant.Type.USER));
            } else {
                Utilities.openCallChooser(OrderDetailActivity.this, userPhone);
            }
        } else if (id == R.id.ivToolbarRightIcon3) {
            openChatDialog();
        } else if (id == R.id.llInvoice) {
            if (orderDetail != null && orderDetail.getOrderPaymentDetail() != null) {
                orderDetail.getOrderPaymentDetail().setTaxIncluded(orderDetail.getTaxIncluded());
                openInvoiceDialog(orderDetail.getOrderPaymentDetail());
            } else {
                Utilities.showToast(OrderDetailActivity.this, getString(R.string.something_went_wrong));
            }
        } else if (id == R.id.llNote) {
            openOrderNoteDialog();
        }
    }

    public void openOrderNoteDialog() {
        if (noteDialog != null && noteDialog.isShowing()) {
            return;
        }

        noteDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_note), orderDetail.getOrder().getDestinationAddresses().get(0).getNote(), false, getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                noteDialog.dismiss();
            }
        };
        noteDialog.show();
    }

    private void openChatDialog() {
        if (chatDialog != null && chatDialog.isShowing()) {
            return;
        }
        chatDialog = new BottomSheetDialog(this);
        chatDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        chatDialog.setContentView(R.layout.dialog_chat_with);
        TextView tvChatWithUser = chatDialog.findViewById(R.id.tvChatWithUser);
        tvChatWithUser.setOnClickListener(view -> {
            chatDialog.dismiss();
            String name = tvClientName.getText().toString();
            gotToChatActivity(Constant.ChatType.USER_AND_STORE, name, orderDetail.getOrder().getUserId());
        });
        TextView tvChatWithAdmin = chatDialog.findViewById(R.id.tvChatWithAdmin);
        tvChatWithAdmin.setOnClickListener(view -> {
            chatDialog.dismiss();
            gotToChatActivity(Constant.ChatType.ADMIN_AND_STORE, getResources().getString(R.string.text_admin), Constant.ADMIN_RECIVER_ID);
        });
        TextView tvChatWithDeliveryMan = chatDialog.findViewById(R.id.tvChatWithDeliveryMan);
        tvChatWithDeliveryMan.setVisibility(View.GONE);

        chatDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> chatDialog.dismiss());
        WindowManager.LayoutParams params = chatDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        chatDialog.show();
    }

    /**
     * this method call a webservice for reject or cancel order
     *
     * @param rejectOrCancelStatus rejectOrCancelStatus
     * @param context              context
     * @param orderItemId          orderItemId
     */
    private void rejectOrCancelOrder(int rejectOrCancelStatus, final Context context, String orderItemId, String cancelReason) {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = getCommonParam(orderItemId);
        map.put(Constant.ORDER_STATUS, rejectOrCancelStatus);
        map.put(Constant.CANCEL_REASON, cancelReason);
        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).CancelOrRejectOrder(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void getCancellationReasons(final int status) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<CancellationReasonsResponse> responseCall = apiInterface.getCancellationReasons(map);
        responseCall.enqueue(new Callback<CancellationReasonsResponse>() {
            @Override
            public void onResponse(@NonNull Call<CancellationReasonsResponse> call, @NonNull Response<CancellationReasonsResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response) && response.body() != null) {
                    openCancelOrderDialog(status, response.body().getReasons());
                } else {
                    openCancelOrderDialog(status, new ArrayList<>());
                }
            }

            @Override
            public void onFailure(@NonNull Call<CancellationReasonsResponse> call, Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(TAG, t);
                openCancelOrderDialog(status, new ArrayList<>());
            }
        });
    }

    private void openCancelOrderDialog(final int status, ArrayList<String> cancellationReason) {
        if (cancelOrderDialog != null && cancelOrderDialog.isShowing()) {
            return;
        }
        cancelOrderDialog = new BottomSheetDialog(this);
        cancelOrderDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        cancelOrderDialog.setContentView(R.layout.dialog_cancel_order);

        final CancellationReasonAdapter cancellationReasonAdapter;
        final RecyclerView rvCancellationReason;

        rvCancellationReason = cancelOrderDialog.findViewById(R.id.rvCancellationReason);

        if (cancellationReason.isEmpty()) {
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_one));
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_two));
            cancellationReason.add(getString(R.string.msg_order_cancel_reason_three));
        }
        cancellationReason.add(getString(R.string.text_other));

        cancellationReasonAdapter = new CancellationReasonAdapter(cancellationReason) {
            @Override
            public void onReasonSelected(int position) {
                currentPosition = position;
            }
        };
        rvCancellationReason.setAdapter(cancellationReasonAdapter);
        cancelOrderDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            if (currentPosition != -1) {
                if (currentPosition == cancellationReason.size() - 1) {
                    LinearLayoutManager linearLayoutManager = (LinearLayoutManager) rvCancellationReason.getLayoutManager();
                    View view1 = Objects.requireNonNull(linearLayoutManager).findViewByPosition(currentPosition);
                    cancelReason = ((EditText) Objects.requireNonNull(view1).findViewById(R.id.etOthersReason)).getText().toString();
                } else {
                    cancelReason = cancellationReason.get(currentPosition);
                }
            }

            if (cancelReason != null && !cancelReason.isEmpty()) {
                cancelOrderDialog.dismiss();
                rejectOrCancelOrder(status, OrderDetailActivity.this, orderDetail.getOrder().getId(), cancelReason);
            } else {
                Utilities.showToast(OrderDetailActivity.this, getResources().getString(R.string.msg_plz_give_valid_reason));
            }
        });

        cancelOrderDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> {
            cancelOrderDialog.dismiss();
            cancelReason = "";
        });

        WindowManager.LayoutParams params = cancelOrderDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        cancelOrderDialog.setCancelable(true);
        cancelOrderDialog.show();
    }

    @SuppressLint("NotifyDataSetChanged")
    private void setOrderDetails(OrderDetail orderDetail) {
        userPhone = orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getCountryPhoneCode() + orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getPhone();
        orderStatus = orderDetail.getOrder().getOrderStatus();
        orderDetailList.clear();
        orderDetailList.addAll(orderDetail.getCartDetail().getOrderDetails());
        orderItemSectionDetailAdapter.notifyDataSetChanged();
        if (orderDetailList.isEmpty()) {
            findViewById(R.id.cvItems).setVisibility(View.GONE);
        }
        tvTotalItemPrice.setText(preferenceHelper.getCurrency().concat(parseContent.decimalTwoDigitFormat.format(orderDetail.getOrderPaymentDetail().getTotal())));
        tvOrderNo.setText(String.valueOf(orderDetail.getOrderPaymentDetail().getOrderUniqueId()));
        if (orderDetail.getOrderPaymentDetail().isIsPaymentModeCash()) {
            tvPaymentMode.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_cash, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
            tvPaymentMode.setText(R.string.text_cash);
        } else {
            tvPaymentMode.setText(R.string.text_card);
            tvPaymentMode.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_card, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
        }

        if (!orderDetail.getCartDetail().getDestinationAddresses().isEmpty()) {
            String address = orderDetail.getCartDetail().getDestinationAddresses().get(0).getAddress();
            if (orderDetail.getCartDetail().getDestinationAddresses().get(0).getFlat_no() != null
                    && !orderDetail.getCartDetail().getDestinationAddresses().get(0).getFlat_no().isEmpty()) {
                address = address.concat("\n" + orderDetail.getCartDetail().getDestinationAddresses().get(0).getFlat_no());
            }
            if (orderDetail.getCartDetail().getDestinationAddresses().get(0).getStreet() != null
                    && !orderDetail.getCartDetail().getDestinationAddresses().get(0).getStreet().isEmpty()) {
                if (orderDetail.getCartDetail().getDestinationAddresses().get(0).getFlat_no() != null
                        && !orderDetail.getCartDetail().getDestinationAddresses().get(0).getFlat_no().isEmpty()) {
                    address = address.concat(", " + orderDetail.getCartDetail().getDestinationAddresses().get(0).getStreet());
                } else {
                    address = address.concat("\n" + orderDetail.getCartDetail().getDestinationAddresses().get(0).getStreet());
                }
            }
            if (orderDetail.getCartDetail().getDestinationAddresses().get(0).getLandmark() != null
                    && !orderDetail.getCartDetail().getDestinationAddresses().get(0).getLandmark().isEmpty()) {
                address = address.concat("\n" + orderDetail.getCartDetail().getDestinationAddresses().get(0).getLandmark());
            }
            tvDeliveryAddress.setText(address);
        }

        tvClientName.setText(orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName());
        if (orderDetail.getOrder().getUserDetail() != null) {
            GlideApp.with(this)
                    .load(IMAGE_URL + orderDetail.getOrder().getUserDetail().getImageUrl())
                    .placeholder(R.drawable.placeholder)
                    .dontAnimate()
                    .fallback(R.drawable.placeholder)
                    .into(ivClient);
        }
        if (orderDetail.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING && !TextUtils.isEmpty(orderDetail.getOrder().getDestinationAddresses().get(0).getNote())) {
            llNote.setVisibility(View.VISIBLE);
        } else {
            llNote.setVisibility(View.GONE);
        }
        if (((orderStatus == Constant.WAITING_FOR_ACCEPT || orderStatus == Constant.STORE_ORDER_ACCEPTED) && orderDetail.getOrder().getOrderType() == Constant.Type.STORE) || (orderStatus == Constant.WAITING_FOR_ACCEPT && orderDetail.getOrder().getOrderType() == Constant.Type.USER && preferenceHelper.getIsStoreCanEditOrder()) && orderDetail.getOrder().getDeliveryType() != Constant.DeliveryType.TABLE_BOOKING) {
            llEditOrder.setVisibility(View.VISIBLE);
        } else {
            llEditOrder.setVisibility(View.GONE);
        }
        if (orderDetail.getOrder().isIsScheduleOrder()) {
            llScheduleOrder.setVisibility(View.VISIBLE);
            tvOrderSchedule.setVisibility(View.VISIBLE);
            try {
                Date date = ParseContent.getInstance().webFormat.parse(orderDetail.getOrder().getScheduleOrderStartAt());
                SimpleDateFormat dateFormat = new SimpleDateFormat(Constant.DATE_FORMAT, Locale.US);
                SimpleDateFormat timeFormat = new SimpleDateFormat(Constant.TIME_FORMAT_AM, Locale.US);
                if (!TextUtils.isEmpty(orderDetail.getOrder().getTimeZone())) {
                    dateFormat.setTimeZone(TimeZone.getTimeZone(orderDetail.getOrder().getTimeZone()));
                    timeFormat.setTimeZone(TimeZone.getTimeZone(orderDetail.getOrder().getTimeZone()));
                }
                if (date != null) {
                    String stringDate = getResources().getString(R.string.text_order_schedule) + " " + dateFormat.format(date) + " " + timeFormat.format(date);

                    if (!TextUtils.isEmpty(orderDetail.getOrder().getScheduleOrderStartAt2())) {
                        Date date2 = ParseContent.getInstance().webFormat.parse(orderDetail.getOrder().getScheduleOrderStartAt2());
                        if (date2 != null) {
                            stringDate = stringDate + " - " + timeFormat.format(date2);
                        }
                    }
                    tvOrderSchedule.setText(stringDate);
                }
            } catch (ParseException e) {
                Utilities.handleException(OrderListAdapter.class.getName(), e);
            }
        } else {
            llScheduleOrder.setVisibility(View.GONE);
            tvOrderSchedule.setVisibility(View.GONE);
        }
        if (orderDetail.getOrderPaymentDetail().isUserPickUpOrder()) {
            tvPickupType.setText(R.string.text_pickup_delivery);
            tvPickupType.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_takeway_order, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
        } else if (orderDetail.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
            tvPickupType.setText(getString(R.string.text_table_no_booked_for_people, orderDetail.getCartDetail().getTableNo(), orderDetail.getCartDetail().getNoOfPersons()));
            tvPickupType.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_table_reservation, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
        } else {
            tvPickupType.setText(R.string.text_delivery);
            tvPickupType.setCompoundDrawablesRelativeWithIntrinsicBounds(ResourcesCompat.getDrawable(getResources(), R.drawable.ic_deliveryman_order, getTheme()), null, ResourcesCompat.getDrawable(getResources(), R.drawable.ic_correct, null), null);
        }
        setBtnTextBasedOnStatus(orderStatus);
    }

    private void setBtnTextBasedOnStatus(int status) {
        switch (status) {
            case Constant.DEFAULT_STATUS:
            case Constant.WAITING_FOR_ACCEPT:
                btnAction.setText(getString(R.string.text_accept));
                llBtn.setVisibility(View.VISIBLE);
                btnReject.setVisibility(View.VISIBLE);
                ivBtnCancel.setVisibility(View.GONE);
                updateUiPrinterButton(false);
                break;
            case Constant.STORE_ORDER_ACCEPTED:
                if (orderDetail != null && orderDetail.getOrder() != null && orderDetail.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
                    btnAction.setText(getString(R.string.btn_arrived));
                } else {
                    btnAction.setText(getString(R.string.text_preparing_order));
                }
                llBtn.setVisibility(View.VISIBLE);
                btnReject.setVisibility(View.GONE);
                ivBtnCancel.setVisibility(View.VISIBLE);
                updateUiPrinterButton(true);
                break;
            case Constant.STORE_ORDER_PREPARING:
                btnAction.setText(getString(R.string.text_order_ready));
                llBtn.setVisibility(View.VISIBLE);
                btnReject.setVisibility(View.GONE);
                ivBtnCancel.setVisibility(View.VISIBLE);
                updateUiPrinterButton(true);
                break;
            case Constant.TABLE_BOOKING_ARRIVED:
                btnAction.setText(getString(R.string.text_complete_order));
                llBtn.setVisibility(View.VISIBLE);
                btnReject.setVisibility(View.GONE);
                ivBtnCancel.setVisibility(View.GONE);
                updateUiPrinterButton(true);
                break;
            case Constant.STORE_ORDER_READY:
                llBtn.setVisibility(View.VISIBLE);
                btnReject.setVisibility(View.GONE);
                ivBtnCancel.setVisibility(View.VISIBLE);
                btnAction.setText(getString(R.string.text_assign));
                updateUiPrinterButton(true);
                if (orderDetail.getOrderPaymentDetail().isUserPickUpOrder()) {
                    btnAction.setText(getString(R.string.text_complete_order));
                } else if (!TextUtils.isEmpty(orderDetail.getOrder().getRequestId())) {
                    onBackPressed();
                } else if (preferenceHelper.getIsStoreCanCompleteOrder() && !preferenceHelper.getIsStoreCanAddProvider()) {
                    btnReject.setText(getString(R.string.text_complete_order));
                    btnAction.setVisibility(View.GONE);
                    btnReject.setVisibility(View.VISIBLE);
                } else if (preferenceHelper.getIsStoreCanCompleteOrder() && preferenceHelper.getIsStoreCanAddProvider()) {
                    btnReject.setText(getString(R.string.text_complete));
                    btnAction.setVisibility(View.VISIBLE);
                    btnReject.setVisibility(View.VISIBLE);
                } else {
                    btnAction.setVisibility(View.VISIBLE);
                    btnReject.setVisibility(View.GONE);
                }
                break;
            case Constant.USER_CANCELED_ORDER:
                openOrderCanceledByUserDialog();
                break;
            default:
                break;
        }
    }

    private void handleActionBtnClick(int status) {
        switch (status) {
            case Constant.DEFAULT_STATUS:
            case Constant.WAITING_FOR_ACCEPT:
                setOrderStatus(Constant.STORE_ORDER_ACCEPTED);
                break;
            case Constant.STORE_ORDER_ACCEPTED:
                if (orderDetail != null && orderDetail.getOrder() != null && orderDetail.getOrder().getDeliveryType() == Constant.DeliveryType.TABLE_BOOKING) {
                    setOrderStatus(Constant.TABLE_BOOKING_ARRIVED);
                } else if (orderDetail != null && !orderDetail.getOrderPaymentDetail().isUserPickUpOrder() && preferenceHelper.getIsAskForEstimatedTimeForOrderReady() && TextUtils.isEmpty(orderDetail.getOrder().getRequestId())) {
                    openOrderDeliveryEstimatedDialog();
                } else {
                    setOrderStatus(Constant.STORE_ORDER_PREPARING);
                }
                break;
            case Constant.TABLE_BOOKING_ARRIVED:
                completeOrder();
                break;
            case Constant.STORE_ORDER_PREPARING:
                setOrderStatus(Constant.STORE_ORDER_READY);
                break;
            case Constant.STORE_ORDER_READY:
                if (orderDetail.getOrderPaymentDetail().isUserPickUpOrder()) {
                    openCompleteDeliveryDialog();
                } else {
                    openVehicleSelectDialog(0);

                }
                break;
            default:
                break;
        }
    }

    /**
     * this method call webservice for set order status (accepted,rejected,prepare etc.)
     *
     * @param orderStatus orderStatus
     */
    private void setOrderStatus(final int orderStatus) {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = getCommonParam(orderDetail.getOrder().getId());
        map.put(Constant.ORDER_STATUS, orderStatus);
        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).setOrderStatus(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        OrderDetailActivity.this.orderStatus = response.body().getOrder().getOrderStatus();
                        if (orderDetail != null && orderDetail.getOrderPaymentDetail() != null) {
                            orderDetail.getOrder().setOrderStatus(OrderDetailActivity.this.orderStatus);
                            setOrderDetails(orderDetail);
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(OrderDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        if (662 == response.body().getErrorCode()) {
                            onBackPressed();
                        }
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), OrderDetailActivity.this);
                }
                Utilities.removeProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.printLog(TAG, t.getMessage());
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for create a order pickUp request to delivery man
     */
    private void assignDeliveryMan(int estimatedTime, String vehicleId, String providerId) {
        Utilities.showProgressDialog(this);
        HashMap<String, Object> map = getCommonParam(orderDetail.getOrder().getId());
        map.put(Constant.ESTIMATED_TIME_FOR_READY_ORDER, estimatedTime);
        map.put(Constant.VEHICLE_ID, vehicleId);
        if (!TextUtils.isEmpty(providerId)) {
            map.put(Constant.PROVIDER_ID, providerId);
        }
        Call<OrderStatusResponse> call = ApiClient.getClient().create(ApiInterface.class).assignProvider(map);
        call.enqueue(new Callback<OrderStatusResponse>() {
            @Override
            public void onResponse(@NonNull Call<OrderStatusResponse> call, @NonNull Response<OrderStatusResponse> response) {
                Utilities.removeProgressDialog();
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        onBackPressed();
                    } else {
                        ParseContent.getInstance().showErrorMessage(OrderDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                    onBackPressed();
                } else {
                    Utilities.showHttpErrorToast(response.code(), OrderDetailActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<OrderStatusResponse> call, @NonNull Throwable t) {
                Utilities.printLog(TAG, t.getMessage());
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for complete a active or running  order
     */
    private void completeOrder() {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.ORDER_ID, orderDetail.getOrder().getId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.completeOrder(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        parseContent.showMessage(OrderDetailActivity.this, response.body().getStatusPhrase());
                        onBackPressed();
                    } else {
                        parseContent.showErrorMessage(OrderDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void openCompleteDeliveryDialog() {
        if (orderDetail.isConfirmationCodeRequiredAtCompleteDelivery()) {
            if (customEditTextDialog != null && customEditTextDialog.isShowing()) {
                return;
            }

            customEditTextDialog = new CustomEditTextDialog(this, false, getResources().getString(R.string.text_complete_delivery), getResources().getString(R.string.msg_enter_delivery_code), getResources().getString(R.string.text_submit), 4) {
                @Override
                public void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmailOtp) {
                    if (btnId == R.id.btnPositive) {
                        if (TextUtils.equals(etEmailOtp.getText().toString(), String.valueOf(orderDetail.getOrder().getConfirmationCodeForCompleteDelivery()))) {
                            completeOrder();
                            dismiss();
                        } else {
                            etEmailOtp.setError(getResources().getString(R.string.msg_invalid_information_code));
                            etEmailOtp.requestFocus();
                        }
                    } else if (btnId == R.id.btnNegative) {
                        dismiss();
                    }
                }

                @Override
                public void resetOtpId(String otpId) {

                }
            };
            customEditTextDialog.show();
            customEditTextDialog.textInputLayoutEmailOtp.setHint(getResources().getString(R.string.text_confirmation_code));
        } else {
            completeOrder();
        }
    }

    private void openOrderCanceledByUserDialog() {
        CustomAlterDialog customAlterDialog = new CustomAlterDialog(this, getResources().getString(R.string.text_order_canceled_user), getResources().getString(R.string.msg_order_canceled_by_user), false, getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    OrderDetailActivity.this.onBackPressed();
                }
                dismiss();
            }
        };
        customAlterDialog.setCancelable(false);
        customAlterDialog.show();
    }

    private void openOrderDeliveryEstimatedDialog() {
        CustomEditTextDialog editTextDialog = new CustomEditTextDialog(this, false, getResources().getString(R.string.text_order_estimated_time), getResources().getString(R.string.msg_order_prepare_estimated_time), getResources().getString(R.string.text_submit), -1) {

            @Override
            public void btnOnClick(int btnId, TextInputEditText etSMSOtp, TextInputEditText etEmail) {
                if (btnId == R.id.btnPositive) {
                    if (TextUtils.isEmpty(etEmail.getText().toString())) {
                        Utilities.showToast(OrderDetailActivity.this, getResources().getString(R.string.msg_plz_enter_data));
                    } else {
                        try {
                            openVehicleSelectDialog(Integer.parseInt(etEmailOtp.getText().toString()));
                            dismiss();
                        } catch (NumberFormatException e) {
                            etEmailOtp.setError(getResources().getString(R.string.msg_plz_enter_valid_time));
                        }
                    }
                } else {
                    dismiss();
                }
            }

            @Override
            public void resetOtpId(String otpId) {

            }
        };
        editTextDialog.setCancelable(false);
        editTextDialog.show();
        editTextDialog.textInputLayoutEmailOtp.setHint(getResources().getString(R.string.text_hint_estimated_time));
        editTextDialog.etEmailOtp.setInputType(InputType.TYPE_CLASS_NUMBER);
        InputFilter[] FilterArray = new InputFilter[1];
        FilterArray[0] = new InputFilter.LengthFilter(3);
        editTextDialog.etEmailOtp.setFilters(FilterArray);
    }

    private void goToOrderUpdateActivity(Order order) {
        UpdateOrder.getInstance().setOrderId(order.getId());
        Intent intent = new Intent(this, UpdateOrderActivity.class);
        startActivity(intent);
        overridePendingTransition(R.anim.enter, R.anim.exit);
        finish();
    }

    @Override
    public void onOrderReceive() {
        getOrderDetail();
    }

    private void openVehicleSelectDialog(final int estimatedTime) {
        List<VehicleDetail> vehicleDetails = orderDetail.getOrderPaymentDetail().getDeliveryPriceUsedType() == Constant.VEHICLE_TYPE ? CurrentBooking.getInstance().getVehicleDetails() : CurrentBooking.getInstance().getAdminVehicleDetails();
        if (vehicleDetails.isEmpty()) {
            Utilities.showToast(this, getResources().getString(R.string.text_vehicle_not_found));
        } else {
            final VehicleDialog vehicleDialog = new VehicleDialog(this, vehicleDetails);
            vehicleDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> vehicleDialog.dismiss());
            vehicleDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
                if (TextUtils.isEmpty(vehicleDialog.getVehicleId())) {
                    Utilities.showToast(OrderDetailActivity.this, getResources().getString(R.string.msg_select_vehicle));
                } else {
                    if (vehicleDialog.isManualAssign()) {
                        vehicleDialog.dismiss();
                        openNearestProviderDialog(estimatedTime, orderDetail.getOrder().getId(), vehicleDialog.getVehicleId());
                    } else {

                        vehicleDialog.dismiss();
                        assignDeliveryMan(estimatedTime, vehicleDialog.getVehicleId(), null);
                    }
                }
            });
            vehicleDialog.show();
        }
    }

    private void openNearestProviderDialog(final int estimatedTime, String orderId, final String vehicleId) {
        final NearestProviderDialog providerDialog = new NearestProviderDialog(this, orderId, vehicleId);
        providerDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> providerDialog.dismiss());
        providerDialog.findViewById(R.id.btnPositive).setOnClickListener(view -> {
            providerDialog.dismiss();
            if (providerDialog.getSelectedProvider() == null) {
                Utilities.showToast(OrderDetailActivity.this, getResources().getString(R.string.msg_select_provider));
            } else {
                assignDeliveryMan(estimatedTime, vehicleId, providerDialog.getSelectedProvider().getId());
            }
        });
        providerDialog.show();
    }

    private void gotToChatActivity(int chat_type, String title, String receiver_id) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(Constant.ORDER_ID, orderDetail.getOrder().getId());
        intent.putExtra(Constant.TYPE, String.valueOf(chat_type));
        intent.putExtra(Constant.TITLE, title);
        intent.putExtra(Constant.RECEIVER_ID, receiver_id);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void getOrderDetail() {
        if (getIntent() != null && getIntent().getParcelableExtra(Constant.ORDER_DETAIL) != null) {
            Order order = getIntent().getParcelableExtra(Constant.ORDER_DETAIL);
            Utilities.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            map.put(Constant.ORDER_ID, order.getId());

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<OrderDetailResponse> responseCall = apiInterface.getOrderDetail(map);
            responseCall.enqueue(new Callback<OrderDetailResponse>() {
                @Override
                public void onResponse(@NonNull Call<OrderDetailResponse> call, @NonNull Response<OrderDetailResponse> response) {
                    Utilities.hideCustomProgressDialog();
                    if (parseContent.isSuccessful(response)) {
                        if (response.body() != null) {
                            if (response.body().isSuccess()) {
                                orderDetail = response.body().getOrderDetail();
                                if (orderDetail != null && orderDetail.getOrderPaymentDetail() != null) {
                                    setUpClickListeners();
                                    setOrderDetails(orderDetail);
                                } else {
                                    updateUiPrinterButton(false);
                                }
                            } else {
                                parseContent.showErrorMessage(OrderDetailActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                            }
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<OrderDetailResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });
        }
    }

    private void openInvoiceDialog(OrderPaymentDetail orderPaymentDetail) {
        BottomSheetDialog invoiceDialog = new BottomSheetDialog(this);
        invoiceDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        invoiceDialog.setContentView(R.layout.dialog_invoice);
        String currency = preferenceHelper.getCurrency();
        String unit = orderPaymentDetail.isIsDistanceUnitMile() ? this.getResources().
                getString(R.string.unit_mile) : this.getResources().getString(R.string.unit_km);

        ArrayList<ArrayList<Invoice>> arrayListsInvoices = new ArrayList<>();
        ArrayList<Invoice> invoices = new ArrayList<>();
        String tag1 = getResources().getString(R.string.text_payment_detail);
        if (orderPaymentDetail.getTotalBasePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_base_price), orderPaymentDetail.getTotalBasePrice(), currency, orderPaymentDetail.getBasePrice(), currency, orderPaymentDetail.getBasePriceDistance(), unit, tag1));
        }
        if (orderPaymentDetail.getDistancePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_distance_price), orderPaymentDetail.getDistancePrice(), currency, orderPaymentDetail.getPricePerUnitDistance(), currency, 0.0, unit, tag1));
        }
        if (orderPaymentDetail.getTotalTimePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_time_cost), orderPaymentDetail.getTotalTimePrice(), currency, orderPaymentDetail.getPricePerUnitTime(), currency, 0.0, this.getResources().getString(R.string.unit_mins), tag1));
        }

        if (orderPaymentDetail.getTotalServicePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_service_price), orderPaymentDetail.getTotalServicePrice(), currency, 0.0, "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTotalAdminTaxPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_service_tax), orderPaymentDetail.getTotalAdminTaxPrice(), currency, 0.0, orderPaymentDetail.getServiceTax() + "%", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTotalSurgePrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_surge_price), orderPaymentDetail.getTotalSurgePrice(), currency, orderPaymentDetail.getSurgeCharges(), "x", 0.0, "", tag1));
        }


        if (orderPaymentDetail.getTotalDeliveryPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_total_service_cost), orderPaymentDetail.getTotalDeliveryPrice(), currency, 0.0, "", 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalCartPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_item_price_2), orderPaymentDetail.getTotalCartPrice(), currency, 0.0, orderPaymentDetail.getTotalItem() + "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getBookingFees() > 0) {
            invoices.add(loadInvoiceData(getString(R.string.text_booking_fees), orderPaymentDetail.getBookingFees(), currency, 0.0, "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(getString(R.string.text_promo), orderPaymentDetail.getPromoPayment(), currency, 0.0, "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTotalStoreTaxPrice() > 0) {
            ArrayList<String> taxesSubtext = new ArrayList<>();
            for (TaxesDetail detail : orderPaymentDetail.getTaxes()) {
                taxesSubtext.add(Utilities.getDetailStringFromList(detail.getTaxName(), Language.getInstance().getStoreLanguageIndex()) + " " + detail.getTax() + "%");
            }
            String text = "";
            if (!taxesSubtext.isEmpty()) {
                text = "(" + TextUtils.join(",", taxesSubtext) + ") " + (orderPaymentDetail.isTaxIncluded() ? "Inc" : "Exc");
            }
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_tex), orderPaymentDetail.getTotalStoreTaxPrice(), currency, 0.0, text, 0.0, "", tag1));
        }

        if (orderPaymentDetail.getTotalOrderPrice() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_total_item_cost), orderPaymentDetail.getTotalOrderPrice(), currency, 0.0, "", 0.0, "", tag1));
        }

        if (orderPaymentDetail.isPromoForDeliveryService() && orderPaymentDetail.getPromoPayment() > 0) {
            invoices.add(loadInvoiceData(getResources().getString(R.string.text_promo), orderPaymentDetail.getPromoPayment(), currency, 0.0, "", 0.0, "", tag1));
        }
        if (orderPaymentDetail.getTipAmount() > 0) {
            invoices.add(loadInvoiceData(this.getResources().getString(R.string.text_tip_amount), orderPaymentDetail.getTipAmount(), currency, 0.0, "", 0.0, "", tag1));
        }

        arrayListsInvoices.add(invoices);

        ArrayList<Invoice> otherEarning = new ArrayList<>();
        String tag = getResources().getString(R.string.text_other_earning);
        otherEarning.add(loadInvoiceData(getResources().getString(R.string.text_profit), orderPaymentDetail.getTotalStoreIncome(), currency, 0.0, "", 0.0, "", tag));
        arrayListsInvoices.add(otherEarning);
        RecyclerView rcvInvoice = invoiceDialog.findViewById(R.id.rcvInvoice);
        rcvInvoice.setLayoutManager(new LinearLayoutManager(this));
        InvoiceAdapter invoiceAdapter = new InvoiceAdapter(arrayListsInvoices);
        invoiceAdapter.setShowFirstSection(true);
        rcvInvoice.setAdapter(invoiceAdapter);

        /// load invoice payment
        LinearLayout invoicePayment = invoiceDialog.findViewById(R.id.invoicePayment);

        ArrayList<InvoicePayment> invoicePayments = new ArrayList<>();
        invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_wallet), appendString(currency, orderPaymentDetail.getWalletPayment()), R.drawable.ic_wallet));
        if (orderPaymentDetail.isIsPaymentModeCash()) {
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_cash), appendString(currency, orderPaymentDetail.getCashPayment()), R.drawable.ic_cash));
        } else {
            invoicePayments.add(loadInvoiceImage(this.getResources().getString(R.string.text_card), appendString(currency, orderPaymentDetail.getCardPayment()), R.drawable.ic_card));
        }

        if (orderPaymentDetail.getPromoPayment() > 0) {
            invoicePayment.addView(LayoutInflater.from(invoiceDialog.getContext()).inflate(R.layout.include_invoice_data, null));
            invoicePayments.add(loadInvoiceImage(getResources().getString(R.string.text_promo), appendString(currency, orderPaymentDetail.getPromoPayment()), R.drawable.ic_promo));
        }
        int size = invoicePayments.size();
        for (int i = 0; i < size; i++) {
            CardView cardView = (CardView) invoicePayment.getChildAt(i);
            LinearLayout currentLayout = (LinearLayout) cardView.getChildAt(0);
            ImageView imageView = (ImageView) currentLayout.getChildAt(0);
            imageView.setImageDrawable(AppCompatResources.getDrawable(this, invoicePayments.get(i).getImageId()));
            ((CustomTextView) currentLayout.getChildAt(1)).setText(invoicePayments.get(i).getTitle());
            ((CustomTextView) currentLayout.getChildAt(2)).setText(invoicePayments.get(i).getValue());
        }
        CustomFontTextViewTitle tvInvoiceTotal = invoiceDialog.findViewById(R.id.tvInvoiceTotal);
        tvInvoiceTotal.setText(String.format("%s%s", currency, parseContent.decimalTwoDigitFormat.format(orderPaymentDetail.getTotal())));

        invoiceDialog.findViewById(R.id.btnNegative).setOnClickListener(view -> invoiceDialog.dismiss());
        WindowManager.LayoutParams params = invoiceDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        invoiceDialog.show();
    }

    private Invoice loadInvoiceData(String title, double mainPrice, String currency, double subPrice, String subText, double unitValue, String unit, String tagTitle) {
        Invoice invoice = new Invoice();
        invoice.setPrice(appendString(currency, mainPrice));
        invoice.setSubTitle(appendString(subText, subPrice, unitValue, unit));
        invoice.setTitle(title);
        invoice.setTagTitle(tagTitle);
        return invoice;
    }

    private InvoicePayment loadInvoiceImage(String title, String subTitle, int id) {
        InvoicePayment invoicePayment = new InvoicePayment();
        invoicePayment.setTitle(title);
        invoicePayment.setValue(subTitle);
        invoicePayment.setImageId(id);
        return invoicePayment;
    }

    private String appendString(String currency, Double price, Double value, String unit) {
        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(currency);
        if (price > 0) {
            stringBuilder.append(parseContent.decimalTwoDigitFormat.format(price));
        }
        if (!TextUtils.isEmpty(unit)) {
            stringBuilder.append("/");
            if (value > 1.0) {
                stringBuilder.append(parseContent.decimalTwoDigitFormat.format(value));
            }
            stringBuilder.append(unit);
        }
        return stringBuilder.toString();
    }

    private String appendString(String string, Double value) {
        return string + parseContent.decimalTwoDigitFormat.format(value);
    }

    public void updateUiPrinterButton(boolean visible) {
        setToolbarEditIcon(visible, R.drawable.ic_printer);
        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) flCart.getLayoutParams();
        if (visible) {
            layoutParams.setMarginEnd(0);
        } else {
            layoutParams.setMarginEnd(getResources().getDimensionPixelSize(R.dimen.activity_horizontal_margin));
        }
        flCart.setLayoutParams(layoutParams);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (BluetoothDeviceManager.REQUEST_CONNECT_BT == requestCode && resultCode == Activity.RESULT_OK) {
            printInvoice(false);
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivEditMenu) {
            if (BluetoothDeviceManager.isDeviceSocketConnected()) {
                printInvoice(false);
            } else {
                Intent intent = new Intent(OrderDetailActivity.this, BTScanActivity.class);
                startActivityForResult(intent, BluetoothDeviceManager.REQUEST_CONNECT_BT);
            }
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    private void printInvoice(boolean isTestMode) {
        if (BluetoothDeviceManager.isDeviceSocketConnected() || isTestMode) {
            Utilities.showToast(OrderDetailActivity.this, getString(R.string.text_printing));
            PrintManager printManager = new PrintManager(this, BluetoothDeviceManager.getBtSocket(), isTestMode, new PrintManager.PrintStatusListener() {
                @Override
                public void completePrinting() {

                }

                @Override
                public void errorPrinting(String message) {

                    Utilities.showToast(OrderDetailActivity.this, message);
                }
            });
            printManager.print(orderDetail);
        }
    }

    private void initPrinter() {
        bluetoothDeviceManager = new BluetoothDeviceManager(this, null, true);
        bluetoothDeviceManager.startDiscoveryOfDevices();
    }
}