package com.dropo.provider.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomFontTextView;
import com.dropo.provider.component.CustomFontTextViewTitle;
import com.dropo.provider.models.datamodels.Analytic;

import java.util.ArrayList;

public class OrderAnalyticAdapter extends RecyclerView.Adapter<OrderAnalyticAdapter.OrderAnalyticView> {

    private final ArrayList<Analytic> arrayListProviderAnalytic;

    public OrderAnalyticAdapter(ArrayList<Analytic> arrayListProviderAnalytic) {
        this.arrayListProviderAnalytic = arrayListProviderAnalytic;
    }

    @NonNull
    @Override
    public OrderAnalyticView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_analitic_item, parent, false);
        return new OrderAnalyticView(view);
    }

    @Override
    public void onBindViewHolder(OrderAnalyticView holder, int position) {
        holder.tvAnalyticName.setText(arrayListProviderAnalytic.get(position).getTitle());
        holder.tvAnalyticValue.setText(arrayListProviderAnalytic.get(position).getValue());
    }

    @Override
    public int getItemCount() {
        return arrayListProviderAnalytic.size();
    }

    protected static class OrderAnalyticView extends RecyclerView.ViewHolder {
        CustomFontTextView tvAnalyticValue;
        CustomFontTextViewTitle tvAnalyticName;

        public OrderAnalyticView(View itemView) {
            super(itemView);
            tvAnalyticValue = itemView.findViewById(R.id.tvAnalyticValue);
            tvAnalyticName = itemView.findViewById(R.id.tvAnalyticName);
        }
    }
}