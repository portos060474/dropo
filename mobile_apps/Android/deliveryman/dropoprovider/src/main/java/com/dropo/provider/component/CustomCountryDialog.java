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

import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.provider.R;
import com.dropo.provider.adapter.CountryAdapter;
import com.dropo.provider.interfaces.ClickListener;
import com.dropo.provider.interfaces.RecyclerTouchListener;
import com.dropo.provider.models.datamodels.Countries;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.ArrayList;

public abstract class CustomCountryDialog extends BottomSheetDialog {

    private final RecyclerView rcvCountryCode;
    private final CountryAdapter countryAdapter;
    private final Context context;

    public CustomCountryDialog(Context context, ArrayList<Countries> countryList) {
        super(context);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_country_code);
        this.context = context;

        CustomFontEditTextView etSearchCountry = findViewById(R.id.etSearchCountry);
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

        rcvCountryCode = findViewById(R.id.rcvCountryCode);
        rcvCountryCode.setLayoutManager(new LinearLayoutManager(context));
        countryAdapter = new CountryAdapter(countryList);
        rcvCountryCode.setAdapter(countryAdapter);
        rcvCountryCode.addItemDecoration(new DividerItemDecoration(context, LinearLayoutManager.VERTICAL));
        findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view -> {
            if (CustomCountryDialog.this.getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Activity.INPUT_METHOD_SERVICE);
                inputMethodManager.hideSoftInputFromWindow(CustomCountryDialog.this.getCurrentFocus().getWindowToken(), 0);
            }
            dismiss();
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

    public abstract void onSelect(Countries countries);
}