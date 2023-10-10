package com.dropo.store.component;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.SpecificationGroupSelectedDialogAdapter;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.utils.RecyclerOnItemListener;
import com.dropo.store.widgets.CustomTextView;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public abstract class CustomSelectSpecificationGroupDialog extends BottomSheetDialog implements RecyclerOnItemListener.OnItemClickListener {

    private final ArrayList<ItemSpecification> specificationGroupItems;
    private final Context context;
    private CustomTextView txDialogTitle;
    private RecyclerView recyclerView;

    public CustomSelectSpecificationGroupDialog(@NonNull Context context, ArrayList<ItemSpecification> specificationGroupItems) {
        super(context);
        this.specificationGroupItems = specificationGroupItems;
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_select_product);

        txDialogTitle = findViewById(R.id.txDialogTitle);
        txDialogTitle.setText(context.getResources().getString(R.string.text_specification_group));
        recyclerView = findViewById(R.id.root_recycler);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.addOnItemTouchListener(new RecyclerOnItemListener(context, this));

        SpecificationGroupSelectedDialogAdapter adapter = new SpecificationGroupSelectedDialogAdapter(context, specificationGroupItems);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.btnNegative).setOnClickListener(view -> dismiss());
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
    }

    @Override
    public void onItemClick(View view, int position) {
        onItemSelected(specificationGroupItems.get(position));
    }

    public abstract void onItemSelected(ItemSpecification specificationGroupItem);
}