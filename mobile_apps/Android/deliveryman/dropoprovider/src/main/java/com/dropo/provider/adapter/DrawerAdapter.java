package com.dropo.provider.adapter;

import android.content.Context;
import android.content.res.TypedArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.utils.AppColor;

public abstract class DrawerAdapter extends RecyclerView.Adapter<DrawerAdapter.DrawerItemHolder> {

    private final Context context;
    private final TypedArray drawerItemTitle, drawerItemIcon;
    private int selectedPosition = 0;

    public DrawerAdapter(Context context) {
        this.context = context;
        drawerItemTitle = context.getResources().obtainTypedArray(R.array.drawer_menu_item);
        drawerItemIcon = context.getResources().obtainTypedArray(R.array.drawer_menu_icons);
    }

    @NonNull
    @Override
    public DrawerItemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.drawer_item, parent, false);
        return new DrawerItemHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull DrawerItemHolder holder, int position) {
        holder.tvDrawerItemText.setText(drawerItemTitle.getString(position));
        holder.ivDrawerIcon.setImageDrawable(ResourcesCompat.getDrawable(context.getResources(), drawerItemIcon.getResourceId(position, R.drawable.ic_man_user_stroke), context.getTheme()));
        if (position == selectedPosition) {
            holder.ivDrawerIcon.getDrawable().setTint(AppColor.COLOR_THEME);
            holder.tvDrawerItemText.setTextColor(AppColor.COLOR_THEME);
        } else {
            holder.ivDrawerIcon.getDrawable().setTint(AppColor.getThemeTextColor(context));
            holder.tvDrawerItemText.setTextColor(AppColor.getThemeTextColor(context));
        }

        holder.itemView.setOnClickListener(view -> {
            if (holder.getAbsoluteAdapterPosition() != 1) { // no need to change selected for earning screen.
                selectedPosition = holder.getAbsoluteAdapterPosition();
            }
            onDrawerItemClick(position);
        });
    }

    @Override
    public int getItemCount() {
        return drawerItemIcon.length();
    }

    public abstract void onDrawerItemClick(int position);

    protected static class DrawerItemHolder extends RecyclerView.ViewHolder {
        ImageView ivDrawerIcon;
        TextView tvDrawerItemText;

        public DrawerItemHolder(@NonNull View itemView) {
            super(itemView);
            ivDrawerIcon = itemView.findViewById(R.id.ivDrawerIcon);
            tvDrawerItemText = itemView.findViewById(R.id.tvDrawerItemText);
        }
    }
}