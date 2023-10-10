package com.dropo.store;

import static com.dropo.store.utils.ServerConfig.IMAGE_URL;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.Menu;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.dropo.store.adapter.ItemSpecificationAdapter;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.utils.Constant;

import java.util.ArrayList;

public class ItemDetailActivity extends BaseActivity {

    private final ArrayList<ItemSpecification> itemSpecifications = new ArrayList<>();
    private TextView tvItemName, tvItemDetail, tvToolbarTitle;
    private ImageView ivItem;
    private ItemSpecificationAdapter itemSpecificationAdapterList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_product_item_detail);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        tvToolbarTitle = findViewById(R.id.tvToolbarTitle);
        tvItemName = findViewById(R.id.tvName);
        tvItemDetail = findViewById(R.id.tvDetail);
        ivItem = findViewById(R.id.iv);
        RecyclerView rcItemSpecification = findViewById(R.id.rcSpecification);
        rcItemSpecification.setNestedScrollingEnabled(false);
        rcItemSpecification.setLayoutManager(new LinearLayoutManager(this));
        itemSpecificationAdapterList = new ItemSpecificationAdapter(this, itemSpecifications);
        rcItemSpecification.setAdapter(itemSpecificationAdapterList);
        setItemData();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    @SuppressLint("NotifyDataSetChanged")
    private void setItemData() {
        if (getIntent() != null && getIntent().getParcelableExtra(Constant.ITEM) != null) {
            Item item = getIntent().getParcelableExtra(Constant.ITEM);
            itemSpecifications.addAll(item.getSpecifications());

            tvItemName.setText(item.getName());
            tvItemDetail.setText(item.getDetails());
            if (item.getImageUrl() != null && !item.getImageUrl().isEmpty()) {
                Glide.with(this).load(IMAGE_URL + item.getImageUrl().get(0)).into(ivItem);
            }
            itemSpecificationAdapterList.notifyDataSetChanged();
            tvToolbarTitle.setText(item.getName());
        }
    }
}