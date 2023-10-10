package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;

import java.util.ArrayList;

public abstract class ProductSpecificationItemAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<ItemSpecification> specificationsItems;
    private final Context context;
    private final ParseContent parseContent;

    public ProductSpecificationItemAdapter(Context context, ArrayList<ItemSpecification> specificationsItems) {
        this.context = context;
        this.specificationsItems = specificationsItems;
        parseContent = ParseContent.getInstance();
    }

    @Override
    public int getSectionCount() {
        return specificationsItems.size();
    }

    @Override
    public int getItemCount(int section) {
        return specificationsItems.get(section).getList().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        SpecificationHeaderHolder specificationHeaderHolder = (SpecificationHeaderHolder) holder;
        specificationHeaderHolder.tvSpecificationName.setText(specificationsItems.get(section).getName());
        if ((specificationsItems.get(section).isRequired())) {
            specificationHeaderHolder.tvRequired.setVisibility(View.VISIBLE);
        } else {
            specificationHeaderHolder.tvRequired.setVisibility(View.GONE);
        }
        specificationHeaderHolder.tvChooseUpTo.setText(specificationsItems.get(section).getChooseMessage());
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int section, final int relativePosition, final int absolutePosition) {
        final SpecificationItemHolder specificationItemHolder = (SpecificationItemHolder) holder;
        final ItemSpecification specification = specificationsItems.get(section);
        final ProductSpecification specificationListItem = specification.getList().get(relativePosition);
        if (specificationListItem.getPrice() > 0) {
            final String price = PreferenceHelper.getPreferenceHelper(context).getCurrency() + parseContent.decimalTwoDigitFormat.format(specificationListItem.getPrice());
            specificationItemHolder.tvSpecificationItemPrice.setText(price);
            specificationItemHolder.tvSpecificationItemPrice.setVisibility(View.VISIBLE);
        } else {
            specificationItemHolder.tvSpecificationItemPrice.setVisibility(View.GONE);
        }

        specificationItemHolder.tvSpecificationItemDescription.setText(specificationListItem.getName());
        specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);

        int itemType = specificationsItems.get(section).getType();
        switch (itemType) {
            case Constant.TYPE_SPECIFICATION_SINGLE:
                specificationItemHolder.rbSingleSpecification.setVisibility(View.VISIBLE);
                specificationItemHolder.rbMultipleSpecification.setVisibility(View.GONE);
                specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                specificationItemHolder.rbSingleSpecification.setChecked(specificationListItem.isIsDefaultSelected());
                specificationItemHolder.rbSingleSpecification.setOnClickListener(view -> {
                    specificationListItem.setIsDefaultSelected(true);
                    onSingleItemClick(section, relativePosition, absolutePosition);
                });
                break;
            case Constant.TYPE_SPECIFICATION_MULTIPLE:
                specificationItemHolder.rbSingleSpecification.setVisibility(View.GONE);
                specificationItemHolder.rbMultipleSpecification.setVisibility(View.VISIBLE);
                specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                specificationItemHolder.rbMultipleSpecification.setChecked(specificationListItem.isIsDefaultSelected());
                specificationItemHolder.rbMultipleSpecification.setOnClickListener(view -> {
                    boolean checked = isValidSelection(specification.getRange(), specification.getMaxRange(), specification.getSelectedCount(), specificationListItem.isIsDefaultSelected());
                    if (!specificationListItem.isIsDefaultSelected() && checked) {
                        specification.setSelectedCount(specification.getSelectedCount() + 1);
                        if (specification.isUserCanAddSpecificationQuantity()) {
                            specificationItemHolder.llSpecificationQuantity.setVisibility(View.VISIBLE);
                        }
                    } else if (specificationListItem.isIsDefaultSelected() && !checked) {
                        specification.setSelectedCount(specification.getSelectedCount() - 1);
                        specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                    }
                    if (checked && (specification.getMaxRange() > 0 && specification.getSelectedCount() > specification.getMaxRange())
                            || (specification.getMaxRange() == 0 && specification.getSelectedCount() > specification.getRange())) {
                        for (ProductSpecification specificationSubItem1 : specification.getList()) {
                            if (specificationSubItem1.isIsDefaultSelected()
                                    && !specificationSubItem1.getId().equalsIgnoreCase(specificationListItem.getId())) {
                                specificationSubItem1.setIsDefaultSelected(false);
                                specification.setSelectedCount(specification.getSelectedCount() - 1);
                                notifyDataSetChanged();
                                break;
                            }
                        }
                    }
                    specificationListItem.setQuantity(1);
                    specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationListItem.getQuantity()));
                    specificationListItem.setIsDefaultSelected(checked);
                    specificationItemHolder.rbMultipleSpecification.setChecked(checked);
                    onMultipleItemClick();
                });

                if (specificationListItem.isIsDefaultSelected() && specification.isUserCanAddSpecificationQuantity()) {
                    specificationItemHolder.llSpecificationQuantity.setVisibility(View.VISIBLE);
                }

                specificationItemHolder.btnIncrease.setOnClickListener(v -> {
                    specificationListItem.setQuantity(specificationListItem.getQuantity() + 1);
                    specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationListItem.getQuantity()));
                    onMultipleItemClick();
                });
                specificationItemHolder.btnDecrease.setOnClickListener(v -> {
                    if (specificationListItem.getQuantity() > 1) {
                        specificationListItem.setQuantity(specificationListItem.getQuantity() - 1);
                        specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationListItem.getQuantity()));
                        onMultipleItemClick();
                    }
                });
                specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationListItem.getQuantity()));
                break;
            default:
                break;
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new SpecificationHeaderHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_specification_header, parent, false));
            case VIEW_TYPE_ITEM:
                return new SpecificationItemHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_specification_item, parent, false));
            default:
                break;
        }
        return null;
    }

    public abstract void onSingleItemClick(int section, final int relativePosition, final int absolutePosition);

    public abstract void onMultipleItemClick();

    /**
     * this method return flag according to range selection
     *
     * @param range         range
     * @param maxRange      maxRange
     * @param selectedCount selectedCount
     * @param isSelected    isSelected
     * @return boolean
     */
    private boolean isValidSelection(int range, int maxRange, int selectedCount, boolean isSelected) {
        if (range == 0 && maxRange == 0) {
            return !isSelected;
        } else if (selectedCount <= range && maxRange == 0) {
            //return range != selectedCount && !isSelected;
            return !isSelected;
        } else if (range >= 0 && selectedCount <= maxRange) {
            //return maxRange != selectedCount && !isSelected;
            return !isSelected;
        } else {
            return isSelected;
        }
    }

    protected static class SpecificationHeaderHolder extends RecyclerView.ViewHolder {
        TextView tvSpecificationName;
        TextView tvRequired, tvChooseUpTo;

        public SpecificationHeaderHolder(View itemView) {
            super(itemView);
            tvSpecificationName = itemView.findViewById(R.id.tvSpecificationName);
            tvRequired = itemView.findViewById(R.id.tvRequired);
            tvChooseUpTo = itemView.findViewById(R.id.tvChooseUpTo);
        }
    }

    protected static class SpecificationItemHolder extends RecyclerView.ViewHolder {
        RadioButton rbSingleSpecification;
        CheckBox rbMultipleSpecification;
        TextView tvSpecificationItemDescription, tvSpecificationItemPrice;

        View llSpecificationQuantity, btnDecrease, btnIncrease;
        TextView tvSpecificationQuantity;

        public SpecificationItemHolder(View itemView) {
            super(itemView);
            rbSingleSpecification = itemView.findViewById(R.id.rbSingleSpecification);
            rbMultipleSpecification = itemView.findViewById(R.id.rbMultipleSpecification);
            tvSpecificationItemDescription = itemView.findViewById(R.id.tvSpecificationItemDescription);
            tvSpecificationItemPrice = itemView.findViewById(R.id.tvSpecificationItemPrice);
            llSpecificationQuantity = itemView.findViewById(R.id.llSpecificationQuantity);
            tvSpecificationQuantity = itemView.findViewById(R.id.tvSpecificationQuantity);
            btnDecrease = itemView.findViewById(R.id.btnDecrease);
            btnIncrease = itemView.findViewById(R.id.btnIncrease);
        }
    }
}