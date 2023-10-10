package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;

import com.dropo.store.models.datamodel.ProviderDetail;
import com.dropo.store.models.datamodel.UserDetail;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomButton;
import com.dropo.store.widgets.CustomEditText;
import com.dropo.store.widgets.CustomTextView;


import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class FeedbackActivity extends BaseActivity {

    private ImageView ivProviderImageFeedback;
    private CustomTextView tvProviderNameFeedback;
    private RatingBar ratingBarFeedback;
    private CustomEditText etFeedbackReview;
    private CustomButton btnSubmitFeedback;
    private UserDetail userDetail;
    private ProviderDetail providerDetail;
    private String orderId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feedback);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_feed_back));
        ivProviderImageFeedback = findViewById(R.id.ivProviderImageFeedback);
        tvProviderNameFeedback = findViewById(R.id.tvProviderNameFeedback);
        ratingBarFeedback = findViewById(R.id.ratingBarFeedback);
        etFeedbackReview = findViewById(R.id.etFeedbackReview);
        btnSubmitFeedback = findViewById(R.id.btnSubmitFeedback);
        btnSubmitFeedback.setOnClickListener(this);
        ratingBarFeedback.setOnRatingBarChangeListener((ratingBar, v, b) -> ratingBarFeedback.setRating(v));
        loadExtraData();
        loadData();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(false);
        setToolbarEditIcon(false, R.drawable.filter_store);
        return true;
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.btnSubmitFeedback) {
            sendFeedback();
        }
    }

    private void sendFeedback() {
        if (ratingBarFeedback.getRating() == 0) {
            Utilities.showToast(this, getResources().getString(R.string.msg_plz_give_rating));
        } else {
            Utilities.showCustomProgressDialog(this, false);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = null;

            HashMap<String, Object> map = new HashMap<>();

            map.put(Constant.ORDER_ID, orderId);
            map.put(Constant.STORE_ID, preferenceHelper.getStoreId());
            map.put(Constant.SERVER_TOKEN, preferenceHelper.getServerToken());
            if (providerDetail == null) {
                map.put(Constant.STORE_RATING_TO_USER, ratingBarFeedback.getRating());
                map.put(Constant.STORE_REVIEW_TO_USER, etFeedbackReview.getText().toString());

                responseCall = apiInterface.setFeedbackUser(map);
            } else {
                map.put(Constant.STORE_RATING_TO_PROVIDER, ratingBarFeedback.getRating());
                map.put(Constant.STORE_REVIEW_TO_PROVIDER, etFeedbackReview.getText().toString());

                responseCall = apiInterface.setFeedbackProvider(map);
            }
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    Utilities.hideCustomProgressDialog();
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            setResult(Activity.RESULT_OK);
                            finish();
                        } else {
                            ParseContent.getInstance().showErrorMessage(FeedbackActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });
        }
    }

    private void loadExtraData() {
        Bundle bundle = getIntent().getExtras();
        if (bundle != null) {
            orderId = bundle.getString(Constant.ORDER_ID);
            userDetail = bundle.getParcelable(Constant.USER_DETAIL);
            providerDetail = bundle.getParcelable(Constant.PROVIDER_DETAIL);
        }
    }

    private void loadData() {
        if (providerDetail == null) {
            GlideApp.with(this)
                    .load(IMAGE_URL + userDetail.getImageUrl())
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                    .into(ivProviderImageFeedback);
            tvProviderNameFeedback.setText(String.format("%s %s", userDetail.getFirstName(), userDetail.getLastName()));

        } else {
            GlideApp.with(this)
                    .load(IMAGE_URL + providerDetail.getImageUrl())
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(this.getResources(), R.drawable.placeholder, null))
                    .into(ivProviderImageFeedback);
            tvProviderNameFeedback.setText(String.format("%s %s", providerDetail.getFirstName(), providerDetail.getLastName()));
        }
    }
}