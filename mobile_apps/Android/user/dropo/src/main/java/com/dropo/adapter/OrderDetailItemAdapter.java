package com.dropo.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomFontTextViewTitle;
import com.dropo.models.datamodels.CartProductItems;
import com.dropo.parser.ParseContent;
import com.dropo.utils.Const;
import com.dropo.utils.GlideApp;
import com.dropo.utils.ImageHelper;
import com.dropo.utils.PreferenceHelper;
import com.dropo.utils.SectionedRecyclerViewAdapter;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.List;

public class OrderDetailItemAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final int categoryImageHeight;
    private final Context context;
    private final String currency;
    private final boolean isImageVisible;
    private final ImageHelper imageHelper;
    List<CartProductItems> itemList;
    private int itemImageWidth;
    private int deliveryType;

    public OrderDetailItemAdapter(Context context, List<CartProductItems> itemList, String currency, boolean isImageVisible) {
        this.context = context;
        this.itemList = itemList;
        this.currency = currency;
        this.isImageVisible = isImageVisible;
        imageHelper = new ImageHelper(context);
        int screenPadding = context.getResources().getDimensionPixelSize(R.dimen.activity_horizontal_padding); // screen padding
        itemImageWidth = context.getResources().getDisplayMetrics().widthPixels;
        itemImageWidth = ((itemImageWidth - (screenPadding * 5)) / 4);
        categoryImageHeight = (int) (itemImageWidth / ImageHelper.ASPECT_RATIO);
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
        ItemChildHeader itemChildHeader = (ItemChildHeader) holder;
        CartProductItems individualItem = itemList.get(section);

        if (deliveryType == Const.DeliveryType.COURIER) {
            itemChildHeader.itemView.setVisibility(View.GONE);
            itemChildHeader.itemView.getLayoutParams().width = 0;
            itemChildHeader.itemView.getLayoutParams().height = 0;
        } else {
            itemChildHeader.itemView.setVisibility(View.VISIBLE);
        }

        itemChildHeader.tvItemName.setText(individualItem.getItemName());
        if (individualItem.getTotalItemAndSpecificationPrice() > 0) {
            itemChildHeader.tvItemsPrice.setText(String.format("%s%s", currency, ParseContent.getInstance().decimalTwoDigitFormat.format(individualItem.getTotalItemAndSpecificationPrice())));
        }
        if (!individualItem.getImageUrl().isEmpty() && isImageVisible && PreferenceHelper.getInstance(context).getIsLoadProductImage()) {
            itemChildHeader.ivItems.getLayoutParams().height = categoryImageHeight;
            itemChildHeader.ivItems.getLayoutParams().width = itemImageWidth;
            GlideApp.with(context).load(imageHelper.getImageUrlAccordingSize(individualItem.getImageUrl().get(0), itemChildHeader.ivItems)).dontAnimate().placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null)).fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null)).into(itemChildHeader.ivItems);
            itemChildHeader.ivItems.setVisibility(View.VISIBLE);
        } else {
            itemChildHeader.ivItems.setVisibility(View.GONE);
        }
        if (individualItem.getItemPrice() + individualItem.getTotalSpecificationPrice() > 0) {
            itemChildHeader.tvItemCounts.setText(String.format("%s %s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity() + " X " + currency + ParseContent.getInstance().decimalTwoDigitFormat.format(individualItem.getItemPrice() + individualItem.getTotalSpecificationPrice())));
        } else {
            itemChildHeader.tvItemCounts.setText(String.format("%s%s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity()));
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder holder, int section, int relativePosition, int absolutePosition) {
        ItemFooter itemFooter = (ItemFooter) holder;
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);

        OrderDetailSpecificationAdapter adapter = new OrderDetailSpecificationAdapter(itemList.get(section).getSpecifications(), currency);
        itemFooter.root_recycler.setLayoutManager(layoutManager);
        itemFooter.root_recycler.setAdapter(adapter);

        String itemNote = itemList.get(section).getItemNote();
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
                return new ItemChildHeader(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_oreder_detail_section, parent, false));
            case VIEW_TYPE_ITEM:
                return new ItemFooter(LayoutInflater.from(parent.getContext()).inflate(R.layout.item_order_detail_items, parent, false));
        }
        return null;
    }

    public void setDeliveryType(int deliveryType) {
        this.deliveryType = deliveryType;
    }

    protected static class ItemChildHeader extends RecyclerView.ViewHolder {
        RoundedImageView ivItems;
        CustomFontTextView tvItemCounts;
        CustomFontTextViewTitle tvItemName, tvItemsPrice;

        public ItemChildHeader(View itemView) {
            super(itemView);
            ivItems = itemView.findViewById(R.id.ivItems);
            tvItemName = itemView.findViewById(R.id.tvItemName);
            tvItemCounts = itemView.findViewById(R.id.tvItemCounts);
            tvItemsPrice = itemView.findViewById(R.id.tvItemsPrice);
        }
    }

    protected class ItemFooter extends RecyclerView.ViewHolder {
        RecyclerView root_recycler;
        CustomFontTextViewTitle tvItemNoteHeading;
        CustomFontTextView tvItemNote;

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
