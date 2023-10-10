package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.ProductGroup;
import com.dropo.utils.AppColor;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;

import java.util.ArrayList;

public abstract class ProductGroupAdapter extends RecyclerView.Adapter<ProductGroupAdapter.CategoryViewHolder> {

    private final ArrayList<ProductGroup> storeProductGroupList;
    private final Context context;
    private final ImageHelper imageHelper;
    private final int categoryImageHeight;
    private int selectedPosition = -1;
    private int categoryImageWidth;

    public ProductGroupAdapter(Context context, ArrayList<ProductGroup> storeProductGroupList) {
        this.context = context;
        this.storeProductGroupList = storeProductGroupList;
        this.imageHelper = new ImageHelper(context);
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        categoryImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        categoryImageWidth = ((categoryImageWidth - (screenPadding * 5)) / 4);
        categoryImageHeight = (int) (categoryImageWidth / ImageHelper.ASPECT_RATIO);
    }

    @NonNull
    @Override
    public CategoryViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new CategoryViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_product_category, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull CategoryViewHolder holder, int position) {
        holder.ivCategory.getLayoutParams().height = categoryImageHeight;
        holder.ivCategory.getLayoutParams().width = categoryImageWidth;

        GlideApp.with(context)
                .load(imageHelper.getImageUrlAccordingSize(storeProductGroupList.get(position).getImageUrl(), holder.ivCategory))
                .addListener(imageHelper.registerGlideLoadFiledListener(holder.ivCategory, storeProductGroupList.get(position).getImageUrl()))
                .dontAnimate().placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                .into(holder.ivCategory);

        holder.tvCategoryName.setText(storeProductGroupList.get(position).getName());
        holder.tvCategoryName.setSelected(true);
        if (selectedPosition == position) {
            holder.tvCategoryName.setTextColor(AppColor.COLOR_THEME);
            holder.tvCategoryName.setFontStyle(context, CustomFontTextView.BOLD);
        } else {
            holder.tvCategoryName.setTextColor(AppColor.getThemeTextColor(context));
            holder.tvCategoryName.setFontStyle(context, CustomFontTextView.NORMAL);
        }
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getItemCount() {
        return storeProductGroupList.size();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setSelectedCategory(int selectedPosition) {
        this.selectedPosition = selectedPosition;
        notifyDataSetChanged();
        onSelect(selectedPosition);
    }

    public abstract void onSelect(int selectedPosition);

    protected class CategoryViewHolder extends RecyclerView.ViewHolder {
        ImageView ivCategory;
        CustomFontTextView tvCategoryName;

        public CategoryViewHolder(@NonNull View itemView) {
            super(itemView);
            ivCategory = itemView.findViewById(R.id.ivCategory);
            tvCategoryName = itemView.findViewById(R.id.tvCategoryName);
            itemView.setOnClickListener(v -> setSelectedCategory(getAbsoluteAdapterPosition()));
        }
    }
}