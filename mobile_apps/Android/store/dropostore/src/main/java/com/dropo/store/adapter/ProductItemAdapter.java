package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.AddItemActivity;
import com.dropo.store.HomeActivity;
import com.dropo.store.ItemDetailActivity;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.CurrentProduct;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ProductItemAdapter extends RecyclerView.Adapter<ProductItemAdapter.ProductItemView> {

    private final String TAG = this.getClass().getSimpleName();
    private final Context context;
    private final ArrayList<Product> productList;
    private final List<Item> items;
    private final int relativePosition;

    public ProductItemAdapter(Context context, ArrayList<Product> productList, ArrayList<Item> items, int relativePosition) {
        this.context = context;
        this.productList = productList;
        this.items = items;
        this.relativePosition = relativePosition;
    }

    @NonNull
    @Override
    public ProductItemView onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view;
        view = LayoutInflater.from(context).inflate(R.layout.item_product_item, parent, false);
        return new ProductItemView(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProductItemView holder, @SuppressLint("RecyclerView") int position) {
        Item item = items.get(position);
        holder.tvItemName.setText(item.getName());
        holder.tvItemDetail.setText(item.getDetails());
        if (item.getPrice() > 0) {
            holder.tvItemPrice.setVisibility(View.VISIBLE);
            holder.tvItemPrice.setText(PreferenceHelper.getPreferenceHelper(context).getCurrency().concat(ParseContent.getInstance().decimalTwoDigitFormat.format(item.getPrice())));
        } else {
            holder.tvItemPrice.setVisibility(View.INVISIBLE);
        }
        holder.switchCompat.setChecked(item.isItemInStock());
        holder.switchCompat.setTag(holder.getAbsoluteAdapterPosition());
        holder.switchCompat.setOnClickListener(view -> isItemInStock(position, holder.switchCompat));
        holder.llSpecificationNum.setOnClickListener(v -> {
            Intent intent = new Intent(context, ItemDetailActivity.class);
            ((HomeActivity) context).itemListFragment.gotoAddItemActivity(intent, item, productList.get(relativePosition).getName(), item.getProductId(), null, false, productList.get(relativePosition).getImageUrl());
        });
        holder.llItem.setOnClickListener(v -> {
            Intent intent = new Intent(context, AddItemActivity.class);
            ((HomeActivity) context).itemListFragment.gotoAddItemActivity(intent, item, productList.get(relativePosition).getName(), item.getProductId(), null, false, productList.get(relativePosition).getImageUrl());
        });
        if (item.isItemInStock()) {
            holder.tvInStock.setText(context.getResources().getString(R.string.text_item_in_stock));
        } else {
            holder.tvInStock.setText(context.getResources().getString(R.string.text_item_out_stock));
        }
    }

    private void isItemInStock(final int section, final SwitchCompat switchCompat) {
        Utilities.showProgressDialog(context);
        final Item item = items.get(section);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.ITEM_ID, item.getId());
        map.put(Constant.IS_ITEM_IN_STOCK, String.valueOf(switchCompat.isChecked()));

        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).isItemInStock(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (response.isSuccessful() && response.body() != null) {
                    if (response.body().isSuccess()) {
                        item.setItemInStock(switchCompat.isChecked());
                        CurrentProduct.getInstance().setProductDataList(productList);
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

    @Override
    public int getItemCount() {
        return items.size();
    }

    public static class ProductItemView extends RecyclerView.ViewHolder {
        TextView tvItemDetail;
        TextView tvInStock;
        SwitchCompat switchCompat;
        LinearLayout llItem;
        LinearLayout llSpecificationNum;
        LinearLayout llStock;
        CustomFontTextViewTitle tvItemName;
        CustomFontTextViewTitle tvItemPrice;

        public ProductItemView(@NonNull View itemView) {
            super(itemView);
            tvItemName = itemView.findViewById(R.id.tvProductName);
            tvItemDetail = itemView.findViewById(R.id.tvProductDescription);
            tvItemPrice = itemView.findViewById(R.id.tvItemPrice);
            tvItemPrice.setVisibility(View.VISIBLE);
            switchCompat = itemView.findViewById(R.id.switchProduct);
            itemView.findViewById(R.id.tvVisibility).setVisibility(View.VISIBLE);
            llSpecificationNum = itemView.findViewById(R.id.llSpec);
            tvInStock = itemView.findViewById(R.id.tvVisibility);
            llItem = itemView.findViewById(R.id.llItem);
            llStock = itemView.findViewById(R.id.llStock);
            llStock.setOnClickListener(null);
        }
    }
}