package com.dropo.store;

import android.os.Bundle;
import android.text.TextUtils;
import android.util.Patterns;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.SubStoreAccessAdapter;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.models.datamodel.SubStore;
import com.dropo.store.models.datamodel.SubStoreAccessService;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.models.singleton.SubStoreAccess;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.FieldValidation;
import com.dropo.store.utils.Utilities;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AddSubStoreActivity extends BaseActivity {

    private EditText etSubStoreName, etSubStoreEmail, etSubStorePhone, etSubStorePassword;
    private RecyclerView rcvSubStoreAccess;
    private Button btnSaveSubStore;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private SwitchCompat switchApproved;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_sub_store);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_sub_store));
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_sub_store));
        etSubStoreName = findViewById(R.id.etSubStoreName);
        etSubStoreEmail = findViewById(R.id.etSubStoreEmail);
        etSubStorePhone = findViewById(R.id.etSubStorePhone);
        etSubStorePassword = findViewById(R.id.etSubStorePassword);
        rcvSubStoreAccess = findViewById(R.id.rcvSubStoreAccess);
        btnSaveSubStore = findViewById(R.id.btnSaveSubStore);
        switchApproved = findViewById(R.id.switchApproved);
        btnSaveSubStore.setOnClickListener(this);
        FieldValidation.setMaxPhoneNumberInputLength(this, etSubStorePhone);
        rcvSubStoreAccess.setAdapter(new SubStoreAccessAdapter(this, getSubStoreAccessService()));
        etSubStoreName.setOnClickListener(v -> addMultiLanguageDetail(etSubStoreName.getHint().toString(), (List<String>) etSubStoreName.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
            @Override
            public void onSave(List<String> detailList) {
                etSubStoreName.setTag(detailList);
                etSubStoreName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
                etSubStoreName.setError(null);
            }
        }));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, R.drawable.ic_history_time);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btnSaveSubStore) {
            saveSubStore();
        }
    }

    private void saveSubStore() {
        if (etSubStoreName.getText().toString().trim().isEmpty()) {
            etSubStoreName.setError(getString(R.string.msg_empty_name));
            etSubStoreName.requestFocus();
        } else if (!Patterns.EMAIL_ADDRESS.matcher(etSubStoreEmail.getText().toString().trim()).matches()) {
            etSubStoreEmail.setError(getString(R.string.msg_valid_email));
            etSubStoreEmail.requestFocus();
        } else if (!FieldValidation.isValidPhoneNumber(this, etSubStorePhone.getText().toString())) {
            etSubStorePhone.setError(FieldValidation.getPhoneNumberValidationMessage(this));
            etSubStorePhone.requestFocus();
        } else if (etSubStorePassword.getText().toString().trim().length() < 6) {
            etSubStorePassword.setError(getString(R.string.msg_password_length));
            etSubStorePassword.requestFocus();
        } else {
            Utilities.showCustomProgressDialog(this, false);
            HashMap<String, Object> map = new HashMap<>();
            map.put(Constant.URLS, new Gson().toJsonTree(((SubStoreAccessAdapter) rcvSubStoreAccess.getAdapter()).getSubStoreAccessServices()));
            map.put(Constant.EMAIL, etSubStoreEmail.getText().toString());
            map.put(Constant.PHONE, etSubStorePhone.getText().toString());
            map.put(Constant.PASS_WORD, etSubStorePassword.getText().toString());
            map.put(Constant.NAME, new Gson().toJsonTree((List<String>) etSubStoreName.getTag()));
            map.put(Constant.IS_APPROVED, switchApproved.isChecked());
            map.put(Constant.STORE_ID, preferenceHelper.getStoreId());

            if (getIntent().getExtras() != null && getIntent().hasExtra(Constant.SUB_STORE)) {
                SubStore subStore = getIntent().getExtras().getParcelable(Constant.SUB_STORE);
                if (subStore != null) {
                    map.put(Constant._ID, subStore.getId());
                }
            }

            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall;
            if (getIntent().getExtras() != null && getIntent().hasExtra(Constant.SUB_STORE)) {
                responseCall = apiInterface.updateSubStore(map);
            } else {
                responseCall = apiInterface.addSubStore(map);
            }

            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    Utilities.hideCustomProgressDialog();
                    if (parseContent.isSuccessful(response)) {
                        if (response.body().isSuccess()) {
                            onBackPressed();
                        } else {
                            ParseContent.getInstance().showErrorMessage(AddSubStoreActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        }
                    }
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    Utilities.hideCustomProgressDialog();
                    Utilities.handleThrowable(AddSubStoreActivity.class.getName(), t);
                }
            });
        }
    }

    private List<SubStoreAccessService> getSubStoreAccessService() {
        ArrayList<SubStoreAccessService> subStoreAccessServices = new ArrayList<>();

        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_create_order), SubStoreAccess.CREATE_ORDER));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_provider), SubStoreAccess.PROVIDERS));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_servcie), SubStoreAccess.SERVICE));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_order), SubStoreAccess.ORDER));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_deliveries), SubStoreAccess.DELIVERIES));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_history), SubStoreAccess.HISTORY));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_group), SubStoreAccess.GROUP));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_product), SubStoreAccess.PRODUCT));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_promo_code), SubStoreAccess.PROMO_CODE));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_settings), SubStoreAccess.SETTING));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_earning), SubStoreAccess.EARNING));
        subStoreAccessServices.add(new SubStoreAccessService(getString(R.string.text_weekly_werning), SubStoreAccess.WEEKLY_EARNING));

        if (getIntent().getExtras() != null && getIntent().hasExtra(Constant.SUB_STORE)) {
            SubStore subStore = getIntent().getExtras().getParcelable(Constant.SUB_STORE);
            if (subStore != null) {
                etSubStoreName.setText(subStore.getName());
                etSubStorePhone.setText(subStore.getPhone());
                etSubStoreEmail.setText(subStore.getEmail());
                etSubStoreName.setTag(subStore.getNameList());
                switchApproved.setChecked(subStore.isIsApproved());
                List<SubStoreAccessService> accessServices = subStore.getSubStoreAccessServices();
                if (accessServices != null && !accessServices.isEmpty()) {
                    for (SubStoreAccessService accessService : accessServices) {
                        for (SubStoreAccessService subStoreAccessService : subStoreAccessServices) {
                            if (TextUtils.equals(accessService.getUrl(), subStoreAccessService.getUrl())) {
                                subStoreAccessService.setPermission(accessService.getPermission());
                            }
                        }
                    }
                }
            }
        }

        return subStoreAccessServices;
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void enableSaveButton(boolean isEnable) {
        btnSaveSubStore.setEnabled(isEnable);
        btnSaveSubStore.setAlpha(isEnable ? 1f : 0.5f);
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, false);
        addDetailInMultiLanguageDialog.show();
    }
}