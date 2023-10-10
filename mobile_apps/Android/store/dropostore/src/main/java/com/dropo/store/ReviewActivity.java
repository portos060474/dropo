package com.dropo.store;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.Menu;
import android.widget.ProgressBar;
import android.widget.RatingBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.PublicReviewAdapter;
import com.dropo.store.models.datamodel.StoreReview;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.ReviewResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ReviewActivity extends BaseActivity {

    public static final String TAG = ReviewActivity.class.getName();
    private RecyclerView rcvPublicReview;
    private List<StoreReview> storePublicReview;
    private PublicReviewAdapter publicReviewAdapter;
    private CustomTextView tvReviewAverage, tv5StarCount, tv4StarCount, tv3StarCount, tv2StarCount, tv1StarCount;
    private RatingBar ratingBar;
    private ProgressBar bar5Star, bar4Star, bar3Star, bar2Star, bar1Star;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_review);
        storePublicReview = new ArrayList<>();
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_review));
        rcvPublicReview = findViewById(R.id.rcvPublicReview);
        tvReviewAverage = findViewById(R.id.tvReviewAverage);
        tv5StarCount = findViewById(R.id.tv5StarCount);
        tv4StarCount = findViewById(R.id.tv4StarCount);
        tv3StarCount = findViewById(R.id.tv3StarCount);
        tv2StarCount = findViewById(R.id.tv2StarCount);
        tv1StarCount = findViewById(R.id.tv1StarCount);
        ratingBar = findViewById(R.id.ratingBar);
        bar5Star = findViewById(R.id.bar5Star);
        bar4Star = findViewById(R.id.bar4Star);
        bar3Star = findViewById(R.id.bar3Star);
        bar2Star = findViewById(R.id.bar2Star);
        bar1Star = findViewById(R.id.bar1Star);
        initRcvStorePublicReview();
        getStoreReview(preferenceHelper.getStoreId());
    }

    private void initRcvStorePublicReview() {
        rcvPublicReview.setLayoutManager(new LinearLayoutManager(this));
        publicReviewAdapter = new PublicReviewAdapter(storePublicReview, this) {
            @Override
            public void onLike(int position) {
                //TODO enable when api gets ready, confirm with back-end before enable api.
                //setReviewLikeOrDislike(position, storePublicReview.get(position).isLike(), false);
            }

            @Override
            public void onDislike(int position) {
                //TODO enable when api gets ready, confirm with back-end before enable api.
                //setReviewLikeOrDislike(position, false, storePublicReview.get(position).isDislike());
            }
        };
        rcvPublicReview.setNestedScrollingEnabled(false);
        rcvPublicReview.setAdapter(publicReviewAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, 0);
        return true;
    }

    private void getStoreReview(String storeId) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, storeId);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<ReviewResponse> call = apiInterface.getStoreReview(map);
        call.enqueue(new Callback<ReviewResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<ReviewResponse> call, @NonNull Response<ReviewResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        storePublicReview.clear();
                        storePublicReview.addAll(response.body().getStoreReviewList());
                        publicReviewAdapter.notifyDataSetChanged();
                        setReviewData(storePublicReview);
                    } else {
                        parseContent.showErrorMessage(ReviewActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<ReviewResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    private void setReviewData(List<StoreReview> reviewData) {
        int oneStar = 0, twoStat = 0, threeStar = 0, fourStar = 0, fiveStar = 0;
        float rate = 0;
        for (StoreReview review : reviewData) {
            int rateRound = (int) Math.round(review.getUserRatingToStore());
            rate += review.getUserRatingToStore();
            switch (rateRound) {
                case 1:
                    oneStar++;
                    break;
                case 2:
                    twoStat++;
                    break;
                case 3:
                    threeStar++;
                    break;
                case 4:
                    fourStar++;
                    break;
                case 5:
                    fiveStar++;
                    break;
                default:
                    break;
            }
        }
        tv1StarCount.setText(String.valueOf(oneStar));
        tv2StarCount.setText(String.valueOf(twoStat));
        tv3StarCount.setText(String.valueOf(threeStar));
        tv4StarCount.setText(String.valueOf(fourStar));
        tv5StarCount.setText(String.valueOf(fiveStar));
        int totalRating = reviewData.size();
        if (totalRating > 0) {
            twoStat = twoStat * 100 / totalRating;
            threeStar = threeStar * 100 / totalRating;
            fourStar = fourStar * 100 / totalRating;
            fiveStar = fiveStar * 100 / totalRating;
            bar5Star.setProgress(fiveStar);
            bar4Star.setProgress(fourStar);
            bar3Star.setProgress(threeStar);
            bar2Star.setProgress(twoStat);
            bar1Star.setProgress(oneStar);
            rate = (rate / totalRating);
        }
        tvReviewAverage.setText(String.valueOf((float) Math.round(rate)));
        ratingBar.setRating((float) Math.round(rate));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    private void setReviewLikeOrDislike(final int position, final boolean like, final boolean dislike) {
        Utilities.showCustomProgressDialog(this, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
        map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
        map.put(Constant.IS_USER_CLICKED_LIKE_STORE_REVIEW, like);
        map.put(Constant.IS_USER_CLICKED_DISLIKE_STORE_REVIEW, dislike);
        map.put(Constant.REVIEW_ID, storePublicReview.get(position).getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> call = apiInterface.setStoreReviewLikeAndDislike(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (parseContent.isSuccessful(response)) {
                    if (response.body().isSuccess()) {
                        StoreReview reviewListItem = storePublicReview.get(position);
                        if (reviewListItem.isLike()) {
                            reviewListItem.getIdOfUsersDislikeStoreComment().remove(preferenceHelper.getStoreId());
                            reviewListItem.getIdOfUsersLikeStoreComment().add(preferenceHelper.getStoreId());
                        } else if (reviewListItem.isDislike()) {
                            reviewListItem.getIdOfUsersLikeStoreComment().remove(preferenceHelper.getStoreId());
                            reviewListItem.getIdOfUsersDislikeStoreComment().add(preferenceHelper.getStoreId());
                        } else {
                            reviewListItem.getIdOfUsersLikeStoreComment().remove(preferenceHelper.getStoreId());
                            reviewListItem.getIdOfUsersDislikeStoreComment().remove(preferenceHelper.getStoreId());
                        }
                        publicReviewAdapter.notifyDataSetChanged();
                    } else {
                        parseContent.showErrorMessage(ReviewActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                }
                Utilities.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }
}