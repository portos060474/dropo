package com.dropo.store.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Invoice;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class InvoiceAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final ArrayList<ArrayList<Invoice>> invoices;
    private Context context;
    private boolean showFirstSection;

    public InvoiceAdapter(ArrayList<ArrayList<Invoice>> invoices) {
        this.invoices = invoices;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new InvoiceViewHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_invoice_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new InvoiceViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_invoice_raw_item, parent, false));
            default:
                break;
        }
        return null;
    }


    @Override
    public int getSectionCount() {
        return invoices.size();
    }

    @Override
    public int getItemCount(int section) {
        return invoices.get(section).size();
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        InvoiceViewHeader invoiceViewHolder = (InvoiceViewHeader) holder;
        invoiceViewHolder.tvTag.setText(invoices.get(section).get(0).getTagTitle());

        if (section == 0 && !showFirstSection) {
            invoiceViewHolder.itemView.setVisibility(View.GONE);
            invoiceViewHolder.itemView.getLayoutParams().height = 0;
        } else {
            invoiceViewHolder.itemView.setVisibility(View.VISIBLE);
            invoiceViewHolder.itemView.getLayoutParams().height = WindowManager.LayoutParams.WRAP_CONTENT;
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        InvoiceViewHolder invoiceViewHolder = (InvoiceViewHolder) holder;
        invoiceViewHolder.tvInvoiceTitle.setText(invoices.get(section).get(relativePosition).getTitle());
        invoiceViewHolder.tvSubInvoiceTitle.setText(invoices.get(section).get(relativePosition).getSubTitle());
        invoiceViewHolder.tvInvoicePrice.setText((invoices.get(section).get(relativePosition).getPrice()));

        if (TextUtils.equals(context.getResources().getString(R.string.text_total_item_cost), invoices.get(section).get(relativePosition).getTitle()) || TextUtils.equals(context.getResources().getString(R.string.text_total_service_cost), invoices.get(section).get(relativePosition).getTitle())
                || TextUtils.equals(context.getResources().getString(R.string.text_promo), invoices.get(section).get(relativePosition).getTitle())) {
            invoiceViewHolder.tvInvoicePrice.setFontStyle(context, CustomTextView.BOLD);
            invoiceViewHolder.tvInvoiceTitle.setFontStyle(context, CustomTextView.BOLD);
            invoiceViewHolder.tvInvoiceTitle.setAllCaps(false);
        }
    }

    public void setShowFirstSection(boolean showFirstSection) {
        this.showFirstSection = showFirstSection;
    }

    public static class InvoiceViewHolder extends RecyclerView.ViewHolder {
        CustomTextView tvInvoiceTitle, tvSubInvoiceTitle, tvInvoicePrice;

        public InvoiceViewHolder(View itemView) {
            super(itemView);
            tvInvoicePrice = itemView.findViewById(R.id.tvInvoicePrice);
            tvInvoiceTitle = itemView.findViewById(R.id.tvInvoiceTitle);
            tvSubInvoiceTitle = itemView.findViewById(R.id.tvSubInvoiceTitle);
        }
    }

    protected static class InvoiceViewHeader extends RecyclerView.ViewHolder {
        CustomTextView tvTag;

        public InvoiceViewHeader(View itemView) {
            super(itemView);
            tvTag = itemView.findViewById(R.id.tvSection_root);
        }
    }
}