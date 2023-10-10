package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.WalletTransactionActivity;
import com.dropo.store.WalletTransactionDetailActivity;
import com.dropo.store.adapter.WalletTransactionAdapter;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.datamodel.WalletRequestDetail;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.WalletTransactionResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WalletTransactionFragment extends Fragment {
    public static final String TAG = WalletTransactionFragment.class.getName();

    private RecyclerView rcvWalletData;
    private WalletTransactionActivity activity;
    private CustomAlterDialog customDialogAlert;

    private ArrayList<WalletRequestDetail> walletRequestDetails;
    private WalletTransactionAdapter transactionAdapter;
    private LinearLayout ivEmpty;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (WalletTransactionActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_wallet_transection, container, false);
        rcvWalletData = view.findViewById(R.id.rcvWalletData);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initRcvWalletTransaction();
        getWalletTransaction();
    }

    private void initRcvWalletTransaction() {
        walletRequestDetails = new ArrayList<>();
        rcvWalletData.setLayoutManager(new LinearLayoutManager(activity));
        transactionAdapter = new WalletTransactionAdapter(this, walletRequestDetails);
        rcvWalletData.setAdapter(transactionAdapter);
    }

    private void getWalletTransaction() {
        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, activity.preferenceHelper.getServerToken());
        map.put(Constant.ID, activity.preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.TYPE_STORE);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<WalletTransactionResponse> call = apiInterface.getWalletTransaction(map);
        call.enqueue(new Callback<WalletTransactionResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<WalletTransactionResponse> call, @NonNull Response<WalletTransactionResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        walletRequestDetails.clear();
                        walletRequestDetails.addAll(response.body().getWalletRequestDetail());
                        Collections.sort(walletRequestDetails, (lhs, rhs) -> compareTwoDate(lhs.getCreatedAt(), rhs.getCreatedAt()));
                        transactionAdapter.notifyDataSetChanged();
                    }

                    if (walletRequestDetails.isEmpty()) {
                        ivEmpty.setVisibility(View.VISIBLE);
                        rcvWalletData.setVisibility(View.GONE);
                    } else {
                        ivEmpty.setVisibility(View.GONE);
                        rcvWalletData.setVisibility(View.VISIBLE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<WalletTransactionResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void canceledWithdrawalRequest(String walletId) {
        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.WALLET_STATUS, Constant.Wallet.WALLET_STATUS_CANCELLED);
        map.put(Constant.ID, walletId);
        map.put(Constant.TYPE, Constant.TYPE_STORE);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> call = apiInterface.cancelWithdrawalRequest(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        getWalletTransaction();
                    } else {
                        ParseContent.getInstance().showErrorMessage(activity, response.body().getErrorCode(), response.body().getStatusPhrase());
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

    public void goToWalletTransactionActivity(WalletRequestDetail walletRequestDetail) {
        Intent intent = new Intent(activity, WalletTransactionDetailActivity.class);
        intent.putExtra(Constant.BUNDLE, walletRequestDetail);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void openCancelWithdrawalRequestDialog(final String walletId) {
        if (customDialogAlert != null && customDialogAlert.isShowing()) {
            return;
        }

        customDialogAlert = new CustomAlterDialog(activity, getResources().getString(R.string.text_cancel_wallet_request), getResources().getString(R.string.text_are_you_sure), true, getResources().getString(R.string.text_ok)) {
            @Override
            public void btnOnClick(int btnId) {
                if (btnId == R.id.btnPositive) {
                    dismiss();
                    canceledWithdrawalRequest(walletId);
                } else {
                    dismiss();
                }
            }
        };

        customDialogAlert.setCancelable(false);
        customDialogAlert.show();
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat webFormat = activity.parseContent.webFormat;
            SimpleDateFormat dateFormat = activity.parseContent.dateTimeFormat;
            String date2 = dateFormat.format(webFormat.parse(secondStrDate));
            String date1 = dateFormat.format(webFormat.parse(firstStrDate));
            return date2.compareTo(date1);
        } catch (ParseException e) {
            Utilities.handleException(WalletTransactionFragment.class.getName(), e);
        }
        return 0;
    }
}