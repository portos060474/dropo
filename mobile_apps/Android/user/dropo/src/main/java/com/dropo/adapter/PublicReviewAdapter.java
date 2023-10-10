package com.dropo.adapter;

import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.LinearSnapHelper;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.SnapHelper;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.fragments.ReviewFragment;
import com.dropo.models.datamodels.RemainingReview;
import com.dropo.models.datamodels.StoreReview;
import com.dropo.parser.ParseContent;
import com.dropo.utils.AppLog;
import com.dropo.utils.GlideApp;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.SectionedRecyclerViewAdapter;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

public abstract class PublicReviewAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {
    private final List<StoreReview> storeReview;
    private final ReviewFragment reviewFragment;
    private final List<RemainingReview> remainStoreReview;
    private ReviewAdapter reviewAdapter;

    public PublicReviewAdapter(List<RemainingReview> remainStoreReview, List<StoreReview> storeReview, ReviewFragment reviewFragment) {
        this.storeReview = storeReview;
        this.reviewFragment = reviewFragment;
        this.remainStoreReview = remainStoreReview;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (VIEW_TYPE_ITEM == viewType) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_review_2, parent, false);
            return new PublicReviewHolder(view);
        } else {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_review_2_header, parent, false);
            return new PublicReviewHolderHeader(view);
        }
    }

    @Override
    public int getSectionCount() {
        return 1;
    }

    @Override
    public int getItemCount(int section) {
        return storeReview.size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        PublicReviewHolderHeader holderHeader = (PublicReviewHolderHeader) holder;
        if (remainStoreReview.isEmpty()) {
            holderHeader.itemView.setVisibility(View.GONE);
            holderHeader.itemView.getLayoutParams().height = 0;
        } else {
            holderHeader.itemView.setVisibility(View.VISIBLE);
            holderHeader.itemView.getLayoutParams().height = ViewGroup.LayoutParams.WRAP_CONTENT;
            holderHeader.rcvOrderReview.setLayoutManager(new LinearLayoutManager(reviewFragment.getContext(), LinearLayoutManager.HORIZONTAL, false));
            reviewAdapter = new ReviewAdapter(remainStoreReview, reviewFragment) {
                @Override
                public void onSelect(int position, float rating, String comment) {
                    submitReview(remainStoreReview.get(position).getOrderId(), position, rating, comment);
                }
            };
            holderHeader.rcvOrderReview.setAdapter(reviewAdapter);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, final int relativePosition, int absolutePosition) {
        PublicReviewHolder reviewHolder = (PublicReviewHolder) holder;
        final StoreReview reviewListItem = storeReview.get(relativePosition);
        GlideApp.with(reviewFragment.requireContext())
                .load(IMAGE_URL + reviewListItem.getUserDetail().getImageUrl())
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(reviewFragment.requireContext().getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(reviewFragment.requireContext().getResources(), R.drawable.placeholder, null))
                .into(reviewHolder.ivUserImage);
        reviewHolder.tvUserName.setText(String.format("%s %s", reviewListItem.getUserDetail().getFirstName(), reviewListItem.getUserDetail().getLastName()));
        reviewHolder.tvRate.setText(String.valueOf(reviewListItem.getUserRatingToStore()));
        if (TextUtils.isEmpty(reviewListItem.getUserReviewToStore())) {
            reviewHolder.llLike.setVisibility(View.GONE);
            reviewHolder.tvUserComment.setVisibility(View.GONE);
        } else {
            reviewHolder.tvUserComment.setText(reviewListItem.getUserReviewToStore());
            reviewHolder.tvUserComment.setVisibility(View.VISIBLE);
            reviewHolder.llLike.setVisibility(View.VISIBLE);
            reviewHolder.tvLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment.requireContext(), R.drawable.ic_thumbs_up_01_unselect), null, null, null);
            reviewHolder.tvDisLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment.requireContext(), R.drawable.ic_thumbs_down_01_unselect), null, null, null);
            reviewHolder.tvLike.setOnClickListener(v -> {
                reviewListItem.setDislike(false);
                reviewListItem.setLike(!reviewListItem.isLike());
                onLike(relativePosition);
            });
            reviewHolder.tvDisLike.setOnClickListener(v -> {
                reviewListItem.setLike(false);
                reviewListItem.setDislike(!reviewListItem.isDislike());
                onDislike(relativePosition);
            });
            reviewListItem.setDislike(false);
            reviewListItem.setLike(false);

            if (reviewListItem.getIdOfUsersLikeStoreComment().contains(PreferenceHelper.getInstance(reviewFragment.requireContext()).getUserId())) {
                reviewHolder.tvLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment.requireContext(), R.drawable.ic_thumbs_up_01), null, null, null);
                reviewListItem.setLike(true);
            } else if (reviewListItem.getIdOfUsersDislikeStoreComment().contains(PreferenceHelper.getInstance(reviewFragment.requireContext()).getUserId())) {
                reviewHolder.tvDisLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment.requireContext(), R.drawable.ic_thumbs_down_01), null, null, null);
                reviewListItem.setDislike(true);
            }
        }
        reviewHolder.tvLike.setText(String.valueOf(reviewListItem.getIdOfUsersLikeStoreComment().size()));
        reviewHolder.tvDisLike.setText(String.valueOf(reviewListItem.getIdOfUsersDislikeStoreComment().size()));
        try {
            Date date = ParseContent.getInstance().webFormat.parse(reviewListItem.getCreatedAt());
            if (date != null) {
                reviewHolder.tvDate.setText(ParseContent.getInstance().dateFormat3.format(date));
            }
        } catch (ParseException e) {
            AppLog.handleException(PublicReviewAdapter.class.getName(), e);
        }
    }


    public abstract void onLike(int position);

    public abstract void onDislike(int position);

    public abstract void submitReview(String orderId, int position, float rating, String comment);

    @SuppressLint("NotifyDataSetChanged")
    public void notifyReview(int position) {
        if (reviewAdapter != null) {
            remainStoreReview.remove(position);
            reviewAdapter.notifyDataSetChanged();
            notifyDataSetChanged();
        }
    }

    protected static class PublicReviewHolder extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvUserName;
        CustomFontTextView tvRate, tvDate, tvUserComment, tvLike, tvDisLike;
        ImageView ivUserImage;
        LinearLayout llLike;

        public PublicReviewHolder(View itemView) {
            super(itemView);
            tvUserName = itemView.findViewById(R.id.tvUserName);
            tvRate = itemView.findViewById(R.id.tvRate);
            tvDate = itemView.findViewById(R.id.tvDate);
            tvUserComment = itemView.findViewById(R.id.tvUserComment);
            tvLike = itemView.findViewById(R.id.tvLike);
            tvDisLike = itemView.findViewById(R.id.tvDisLike);
            ivUserImage = itemView.findViewById(R.id.ivUserImage);
            llLike = itemView.findViewById(R.id.llLike);
        }
    }

    protected static class PublicReviewHolderHeader extends RecyclerView.ViewHolder {
        private final RecyclerView rcvOrderReview;

        public PublicReviewHolderHeader(View itemView) {
            super(itemView);
            rcvOrderReview = itemView.findViewById(R.id.rcvOrderReview);
            SnapHelper snapHelper = new LinearSnapHelper();
            snapHelper.attachToRecyclerView(rcvOrderReview);
        }
    }
}