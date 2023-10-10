package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontCheckBox;
import com.dropo.component.CustomFontTextView;
import com.dropo.models.datamodels.Product;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class ProductFilterAdapter extends RecyclerView.Adapter<ProductFilterAdapter.ProductFilterViewHolder> {
    private final ArrayList<Product> storeProductList;

    public ProductFilterAdapter(ArrayList<Product> storeProductList) {
        this.storeProductList = storeProductList;
    }

    @NotNull
    @Override
    public ProductFilterViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        return new ProductFilterViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_product_filter, parent, false));
    }

    @Override
    public void onBindViewHolder(ProductFilterViewHolder holder, int position) {
        holder.tvProductNameFilter.setText(storeProductList.get(position).getProductDetail().getName());
        holder.rbSelectProductFilter.setChecked(storeProductList.get(position).isProductFiltered());
    }

    @Override
    public int getItemCount() {
        return storeProductList == null ? 0 : storeProductList.size();
    }

    protected class ProductFilterViewHolder extends RecyclerView.ViewHolder {
        private final CustomFontTextView tvProductNameFilter;
        private final CustomFontCheckBox rbSelectProductFilter;

        public ProductFilterViewHolder(View itemView) {
            super(itemView);
            tvProductNameFilter = itemView.findViewById(R.id.tvProductNameFilter);
            rbSelectProductFilter = itemView.findViewById(R.id.rbSelectProductFilter);
            rbSelectProductFilter.setOnCheckedChangeListener((buttonView, isChecked) -> storeProductList.get(getAbsoluteAdapterPosition()).setProductFiltered(isChecked));
        }
    }
}
