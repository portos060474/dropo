package com.dropo.provider.adapter;

import static com.dropo.provider.utils.ServerConfig.IMAGE_URL;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.models.datamodels.OrderProductItem;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.GlideApp;
import com.dropo.provider.utils.SectionedRecyclerViewAdapter;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.List;

public class OrderDetailItemAdapter extends SectionedRecyclerViewAdapter<RecyclerView.ViewHolder> {

    private final Context context;
    private final String currency;
    private final boolean isImageVisible;
    private final List<OrderProductItem> itemList;
    private int deliveryType;

    public OrderDetailItemAdapter(Context context, List<OrderProductItem> itemList, String currency, boolean isImageVisible) {
        this.context = context;
        this.itemList = itemList;
        this.currency = currency;
        this.isImageVisible = isImageVisible;
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
        OrderProductItem individualItem = itemList.get(section);

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
        if (!individualItem.getImageUrl().isEmpty() && isImageVisible) {
            GlideApp.with(context)
                    .load(IMAGE_URL + individualItem.getImageUrl().get(0))
                    .dontAnimate()
                    .placeholder(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .fallback(ResourcesCompat.getDrawable(context.getResources(), R.drawable.placeholder, null))
                    .into(itemChildHeader.ivItems);
            itemChildHeader.ivItems.setVisibility(View.VISIBLE);
        } else {
            itemChildHeader.ivItems.setVisibility(View.GONE);
        }
        if (individualItem.getItemPrice() + individualItem.getTotalSpecificationPrice() > 0) {
            itemChildHeader.tvItemCounts.setText(String.format("%s %s X %s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity(), currency + ParseContent.getInstance().decimalTwoDigitFormat.format(individualItem.getItemPrice() + individualItem.getTotalSpecificationPrice())));
        } else {
            itemChildHeader.tvItemCounts.setText(String.format("%s%s", context.getResources().getString(R.string.text_qty), individualItem.getQuantity()));
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

        OrderDetailSpecificationAdapter adapter = new OrderDetailSpecificationAdapter(itemList.get(section).getSpecifications(), currency);
        itemFooter.rootRecycler.setLayoutManager(layoutManager);
        itemFooter.rootRecycler.setAdapter(adapter);

        String itemNote = itemList.get(absolutePosition).getNoteForItem();
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
        View ivListDivider;
        TextView tvItemCounts;
        TextView tvItemName, tvItemsPrice;

        public ItemChildHeader(View itemView) {
            super(itemView);
            ivItems = itemView.findViewById(R.id.ivItems);
            tvItemName = itemView.findViewById(R.id.tvItemName);
            tvItemCounts = itemView.findViewById(R.id.tvItemCounts);
            tvItemsPrice = itemView.findViewById(R.id.tvItemsPrice);
            ivListDivider = itemView.findViewById(R.id.ivListDivider);
        }
    }

    protected class ItemFooter extends RecyclerView.ViewHolder {
        RecyclerView rootRecycler;
        TextView tvItemNoteHeading;
        TextView tvItemNote;

        public ItemFooter(View itemView) {
            super(itemView);
            rootRecycler = itemView.findViewById(R.id.rootRecycler);
            RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);
            rootRecycler.setLayoutManager(layoutManager);
            tvItemNote = itemView.findViewById(R.id.tvItemNote);
            tvItemNoteHeading = itemView.findViewById(R.id.tvItemNoteHeading);
        }
    }
}