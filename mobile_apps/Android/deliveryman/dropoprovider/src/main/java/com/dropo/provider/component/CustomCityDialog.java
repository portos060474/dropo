package com.dropo.provider.component;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;

import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.adapter.CityAdapter;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.Cities;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;

public abstract class CustomCityDialog extends BottomSheetDialog {

    private final RecyclerView rcvCountryCode;
    private final TextView tvCountryDialogTitle;
    private final CityAdapter cityAdapter;
    private final Context context;

    public CustomCityDialog(Context context, ArrayList<Cities> cityList) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_country_code);
        rcvCountryCode = findViewById(R.id.rcvCountryCode);
        tvCountryDialogTitle = findViewById(R.id.tvCountryDialogTitle);
        tvCountryDialogTitle.setText(context.getResources().getString(R.string.text_select_city));

        TextInputLayout tilSearchCountry = findViewById(R.id.tilSearchCountry);
        tilSearchCountry.setHint(context.getResources().getString(R.string.text_select_city));

        CustomFontEditTextView etSearchCountry = findViewById(R.id.etSearchCountry);
        etSearchCountry.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                cityAdapter.getFilter().filter(s);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        rcvCountryCode.setLayoutManager(new LinearLayoutManager(context));
        cityAdapter = new CityAdapter(cityList);
        rcvCountryCode.setAdapter(cityAdapter);
        rcvCountryCode.addItemDecoration(new DividerItemDecoration(context, LinearLayoutManager.VERTICAL));
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> {
            if (CustomCityDialog.this.getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(CustomCityDialog.this.getCurrentFocus().getWindowToken(), 0);
            }
            dismiss();
        });
        this.context = context;
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        getWindow().setAttributes(params);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        rcvCountryCode.addOnItemTouchListener(new RecyclerTouchListener(context, rcvCountryCode, new ClickListener() {
            @Override
            public void onClick(View view, int position) {
                if (CustomCityDialog.this.getCurrentFocus() != null) {
                    InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(CustomCityDialog.this.getCurrentFocus().getWindowToken(), 0);
                }
                onSelect(cityAdapter.getFilterCities().get(position));
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }

    public abstract void onSelect(Cities cities);
}