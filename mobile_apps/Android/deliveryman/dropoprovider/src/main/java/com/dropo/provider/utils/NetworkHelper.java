package com.dropo.provider.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkRequest;
import android.os.Build;

import com.dropo.provider.BaseAppCompatActivity;

public class NetworkHelper {

    private static final NetworkHelper networkHelper = new NetworkHelper();
    private final NetworkRequest networkRequest;
    private final ConnectivityManager.NetworkCallback networkCallback;
    private ConnectivityManager connectivityManager;

    private BaseAppCompatActivity.NetworkListener networkAvailableListener;

    private NetworkHelper() {
        networkRequest = new NetworkRequest.Builder().build();
        networkCallback = new ConnectivityManager.NetworkCallback() {
            @Override
            public void onAvailable(Network network) {
                super.onAvailable(network);
                if (networkAvailableListener != null) {
                    networkAvailableListener.onNetworkChange(true);
                }

            }

            @Override
            public void onUnavailable() {
                super.onUnavailable();
               /* if (networkAvailableListener != null) {
                    networkAvailableListener.onNetworkChange(false);
                }*/
            }

            @Override
            public void onLost(Network network) {
                super.onLost(network);
                if (networkAvailableListener != null) {
                    networkAvailableListener.onNetworkChange(false);
                }
            }
        };
    }

    public static NetworkHelper getInstance() {
        return networkHelper;
    }

    public void initConnectivityManager(Context context) {
        if (connectivityManager == null) {
            connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
            if (connectivityManager != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    connectivityManager.registerDefaultNetworkCallback(networkCallback);
                } else {
                    connectivityManager.registerNetworkCallback(networkRequest, networkCallback);
                }
            }
        }
    }

    public void setNetworkAvailableListener(BaseAppCompatActivity.NetworkListener networkAvailableListener) {
        this.networkAvailableListener = networkAvailableListener;
    }
}