package com.dropo.store.adapter;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.store.R;
import com.dropo.store.AddItemActivity;
import com.dropo.store.utils.GlideApp;

import java.util.ArrayList;

public class ItemImageAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final AddItemActivity addItemActivity;
    private final ArrayList<String> itemImageListForAdapter;
    private final ArrayList<String> deleteItemImage;
    private final ArrayList<String> itemImageList;
    private boolean isEnable;

    public ItemImageAdapter(AddItemActivity addItemActivity, ArrayList<String> itemImageListForAdapter, ArrayList<String> deleteItemImage, ArrayList<String> itemImageList) {
        this.addItemActivity = addItemActivity;
        this.itemImageListForAdapter = itemImageListForAdapter;
        this.deleteItemImage = deleteItemImage;
        this.itemImageList = itemImageList;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ItemImageHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_image, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        final ItemImageHolder imageHolder = (ItemImageHolder) holder;
        if (!itemImageListForAdapter.isEmpty()) {
            String imageUrl;
            if (isUrl(itemImageListForAdapter.get(position))) {
                imageUrl = IMAGE_URL + itemImageListForAdapter.get(position);

            } else {
                imageUrl = itemImageListForAdapter.get(position);
            }
            GlideApp.with(addItemActivity).load(imageUrl).dontAnimate().listener(new RequestListener<Drawable>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                    imageHolder.ivProduct.setVisibility(View.GONE);
                    return false;
                }

                @Override
                public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                    imageHolder.ivProduct.setVisibility(View.VISIBLE);
                    return false;
                }
            }).into(imageHolder.ivProduct);
        }
        if (isEnable) {
            imageHolder.itemImageDelete.setVisibility(View.VISIBLE);
        } else {
            imageHolder.itemImageDelete.setVisibility(View.GONE);
        }
        if (isEnable && (itemImageListForAdapter.size() - 1 == position || itemImageListForAdapter.size() == 0)) {
            if (itemImageListForAdapter.size() == 0) {
                imageHolder.ivProduct.setVisibility(View.GONE);
                imageHolder.itemImageDelete.setVisibility(View.GONE);
            } else {
                imageHolder.ivProduct.setVisibility(View.VISIBLE);
                imageHolder.itemImageDelete.setVisibility(View.VISIBLE);
            }
            imageHolder.ivAddImage.setVisibility(View.VISIBLE);
        } else {
            imageHolder.ivAddImage.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        if (itemImageListForAdapter.isEmpty()) {
            return 1;
        } else {
            return itemImageListForAdapter.size();
        }
    }

    private boolean isUrl(String s) {
        String[] split = s.split("/");
        return TextUtils.equals("store_items", split[0]);
    }

    public void setIsEnable(boolean isEnable) {
        this.isEnable = isEnable;
    }

    protected class ItemImageHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        ImageView ivProduct, itemImageDelete, ivAddImage;

        public ItemImageHolder(View itemView) {
            super(itemView);
            ivProduct = itemView.findViewById(R.id.ivProduct);
            itemImageDelete = itemView.findViewById(R.id.itemImageDelete);
            ivAddImage = itemView.findViewById(R.id.ivAddImage);
            itemImageDelete.setOnClickListener(this);
            ivAddImage.setOnClickListener(this);
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        public void onClick(View view) {
            int id = view.getId();
            if (id == R.id.itemImageDelete) {
                if (isEnable) {
                    for (int i = 0; i < itemImageList.size(); i++) {
                        if (itemImageList.get(i).equals(itemImageListForAdapter.get(getAbsoluteAdapterPosition()))) {
                            itemImageList.remove(i);
                            itemImageListForAdapter.remove(getAbsoluteAdapterPosition());
                            notifyDataSetChanged();
                            return;
                        }
                    }
                    deleteItemImage.add(itemImageListForAdapter.get(getAbsoluteAdapterPosition()));
                    itemImageListForAdapter.remove(getAbsoluteAdapterPosition());
                    notifyDataSetChanged();
                }
            } else if (id == R.id.ivAddImage) {
                addItemActivity.addItemImage();
            }
        }
    }
}