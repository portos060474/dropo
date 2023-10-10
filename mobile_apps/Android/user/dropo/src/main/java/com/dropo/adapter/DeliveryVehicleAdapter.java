package com.dropo.adapter;

import static com.dropo.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.models.datamodels.Vehicle;
import com.dropo.utils.AppColor;
import com.dropo.utils.GlideApp;

import java.util.ArrayList;

public abstract class DeliveryVehicleAdapter extends RecyclerView.Adapter<DeliveryVehicleAdapter.DeliveryVehicleViewHolder> {
    private final Context context;
    private final ArrayList<Vehicle> vehicleArrayList;

    private Vehicle vehicle;

    public DeliveryVehicleAdapter(Context context, ArrayList<Vehicle> vehicleArrayList) {
        this.context = context;
        this.vehicleArrayList = vehicleArrayList;
        if (vehicleArrayList != null && !vehicleArrayList.isEmpty()) {
            vehicle = vehicleArrayList.get(0);
            vehicleArrayList.get(0).setSelected(true);
        }
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    @NonNull
    @Override
    public DeliveryVehicleViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_courier_vehicle, parent, false);
        return new DeliveryVehicleViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull DeliveryVehicleViewHolder holder, int position) {
        Vehicle vehicle = vehicleArrayList.get(position);
        holder.viewSelect.setVisibility(vehicle.isSelected() ? View.VISIBLE : View.GONE);
        GlideApp.with(context)
                .load(IMAGE_URL + vehicle.getImageUrl())
                .placeholder(R.drawable.placeholder)
                .error(R.drawable.placeholder)
                .override(200, 200)
                .into(holder.ivVehicleImage);
        holder.tvVehicleName.setText(vehicle.getVehicleName());
    }

    @Override
    public int getItemCount() {
        if (vehicleArrayList == null) {
            return 0;
        } else {
            return vehicleArrayList.size();
        }
    }

    public abstract void onSelect(Vehicle vehicle);

    protected class DeliveryVehicleViewHolder extends RecyclerView.ViewHolder {
        TextView tvVehicleName;
        View viewSelect;
        ImageView ivVehicleImage;

        @SuppressLint("NotifyDataSetChanged")
        public DeliveryVehicleViewHolder(View itemView) {
            super(itemView);
            tvVehicleName = itemView.findViewById(R.id.tvVehicleName);
            ivVehicleImage = itemView.findViewById(R.id.ivVehicleImage);
            viewSelect = itemView.findViewById(R.id.viewSelect);
            viewSelect.setBackgroundColor(AppColor.COLOR_THEME);
            itemView.setOnClickListener(v -> {
                for (Vehicle vehicle : vehicleArrayList) {
                    vehicle.setSelected(false);
                }
                vehicleArrayList.get(getAbsoluteAdapterPosition()).setSelected(true);
                vehicle = vehicleArrayList.get(getAbsoluteAdapterPosition());
                onSelect(vehicle);
                notifyDataSetChanged();
            });
        }
    }
}
