package com.dropo.component;

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

import com.dropo.user.R;
import com.dropo.adapter.CountryAdapter;
import com.dropo.interfaces.ClickListener;
import com.dropo.interfaces.RecyclerTouchListener;
import com.dropo.models.datamodels.Country;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public abstract class CustomCountryDialog extends BottomSheetDialog {

    private final RecyclerView rcvCountryCode;
    private final CountryAdapter countryAdapter;
    private final Context context;
    private final EditText etSearchCountry;

    public CustomCountryDialog(Context context, ArrayList<Country> countryList) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_country_code);
        this.context = context;
        rcvCountryCode = findViewById(R.id.rcvCountryCode);
        rcvCountryCode.setLayoutManager(new LinearLayoutManager(context));
        countryAdapter = new CountryAdapter(countryList);
        rcvCountryCode.setAdapter(countryAdapter);
        etSearchCountry = findViewById(R.id.etSearchCountry);
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> dismiss());
        etSearchCountry.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                countryAdapter.getFilter().filter(s);
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
                if (CustomCountryDialog.this.getCurrentFocus() != null) {
                    InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                    inputMethodManager.hideSoftInputFromWindow(CustomCountryDialog.this.getCurrentFocus().getWindowToken(), 0);
                }
                onSelect(countryAdapter.getFilterCountries().get(position));

            }

            @Override
            public void onLongClick(View view, int position) {

            }
        }));
    }

    public abstract void onSelect(Country country);
}