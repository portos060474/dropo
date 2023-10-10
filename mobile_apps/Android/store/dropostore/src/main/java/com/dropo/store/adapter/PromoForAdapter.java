package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;


import java.util.ArrayList;

public class PromoForAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<Product> productList;
    private final int selection;
    private final ArrayList<String> promoForList;

    public PromoForAdapter(ArrayList<Product> productList, int selection, ArrayList<String> promoForList) {
        this.productList = productList;
        this.selection = selection;
        this.promoForList = promoForList;
    }

    @Override
    public int getSectionCount() {
        if (Constant.Promo.PROMO_FOR_ITEM == selection) {
            return productList.size();
        } else {
            return 1;
        }
    }

    @Override
    public int getItemCount(int section) {
        if (Constant.Promo.PROMO_FOR_ITEM == selection) {
            return productList.get(section).getItems().size();
        } else {
            return productList.size();
        }
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        PromoForeViewHeaderHolder headerHolder = (PromoForeViewHeaderHolder) holder;
        headerHolder.itemView.setVisibility(View.GONE);
        headerHolder.itemView.getLayoutParams().height = 0;
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        PromoForeViewHolder viewHolder = (PromoForeViewHolder) holder;
        if (Constant.Promo.PROMO_FOR_ITEM == selection) {
            final Item item = productList.get(section).getItems().get(relativePosition);
            viewHolder.tvPromoItem.setText(item.getName());
            viewHolder.rbPromoItem.setChecked(promoForList.contains(item.getId()));
            viewHolder.rbPromoItem.setOnClickListener(v -> {
                if (promoForList.contains(item.getId())) {
                    promoForList.remove(item.getId());
                } else {
                    promoForList.add(item.getId());
                }
            });
        } else {
            final Product product = productList.get(relativePosition);
            viewHolder.tvPromoItem.setText(product.getName());
            viewHolder.rbPromoItem.setChecked(promoForList.contains(product.getId()));
            viewHolder.rbPromoItem.setOnClickListener(v -> {
                if (promoForList.contains(product.getId())) {
                    promoForList.remove(product.getId());
                } else {
                    promoForList.add(product.getId());
                }
            });
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == VIEW_TYPE_ITEM) {
            return new PromoForeViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_promo_for, parent, false));
        } else {
            return new PromoForeViewHeaderHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_promo_for, parent, false));
        }
    }

    protected static class PromoForeViewHolder extends RecyclerView.ViewHolder {
        TextView tvPromoItem;
        CheckBox rbPromoItem;

        public PromoForeViewHolder(View itemView) {
            super(itemView);
            tvPromoItem = itemView.findViewById(R.id.tvPromoItem);
            rbPromoItem = itemView.findViewById(R.id.rbPromoItem);
        }
    }

    protected static class PromoForeViewHeaderHolder extends RecyclerView.ViewHolder {
        public PromoForeViewHeaderHolder(View itemView) {
            super(itemView);
        }
    }
}