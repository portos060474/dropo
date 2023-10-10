package com.dropo.provider.component;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import androidx.annotation.NonNull;

import com.dropo.provider.R;
import com.dropo.provider.models.responsemodels.AppSettingDetailResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;
import com.dropo.provider.parser.ParseContent;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.PreferenceHelper;
import com.dropo.provider.utils.ServerConfig;
import com.dropo.provider.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public abstract class ServerDialog extends BottomSheetDialog implements View.OnClickListener {

    private final Activity activity;

    private final RadioGroup radioGroup;
    private final RadioButton rbServer1, rbServer2, rbServer3, rbServer4;
    private final CustomFontEditTextView etServerUrl;
    private final CustomImageView btnClose;
    private final CustomFontButton btnOk;

    public ServerDialog(@NonNull Activity activity) {
        super(activity);
        this.activity = activity;
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_server);

        btnClose = findViewById(R.id.btnClose);
        btnOk = findViewById(R.id.btnOk);
        radioGroup = findViewById(R.id.radioGroup);
        rbServer1 = findViewById(R.id.rbServer1);
        rbServer2 = findViewById(R.id.rbServer2);
        rbServer3 = findViewById(R.id.rbServer3);
        rbServer4 = findViewById(R.id.rbServer4);
        etServerUrl = findViewById(R.id.etServerUrl);

        setCancelable(false);
        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        getWindow().setAttributes(params);
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        switch (ServerConfig.BASE_URL) {
            case "https://edelivery.appemporio.net/v4/":
                rbServer1.setChecked(true);
                etServerUrl.setVisibility(View.GONE);
                break;
            case "https://apiedeliverydemo.appemporio.net/v4/":
                rbServer2.setChecked(true);
                etServerUrl.setVisibility(View.GONE);
                break;
            case "https://apiedeliverynew.appemporio.net/v4/":
                rbServer3.setChecked(true);
                etServerUrl.setVisibility(View.GONE);
                break;
            default:
                rbServer4.setChecked(true);
                etServerUrl.setText(ServerConfig.BASE_URL);
                etServerUrl.setVisibility(View.VISIBLE);
                break;
        }

        rbServer4.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if (isChecked) {
                etServerUrl.setVisibility(View.VISIBLE);
            } else {
                etServerUrl.setVisibility(View.GONE);
            }
        });

        btnClose.setOnClickListener(this);
        btnOk.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnClose) {
            dismiss();
        } else if (id == R.id.btnOk) {
            int checkedRadioButtonId = radioGroup.getCheckedRadioButtonId();
            if (checkedRadioButtonId == R.id.rbServer1) {
                ServerConfig.BASE_URL = "https://edelivery.appemporio.net/v4/";
                ServerConfig.USER_PANEL_URL = "https://webappedelivery.appemporio.net/";
                ServerConfig.IMAGE_URL = "https://edelivery.appemporio.net/";
            } else if (checkedRadioButtonId == R.id.rbServer2) {
                ServerConfig.BASE_URL = "https://apiedeliverydemo.appemporio.net/v4/";
                ServerConfig.USER_PANEL_URL = "https://apiedeliverydemo.appemporio.net/";
                ServerConfig.IMAGE_URL = "https://webappedeliverydemo.appemporio.net/";
            } else if (checkedRadioButtonId == R.id.rbServer3) {
                ServerConfig.BASE_URL = "https://apiedeliverynew.appemporio.net/v4/";
                ServerConfig.USER_PANEL_URL = "https://webappedeliverynew.appemporio.net/";
                ServerConfig.IMAGE_URL = "https://apiedeliverynew.appemporio.net/";
            } else if (checkedRadioButtonId == R.id.rbServer4) {
                if (TextUtils.isEmpty(etServerUrl.getText()) || !Patterns.WEB_URL.matcher(etServerUrl.getText()).matches()) {
                    Utils.showToast(activity.getString(R.string.msg_please_enter_url), activity);
                    return;
                } else {
                    ServerConfig.BASE_URL = etServerUrl.getText().toString();
                }
            }

            if (rbServer4.isChecked()) {
                goWithOtherURL();
            } else {
                goWithOk();
            }
        }
    }

    private void goWithOk() {
        if (!ServerConfig.BASE_URL.equals(PreferenceHelper.getInstance(activity).getBaseUrl())) {
            onOkClicked();
        }
        dismiss();
    }

    private void goWithOtherURL() {
        Utils.showCustomProgressDialog(activity, false);
        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.TYPE, Const.TYPE_PROVIDER);
        map.put(Const.Params.DEVICE_TYPE, Const.ANDROID);

        if (!ServerConfig.BASE_URL.endsWith("/")) {
            ServerConfig.BASE_URL += "/";
        }

        ApiInterface apiInterface = new ApiClient().changeApiBaseUrl(ServerConfig.BASE_URL).create(ApiInterface.class);
        Call<AppSettingDetailResponse> detailResponseCall = apiInterface.getAppSettingDetail(map);
        detailResponseCall.enqueue(new Callback<AppSettingDetailResponse>() {
            @Override
            public void onResponse(@NonNull Call<AppSettingDetailResponse> call, @NonNull Response<AppSettingDetailResponse> response) {
                Utils.hideCustomProgressDialog();
                if (ParseContent.getInstance().isSuccessful(response)) {
                    if (response.body() != null && response.body().isSuccess()) {
                        goWithOk();
                    }
                } else {
                    if (response.body() != null) {
                        Utils.showErrorToast(response.body().getErrorCode(), response.body().getStatusPhrase(), activity);
                    }
                }
            }

            @Override
            public void onFailure(@NonNull Call<AppSettingDetailResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
            }
        });
    }

    public abstract void onOkClicked();
}