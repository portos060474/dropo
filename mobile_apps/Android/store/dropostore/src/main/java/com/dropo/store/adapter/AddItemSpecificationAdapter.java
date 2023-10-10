package com.dropo.store.adapter;

import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomSwitch;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.textfield.TextInputEditText;

import java.util.ArrayList;

public class AddItemSpecificationAdapter extends RecyclerView.Adapter<AddItemSpecificationAdapter.ViewHolder> implements CompoundButton.OnCheckedChangeListener {

    private final Context context;
    private final ArrayList<ProductSpecification> newSpecificationList;
    private final ParseContent parseContent;

    public AddItemSpecificationAdapter(Context context, ArrayList<ProductSpecification> productSpecificationList) {
        this.context = context;
        this.newSpecificationList = productSpecificationList;
        parseContent = ParseContent.getInstance();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.adapter_add_item_specification, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        final ProductSpecification productSpecification = newSpecificationList.get(position);
        holder.tvSpecificationName.setText(productSpecification.getName());
        holder.llDefault.setSelected(productSpecification.isIsDefaultSelected());
        holder.switchDefault.setChecked(productSpecification.isIsDefaultSelected());
        if (productSpecification.getPrice() > 0) {
            holder.etSpecificationPrice.setText(parseContent.decimalTwoDigitFormat.format(productSpecification.getPrice()));
        }
        holder.checkboxSpecification.setOnCheckedChangeListener(null);
        holder.checkboxSpecification.setChecked(productSpecification.isIsUserSelected());
        holder.checkboxSpecification.setOnCheckedChangeListener(this);
        holder.checkboxSpecification.setTag(position);

        holder.etSpecificationPrice.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (Utilities.isDecimalAndGraterThenZero(s.toString())) {
                    newSpecificationList.get(holder.getAbsoluteAdapterPosition()).setPrice(Utilities.roundDecimal(Double.parseDouble(s.toString())));
                }
            }
        });

        if (productSpecification.isIsDefaultSelected() && holder.checkboxSpecification.isChecked()) {
            holder.llDefault.setSelected(true);
            holder.switchDefault.setChecked(true);
            productSpecification.setIsDefaultSelected(true);
        } else {
            holder.llDefault.setSelected(false);
            holder.switchDefault.setChecked(false);
            productSpecification.setIsDefaultSelected(false);
        }

        holder.etSpecificationPrice.setEnabled(holder.checkboxSpecification.isChecked());
        holder.llDefault.setEnabled(holder.checkboxSpecification.isChecked());
        holder.tvSpecificationName.setEnabled(holder.checkboxSpecification.isChecked());
        holder.tvCurrency.setText(PreferenceHelper.getPreferenceHelper(context).getCurrency());
        holder.llDefault.setOnClickListener(view -> {
            if (holder.llDefault.isSelected()) {
                newSpecificationList.get(position).setIsDefaultSelected(false);
                holder.llDefault.setSelected(false);
                holder.switchDefault.setChecked(false);
            } else {
                if (newSpecificationList.get(position).isIsUserSelected()) {
                    newSpecificationList.get(position).setIsDefaultSelected(true);
                    holder.llDefault.setSelected(true);
                    holder.switchDefault.setChecked(true);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return newSpecificationList.size();
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        CheckBox cb = (CheckBox) buttonView;
        newSpecificationList.get((int) cb.getTag()).setIsUserSelected(cb.isChecked());
        notifyItemChanged((Integer) cb.getTag());
    }

    public ArrayList<ProductSpecification> getUpdatedList() {
        return newSpecificationList;
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final CheckBox checkboxSpecification;
        private final TextView tvCurrency;
        private final TextInputEditText etSpecificationPrice;
        private final CustomSwitch switchDefault;
        private final CustomTextView tvSpecificationName;
        private final LinearLayout llDefault;

        ViewHolder(View itemView) {
            super(itemView);
            tvSpecificationName = itemView.findViewById(R.id.tvSpecificationName);
            checkboxSpecification = itemView.findViewById(R.id.checkboxSpecification);
            etSpecificationPrice = itemView.findViewById(R.id.etSpecificationPrice);
            tvCurrency = itemView.findViewById(R.id.tvCurrency);
            switchDefault = itemView.findViewById(R.id.switchDefault);
            llDefault = itemView.findViewById(R.id.llDefault);
        }
    }
}