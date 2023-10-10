package com.dropo.provider.adapter;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.VehicleDetailActivity;
import com.dropo.provider.models.datamodels.Vehicle;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.Utils;

import java.util.List;

public class VehicleDetailAdapter extends RecyclerView.Adapter<VehicleDetailAdapter.VehicleItemView> {

    private final VehicleDetailActivity vehicleDetailActivity;
    private final List<Vehicle> vehicleList;

    public VehicleDetailAdapter(VehicleDetailActivity vehicleDetailActivity, List<Vehicle> vehicleList) {
        this.vehicleDetailActivity = vehicleDetailActivity;
        this.vehicleList = vehicleList;
    }

    @NonNull
    @Override
    public VehicleItemView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_vehicle, parent, false);
        return new VehicleItemView(view);
    }

    @Override
    public void onBindViewHolder(final VehicleItemView holder, int position) {
        final Vehicle vehicle = vehicleList.get(position);
        holder.tvVehicleName.setText(vehicle.getVehicleName());
        holder.tvVehiclePlateNo.setText(vehicle.getVehiclePlateNo());
        holder.tvVehicleModel.setText(vehicle.getVehicleModel());
        if (vehicle.getVehicleDetail() != null && !vehicle.getVehicleDetail().isEmpty()) {
            holder.tvVehicleType.setText(vehicle.getVehicleDetail().get(0).getVehicleName());
        }
        holder.rbSelectVehicle.setChecked(TextUtils.equals(vehicle.getId(), PreferenceHelper.getInstance(vehicleDetailActivity).getSelectedVehicleId()));
        holder.rbSelectVehicle.setOnClickListener(v -> {
            if (vehicleList.get(holder.getAbsoluteAdapterPosition()).getApproved() && !TextUtils.isEmpty(vehicle.getAdminVehicleId())) {
                vehicleDetailActivity.selectVehicle(holder.getAbsoluteAdapterPosition());
            } else {
                holder.rbSelectVehicle.setChecked(false);
                Utils.showToast(vehicleDetailActivity.getResources().getString(R.string.msg_vehicle_not_approved), vehicleDetailActivity);
            }
        });
        holder.itemView.setOnClickListener(v -> vehicleDetailActivity.goToAddVehicleDetailFragment(vehicle));
        if (!vehicleList.get(position).getVehicleDetail().isEmpty()) {
            GlideApp.with(vehicleDetailActivity)
                    .load(IMAGE_URL + vehicle.getVehicleDetail().get(0).getImageUrl())
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(vehicleDetailActivity.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(vehicleDetailActivity.getResources(), R.drawable.placeholder, null))
                    .into(holder.ivVehicle);
        }
    }

    @Override
    public int getItemCount() {
        return vehicleList.size();
    }

    protected static class VehicleItemView extends RecyclerView.ViewHolder {
        ImageView ivVehicle;
        RadioButton rbSelectVehicle;
        TextView tvVehicleName, tvVehicleModel, tvVehiclePlateNo, tvVehicleType;

        public VehicleItemView(View itemView) {
            super(itemView);
            ivVehicle = itemView.findViewById(R.id.ivVehicle);
            rbSelectVehicle = itemView.findViewById(R.id.rbSelectVehicle);
            tvVehiclePlateNo = itemView.findViewById(R.id.tvVehiclePlateNo);
            tvVehicleType = itemView.findViewById(R.id.tvVehicleType);
            tvVehicleModel = itemView.findViewById(R.id.tvVehicleModel);
            tvVehicleName = itemView.findViewById(R.id.tvVehicleName);
        }
    }
}