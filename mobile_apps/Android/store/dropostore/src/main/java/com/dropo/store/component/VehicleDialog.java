package com.dropo.store.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RadioGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.VehicleAdapter;
import com.dropo.store.models.datamodel.VehicleDetail;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.RecyclerTouchListener;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.List;

public class VehicleDialog extends BottomSheetDialog {

    private final RecyclerView rcvVehicle;
    private final VehicleAdapter vehicleAdapter;
    private final TextView tvDriverAssign;
    private final RadioGroup radioGroup;
    private String vehicleId;

    public VehicleDialog(@NonNull Context context, final List<VehicleDetail> vehicleDetailList) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_vehicle_selecte);
        for (VehicleDetail vehicleDetail : vehicleDetailList) {
            vehicleDetail.setSelected(false);
        }
        rcvVehicle = findViewById(R.id.rcvVehicle);
        vehicleAdapter = new VehicleAdapter(context, vehicleDetailList);
        rcvVehicle.setLayoutManager(new LinearLayoutManager(context));
        rcvVehicle.setAdapter(vehicleAdapter);
        rcvVehicle.addOnItemTouchListener(new RecyclerTouchListener(context, rcvVehicle, new ClickListener() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onClick(View view, int position) {
                for (VehicleDetail vehicleDetail : vehicleDetailList) {
                    vehicleDetail.setSelected(false);
                }
                vehicleId = vehicleDetailList.get(position).getId();
                vehicleDetailList.get(position).setSelected(true);
                vehicleAdapter.notifyDataSetChanged();
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));

        radioGroup = findViewById(R.id.radioGroup);
        radioGroup.setEnabled(SubStoreAccess.getInstance().isAccess(SubStoreAccess.DELIVERIES));
        tvDriverAssign = findViewById(R.id.tvDriverAssign);

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(params);
        getBehavior().setState(BottomSheetBehavior.STATE_EXPANDED);
    }

    public String getVehicleId() {
        return vehicleId;
    }

    public void hideProviderManualAssign() {
        tvDriverAssign.setVisibility(View.GONE);
        radioGroup.setVisibility(View.GONE);
    }

    public boolean isManualAssign() {
        return radioGroup.getCheckedRadioButtonId() == R.id.rbManualAssign;
    }
}