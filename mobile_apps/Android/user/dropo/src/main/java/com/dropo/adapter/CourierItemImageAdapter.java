package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.utils.GlideApp;
import com.dropo.utils.Utils;

import java.util.ArrayList;

public abstract class CourierItemImageAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final ArrayList<String> courierItemImageList;
    private Context context;

    public CourierItemImageAdapter() {
        courierItemImageList = new ArrayList<>();
    }

    public ArrayList<String> getCourierItemImageList() {
        return courierItemImageList;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        return new ItemImageHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_courier_image, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        final ItemImageHolder imageHolder = (ItemImageHolder) holder;
        if (!courierItemImageList.isEmpty()) {
            GlideApp.with(context).load(courierItemImageList.get(position)).into(imageHolder.ivProduct);
        }
        if ((courierItemImageList.size() - 1 == position || courierItemImageList.size() == 0)) {
            if (courierItemImageList.size() == 0) {
                imageHolder.ivProduct.setVisibility(View.GONE);
                imageHolder.itemImageDelete.setVisibility(View.GONE);
            } else {
                imageHolder.ivProduct.setVisibility(View.VISIBLE);
                imageHolder.itemImageDelete.setVisibility(View.VISIBLE);
            }
            if (courierItemImageList.size() >= 3) {
                imageHolder.ivAddImage.setVisibility(View.GONE);
            } else {
                imageHolder.ivAddImage.setVisibility(View.VISIBLE);
            }
        } else {
            imageHolder.ivAddImage.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        if (courierItemImageList.isEmpty()) {
            return 1;
        } else {
            return courierItemImageList.size();
        }
    }

    public abstract void addImage();

    @SuppressLint("NotifyDataSetChanged")
    public void addCourierItemImage(String imagePath) {
        courierItemImageList.add(imagePath);
        notifyDataSetChanged();
    }

    protected class ItemImageHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        ImageView ivProduct, itemImageDelete;
        ImageView ivAddImage;

        public ItemImageHolder(View itemView) {
            super(itemView);
            ivProduct = itemView.findViewById(R.id.ivProduct);
            itemImageDelete = itemView.findViewById(R.id.itemImageDelete);
            itemImageDelete.setImageDrawable(Utils.getLayerDrawableRoundIconFill(context, R.drawable.ic_cross_small));
            ivAddImage = itemView.findViewById(R.id.ivAddImage);
            itemImageDelete.setOnClickListener(this);
            ivAddImage.setOnClickListener(this);
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        public void onClick(View view) {
            int id = view.getId();
            if (id == R.id.itemImageDelete) {
                courierItemImageList.remove(getAbsoluteAdapterPosition());
                notifyDataSetChanged();
            } else if (id == R.id.ivAddImage) {
                addImage();
            }
        }
    }
}