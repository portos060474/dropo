package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.fragment.BasePaymentFragments;
import com.dropo.store.fragment.PayStackFragment;
import com.dropo.store.fragment.StripeFragment;
import com.dropo.store.models.datamodel.Card;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class CardAdapter extends RecyclerView.Adapter<CardAdapter.CardViewHolder> {

    private final ArrayList<Card> cardList;
    private final BasePaymentFragments stripeFragment;

    public CardAdapter(BasePaymentFragments stripeFragment, ArrayList<Card> cardList) {
        this.cardList = cardList;
        this.stripeFragment = stripeFragment;
    }

    @NonNull
    @Override
    public CardViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_card, parent, false);
        return new CardViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CardViewHolder holder, int position) {
        Card card = cardList.get(position);
        String cardLastFour = "****" + card.getLastFour();
        holder.tvCardNumber.setText(cardLastFour);
        if (card.isIsDefault()) {
            holder.ivSelected.setVisibility(View.VISIBLE);
        } else {
            holder.ivSelected.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return cardList.size();
    }

    protected class CardViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        CustomTextView tvCardNumber;
        ImageView ivSelected;
        LinearLayout llCard;
        ImageView ivDeleteCard;

        public CardViewHolder(View itemView) {
            super(itemView);
            tvCardNumber = itemView.findViewById(R.id.tvCardNumber);
            ivDeleteCard = itemView.findViewById(R.id.ivDeleteCard);
            ivSelected = itemView.findViewById(R.id.ivSelected);
            llCard = itemView.findViewById(R.id.llCard);
            llCard.setOnClickListener(this);
            ivDeleteCard.setOnClickListener(this);
        }

        @Override
        public void onClick(View view) {
            int id = view.getId();
            if (id == R.id.llCard) {
                if (!cardList.get(getAbsoluteAdapterPosition()).isIsDefault()) {
                    if (stripeFragment instanceof StripeFragment) {
                        ((StripeFragment) stripeFragment).selectCreditCard(getAbsoluteAdapterPosition());
                    } else if (stripeFragment instanceof PayStackFragment) {
                        ((PayStackFragment) stripeFragment).selectCreditCard(getAbsoluteAdapterPosition());
                    } else {
                        Utilities.showToast(view.getContext(), view.getContext().getString(R.string.something_went_wrong));
                    }
                }
            } else if (id == R.id.ivDeleteCard) {
                if (stripeFragment instanceof StripeFragment) {
                    ((StripeFragment) stripeFragment).openDeleteCard(getAbsoluteAdapterPosition());
                } else if (stripeFragment instanceof PayStackFragment) {
                    ((PayStackFragment) stripeFragment).openDeleteCard(getAbsoluteAdapterPosition());
                } else {
                    Utilities.showToast(view.getContext(), view.getContext().getString(R.string.something_went_wrong));
                }
            }
        }
    }
}