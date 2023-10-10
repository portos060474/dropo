package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Product;


import java.util.Collections;
import java.util.List;

public class ProductsAdapter extends RecyclerView.Adapter<ProductsAdapter.ViewHolder> {

    private List<Product> products;

    public ProductsAdapter(List<Product> products) {
        this.products = products;
        Collections.sort(products);
    }

    public void setProducts(List<Product> products) {
        this.products = products;
        Collections.sort(products);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_product, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull final ViewHolder holder, final int position) {
        holder.tvProductName.setText(products.get(position).getName());
        holder.cbProduct.setChecked(products.get(position).isSelected());
        holder.cbProduct.setOnClickListener(v -> {
            holder.cbProduct.setChecked(!products.get(holder.getAbsoluteAdapterPosition()).isSelected());
            products.get(holder.getAbsoluteAdapterPosition()).setSelected(holder.cbProduct.isChecked());
        });
    }


    @Override
    public int getItemCount() {
        return products.size();
    }

    protected static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvProductName;
        CheckBox cbProduct;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            tvProductName = itemView.findViewById(R.id.tvProductName);
            cbProduct = itemView.findViewById(R.id.cbProduct);
        }
    }
}