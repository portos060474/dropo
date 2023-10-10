package com.dropo;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.WalletHistoryAdapter;
import com.dropo.interfaces.ClickListener;
import com.dropo.interfaces.RecyclerTouchListener;
import com.dropo.models.datamodels.WalletHistory;
import com.dropo.models.responsemodels.WalletHistoryResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class WalletHistoryActivity extends BaseAppCompatActivity {
    public final String TAG = this.getClass().getSimpleName();

    private RecyclerView rcvWalletData;
    private ArrayList<WalletHistory> walletHistory;
    private WalletHistoryAdapter walletHistoryAdapter;
    private LinearLayout ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_wallet_history);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_wallet_history));
        initViewById();
        setViewListener();
        initRcvWalletHistory();
        getWalletHistory();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvWalletData = findViewById(R.id.rcvWalletData);
        ivEmpty = findViewById(R.id.ivEmpty);
    }

    @Override
    protected void setViewListener() {

    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
    }

    private void getWalletHistory() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.ID, preferenceHelper.getUserId());
        map.put(Const.Params.TYPE, Const.Type.USER);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<WalletHistoryResponse> call = apiInterface.getWalletHistory(map);
        call.enqueue(new Callback<WalletHistoryResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<WalletHistoryResponse> call, @NonNull Response<WalletHistoryResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        walletHistory.clear();
                        walletHistory.addAll(response.body().getWalletHistory());
                        Collections.sort(walletHistory, (lhs, rhs) -> compareTwoDate(lhs.getCreatedAt(), rhs.getCreatedAt()));
                        walletHistoryAdapter.notifyDataSetChanged();
                    }
                    if (walletHistory.isEmpty()) {
                        rcvWalletData.setVisibility(View.GONE);
                        ivEmpty.setVisibility(View.VISIBLE);
                    } else {
                        rcvWalletData.setVisibility(View.VISIBLE);
                        ivEmpty.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<WalletHistoryResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(TAG, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void initRcvWalletHistory() {
        walletHistory = new ArrayList<>();
        rcvWalletData.setLayoutManager(new LinearLayoutManager(this));
        walletHistoryAdapter = new WalletHistoryAdapter(this, walletHistory);
        rcvWalletData.setAdapter(walletHistoryAdapter);
        rcvWalletData.addOnItemTouchListener(new RecyclerTouchListener(this, rcvWalletData, new ClickListener() {
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
        Intent intent = new Intent(this, WalletDetailActivity.class);
        intent.putExtra(Const.BUNDLE, walletHistory);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private int compareTwoDate(String firstStrDate, String secondStrDate) {
        try {
            SimpleDateFormat webFormat = parseContent.webFormat;
            SimpleDateFormat dateFormat = parseContent.dateTimeFormat;
            String date2 = dateFormat.format(webFormat.parse(secondStrDate));
            String date1 = dateFormat.format(webFormat.parse(firstStrDate));
            return date2.compareTo(date1);
        } catch (ParseException e) {
            AppLog.handleException(WalletHistoryResponse.class.getName(), e);
        }
        return 0;
    }
}