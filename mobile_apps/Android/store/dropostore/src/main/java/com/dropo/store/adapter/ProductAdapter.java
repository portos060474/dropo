package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.HomeActivity;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Product;

import java.util.ArrayList;
import java.util.List;

public class ProductAdapter extends RecyclerView.Adapter<ProductAdapter.ProductView> implements Filterable {

    private final Context context;
    private final List<Item> itemsItemFilter;
    private ArrayList<Product> filterList;
    private ArrayList<Product> productList;
    private final RecyclerView.RecycledViewPool viewPool = new RecyclerView.RecycledViewPool();
    private StoreItemFilter storeItemFilter;

    public ProductAdapter(Context context, ArrayList<Product> productList) {
        this.context = context;
        this.productList = productList;
        this.filterList = new ArrayList<>(productList);
        this.itemsItemFilter = new ArrayList<>();
    }

    public void setProductList(ArrayList<Product> productList) {
        this.productList = productList;
        this.filterList = new ArrayList<>(productList);
    }

    @NonNull
    @Override
    public ProductView onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_product_section, parent, false);
        return new ProductView(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProductView holder, int position) {
        Product product = filterList.get(position);
        holder.tvSection.setText(product.getName());
        holder.tvSection.setOnClickListener(v -> ((HomeActivity) context).itemListFragment.gotoEditProductActivity(product));
        if (product.getItems().isEmpty()) {
            holder.llNoItem.setVisibility(View.VISIBLE);
            holder.recyclerItemView.setVisibility(View.GONE);
        } else {
            holder.llNoItem.setVisibility(View.GONE);
            holder.recyclerItemView.setVisibility(View.VISIBLE);
            LinearLayoutManager layoutManager = new LinearLayoutManager(holder.recyclerItemView.getContext(), LinearLayoutManager.VERTICAL, false);
            layoutManager.setInitialPrefetchItemCount(product.getItems().size());
            ProductItemAdapter productItemAdapter = new ProductItemAdapter(context, productList, product.getItems(), holder.getAbsoluteAdapterPosition());
            holder.recyclerItemView.setLayoutManager(layoutManager);
            holder.recyclerItemView.setNestedScrollingEnabled(false);
            holder.recyclerItemView.setAdapter(productItemAdapter);
            holder.recyclerItemView.setRecycledViewPool(viewPool);
        }
    }

    @Override
    public int getItemCount() {
        return filterList.size();
    }

    @Override
    public Filter getFilter() {
        if (storeItemFilter == null) storeItemFilter = new StoreItemFilter(filterList);
        return storeItemFilter;
    }

    private class StoreItemFilter extends Filter {
        private final ArrayList<Product> sourceList;

        StoreItemFilter(ArrayList<Product> storesItemArrayList) {
            sourceList = new ArrayList<>();
            synchronized (this) {
                sourceList.addAll(storesItemArrayList);
            }
        }

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String filterSeq = constraint.toString();
            FilterResults result = new FilterResults();
            filterList.clear();
            for (int i = 0; i < sourceList.size(); i++) {
                itemsItemFilter.clear();
                if (sourceList.get(i).isProductFiltered()) {
                    if (TextUtils.isEmpty(constraint)) {
                        itemsItemFilter.addAll(sourceList.get(i).getItems());
                    } else {
                        for (Item itemsItem : sourceList.get(i).getItems()) {
                            if (itemsItem.getName().toUpperCase().contains(filterSeq.toUpperCase())) {
                                itemsItemFilter.add(itemsItem);
                            }
                        }
                    }

                    if (!itemsItemFilter.isEmpty()) {
                        Product productItem = sourceList.get(i).copy();
                        productItem.getItems().clear();
                        productItem.getItems().addAll(itemsItemFilter);
                        filterList.add(productItem);
                    }
                }
            }
            result.count = filterList.size();
            result.values = filterList;
            return result;
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            productList = (ArrayList<Product>) results.values;
            notifyDataSetChanged();
        }
    }

    public static class ProductView extends RecyclerView.ViewHolder {
        TextView tvSection;
        RecyclerView recyclerItemView;
        CardView llNoItem;

        public ProductView(@NonNull View itemView) {
            super(itemView);
            tvSection = itemView.findViewById(R.id.tvSection);
            recyclerItemView = itemView.findViewById(R.id.recyclerItemView);
            llNoItem = itemView.findViewById(R.id.llNoItem);
        }
    }
}