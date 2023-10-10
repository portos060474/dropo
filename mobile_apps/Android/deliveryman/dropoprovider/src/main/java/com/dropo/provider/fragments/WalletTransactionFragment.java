package com.dropo.provider.fragments;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.WalletTransactionActivity;
import com.dropo.provider.WalletTransactionDetailActivity;
import com.dropo.provider.adapter.WalletTransactionAdapter;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.models.datamodels.WalletRequestDetail;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.WalletTransactionResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.Utils;

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
    private CustomDialogAlert customDialogAlert;

    private ArrayList<WalletRequestDetail> walletRequestDetails;
    private WalletTransactionAdapter transactionAdapter;

    private View ivEmpty;

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
        Utils.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, activity.preferenceHelper.getSessionToken());
        map.put(Const.Params.ID, activity.preferenceHelper.getProviderId());
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<WalletTransactionResponse> call = apiInterface.getWalletTransaction(map);
        call.enqueue(new Callback<WalletTransactionResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<WalletTransactionResponse> call, @NonNull Response<WalletTransactionResponse> response) {
                Utils.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        walletRequestDetails.clear();
                        walletRequestDetails.addAll(response.body().getWalletRequestDetail());
                        Collections.sort(walletRequestDetails, (lhs, rhs) -> compareTwoDate(lhs.getCreatedAt(), rhs.getCreatedAt()));
                        transactionAdapter.notifyDataSetChanged();
                    }
                }

                ivEmpty.setVisibility(walletRequestDetails.isEmpty() ? View.VISIBLE : View.GONE);
            }

            @Override
            public void onFailure(@NonNull Call<WalletTransactionResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
                ivEmpty.setVisibility(walletRequestDetails.isEmpty() ? View.VISIBLE : View.GONE);
            }
        });
    }

    private void canceledWithdrawalRequest(String walletId) {
        Utils.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.WALLET_STATUS, Const.Wallet.WALLET_STATUS_CANCELLED);
        map.put(Const.Params.ID, walletId);
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> call = apiInterface.cancelWithdrawalRequest(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        getWalletTransaction();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), activity);
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

    public void goToWalletTransactionActivity(WalletRequestDetail walletRequestDetail) {
        Intent intent = new Intent(activity, WalletTransactionDetailActivity.class);
        intent.putExtra(Const.BUNDLE, walletRequestDetail);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    public void openCancelWithdrawalRequestDialog(final String walletId) {
        if (customDialogAlert != null && customDialogAlert.isShowing()) {
            return;
        }

        customDialogAlert = new CustomDialogAlert(activity, activity.getResources().getString(R.string.text_transaction_request), activity.getResources().getString(R.string.msg_are_you_sure), activity.getResources().getString(R.string.text_ok)) {
            @Override
            public void onClickLeftButton() {
                dismiss();

            }

            @Override
            public void onClickRightButton() {
                canceledWithdrawalRequest(walletId);
                dismiss();
            }
        };
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
            AppLog.handleException(WalletTransactionFragment.class.getName(), e);
        }
        return 0;
    }
}