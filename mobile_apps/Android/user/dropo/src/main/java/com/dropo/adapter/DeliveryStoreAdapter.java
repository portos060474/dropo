package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.Deliveries;
import com.dropo.utils.AppColor;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public abstract class DeliveryStoreAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private final ArrayList<Deliveries> deliveryStoreList;
    private final Context context;
    private final ImageHelper imageHelper;
    private final int deliveryImageHeight;
    public String TAG = this.getClass().getSimpleName();
    private int deliveryImageWidth;
    private int selectedPosition = -1;

    public DeliveryStoreAdapter(Context context, ArrayList<Deliveries> deliveryStoreList) {
        imageHelper = new ImageHelper(context);
        this.context = context;
        this.deliveryStoreList = deliveryStoreList;
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        deliveryImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        deliveryImageWidth = (int) ((deliveryImageWidth - (screenPadding * 3)) / 3.5);
        deliveryImageHeight = (int) (deliveryImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_delivery_store_list, parent, false);
        return new StoreViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NotNull RecyclerView.ViewHolder holder, int position) {
        StoreViewHolder storeViewHolder = (StoreViewHolder) holder;
        storeViewHolder.llCardDeliveries.getLayoutParams().height = deliveryImageHeight;
        storeViewHolder.llCardDeliveries.getLayoutParams().width = deliveryImageWidth;
        storeViewHolder.ivDeliverySoreIcon.getLayoutParams().height = deliveryImageHeight;
        storeViewHolder.ivDeliverySoreIcon.getLayoutParams().width = deliveryImageWidth;
        Deliveries deliveries = deliveryStoreList.get(position);

        GlideApp.with(context)
                .load(imageHelper.getImageUrlAccordingSize(deliveries.getImageUrl(), storeViewHolder.ivDeliverySoreIcon))
                .dontAnimate().placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .into(storeViewHolder.ivDeliverySoreIcon);

        storeViewHolder.tvDeliveryName.setText(deliveries.getDeliveryName());
        storeViewHolder.tvDeliveryName.setSelected(true);
        if (selectedPosition == position) {
            storeViewHolder.tvDeliveryName.setTextColor(AppColor.COLOR_THEME);
            storeViewHolder.tvDeliveryName.setFontStyle(context, CustomFontTextView.BOLD);
        } else {
            storeViewHolder.tvDeliveryName.setTextColor(AppColor.getThemeTextColor(context));
            storeViewHolder.tvDeliveryName.setFontStyle(context, CustomFontTextView.NORMAL);
        }
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getItemCount() {
        return deliveryStoreList.size();
    }

    public abstract void onSelect(int selectedPosition);

    @SuppressLint("NotifyDataSetChanged")
    public void setSelectedCategory(int selectedPosition) {
        if (deliveryStoreList.get(selectedPosition).getDeliveryType() != Const.DeliveryType.COURIER) {
            this.selectedPosition = selectedPosition;
            notifyDataSetChanged();
        }
        onSelect(selectedPosition);
    }

    protected class StoreViewHolder extends RecyclerView.ViewHolder {
        private final ImageView ivDeliverySoreIcon;
        private final CustomFontTextView tvDeliveryName;
        private final CardView llCardDeliveries;

        public StoreViewHolder(View itemView) {
            super(itemView);
            ivDeliverySoreIcon = itemView.findViewById(R.id.ivDeliverySoreIcon);
            tvDeliveryName = itemView.findViewById(R.id.tvDeliveryName);
            llCardDeliveries = itemView.findViewById(R.id.llCardDeliveries);
            itemView.setOnClickListener(v -> setSelectedCategory(getAbsoluteAdapterPosition()));
        }
    }
}