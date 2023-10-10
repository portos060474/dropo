package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.AddProductActivity;
import com.dropo.store.ProductListActivity;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Utilities;


import java.util.ArrayList;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductListAdapter extends RecyclerView.Adapter<ProductListAdapter.ViewHolder> implements CompoundButton.OnCheckedChangeListener {

    private final String TAG = this.getClass().getSimpleName();
    private final Context context;
    private final ArrayList<Product> productList;

    public ProductListAdapter(Context context, ArrayList<Product> productList) {
        this.context = context;
        this.productList = productList;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.adapter_product_list, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        Product product = productList.get(position);
        holder.tvProductName.setText(product.getName());
        holder.tvProductDescription.setText(product.getDetails());
        if (product.getSpecificationsDetails().size() == 0) {
            holder.tvSpecification.setText(context.getResources().getString(R.string.text_no_specification));
        } else {
            holder.tvSpecification.setText(String.valueOf(context.getResources().getString(R.string.text_specification)));
        }
        holder.switchProduct.setOnCheckedChangeListener(null);
        if (product.isIsVisibleInStore()) {
            holder.switchProduct.setChecked(true);
            holder.tvVisibility.setText(context.getResources().getString(R.string.text_visible));
        } else {
            holder.switchProduct.setChecked(false);
            holder.tvVisibility.setText(context.getResources().getString(R.string.text_invisible));
        }
        holder.switchProduct.setOnCheckedChangeListener(this);
        holder.switchProduct.setTag(position);
        holder.llProductItem.setTag(position);

        holder.llProductItem.setOnClickListener(v -> {
            Intent intent = new Intent(context, AddProductActivity.class);
            ((ProductListActivity) context).gotoProductDetail(intent, holder.getAbsoluteAdapterPosition());
        });

        if (productList.size() - 1 == position) {
            holder.llBlank.setVisibility(View.VISIBLE);
        } else {
            holder.llBlank.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return productList.size();
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

        if (buttonView instanceof SwitchCompat) {
            SwitchCompat switchCompat = (SwitchCompat) buttonView;
            try {
                if (switchCompat.getTag() != null) {
                    updateProduct((int) switchCompat.getTag(), switchCompat);
                }
            } catch (NullPointerException e) {
                Utilities.handleThrowable(TAG, e);
            }
        }
    }

    private void updateProduct(final int position, final SwitchCompat switchCompat) {
        final Product product = productList.get(position);
        Utilities.showProgressDialog(context);

        Call<IsSuccessResponse> call = ((ProductListActivity) context).getUpdateProductCall(product, switchCompat.isChecked());
        call.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        product.setIsVisibleInStore(switchCompat.isChecked());
                        notifyDataSetChanged();
                    } else {
                        switchCompat.toggle();
                        ParseContent.getInstance().showErrorMessage(context, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), context);
                }
                Utilities.removeProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    class ViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvProductName;
        private final TextView tvProductDescription;
        private final TextView tvSpecification;
        private final TextView tvVisibility;
        private final SwitchCompat switchProduct;
        private final LinearLayout llProductItem;
        private final View llBlank;

        ViewHolder(View itemView) {
            super(itemView);
            tvProductName = itemView.findViewById(R.id.tvProductName);
            tvSpecification = itemView.findViewById(R.id.tvSpecificationNum);
            tvProductDescription = itemView.findViewById(R.id.tvProductDescription);
            tvVisibility = itemView.findViewById(R.id.tvVisibility);
            switchProduct = itemView.findViewById(R.id.switchProduct);
            llProductItem = itemView.findViewById(R.id.llProductItem);
            switchProduct.setOnCheckedChangeListener(ProductListAdapter.this);
            llBlank = itemView.findViewById(R.id.llBlank);
        }
    }
}