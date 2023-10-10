package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Addresses;

import java.util.List;

public class CourierDeliveryAddressAdapter extends RecyclerView.Adapter<CourierDeliveryAddressAdapter.CourierDeliveryAddressViewHolder> {

    private final List<Addresses> addressesList;

    public CourierDeliveryAddressAdapter(List<Addresses> addressesList) {
        this.addressesList = addressesList;
    }

    @NonNull
    @Override
    public CourierDeliveryAddressViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        return new CourierDeliveryAddressViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_courier_delivery_address, parent, false));
    }

    @Override
    public void onBindViewHolder(CourierDeliveryAddressViewHolder holder, int position) {
        Addresses addresses = addressesList.get(position);

        holder.tvNumber.setText(String.valueOf(holder.getAbsoluteAdapterPosition() + 1));
        holder.tvDeliveredTo.setText(addresses.getUserDetails().getName());
        holder.tvDeliveredAddress.setText(addresses.getAddress());
        holder.tvPhoneNumber.setText(String.format("%s %s", addresses.getUserDetails().getCountryPhoneCode(), addresses.getUserDetails().getPhone()));
        if (addresses.getArrivedTime() != null) {
            holder.tvArrivedTime.setVisibility(View.VISIBLE);
            holder.tvArrivedTime.setText(addresses.getArrivedTime());
        } else {
            holder.tvArrivedTime.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        if (addressesList == null) {
            return 0;
        } else {
            return addressesList.size();
        }
    }

    public static class CourierDeliveryAddressViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextViewTitle tvNumber, tvDeliveredTo;
        CustomFontTextView tvDeliveredAddress, tvPhoneNumber, tvArrivedTime;

        public CourierDeliveryAddressViewHolder(View itemView) {
            super(itemView);
            tvNumber = itemView.findViewById(R.id.tvNumber);
            tvDeliveredTo = itemView.findViewById(R.id.tvDeliveredTo);
            tvDeliveredAddress = itemView.findViewById(R.id.tvDeliveredAddress);
            tvPhoneNumber = itemView.findViewById(R.id.tvPhoneNumber);
            tvArrivedTime = itemView.findViewById(R.id.tvArrivedTime);
        }
    }
}