package com.dropo.fragments;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.CheckoutActivity;
import com.dropo.user.R;
import com.dropo.adapter.PromoDetailAdapter;
import com.dropo.models.datamodels.PromoCodes;
import com.dropo.models.responsemodels.DeliveryOffersResponse;
import com.dropo.models.responsemodels.StoreOffersResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class PromoFragment extends BottomSheetDialogFragment {

    private RecyclerView rcvOffer;
    private LinearLayout ivEmpty;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_promo, container, false);
        view.findViewById(R.id.btnClosed).setOnClickListener(view1 -> dismiss());
        rcvOffer = view.findViewById(R.id.rcvOffers);
        ivEmpty = view.findViewById(R.id.ivEmpty);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }
        Bundle bundle = getArguments();
        if (TextUtils.isEmpty(bundle.getString(Const.Params.PROMO_ID))) {
            getStoreOffers(bundle.getString(Const.STORE_DETAIL));
        } else {
            getPromoDetail(bundle.getString(Const.Params.PROMO_ID));
        }

    }

    private void getStoreOffers(String storeId) {
        Utils.showCustomProgressDialog(getContext(), false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.STORE_ID, storeId);
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(requireContext()).getSessionToken());
        map.put(Const.Params.USER_ID, PreferenceHelper.getInstance(requireContext()).getUserId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<StoreOffersResponse> responseCall = apiInterface.getStoreOffers(map);
        responseCall.enqueue(new Callback<StoreOffersResponse>() {
            @Override
            public void onResponse(@NonNull Call<StoreOffersResponse> call, @NonNull Response<StoreOffersResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess() && response.body().getPromoCodes() != null && !response.body().getPromoCodes().isEmpty()) {
                        ivEmpty.setVisibility(View.GONE);
                        rcvOffer.setVisibility(View.VISIBLE);
                        rcvOffer.setAdapter(new PromoDetailAdapter(getContext(), response.body().getPromoCodes(), true) {
                            @Override
                            public void promoApply(PromoCodes promoCodes) {
                                if (getActivity() instanceof CheckoutActivity) {
                                    CheckoutActivity checkoutActivity = (CheckoutActivity) getActivity();
                                    dismiss();
                                    checkoutActivity.selectPromoOffer(promoCodes.getPromoCodeName());
                                }
                            }
                        });
                    } else {
                        ivEmpty.setVisibility(View.VISIBLE);
                        rcvOffer.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<StoreOffersResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(CheckoutActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void getPromoDetail(String promoId) {
        Utils.showCustomProgressDialog(getContext(), false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.PROMO_ID, promoId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<DeliveryOffersResponse> responseCall = apiInterface.getPromoDetail(map);
        responseCall.enqueue(new Callback<DeliveryOffersResponse>() {
            @Override
            public void onResponse(@NonNull Call<DeliveryOffersResponse> call, @NonNull Response<DeliveryOffersResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess() && response.body().getPromoCodeDetail() != null) {
                        ivEmpty.setVisibility(View.GONE);
                        rcvOffer.setVisibility(View.VISIBLE);
                        ArrayList<PromoCodes> promoCodes = new ArrayList<>();
                        promoCodes.add(response.body().getPromoCodeDetail());
                        rcvOffer.setAdapter(new PromoDetailAdapter(getContext(), promoCodes, false) {
                            @Override
                            public void promoApply(PromoCodes promoCodes) {

                            }
                        });
                    } else {
                        ivEmpty.setVisibility(View.VISIBLE);
                        rcvOffer.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<DeliveryOffersResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(CheckoutActivity.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }
}