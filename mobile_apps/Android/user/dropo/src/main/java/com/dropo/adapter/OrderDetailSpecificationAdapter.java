package com.dropo.adapter;

import android.graphics.Typeface;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.parser.ParseContent;
import com.dropo.utils.SectionedRecyclerViewAdapter;

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
        itemSpecificationHeader.tvSectionSpeci_root.setText(itemSpecificationList.get(section).getName());
        if (itemSpecificationList.get(section).getPrice() > 0) {
            String price = currency + ParseContent.getInstance().decimalTwoDigitFormat.format(itemSpecificationList.get(section).getPrice());
            itemSpecificationHeader.tvSectionSpeciPrice.setText(price);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemSpecificationFooter itemSpecificationFooter = (ItemSpecificationFooter) holder;
        SpecificationSubItem productSpecification = itemSpecificationList.get(section).getList().get(relativePosition);
        if (productSpecification.getPrice() > 0) {
            itemSpecificationFooter.tvSpecPrice.setText(String.format("%s%s", currency, ParseContent.getInstance().decimalTwoDigitFormat.format(productSpecification.getPrice())));
        }

        itemSpecificationFooter.txSpeciName.setText(productSpecification.getName());
        if (productSpecification.getQuantity() > 1) {
            String name = String.format(Locale.getDefault(), "%s x%d", productSpecification.getName(), productSpecification.getQuantity());
            SpannableStringBuilder finalName = new SpannableStringBuilder(name);
            finalName.setSpan(new StyleSpan(Typeface.BOLD), productSpecification.getName().length(), name.length(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            itemSpecificationFooter.txSpeciName.setText(finalName);
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
        CustomFontTextViewTitle tvSectionSpeci_root, tvSectionSpeciPrice;

        public ItemSpecificationHeader(View itemView) {
            super(itemView);
            tvSectionSpeci_root = itemView.findViewById(R.id.tvSectionSpeci);
            tvSectionSpeciPrice = itemView.findViewById(R.id.tvSectionSpeciPrice);
        }
    }

    private static class ItemSpecificationFooter extends RecyclerView.ViewHolder {
        CustomFontTextView txSpeciName, tvSpecPrice;

        public ItemSpecificationFooter(View itemView) {
            super(itemView);
            txSpeciName = itemView.findViewById(R.id.tvSpecifications);
            tvSpecPrice = itemView.findViewById(R.id.tvSubSpeciPrice);
        }
    }
}
