package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.ReviewActivity;
import com.dropo.store.models.datamodel.StoreReview;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;


import java.text.ParseException;
import java.util.Date;
import java.util.List;

public abstract class PublicReviewAdapter extends RecyclerView.Adapter<PublicReviewAdapter.PublicReviewHolder> {

    private final List<StoreReview> storeReview;
    private final ReviewActivity reviewFragment;

    public PublicReviewAdapter(List<StoreReview> storeReview, ReviewActivity reviewFragment) {
        this.storeReview = storeReview;
        this.reviewFragment = reviewFragment;
    }

    @NonNull
    @Override
    public PublicReviewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_review_2, parent, false);
        return new PublicReviewHolder(view);
    }

    @Override
    public void onBindViewHolder(PublicReviewHolder holder, final int position) {
        final StoreReview reviewListItem = storeReview.get(position);
        GlideApp.with(reviewFragment)
                .load(IMAGE_URL + reviewListItem.getUserDetail().getImageUrl())
                .dontAnimate()
                .placeholder(ResourcesCompat.getDrawable(reviewFragment.getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(reviewFragment.getResources(), R.drawable.placeholder, null))
                .into(holder.ivUserImage);
        holder.tvUserName.setText(String.format("%s %s", reviewListItem.getUserDetail().getFirstName(), reviewListItem.getUserDetail().getLastName()));
        holder.tvRate.setText(String.valueOf(reviewListItem.getUserRatingToStore()));
        if (TextUtils.isEmpty(reviewListItem.getUserReviewToStore())) {
            holder.llLike.setVisibility(View.GONE);
            holder.tvUserComment.setVisibility(View.GONE);
        } else {
            holder.tvUserComment.setText(reviewListItem.getUserReviewToStore());
            holder.tvUserComment.setVisibility(View.VISIBLE);
            holder.llLike.setVisibility(View.VISIBLE);
            holder.tvLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment, R.drawable.ic_thumbs_up_01_unselect), null, null, null);
            holder.tvDisLike.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(reviewFragment, R.drawable.ic_thumbs_down_01_unselect), null, null, null);
        }
        holder.tvLike.setText(String.valueOf(reviewListItem.getIdOfUsersLikeStoreComment().size()));
        holder.tvDisLike.setText(String.valueOf(reviewListItem.getIdOfUsersDislikeStoreComment().size()));
        try {
            Date date = ParseContent.getInstance().webFormat.parse(reviewListItem.getCreatedAt());
            if (date != null) {
                holder.tvDate.setText(ParseContent.getInstance().dateFormat3.format(date));
            }
        } catch (ParseException e) {
            Utilities.handleException(PublicReviewAdapter.class.getName(), e);
        }
        holder.tvOrderId.setText(String.format("%s%s", reviewFragment.getResources().getString(R.string.text_order_no), reviewListItem.getOrderUniqueId()));
    }

    @Override
    public int getItemCount() {
        return storeReview.size();
    }

    public abstract void onLike(int position);

    public abstract void onDislike(int position);

    protected static class PublicReviewHolder extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvUserName;
        CustomTextView tvRate, tvDate, tvUserComment, tvLike, tvDisLike, tvOrderId;
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
            tvOrderId = itemView.findViewById(R.id.tvOrderId);
        }
    }
}