package com.dropo.store.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Invoice;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class OrderInvoiceAdapter extends RecyclerView.Adapter<OrderInvoiceAdapter.InvoiceViewHolder> {

    private final ArrayList<Invoice> invoices;
    private Context context;

    public OrderInvoiceAdapter(ArrayList<Invoice> invoices) {
        this.invoices = invoices;
    }

    @NonNull
    @Override
    public InvoiceViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_invoice_raw_item, parent, false);
        return new InvoiceViewHolder(view);
    }

    @Override
    public void onBindViewHolder(InvoiceViewHolder holder, int position) {
        holder.tvInvoiceTitle.setText(invoices.get(position).getTitle());
        holder.tvSubInvoiceTitle.setText(invoices.get(position).getSubTitle());
        holder.tvInvoicePrice.setText(invoices.get(position).getPrice());
        if (TextUtils.equals(context.getResources().getString(R.string.text_total_item_cost), invoices.get(position).getTitle()) || TextUtils.equals(context.getResources().getString(R.string.text_total_service_cost), invoices.get(position).getTitle())) {
            holder.tvInvoicePrice.setFontStyle(context, CustomTextView.BOLD);
            holder.tvInvoiceTitle.setFontStyle(context, CustomTextView.BOLD);
            holder.tvInvoiceTitle.setAllCaps(true);
        }
    }

    @Override
    public int getItemCount() {
        return invoices.size();
    }

    protected static class InvoiceViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvInvoiceTitle, tvSubInvoiceTitle, tvInvoicePrice;

        public InvoiceViewHolder(View itemView) {
            super(itemView);
            tvInvoicePrice = itemView.findViewById(R.id.tvInvoicePrice);
            tvInvoiceTitle = itemView.findViewById(R.id.tvInvoiceTitle);
            tvSubInvoiceTitle = itemView.findViewById(R.id.tvSubInvoiceTitle);
        }
    }
}