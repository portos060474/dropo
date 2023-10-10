package com.dropo.provider.adapter;

import android.content.res.TypedArray;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.HomeActivity;
import com.dropo.provider.R;

public class UserMenuAdapter extends RecyclerView.Adapter<UserMenuAdapter.UserViewHolder> {

    private final TypedArray userItemTitle;
    private final TypedArray userItemIcon;

    public UserMenuAdapter(HomeActivity activity) {
        userItemTitle = activity.getResources().obtainTypedArray(R.array.user_menu_item);
        userItemIcon = activity.getResources().obtainTypedArray(R.array.user_menu_icons);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }

    @NonNull
    @Override
    public UserViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_user_menu, parent, false);
        return new UserViewHolder(view);
    }

    @Override
    public void onBindViewHolder(UserViewHolder holder, int position) {
        holder.ivUserItemIcon.setImageResource(userItemIcon.getResourceId(position, 0));
        holder.tvUserItemTitle.setText(userItemTitle.getString(position));
    }

    @Override
    public int getItemCount() {
        return userItemTitle.length();
    }

    protected static class UserViewHolder extends RecyclerView.ViewHolder {
        TextView tvUserItemTitle;
        ImageView ivUserItemIcon;

        public UserViewHolder(View itemView) {
            super(itemView);
            tvUserItemTitle = itemView.findViewById(R.id.tvUserItemTitle);
            ivUserItemIcon = itemView.findViewById(R.id.ivUserItemIcon);
        }
    }
}