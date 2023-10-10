package com.dropo.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.PromoCodes;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;

import java.util.List;

public abstract class OffersAdapter extends RecyclerView.Adapter<OffersAdapter.OffersItemHolder> {
    private final Context context;
    private final ImageHelper imageHelper;
    private final int deliveryImageHeight;
    private final List<PromoCodes> promoCodes;
    private int deliveryImageWidth;

    public OffersAdapter(Context context, List<PromoCodes> promoCodes) {
        imageHelper = new ImageHelper(context);
        this.context = context;
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        deliveryImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        deliveryImageWidth = (int) ((deliveryImageWidth - (screenPadding * 3)) / 3.5);
        deliveryImageHeight = (int) (deliveryImageWidth / ImageHelper.ASPECT_RATIO);
        this.promoCodes = promoCodes;
    }

    @NonNull
    @Override
    public OffersItemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_delivery_offers, parent, false);
        return new OffersItemHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull OffersItemHolder holder, int position) {
        PromoCodes promoCode = promoCodes.get(position);
        holder.llCardDeliveriesOffers.getLayoutParams().height = deliveryImageHeight;
        holder.llCardDeliveriesOffers.getLayoutParams().width = deliveryImageWidth;
        holder.ivDeliveryOffers.getLayoutParams().height = deliveryImageHeight;
        holder.ivDeliveryOffers.getLayoutParams().width = deliveryImageWidth;
        GlideApp.with(context)
                .load(imageHelper.getImageUrlAccordingSize(promoCode.getImageUrl(), holder.ivDeliveryOffers))
                .dontAnimate()
                .placeholder(R.drawable.img_placeholder_offer)
                .fallback(R.drawable.img_placeholder_offer)
                .into(holder.ivDeliveryOffers);
    }

    @Override
    public int getItemCount() {
        return promoCodes == null ? 0 : promoCodes.size();
    }

    public abstract void onSelect(int position);

    protected class OffersItemHolder extends RecyclerView.ViewHolder {
        ImageView ivDeliveryOffers;
        CardView llCardDeliveriesOffers;

        public OffersItemHolder(@NonNull View itemView) {
            super(itemView);
            ivDeliveryOffers = itemView.findViewById(R.id.ivDeliveryOffers);
            llCardDeliveriesOffers = itemView.findViewById(R.id.llCardDeliveriesOffers);
            itemView.setOnClickListener(view -> onSelect(getAbsoluteAdapterPosition()));
        }
    }
}