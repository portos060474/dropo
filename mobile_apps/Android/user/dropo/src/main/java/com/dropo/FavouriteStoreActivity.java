package com.dropo;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.FavouriteStoreAdapter;
import com.dropo.models.datamodels.RemoveFavourite;
import com.dropo.models.datamodels.Store;
import com.dropo.models.datamodels.StoreClosedResult;
import com.dropo.models.responsemodels.FavouriteStoreResponse;
import com.dropo.models.responsemodels.SetFavouriteResponse;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FavouriteStoreActivity extends BaseAppCompatActivity {

    private RecyclerView rcvFavoriteStore;
    private FavouriteStoreAdapter favouriteStoreAdapter;
    private List<Store> storeList;
    private LinearLayout ivEmpty;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favourite_store);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_favourite));
        setToolbarRightIcon3(R.drawable.ic_save, view -> {
            if (favouriteStoreAdapter != null) {
                List<String> stores = favouriteStoreAdapter.getStoreRemovedStores();
                if (stores.isEmpty()) {
                    Utils.showToast(getResources().getString(R.string.msg_plz_check_one_ro_more), FavouriteStoreActivity.this);
                } else {
                    removeAsFavoriteStore(stores);
                }
            }
        });
        storeList = new ArrayList<>();
        initViewById();
        setViewListener();
        initRcvFavourite();
    }

    @Override
    protected void onResume() {
        super.onResume();
        getFavoriteStores();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvFavoriteStore = findViewById(R.id.rcvFavoriteStore);
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

    private void initRcvFavourite() {
        rcvFavoriteStore.setLayoutManager(new GridLayoutManager(this, 2, RecyclerView.VERTICAL, false));
        favouriteStoreAdapter = new FavouriteStoreAdapter(this, storeList);
    }

    private void getFavoriteStores() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<FavouriteStoreResponse> call = apiInterface.getFavouriteStores(map);
        call.enqueue(new Callback<FavouriteStoreResponse>() {
            @Override
            public void onResponse(@NonNull Call<FavouriteStoreResponse> call, @NonNull Response<FavouriteStoreResponse> response) {
                Utils.hideCustomProgressDialog();
                storeList.clear();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        storeList.addAll(response.body().getStoreDetail());
                        for (Store store : storeList) {
                            StoreClosedResult storeClosedResult = Utils.checkStoreOpenAndClosed(FavouriteStoreActivity.this, store.getStoreTime(), response.body().getServerTime(), store.getCityDetail().getTimezone(), false, null);
                            store.setStoreClosed(storeClosedResult.isStoreClosed());
                            store.setReOpenTime(storeClosedResult.getReOpenAt());
                            store.setDistance(0);
                            store.setCurrency(store.getCountries().getCurrencySign());
                            store.setTags(Utils.getStoreTag(store.getFamousProductsTags()));
                            store.setPriceRattingTag(Utils.getStringPrice(store.getPriceRating(), store.getCurrency()));
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), FavouriteStoreActivity.this);
                    }

                    if (storeList.isEmpty()) {
                        ivEmpty.setVisibility(View.VISIBLE);
                        rcvFavoriteStore.setVisibility(View.GONE);
                        ivToolbarRightIcon3.setVisibility(View.GONE);
                    } else {
                        ivEmpty.setVisibility(View.GONE);
                        ivToolbarRightIcon3.setVisibility(View.VISIBLE);
                        rcvFavoriteStore.setVisibility(View.VISIBLE);
                    }

                    rcvFavoriteStore.setAdapter(favouriteStoreAdapter);
                }
            }

            @Override
            public void onFailure(@NonNull Call<FavouriteStoreResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void removeAsFavoriteStore(final List<String> store) {
        Utils.showCustomProgressDialog(this, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SetFavouriteResponse> call = apiInterface.removeAsFavouriteStore(ApiClient.makeGSONRequestBody(new RemoveFavourite(preferenceHelper.getSessionToken(), preferenceHelper.getUserId(), store)));
        call.enqueue(new Callback<SetFavouriteResponse>() {
            @Override
            public void onResponse(@NonNull Call<SetFavouriteResponse> call, @NonNull Response<SetFavouriteResponse> response) {
                Utils.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        favouriteStoreAdapter.clearRemovedStores();
                        CurrentBooking.getInstance().getFavourite().clear();
                        CurrentBooking.getInstance().setFavourite(response.body().getFavouriteStores());
                        onBackPressed();
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<SetFavouriteResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void gotToStoreProductActivity(Store store) {
        Intent intent = new Intent(this, StoreProductActivity.class);
        intent.putExtra(Const.SELECTED_STORE, store);
        intent.putExtra(Const.STORE_INDEX, getLangIndxex(preferenceHelper.getLanguageCode(), store.getLang(), true));
        intent.putExtra(Const.IS_STORE_CAN_CREATE_GROUP, store.isStoreCanCreateGroup());
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }
}