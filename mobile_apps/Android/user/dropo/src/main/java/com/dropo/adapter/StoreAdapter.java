package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ToggleButton;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Store;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;

import java.util.ArrayList;

public abstract class StoreAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> implements Filterable {

    private final Context context;
    private final ArrayList<Store> filterList;
    private final ImageHelper imageHelper;
    private final int storeImageHeight;
    private ArrayList<Store> storeList;
    private StoreFilter storeFilter;
    private String filterBy;
    private int storeImageWidth;

    public StoreAdapter(Context context, ArrayList<Store> storeList) {
        this.context = context;
        this.storeList = storeList;
        filterList = new ArrayList<>();
        imageHelper = new ImageHelper(context);
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        storeImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        storeImageWidth = (storeImageWidth - (screenPadding * 4)) / 2;
        storeImageHeight = (int) (storeImageWidth / ImageHelper.ASPECT_RATIO);
    }

    public String getFilterBy() {
        return filterBy;
    }

    public void setFilterBy(String filterBy) {
        this.filterBy = filterBy;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_list, parent, false);
        return new StoreHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        StoreHolder storeHolder = (StoreHolder) holder;
        Store store = storeList.get(position);
        storeHolder.ivStoreImage.getLayoutParams().height = storeImageHeight;
        storeHolder.ivStoreImage.getLayoutParams().width = storeImageWidth;
        storeHolder.storeCard.getLayoutParams().height = storeImageHeight;
        storeHolder.storeCard.getLayoutParams().width = storeImageWidth;
        if (PreferenceHelper.getInstance(context).getIsLoadStoreImage()) {
            GlideApp.with(context)
                    .load(imageHelper.getImageUrlAccordingSize(store.getImageUrl(), storeHolder.ivStoreImage))
                    .addListener(imageHelper.registerGlideLoadFiledListener(storeHolder.ivStoreImage, store.getImageUrl()))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into(storeHolder.ivStoreImage);
        }

        storeHolder.tvStoreName.setText(store.getName());
        storeHolder.tvStoreTags.setText(store.getTags());
        storeHolder.tvStorePricing.setText(store.getPriceRattingTag());
        if (store.getDeliveryTimeMax() > store.getDeliveryTime()) {
            storeHolder.tvStoreApproxTime.setText(String.format("%s %s - %s %s %s", "|", store.getDeliveryTime(), store.getDeliveryTimeMax(), context.getResources().getString(R.string.unit_mins), "|"));
        } else {
            storeHolder.tvStoreApproxTime.setText(String.format("%s %s", store.getDeliveryTime(), context.getResources().getString(R.string.unit_mins)));
        }

        storeHolder.tvStoreRatings.setText(String.valueOf(store.getRate()));

        if (store.isStoreClosed()) {
            storeHolder.llStoreClosed.setVisibility(View.VISIBLE);
            storeHolder.tvTag.setText(context.getResources().getText(R.string.text_store_closed));
            storeHolder.tvStoreReOpenTime.setVisibility(View.VISIBLE);
            storeHolder.tvStoreReOpenTime.setText(store.getReOpenTime());
        } else {
            if (store.isBusy()) {
                storeHolder.llStoreClosed.setVisibility(View.VISIBLE);
                storeHolder.tvTag.setText(context.getResources().getText(R.string.text_store_busy));
                storeHolder.tvStoreReOpenTime.setVisibility(View.GONE);
            } else {
                storeHolder.llStoreClosed.setVisibility(View.GONE);
            }
        }

