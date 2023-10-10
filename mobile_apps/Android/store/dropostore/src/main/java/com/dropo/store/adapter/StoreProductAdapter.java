package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.dropo.store.R;
import com.dropo.store.StoreOrderProductActivity;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.GlideApp;
import com.dropo.store.utils.ImageHelper;
import com.dropo.store.utils.PinnedHeaderItemDecoration;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;
import com.dropo.store.widgets.CustomTextView;

import java.util.ArrayList;
import java.util.List;

public class StoreProductAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> implements Filterable, PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final ArrayList<Product> filterList;
    private final StoreOrderProductActivity storeProductActivity;
    private final ParseContent parseContent;
    private final List<Item> itemsItemFilter;
    private final FilterResult filterResult;
    private final ImageHelper imageHelper;
    private ArrayList<Product> storeProductList;
    private StoreItemFilter filter;

    public StoreProductAdapter(StoreOrderProductActivity storeProductActivity, ArrayList<Product> storeProductList, @NonNull FilterResult filterResult) {
        this.storeProductList = storeProductList;
        this.storeProductActivity = storeProductActivity;
        parseContent = ParseContent.getInstance();
        itemsItemFilter = new ArrayList<>();
        filterList = new ArrayList<>();
        this.filterResult = filterResult;
        imageHelper = new ImageHelper(storeProductActivity);
    }

    @Override
    public int getSectionCount() {
        return storeProductList.size();
    }

    @Override
    public int getItemCount(int section) {
        return storeProductList.get(section).getItems().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        StoreProductHeaderHolder storeProductHeaderHolder = (StoreProductHeaderHolder) holder;
        storeProductHeaderHolder.tvStoreProductName.setText(storeProductList.get(section).getName());
        storeProductHeaderHolder.itemView.setVisibility(View.VISIBLE);
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, final int section, int relativePosition, int absolutePosition) {
        final StoreProductItemHolder storeProductItemHolder = (StoreProductItemHolder) holder;
        List<Item> productItemsItemList = storeProductList.get(section).getItems();
        final Item productsItem = productItemsItemList.get(relativePosition);

        if (productsItem.getImageUrl() != null && !productsItem.getImageUrl().isEmpty()) {
            GlideApp.with(storeProductActivity)
                    .load(imageHelper.getImageUrlAccordingSize(productsItem.getImageUrl().get(0), storeProductItemHolder.ivProductImage))
                    .dontAnimate()
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            storeProductItemHolder.ivProductImage.setVisibility(View.GONE);
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            storeProductItemHolder.ivProductImage.setVisibility(View.VISIBLE);
                            return false;
                        }
                    }).into(storeProductItemHolder.ivProductImage);
        }
        storeProductItemHolder.tvProductName.setText(productsItem.getName());
        storeProductItemHolder.tvProductDescription.setText(String.valueOf(productsItem.getDetails()));
        if (productsItem.getPrice() > 0) {
            String price = PreferenceHelper.getPreferenceHelper(storeProductActivity).getCurrency() + parseContent.decimalTwoDigitFormat.format(productsItem.getPrice());
            storeProductItemHolder.tvProductPricing.setText(price);
            storeProductItemHolder.tvProductPricing.setVisibility(View.VISIBLE);
        } else {
            double price = calculateProductPrice(productsItem.getSpecifications());
            storeProductItemHolder.tvProductPricing.setText(String.format("%s%s", PreferenceHelper.getPreferenceHelper(storeProductActivity).getCurrency(), parseContent.decimalTwoDigitFormat.format(price)));
            storeProductItemHolder.tvProductPricing.setVisibility(View.VISIBLE);
        }
        holder.itemView.setOnClickListener(view -> storeProductActivity.goToSpecificationActivity(storeProductList.get(section), productsItem));
        ViewGroup.LayoutParams layoutParams = holder.itemView.getLayoutParams();
        if (productsItem.isItemInStock()) {
            layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
            holder.itemView.setVisibility(View.VISIBLE);
        } else {
            layoutParams.height = 0;
            holder.itemView.setVisibility(View.GONE);
        }
        holder.itemView.setLayoutParams(layoutParams);
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new StoreProductHeaderHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_item_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new StoreProductItemHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_product_item, parent, false));
            default:
                break;
        }
        return null;
    }

    @Override
    public Filter getFilter() {
        if (filter == null) filter = new StoreItemFilter(storeProductList);
        return filter;
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == VIEW_TYPE_HEADER;
    }

    public interface FilterResult {
        void onFilter(ArrayList<Product> products);
    }

    protected static class StoreProductHeaderHolder extends RecyclerView.ViewHolder {
        CustomTextView tvStoreProductName;

        public StoreProductHeaderHolder(View itemView) {
            super(itemView);
            tvStoreProductName = itemView.findViewById(R.id.tvSection);
        }
    }

    protected static class StoreProductItemHolder extends RecyclerView.ViewHolder {
        ImageView ivProductImage;
        TextView tvProductName, tvProductPricing;
        TextView tvProductDescription;

        public StoreProductItemHolder(View itemView) {
            super(itemView);
            ivProductImage = itemView.findViewById(R.id.ivProductImage);
            tvProductName = itemView.findViewById(R.id.tvProductName);
            tvProductDescription = itemView.findViewById(R.id.tvProductDescription);
            tvProductPricing = itemView.findViewById(R.id.tvProductPricing);
        }
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
            storeProductList = (ArrayList<Product>) results.values;
            notifyDataSetChanged();
            filterResult.onFilter(storeProductList);
        }
    }

    private double calculateProductPrice(List<ItemSpecification> mainSpecificationList) {
        List<ItemSpecification> specificationsList = new ArrayList<>();

        for (ItemSpecification specifications : mainSpecificationList) {
            if (!specifications.isAssociated()) {
                specificationsList.add(specifications);
            }
        }

        ArrayList<String> itemIds = new ArrayList<>();
        for (ItemSpecification specifications : specificationsList) {
            itemIds.add(specifications.getId());
        }

        ArrayList<ProductSpecification> selectedSpecificationsList = new ArrayList<>();
        for (ItemSpecification specifications : specificationsList) {
            for (ProductSpecification specificationSubItem : specifications.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    selectedSpecificationsList.add(specificationSubItem);
                }
            }
        }

        for (ItemSpecification objMain : mainSpecificationList) {
            for (ProductSpecification obj : selectedSpecificationsList) {
                if (obj.getId().equalsIgnoreCase(objMain.getModifierId()) && !itemIds.contains(objMain.getId())) {
                    specificationsList.add(objMain);
                } else if (obj.getId().equalsIgnoreCase(objMain.getModifierId()) && itemIds.contains(objMain.getId())) {
                    int index = -1;
                    for (int i = 0; i < specificationsList.size(); i++) {
                        if (specificationsList.get(i).getId().equalsIgnoreCase(objMain.getId())) {
                            index = i;
                            break;
                        }
                    }
                    if (index >= 0) {
                        specificationsList.remove(index);
                        specificationsList.add(index, objMain);
                    }
                }
            }
        }

        double price = 0;
        for (ItemSpecification specifications : specificationsList) {
            for (ProductSpecification listItem : specifications.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    price = price + listItem.getPrice();
                }
            }
        }
        return price;
    }
}