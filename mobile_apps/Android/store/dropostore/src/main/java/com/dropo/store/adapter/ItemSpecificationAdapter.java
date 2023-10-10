package com.dropo.store.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.RecyclerView.ViewHolder;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;


import java.util.ArrayList;

public class ItemSpecificationAdapter extends SectionedRecyclerViewAdapter<ViewHolder> {

    private final Context context;
    private final ArrayList<ItemSpecification> itemSpecifications;

    public ItemSpecificationAdapter(Context context, ArrayList<ItemSpecification> itemSpecifications) {
        this.context = context;
        this.itemSpecifications = itemSpecifications;
    }


    @Override
    public int getSectionCount() {
        return itemSpecifications.size();
    }

    @Override
    public int getItemCount(int section) {
        return itemSpecifications.get(section).getList().size();
    }

    @Override
    public void onBindHeaderViewHolder(ViewHolder holder, int section) {
        SectionViewHolder sectionViewHolder = (SectionViewHolder) holder;
        ItemSpecification itemSpecification = itemSpecifications.get(section);
        sectionViewHolder.tvSectionName.setText(itemSpecification.getName());
        if (!TextUtils.isEmpty(itemSpecification.getModifierGroupName()) && !TextUtils.isEmpty(itemSpecification.getModifierName())) {
            String displayName = String.format("%s (%s - %s)", itemSpecification.getName(),
                    itemSpecification.getModifierGroupName(), itemSpecification.getModifierName());
            sectionViewHolder.tvSectionName.setText(displayName);
        }
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ContentViewHolder contentViewHolder = (ContentViewHolder) holder;
        ProductSpecification productSpecification = itemSpecifications.get(section).getList().get(relativePosition);
        contentViewHolder.tvSubSpecificationName.setText(productSpecification.getName());
        if (productSpecification.getPrice() > 0) {
            contentViewHolder.tvSubSpecificationPrice.setText(PreferenceHelper.getPreferenceHelper(context).getCurrency().concat(ParseContent.getInstance().decimalTwoDigitFormat.format(productSpecification.getPrice())));
        }
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view;
        if (viewType == VIEW_TYPE_ITEM) {
            view = LayoutInflater.from(context).inflate(R.layout.adapter_display_specification, parent, false);
            return new ContentViewHolder(view);
        } else if (viewType == VIEW_TYPE_HEADER) {
            view = LayoutInflater.from(context).inflate(R.layout.adapter_item_speci_section, parent, false);
            return new SectionViewHolder(view);
        }
        return null;
    }

    private static class SectionViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvSectionName;

        private SectionViewHolder(View itemView) {
            super(itemView);

            tvSectionName = itemView.findViewById(R.id.tvSectionSpecification);
        }
    }

    private static class ContentViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvSubSpecificationName;
        private final TextView tvSubSpecificationPrice;
        private final TextView tvSequenceNumber;

        private ContentViewHolder(View itemView) {
            super(itemView);

            tvSubSpecificationName = itemView.findViewById(R.id.tvSpecification);
            tvSubSpecificationPrice = itemView.findViewById(R.id.tvSubSpecificationPrice);
            tvSequenceNumber = itemView.findViewById(R.id.tvSequenceNumber);
            tvSequenceNumber.setVisibility(View.GONE);
            tvSubSpecificationPrice.setVisibility(View.VISIBLE);
        }
    }
}
