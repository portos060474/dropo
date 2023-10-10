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
import com.dropo.store.adapter.ProductSelectedDialogAdapter;
import com.dropo.store.models.datamodel.Product;
import com.dropo.store.utils.RecyclerOnItemListener;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public abstract class CustomSelectProductDialog extends BottomSheetDialog implements RecyclerOnItemListener.OnItemClickListener {

    private final ArrayList<Product> productList;
    private final Context context;
    private RecyclerView recyclerView;

    public CustomSelectProductDialog(@NonNull Context context, ArrayList<Product> productList) {
        super(context);
        this.productList = productList;
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_select_product);

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.MATCH_PARENT;
        recyclerView = findViewById(R.id.root_recycler);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(context);
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.addOnItemTouchListener(new RecyclerOnItemListener(context, this));

        ProductSelectedDialogAdapter adapter = new ProductSelectedDialogAdapter(context, productList);
        recyclerView.setAdapter(adapter);
        findViewById(R.id.btnNegative).setOnClickListener(view -> dismiss());
    }

    @Override
    public void onItemClick(View view, int position) {
        onProductItemSelected(productList.get(position));
    }

    public abstract void onProductItemSelected(Product product);
}