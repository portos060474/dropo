package com.dropo.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioButton;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontEditTextView;
import com.google.android.material.textfield.TextInputLayout;

import java.util.List;
import java.util.Objects;

public abstract class CancellationReasonAdapter extends RecyclerView.Adapter<CancellationReasonAdapter.CancellationReasonViewHolder> {

    private final List<String> reasonsList;

    private RadioButton lastChecked = null;
    private int lastSelectedPosition = -1;

    public CancellationReasonAdapter(List<String> reasonsList) {
        this.reasonsList = reasonsList;
    }

    @NonNull
    @Override
    public CancellationReasonViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_cancel_reason, parent, false);
        return new CancellationReasonViewHolder(view);
    }

    @Override
    public void onBindViewHolder(CancellationReasonViewHolder holder, int position) {
        String reason = reasonsList.get(position);
        holder.rbReason.setText(reason);

        holder.rbReason.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                onReasonSelected(holder.getAbsoluteAdapterPosition());
            }

            if (lastChecked == null && lastSelectedPosition == -1) {
                lastChecked = holder.rbReason;
                lastSelectedPosition = holder.getAbsoluteAdapterPosition();
            } else {
                Objects.requireNonNull(lastChecked).setChecked(false);
            }

            if (position == reasonsList.size() - 1 && isChecked) {
                holder.tilOtherReason.setVisibility(View.VISIBLE);
            } else {
                holder.tilOtherReason.setVisibility(View.GONE);
            }

            lastSelectedPosition = holder.getAbsoluteAdapterPosition();
            lastChecked = holder.rbReason;
        });
    }

    public abstract void onReasonSelected(int position);

    @Override
    public int getItemCount() {
        return reasonsList == null ? 0 : reasonsList.size();
    }

    protected static class CancellationReasonViewHolder extends RecyclerView.ViewHolder {
        RadioButton rbReason;
        TextInputLayout tilOtherReason;
        CustomFontEditTextView etOthersReason;

        public CancellationReasonViewHolder(View itemView) {
            super(itemView);
            rbReason = itemView.findViewById(R.id.rbReason);
            tilOtherReason = itemView.findViewById(R.id.tilOtherReason);
            etOthersReason = itemView.findViewById(R.id.etOthersReason);
        }
    }
}