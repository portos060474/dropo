package com.dropo.adapter;

import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.fragments.OrderPreparedFragment;
import com.dropo.utils.GlideApp;

import java.util.ArrayList;


public class CourierItemDetailAdapter extends RecyclerView.Adapter<CourierItemDetailAdapter.CourierItemImageHolder> {

    private final ArrayList<String> courierItemDetails;
    private Context context;
    private final OrderPreparedFragment fragment;

    public CourierItemDetailAdapter(OrderPreparedFragment orderPreparedFragment, ArrayList<String> courierItemDetails) {
        this.fragment = orderPreparedFragment;
        this.courierItemDetails = courierItemDetails;
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

    public ArrayList<String> getImageList() {
        if (courierItemDetails == null) {
            return new ArrayList<>();
        } else {
            return courierItemDetails;
        }
    }

    protected class CourierItemImageHolder extends RecyclerView.ViewHolder {
        ImageView ivProduct;

        public CourierItemImageHolder(View itemView) {
            super(itemView);
            ivProduct = itemView.findViewById(R.id.ivCourier);
            ivProduct.setOnClickListener(v -> fragment.openDialogCourierItemImage(getAbsoluteAdapterPosition()));
        }
    }
}