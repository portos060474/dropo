package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.graphics.Paint;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.StoreProductActivity;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Product;
import com.dropo.models.datamodels.ProductItem;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.parser.ParseContent;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PinnedHeaderItemDecoration;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.SectionedRecyclerViewAdapter;

import java.util.ArrayList;
import java.util.List;

public class StoreProductAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> implements Filterable, PinnedHeaderItemDecoration.PinnedHeaderAdapter {

    private final ArrayList<Product> filterList;
    private final StoreProductActivity storeProductActivity;
    private final ParseContent parseContent;
    private final List<ProductItem> itemsItemFilter;
    private final ImageHelper imageHelper;
    private final int categoryImageHeight;
    private ArrayList<Product> storeProductList;
    private StoreItemFilter filter;
    private int itemImageWidth;
    private final boolean isShowQuantity;

    public StoreProductAdapter(StoreProductActivity storeProductActivity, ArrayList<Product> storeProductList, boolean isShowQuantity) {
        this.storeProductList = storeProductList;
        this.storeProductActivity = storeProductActivity;
        this.isShowQuantity = isShowQuantity;
        parseContent = ParseContent.getInstance();
        itemsItemFilter = new ArrayList<>();
        filterList = new ArrayList<>();
        imageHelper = new ImageHelper(storeProductActivity);
        int screenPadding = storeProductActivity.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        itemImageWidth = storeProductActivity.getResources().getDisplayMetrics().widthPixels;
        itemImageWidth = ((itemImageWidth - (screenPadding * 5)) / 4);
        categoryImageHeight = (int) (itemImageWidth / ImageHelper.ASPECT_RATIO);
    }

