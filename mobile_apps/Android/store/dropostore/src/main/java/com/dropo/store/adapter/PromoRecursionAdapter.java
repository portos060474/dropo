package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.PromoRecursionData;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class PromoRecursionAdapter extends RecyclerView.Adapter<PromoRecursionAdapter.PromoRecursionDataHolder> {

    private final ArrayList<PromoRecursionData> dataArrayList;

    public PromoRecursionAdapter(ArrayList<PromoRecursionData> dataArrayList) {
        this.dataArrayList = dataArrayList;
    }

    @NonNull
    @Override
    public PromoRecursionDataHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_promo_recursion_data, parent, false);
        return new PromoRecursionDataHolder(view);
    }

    @Override
    public void onBindViewHolder(PromoRecursionDataHolder holder, int position) {
        holder.tvRecursionData.setText(dataArrayList.get(position).getDisplayData());
        holder.cbRecursionData.setChecked(dataArrayList.get(position).isSelected());
    }

    @Override
    public int getItemCount() {
        return dataArrayList.size();
    }

    protected static class PromoRecursionDataHolder extends RecyclerView.ViewHolder {
        private final CustomTextView tvRecursionData;
        private final CheckBox cbRecursionData;

        public PromoRecursionDataHolder(View itemView) {
            super(itemView);
            tvRecursionData = itemView.findViewById(R.id.tvRecursionData);
            cbRecursionData = itemView.findViewById(R.id.cbRecursionData);
        }
    }
}