package com.dropo.store.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.widgets.CustomRadioButton;


import java.util.List;

public class VehicleAdapter extends RecyclerView.Adapter<VehicleAdapter.VehicleViewHolder> {

    private final List<VehicleDetail> vehicleDetails;
    private final Context context;

    public VehicleAdapter(Context context, List<VehicleDetail> vehicleDetails) {
        this.vehicleDetails = vehicleDetails;
        this.context = context;
    }

    @NonNull
    @Override
    public VehicleViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new VehicleViewHolder(LayoutInflater.from(context).inflate(R.layout.item_vehicle, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull VehicleViewHolder holder, int position) {
        holder.rbVehicle.setText(vehicleDetails.get(position).getVehicleName());
        holder.rbVehicle.setChecked(vehicleDetails.get(position).isSelected());
    }

    @Override
    public int getItemCount() {
        return vehicleDetails.size();
    }

    protected static class VehicleViewHolder extends RecyclerView.ViewHolder {
        CustomRadioButton rbVehicle;

        public VehicleViewHolder(View itemView) {
            super(itemView);
            rbVehicle = itemView.findViewById(R.id.rbVehicle);
            rbVehicle.setClickable(false);
        }
    }
}