    public void setProductList(ArrayList<Product> storeProductList) {
        this.storeProductList = storeProductList;
        filter = null;
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
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, final int section) {
        StoreProductHeaderHolder storeProductHeaderHolder = (StoreProductHeaderHolder) holder;
        storeProductHeaderHolder.tvStoreProductName.setText(storeProductList.get(section).getProductDetail().getName());
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, final int section, int relativePosition, int absolutePosition) {
        final StoreProductItemHolder storeProductItemHolder = (StoreProductItemHolder) holder;
        List<ProductItem> productItemList = storeProductList.get(section).getItems();
        final ProductItem productsItem = productItemList.get(relativePosition);
        productsItem.setCurrency(storeProductActivity.store.getCurrency());

        if (productsItem.getImageUrl() != null && !productsItem.getImageUrl().isEmpty() && PreferenceHelper.getInstance(storeProductActivity).getIsLoadProductImage()) {
            storeProductItemHolder.ivProductImage.getLayoutParams().height = categoryImageHeight;
            storeProductItemHolder.ivProductImage.getLayoutParams().width = itemImageWidth;
            storeProductItemHolder.ivProductImage.setVisibility(View.VISIBLE);
            GlideApp.with(storeProductActivity)
                    .load(imageHelper.getImageUrlAccordingSize(productsItem.getImageUrl().get(0), storeProductItemHolder.ivProductImage))
                    .addListener(imageHelper.registerGlideLoadFiledListener(storeProductItemHolder.ivProductImage, productsItem.getImageUrl().get(0))).dontAnimate().fallback(AppCompatResources.getDrawable(storeProductActivity, R.drawable.placeholder))
                    .placeholder(AppCompatResources.getDrawable(storeProductActivity, R.drawable.placeholder))
                    .into(storeProductItemHolder.ivProductImage);
        } else {
            storeProductItemHolder.ivProductImage.setVisibility(PreferenceHelper.getInstance(storeProductActivity).getIsLoadProductImage() ? View.VISIBLE : View.GONE);
            storeProductItemHolder.ivProductImage.setImageResource(R.drawable.placeholder);
        }
        storeProductItemHolder.tvProductName.setText(productsItem.getName());
        if (TextUtils.isEmpty(productsItem.getDetails())) {
            storeProductItemHolder.tvProductDescription.setVisibility(View.GONE);
        } else {
            storeProductItemHolder.tvProductDescription.setVisibility(View.VISIBLE);
            storeProductItemHolder.tvProductDescription.setText(productsItem.getDetails());
        }
        if (productsItem.getPrice() > 0) {
            String price = storeProductActivity.store.getCurrency() + parseContent.decimalTwoDigitFormat.format(productsItem.getPrice());
            storeProductItemHolder.tvProductPricing.setText(price);
        } else {
            double price = calculateProductPrice(productsItem.getSpecifications());
            storeProductItemHolder.tvProductPricing.setText(String.format("%s%s", storeProductActivity.store.getCurrency(), parseContent.decimalTwoDigitFormat.format(price)));
        }
        storeProductItemHolder.tvProductPricing.setVisibility(View.VISIBLE);

        holder.itemView.setOnClickListener(view -> {
            if (storeProductActivity.currentBooking.isApplication()) {
                storeProductActivity.currentBooking.setApplication(false);
                if (!productsItem.getSpecifications().isEmpty()) {
                    productsItem.setCartItemQuantity(1);
                }
                storeProductActivity.goToProductSpecificationActivity(storeProductList.get(section).getProductDetail(), productsItem, holder.itemView, false);
            }
        });

        if (productsItem.getItemPriceWithoutOffer() > 0) {
            String priceWithOutOffer = storeProductActivity.store.getCurrency() + parseContent.decimalTwoDigitFormat.format(productsItem.getItemPriceWithoutOffer());
            storeProductItemHolder.tvProductPricingWithoutOffer.setText(priceWithOutOffer);
            storeProductItemHolder.tvProductPricingWithoutOffer.setVisibility(View.VISIBLE);
        } else {
            storeProductItemHolder.tvProductPricingWithoutOffer.setVisibility(View.GONE);
        }

        if (productsItem.getSpecifications().isEmpty()) {
            storeProductItemHolder.tvAddItem.setText(storeProductActivity.getResources().getText(R.string.text_add));
        } else {
            storeProductItemHolder.tvAddItem.setText(storeProductActivity.getResources().getText(R.string.text_customize));
            storeProductItemHolder.llItemQuantity.setVisibility(View.GONE);
            storeProductItemHolder.tvAddItem.setVisibility(View.VISIBLE);
        }

        if (isShowQuantity) {
            if (productsItem.getCartItemQuantity() == 0) {
                storeProductItemHolder.llItemQuantity.setVisibility(View.GONE);
                storeProductItemHolder.tvAddItem.setVisibility(View.VISIBLE);
            } else {
                storeProductItemHolder.llItemQuantity.setVisibility(View.VISIBLE);
                storeProductItemHolder.tvAddItem.setVisibility(View.GONE);
                storeProductItemHolder.tvItemQuantity.setText(String.valueOf(productsItem.getCartItemQuantity()));
            }
        }

        storeProductItemHolder.tvAddItem.setOnClickListener(v -> {
            if (productsItem.getSpecifications().isEmpty()) {
                productsItem.setCartItemQuantity(1);
                storeProductActivity.checkValidCartItem(productsItem, storeProductList.get(section).getProductDetail());
            } else {
                if (storeProductActivity.currentBooking.isApplication()) {
                    storeProductActivity.currentBooking.setApplication(false);
                    storeProductActivity.goToProductSpecificationActivity(storeProductList.get(section).getProductDetail(), productsItem, holder.itemView, false);
                }
            }
        });

        storeProductItemHolder.btnIncrease.setOnClickListener(v -> storeProductActivity.increaseItemQuality(productsItem, section, relativePosition));
        storeProductItemHolder.btnDecrease.setOnClickListener(v -> storeProductActivity.decreaseItemQuantity(productsItem, section, relativePosition));
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new StoreProductHeaderHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_product_header, parent, false));
            case VIEW_TYPE_ITEM:
                return new StoreProductItemHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_store_product_item, parent, false));
            default:
                break;
        }
        return null;
    }

    @Override
    public Filter getFilter() {
        if (filter == null) {
            filter = new StoreItemFilter(storeProductList);
        }
        return filter;
    }

    @Override
    public boolean isPinnedViewType(int viewType) {
        return viewType == VIEW_TYPE_HEADER;
    }

    public ArrayList<Product> getStoreProductList() {
        return storeProductList;
    }

    protected static class StoreProductHeaderHolder extends RecyclerView.ViewHolder {
        private final TextView tvStoreProductName;

        public StoreProductHeaderHolder(View itemView) {
            super(itemView);
            tvStoreProductName = itemView.findViewById(R.id.tvStoreProductName);
        }
    }

    protected static class StoreProductItemHolder extends RecyclerView.ViewHolder {
        private final ImageView ivProductImage;
        private final CustomFontTextViewTitle tvProductName, tvProductPricing, tvProductPricingWithoutOffer;
        private final CustomFontTextView tvProductDescription, btnDecrease, tvItemQuantity, btnIncrease, tvAddItem;
        private final LinearLayout llItemQuantity;

        public StoreProductItemHolder(View itemView) {
            super(itemView);
            ivProductImage = itemView.findViewById(R.id.ivProductImage);
            tvProductName = itemView.findViewById(R.id.tvProductName);
            tvProductDescription = itemView.findViewById(R.id.tvProductDescription);
            tvProductPricing = itemView.findViewById(R.id.tvProductPricing);
            tvProductPricingWithoutOffer = itemView.findViewById(R.id.tvProductPricingWithoutOffer);
            llItemQuantity = itemView.findViewById(R.id.llItemQuantity);
            btnDecrease = itemView.findViewById(R.id.btnDecrease);
            btnIncrease = itemView.findViewById(R.id.btnIncrease);
            tvItemQuantity = itemView.findViewById(R.id.tvItemQuantity);
            tvAddItem = itemView.findViewById(R.id.tvAddItem);
            tvProductPricingWithoutOffer.setPaintFlags(tvProductPricingWithoutOffer.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
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
                        for (ProductItem itemsItem : sourceList.get(i).getItems()) {
                            if (itemsItem.getName().toUpperCase().contains(filterSeq.toUpperCase())) {
                                itemsItemFilter.add(itemsItem);
                            }
                        }
                    }
                    if (!itemsItemFilter.isEmpty()) {
                        Product product = sourceList.get(i).copy();
                        product.getItems().clear();
                        product.getItems().addAll(itemsItemFilter);
                        filterList.add(product);
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
        }
    }

    private double calculateProductPrice(List<Specifications> mainSpecificationList) {
        List<Specifications> specificationsList = new ArrayList<>();

        for (Specifications specifications : mainSpecificationList) {
            if (!specifications.isAssociated()) {
                specificationsList.add(specifications);
            }
        }

        ArrayList<String> itemIds = new ArrayList<>();
        for (Specifications specifications : specificationsList) {
            itemIds.add(specifications.getId());
        }

        ArrayList<SpecificationSubItem> selectedSpecificationsList = new ArrayList<>();
        for (Specifications specifications : specificationsList) {
            for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                if (specificationSubItem.isIsDefaultSelected()) {
                    selectedSpecificationsList.add(specificationSubItem);
                }
            }
        }

        for (Specifications objMain : mainSpecificationList) {
            for (SpecificationSubItem obj : selectedSpecificationsList) {
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
        for (Specifications specifications : specificationsList) {
            for (SpecificationSubItem listItem : specifications.getList()) {
                if (listItem.isIsDefaultSelected()) {
                    price = price + listItem.getPrice();
                }
            }
        }
        return price;
    }
}