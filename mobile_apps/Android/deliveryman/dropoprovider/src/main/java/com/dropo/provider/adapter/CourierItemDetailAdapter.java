package com.dropo.provider.adapter;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.ActiveDeliveryActivity;
import com.dropo.provider.R;
import com.dropo.provider.utils.GlideApp;

import java.util.ArrayList;

public class CourierItemDetailAdapter extends RecyclerView.Adapter<CourierItemDetailAdapter.CourierItemImageHolder> {

    private final ArrayList<String> courierItemDetails;
    private Context context;
    private final ActiveDeliveryActivity activeDeliveryActivity;

    public CourierItemDetailAdapter(ActiveDeliveryActivity activeDeliveryActivity, ArrayList<String> courierItemDetails) {
        this.courierItemDetails = courierItemDetails;
        this.activeDeliveryActivity = activeDeliveryActivity;
    }

    @NonNull
    @Override
    public CourierItemImageHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        return new CourierItemImageHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_courier_detail, parent, false));
    }


    @Override
    public void onBindViewHolder(@NonNull CourierItemImageHolder holder, int position) {
        if (!courierItemDetails.isEmpty()) {
            GlideApp.with(context)
                    .load(IMAGE_URL + courierItemDetails.get(position))
                    .placeholder(R.drawable.placeholder)
                    .into(holder.ivProduct);
        }
    }

    @Override
    public int getItemCount() {
        if (courierItemDetails == null) {
            return 0;
        } else {
            return courierItemDetails.size();
        }
    }

    protected class CourierItemImageHolder extends RecyclerView.ViewHolder {
        ImageView ivProduct;

        public CourierItemImageHolder(View itemView) {
            super(itemView);
            ivProduct = itemView.findViewById(R.id.ivCourier);
            ivProduct.setOnClickListener(v -> activeDeliveryActivity.openDialogCourierItemImage(getAbsoluteAdapterPosition()));
        }
    }
}