        if (TextUtils.isEmpty(PreferenceHelper.getInstance(context).getUserId())) {
            storeHolder.ivFavourites.setVisibility(View.GONE);
            storeHolder.flFavourite.setVisibility(View.GONE);
        } else {
            store.setFavourite(CurrentBooking.getInstance().getFavourite().contains(store.getId()));
            storeHolder.ivFavourites.setVisibility(View.VISIBLE);
            storeHolder.flFavourite.setVisibility(View.VISIBLE);
            storeHolder.ivFavourites.setChecked(store.isFavourite());
        }
    }

    @Override
    public int getItemCount() {
        return storeList == null ? 0 : storeList.size();
    }

    @Override
    public Filter getFilter() {
        if (storeFilter == null) {
            storeFilter = new StoreFilter(storeList);
        }
        return storeFilter;
    }

    public ArrayList<Store> getStoreArrayList() {
        return storeList;
    }

    public void setStoreArrayList(ArrayList<Store> storeList) {
        this.storeList = storeList;
        storeFilter = new StoreFilter(this.storeList);
    }

    public abstract void onSelected(View view, int position);

    public abstract void setFavourites(int position, boolean isFavourite);

    protected class StoreHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        ImageView ivStoreImage;
        ToggleButton ivFavourites;
        LinearLayout llStoreClosed;
        CustomFontTextView tvStorePricing, tvStoreTags, tvStoreRatings, tvStoreReOpenTime, tvStoreApproxTime, tvTag;
        CustomFontTextViewTitle tvStoreName;
        CardView storeCard;
        FrameLayout flFavourite;

        public StoreHolder(View itemView) {
            super(itemView);
            llStoreClosed = itemView.findViewById(R.id.llStoreClosed);
            ivStoreImage = itemView.findViewById(R.id.ivStoreImage);
            tvStoreName = itemView.findViewById(R.id.tvStoreName);
            tvStorePricing = itemView.findViewById(R.id.tvStorePricing);
            tvStoreRatings = itemView.findViewById(R.id.tvStoreRatings);
            tvStoreTags = itemView.findViewById(R.id.tvStoreTags);
            tvStoreReOpenTime = itemView.findViewById(R.id.tvStoreReOpenTime);
            tvStoreApproxTime = itemView.findViewById(R.id.tvStoreApproxTime);
            ivFavourites = itemView.findViewById(R.id.ivFavourites);
            itemView.setOnClickListener(this);
            ivFavourites.setOnClickListener(this);
            tvTag = itemView.findViewById(R.id.tvTag);
            storeCard = itemView.findViewById(R.id.storeCard);
            flFavourite = itemView.findViewById(R.id.flFavourite);
            flFavourite.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            int id = v.getId();
            if (id == R.id.flFavourite || id == R.id.ivFavourites) {
                setFavourites(getAbsoluteAdapterPosition(), storeList.get(getAbsoluteAdapterPosition()).isFavourite());
            } else {
                onSelected(v, getAbsoluteAdapterPosition());
            }
        }
    }

    private class StoreFilter extends Filter {
        private final ArrayList<Store> sourceList;

        StoreFilter(ArrayList<Store> storeArrayList) {
            sourceList = new ArrayList<>();
            synchronized (this) {
                sourceList.addAll(storeArrayList);
            }
        }

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String filterSeq = constraint.toString();
            FilterResults result = new FilterResults();
            filterSeq = filterSeq.trim();
            if (filterSeq.length() > 0) {
                filterList.clear();
                if (TextUtils.equals(filterBy, context.getResources().getString(R.string.text_item))) {
                    for (Store store : sourceList) {
                        for (String itemName : store.getProductItemNameList()) {
                            if (itemName.toUpperCase().contains(filterSeq.toUpperCase())) {
                                if (!filterList.contains(store)) {
                                    filterList.add(store);
                                }
                            }
                        }
                    }
                } else if (TextUtils.equals(filterBy, context.getResources().getString(R.string.text_tag))) {
                    for (Store store : sourceList) {
                        for (String tag : store.getFamousProductsTagIds()) {
                            if (tag.toUpperCase().contains(filterSeq.toUpperCase())) {
                                if (!filterList.contains(store)) {
                                    filterList.add(store);
                                }
                            }
                        }
                    }
                } else {
                    for (Store store : sourceList) {
                        if (store.getName().toUpperCase().contains(filterSeq.toUpperCase())) {
                            filterList.add(store);
                        }
                    }
                }


                result.count = filterList.size();
                result.values = filterList;
            } else {
                synchronized (this) {
                    result.values = sourceList;
                    result.count = sourceList.size();
                }
            }
            return result;
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            storeList = (ArrayList<Store>) results.values;
            notifyDataSetChanged();
        }
    }
}