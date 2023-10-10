package com.dropo.store.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class ProductSelectedDialogAdapter extends RecyclerView.Adapter<ProductSelectedDialogAdapter.MyViewHolder> {

    private final ArrayList<Product> productList;
    private final Context context;

    public ProductSelectedDialogAdapter(Context context, ArrayList<Product> productList) {
        this.context = context;
        this.productList = productList;
    }

    @NonNull
    @Override
    public MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.select_iteam_raw, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(MyViewHolder holder, int position) {
        holder.productName.setText(productList.get(position).getName());
    }

    @Override
    public int getItemCount() {
        return productList.size();
    }

    public static class MyViewHolder extends RecyclerView.ViewHolder {
        CustomTextView productName;

        public MyViewHolder(View itemView) {
            super(itemView);
            productName = itemView.findViewById(R.id.tvItemName_root);
        }
    }
}