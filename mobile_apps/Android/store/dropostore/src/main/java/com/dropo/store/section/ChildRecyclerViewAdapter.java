package com.dropo.store.section;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.SectionedRecyclerViewAdapter;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;


import java.util.ArrayList;

public class ChildRecyclerViewAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final Context context;
    ArrayList<Item> itemList;

    public ChildRecyclerViewAdapter(Context context, ArrayList<Item> itemList) {
        this.context = context;
        this.itemList = itemList;
    }

    @Override
    public int getSectionCount() {
        return itemList.size();
    }

    @Override
    public int getItemCount(int section) {
        return 1;
    }

    @Override
    public void onBindHeaderViewHolder(RecyclerView.ViewHolder holder, int section) {
        final ItemChildHeader itemChildHeader = (ItemChildHeader) holder;
        Item individualItem = itemList.get(section);
        itemChildHeader.tvItemName.setText(individualItem.getItemName());
        if (individualItem.getTotalItemAndSpecificationPrice() > 0) {
            itemChildHeader.tvItemsPrice.setText(String.format("%s%s", PreferenceHelper.getPreferenceHelper(context).getCurrency(), ParseContent.getInstance().decimalTwoDigitFormat.format(individualItem.getTotalItemAndSpecificationPrice())));
        }

        if (individualItem.getItemPrice() + individualItem.getItemPrice() > 0) {
            itemChildHeader.tvItemCounts.setText(String.format("%s %s X %s%s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity(), PreferenceHelper.getPreferenceHelper(context).getCurrency(), ParseContent.getInstance().decimalTwoDigitFormat.format(individualItem.getItemPrice())));
        } else {
            itemChildHeader.tvItemCounts.setText(String.format("%s %s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity()));
        }

        if (0 == section) {
            itemChildHeader.ivListDivider.setVisibility(View.GONE);
        } else {
            itemChildHeader.ivListDivider.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemFooter itemFooter = (ItemFooter) holder;
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);

        ChildSpecificationViewAdapter adapter = new ChildSpecificationViewAdapter(context, itemList.get(section).getSpecifications());
        itemFooter.root_recycler.setLayoutManager(layoutManager);
        itemFooter.root_recycler.setAdapter(adapter);

        String itemNote = itemList.get(section).getNoteForItem();
        if (TextUtils.isEmpty(itemNote)) {
            itemFooter.tvItemNote.setVisibility(View.GONE);
            itemFooter.tvItemNoteHeading.setVisibility(View.GONE);
        } else {
            itemFooter.tvItemNote.setVisibility(View.VISIBLE);
            itemFooter.tvItemNoteHeading.setVisibility(View.VISIBLE);
            itemFooter.tvItemNote.setText(itemNote);
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new ItemChildHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.adapter_item_oreder_detail, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemFooter(LayoutInflater.from(parent.getContext()).inflate(R.layout.root_recycler, parent, false));

        }
        return null;
    }

    protected static class ItemChildHeader extends RecyclerView.ViewHolder {
        View ivListDivider;
        CustomTextView tvItemCounts;
        CustomFontTextViewTitle tvItemName, tvItemsPrice;

        public ItemChildHeader(View itemView) {
            super(itemView);
            tvItemName = itemView.findViewById(R.id.tvItemName);
            tvItemCounts = itemView.findViewById(R.id.tvItemCounts);
            tvItemsPrice = itemView.findViewById(R.id.tvItemsPrice);
            ivListDivider = itemView.findViewById(R.id.ivListDivider);
        }
    }

    protected class ItemFooter extends RecyclerView.ViewHolder {
        RecyclerView root_recycler;
        CustomFontTextViewTitle tvItemNoteHeading;
        CustomTextView tvItemNote;

        public ItemFooter(View itemView) {
            super(itemView);
            root_recycler = itemView.findViewById(R.id.root_recycler);
            RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);
            root_recycler.setLayoutManager(layoutManager);
            tvItemNote = itemView.findViewById(R.id.tvItemNote);
            tvItemNoteHeading = itemView.findViewById(R.id.tvItemNoteHeading);
        }
    }
}