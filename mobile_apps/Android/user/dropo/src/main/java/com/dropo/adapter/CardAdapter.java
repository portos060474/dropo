package com.dropo.adapter;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.AppCompatImageView;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.fragments.BasePaymentFragments;
import com.dropo.fragments.PaystackFragment;
import com.dropo.fragments.StripeFragment;
import com.dropo.models.datamodels.Card;
import com.dropo.utils.AppColor;
import com.dropo.utils.Utils;

import java.util.ArrayList;
import java.util.Objects;

public class CardAdapter extends RecyclerView.Adapter<CardAdapter.CardViewHolder> {
    private final ArrayList<Card> cardList;
    private final BasePaymentFragments stripeFragment;
    private Context context;

    public CardAdapter(BasePaymentFragments stripeFragment, ArrayList<Card> cardList) {
        this.cardList = cardList;
        this.stripeFragment = stripeFragment;
    }

    @NonNull
    @Override
    public CardViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_card, parent, false);
        return new CardViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CardViewHolder holder, int position) {
        Card card = cardList.get(position);
        String cardLastFour = "**** " + card.getLastFour();
        holder.tvCardNumber.setText(cardLastFour);
        if (card.isDefault()) {
            Drawable drawable = Objects.requireNonNull(AppCompatResources.getDrawable(context, R.drawable.ic_credit_card_big)).mutate();
            drawable.setTint(AppColor.COLOR_THEME);
            holder.ivCard.setImageDrawable(drawable);
            holder.tvCardNumber.setTextColor(AppColor.COLOR_THEME);
        } else {
            Drawable drawable = Objects.requireNonNull(AppCompatResources.getDrawable(context, R.drawable.ic_credit_card_big)).mutate();
            drawable.setTint(ResourcesCompat.getColor(context.getResources(), AppColor.isDarkTheme(context) ? R.color.color_app_icon_dark : R.color.color_app_icon_light, null));
            holder.ivCard.setImageDrawable(drawable);
            holder.tvCardNumber.setTextColor(AppColor.getThemeTextColor(context));
        }
    }

    @Override
    public int getItemCount() {
        return cardList.size();
    }

    protected class CardViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        private final CustomFontTextView tvCardNumber;
        private final LinearLayout llCard;
        private final ImageView ivDeleteCard;
        private final AppCompatImageView ivCard;

        public CardViewHolder(View itemView) {
            super(itemView);
            tvCardNumber = itemView.findViewById(R.id.tvCardNumber);
            ivDeleteCard = itemView.findViewById(R.id.ivDeleteCard);
            llCard = itemView.findViewById(R.id.llCard);
            llCard.setOnClickListener(this);
            ivDeleteCard.setOnClickListener(this);
            ivCard = itemView.findViewById(R.id.ivCard);
        }

        @Override
        public void onClick(View view) {
            int id = view.getId();
            if (id == R.id.llCard) {
                if (!cardList.get(getAbsoluteAdapterPosition()).isDefault()) {
                    if (stripeFragment instanceof StripeFragment) {
                        ((StripeFragment) stripeFragment).selectCreditCard(getAbsoluteAdapterPosition());
                    } else if (stripeFragment instanceof PaystackFragment) {
                        ((PaystackFragment) stripeFragment).selectCreditCard(getAbsoluteAdapterPosition());
                    } else {
                        Utils.showToast(context.getString(R.string.something_went_wrong), context);
                    }
                }
            } else if (id == R.id.ivDeleteCard) {
                if (stripeFragment instanceof StripeFragment) {
                    ((StripeFragment) stripeFragment).openDeleteCard(getAbsoluteAdapterPosition());
                } else if (stripeFragment instanceof PaystackFragment) {
                    ((PaystackFragment) stripeFragment).openDeleteCard(getAbsoluteAdapterPosition());
                } else {
                    Utils.showToast(context.getString(R.string.something_went_wrong), context);
                }
            }
        }
    }
}