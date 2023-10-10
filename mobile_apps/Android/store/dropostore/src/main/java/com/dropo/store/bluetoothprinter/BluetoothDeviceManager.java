package com.dropo.store.bluetoothprinter;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothClass;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.dropo.store.R;
import com.dropo.store.utils.Utilities;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public final class BluetoothDeviceManager {
    /**
     * The constant REQUEST_CONNECT_BT.
     */
    public static final int REQUEST_CONNECT_BT = 1231;
    /**
     * The constant PERMISSION_FOR_LOCATION_BT.
     */
    public static final int PERMISSION_FOR_LOCATION_BT = 232;
    private static BluetoothSocket btSocket = null;
    /**
     * The Tag.
     */
    public final String TAG = BluetoothDeviceManager.class.getSimpleName();
    private final AppCompatActivity appCompatActivity;
    private final int REQUEST_ENABLE_BT = 1230;
    private final UUID MY_UUID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");
    private final Set<BluetoothDevice> btDeviceList;
    private final BlueToothDevicesListener blueToothDevicesListener;
    private final IntentFilter btIntentFilter;
    private final IncomingHandler incomingHandler;
    private BluetoothAdapter bluetoothAdapter = null;
    private ConnectThread connectThread;
    private boolean isAutoConnect;
    private boolean isRegisterReceiver;
    private InputStream bTInputStream = null;
    private OutputStream bTOutputStream = null;
    private final BroadcastReceiver btReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (BluetoothDevice.ACTION_FOUND.equals(action)) {

                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                if (isPrinterDeviceAndNotAlreadyAdded(device)) {
                    btDeviceList.add(device);
                    if (isBlueToothDevicesListener()) {
                        blueToothDevicesListener.bluetoothDiscoverDevice(device);
                    }
                }
                autoConnectPreviousDevice(device);

            } else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action) || BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                if (device != null && btSocket != null && TextUtils.equals(btSocket.getRemoteDevice().getAddress(), device.getAddress())) {
                    flushData();
                }

            } else if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(action)) {
                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
                if (state == BluetoothAdapter.STATE_OFF) {
                    btSocket = null;
                } else if (state == BluetoothAdapter.STATE_ON) {
                }
            } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {

            }

        }
    };


    /**
     * Instantiates a new Bluetooth device manager.
     *
     * @param appCompatActivity        the app compat activity
     * @param blueToothDevicesListener the blue tooth devices listener
     */
    public BluetoothDeviceManager(AppCompatActivity appCompatActivity, BlueToothDevicesListener blueToothDevicesListener, boolean isAutoConnect) {
        this.isAutoConnect = isAutoConnect;
        this.appCompatActivity = appCompatActivity;
        this.blueToothDevicesListener = blueToothDevicesListener;
        incomingHandler = new IncomingHandler(this);
        btIntentFilter = new IntentFilter();
        btIntentFilter.addAction(BluetoothAdapter.ACTION_DISCOVERY_STARTED);
        btIntentFilter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        btIntentFilter.addAction(BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED);
        btIntentFilter.addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED);
        btIntentFilter.addAction(BluetoothDevice.ACTION_ACL_CONNECTED);
        btIntentFilter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        btIntentFilter.addAction(BluetoothDevice.ACTION_FOUND);
        btDeviceList = new HashSet<>();


    }

    /**
     * Gets bt socket.
     *
     * @return the bt socket
     */
    public static BluetoothSocket getBtSocket() {
        return btSocket;
    }

    /**
     * Is device socket connected boolean.
     *
     * @return the boolean
     */
    public static boolean isDeviceSocketConnected() {
        return btSocket != null && btSocket.isConnected() && btSocket.getRemoteDevice().getBondState() == BluetoothDevice.BOND_BONDED;

    }

    /**
     * Sets result on manager.
     *
     * @param reqCode    the req code
     * @param resultCode the result code
     * @param intent     the intent
     */
    public void setResultOnManager(int reqCode, int resultCode, Intent intent) {
        if (reqCode == REQUEST_ENABLE_BT) {
            if (resultCode == Activity.RESULT_OK) {
                Toast.makeText(this.appCompatActivity, "Getting all available Bluetooth Devices", Toast.LENGTH_SHORT).show();
                fetchAllBondedDevices();
                if (isBlueToothDevicesListener()) {
                    blueToothDevicesListener.bluetoothDiscoverDevices(btDeviceList);
                }
                bluetoothAdapter.startDiscovery();

            }
        }


    }

    /**
     * Start discovery of devices.
     */

    public boolean checkLocationPermission() {
        if ((ContextCompat.checkSelfPermission(appCompatActivity, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(appCompatActivity, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED)) {
            ActivityCompat.requestPermissions(appCompatActivity, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION, android.Manifest.permission.ACCESS_COARSE_LOCATION}, PERMISSION_FOR_LOCATION_BT);
            return false;
        } else {
            return true;
        }
    }

    public void startDiscoveryOfDevices() {
        //Do the stuff that requires permission...
        BluetoothManager mBluetoothManager = (BluetoothManager) appCompatActivity.getSystemService(Context.BLUETOOTH_SERVICE);

        if (mBluetoothManager == null) {
            Utilities.showToast(this.appCompatActivity, appCompatActivity.getString(R.string.bluetooth_is_not_supported));
            return;
        }
        bluetoothAdapter = mBluetoothManager.getAdapter();
        if (bluetoothAdapter == null) {
            Utilities.showToast(this.appCompatActivity, appCompatActivity.getString(R.string.bluetooth_is_not_supported));
            return;
        }

        if (isAutoConnect) {
            fetchAllBondedDevices();
            if (bluetoothAdapter.isEnabled()) {
                bluetoothAdapter.startDiscovery();
            }
        } else {
            flushData();
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            try {
                appCompatActivity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            } catch (Exception ex) {
                Toast.makeText(this.appCompatActivity, ex.getMessage(), Toast.LENGTH_SHORT).show();
            }
        }
        if (!isRegisterReceiver) {
            isRegisterReceiver = true;
            appCompatActivity.registerReceiver(btReceiver, btIntentFilter);
        }
    }

    /**
     * Stop discovery of devices.
     */
    public void stopDiscoveryOfDevices() {
        if (bluetoothAdapter != null && bluetoothAdapter.isDiscovering()) {
            bluetoothAdapter.cancelDiscovery();
        }
        if (isRegisterReceiver) {
            isRegisterReceiver = false;
            appCompatActivity.unregisterReceiver(btReceiver);
        }


    }

    private void flushData() {
        try {
            if (btSocket != null) {
                btSocket.close();
                if (bTInputStream != null) {
                    bTInputStream.close();
                }
                if (bTOutputStream != null) {
                    bTOutputStream.close();
                }
                btSocket = null;
            }

            if (bluetoothAdapter != null) {
                bluetoothAdapter.cancelDiscovery();
            }
            if (btDeviceList != null) {
                btDeviceList.clear();
            }

            //finalize();
        } catch (Exception ex) {
        } catch (Throwable e) {
        }
    }

    /**
     * Connect to device.
     *
     * @param bluetoothDevice the bluetooth device
     * @return the boolean
     */
    public void connectToDevice(BluetoothDevice bluetoothDevice) {
        if (bluetoothAdapter == null) {
            return;
        }
        if (bluetoothAdapter.isDiscovering()) {
            bluetoothAdapter.cancelDiscovery();
        }
        if (connectThread != null) {
            connectThread.cancel();
            connectThread = null;
        }
        connectThread = new ConnectThread(bluetoothDevice);
        connectThread.start();
    }

    private boolean isPrinterDeviceAndNotAlreadyAdded(BluetoothDevice bluetoothDevice) {
        return !btDeviceList.contains(bluetoothDevice) && isPrinter(bluetoothDevice);
    }

    private void autoConnectPreviousDevice(BluetoothDevice bluetoothDevice) {
        if (isAutoConnect && btDeviceList.contains(bluetoothDevice) && isPrinter(bluetoothDevice) && bluetoothDevice.getBondState() == BluetoothDevice.BOND_BONDED) {
            isAutoConnect = false;
            if (btSocket == null || !btSocket.isConnected()) {
                connectToDevice(bluetoothDevice);
            }
        }


    }

    private boolean isBlueToothDevicesListener() {
        return blueToothDevicesListener != null;
    }

    private void fetchAllBondedDevices() {
        if (bluetoothAdapter != null) {
            Set<BluetoothDevice> btDeviceList = bluetoothAdapter.getBondedDevices();
            if (btDeviceList.size() > 0) {
                for (BluetoothDevice bluetoothDevice : btDeviceList) {
                    if (isPrinterDeviceAndNotAlreadyAdded(bluetoothDevice)) {
                        this.btDeviceList.add(bluetoothDevice);
                    }

                }
            }
        }
    }

    private boolean isPrinter(BluetoothDevice device) {
        // class 0 allow for inner printer.
        return device.getBluetoothClass().getMajorDeviceClass() == BluetoothClass.Device.Major.IMAGING || device.getBluetoothClass().getDeviceClass() == 0 || device.getBluetoothClass().getMajorDeviceClass() == 0;
    }

    /**
     * The interface Blue tooth devices listener.
     */
    public interface BlueToothDevicesListener {

        /**
         * Bluetooth discover devices.
         *
         * @param btDeviceList the bt device list
         */
        void bluetoothDiscoverDevices(Set<BluetoothDevice> btDeviceList);

        /**
         * Bluetooth discover device.
         *
         * @param device the device
         */
        void bluetoothDiscoverDevice(BluetoothDevice device);

        /**
         * Device fail to connect.
         *
         * @param errorMessage the error message
         */
        void deviceFailToConnect(String errorMessage);

        /**
         * Device connected.
         *
         * @param btSocket the bt socket
         */
        void deviceConnected(BluetoothSocket btSocket);
    }

    private static final class IncomingHandler extends Handler {
        private final BluetoothDeviceManager bluetoothDeviceManager;

        /**
         * Instantiates a new Incoming handler.
         *
         * @param bluetoothDeviceManager the bluetooth device manager
         */
        public IncomingHandler(BluetoothDeviceManager bluetoothDeviceManager) {
            this.bluetoothDeviceManager = bluetoothDeviceManager;
        }

        @Override
        public void handleMessage(@NonNull Message msg) {
            super.handleMessage(msg);
            if (this.bluetoothDeviceManager.isBlueToothDevicesListener()) {
                if (msg.what == 1) {
                    bluetoothDeviceManager.blueToothDevicesListener.deviceConnected((BluetoothSocket) msg.obj);
                } else {
                    bluetoothDeviceManager.blueToothDevicesListener.deviceFailToConnect((String) msg.obj);
                }
            }
        }
    }

    private class ConnectThread extends Thread {

        /**
         * Instantiates a new Connect thread.
         *
         * @param device the device
         */
        public ConnectThread(BluetoothDevice device) {
            // Use a temporary object that is later assigned to mmSocket
            // because mmSocket is final.
            BluetoothSocket tmp = null;
            try {
                // Get a BluetoothSocket to connect with the given BluetoothDevice.
                // MY_UUID is the app's UUID string, also used in the server code.
                tmp = device.createRfcommSocketToServiceRecord(MY_UUID);
            } catch (IOException e) {
                if (isBlueToothDevicesListener()) {
                    blueToothDevicesListener.deviceFailToConnect("Socket's creation failed");
                }
            }
            btSocket = tmp;
        }

        public void run() {
            // Cancel discovery because it otherwise slows down the connection.
            if (bluetoothAdapter.isDiscovering()) {
                bluetoothAdapter.cancelDiscovery();
            }

            try {
                // Connect to the remote device through the socket. This call blocks
                // until it succeeds or throws an exception.
                Thread.sleep(2000);
                if (btSocket != null) {
                    btSocket.connect();
                } else {
                    if (isBlueToothDevicesListener()) {
                        blueToothDevicesListener.deviceFailToConnect("Socket not available, " + "device " + "connection fail");
                    }
                    return;
                }
            } catch (IOException | InterruptedException e) {
                // Unable to connect; close the socket and return.
                e.printStackTrace();
                cancel();
                if (e instanceof IOException) {
                    sendResult(null, "Read failed, socket might closed or timeout or already " + "connected to other device.");
                } else {
                    sendResult(null, e.getMessage());
                    Thread.currentThread().interrupt();
                }
                return;
            }

            // The connection attempt succeeded. Perform work associated with
            // the connection in a separate thread.
            sendResult(btSocket, "");
        }

        /**
         * Cancel.
         */
// Closes the client socket and causes the thread to finish.
        public void cancel() {
            try {
                if (btSocket != null) {
                    btSocket.close();
                }
            } catch (IOException e) {
                Utilities.printLog("Could not close the client socket", e.getMessage());
            }
        }

        private void sendResult(BluetoothSocket bluetoothSocket, String message) {
            Message message1 = incomingHandler.obtainMessage();
            if (bluetoothSocket == null) {
                message1.what = 0;
                message1.obj = message;
            } else if (bluetoothSocket.isConnected()) {
                if (bluetoothSocket.getRemoteDevice().getBondState() == BluetoothDevice.BOND_NONE) {
                    message1.what = 0;
                    message1.obj = "Please pair bluetooth device from system setting";
                } else if (bluetoothSocket.getRemoteDevice().getBondState() == BluetoothDevice.BOND_BONDING) {
                    message1.what = 0;
                    message1.obj = bluetoothSocket.getRemoteDevice().getName() + "device " + "connecting...";
                } else {
                    message1.what = 1;
                    message1.obj = bluetoothSocket;
                    try {
                        bTInputStream = bluetoothSocket.getInputStream();
                        bTOutputStream = bluetoothSocket.getOutputStream();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }


                }
            } else {
                message1.what = 0;
                message1.obj = bluetoothSocket.getRemoteDevice().getName() + "device not connected";
            }
            incomingHandler.sendMessage(message1);
        }
    }
}
