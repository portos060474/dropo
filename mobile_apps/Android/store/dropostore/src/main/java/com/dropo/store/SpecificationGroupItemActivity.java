package com.dropo.store;

import android.annotation.SuppressLint;
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
import com.dropo.store.adapter.SpecificationGroupItemAdapter;
import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.models.datamodel.SetSpecificationGroup;
import com.dropo.store.models.datamodel.SetSpecificationList;
import com.dropo.store.models.datamodel.SpecificationGroup;
import com.dropo.store.models.datamodel.Specifications;
import com.dropo.store.models.responsemodel.AddOrDeleteSpecificationResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class SpecificationGroupItemActivity extends BaseActivity {

    private final ArrayList<Specifications> specificationsArrayList = new ArrayList<>();
    private LinearLayout llNewSpecification;
    private CustomTextView tvAddSpecification;
    private RecyclerView rcSpecification;
    private SpecificationGroupItemAdapter specificationGroupItemAdapter;
    private FloatingActionButton floatingBtn;
    private SpecificationGroup specificationGroup;
    private BottomSheetDialog addDetailInMultiLanguageDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_specification_group_item);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        llNewSpecification = findViewById(R.id.llNewSpecification);
        tvAddSpecification = findViewById(R.id.tvAddSpecification);
        tvAddSpecification.setOnClickListener(this);
        tvAddSpecification.setVisibility(View.GONE);
        rcSpecification = findViewById(R.id.rcSpecification);
        floatingBtn = findViewById(R.id.floatingBtn);
        floatingBtn.setOnClickListener(this);
        loadExtraData();
        initRcvSpecificationGroup();
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

    @Override
    public void onClick(View v) {
        super.onClick(v);
        int id = v.getId();
        if (id == R.id.tvAddSpecification) {
            addORUpdateSpecificationDialog(0, null, false);
        } else if (id == R.id.floatingBtn) {
            if (isEdited()) {
                floatingBtn.setImageResource(R.drawable.ic_pencil);
                tvAddSpecification.setVisibility(View.GONE);
                specificationGroupItemAdapter.setEdited(false);
                addOrDeleteSpecification();
            } else {
                floatingBtn.setImageResource(R.drawable.ic_check_black_24dp);
                tvAddSpecification.setVisibility(View.VISIBLE);
                specificationGroupItemAdapter.setEdited(true);
            }
        }
    }

    private void loadExtraData() {
        if (getIntent().getExtras() != null) {
            specificationGroup = getIntent().getExtras().getParcelable(Constant.SPECIFICATIONS);
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(specificationGroup.getName());
            specificationsArrayList.addAll(specificationGroup.getSpecifications());
        }

    }

    private void initRcvSpecificationGroup() {
        specificationGroupItemAdapter = new SpecificationGroupItemAdapter(specificationsArrayList, this);
        rcSpecification.setNestedScrollingEnabled(false);
        rcSpecification.setLayoutManager(new LinearLayoutManager(this));
        rcSpecification.setAdapter(specificationGroupItemAdapter);
    }


    public void addOrDeleteSpecification() {
        if (llNewSpecification != null) {
            if (!specificationGroupItemAdapter.getSpecificationIds().isEmpty()) {
                deleteSpecification(specificationGroup.getId());
            } else {
                Utilities.hideCustomProgressDialog();
            }
        }
    }

    /**
     * this method call a webservice for add specification in
     * group
     *
     * @param groupId in string
     */
    private void addSpecification(final String groupId, ArrayList<Specifications.NameAndPrice> addSpecificationGroupItem, String sequenceNumber) {
        Utilities.showCustomProgressDialog(this, false);
        SetSpecificationList setSpecificationList = new SetSpecificationList();
        setSpecificationList.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
        setSpecificationList.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
        setSpecificationList.setSpecificationName(addSpecificationGroupItem);
        setSpecificationList.setSpecificationGroupId(groupId);
        setSpecificationList.setSequenceNumber(TextUtils.isEmpty(sequenceNumber) ? 0 : Long.parseLong(sequenceNumber));

        Call<AddOrDeleteSpecificationResponse> call = ApiClient.getClient().create(ApiInterface.class).
                addSpecification(ApiClient.makeGSONRequestBody(setSpecificationList));
        call.enqueue(new Callback<AddOrDeleteSpecificationResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<AddOrDeleteSpecificationResponse> call, @NonNull Response<AddOrDeleteSpecificationResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        if (specificationGroupItemAdapter.getSpecificationIds().isEmpty()) {
                            specificationsArrayList.clear();
                            specificationsArrayList.addAll(response.body().getSpecifications());
                            specificationGroup.setSpecifications(response.body().getSpecifications());
                            specificationGroupItemAdapter.notifyDataSetChanged();
                            Utilities.hideCustomProgressDialog();
                        } else {
                            deleteSpecification(groupId);
                        }
                    } else {
                        ParseContent.getInstance().showErrorMessage(SpecificationGroupItemActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                        Utilities.hideCustomProgressDialog();
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SpecificationGroupItemActivity.this);
                }
            }

            @Override
            public void onFailure(@NonNull Call<AddOrDeleteSpecificationResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for delete particular specification in group
     *
     * @param groupId in string
     */
    private void deleteSpecification(String groupId) {
        Utilities.showCustomProgressDialog(this, false);
        SetSpecificationList setSpecificationList = new SetSpecificationList();
        setSpecificationList.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
        setSpecificationList.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
        setSpecificationList.setSpecificationGroupId(groupId);
        setSpecificationList.setSpecificationId(specificationGroupItemAdapter.getSpecificationIds());
        ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
        Call<AddOrDeleteSpecificationResponse> responseCall = apiInterface.deleteSpecification((ApiClient.makeGSONRequestBody(setSpecificationList)));
        responseCall.enqueue(new Callback<AddOrDeleteSpecificationResponse>() {
            @SuppressLint("NotifyDataSetChanged")
            @Override
            public void onResponse(@NonNull Call<AddOrDeleteSpecificationResponse> call, Response<AddOrDeleteSpecificationResponse> response) {
                if (response.isSuccessful()) {
                    if (response.body().isSuccess()) {
                        specificationsArrayList.clear();
                        specificationsArrayList.addAll(response.body().getSpecifications());
                        specificationGroup.setSpecifications(response.body().getSpecifications());
                        specificationGroupItemAdapter.notifyDataSetChanged();
                        specificationGroupItemAdapter.getSpecificationIds().clear();
                    } else {
                        ParseContent.getInstance().showErrorMessage(SpecificationGroupItemActivity.this, response.body().getErrorCode(), response.body().getStatusPhrase());
                    }
                } else {
                    Utilities.showHttpErrorToast(response.code(), SpecificationGroupItemActivity
                            .this);
                }
                Utilities.hideCustomProgressDialog();
            }

            @Override
            public void onFailure(@NonNull Call<AddOrDeleteSpecificationResponse> call, @NonNull Throwable t) {
                Utilities.handleThrowable(TAG, t);
                Utilities.hideCustomProgressDialog();
            }
        });
    }

    /**
     * this method call webservice for add number of new specification group
     */
    private void updateSpecificationName(final TextView tvSpecificationGroupName, final int position, final List<String> detailList, final String sequenceNumber, final String price) {
        Utilities.showCustomProgressDialog(this, false);
        if (!detailList.isEmpty()) {
            SetSpecificationGroup setSpecificationGroup = new SetSpecificationGroup();
            setSpecificationGroup.setStoreId(PreferenceHelper.getPreferenceHelper(this).getStoreId());
            setSpecificationGroup.setServerToken(PreferenceHelper.getPreferenceHelper(this).getServerToken());
            setSpecificationGroup.setSpId(specificationsArrayList.get(position).getId());
            setSpecificationGroup.setSequenceNumber(TextUtils.isEmpty(sequenceNumber) ? 0 : Long.parseLong(sequenceNumber));
            setSpecificationGroup.setName(detailList);
            setSpecificationGroup.setSpecificationPrice(price);
            ApiInterface apiInterface = ApiClient.getClient().create(ApiInterface.class);
            Call<IsSuccessResponse> responseCall = apiInterface.updateSpecificationName(ApiClient.makeGSONRequestBody(setSpecificationGroup));
            responseCall.enqueue(new Callback<IsSuccessResponse>() {
                @Override
                public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                    if (response.isSuccessful()) {
                        if (response.body().isSuccess()) {
                            Utilities.hideCustomProgressDialog();
                            specificationsArrayList.get(position).setName(detailList);
                            specificationsArrayList.get(position).setSequenceNumber(TextUtils.isEmpty(sequenceNumber) ? 0 : Long.parseLong(sequenceNumber));
                            specificationsArrayList.get(position).setPrice(Double.parseDouble(price));
                            specificationGroupItemAdapter.notifyDataChange();
                            tvSpecificationGroupName.setTag(detailList);
                            tvSpecificationGroupName.setText(Utilities.getDetailStringFromList(detailList, Language.getInstance().getStoreLanguageIndex()));
                        }
                    } else {
                        Utilities.showHttpErrorToast(response.code(), SpecificationGroupItemActivity.this);
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


    public void addORUpdateSpecificationDialog(final int position, final TextView tvSpecificationGroupName, final boolean isUpdate) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }

        addDetailInMultiLanguageDialog = new BottomSheetDialog(this);
        addDetailInMultiLanguageDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        addDetailInMultiLanguageDialog.setContentView(R.layout.dialog_specification_in_multi_language);
        final EditText etSpecificationPrice = addDetailInMultiLanguageDialog.findViewById(R.id.etSpecificationPrice);
        final EditText etSpecificationSequenceNumber = addDetailInMultiLanguageDialog.findViewById(R.id.etSpecificationSequenceNumber);

        if (isUpdate) {
            etSpecificationSequenceNumber.setText(String.valueOf(specificationsArrayList.get(position).getSequenceNumber()));
            etSpecificationPrice.setText(String.valueOf(specificationsArrayList.get(position).getPrice()));
        }

        List<String> detailMap = null;
        if (tvSpecificationGroupName != null) {
            detailMap = (List<String>) tvSpecificationGroupName.getTag();
        }

        TextView txDialogTitle = addDetailInMultiLanguageDialog.findViewById(R.id.txDialogTitle);
        txDialogTitle.setText(R.string.text_specification_name);
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
                        updateSpecificationName(tvSpecificationGroupName, position, detailList, etSpecificationSequenceNumber.getText().toString(), etSpecificationPrice.getText().toString());
                    } else {
                        ArrayList<Specifications.NameAndPrice> addSpecificationGroupItem = new ArrayList<>();
                        double price = TextUtils.isEmpty(etSpecificationPrice.getText().toString()) ? 0 : Double.parseDouble(etSpecificationPrice.getText().toString().trim());
                        addSpecificationGroupItem.add(new Specifications().new NameAndPrice(price, detailList, TextUtils.isEmpty(etSpecificationSequenceNumber.getText().toString()) ? 0 : Long.parseLong(etSpecificationSequenceNumber.getText().toString())));
                        addSpecification(specificationGroup.getId(), addSpecificationGroupItem, etSpecificationSequenceNumber.getText().toString());
                    }
                    addDetailInMultiLanguageDialog.dismiss();
                }

            }
            if (!isDefaultDataNotSet) addDetailInMultiLanguageDialog.dismiss();
        });

        WindowManager.LayoutParams params = addDetailInMultiLanguageDialog.getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        addDetailInMultiLanguageDialog.setCancelable(true);
        addDetailInMultiLanguageDialog.show();
    }
}