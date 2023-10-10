package com.dropo.store.adapter;

import android.content.Context;
import android.content.res.TypedArray;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.utils.PreferenceHelper;


public class ProfileMenuAdapter extends RecyclerView.Adapter<ProfileMenuAdapter.ViewHolder> {

    private final Context context;
    private final TypedArray menuItemList;
    private final TypedArray menuItemListName;

    public ProfileMenuAdapter(Context context) {
        this.context = context;
        menuItemList = context.getResources().obtainTypedArray(R.array.profileMenuIcon);
        menuItemListName = context.getResources().obtainTypedArray(R.array.profileMenuItem);
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.adapter_profile_menu, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        holder.ivMenuIcon.setImageDrawable(ResourcesCompat.getDrawable(context.getResources(), menuItemList.getResourceId(position, R.drawable.ic_man_user_stroke), context.getTheme()));
        holder.tvMenuName.setText(menuItemListName.getString(position));

        if (isBankDetailTabHide(position) || isPaymentTabHide(position) || isDocumentTabHide(position) || isProfileTabHide(position) || isSubStoreTabHide(position) || isPromoTabHide(position) || isCreateOrderTabHide(position) || isGroupTabHide(position) || isSettingsTabHide(position) || isHistoryTabHide(position) || isEarningTabHide(position)) {
            RecyclerView.LayoutParams layoutParams = (RecyclerView.LayoutParams) holder.itemView.getLayoutParams();
            layoutParams.height = 0;
            layoutParams.topMargin = 0;
            holder.itemView.setLayoutParams(layoutParams);
            holder.itemView.setVisibility(View.GONE);
        } else {
            RecyclerView.LayoutParams layoutParams = (RecyclerView.LayoutParams) holder.itemView.getLayoutParams();
            layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
            layoutParams.topMargin = context.getResources().getDimensionPixelOffset(R.dimen.card_view_space_12dp);
            holder.itemView.setLayoutParams(layoutParams);
            holder.itemView.setVisibility(View.VISIBLE);
        }

    }

    @Override
    public int getItemCount() {
        return menuItemList.length();
    }

    private boolean isPromoTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_promo)) && !(PreferenceHelper.getPreferenceHelper(context).getIsStoreAddPromoCode() && SubStoreAccess.getInstance().isAccess(SubStoreAccess.PROMO_CODE));
    }

    private boolean isCreateOrderTabHide(int position) {
        return (TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_create_order)) || TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_instant_order))) && !(PreferenceHelper.getPreferenceHelper(context).getIsStoreCreateOrder() && SubStoreAccess.getInstance().isAccess(SubStoreAccess.CREATE_ORDER));
    }

    private boolean isGroupTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_group_of_category)) && !(PreferenceHelper.getPreferenceHelper(context).getIsStoreCanCreateGroup() && SubStoreAccess.getInstance().isAccess(SubStoreAccess.GROUP));
    }

    private boolean isHistoryTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_history)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.HISTORY);
    }

    private boolean isEarningTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_earning)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.EARNING);
    }

    private boolean isSettingsTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_settings)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SETTING);
    }

    private boolean isProfileTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_profile)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SUB_STORE);
    }

    private boolean isSubStoreTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_sub_store)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SUB_STORE);
    }

    private boolean isDocumentTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_document)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SUB_STORE);
    }

    private boolean isPaymentTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_payments)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SUB_STORE);
    }

    private boolean isBankDetailTabHide(int position) {
        return TextUtils.equals(menuItemListName.getString(position), context.getResources().getString(R.string.text_bank_details)) && !SubStoreAccess.getInstance().isAccess(SubStoreAccess.SUB_STORE);
    }

    protected static class ViewHolder extends RecyclerView.ViewHolder {
        TextView tvMenuName;
        ImageView ivMenuIcon;

        ViewHolder(View itemView) {
            super(itemView);
            tvMenuName = itemView.findViewById(R.id.tvMenuName);
            ivMenuIcon = itemView.findViewById(R.id.ivMenuIcon);
        }
    }
}