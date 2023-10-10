package com.dropo.adapter;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;

public class UserMenuAdapter extends RecyclerView.Adapter<UserMenuAdapter.UserViewHolder> {

    private final Context context;
    private final TypedArray userItemTitle;
    private final TypedArray userItemIcon;

    public UserMenuAdapter(Context context) {
        userItemTitle = context.getResources().obtainTypedArray(R.array.user_menu_item);
        userItemIcon = context.getResources().obtainTypedArray(R.array.user_menu_icons);
        this.context = context;
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
        ViewGroup.LayoutParams layoutParams = holder.itemView.getLayoutParams();
        if (userItemTitle.length() - 1 == position && TextUtils.equals(userItemTitle.getString(position), context.getResources().getString(R.string.text_book_taxi))) {
            if (TextUtils.equals(context.getPackageName(), "com.elluminati.edelivery")) {
                layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                holder.itemView.setVisibility(View.VISIBLE);
                holder.itemView.setLayoutParams(layoutParams);
            } else {
                layoutParams.height = 0;
                holder.itemView.setVisibility(View.GONE);
                holder.itemView.setLayoutParams(layoutParams);
            }
        } else {
            layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
            holder.itemView.setVisibility(View.VISIBLE);
            holder.itemView.setLayoutParams(layoutParams);
        }
        if (getItemCount() - 1 == position) {
            holder.divMenu.setVisibility(View.GONE);
        } else {
            holder.divMenu.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public int getItemCount() {
        return userItemTitle.length();
    }

    protected static class UserViewHolder extends RecyclerView.ViewHolder {
        CustomFontTextView tvUserItemTitle;
        ImageView ivUserItemIcon;
        View divMenu;

        public UserViewHolder(View itemView) {
            super(itemView);
            divMenu = itemView.findViewById(R.id.divMenu);
            tvUserItemTitle = itemView.findViewById(R.id.tvUserItemTitle);
            ivUserItemIcon = itemView.findViewById(R.id.ivUserItemIcon);
        }
    }
}