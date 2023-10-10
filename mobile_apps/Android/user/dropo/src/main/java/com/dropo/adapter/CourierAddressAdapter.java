package com.dropo.adapter;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.component.SwipeAndDragHelper;
import com.dropo.models.datamodels.Addresses;

import java.util.ArrayList;

public abstract class CourierAddressAdapter extends RecyclerView.Adapter<CourierAddressAdapter.ViewHolder> implements
        SwipeAndDragHelper.ItemTouchHelperAdapter {

    private final Context context;
    private final ArrayList<Addresses> courierAddressList;

    public CourierAddressAdapter(Context context, ArrayList<Addresses> courierAddressList) {
        this.context = context;
        this.courierAddressList = courierAddressList;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_courier_address, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Addresses addresses = courierAddressList.get(position);

        holder.tvAddressTitle.setText(addresses.getAddress());
        holder.tvDetails.setText(String.format("%s | %s %s",
                addresses.getUserDetails().getName(),
                addresses.getUserDetails().getCountryPhoneCode(), addresses.getUserDetails().getPhone()));

        if (!TextUtils.isEmpty(addresses.getNote())) {
            holder.tvNote.setText(addresses.getNote());
        } else {
            holder.tvNote.setText(context.getString(R.string.text_empty_string));
        }

        holder.div1.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
        holder.div2.setVisibility(position == getItemCount() - 1 ? View.INVISIBLE : View.VISIBLE);
        if (position == 0) {
            holder.ivAddressPin.setImageResource(R.drawable.ic_location_on_gray_24dp);
            holder.ivAddressPin.setPadding(0, 0, 0, 0);
        } else if (position == getItemCount() - 1) {
            holder.ivAddressPin.setImageResource(R.drawable.ic_location_on_gray_24dp);
            holder.ivAddressPin.setPadding(0, 0, 0, 0);
        } else {
            holder.ivAddressPin.setImageResource(R.drawable.circle_theme);
            holder.ivAddressPin.setPadding(15, 15, 15, 15);
        }
    }

    @Override
    public int getItemCount() {
        return courierAddressList.size();
    }

    public abstract void onSelect(int position);

    public abstract void onDelete(int position);

    protected class ViewHolder extends RecyclerView.ViewHolder implements SwipeAndDragHelper.ItemTouchHelperViewHolder {
        private final CustomFontTextViewTitle tvAddressTitle;
        private final CustomFontTextView tvDetails, tvNote;
        private final ImageView ivAddressPin, btnDeleteAddress;
        private final View div1, div2;

        public ViewHolder(View itemView) {
            super(itemView);
            tvAddressTitle = itemView.findViewById(R.id.tvAddressTitle);
            tvDetails = itemView.findViewById(R.id.tvDetails);
            tvNote = itemView.findViewById(R.id.tvNote);
            ivAddressPin = itemView.findViewById(R.id.ivAddressPin);
            btnDeleteAddress = itemView.findViewById(R.id.btnDeleteAddress);

            div1 = itemView.findViewById(R.id.div1);
            div2 = itemView.findViewById(R.id.div2);

            btnDeleteAddress.setOnClickListener(v -> onDelete(getAbsoluteAdapterPosition()));
            itemView.setOnClickListener(v -> onSelect(getAbsoluteAdapterPosition()));
        }

        @Override
        public void onItemSelected() {
            itemView.setBackgroundColor(Color.LTGRAY);
        }

        @Override
        public void onItemClear() {
            itemView.setBackgroundColor(0);
        }
    }
}
