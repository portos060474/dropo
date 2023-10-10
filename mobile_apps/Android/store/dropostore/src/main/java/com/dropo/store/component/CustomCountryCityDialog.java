package com.dropo.store.component;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.CountryCityAdapter;
import com.dropo.store.models.datamodel.City;
import com.dropo.store.models.datamodel.Country;
import com.dropo.store.utils.ClickListener;
import com.dropo.store.utils.RecyclerTouchListener;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;

public abstract class CustomCountryCityDialog extends BottomSheetDialog {

    private final RecyclerView rcvCountryCode;
    private final CountryCityAdapter countryCityAdapter;
    private final Context context;
    private final EditText etSearchCountry;
    private final boolean isCountry;

    public CustomCountryCityDialog(Context context, ArrayList<Country> countryList, ArrayList<City> cityList, boolean isCountry) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_country_code);
        this.context = context;
        this.isCountry = isCountry;

        CustomFontTextViewTitle tvCountryDialogTitle = findViewById(R.id.tvCountryDialogTitle);
        TextInputLayout tilSearch = findViewById(R.id.tilSearch);
        if (isCountry) {
            tvCountryDialogTitle.setText(context.getString(R.string.text_search_country));
            tilSearch.setHint(context.getString(R.string.text_search_country));
        } else {
            tvCountryDialogTitle.setText(context.getString(R.string.text_search_city));
            tilSearch.setHint(context.getString(R.string.text_search_city));
        }

        rcvCountryCode = findViewById(R.id.rcvCountryCode);
        rcvCountryCode.setLayoutManager(new LinearLayoutManager(context));
        countryCityAdapter = new CountryCityAdapter(countryList, cityList, isCountry);
        rcvCountryCode.setAdapter(countryCityAdapter);
        etSearchCountry = findViewById(R.id.etSearchCountry);
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> {
            if (CustomCountryCityDialog.this.getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(CustomCountryCityDialog.this.getCurrentFocus().getWindowToken(), 0);
            }
            dismiss();
        });
        etSearchCountry.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                countryCityAdapter.getFilter().filter(s);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

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
                if (CustomCountryCityDialog.this.getCurrentFocus() != null) {
                    InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(CustomCountryCityDialog.this.getCurrentFocus().getWindowToken(), 0);
                }

                if (isCountry) {
                    onSelect(countryCityAdapter.getFilterCountries().get(position));
                } else {
                    onSelect(countryCityAdapter.getFilterCities().get(position));
                }
            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }

    public abstract void onSelect(Object object);
}