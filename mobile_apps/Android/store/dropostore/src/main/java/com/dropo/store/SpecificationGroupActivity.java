package com.dropo.store;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.SpecificationGroupAdapter;
import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.models.datamodel.SetSpecificationGroup;
import com.dropo.store.models.datamodel.SetSpecificationList;
import com.dropo.store.models.datamodel.SpecificationGroup;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.SpecificationGroupResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomFontTextViewTitle;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SpecificationGroupActivity extends BaseActivity {

    private final ArrayList<SpecificationGroup> specificationGroups = new ArrayList<>();
    private CustomTextView tvAddSpecification;
    private RecyclerView rcSpecification;
    private SpecificationGroupAdapter group2Adapter;
    private FloatingActionButton floatingBtn;
    private BottomSheetDialog addDetailInMultiLanguageDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_specificatrion_group);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_product_specification_group));
        tvAddSpecification = findViewById(R.id.tvAddSpecification);
        tvAddSpecification.setOnClickListener(this);
        tvAddSpecification.setVisibility(View.GONE);
        rcSpecification = findViewById(R.id.rcSpecification);
        floatingBtn = findViewById(R.id.floatingBtn);
        floatingBtn.setOnClickListener(this);
        initRcvSpecificationGroup();
    }

    @Override
    protected void onResume() {
        super.onResume();
        getSpecificationGroup();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    private boolean isEdited() {
        return tvAddSpecification.getVisibility() == View.VISIBLE;
    }

    private void initRcvSpecificationGroup() {
        group2Adapter = new SpecificationGroupAdapter(specificationGroups, this);
        rcSpecification.setNestedScrollingEnabled(false);
        rcSpecification.setLayoutManager(new LinearLayoutManager(this));
        rcSpecification.setAdapter(group2Adapter);
    }

    /**
     * this method call webservice for all specification group for particular product
     */
    private void getSpecificationGroup() {
        Utilities.showCustomProgressDialog(this, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(this).getServerToken());
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(this).getStoreId());

        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<SpecificationGroupResponse> responseCall = apiInterface.getSpecificationGroup(map);
        responseCall.enqueue(new Callback<SpecificationGroupResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<SpecificationGroupResponse> call, @NonNull Response<SpecificationGroupResponse> response) {
                if (response.isSuccessful()) {
                    Utilities.hideCustomProgressDialog();
                    specificationGroups.clear();
                    if (response.body().isSuccess()) {
                        specificationGroups.addAll(response.body().getSpecificationGroup());
                        Collections.sort(specificationGroups);
                    } else {
                        ParseContent.getInstance().showErrorMessage(SpecificationGroupActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SpecificationGroupActivity.this);
                }
                if (group2Adapter != null) {
                    group2Adapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onFailure(@NonNull Call<SpecificationGroupResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call a webservice for delete Specification Group
     *
     * @param position list item position
     */
    public void deleteSpecificationGroup(final int position) {
        Utilities.showCustomProgressDialog(this, false);
        SetSpecificationList setSpecificationList = new SetSpecificationList();
        setSpecificationList.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
        setSpecificationList.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
        setSpecificationList.setSpecificationGroupId(specificationGroups.get(position).getId());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.deleteSpecificationGroup((ApiClient.makeGSONRequestBody(setSpecificationList)));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        specificationGroups.remove(position);
                        group2Adapter.notifyDataSetChanged();
                        parseContent.showMessage(SpecificationGroupActivity.this, response.body().getStatusPhrase());
                    } else {
                        ParseContent.getInstance().showErrorMessage(SpecificationGroupActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SpecificationGroupActivity.this);
                }
                Utilities.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });

    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.tvAddSpecification) {
            if (isEdited()) {
                addORUpdateSpecificationGroupDialog(null, null, new ArrayList<>(), false, 0);
            }
        } else if (id == R.id.floatingBtn) {
            if (isEdited()) {
                floatingBtn.setImageResource(R.drawable.ic_pencil);
                tvAddSpecification.setVisibility(View.GONE);
                group2Adapter.setEdited(false);
            } else {
                floatingBtn.setImageResource(R.drawable.ic_check_black_24dp);
                tvAddSpecification.setVisibility(View.VISIBLE);
                group2Adapter.setEdited(true);
            }
        }
    }

    /**
     * this method call webservice for add number of new specification group
     */
    private void addSpecificationGroup(final List<String> specificationGroupList) {
        List<List<String>> specificationGroup = new ArrayList<>();

        specificationGroup.add(specificationGroupList);
        SetSpecificationGroup setSpecificationGroup = new SetSpecificationGroup();
        setSpecificationGroup.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
        setSpecificationGroup.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
        setSpecificationGroup.setSpecificationGroup(specificationGroup);
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<IsSuccessResponse> responseCall = apiInterface.addSpecificationGroup(ApiClient.makeGSONRequestBody(setSpecificationGroup));
        responseCall.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        getSpecificationGroup();
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SpecificationGroupActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for add number of new specification group
     */
    private void updateSpecificationGroupName(
            final CustomFontTextViewTitle tvSpecificationGroupName, final CustomFontTextViewTitle tvSequenceNumber,
            final int position, final List<String> detailList, int sequenceNumber) {

        Utilities.showCustomProgressDialog(this, false);

        if (!detailList.isEmpty()) {
            SetSpecificationGroup setSpecificationGroup = new SetSpecificationGroup();
            setSpecificationGroup.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
            setSpecificationGroup.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
            setSpecificationGroup.setSpId(specificationGroups.get(position).getId());
            setSpecificationGroup.setName(detailList);
            //setSpecificationGroup.setSequenceNumber(sequenceNumber);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = apiInterface.updateSpecificationGroupName(ApiClient.makeGSONRequestBody(setSpecificationGroup));
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            Utilities.hideCustomProgressDialog();
                            specificationGroups.get(position).setName(detailList);
                            specificationGroups.get(position).setSequenceNumber(Long.parseLong(String.valueOf(sequenceNumber)));
                            tvSpecificationGroupName.setTag(detailList);
                            tvSpecificationGroupName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
                            tvSequenceNumber.setText(String.valueOf(sequenceNumber));
                        }
                    } else {
                        Utilities.showHttpErrorToast(response.code(), SpecificationGroupActivity.this);
                    }
                }

                @Override
                public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                    Utilities.handleThrowable(TAG, t);
                    Utilities.hideCustomProgressDialog();
                }
            });
        } else {
            Utilities.hideCustomProgressDialog();
        }
    }

    public void updateSpecification(final int position, final CustomFontTextViewTitle tvSpecificationGroupName, final CustomFontTextViewTitle tvSequenceNumber) {
        addORUpdateSpecificationGroupDialog(tvSpecificationGroupName, tvSequenceNumber, (List<String>) tvSpecificationGroupName.getTag(), true, position);
    }

    public void goToSpecificationGroupItemActivity(int position) {
        Intent intent = new Intent(this, SpecificationGroupItemActivity.class);
        intent.putExtra(Constant.SPECIFICATIONS, specificationGroups.get(position));
        startActivity(intent);
    }

    public void addORUpdateSpecificationGroupDialog(
            final CustomFontTextViewTitle tvSpecificationGroupName, final CustomFontTextViewTitle tvSequenceNumber,
            final List<String> detailMap, final boolean isUpdate, int position) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new BottomSheetDialog(this);
        addDetailInMultiLanguageDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        addDetailInMultiLanguageDialog.setContentView(R.layout.dialog_specification_in_multi_language);
        final EditText etSpecificationPrice = addDetailInMultiLanguageDialog.findViewById(R.id.etSpecificationPrice);
        final EditText etSpecificationSequenceNumber = addDetailInMultiLanguageDialog.findViewById(R.id.etSpecificationSequenceNumber);
        final TextInputLayout tilSpecificationSequenceNumber = addDetailInMultiLanguageDialog.findViewById(R.id.tilSpecificationSequenceNumber);
        final TextInputLayout tilSpecificationPrice = addDetailInMultiLanguageDialog.findViewById(R.id.tilSpecificationPrice);

        if (isUpdate) {
            etSpecificationPrice.setVisibility(View.GONE);
            tilSpecificationPrice.setVisibility(View.GONE);
            etSpecificationSequenceNumber.setText(String.valueOf(specificationGroups.get(position).getSequenceNumber()));
            etSpecificationSequenceNumber.setVisibility(View.GONE);
            tilSpecificationSequenceNumber.setVisibility(View.GONE);
        } else {
            etSpecificationPrice.setVisibility(View.GONE);
            tilSpecificationPrice.setVisibility(View.GONE);
            etSpecificationSequenceNumber.setVisibility(View.GONE);
            tilSpecificationSequenceNumber.setVisibility(View.GONE);
        }

        TextView txDialogTitle = addDetailInMultiLanguageDialog.findViewById(R.id.txDialogTitle);
        txDialogTitle.setText(R.string.text_specification_group_name);
        LinearLayout llContainer = addDetailInMultiLanguageDialog.findViewById(R.id.llContainer);
        ArrayList<Languages> languages;
        languages = Language.getInstance().getStoreLanguages();
        if (languages != null && !languages.isEmpty()) {
            for (int i = 0; i < languages.size(); i++) {
                Languages language = languages.get(i);
                View view = LayoutInflater.from(this).inflate(R.layout.item_multi_language_detail, null);
                TextInputLayout textInputLayout = view.findViewById(R.id.tilLanguage);
                textInputLayout.setHint(language.getName());
                textInputLayout.setTag(language.getCode());
                if (detailMap != null && !detailMap.isEmpty() && i < detailMap.size()) {
                    EditText editText = textInputLayout.getEditText();
                    editText.setText(detailMap.get(i));
                }
                if (!language.isVisible()) {
                    textInputLayout.setVisibility(View.GONE);
                } else {
                    textInputLayout.setVisibility(View.VISIBLE);
                }

                llContainer.addView(view);
            }
        }

        addDetailInMultiLanguageDialog.findViewById(R.id.btnNegative).setOnClickListener(v -> addDetailInMultiLanguageDialog.dismiss());

        final LinearLayout finalLlContainer = llContainer;
        addDetailInMultiLanguageDialog.findViewById(R.id.btnPositive).setOnClickListener(v -> {
            boolean isDefaultDataNotSet = false;
            if (finalLlContainer.getChildCount() > 0) {
                List<String> detailList = new ArrayList<>();
                int size = finalLlContainer.getChildCount();
                for (int i = 0; i < size; i++) {
                    TextInputLayout textInputLayout = (TextInputLayout) finalLlContainer.getChildAt(i);
                    EditText editText = textInputLayout.getEditText();
                    if (i == 0 && TextUtils.isEmpty(editText.getText().toString().trim())) {
                        isDefaultDataNotSet = true;
                        editText.setError(getResources().getString(R.string.msg_enter_detail_for_default_language));
                        break;
                    }

                    if (!TextUtils.isEmpty(editText.getText().toString().trim())) {
                        detailList.add(editText.getText().toString().trim());
                    }
                }

                if (!isDefaultDataNotSet) {
                    if (isUpdate) {
                        updateSpecificationGroupName(tvSpecificationGroupName, tvSequenceNumber, position,
                                detailList, TextUtils.isEmpty(etSpecificationSequenceNumber.getText().toString()) ? 0 : Integer.parseInt(etSpecificationSequenceNumber.getText().toString()));
                    } else {
                        addSpecificationGroup(detailList);
                    }
                    addDetailInMultiLanguageDialog.dismiss();
                }

            }
            if (!isDefaultDataNotSet) addDetailInMultiLanguageDialog.dismiss();
        });

        addDetailInMultiLanguageDialog.setOnDismissListener(dialog -> getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN));

        WindowManager.LayoutParams params = addDetailInMultiLanguageDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        addDetailInMultiLanguageDialog.setCancelable(true);
        addDetailInMultiLanguageDialog.show();
    }
}