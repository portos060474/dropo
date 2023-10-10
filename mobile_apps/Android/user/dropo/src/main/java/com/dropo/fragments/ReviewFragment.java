package com.dropo.fragments;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RatingBar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.StoreProductActivity;
import com.dropo.adapter.PublicReviewAdapter;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.RemainingReview;
import com.dropo.models.datamodels.StoreReview;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.ReviewResponse;
import com.dropo.parser.ApiClient;
import com.dropo.parser.ApiInterface;
import com.dropo.utils.AppColor;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ReviewFragment extends BottomSheetDialogFragment {

    private RecyclerView rcvPublicReview;
    private StoreProductActivity storeProductActivity;
    private List<RemainingReview> remainStoreReview;
    private List<StoreReview> storePublicReview;
    private PublicReviewAdapter publicReviewAdapter;
    private CustomFontTextView tvReviewAverage, tv5StarCount, tv4StarCount, tv3StarCount, tv2StarCount, tv1StarCount;
    private RatingBar ratingBar;
    private ProgressBar bar5Star, bar4Star, bar3Star, bar2Star, bar1Star;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        storeProductActivity = (StoreProductActivity) getActivity();
        synchronized (this) {
            storePublicReview = new ArrayList<>();
        }
        remainStoreReview = new ArrayList<>();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_review, container, false);
        rcvPublicReview = view.findViewById(R.id.rcvPublicReview);
        tvReviewAverage = view.findViewById(R.id.tvReviewAverage);
        tv5StarCount = view.findViewById(R.id.tv5StarCount);
        tv4StarCount = view.findViewById(R.id.tv4StarCount);
        tv3StarCount = view.findViewById(R.id.tv3StarCount);
        tv2StarCount = view.findViewById(R.id.tv2StarCount);
        tv1StarCount = view.findViewById(R.id.tv1StarCount);
        ratingBar = view.findViewById(R.id.ratingBar);
        bar5Star = view.findViewById(R.id.bar5Star);
        bar4Star = view.findViewById(R.id.bar4Star);
        bar3Star = view.findViewById(R.id.bar3Star);
        bar2Star = view.findViewById(R.id.bar2Star);
        bar1Star = view.findViewById(R.id.bar1Star);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismiss());
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initRcvStorePublicReview();
        getStoreReview(storeProductActivity.store.getId());
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK && requestCode == Const.FEEDBACK_REQUEST) {
            getStoreReview(storeProductActivity.store.getId());
        }
    }

    private void initRcvStorePublicReview() {
        rcvPublicReview.setLayoutManager(new LinearLayoutManager(storeProductActivity));
        publicReviewAdapter = new PublicReviewAdapter(remainStoreReview, storePublicReview, this) {
            @Override
            public void onLike(int position) {
                setReviewLikeOrDislike(position, storePublicReview.get(position).isLike(), false);
            }

            @Override
            public void onDislike(int position) {
                setReviewLikeOrDislike(position, false, storePublicReview.get(position).isDislike());
            }

            @Override
            public void submitReview(String orderId, int position, float rating, String comment) {
                giveFeedback(orderId, position, rating, comment);
            }
        };
        publicReviewAdapter.shouldShowHeadersForEmptySections(true);
        rcvPublicReview.setAdapter(publicReviewAdapter);
        DividerItemDecoration itemDecorationnew = new DividerItemDecoration(storeProductActivity, DividerItemDecoration.VERTICAL);
        if (itemDecorationnew.getDrawable() != null) {
            itemDecorationnew.getDrawable().setTint(ResourcesCompat.getColor(getResources(), AppColor.isDarkTheme(storeProductActivity) ? R.color.color_app_tag_light : R.color.color_app_tag_dark, null));
        }
        rcvPublicReview.addItemDecoration(itemDecorationnew);
    }

    private void getStoreReview(String storeId) {
        Utils.showCustomProgressDialog(storeProductActivity, false);
        HashMap<String, Object> map = new HashMap<>();
        if (storeProductActivity.isCurrentLogin()) {
            map.put(Const.Params.USER_ID, storeProductActivity.preferenceHelper.getUserId());
            map.put(Const.Params.SERVER_TOKEN, storeProductActivity.preferenceHelper.getSessionToken());
        }
        map.put(Const.Params.STORE_ID, storeId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ReviewResponse> call = apiInterface.getStoreReview(map);
        call.enqueue(new Callback<ReviewResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ReviewResponse> call, @NonNull Response<ReviewResponse> response) {
                Utils.hideCustomProgressDialog();
                if (storeProductActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        remainStoreReview.clear();
                        storePublicReview.clear();
                        remainStoreReview.addAll(response.body().getRemainingReviewList());
                        storePublicReview.addAll(response.body().getStoreReviewList());
                        publicReviewAdapter.notifyDataSetChanged();
                        setReviewData(storePublicReview);
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), storeProductActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ReviewResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                Utils.hideCustomProgressDialog();
            }
        });
    }

    private void setReviewData(List<StoreReview> reviewData) {
        Double oneStar = 0.0, twoStar = 0.0, threeStar = 0.0, fourStar = 0.0, fiveStar = 0.0;
        float rate = 0;
        for (StoreReview review : reviewData) {
            int rateRound = (int) Math.round(review.getUserRatingToStore());
            rate += review.getUserRatingToStore();
            switch (rateRound) {
                case 1:
                    oneStar += 1.0;
                    break;
                case 2:
                    twoStar += 1.0;
                    break;
                case 3:
                    threeStar += 1.0;
                    break;
                case 4:
                    fourStar += 1.0;
                    break;
                case 5:
                    fiveStar += 1.0;
                    break;
                default:
                    // do with default
                    break;
            }
        }
        tv1StarCount.setText(String.valueOf(oneStar));
        tv2StarCount.setText(String.valueOf(twoStar));
        tv3StarCount.setText(String.valueOf(threeStar));
        tv4StarCount.setText(String.valueOf(fourStar));
        tv5StarCount.setText(String.valueOf(fiveStar));
        int totalRating = reviewData.size();
        if (totalRating > 0.0) {
            int rateOne, rateTwo, rateThree, rateFour, rateFive;
            rateOne = (int) (oneStar * 100 / totalRating);
            rateTwo = (int) (twoStar * 100 / totalRating);
            rateThree = (int) (threeStar * 100 / totalRating);
            rateFour = (int) (fourStar * 100 / totalRating);
            rateFive = (int) (fiveStar * 100 / totalRating);
            bar5Star.setProgress(rateFive);
            bar4Star.setProgress(rateFour);
            bar3Star.setProgress(rateThree);
            bar2Star.setProgress(rateTwo);
            bar1Star.setProgress(rateOne);
            rate = (rate / totalRating);
        }
        tvReviewAverage.setText(String.valueOf((float) Math.round(rate)));
        ratingBar.setRating((float) Math.round(rate));
    }

    private void setReviewLikeOrDislike(final int position, final boolean like, final boolean dislike) {
        if (storeProductActivity.isCurrentLogin()) {
            Utils.showCustomProgressDialog(storeProductActivity, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Const.Params.USER_ID, storeProductActivity.preferenceHelper.getUserId());
            map.put(Const.Params.SERVER_TOKEN, storeProductActivity.preferenceHelper.getSessionToken());
            map.put(Const.Params.IS_USER_CLICKED_LIKE_STORE_REVIEW, like);
            map.put(Const.Params.IS_USER_CLICKED_DISLIKE_STORE_REVIEW, dislike);
            map.put(Const.Params.REVIEW_ID, storePublicReview.get(position).getId());
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> call = apiInterface.setUserReviewLikeAndDislike(map);
            call.enqueue(new Callback<IsSuccessResponse>() {
                @SuppressLint("NotifyDataSetChanged")
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    if (storeProductActivity.parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            StoreReview reviewListItem = storePublicReview.get(position);
                            if (reviewListItem.isLike()) {
                                reviewListItem.getIdOfUsersDislikeStoreComment().remove(storeProductActivity.preferenceHelper.getUserId());

                                reviewListItem.getIdOfUsersLikeStoreComment().add(storeProductActivity.preferenceHelper.getUserId());
                            } else if (reviewListItem.isDislike()) {
                                reviewListItem.getIdOfUsersLikeStoreComment().remove(storeProductActivity.preferenceHelper.getUserId());

                                reviewListItem.getIdOfUsersDislikeStoreComment().add(storeProductActivity.preferenceHelper.getUserId());
                            } else {
                                reviewListItem.getIdOfUsersLikeStoreComment().remove(storeProductActivity.preferenceHelper.getUserId());
                                reviewListItem.getIdOfUsersDislikeStoreComment().remove(storeProductActivity.preferenceHelper.getUserId());
                            }
                            publicReviewAdapter.notifyDataSetChanged();
                        } else {
                            Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), storeProductActivity);
                        }
                    }

                    Utils.hideCustomProgressDialog();
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    AppLog.handleThrowable(Const.Tag.STORES_ACTIVITY, t);
                    Utils.hideCustomProgressDialog();
                }
            });
        }
    }

    private void giveFeedback(String orderId, int position, float rating, String comment) {
        Utils.showCustomProgressDialog(storeProductActivity, false);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall;
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.SERVER_TOKEN, storeProductActivity.preferenceHelper.getSessionToken());
        map.put(Const.Params.USER_ID, storeProductActivity.preferenceHelper.getUserId());
        map.put(Const.Params.ORDER_ID, orderId);
        map.put(Const.Params.USER_RATING_TO_STORE, rating);
        map.put(Const.Params.USER_REVIEW_TO_STORE, comment);
        responseCall = apiInterface.setFeedbackStore(map);
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (storeProductActivity.parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        Utils.showMessageToast(response.body().getStatusPhrase(), storeProductActivity);
                        if (publicReviewAdapter != null) {
                            publicReviewAdapter.notifyReview(position);
                        }
                    } else {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), storeProductActivity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                AppLog.handleThrowable(ReviewFragment.class.getName(), t);
                Utils.hideCustomProgressDialog();
            }
        });
    }
}