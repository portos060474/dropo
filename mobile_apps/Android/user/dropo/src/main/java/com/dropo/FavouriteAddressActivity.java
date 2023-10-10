package com.dropo;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.adapter.FavouriteAddressAdapter;
import com.dropo.component.CustomFloatingButton;
import com.dropo.fragments.AddFavouriteAddressFragment;
import com.dropo.models.datamodels.Address;
import com.dropo.models.datamodels.FavoriteAddressResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FavouriteAddressActivity extends BaseAppCompatActivity {

    private RecyclerView rcvAddresses;
    private CustomFloatingButton btnAddNewAddress;
    private LinearLayout viewEmpty;
    private final ArrayList<Address> addressList = new ArrayList<>();
    private FavouriteAddressAdapter favouriteAddressAdapter;
    private boolean isChoseAddress = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favourite_address);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_favourite_address));
        initViewById();
        setViewListener();
        loadExtraData();
        favouriteAddressAdapter = new FavouriteAddressAdapter(isChoseAddress) {
            @Override
            public void onAddressDelete(Address address) {
                if (!isChoseAddress) {
                    deleteAddress(address);
                }
            }

            @Override
            public void onAddressUpdate(Address address) {
                if (isChoseAddress) {
                    Intent intent = new Intent();
                    intent.putExtra(Const.Params.ADDRESS, address);
                    setResult(Activity.RESULT_OK, intent);
                    onBackPressed();
                } else {
                    addFavouriteAddress(address);
                }
            }
        };
        rcvAddresses.setAdapter(favouriteAddressAdapter);
        loadAddress();
    }

    private void deleteAddress(Address address) {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.ADDRESS_ID, address.getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteFavAddress(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        favouriteAddressAdapter.removeAddress(address);
                        checkEmptyData();
                        Utils.showToast(getString(R.string.msg_favourite_address_removed_successfully), FavouriteAddressActivity.this);
                    } else {
                        Utils.showToast(getString(R.string.msg_favourite_address_failed), FavouriteAddressActivity.this);
                    }
                }
                Utils.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CURRENT_ORDER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public void loadExtraData() {
        if (getIntent().getExtras() != null && getIntent().getExtras().getBoolean(Const.Params.ADDRESS)) {
            isChoseAddress = getIntent().getExtras().getBoolean(Const.Params.ADDRESS, false);
        }
        if (isChoseAddress) {
            btnAddNewAddress.setVisibility(View.GONE);
        } else {
            btnAddNewAddress.setVisibility(View.VISIBLE);
        }
    }

    public void loadAddress() {
        Utils.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, preferenceHelper.getUserId());
        map.put(Const.Params.ID, preferenceHelper.getUserId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<FavoriteAddressResponse> responseCall = apiInterface.getFavAddressList(map);
        responseCall.enqueue(new Callback<FavoriteAddressResponse>() {
            @Override
            public void onResponse(@NonNull Call<FavoriteAddressResponse> call, @NonNull Response<FavoriteAddressResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    addressList.clear();
                    if (response.body().isSuccess()) {
                        addressList.addAll(response.body().getFavouriteAddresses());
                        rcvAddresses.setAdapter(favouriteAddressAdapter);
                        checkEmptyData();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), FavouriteAddressActivity.this);
                    }
                }
                Utils.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<FavoriteAddressResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.CURRENT_ORDER_FRAGMENT, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void checkEmptyData() {
        if (addressList.isEmpty()) {
            viewEmpty.setVisibility(View.VISIBLE);
        } else {
            viewEmpty.setVisibility(View.GONE);
            favouriteAddressAdapter.setAddresses(addressList);
        }
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        rcvAddresses = findViewById(R.id.rcvFavouriteAddress);
        viewEmpty = findViewById(R.id.viewEmpty);
        btnAddNewAddress = findViewById(R.id.btnAddFavouriteAddress);
    }

    @Override
    protected void setViewListener() {
        btnAddNewAddress.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btnAddFavouriteAddress) {
            addFavouriteAddress(null);
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void addFavouriteAddress(Address address) {
        AddFavouriteAddressFragment favouriteAddressFragment = new AddFavouriteAddressFragment();
        if (address != null) {
            Bundle bundle = new Bundle();
            bundle.putParcelable(Const.Params.ADDRESS, address);
            favouriteAddressFragment.setArguments(bundle);
        }
        favouriteAddressFragment.show(getSupportFragmentManager(), favouriteAddressFragment.getTag());
    }
}