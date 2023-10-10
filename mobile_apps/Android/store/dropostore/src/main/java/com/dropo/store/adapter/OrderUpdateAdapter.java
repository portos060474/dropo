package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.UpdateOrderActivity;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;


import java.util.List;
import java.util.Locale;

public class OrderUpdateAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final List<OrderDetails> cartProductList;
    private final UpdateOrderActivity activity;
    private final ParseContent parseContent;

    public OrderUpdateAdapter(UpdateOrderActivity activity, List<OrderDetails> cartProductList) {
        this.activity = activity;
        this.cartProductList = cartProductList;
        parseContent = ParseContent.getInstance();
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new CartHeaderHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_divider_horizontal, parent, false));
            case VIEW_TYPE_ITEM:
                return new CartHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_cart_product_item, parent, false));
            default:
                break;
        }
        return null;
    }

    @Override
    public int getSectionCount() {
        return cartProductList == null ? 0 : cartProductList.size();
    }

    @Override
    public int getItemCount(int section) {
        return cartProductList.get(section).getItems().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        CartHeaderHolder cartHeaderHolder = (CartHeaderHolder) holder;
        cartHeaderHolder.itemView.setVisibility(View.GONE);
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int section, final int relativePosition, int absolutePosition) {
        CartHolder cartHolder = (CartHolder) holder;
        OrderDetails cartProducts = cartProductList.get(section);
        Item cartProductItems = cartProducts.getItems().get(relativePosition);
        cartHolder.tvCartProductName.setText(cartProductItems.getItemName());
        cartHolder.tvCartProductDescription.setText(cartProductItems.getDetails());
        String price = PreferenceHelper.getPreferenceHelper(activity).getCurrency() + parseContent.decimalTwoDigitFormat.format(cartProductItems.getTotalItemAndSpecificationPrice());
        cartHolder.tvCartProductPricing.setText(price);
        cartHolder.tvItemQuantity.setText(String.valueOf(cartProductItems.getQuantity()));

        StringBuilder strSpecifications = new StringBuilder();
        for (ItemSpecification itemSpecification : cartProductItems.getSpecifications()) {
            for (ProductSpecification productSpecification : itemSpecification.getList()) {
                strSpecifications.append(productSpecification.getName())
                        .append(productSpecification.getQuantity() > 1 ?
                                String.format(Locale.getDefault(), " (%d), ", productSpecification.getQuantity()) : ", ");
            }
        }
        cartHolder.tvSpecifications.setVisibility(View.GONE);
        if (strSpecifications.length() > 0) {
            cartHolder.tvSpecifications.setVisibility(View.VISIBLE);
            cartHolder.tvSpecifications.setText(strSpecifications.substring(0, strSpecifications.toString().lastIndexOf(", ")));
        }

        cartHolder.btnIncrease.setOnClickListener(view -> activity.increaseItemQuantity(cartProductList.get(section).getItems().get(relativePosition)));
        cartHolder.btnDecrease.setOnClickListener(view -> activity.decreaseItemQuantity(cartProductList.get(section).getItems().get(relativePosition)));
        cartHolder.tvRemoveCartItem.setOnClickListener(view -> activity.removeItem(section, relativePosition));
        cartHolder.itemView.setOnClickListener(v -> activity.goToUpdateOrderProductSpecificationActivity(section, relativePosition));
    }


    protected static class CartHolder extends RecyclerView.ViewHolder {
        TextView tvCartProductName, tvCartProductPricing, tvSpecifications,
                tvCartProductDescription, btnDecrease, tvItemQuantity, btnIncrease;
        ImageView tvRemoveCartItem;

        public CartHolder(View itemView) {
            super(itemView);
            tvCartProductName = itemView.findViewById(R.id.tvCartProductName);
            tvCartProductDescription = itemView.findViewById(R.id.tvCartProductDescription);
            tvSpecifications = itemView.findViewById(R.id.tvSpecifications);
            tvCartProductPricing = itemView.findViewById(R.id.tvCartProductPricing);
            btnDecrease = itemView.findViewById(R.id.btnDecrease);
            tvItemQuantity = itemView.findViewById(R.id.tvItemQuantity);
            btnIncrease = itemView.findViewById(R.id.btnIncrease);
            tvRemoveCartItem = itemView.findViewById(R.id.tvRemoveCartItem);
        }
    }

    protected static class CartHeaderHolder extends RecyclerView.ViewHolder {
        public CartHeaderHolder(View itemView) {
            super(itemView);
        }
    }
}
