package com.dropo.provider.adapter;

import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.models.datamodels.SpecificationSubItem;
import com.dropo.provider.models.datamodels.Specifications;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.SectionedRecyclerViewAdapter;

import java.util.List;
import java.util.Locale;

public class OrderDetailSpecificationAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final List<Specifications> itemSpecificationList;
    private final String currency;

    OrderDetailSpecificationAdapter(List<Specifications> itemSpecificationList, String currency) {
        this.itemSpecificationList = itemSpecificationList;
        this.currency = currency;
    }

    @Override
    public int getSectionCount() {
        return itemSpecificationList.size();
    }

    @Override
    public int getItemCount(int section) {
        return itemSpecificationList.get(section).getList().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        ItemSpecificationHeader itemSpecificationHeader = (ItemSpecificationHeader) holder;
        itemSpecificationHeader.tvSectionSpecification.setText(itemSpecificationList.get(section).getName());

        if (itemSpecificationList.get(section).getPrice() > 0) {
            String price = currency + ParseContent.getInstance().decimalTwoDigitFormat.format(itemSpecificationList.get(section).getPrice());
            itemSpecificationHeader.tvSectionSpecificationPrice.setText(price);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemSpecificationFooter itemSpecificationFooter = (ItemSpecificationFooter) holder;
        SpecificationSubItem productSpecification = itemSpecificationList.get(section).getList().get(relativePosition);
        if (productSpecification.getPrice() > 0) {
            itemSpecificationFooter.tvSubSpecificationPrice.setText(String.format("%s%s", currency, ParseContent.getInstance().decimalTwoDigitFormat.format(productSpecification.getPrice())));
        }

        itemSpecificationFooter.txSpecificationName.setText(productSpecification.getName());
        if (productSpecification.getQuantity() > 1) {
            String name = String.format(Locale.getDefault(), "%s x%d", productSpecification.getName(), productSpecification.getQuantity());
            SpannableStringBuilder finalName = new SpannableStringBuilder(name);
            finalName.setSpan(new StyleSpan(Typeface.BOLD), productSpecification.getName().length(), name.length(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            itemSpecificationFooter.txSpecificationName.setText(finalName);
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new ItemSpecificationHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_specification_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemSpecificationFooter(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_specification_item, parent, false));
        }

        return null;
    }

    protected static class ItemSpecificationHeader extends RecyclerView.ViewHolder {
        TextView tvSectionSpecification, tvSectionSpecificationPrice;

        public ItemSpecificationHeader(View itemView) {
            super(itemView);
            tvSectionSpecification = itemView.findViewById(R.id.tvSectionSpecification);
            tvSectionSpecificationPrice = itemView.findViewById(R.id.tvSectionSpecificationPrice);
        }
    }

    private static class ItemSpecificationFooter extends RecyclerView.ViewHolder {
        TextView txSpecificationName, tvSubSpecificationPrice;

        public ItemSpecificationFooter(View itemView) {
            super(itemView);
            txSpecificationName = itemView.findViewById(R.id.tvSpecification);
            tvSubSpecificationPrice = itemView.findViewById(R.id.tvSubSpecificationPrice);
        }
    }
}