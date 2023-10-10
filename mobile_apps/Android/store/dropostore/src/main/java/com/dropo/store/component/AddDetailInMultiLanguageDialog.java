package com.dropo.store.component;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.models.singleton.Language;

import com.google.android.material.bottomsheet.BottomSheetDialog;
import com.google.android.material.textfield.TextInputLayout;

import java.util.ArrayList;
import java.util.List;

public class AddDetailInMultiLanguageDialog extends BottomSheetDialog {

    private final String dialogTitle;
    private final Context context;
    private final SaveDetails saveDetails;
    private final List<String> detailList;
    private final boolean isAdminLanguage;
    private LinearLayout llContainer;

    public AddDetailInMultiLanguageDialog(@NonNull Context context, @NonNull String dialogTitle, @NonNull SaveDetails saveDetails, List<String> detailList, boolean isAdminLanguage) {
        super(context);
        this.dialogTitle = dialogTitle;
        this.context = context;
        this.saveDetails = saveDetails;
        this.detailList = detailList;
        this.isAdminLanguage = isAdminLanguage;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_deatil_in_multi_language);
        TextView txDialogTitle = findViewById(R.id.txDialogTitle);
        txDialogTitle.setText(dialogTitle);
        llContainer = findViewById(R.id.llContainer);
        ArrayList<Languages> languages;
        if (isAdminLanguage) languages = Language.getInstance().getAdminLanguages();
        else languages = Language.getInstance().getStoreLanguages();
        if (languages != null && !languages.isEmpty()) {
            for (int i = 0; i < languages.size(); i++) {
                Languages language = languages.get(i);
                View view = LayoutInflater.from(context).inflate(R.layout.item_multi_language_detail, null);
                TextInputLayout textInputLayout = view.findViewById(R.id.tilLanguage);
                textInputLayout.setHint(language.getName());
                textInputLayout.setTag(language.getCode());
                if (detailList != null && !detailList.isEmpty() && i < detailList.size()) {
                    EditText editText = textInputLayout.getEditText();
                    editText.setText(detailList.get(i));
                }
                if (!language.isVisible() && !isAdminLanguage) {
                    textInputLayout.setVisibility(View.GONE);
                } else {
                    textInputLayout.setVisibility(View.VISIBLE);
                }

                llContainer.addView(view);
            }
        }
        findViewById(R.id.btnNegative).setOnClickListener(v -> dismiss());
        findViewById(R.id.btnPositive).setOnClickListener(v -> {
            boolean isDefaultDataNotSet = false;
            if (llContainer.getChildCount() > 0) {
                List<String> detailList = new ArrayList<>();
                int size = llContainer.getChildCount();
                for (int i = 0; i < size; i++) {
                    TextInputLayout textInputLayout = (TextInputLayout) llContainer.getChildAt(i);
                    EditText editText = textInputLayout.getEditText();
                    if (i == 0 && TextUtils.isEmpty(editText.getText().toString().trim())) {
                        isDefaultDataNotSet = true;
                        editText.setError(context.getResources().getString(R.string.msg_enter_detail_for_default_language));
                        break;
                    }
                    if (!TextUtils.isEmpty(editText.getText().toString().trim())) {
                        detailList.add(editText.getText().toString().trim());
                    }

                }

                saveDetails.onSave(detailList);
            }
            if (!isDefaultDataNotSet) dismiss();
        });

        WindowManager.LayoutParams params = getWindow().getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        setCancelable(true);
    }

    public interface SaveDetails {
        void onSave(List<String> detailList);
    }
}