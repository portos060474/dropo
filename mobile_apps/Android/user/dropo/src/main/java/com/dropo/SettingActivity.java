package com.dropo;

import android.content.res.TypedArray;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CompoundButton;
import android.widget.LinearLayout;
import android.widget.Spinner;

import androidx.appcompat.widget.SwitchCompat;

import com.dropo.component.CustomSwitch;
import com.dropo.models.singleton.CurrentBooking;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.PreferenceHelper;

public class SettingActivity extends BaseAppCompatActivity implements CompoundButton.OnCheckedChangeListener {

    private SwitchCompat switchPushNotificationSound, switchStoreImage, switchProductImage;
    private LinearLayout llNotification;
    private CustomSwitch switchDarkMode;
    private Spinner spinnerLanguage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_settings));
        initViewById();
        setViewListener();
        initLanguageSpinner();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        switchPushNotificationSound = findViewById(R.id.switchPushNotificationSound);
        switchStoreImage = findViewById(R.id.switchStoreImage);
        switchProductImage = findViewById(R.id.switchProductImage);
        switchPushNotificationSound.setChecked(preferenceHelper.getIsPushNotificationSoundOn());
        switchStoreImage.setChecked(preferenceHelper.getIsLoadStoreImage());
        switchProductImage.setChecked(preferenceHelper.getIsLoadProductImage());
        llNotification = findViewById(R.id.llNotification);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            llNotification.setVisibility(View.GONE);
        } else {
            llNotification.setVisibility(View.VISIBLE);
        }
        switchDarkMode = findViewById(R.id.switchDarkMode);
        spinnerLanguage = findViewById(R.id.spinnerLanguage);
    }

    @Override
    protected void setViewListener() {
        switchPushNotificationSound.setOnCheckedChangeListener(this);
        switchStoreImage.setOnCheckedChangeListener(this);
        switchProductImage.setOnCheckedChangeListener(this);
        switchDarkMode.setChecked(AppColor.isDarkTheme(this));
        switchDarkMode.setOnCheckedChangeListener((compoundButton, checked) -> {
            if (checked) {
                PreferenceHelper.getInstance(this).putTheme(AppColor.APP_THEME_DARK);
            } else {
                PreferenceHelper.getInstance(this).putTheme(AppColor.APP_THEME_LIGHT);
            }
            finishAffinity();
            restartApp();
        });
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View view) {
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        int id = buttonView.getId();
        if (id == R.id.switchPushNotificationSound) {
            preferenceHelper.putIsPushNotificationSoundOn(isChecked);
        } else if (id == R.id.switchStoreImage) {
            preferenceHelper.putIsLoadStoreImage(isChecked);
        } else if (id == R.id.switchProductImage) {
            preferenceHelper.putIsLoadProductImage(isChecked);
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
    
    private void initLanguageSpinner() {
        TypedArray array = this.getResources().obtainTypedArray(R.array.language_code);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.language_name, R.layout.spiner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spiner_view_small);
        spinnerLanguage.setAdapter(adapter);

        spinnerLanguage.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String languageCode = array.getString(i);
                if (!TextUtils.equals(preferenceHelper.getLanguageCode(), languageCode)) {
                    preferenceHelper.putLanguageCode(languageCode);
                    preferenceHelper.putLanguageIndex(getLangIndxex(languageCode, currentBooking.getLangs(), false));
                    CurrentBooking.getInstance().setLanguageChanged(true);
                    finishAffinity();
                    restartApp();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        int size = array.length();
        for (int i = 0; i < size; i++) {
            if (TextUtils.equals(this.preferenceHelper.getLanguageCode(), array.getString(i))) {
                spinnerLanguage.setSelection(i);
                break;
            }
        }
    }
}