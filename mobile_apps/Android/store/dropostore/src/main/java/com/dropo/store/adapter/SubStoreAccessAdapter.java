package com.dropo.store.adapter;

import static com.dropo.store.models.singleton.SubStoreAccess.PERMISSION_GRANTED;
import static com.dropo.store.models.singleton.SubStoreAccess.PERMISSION_NOT_GRANTED;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.AddSubStoreActivity;
import com.dropo.store.models.datamodel.SubStoreAccessService;


import java.util.List;

public class SubStoreAccessAdapter extends RecyclerView.Adapter<SubStoreAccessAdapter.SubStoreAccessHolder> {

    private final List<SubStoreAccessService> subStoreAccessServices;
    private final AddSubStoreActivity addSubStoreActivity;

    public SubStoreAccessAdapter(AddSubStoreActivity addSubStoreActivity, List<SubStoreAccessService> subStoreAccessServices) {
        this.subStoreAccessServices = subStoreAccessServices;
        this.addSubStoreActivity = addSubStoreActivity;
        isHavePermission();
    }

    @NonNull
    @Override
    public SubStoreAccessHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new SubStoreAccessHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_sub_store_access, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull final SubStoreAccessHolder holder, final int position) {
        holder.cbAccess.setText(subStoreAccessServices.get(position).getName());
        holder.cbAccess.setChecked(subStoreAccessServices.get(position).getPermission() == PERMISSION_GRANTED);
        holder.cbAccess.setOnClickListener(v -> {
            subStoreAccessServices.get(holder.getAbsoluteAdapterPosition()).setPermission(holder.cbAccess.isChecked() ? PERMISSION_GRANTED : PERMISSION_NOT_GRANTED);
            isHavePermission();
        });
    }

    @Override
    public int getItemCount() {
        return subStoreAccessServices == null ? 0 : subStoreAccessServices.size();
    }

    public List<SubStoreAccessService> getSubStoreAccessServices() {
        return subStoreAccessServices;
    }

    private void isHavePermission() {
        boolean isHavePermission = false;
        for (SubStoreAccessService subStoreAccessService : subStoreAccessServices) {
            if (subStoreAccessService.getPermission() == PERMISSION_GRANTED) {
                isHavePermission = true;
                break;
            }
        }
        addSubStoreActivity.enableSaveButton(isHavePermission);
    }

    protected static class SubStoreAccessHolder extends RecyclerView.ViewHolder {
        CheckBox cbAccess;

        public SubStoreAccessHolder(@NonNull View itemView) {
            super(itemView);
            cbAccess = itemView.findViewById(R.id.cbAccess);
        }
    }
}