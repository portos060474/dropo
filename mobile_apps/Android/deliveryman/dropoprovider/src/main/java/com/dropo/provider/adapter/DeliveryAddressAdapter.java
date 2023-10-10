package com.dropo.provider.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.models.datamodels.Addresses;

import java.util.List;

public class DeliveryAddressAdapter extends RecyclerView.Adapter<DeliveryAddressAdapter.DeliveryAddressViewHolder> {

    private final Context context;
    private final List<Addresses> addressesList;
    private boolean isShowCheck = false;
    private boolean isShowPickupPin = true;
    private int reachedAddressPosition;

    public DeliveryAddressAdapter(Context context, List<Addresses> addressesList) {
        this.context = context;
        this.addressesList = addressesList;
    }

    @NonNull
    @Override
    public DeliveryAddressViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new DeliveryAddressViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_delivery_address, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull DeliveryAddressViewHolder holder, int position) {
        Addresses addresses = addressesList.get(position);
        if (isShowPickupPin && position == 0) {
            if (isShowCheck && position <= reachedAddressPosition) {
                holder.tvAddress.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(context, R.drawable.ic_pin_delivery_black), null, AppCompatResources.getDrawable(context, R.drawable.ic_checked), null);
            } else {
                holder.tvAddress.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(context, R.drawable.ic_pin_delivery_black), null, null, null);
            }
        } else {
            if (isShowCheck && position <= reachedAddressPosition) {
                holder.tvAddress.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(context, R.drawable.ic_pin_delivery), null, AppCompatResources.getDrawable(context, R.drawable.ic_checked), null);
            } else {
                holder.tvAddress.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(context, R.drawable.ic_pin_delivery), null, null, null);
            }
        }

        holder.tvAddress.setText(getFormattedAddress(addresses));

        if (addresses.getArrivedTime() != null) {
            holder.tvArrivedTime.setVisibility(View.VISIBLE);
            holder.tvArrivedTime.setText(addresses.getArrivedTime());
        } else {
            holder.tvArrivedTime.setVisibility(View.GONE);
        }
    }

    private String getFormattedAddress(Addresses addressesData) {
        if (addressesData != null) {
            String address = addressesData.getAddress();
            if (addressesData.getFlatNo() != null && !addressesData.getFlatNo().isEmpty()) {
                address = address.concat("\n" + addressesData.getFlatNo());
            }
            if (addressesData.getStreet() != null && !addressesData.getStreet().isEmpty()) {
                if (addressesData.getFlatNo() != null && !addressesData.getFlatNo().isEmpty()) {
                    address = address.concat(", " + addressesData.getStreet());
                } else {
                    address = address.concat("\n" + addressesData.getStreet());
                }
            }
            if (addressesData.getLandmark() != null && !addressesData.getLandmark().isEmpty()) {
                address = address.concat("\n" + addressesData.getLandmark());
            }
            return address;
        }
        return "";
    }

    @Override
    public int getItemCount() {
        return addressesList == null ? 0 : addressesList.size();
    }

    public void setReachedAddressPosition(boolean isShowCheck, int reachedAddressPosition) {
        this.isShowCheck = isShowCheck;
        this.reachedAddressPosition = reachedAddressPosition;
    }

    public void setShowPickupPin(boolean isShowPickupPin) {
        this.isShowPickupPin = isShowPickupPin;
    }

    protected static class DeliveryAddressViewHolder extends RecyclerView.ViewHolder {
        private final CustomFontTextView tvAddress, tvArrivedTime;

        public DeliveryAddressViewHolder(@NonNull View itemView) {
            super(itemView);
            tvAddress = itemView.findViewById(R.id.tvAddress);
            tvArrivedTime = itemView.findViewById(R.id.tvArrivedTime);
        }
    }
}