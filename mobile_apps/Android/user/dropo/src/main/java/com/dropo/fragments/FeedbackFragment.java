package com.dropo.fragments;

import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.RatingBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.dropo.OrderDetailActivity;
import com.dropo.user.R;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.models.datamodels.Addresses;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FeedbackFragment extends BottomSheetDialogFragment implements View.OnClickListener, TextView.OnEditorActionListener {

    private TextView tvProviderNameFeedback;
    private RatingBar ratingBarFeedback;
    private CustomFontEditTextView etFeedbackReview;
    private CustomFontButton btnSubmitFeedback;
    private OrderDetailActivity activity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (OrderDetailActivity) getActivity();
        activity.setTitleOnToolBar(activity.getResources().getString(R.string.text_feedback));
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_feedback, container, false);
        tvProviderNameFeedback = view.findViewById(R.id.tvProviderNameFeedback);
        ratingBarFeedback = view.findViewById(R.id.ratingBarFeedback);
        etFeedbackReview = view.findViewById(R.id.etFeedbackReview);
        btnSubmitFeedback = view.findViewById(R.id.btnSubmitFeedback);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismiss());
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        btnSubmitFeedback.setOnClickListener(this);
        etFeedbackReview.setOnEditorActionListener(this);
        ratingBarFeedback.setOnRatingBarChangeListener(new RatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(RatingBar ratingBar, float v, boolean b) {
                ratingBarFeedback.setRating(v);
            }
        });
        loadData(getArguments().getBoolean(Const.Params.IS_STORE_RATING));
    }

    private void loadData(boolean storeData) {
        if (activity.isShowHistory) {
            if (activity.historyDetailResponse != null && !storeData) {
                tvProviderNameFeedback.setText(String.format("%s %s", activity.historyDetailResponse.getProviderDetail().getFirstName(), activity.historyDetailResponse.getProviderDetail().getLastName()));
            } else {
                tvProviderNameFeedback.setText(activity.historyDetailResponse.getStore().getName());
            }

        } else {
            if (activity.activeOrderResponse != null && !storeData) {
                if (activity.activeOrderResponse.getProvider() != null) {
                    tvProviderNameFeedback.setText(activity.activeOrderResponse.getProvider().getName());
                }
            } else if (activity.activeOrderResponse != null && storeData) {
                Addresses addresses = activity.activeOrderResponse.getPickupAddresses().get(0);
                tvProviderNameFeedback.setText(addresses.getUserDetails().getName());
            }
        }
    }

    @Override
    public void onClick(View view) {
        int id = view.getId();
        if (id == R.id.btnSubmitFeedback) {
            submitRatting();
        }
    }

    private void submitRatting() {
        if (ratingBarFeedback.getRating() == 0) {
            Utils.showToast(getResources().getString(R.string.msg_plz_give_rating), activity);
        } else {
            giveFeedback();
        }
    }

    /**
     * this method call a webservice for give feedback to delivery man
     */
    private void giveFeedback() {
        Utils.showCustomProgressDialog(activity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, activity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, activity.preferenceHelper.getUserId());
        if (activity.isShowHistory) {
            map.put(Const.Params.ORDER_ID, activity.historyDetailResponse.getOrderDetail().getId());
        } else {
            map.put(Const.Params.ORDER_ID, activity.order.getId());
        }
        if (!getArguments().getBoolean(Const.Params.IS_STORE_RATING)) {
            map.put(Const.Params.USER_RATING_TO_PROVIDER, ratingBarFeedback.getRating());
            map.put(Const.Params.USER_REVIEW_TO_PROVIDER, etFeedbackReview.getText().toString());
            responseCall = apiInterface.setFeedbackProvider(map);
        } else {
            map.put(Const.Params.USER_RATING_TO_STORE, ratingBarFeedback.getRating());
            map.put(Const.Params.USER_REVIEW_TO_STORE, etFeedbackReview.getText().toString());
            responseCall = apiInterface.setFeedbackStore(map);
        }
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (activity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), activity);
                        if (getArguments().getBoolean(Const.Params.IS_STORE_RATING)) {
                            activity.setRatingForStore(ratingBarFeedback.getRating());
                        } else {
                            activity.setRatingForDeliveryMan(ratingBarFeedback.getRating());
                        }
                        dismiss();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), activity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(FeedbackFragment.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });

    }

    @Override
    public boolean onEditorAction(TextView textView, int i, KeyEvent keyEvent) {
        if (textView.getId() == R.id.etFeedbackReview) {
            if (i == EditorInfo.IME_ACTION_DONE) {
                submitRatting();
                return true;
            }
        }
        return false;
    }
}