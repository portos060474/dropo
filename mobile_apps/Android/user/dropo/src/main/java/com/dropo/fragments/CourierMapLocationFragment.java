package com.dropo.fragments;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatImageView;

import com.dropo.CreateCourierOrderActivity;
import com.dropo.user.R;
import com.dropo.component.CustomEventMapView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.Addresses;
import com.dropo.utils.Const;
import com.google.android.gms.maps.CameraUpdate;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.android.gms.maps.model.Polyline;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;
import com.google.maps.android.ui.IconGenerator;

import java.util.ArrayList;

public class CourierMapLocationFragment extends BottomSheetDialogFragment implements OnMapReadyCallback, View.OnClickListener {

    private Activity activity;
    private CreateCourierOrderActivity createCourierOrderActivity;

    private GoogleMap googleMap;
    private CustomEventMapView mapView;

    private AppCompatImageView ivClose;

    private boolean isOptimize;
    private final ArrayList<Addresses> addressesList = new ArrayList<>();
    private Polyline googlePathPolyline;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = getActivity();
        if (getActivity() instanceof CreateCourierOrderActivity) {
            createCourierOrderActivity = (CreateCourierOrderActivity) getActivity();
        }
        if (getArguments() != null) {
            addressesList.addAll(getArguments().getParcelableArrayList(Const.Params.ADDRESS));
            isOptimize = getArguments().getBoolean(Const.BUNDLE);
        }
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_courier_map_location, container, false);
        mapView = view.findViewById(R.id.mapView);
        ivClose = view.findViewById(R.id.ivClose);
        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        if (getDialog() instanceof BottomSheetDialog) {
            BottomSheetDialog dialog = (BottomSheetDialog) getDialog();
            BottomSheetBehavior<?> behavior = dialog.getBehavior();
            setCancelable(false);
            behavior.setDraggable(false);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        }

        mapView.onCreate(savedInstanceState);
        mapView.getMapAsync(this);

        ivClose.setOnClickListener(this);
    }

    @Override
    public void onMapReady(@NonNull GoogleMap googleMap) {
        this.googleMap = googleMap;
        setUpMap();
        if (!addressesList.isEmpty()) {
            ArrayList<LatLng> latLngList = new ArrayList<>();
            for (Addresses addresses : addressesList) {
                latLngList.add(new LatLng(addresses.getLocation().get(0), addresses.getLocation().get(1)));
            }
            setLocationBounds(latLngList);
            setMarkersOnMap(latLngList);
            drawPathOnMap();
        }
    }

    private void drawPathOnMap() {
        if (createCourierOrderActivity != null) {
            if (googlePathPolyline != null) {
                googlePathPolyline.remove();
            }
            if (isOptimize && createCourierOrderActivity.optimizePolylineOptions != null) {
                googlePathPolyline = googleMap.addPolyline(createCourierOrderActivity.optimizePolylineOptions);
            } else if (createCourierOrderActivity.polylineOptions != null){
                googlePathPolyline = googleMap.addPolyline(createCourierOrderActivity.polylineOptions);
            }
        }
    }

    @SuppressLint("PotentialBehaviorOverride")
    private void setUpMap() {
        this.googleMap.getUiSettings().setMyLocationButtonEnabled(true);
        this.googleMap.getUiSettings().setMapToolbarEnabled(false);
        this.googleMap.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
    }

    /**
     * This method is use to bound map as per total markers in map.
     *
     * @param latLngList   latLngList
     */
    private void setLocationBounds(ArrayList<LatLng> latLngList) {
        try {
            googleMap.setPadding(0, 0, 0, 0);
            LatLngBounds.Builder bounds = new LatLngBounds.Builder();
            int driverListSize = latLngList.size();
            for (int i = 0; i < driverListSize; i++) {
                bounds.include(latLngList.get(i));
            }
            DisplayMetrics displayMetrics = new DisplayMetrics();
            activity.getWindow().getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
            int height = displayMetrics.heightPixels;
            int width = displayMetrics.widthPixels;
            CameraUpdate cu = CameraUpdateFactory.newLatLngBounds(bounds.build(), width, height, (int) activity.getResources().getDimension(R.dimen.map_padding));
            googleMap.animateCamera(cu);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void setMarkersOnMap(ArrayList<LatLng> latLngList) {
        for (int i = 0; i < latLngList.size(); i++) {
            createMarker(new LatLng(latLngList.get(i).latitude, latLngList.get(i).longitude), String.valueOf(i + 1));
        }
    }

    protected void createMarker(LatLng latLng, String label) {
        BitmapDescriptor bitmapDescriptor = BitmapDescriptorFactory.fromBitmap(getMarkerIconWithLabel(label));
        googleMap.addMarker(new MarkerOptions().position(latLng).icon(bitmapDescriptor));
    }

    public Bitmap getMarkerIconWithLabel(String label) {
        IconGenerator iconGenerator = new IconGenerator(activity);
        @SuppressLint("InflateParams")
        View markerView = LayoutInflater.from(activity).inflate(R.layout.layout_custom_marker, null);
        CustomFontTextViewTitle tvLabel = markerView.findViewById(R.id.tvLabel);
        tvLabel.setText(label);
        iconGenerator.setContentView(markerView);
        iconGenerator.setBackground(null);
        return iconGenerator.makeIcon();
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        super.onSaveInstanceState(outState);
        if (mapView != null) {
            mapView.onSaveInstanceState(outState);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mapView != null) {
            mapView.onResume();
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        if (mapView != null) {
            mapView.onResume();
        }
    }

    @Override
    public void onStop() {
        super.onStop();
        if (mapView != null) {
            mapView.onStop();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (mapView != null) {
            mapView.onPause();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (mapView != null) {
            mapView.onDestroy();
        }
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.ivClose) {
            dismiss();
        }
    }
}
