package com.dropo.store;

import static com.dropo.store.utils.Constant.PRODUCT_SPECIFICATION;
import static com.dropo.store.utils.Constant.PRODUCT_SPECIFICATION_LIST;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatSpinner;
import androidx.appcompat.widget.SwitchCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.adapter.AddItemSpecificationAdapter;
import com.dropo.store.adapter.CustomSpinnerAdapter;
import com.dropo.store.component.AddDetailInMultiLanguageDialog;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.datamodel.ItemSpecification;
import com.dropo.store.models.datamodel.ProductSpecification;
import com.dropo.store.models.datamodel.SpinnerItem;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

import com.google.android.material.textfield.TextInputEditText;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

public class AddItemSpecificationActivity extends BaseActivity {

    private final ArrayList<ProductSpecification> specificationArrayList = new ArrayList<>();
    private boolean isTypeSingle;
    private TextInputEditText etSpecificationName, etStartRange, etEndRange, etGroupSequenceNumber;
    private AddItemSpecificationAdapter addItemSpecificationAdapter;
    private ItemSpecification itemSpecification;
    private SwitchCompat switchRequired, swAssociateModifier, swUserCanAddSpecificationQuantity;
    private AppCompatSpinner spSpecificationGroup, spSpecification;
    private View llAssociate, llAssociateData, llModifierQuantity;
    private ItemSpecification specificationGroupForAddItem;
    private String specificationGroupId;
    private Spinner spinnerSpecificationRange;
    private CustomTextView tvTo;
    private AddDetailInMultiLanguageDialog addDetailInMultiLanguageDialog;
    private int uniqueId;

    private final ArrayList<ItemSpecification> productSpecificationList = new ArrayList<>();
    private final ArrayList<String> modifierIds = new ArrayList<>();

