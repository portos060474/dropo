package com.dropo.adapter;

import android.annotation.SuppressLint;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.utils.AppColor;

import java.util.ArrayList;

public abstract class TableAdapter extends RecyclerView.Adapter<TableAdapter.TableViewHolder> {
    private final ArrayList<String> tableNumbers;
    private Context context;
    private String selected = "";
    private int selectedPosition;

    public TableAdapter(ArrayList<String> tableNumbers) {
        this.tableNumbers = tableNumbers;
    }

    @NonNull
    @Override
    public TableViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        context = parent.getContext();
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_number, parent, false);
        return new TableViewHolder(view);
    }

    @Override
    public void onBindViewHolder(TableViewHolder holder, int position) {
        holder.tvNumber.setText(tableNumbers.get(position));
        if (TextUtils.equals(selected, tableNumbers.get(position))) {
            holder.tvNumber.setBackground(ContextCompat.getDrawable(context, R.drawable.circle_theme));
            holder.tvNumber.setTextColor(AppColor.getThemeColor(context, R.attr.appThemeModeColor));
        } else {
            holder.tvNumber.setBackground(ContextCompat.getDrawable(context, R.drawable.circle_holo));
            holder.tvNumber.setTextColor(AppColor.getThemeColor(context, R.attr.appThemeModeTextColor));
        }
    }

    @Override
    public int getItemCount() {
        return tableNumbers.size();
    }

    public abstract void onChooseNumber(String number, int position);

    public String getSelected() {
        return selected;
    }

    public int getSelectedPosition() {
        return selectedPosition;
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setSelected(String selected) {
        this.selected = selected;
        notifyDataSetChanged();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void resetTable() {
        selected = "";
        notifyDataSetChanged();
    }

    @SuppressLint("NotifyDataSetChanged")
    public void setTables(ArrayList<String> filteredTables) {
        tableNumbers.clear();
        selected = "";
        tableNumbers.addAll(filteredTables);
        notifyDataSetChanged();
    }

    protected class TableViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        CustomFontTextView tvNumber;

        public TableViewHolder(View itemView) {
            super(itemView);
            tvNumber = itemView.findViewById(R.id.tvNumber);
            tvNumber.setOnClickListener(this);
        }

        @SuppressLint("NotifyDataSetChanged")
        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.tvNumber) {
                selected = tableNumbers.get(getAbsoluteAdapterPosition());
                selectedPosition = getAbsoluteAdapterPosition();
                onChooseNumber(tableNumbers.get(getAbsoluteAdapterPosition()), getAbsoluteAdapterPosition());
                notifyDataSetChanged();
            }
        }
    }
}