package com.dropo.provider;

import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;

import androidx.appcompat.widget.SwitchCompat;

public class SettingActivity extends BaseAppCompatActivity implements CompoundButton.OnCheckedChangeListener {

    private SwitchCompat switchNewOrderSound;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_settings));
        initViewById();
        setViewListener();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        switchNewOrderSound = findViewById(R.id.switchNewOrderSound);
        switchNewOrderSound.setChecked(preferenceHelper.getIsNewOrderSoundOn());

    }

    @Override
    protected void setViewListener() {
        switchNewOrderSound.setOnCheckedChangeListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }


    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        if (buttonView.getId() == R.id.switchNewOrderSound) {
            preferenceHelper.putIsNewOrderSoundOn(isChecked);
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    @Override
    public void onClick(View view) {

    }
}