    private final ArrayList<SpinnerItem> itemsSpecificationGroup = new ArrayList<>();
    private final ArrayList<SpinnerItem> itemsSpecification = new ArrayList<>();

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_item_specification);

        etSpecificationName = findViewById(R.id.etSpecificationName);
        etGroupSequenceNumber = findViewById(R.id.etGroupSequenceNumber);
        swUserCanAddSpecificationQuantity = findViewById(R.id.swUserCanAddSpecificationQuantity);
        swAssociateModifier = findViewById(R.id.swAssociateModifier);
        llAssociate = findViewById(R.id.llAssociate);
        llAssociateData = findViewById(R.id.llAssociateData);
        llModifierQuantity = findViewById(R.id.llModifierQuantity);
        spSpecificationGroup = findViewById(R.id.spSpecificationGroup);
        spSpecification = findViewById(R.id.spSpecification);

        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_add_item_specification));
        spinnerSpecificationRange = findViewById(R.id.spinnerSpecificationRange);
        etStartRange = findViewById(R.id.etStartRange);
        etEndRange = findViewById(R.id.etEndRange);
        tvTo = findViewById(R.id.tvTo);
        switchRequired = findViewById(R.id.switchRequired);
        RecyclerView rcProSpecification = findViewById(R.id.rcProSpecification);
        rcProSpecification.setLayoutManager(new LinearLayoutManager(this));
        addItemSpecificationAdapter = new AddItemSpecificationAdapter(this, specificationArrayList);
        rcProSpecification.setAdapter(addItemSpecificationAdapter);
        initSpinnerSpecificationRange();
        etStartRange.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                setDataForSelectRangeMax();
            }
        });
        etEndRange.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                setDataForSelectRangeMax();
            }
        });

        if (getIntent().getParcelableExtra(Constant.SPECIFICATIONS) != null) {
            itemSpecification = getIntent().getParcelableExtra(Constant.SPECIFICATIONS);
            setSpecificationDetail(itemSpecification);
        }
        if (getIntent().getParcelableExtra(PRODUCT_SPECIFICATION) != null) {
            specificationGroupForAddItem = getIntent().getParcelableExtra(PRODUCT_SPECIFICATION);
            for (ProductSpecification productSpecification : specificationGroupForAddItem.getList()) {
                productSpecification.setIsUserSelected(true);
            }
            setSpecificationDetail(specificationGroupForAddItem);
        }
        if (getIntent().getParcelableArrayListExtra(PRODUCT_SPECIFICATION_LIST) != null) {
            productSpecificationList.addAll(getIntent().getParcelableArrayListExtra(PRODUCT_SPECIFICATION_LIST));
        }

        if (productSpecificationList.isEmpty()) {
            llAssociate.setVisibility(View.GONE);
        } else {
            swAssociateModifier.setOnCheckedChangeListener((buttonView, isChecked) -> {
                llAssociateData.setVisibility(isChecked ? View.VISIBLE : View.GONE);
                if (isChecked) {
                    spSpecificationGroup.setSelection(0);
                    initSpinnerSpecificationGroup();
                    if (itemsSpecificationGroup.size() <= 1) {
                        Utilities.showToast(this, getString(R.string.msg_no_modifier_available));
                        swAssociateModifier.setChecked(false);
                        swAssociateModifier.setEnabled(false);
                        llAssociateData.setVisibility(View.GONE);
                    }
                }
            });

            if (itemSpecification != null) {
                swAssociateModifier.setChecked(itemSpecification.getModifierGroupId() != null);
                swAssociateModifier.setEnabled(false);
                spSpecificationGroup.setEnabled(false);
                spSpecification.setEnabled(false);
            }
        }

        etSpecificationName.setOnClickListener(this);
    }

    private void initSpinnerSpecificationGroup() {
        if (itemsSpecificationGroup.isEmpty()) {
            itemsSpecificationGroup.add(new SpinnerItem("", getString(R.string.text_select)));

            if (specificationGroupForAddItem != null) {
                modifierIds.clear();
                ArrayList<String> modifierGroupIds = new ArrayList<>();
                List<ItemSpecification> totalAddedSpecification = new ArrayList<>();
                for (ItemSpecification itemSpecification : productSpecificationList) {
                    if (specificationGroupForAddItem.getId().equalsIgnoreCase(itemSpecification.getId())) {
                        totalAddedSpecification.add(itemSpecification);
                        if (!modifierGroupIds.contains(itemSpecification.getModifierGroupId()) && itemSpecification.getModifierGroupId() != null) {
                            modifierGroupIds.add(itemSpecification.getModifierGroupId());
                        }
                        if (!modifierIds.contains(itemSpecification.getModifierId()) && itemSpecification.getModifierId() != null) {
                            modifierIds.add(itemSpecification.getModifierId());
                        }
                    }
                }

                List<ItemSpecification> addedSpecification = new ArrayList<>();
                for (ItemSpecification itemSpecification : productSpecificationList) {
                    if (itemSpecification.getType() == Constant.TYPE_SPECIFICATION_SINGLE
                            && itemSpecification.getModifierGroupId() == null && itemSpecification.getModifierId() == null) {
                        if (!modifierGroupIds.isEmpty()) {
                            for (String groupId : modifierGroupIds) {
                                if (itemSpecification.getId().equalsIgnoreCase(groupId)) {
                                    addedSpecification.clear();
                                    for (ItemSpecification specification : totalAddedSpecification) {
                                        if (specification.getModifierGroupId() != null && specification.getModifierGroupId().equalsIgnoreCase(groupId)) {
                                            addedSpecification.add(specification);
                                        }
                                    }
                                    if (itemSpecification.getList().size() != addedSpecification.size()) {
                                        if (itemSpecification.getModifierGroupId() != null && itemSpecification.getModifierGroupId().equalsIgnoreCase(groupId)) {
                                            itemsSpecificationGroup.add(new SpinnerItem(itemSpecification.getId(), itemSpecification.getName()));
                                            break;
                                        } else {
                                            itemsSpecificationGroup.add(new SpinnerItem(itemSpecification.getId(), itemSpecification.getName()));
                                        }
                                    }
                                }
                            }
                        } else if (!specificationGroupForAddItem.getId().equalsIgnoreCase(itemSpecification.getId())) {
                            itemsSpecificationGroup.add(new SpinnerItem(itemSpecification.getId(), itemSpecification.getName()));
                        }
                    }
                }

                ArrayList<SpinnerItem> spinnerItems = new ArrayList<>(itemsSpecificationGroup);
                int totalCount;
                for (SpinnerItem spinnerItem : spinnerItems) {
                    totalCount = 0;
                    for (ItemSpecification itemSpecification : productSpecificationList) {
                        if (itemSpecification.getId().equalsIgnoreCase(spinnerItem.getKey())) {
                            totalCount++;
                        }
                    }
                    if (totalCount > 1) {
                        itemsSpecificationGroup.remove(spinnerItem);
                    }
                }
            } else {
                for (ItemSpecification itemSpecification : productSpecificationList) {
                    if (itemSpecification.getType() == Constant.TYPE_SPECIFICATION_SINGLE) {
                        itemsSpecificationGroup.add(new SpinnerItem(itemSpecification.getId(), itemSpecification.getName()));
                    }
                }
            }

            CustomSpinnerAdapter adapter = new CustomSpinnerAdapter(this, itemsSpecificationGroup);
            spSpecificationGroup.setAdapter(adapter);
            spSpecificationGroup.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                @Override
                public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                    if (position > 0) {
                        initSpinnerSpecification();
                        spSpecification.setVisibility(View.VISIBLE);
                    } else {
                        spSpecification.setVisibility(View.INVISIBLE);
                    }
                }

                @Override
                public void onNothingSelected(AdapterView<?> parent) {

                }
            });

            if (itemSpecification != null) {
                for (int i = 0; i < itemsSpecificationGroup.size(); i++) {
                    if (itemSpecification.getModifierGroupId() != null
                            && itemSpecification.getModifierGroupId().equalsIgnoreCase(itemsSpecificationGroup.get(i).getKey())) {
                        spSpecificationGroup.setSelection(i);
                        break;
                    }
                }
            }
        } else {
            spSpecificationGroup.setSelection(0);
        }
    }

    private void initSpinnerSpecification() {
        itemsSpecification.clear();
        itemsSpecification.add(new SpinnerItem("", getString(R.string.text_select)));

        ItemSpecification specification = null;
        String selectedSpecificationGroupId = itemsSpecificationGroup.get(spSpecificationGroup.getSelectedItemPosition()).getKey();
        for (ItemSpecification itemSpecification : productSpecificationList) {
            if (selectedSpecificationGroupId.equalsIgnoreCase(itemSpecification.getId())) {
                specification = itemSpecification;
                break;
            }
        }

        if (specification != null) {
            if (specificationGroupForAddItem != null) {
                for (ProductSpecification productSpecification : specification.getList()) {
                    if (!modifierIds.contains(productSpecification.getId()) && productSpecification.isIsUserSelected()) {
                        itemsSpecification.add(new SpinnerItem(productSpecification.getId(), productSpecification.getName()));
                    }
                }
            } else {
                for (ProductSpecification productSpecification : specification.getList()) {
                    if (productSpecification.isIsUserSelected()) {
                        itemsSpecification.add(new SpinnerItem(productSpecification.getId(), productSpecification.getName()));
                    }
                }
            }
        }

        CustomSpinnerAdapter adapter = new CustomSpinnerAdapter(this, itemsSpecification);
        spSpecification.setAdapter(adapter);
        spSpecification.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        if (itemSpecification != null) {
            for (int i = 0; i < itemsSpecification.size(); i++) {
                if (itemSpecification.getModifierId() != null
                        && itemSpecification.getModifierId().equalsIgnoreCase(itemsSpecification.get(i).getKey())) {
                    spSpecification.setSelection(i);
                    break;
                }
            }
        }
    }

    /**
     * this method set data according to specification and update UI
     */
    private void setSpecificationDetail(ItemSpecification itemSpecification) {
        if (itemSpecification != null) {
            uniqueId = itemSpecification.getUniqueId();
            specificationGroupId = itemSpecification.getId();
            etSpecificationName.setText(itemSpecification.getName());
            etSpecificationName.setTag(itemSpecification.getNameList());
            etGroupSequenceNumber.setText(String.valueOf(itemSpecification.getSequenceNumber()));
            swUserCanAddSpecificationQuantity.setChecked(itemSpecification.isUserCanAddSpecificationQuantity());
            if (itemSpecification.getMaxRange() == 0 && itemSpecification.getRange() == 0) {
                etStartRange.setText(String.valueOf(0));
                etEndRange.setText(String.valueOf(0));
                spinnerSpecificationRange.setSelection(0);
                updateUIForSelectRangeMax(false);
                isTypeSingle = false;
                switchRequired.setChecked(false);
            } else {
                spinnerSpecificationRange.setSelection(itemSpecification.getMaxRange() > 0 ? 1 : 0);
                updateUIForSelectRangeMax(itemSpecification.getMaxRange() > 0);
                etStartRange.setText(String.valueOf(itemSpecification.getRange()));
                etEndRange.setText(String.valueOf(itemSpecification.getMaxRange()));
                isTypeSingle = itemSpecification.getType() == Constant.TYPE_SPECIFICATION_SINGLE;
                switchRequired.setChecked(itemSpecification.isRequired());
            }
            specificationArrayList.addAll(itemSpecification.getList());
            Collections.sort(specificationArrayList);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        setToolbarSaveIcon(true);
        setToolbarEditIcon(false, 0);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.ivSaveMenu) {
            validate();
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
        if (v.getId() == R.id.etSpecificationName) {
            addMultiLanguageDetail(etSpecificationName.getHint().toString(), (List<String>) etSpecificationName.getTag(), new AddDetailInMultiLanguageDialog.SaveDetails() {
                @Override
                public void onSave(List<String> detailList) {
                    etSpecificationName.setTag(detailList);
                }
            });
        }
    }

    /**
     * this method check that all data which selected by store user is valid or not
     */
    private void validate() {
        setDataForSelectRangeMax();
        if (TextUtils.isEmpty(etSpecificationName.getText().toString())) {
            new CustomAlterDialog(this, null, getString(R.string.msg_empty_item_speci_name)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else if (etStartRange.getText().toString().isEmpty()) {
            etStartRange.setError(getString(R.string.msg_plz_enter_valid_range));
        } else if (spinnerSpecificationRange.getSelectedItemPosition() == 1 && etEndRange.getText().toString().isEmpty()) {
            etEndRange.setError(getString(R.string.msg_plz_enter_valid_range));
        } else if (spinnerSpecificationRange.getSelectedItemPosition() == 1 && Integer.valueOf(etEndRange.getText().toString()) <= Integer.valueOf(etStartRange.getText().toString())) {
            etEndRange.setError(getString(R.string.msg_plz_enter_valid_range));
        } else if (swAssociateModifier.isChecked() && spSpecificationGroup.getSelectedItemPosition() <= 0) {
            Utilities.showToast(this, getString(R.string.msg_plz_select_modifier_group));
        } else if (swAssociateModifier.isChecked() && spSpecification.getSelectedItemPosition() <= 0) {
            Utilities.showToast(this, getString(R.string.msg_plz_select_specification));
        } else {
            boolean isEligibleForAdd = true;
            if (itemSpecification != null) {
                if (itemSpecification.isParentAssociate()) {
                    if (spinnerSpecificationRange.getSelectedItemPosition() != 0
                            || !Objects.requireNonNull(etStartRange.getText()).toString().trim()
                            .equalsIgnoreCase(String.valueOf(Constant.TYPE_SPECIFICATION_SINGLE))) {
                        isEligibleForAdd = false;
                        new CustomAlterDialog(this, getString(R.string.text_attention), getString(R.string.msg_already_modifier_associated_changes),
                                true, getString(R.string.text_update)) {
                            @Override
                            public void btnOnClick(int btnId) {
                                if (btnId == R.id.btnPositive) {
                                    addSpecification();
                                }
                                dismiss();
                            }
                        }.show();
                    }
                }
            } else {
                if (!swAssociateModifier.isChecked()) {
                    for (ItemSpecification itemSpecification : productSpecificationList) {
                        if (specificationGroupId.equalsIgnoreCase(itemSpecification.getId())
                                && itemSpecification.getModifierGroupId() == null && itemSpecification.getModifierId() == null) {
                            Utilities.showToast(this, getString(R.string.msg_specification_already_added));
                            isEligibleForAdd = false;
                            break;
                        }
                    }
                }
            }

            if (isEligibleForAdd) {
                addSpecification();
            }
        }
    }


    /**
     * this method save a selected specification in constant object
     */
    public void addSpecification() {
        int defaultSelectedCount = 0;
        boolean oneSpecificationUserSelected = false;
        for (ProductSpecification productSpecification : addItemSpecificationAdapter.getUpdatedList()) {
            if (productSpecification.isIsDefaultSelected()) {
                defaultSelectedCount++;
            }
            if (productSpecification.isIsUserSelected()) {
                oneSpecificationUserSelected = true;
            }
        }

        int maxDefaultCount = spinnerSpecificationRange.getSelectedItemPosition() == 1 ? Integer.parseInt(etEndRange.getText().toString()) : (Integer.valueOf(etStartRange.getText().toString()) == 0) ? Integer.MAX_VALUE : Integer.valueOf(etStartRange.getText().toString());
        if (!oneSpecificationUserSelected || addItemSpecificationAdapter.getUpdatedList().size() < Integer.parseInt(etStartRange.getText().toString())) {
            new CustomAlterDialog(this, null, getString(R.string.msg_single_type)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else if (defaultSelectedCount > maxDefaultCount) {
            new CustomAlterDialog(this, null, getString(R.string.msg_plz_enter_valid_default_selection)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            }.show();
        } else {
            boolean isParentAssociate = itemSpecification != null && this.itemSpecification.isParentAssociate();

            itemSpecification = new ItemSpecification();
            itemSpecification.setNameList((List<String>) etSpecificationName.getTag());
            itemSpecification.setId(specificationGroupId);
            itemSpecification.setType(isTypeSingle ? Constant.TYPE_SPECIFICATION_SINGLE : Constant.TYPE_SPECIFICATION_MULTIPLE);
            itemSpecification.setRequired(switchRequired.isChecked());
            itemSpecification.setRange(Integer.parseInt(etStartRange.getText().toString()));
            itemSpecification.setMaxRange(Integer.parseInt(etEndRange.getText().toString()));
            itemSpecification.setList(addItemSpecificationAdapter.getUpdatedList());
            itemSpecification.setSequenceNumber(etGroupSequenceNumber.getText().toString().trim().isEmpty() ? 0 : Long.parseLong(etGroupSequenceNumber.getText().toString().trim()));
            itemSpecification.setUserCanAddSpecificationQuantity(swUserCanAddSpecificationQuantity.isChecked());
            itemSpecification.setAssociated(swAssociateModifier.isChecked());
            itemSpecification.setParentAssociate(isParentAssociate && itemSpecification.getType() == Constant.TYPE_SPECIFICATION_SINGLE);
            if (swAssociateModifier.isChecked()) {
                itemSpecification.setModifierGroupId(itemsSpecificationGroup.get(spSpecificationGroup.getSelectedItemPosition()).getKey());
                itemSpecification.setModifierGroupName(itemsSpecificationGroup.get(spSpecificationGroup.getSelectedItemPosition()).getValue());
                itemSpecification.setModifierId(itemsSpecification.get(spSpecification.getSelectedItemPosition()).getKey());
                itemSpecification.setModifierName(itemsSpecification.get(spSpecification.getSelectedItemPosition()).getValue());
            }
            Constant.itemSpecification = itemSpecification;
            Constant.itemSpecification.setUniqueId(uniqueId);
            onBackPressed();
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    private void initSpinnerSpecificationRange() {
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this, R.array.specification_range, R.layout.spinner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_small);
        spinnerSpecificationRange.setAdapter(adapter);
        spinnerSpecificationRange.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                updateUIForSelectRangeMax(TextUtils.equals(adapterView.getItemAtPosition(i).toString(), getString(R.string.text_selected_range_max)));
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }


    private void updateUIForSelectRangeMax(boolean isSelectRangeMax) {
        if (isSelectRangeMax) {
            tvTo.setVisibility(View.VISIBLE);
            etEndRange.setVisibility(View.VISIBLE);
        } else {
            tvTo.setVisibility(View.GONE);
            etEndRange.setVisibility(View.GONE);
            etEndRange.setText(String.valueOf(0));
        }
        setSpecificationQuantityView();
    }

    private void setDataForSelectRangeMax() {
        int startRange = TextUtils.isEmpty(etStartRange.getText().toString()) ? 0 : Integer.parseInt(etStartRange.getText().toString());
        int endRange = TextUtils.isEmpty(etEndRange.getText().toString()) ? 0 : Integer.parseInt(etEndRange.getText().toString());
        isTypeSingle = startRange == 1 && endRange == 0;
        switchRequired.setChecked(startRange != 0);
        setSpecificationQuantityView();
    }

    private void setSpecificationQuantityView() {
        int startRange = TextUtils.isEmpty(etStartRange.getText().toString()) ? 0 : Integer.parseInt(etStartRange.getText().toString());
        llModifierQuantity.setVisibility(spinnerSpecificationRange.getSelectedItemPosition() == 0 && startRange == 1 ? View.GONE : View.VISIBLE);
        if (isTypeSingle) {
            swUserCanAddSpecificationQuantity.setChecked(false);
        }
    }

    private void addMultiLanguageDetail(String title, List<String> detailMap, @NonNull AddDetailInMultiLanguageDialog.SaveDetails saveDetails) {
        if (addDetailInMultiLanguageDialog != null && addDetailInMultiLanguageDialog.isShowing()) {
            return;
        }
        addDetailInMultiLanguageDialog = new AddDetailInMultiLanguageDialog(this, title, saveDetails, detailMap, false);
        addDetailInMultiLanguageDialog.show();
    }
}