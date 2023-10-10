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
import com.dropo.store.WalletDetailActivity;
import com.dropo.store.WalletTransactionActivity;
import com.dropo.store.adapter.WalletHistoryAdapter;
import com.dropo.store.models.datamodel.WalletHistory;
import com.dropo.store.models.responsemodel.WalletHistoryResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.utils.Utilities;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WalletHistoryFragment extends Fragment {

    public static final String TAG = WalletHistoryFragment.class.getName();
    private RecyclerView rcvWalletData;
    private ArrayList<WalletHistory> walletHistory;
    private WalletTransactionActivity activity;
    private WalletHistoryAdapter walletHistoryAdapter;
    private LinearLayout ivEmpty;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (WalletTransactionActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_wallet_history, container, false);
        rcvWalletData = view.findViewById(R.id.rcvWalletData);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initRcvWalletHistory();
        getWalletHistory();
    }

    private void getWalletHistory() {

        Utilities.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, activity.preferenceHelper.getServerToken());
        map.put(Constant.ID, activity.preferenceHelper.getStoreId());
        map.put(Constant.TYPE, Constant.TYPE_STORE);

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<WalletHistoryResponse> call = apiInterface.getWalletHistory(map);
        call.enqueue(new Callback<WalletHistoryResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<WalletHistoryResponse> call, @NonNull Response<WalletHistoryResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        walletHistory.clear();
                        walletHistory.addAll(response.body().getWalletHistory());
                        Collections.sort(walletHistory, (lhs, rhs) -> compareTwoDate(lhs.getCreatedAt(), rhs.getCreatedAt()));
                        walletHistoryAdapter.notifyDataSetChanged();
                    }

                    if (walletHistory.isEmpty()) {
                        ivEmpty.setVisibility(View.VISIBLE);
                        rcvWalletData.setVisibility(View.GONE);
                    } else {
                        ivEmpty.setVisibility(View.GONE);
                        rcvWalletData.setVisibility(View.VISIBLE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<WalletHistoryResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvWalletHistory() {
        walletHistory = new ArrayList<>();
        rcvWalletData.setLayoutManager(new LinearLayoutManager(activity));
        walletHistoryAdapter = new WalletHistoryAdapter(this, walletHistory);
        rcvWalletData.setAdapter(walletHistoryAdapter);
        rcvWalletData.addOnItemTouchListener(new RecyclerTouchListener(activity, rcvWalletData, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                goToWalletDetailActivity(walletHistory.get(position));
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }

    private void goToWalletDetailActivity(WalletHistory walletHistory) {
        Intent intent = new Intent(activity, WalletDetailActivity.class);
        intent.putExtra(Constant.BUNDLE, walletHistory);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat webFormat = activity.parseContent.webFormat;
            SimpleDateFormat dateFormat = activity.parseContent.dateTimeFormat;
            String date2 = dateFormat.format(webFormat.parse(secondStrDate));
            String date1 = dateFormat.format(webFormat.parse(firstStrDate));
            return date2.compareTo(date1);
        } catch (ParseException e) {
            Utilities.handleException(WalletHistoryFragment.class.getName(), e);
        }
        return 0;
    }
}