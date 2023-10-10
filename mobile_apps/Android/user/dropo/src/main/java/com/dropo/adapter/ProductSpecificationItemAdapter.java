package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.ProductSpecificationActivity;
import com.dropo.user.R;
import com.dropo.component.CustomFontCheckBox;
import com.dropo.component.CustomFontRadioButton;
import com.dropo.models.datamodels.SpecificationSubItem;
import com.dropo.models.datamodels.Specifications;
import com.dropo.parser.ParseContent;
import com.dropo.utils.Const;
import com.dropo.utils.SectionedRecyclerViewAdapter;

import java.util.ArrayList;

public class ProductSpecificationItemAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<Specifications> specificationsArrayList;
    private final ProductSpecificationActivity productSpecificationActivity;
    private final ParseContent parseContent;

    public ProductSpecificationItemAdapter(ProductSpecificationActivity productSpecificationActivity, ArrayList<Specifications> specificationsArrayList) {
        this.productSpecificationActivity = productSpecificationActivity;
        this.specificationsArrayList = specificationsArrayList;
        parseContent = ParseContent.getInstance();
    }

    @Override
    public int getSectionCount() {
        return specificationsArrayList.size();
    }

    @Override
    public int getItemCount(int section) {
        return specificationsArrayList.get(section).getList().size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        SpecificationHeaderHolder specificationHeaderHolder = (SpecificationHeaderHolder) holder;
        specificationHeaderHolder.tvSpecificationName.setText(specificationsArrayList.get(section).getName());
        Specifications specifications = specificationsArrayList.get(section);
        specificationHeaderHolder.tvRequired.setVisibility(specifications.isRequired() ? View.VISIBLE : View.GONE);
        if (TextUtils.isEmpty(specifications.getChooseMessage())) {
            specificationHeaderHolder.tvChooseUpTo.setVisibility(View.GONE);
        } else {
            specificationHeaderHolder.tvChooseUpTo.setText(specifications.getChooseMessage());
            specificationHeaderHolder.tvChooseUpTo.setVisibility(View.VISIBLE);
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, final int section, final int relativePosition, final int absolutePosition) {
        final SpecificationItemHolder specificationItemHolder = (SpecificationItemHolder) holder;
        final Specifications specification = specificationsArrayList.get(section);
        final SpecificationSubItem specificationSubItem = specification.getList().get(relativePosition);
        if (specificationSubItem.getPrice() > 0) {
            final String price = productSpecificationActivity.productItem.getCurrency() + parseContent.decimalTwoDigitFormat.format(specificationSubItem.getPrice());
            specificationItemHolder.tvSpecificationItemPrice.setText(price);
            specificationItemHolder.tvSpecificationItemPrice.setVisibility(View.VISIBLE);
        } else {
            specificationItemHolder.tvSpecificationItemPrice.setVisibility(View.GONE);
        }

        specificationItemHolder.tvSpecificationItemDescription.setText(specificationSubItem.getName());
        specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);

        int itemType = specificationsArrayList.get(section).getType();
        switch (itemType) {
            case Const.TYPE_SPECIFICATION_SINGLE:
                specificationItemHolder.rbSingleSpecification.setVisibility(View.VISIBLE);
                specificationItemHolder.rbMultipleSpecification.setVisibility(View.GONE);
                specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                specificationItemHolder.rbSingleSpecification.setChecked(specificationSubItem.isIsDefaultSelected());
                specificationItemHolder.rbSingleSpecification.setOnClickListener(view -> {
                    specificationSubItem.setIsDefaultSelected(true);
                    productSpecificationActivity.onSingleItemClick(section, relativePosition);
                });
                break;
            case Const.TYPE_SPECIFICATION_MULTIPLE:
                specificationItemHolder.rbSingleSpecification.setVisibility(View.GONE);
                specificationItemHolder.rbMultipleSpecification.setVisibility(View.VISIBLE);
                specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                specificationItemHolder.rbMultipleSpecification.setChecked(specificationSubItem.isIsDefaultSelected());
                specificationItemHolder.rbMultipleSpecification.setOnClickListener(view -> {
                    boolean checked = isValidSelection(specification.getRange(), specification.getMaxRange(), specification.getSelectedCount(), specificationSubItem.isIsDefaultSelected());
                    if (!specificationSubItem.isIsDefaultSelected() && checked) {
                        specification.setSelectedCount(specification.getSelectedCount() + 1);
                        if (specification.isUserCanAddSpecificationQuantity()) {
                            specificationItemHolder.llSpecificationQuantity.setVisibility(View.VISIBLE);
                        }
                    } else if (specificationSubItem.isIsDefaultSelected() && !checked) {
                        specification.setSelectedCount(specification.getSelectedCount() - 1);
                        specificationItemHolder.llSpecificationQuantity.setVisibility(View.GONE);
                    }
                    if (checked && (specification.getMaxRange() > 0 && specification.getSelectedCount() > specification.getMaxRange())
                            || (specification.getMaxRange() == 0 && specification.getSelectedCount() > specification.getRange())) {
                        for (SpecificationSubItem specificationSubItem1 : specification.getList()) {
                            if (specificationSubItem1.isIsDefaultSelected()
                                    && !specificationSubItem1.getId().equalsIgnoreCase(specificationSubItem.getId())) {
                                specificationSubItem1.setIsDefaultSelected(false);
                                specification.setSelectedCount(specification.getSelectedCount() - 1);
                                notifyDataSetChanged();
                                break;
                            }
                        }
                    }
                    specificationSubItem.setQuantity(1);
                    specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationSubItem.getQuantity()));
                    specificationSubItem.setIsDefaultSelected(checked);
                    specificationItemHolder.rbMultipleSpecification.setChecked(checked);
                    productSpecificationActivity.modifyTotalItemAmount();
                });

                if (specificationSubItem.isIsDefaultSelected() && specification.isUserCanAddSpecificationQuantity()) {
                    //specificationItemHolder.llSpecificationQuantity.setVisibility(specificationSubItem.getPrice() > 0 ? View.VISIBLE : View.GONE);
                    specificationItemHolder.llSpecificationQuantity.setVisibility(View.VISIBLE);
                }

                specificationItemHolder.btnIncrease.setOnClickListener(v -> {
                    specificationSubItem.setQuantity(specificationSubItem.getQuantity() + 1);
                    specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationSubItem.getQuantity()));
                    productSpecificationActivity.modifyTotalItemAmount();
                });
                specificationItemHolder.btnDecrease.setOnClickListener(v -> {
                    if (specificationSubItem.getQuantity() > 1) {
                        specificationSubItem.setQuantity(specificationSubItem.getQuantity() - 1);
                        specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationSubItem.getQuantity()));
                        productSpecificationActivity.modifyTotalItemAmount();
                    }
                });
                specificationItemHolder.tvSpecificationQuantity.setText(String.valueOf(specificationSubItem.getQuantity()));
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
        CustomFontRadioButton rbSingleSpecification;
        CustomFontCheckBox rbMultipleSpecification;
        TextView tvSpecificationItemDescription, tvSpecificationItemPrice, tvSpecificationQuantity;
        LinearLayout llSpecificationQuantity;
        View btnDecrease, btnIncrease;

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