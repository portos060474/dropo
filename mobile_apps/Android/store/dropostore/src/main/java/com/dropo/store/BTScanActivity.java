package com.dropo.store;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.BTAdapter;
import com.dropo.store.bluetoothprinter.BluetoothDeviceManager;
import com.dropo.store.utils.Utilities;

import java.util.Set;

public class BTScanActivity extends BaseActivity implements BluetoothDeviceManager.BlueToothDevicesListener, BTAdapter.BlueToothSelectListener {

    private BluetoothDeviceManager bluetoothDeviceManager;
    private BTAdapter btAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bt_scan);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_blue_tooth_devices));
        bluetoothDeviceManager = new BluetoothDeviceManager(this, this, false);
        btAdapter = new BTAdapter(this);
        findViewById(R.id.btnScan).setOnClickListener(this);
        RecyclerView recyclerView = findViewById(R.id.deviceList);
        recyclerView.setAdapter(btAdapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (bluetoothDeviceManager.checkLocationPermission()) {
            bluetoothDeviceManager.startDiscoveryOfDevices();
        }
    }

    @Override
    protected void onStop() {
        bluetoothDeviceManager.stopDiscoveryOfDevices();
        super.onStop();
    }

    @Override
    public void bluetoothDiscoverDevices(Set<BluetoothDevice> btDeviceList) {
        btAdapter.setBluetoothDevices(btDeviceList);

    }

    @Override
    public void bluetoothDiscoverDevice(BluetoothDevice device) {
        btAdapter.setBluetoothDevices(device);
    }

    @Override
    public void deviceFailToConnect(String errorMessage) {
        Utilities.hideCustomProgressDialog();
        Utilities.showToast(this, errorMessage);
    }

    @Override
    public void deviceConnected(BluetoothSocket btSocket) {
        Utilities.hideCustomProgressDialog();
        Utilities.showToast(this, "Device connected successfully");
        setResult(Activity.RESULT_OK);
        finish();
    }

    @Override
    public void onBlueToothSelect(BluetoothDevice device) {
        Utilities.showCustomProgressDialog(this, false);
        bluetoothDeviceManager.connectToDevice(device);
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.btnScan) {
            bluetoothDeviceManager.stopDiscoveryOfDevices();
            if (bluetoothDeviceManager.checkLocationPermission()) {
                bluetoothDeviceManager.startDiscoveryOfDevices();
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        bluetoothDeviceManager.setResultOnManager(requestCode, resultCode, data);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == BluetoothDeviceManager.PERMISSION_FOR_LOCATION_BT) {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    bluetoothDeviceManager.startDiscoveryOfDevices();
                }
            }
        }
    }
}