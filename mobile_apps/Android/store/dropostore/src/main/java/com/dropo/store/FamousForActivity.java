package com.dropo.store;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.FamousTagAdapter;
import com.dropo.store.models.datamodel.FamousProductsTags;
import com.dropo.store.models.datamodel.StoreData;
import com.dropo.store.utils.Constant;
import com.dropo.store.widgets.CustomButton;


import java.util.ArrayList;

public class FamousForActivity extends BaseActivity {

    private RecyclerView rcvFamousTag;
    private CustomButton btnDone;
    private FamousTagAdapter famousTagAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_famous_for);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_famous_for));
        btnDone = findViewById(R.id.btnDone);
        btnDone.setOnClickListener(this);
        initRcvTag();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    private void initRcvTag() {
        StoreData storeData = getIntent().getExtras().getParcelable(Constant.BUNDLE);
        ArrayList<FamousProductsTags> deliveryTag = new ArrayList<>();
        ArrayList<FamousProductsTags> storeTag = new ArrayList<>();
        if (storeData.getDeliveryDetails().getFamousProductsTags() != null) {
            deliveryTag.addAll(storeData.getDeliveryDetails().getFamousProductsTags());
        }
        if (storeData.getFamousProductsTagIds() != null && storeData.getDeliveryDetails().getFamousProductsTags() != null) {
            for (String tagId : storeData.getFamousProductsTagIds()) {
                for (FamousProductsTags famousProductsTags : storeData.getDeliveryDetails().getFamousProductsTags()) {
                    if (tagId.equalsIgnoreCase(famousProductsTags.getTagId()) && !storeTag.contains(famousProductsTags)) {
                        storeTag.add(famousProductsTags);
                    }
                }
            }
        }

        rcvFamousTag = findViewById(R.id.rcvFamousTag);
        rcvFamousTag.setLayoutManager(new LinearLayoutManager(this));
        famousTagAdapter = new FamousTagAdapter(deliveryTag, storeTag);
        rcvFamousTag.setAdapter(famousTagAdapter);
        rcvFamousTag.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.btnDone) {
            setResult(Activity.RESULT_OK, new Intent().putExtra(Constant.BUNDLE, famousTagAdapter.getStoreTagList()));
            finish();
        }
    }
}