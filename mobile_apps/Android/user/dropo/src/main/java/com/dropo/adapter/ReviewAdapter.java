package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RatingBar;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontEditTextView;
import com.dropo.component.CustomFontTextView;
import com.dropo.fragments.ReviewFragment;
import com.dropo.models.datamodels.RemainingReview;
import com.dropo.utils.Utils;
import com.google.android.material.textfield.TextInputLayout;

import java.util.List;
import java.util.Locale;
import java.util.Objects;

public abstract class ReviewAdapter extends RecyclerView.Adapter<ReviewAdapter.ReviewHolder> {

    private final List<RemainingReview> storeReview;
    private final ReviewFragment reviewFragment;

    public ReviewAdapter(List<RemainingReview> storeReview, ReviewFragment reviewFragment) {
        this.storeReview = storeReview;
        this.reviewFragment = reviewFragment;
    }

    @NonNull
    @Override
    public ReviewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_review_1, parent, false);
        return new ReviewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ReviewHolder holder, final int position) {

        holder.tvOrderId.setText(String.format(Locale.getDefault(), "%s #%d", reviewFragment.getResources().getString(R.string.text_order_number), storeReview.get(position).getOrderUniqueId()));
        holder.tilReview.setEndIconOnClickListener(view -> {
            if (holder.ratingBarReview.getRating() > 0) {
                onSelect(position, holder.ratingBarReview.getRating(), Objects.requireNonNull(holder.etReview.getText()).toString());
            } else {
                Utils.showToast(reviewFragment.requireContext().getResources().getString(R.string.msg_plz_give_rating), reviewFragment.getContext());
            }
        });

    }

    @Override
    public int getItemCount() {
        return storeReview.size();
    }

    public abstract void onSelect(int position, float rating, String comment);

    protected static class ReviewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvOrderId;
        RatingBar ratingBarReview;
        TextInputLayout tilReview;
        CustomFontEditTextView etReview;

        public ReviewHolder(View itemView) {
            super(itemView);
            ratingBarReview = itemView.findViewById(R.id.ratingBarReview);
            tvOrderId = itemView.findViewById(R.id.tvOrderId);
            tilReview = itemView.findViewById(R.id.tilReview);
            etReview = itemView.findViewById(R.id.etReview);
        }
    }
}