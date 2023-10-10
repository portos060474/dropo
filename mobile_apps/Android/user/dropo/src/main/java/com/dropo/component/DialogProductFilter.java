package com.dropo.component;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.adapter.ProductFilterAdapter;
import com.dropo.models.datamodels.Product;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public final class DialogProductFilter extends BottomSheetDialog {

    private final ArrayList<Product> storeProductList;
    private final ProductFilterListener productFilterListener;
    private final String filter;
    private EditText etProductSearch;

    public DialogProductFilter(@NonNull Context context, ArrayList<Product> storeProductList, String filter, @NonNull ProductFilterListener productFilterListener) {
        super(context);
        this.storeProductList = storeProductList;
        this.productFilterListener = productFilterListener;
        this.filter = filter;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_product_filter);
        etProductSearch = findViewById(R.id.etProductSearch);
        if (!TextUtils.isEmpty(filter)) {
            etProductSearch.setText(filter);
        }
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> dismiss());
        findViewById(R.id.btnApplyProductFilter).setOnClickListener(view -> productFilterListener.onFilter(etProductSearch.getText().toString().trim()));
        RecyclerView rcvFilterList = findViewById(R.id.rcvFilterList);
        rcvFilterList.setLayoutManager(new LinearLayoutManager(getContext()));
        rcvFilterList.setAdapter(new ProductFilterAdapter(storeProductList));
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        BottomSheetBehavior<?> behavior = getBehavior();
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
    }

    public interface ProductFilterListener {
        void onFilter(String itemName);
    }
}