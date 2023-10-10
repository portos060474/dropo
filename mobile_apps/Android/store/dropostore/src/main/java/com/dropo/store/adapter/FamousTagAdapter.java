package com.dropo.store.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.FamousProductsTags;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Utilities;


import java.util.ArrayList;

public class FamousTagAdapter extends RecyclerView.Adapter<FamousTagAdapter.FamousTagView> {

    private final ArrayList<FamousProductsTags> deliveryTagList;
    private final ArrayList<FamousProductsTags> storeTagList;

    public FamousTagAdapter(ArrayList<FamousProductsTags> deliveryTagList, ArrayList<FamousProductsTags> storeTagList) {
        this.deliveryTagList = deliveryTagList;
        this.storeTagList = storeTagList;
    }

    @NonNull
    @Override
    public FamousTagView onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_famous_tag, parent, false);
        return new FamousTagView(view);
    }

    @Override
    public void onBindViewHolder(FamousTagView holder, int position) {
        FamousProductsTags famousProductsTags = deliveryTagList.get(position);

        holder.tvFamousTag.setText(Utilities.getDetailStringFromList(famousProductsTags.getTag(),
                Language.getInstance().getAdminLanguageIndex()));
        holder.cbTag.setChecked(storeTagList.contains(deliveryTagList.get(position)));

        holder.cbTag.setOnClickListener(v -> {
            if (storeTagList.contains(famousProductsTags)) {
                storeTagList.remove(famousProductsTags);
            } else {
                storeTagList.add(famousProductsTags);
            }
        });
    }

    @Override
    public int getItemCount() {
        return deliveryTagList.size();
    }

    public ArrayList<String> getStoreTagList() {
        ArrayList<String> famousProductsTagIds = new ArrayList<>();
        for (FamousProductsTags famousProductsTags : storeTagList) {
            if (!famousProductsTagIds.contains(famousProductsTags.getTagId())) {
                famousProductsTagIds.add(famousProductsTags.getTagId());
            }
        }
        return famousProductsTagIds;
    }

    protected static class FamousTagView extends RecyclerView.ViewHolder {
        TextView tvFamousTag;
        CheckBox cbTag;

        public FamousTagView(View itemView) {
            super(itemView);
            tvFamousTag = itemView.findViewById(R.id.tvFamousTag);
            cbTag = itemView.findViewById(R.id.cbTag);
        }
    }
}