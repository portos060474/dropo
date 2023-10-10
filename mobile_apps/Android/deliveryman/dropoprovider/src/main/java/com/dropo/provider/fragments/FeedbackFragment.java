package com.dropo.provider.fragments;

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

import com.dropo.provider.ActiveDeliveryActivity;
import com.dropo.provider.HistoryDetailActivity;
import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontButton;
import com.dropo.provider.component.CustomFontEditTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.Order;
import com.dropo.provider.models.datamodels.StoreDetail;
import com.dropo.provider.models.datamodels.UserDetail;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FeedbackFragment extends BottomSheetDialogFragment implements TextView.OnEditorActionListener, View.OnClickListener {

    private CustomFontTextViewTitle tvProviderNameFeedback;
    private RatingBar ratingBarFeedback;
    private CustomFontEditTextView etFeedbackReview;
    private CustomFontButton btnSubmitFeedback;
    private String requestId;
    private StoreDetail storeDetail;
    private UserDetail userDetail;
    private Order order;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_feedback, container, false);
        ratingBarFeedback = view.findViewById(R.id.ratingBarFeedback);
        tvProviderNameFeedback = view.findViewById(R.id.tvProviderNameFeedback);
        etFeedbackReview = view.findViewById(R.id.etFeedbackReview);
        btnSubmitFeedback = view.findViewById(R.id.btnSubmitFeedback);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismissDialog());
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Bundle bundle = getArguments();
        requestId = bundle.getString(Const.Params.REQUEST_ID);
        storeDetail = bundle.getParcelable(Const.STORE_DETAIL);
        userDetail = bundle.getParcelable(Const.USER_DETAIL);
        order = bundle.getParcelable(Const.Params.NEW_ORDER);
        loadData();
        btnSubmitFeedback.setOnClickListener(this);
        etFeedbackReview.setOnEditorActionListener(this);
        ratingBarFeedback.setOnRatingBarChangeListener((ratingBar, v, b) -> ratingBarFeedback.setRating(v));
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == R.id.btnSubmitFeedback) {
            submitRatting();
        }
    }

    /**
     * this method call a webservice for give feedback to user
     */
    private void giveFeedback() {
        Utils.showCustomProgressDialog(getContext(), false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(requireContext()).getSessionToken());
        map.put(Const.Params.PROVIDER_ID, PreferenceHelper.getInstance(requireContext()).getProviderId());
        map.put(Const.Params.REQUEST_ID, requestId);

        if (storeDetail == null) {
            map.put(Const.Params.PROVIDER_RATING_TO_USER, ratingBarFeedback.getRating());
            map.put(Const.Params.PROVIDER_REVIEW_TO_USER, etFeedbackReview.getText().toString());
            responseCall = apiInterface.setFeedbackUser(map);
        } else {
            map.put(Const.Params.PROVIDER_RATING_TO_STORE, ratingBarFeedback.getRating());
            map.put(Const.Params.PROVIDER_REVIEW_TO_STORE, etFeedbackReview.getText().toString());
            responseCall = apiInterface.setFeedbackStore(map);
        }

        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), getContext());
                        if (getActivity() instanceof HistoryDetailActivity) {
                            HistoryDetailActivity historyDetailActivity = (HistoryDetailActivity) getActivity();
                            if (storeDetail == null) {
                                historyDetailActivity.submitUserReview();
                            } else {
                                historyDetailActivity.submitStoreReview();
                            }
                        }
                        dismissDialog();
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), getContext());
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

    private void submitRatting() {
        if (ratingBarFeedback.getRating() == 0) {
            Utils.showToast(getResources().getString(R.string.msg_plz_give_rating), getContext());
        } else {
            giveFeedback();
        }
    }

    private void loadData() {
        if (order != null && userDetail == null && storeDetail == null) {
            //  give rating to user from ActiveFragmentDelivery
            tvProviderNameFeedback.setText(String.format("%s %s", order.getUserFirstName(), order.getUserLastName()));
            tvProviderNameFeedback.setText(order.getDestinationAddresses().get(0).getUserDetails().getName());
        } else if (userDetail != null && storeDetail == null && order == null) {
            tvProviderNameFeedback.setText(userDetail.getName());
        } else {
            // give rating to store from feedback screen
            if (storeDetail != null) {
                tvProviderNameFeedback.setText(storeDetail.getName());
            }
        }
    }

    private void dismissDialog() {
        if (getActivity() instanceof ActiveDeliveryActivity) {
            dismiss();
            ActiveDeliveryActivity activeDeliveryActivity = (ActiveDeliveryActivity) getActivity();
            activeDeliveryActivity.onBackPressed();
        } else {
            dismiss();
        }
    }
}