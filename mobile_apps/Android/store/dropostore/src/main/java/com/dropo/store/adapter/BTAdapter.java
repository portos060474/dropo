package com.dropo.store.adapter;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;


import com.dropo.store.R;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public final class BTAdapter extends RecyclerView.Adapter<BTAdapter.BTViewHolder> {

    private final List<BluetoothDevice> bluetoothDevices;
    private final BlueToothSelectListener blueToothSelectListener;

    public BTAdapter(@NonNull BlueToothSelectListener blueToothSelectListener) {
        bluetoothDevices = new ArrayList<>();
        this.blueToothSelectListener = blueToothSelectListener;
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setBluetoothDevices(Set<BluetoothDevice> bluetoothDevices) {
        this.bluetoothDevices.clear();
        this.bluetoothDevices.addAll(bluetoothDevices);
        notifyDataSetChanged();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setBluetoothDevices(BluetoothDevice bluetoothDevice) {
        this.bluetoothDevices.add(bluetoothDevice);
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public BTViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        return new BTViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_bt_list, parent, false));
    }

    @SuppressLint("MissingPermission")
    @Override
    public void onBindViewHolder(@NonNull BTViewHolder holder, int position) {
        BluetoothDevice bluetoothDevice = bluetoothDevices.get(position);
        holder.tvBTName.setText(bluetoothDevice.getName());
        holder.tvBTAddress.setText(bluetoothDevice.getAddress());
        holder.tvBTType.setText(deviceType(bluetoothDevice.getType()));
    }

    @Override
    public int getItemCount() {
        return bluetoothDevices.size();
    }

    private String deviceType(int deviceType) {
        switch (deviceType) {
            case BluetoothDevice.DEVICE_TYPE_CLASSIC:
                return "Bluetooth device type, Classic - BR/EDR devices";
            case BluetoothDevice.DEVICE_TYPE_LE:
                return "Bluetooth device type, Low Energy - LE-only";
            case BluetoothDevice.DEVICE_TYPE_DUAL:
                return "Bluetooth device type, Dual Mode - BR/EDR/LE";
            default:
                return "Bluetooth device type, Unknown";
        }
    }

    public interface BlueToothSelectListener {
        void onBlueToothSelect(BluetoothDevice device);
    }

    protected class BTViewHolder extends RecyclerView.ViewHolder {
        TextView tvBTName, tvBTAddress, tvBTType;

        public BTViewHolder(@NonNull View itemView) {
            super(itemView);
            tvBTName = itemView.findViewById(R.id.tvBTName);
            tvBTAddress = itemView.findViewById(R.id.tvBTAddress);
            tvBTType = itemView.findViewById(R.id.tvBTType);
            itemView.setOnClickListener(view -> blueToothSelectListener.onBlueToothSelect(bluetoothDevices.get(getAbsoluteAdapterPosition())));
        }
    }
}
