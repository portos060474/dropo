package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.Address;

import java.util.List;

public abstract class FavouriteAddressAdapter extends RecyclerView.Adapter<FavouriteAddressAdapter.AddressViewHolder> {

    private final boolean isChooseAddress;
    private List<Address> addresses;

    public FavouriteAddressAdapter(boolean isChooseAddress) {
        this.isChooseAddress = isChooseAddress;
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setAddresses(List<Address> addresses) {
        this.addresses = addresses;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public AddressViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new AddressViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_favourite_address, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull AddressViewHolder holder, int position) {
        Address address = addresses.get(position);

        String strAddress = address.getAddress();
        if (address.getFlat_no() != null && address.getFlat_no().isEmpty()) {
            strAddress = strAddress.concat("\n" + address.getFlat_no());
        }
        if (address.getStreet() != null && !address.getStreet().isEmpty()) {
            if (!address.getFlat_no().isEmpty()) {
                strAddress = strAddress.concat(", " + address.getStreet());
            } else {
                strAddress = strAddress.concat("\n" + address.getStreet());
            }
        }
        if (address.getLandmark() != null && !address.getLandmark().isEmpty()) {
            strAddress = strAddress.concat("\n" + address.getLandmark());
        }
        holder.tvAddress.setText(strAddress);

        holder.tvAddressTitle.setText(address.getAddressName());
        holder.tvAddressTitle.setVisibility(TextUtils.isEmpty(address.getAddressName()) ? View.GONE : View.VISIBLE);
        holder.div.setVisibility(getItemCount() - 1 == position ? View.GONE : View.VISIBLE);
    }

    @Override
    public int getItemCount() {
        return addresses == null ? 0 : addresses.size();
    }

    public abstract void onAddressDelete(Address address);

    public abstract void onAddressUpdate(Address address);

    @SuppressLint("NotifyDataSetChanged")
    public void removeAddress(Address address) {
        if (addresses != null) {
            addresses.remove(address);
            notifyDataSetChanged();
        }
    }

    protected class AddressViewHolder extends RecyclerView.ViewHolder {
        private final TextView tvAddressTitle;
        private final TextView tvAddress;
        private final View div;

        public AddressViewHolder(@NonNull View itemView) {
            super(itemView);
            tvAddressTitle = itemView.findViewById(R.id.tvAddressTitle);
            tvAddress = itemView.findViewById(R.id.tvAddress);
            ImageView btnDeleteAddress = itemView.findViewById(R.id.btnDeleteAddress);
            btnDeleteAddress.setOnClickListener(v -> onAddressDelete(addresses.get(getAbsoluteAdapterPosition())));
            div = itemView.findViewById(R.id.div);
            itemView.setOnClickListener(v -> onAddressUpdate(addresses.get(getAbsoluteAdapterPosition())));
            if (isChooseAddress) {
                btnDeleteAddress.setVisibility(View.GONE);
                btnDeleteAddress.setClickable(false);
            } else {
                btnDeleteAddress.setVisibility(View.VISIBLE);
                btnDeleteAddress.setClickable(true);
            }
        }
    }
}