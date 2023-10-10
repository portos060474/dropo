package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.CartActivity;
import com.dropo.user.R;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.models.datamodels.CartProducts;
import com.dropo.models.datamodels.ProductDetail;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.parser.ParseContent;
import com.dropo.utils.SectionedRecyclerViewAdapter;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.Locale;

public class CartProductAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {
    private final ArrayList<CartProducts> cartProductList;
    private final CartActivity cartActivity;
    private final ParseContent parseContent;

    public CartProductAdapter(CartActivity cartActivity, ArrayList<CartProducts> cartProductList) {
        this.cartActivity = cartActivity;
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
        return cartProductList.size();
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
        CartProducts cartProducts = cartProductList.get(section);
        CartProductItems cartProductItems = cartProducts.getItems().get(relativePosition);
        cartHolder.tvCartProductName.setText(cartProductItems.getItemName());
        cartHolder.tvCartProductDescription.setText(cartProductItems.getDetails());
        final String price = CurrentBooking.getInstance().getCartCurrency() + parseContent.decimalTwoDigitFormat.format(cartProductItems.getTotalItemAndSpecificationPrice());
        cartHolder.tvCartProductPricing.setText(price);
        cartHolder.tvItemQuantity.setText(String.valueOf(cartProductItems.getQuantity()));

        StringBuilder strSpecifications = new StringBuilder();
        for (Specifications specifications : cartProductItems.getSpecifications()) {
            for (SpecificationSubItem specificationSubItem : specifications.getList()) {
                strSpecifications.append(specificationSubItem.getName())
                        .append(specificationSubItem.getQuantity() > 1 ?
                                String.format(Locale.getDefault(), " (%d), ", specificationSubItem.getQuantity()) : ", ");
            }
        }
        cartHolder.tvSpecifications.setVisibility(View.GONE);
        if (strSpecifications.length() > 0) {
            cartHolder.tvSpecifications.setVisibility(View.VISIBLE);
            cartHolder.tvSpecifications.setText(strSpecifications.substring(0, strSpecifications.toString().lastIndexOf(", ")));
        }

        Utils.setLeftBackgroundRtlView(cartActivity, cartHolder.btnIncrease);
        Utils.setRightBackgroundRtlView(cartActivity, cartHolder.btnDecrease);

        cartHolder.btnIncrease.setOnClickListener(view -> cartActivity.increaseItemQuantity(cartProductList.get(section).getItems().get(relativePosition)));
        cartHolder.btnDecrease.setOnClickListener(view -> cartActivity.decreaseItemQuantity(cartProductList.get(section).getItems().get(relativePosition)));
        cartHolder.tvRemoveCartItem.setOnClickListener(view -> cartActivity.removeItem(section, relativePosition));
        cartHolder.itemView.setOnClickListener(v -> {
            ProductDetail productDetail = new ProductDetail();
            productDetail.setName(cartProductList.get(section).getProductName());
            productDetail.setUniqueId(cartProductList.get(section).getUniqueId());
            cartActivity.goToProductSpecificationActivity(section, relativePosition, cartProductList.get(section).getItems().get(relativePosition), productDetail);
        });
    }

    protected static class CartHolder extends RecyclerView.ViewHolder {
        private final TextView tvCartProductName, tvCartProductPricing, tvCartProductDescription,
                tvSpecifications, btnDecrease, tvItemQuantity, btnIncrease;
        private final ImageView tvRemoveCartItem;

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