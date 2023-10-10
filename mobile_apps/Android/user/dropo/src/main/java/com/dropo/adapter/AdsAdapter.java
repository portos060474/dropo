package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.Ads;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;

import java.util.List;

public abstract class AdsAdapter extends RecyclerView.Adapter<AdsAdapter.AdsViewHolder> {

    private final List<Ads> ads;
    private final Context context;
    private final ImageHelper imageHelper;
    private final int adsImageHeight;
    private int adsImageWidth;

    public AdsAdapter(Context context, List<Ads> ads) {
        this.ads = ads;
        this.context = context;
        this.imageHelper = new ImageHelper(context);
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        adsImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        adsImageWidth = (int) ((adsImageWidth - (screenPadding)) / 2.5);
        adsImageHeight = (int) (adsImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public AdsViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_ads, parent, false);
        return new AdsViewHolder(view);
    }

    @Override
    public void onBindViewHolder(AdsViewHolder holder, int position) {
        holder.ivAddImage.getLayoutParams().height = adsImageHeight;
        holder.ivAddImage.getLayoutParams().width = adsImageWidth;
        GlideApp.with(context)
                .load(imageHelper.getImageUrlAccordingSize(ads.get(position).getImageUrl(), holder.ivAddImage))
                .dontAnimate()
                .placeholder(R.drawable.img_placeholder_ads)
                .fallback(R.drawable.img_placeholder_ads)
                .into(holder.ivAddImage);
    }

    @Override
    public int getItemCount() {
        return ads == null ? 0 : ads.size();
    }

    public abstract void onAddClick(Ads ads);

    public class AdsViewHolder extends RecyclerView.ViewHolder {
        ImageView ivAddImage;

        public AdsViewHolder(View itemView) {
            super(itemView);
            ivAddImage = itemView.findViewById(R.id.ivAddImage);
            itemView.setOnClickListener(view -> onAddClick(ads.get(getAbsoluteAdapterPosition())));

        }
    }
}