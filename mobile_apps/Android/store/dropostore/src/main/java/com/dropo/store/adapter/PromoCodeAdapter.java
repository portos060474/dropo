package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.PromoCodeActivity;
import com.dropo.store.models.datamodel.PromoCodes;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomInputEditText;
import com.dropo.store.widgets.CustomTextView;


import java.text.ParseException;
import java.util.Date;
import java.util.List;

public class PromoCodeAdapter extends RecyclerView.Adapter<PromoCodeAdapter.PromoCodeItemView> {

    private final List<PromoCodes> codesItemList;
    private final PromoCodeActivity promoCodeActivity;

    public PromoCodeAdapter(PromoCodeActivity promoCodeActivity, List<PromoCodes> codesItemList) {
        this.codesItemList = codesItemList;
        this.promoCodeActivity = promoCodeActivity;
    }

    @NonNull
    @Override
    public PromoCodeItemView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_promo_code, parent, false);
        return new PromoCodeItemView(view);
    }

    @SuppressLint("SetTextI18n")
    @Override
    public void onBindViewHolder(PromoCodeItemView holder, int position) {
        final PromoCodes promoCodes = codesItemList.get(position);
        holder.tvPromoName.setText(promoCodes.getPromoCodeName());
        holder.tvPromoDescription.setText(promoCodes.getPromoDetails());
        if (promoCodes.getPromoCodeType() == Constant.Type.ABSOLUTE) {
            holder.tvPromoPricing.setText(String.format("%s %s", PreferenceHelper.getPreferenceHelper(promoCodeActivity).getCurrency(), promoCodes.getPromoCodeValue()));
        } else {
            holder.tvPromoPricing.setText(promoCodes.getPromoCodeValue() + "%");
        }

        try {
            if (promoCodes.isPromoHaveDate()) {
                if (promoCodes.getPromoStartDate() != null) {
                    Date startDate = ParseContent.getInstance().webFormat.parse(promoCodes.getPromoStartDate());
                    if (startDate != null) {
                        holder.etPromoStartDate.setText(ParseContent.getInstance().dateFormat.format(startDate));
                    }
                }
                if (promoCodes.getPromoExpireDate() != null) {
                    Date expDate = ParseContent.getInstance().webFormat.parse(promoCodes.getPromoExpireDate());
                    if (expDate != null) {
                        holder.etPromoExpDate.setText(ParseContent.getInstance().dateFormat.format(expDate));
                    }
                }
                holder.llIsPromoHaveDate.setVisibility(View.VISIBLE);
            } else {
                holder.llIsPromoHaveDate.setVisibility(View.GONE);
            }

        } catch (ParseException e) {
            Utilities.handleException(PromoCodeAdapter.class.getName(), e);
        }
        holder.switchActivePromo.setChecked(promoCodes.isIsActive());
        holder.switchActivePromo.setOnClickListener(v -> {
            promoCodes.setIsActive(!promoCodes.isIsActive());
            promoCodeActivity.updatePromoCode(promoCodes);
        });

        holder.itemView.setOnClickListener(v -> promoCodeActivity.goToAddPromoActivity(promoCodes));
    }

    @Override
    public int getItemCount() {
        return codesItemList.size();
    }

    protected static class PromoCodeItemView extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvPromoName, tvPromoPricing;
        CustomTextView tvPromoDescription;
        CustomInputEditText etPromoStartDate, etPromoExpDate;
        SwitchCompat switchActivePromo;
        LinearLayout llIsPromoHaveDate;

        public PromoCodeItemView(View itemView) {
            super(itemView);
            tvPromoName = itemView.findViewById(R.id.tvPromoCode);
            tvPromoPricing = itemView.findViewById(R.id.tvPromoPricing);
            tvPromoDescription = itemView.findViewById(R.id.tvPromoDescription);
            etPromoStartDate = itemView.findViewById(R.id.etPromoStartDate);
            etPromoExpDate = itemView.findViewById(R.id.etPromoExpDate);
            switchActivePromo = itemView.findViewById(R.id.switchActivePromo);
            llIsPromoHaveDate = itemView.findViewById(R.id.llIsPromoHaveDate);
        }
    }
}