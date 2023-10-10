package com.dropo.store.component;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.CountryCityListAdapter;
import com.dropo.store.models.datamodel.Category;
import com.dropo.store.models.datamodel.City;
import com.dropo.store.models.datamodel.Country;
import com.dropo.store.utils.RecyclerOnItemListener;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public abstract class CustomListDialog extends BottomSheetDialog implements RecyclerOnItemListener.OnItemClickListener {

    private final Context context;
    private ArrayList<Country> countryItemsList;
    private ArrayList<City> cityItemsList;
    private ArrayList<Category> deliveryList;
    private boolean isCountryList;
    private int code;

    public CustomListDialog(Context context, ArrayList<Country> countryItemsList, boolean isCountryList) {
        super(context);
        this.countryItemsList = countryItemsList;
        this.isCountryList = isCountryList;
        this.context = context;
    }

    public CustomListDialog(Context context, ArrayList<City> cityItemsList) {
        super(context);
        this.cityItemsList = cityItemsList;
        this.context = context;
    }

    public CustomListDialog(Context context, ArrayList<Category> deliveryList, int code) {
        super(context);
        this.deliveryList = deliveryList;
        this.code = code;
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        RecyclerView recyclerView;
        TextView tvDialogTitle;
        CountryCityListAdapter countryCityListAdapter;

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_general);

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;

        tvDialogTitle = findViewById(R.id.tvDialogTitle);
        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        recyclerView.addOnItemTouchListener(new RecyclerOnItemListener(context, this));

        if (code > 0) {
            countryCityListAdapter = new CountryCityListAdapter(context, deliveryList, code);
            tvDialogTitle.setText(context.getResources().getString(R.string.text_select_category));
        } else {
            if (isCountryList) {
                countryCityListAdapter = new CountryCityListAdapter(context, countryItemsList, true);
                tvDialogTitle.setText(context.getResources().getString(R.string.text_select_country));
            } else {
                countryCityListAdapter = new CountryCityListAdapter(context, cityItemsList);
                tvDialogTitle.setText(context.getResources().getString(R.string.text_select_city));
            }
        }

        recyclerView.setAdapter(countryCityListAdapter);
    }

    @Override
    public void onItemClick(View view, int position) {
        if (code > 0) {
            onItemClickOnList(deliveryList.get(position));
        } else {
            if (isCountryList) {
                onItemClickOnList(countryItemsList.get(position));
            } else {
                onItemClickOnList(cityItemsList.get(position));
            }
        }
    }

    public abstract void onItemClickOnList(Object object);
}
