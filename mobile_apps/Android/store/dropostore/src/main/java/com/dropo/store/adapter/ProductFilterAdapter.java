package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.widgets.CustomTextView;

import java.util.ArrayList;

public class ProductFilterAdapter extends RecyclerView.Adapter<ProductFilterAdapter.ProductFilterViewHolder> {

    private final ArrayList<Product> storeProductList;

    public ProductFilterAdapter(ArrayList<Product> storeProductList) {
        this.storeProductList = storeProductList;
    }

    @NonNull
    @Override
    public ProductFilterViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new ProductFilterViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_product_filter, parent, false));
    }

    @Override
    public void onBindViewHolder(ProductFilterViewHolder holder, int position) {
        holder.tvProductNameFilter.setText(storeProductList.get(position).getName());
        holder.rbSelectProductFilter.setChecked(storeProductList.get(position).isProductFiltered());
    }

    @Override
    public int getItemCount() {
        return storeProductList.size();
    }

    protected class ProductFilterViewHolder extends RecyclerView.ViewHolder {
        private final CustomTextView tvProductNameFilter;
        private final CheckBox rbSelectProductFilter;

        public ProductFilterViewHolder(View itemView) {
            super(itemView);
            tvProductNameFilter = itemView.findViewById(R.id.tvProductNameFilter);
            rbSelectProductFilter = itemView.findViewById(R.id.rbSelectProductFilter);
            rbSelectProductFilter.setOnCheckedChangeListener((buttonView, isChecked) -> storeProductList.get(getAbsoluteAdapterPosition()).setProductFiltered(isChecked));
        }
    }
}