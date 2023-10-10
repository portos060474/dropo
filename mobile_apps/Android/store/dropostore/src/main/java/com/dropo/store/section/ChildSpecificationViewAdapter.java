package com.dropo.store.section;

import android.content.Context;
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

import com.dropo.store.R;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;

import java.util.ArrayList;
import java.util.Locale;

public class ChildSpecificationViewAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<ItemSpecification> itemSpecificationList;
    private final Context context;

    ChildSpecificationViewAdapter(Context context, ArrayList<ItemSpecification> itemSpecificationList) {
        this.context = context;
        this.itemSpecificationList = itemSpecificationList;
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
            String price = PreferenceHelper.getPreferenceHelper(context).getCurrency() + ParseContent.getInstance().decimalTwoDigitFormat.format(itemSpecificationList.get(section).getPrice());
            itemSpecificationHeader.tvSectionSpecificationPrice.setText(price);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemSpecificationFooter itemSpecificationFooter = (ItemSpecificationFooter) holder;
        ProductSpecification productSpecification = itemSpecificationList.get(section).getList().get(relativePosition);
        if (productSpecification.getPrice() > 0) {
            itemSpecificationFooter.tvSubSpecificationPrice.setText(String.format("%s%s", PreferenceHelper.getPreferenceHelper(context).getCurrency(), ParseContent.getInstance().decimalTwoDigitFormat.format(productSpecification.getPrice())));
        }

        itemSpecificationFooter.tvSpecification.setText(productSpecification.getName());
        if (productSpecification.getQuantity() > 1) {
            String name = String.format(Locale.getDefault(), "%s x%d", productSpecification.getName(), productSpecification.getQuantity());
            SpannableStringBuilder finalName = new SpannableStringBuilder(name);
            finalName.setSpan(new StyleSpan(Typeface.BOLD), productSpecification.getName().length(), name.length(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            itemSpecificationFooter.tvSpecification.setText(finalName);
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new ItemSpecificationHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_item_speci_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemSpecificationFooter(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_display_specification, parent, false));
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
        TextView tvSpecification, tvSubSpecificationPrice, tvSequenceNumber;

        public ItemSpecificationFooter(View itemView) {
            super(itemView);
            tvSpecification = itemView.findViewById(R.id.tvSpecification);
            tvSubSpecificationPrice = itemView.findViewById(R.id.tvSubSpecificationPrice);
            tvSequenceNumber = itemView.findViewById(R.id.tvSequenceNumber);
            tvSequenceNumber.setVisibility(View.GONE);
        }
    }
}