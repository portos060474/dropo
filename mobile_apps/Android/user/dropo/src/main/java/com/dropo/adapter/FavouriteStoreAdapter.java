package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.FavouriteStoreActivity;
import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Store;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.List;

public class FavouriteStoreAdapter extends RecyclerView.Adapter<FavouriteStoreAdapter.FavouriteViewHolder> {

    private final List<Store> storeDetail;
    private final FavouriteStoreActivity activity;
    private final int storeImageHeight;
    private final ImageHelper imageHelper;
    private final ArrayList<String> store = new ArrayList<>();
    private int storeImageWidth;

    public FavouriteStoreAdapter(FavouriteStoreActivity activity, List<Store> storeDetail) {
        this.storeDetail = storeDetail;
        this.activity = activity;
        imageHelper = new ImageHelper(activity);
        int screenPadding = activity.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); //
        storeImageWidth = activity.getResources().getDisplayMetrics().widthPixels;
        storeImageWidth = (storeImageWidth - (screenPadding * 4)) / 2;
        storeImageHeight = (int) (storeImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public FavouriteViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_favourite_store, parent, false);
        return new FavouriteViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull FavouriteViewHolder holder, int position) {
        final Store store = storeDetail.get(position);
        holder.ivStoreImage.getLayoutParams().height = storeImageHeight;
        holder.ivStoreImage.getLayoutParams().width = storeImageWidth;
        holder.storeCard.getLayoutParams().height = storeImageHeight;
        holder.storeCard.getLayoutParams().width = storeImageWidth;
        store.setFavourite(true);
        if (PreferenceHelper.getInstance(activity).getIsLoadStoreImage()) {
            GlideApp.with(activity).load(imageHelper.getImageUrlAccordingSize(store.getImageUrl(), holder.ivStoreImage)).dontAnimate().placeholder(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.placeholder, null)).into(holder.ivStoreImage);
            holder.ivStoreImage.setBackground(ResourcesCompat.getDrawable(activity.getResources(), R.drawable.shadow_store_list, null));
        }
        holder.tvStoreName.setText(store.getName());
        holder.tvStoreTags.setText(store.getTags());
        holder.tvStorePricing.setText(store.getPriceRattingTag());

        if (store.getDeliveryTimeMax() > store.getDeliveryTime()) {
            holder.tvStoreApproxTime.setText(String.format("%s-%s %s", store.getDeliveryTime(), store.getDeliveryTimeMax(), activity.getResources().getString(R.string.unit_mins)));
        } else {
            holder.tvStoreApproxTime.setText(String.format("%s %s", store.getDeliveryTime(), activity.getResources().getString(R.string.unit_mins)));
        }
        holder.tvStoreRatings.setText(String.valueOf(store.getRate()));
        if (store.isStoreClosed()) {
            holder.llStoreClosed.setVisibility(View.VISIBLE);
            holder.tvTag.setText(activity.getResources().getText(R.string.text_store_closed));
            holder.tvStoreReOpenTime.setVisibility(View.VISIBLE);
            holder.tvStoreReOpenTime.setText(store.getReOpenTime());
        } else {
            if (store.isBusy()) {
                holder.llStoreClosed.setVisibility(View.VISIBLE);
                holder.tvTag.setText(activity.getResources().getText(R.string.text_store_busy));
                holder.tvStoreReOpenTime.setVisibility(View.GONE);
            } else {
                holder.llStoreClosed.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public int getItemCount() {
        return storeDetail.size();
    }

    public List<String> getStoreRemovedStores() {
        return store;
    }

    public void clearRemovedStores() {
        store.clear();
    }

    protected class FavouriteViewHolder extends RecyclerView.ViewHolder {
        ImageView ivRemoveStore;
        ImageView ivStoreImage;
        LinearLayout llStoreClosed;
        CustomFontTextView tvStorePricing, tvStoreTags, tvStoreRatings, tvStoreReOpenTime, tvStoreApproxTime, tvTag;
        CustomFontTextViewTitle tvStoreName;
        CardView storeCard;

        @SuppressLint("NotifyDataSetChanged")
        public FavouriteViewHolder(View itemView) {
            super(itemView);
            ivRemoveStore = itemView.findViewById(R.id.ivRemoveStore);
            ivRemoveStore.setImageDrawable(Utils.getLayerDrawableRoundIconFill(activity, R.drawable.ic_cross_small));
            ivRemoveStore.setOnClickListener(view -> {
                store.add(storeDetail.get(getAbsoluteAdapterPosition()).getId());
                storeDetail.remove(getAbsoluteAdapterPosition());
                notifyDataSetChanged();
            });
            itemView.setOnClickListener(v -> activity.gotToStoreProductActivity(storeDetail.get(getAbsoluteAdapterPosition())));
            llStoreClosed = itemView.findViewById(R.id.llStoreClosed);
            ivStoreImage = itemView.findViewById(R.id.ivStoreImage);
            tvStoreName = itemView.findViewById(R.id.tvStoreName);
            tvStorePricing = itemView.findViewById(R.id.tvStorePricing);
            tvStoreRatings = itemView.findViewById(R.id.tvStoreRatings);
            tvStoreTags = itemView.findViewById(R.id.tvStoreTags);
            tvStoreReOpenTime = itemView.findViewById(R.id.tvStoreReOpenTime);
            tvStoreApproxTime = itemView.findViewById(R.id.tvStoreApproxTime);
            tvTag = itemView.findViewById(R.id.tvTag);
            storeCard = itemView.findViewById(R.id.storeCard);
        }
    }
}