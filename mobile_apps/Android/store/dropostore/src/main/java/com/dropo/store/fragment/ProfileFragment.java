package com.dropo.store.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.BuildConfig;
import com.dropo.store.R;
import com.dropo.store.BankDetailActivity;
import com.dropo.store.HelpActivity;
import com.dropo.store.HistoryActivity;
import com.dropo.store.InstantOrderActivity;
import com.dropo.store.NotificationActivity;
import com.dropo.store.PaymentActivity;
import com.dropo.store.ProductGroupsActivity;
import com.dropo.store.PromoCodeActivity;
import com.dropo.store.ReviewActivity;
import com.dropo.store.SettingsActivity;
import com.dropo.store.SpecificationGroupActivity;
import com.dropo.store.StoreOrderProductActivity;
import com.dropo.store.SubStoresActivity;
import com.dropo.store.UpdateProfileActivity;
import com.dropo.store.adapter.ProfileMenuAdapter;
import com.dropo.store.component.ServerDialog;
import com.dropo.store.interfaces.TripleTapListener;
import com.dropo.store.models.singleton.Language;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.RecyclerOnItemListener;
import com.dropo.store.utils.ServerConfig;
import com.dropo.store.utils.Utilities;



public class ProfileFragment extends BaseFragment implements RecyclerOnItemListener.OnItemClickListener {

    private Spinner spinnerLanguage;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = LayoutInflater.from(activity).inflate(R.layout.fragment_profile, container, false);
        RecyclerView recyclerView = view.findViewById(R.id.recyclerView);

        ((TextView) view.findViewById(R.id.tvVersion)).setText(activity.getResources().getString(R.string.text_app_version).concat(" " + BuildConfig.VERSION_NAME));

        if (BuildConfig.APPLICATION_ID.equalsIgnoreCase("com.elluminati.edelivery.store")) {
            view.findViewById(R.id.tvVersion).setOnTouchListener(new TripleTapListener() {
                @Override
                protected void onTripleTap() {
                    showServerDialog();
                }
            });
        }

        recyclerView.setLayoutManager(new LinearLayoutManager(activity));
        recyclerView.setAdapter(new ProfileMenuAdapter(activity));
        recyclerView.addOnItemTouchListener(new RecyclerOnItemListener(activity, this));

        swipeLayoutSetup();

        spinnerLanguage = view.findViewById(R.id.spinnerLanguage);
        return view;
    }

    private void showServerDialog() {
        ServerDialog serverDialog = new ServerDialog(activity) {
            @Override
            public void onOkClicked() {
                PreferenceHelper.getPreferenceHelper(activity).putBaseUrl(ServerConfig.BASE_URL);
                PreferenceHelper.getPreferenceHelper(activity).putUserPanelUrl(ServerConfig.USER_PANEL_URL);
                PreferenceHelper.getPreferenceHelper(activity).putImageUrl(ServerConfig.IMAGE_URL);
                activity.logoutForServer();
            }
        };
        serverDialog.show();
    }

    private void swipeLayoutSetup() {
        activity.mainSwipeLayout.setEnabled(false);
        activity.mainSwipeLayout.setOnRefreshListener(null);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        activity.toolbar.setElevation(getResources().getDimensionPixelSize(R.dimen.dimen_app_toolbar_elevation));
        initLanguageSpinner();
    }

    @Override
    public void onClick(View v) {
        super.onClick(v);
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public void onItemClick(View view, int position) {
        switch (position) {
            case 0:
                activity.startActivity(new Intent(activity, UpdateProfileActivity.class));
                break;
            case 1:
                activity.startActivity(new Intent(activity, HistoryActivity.class));
                break;
            case 2:
                activity.startActivity(new Intent(activity, ProductGroupsActivity.class));
                break;
            case 3:
                activity.startActivity(new Intent(activity, SpecificationGroupActivity.class));
                break;
            case 4:
                activity.goToDocumentActivity(false);
                break;
            case 5:
                goToBankDetailActivity();
                break;
            case 6:
                activity.goToEarningActivity();
                break;
            case 7:
                goToPaymentsActivity();
                break;
            case 8:
                activity.startActivity(new Intent(activity, SettingsActivity.class));
                break;
            case 9:
                goToSubStoreActivity();
                break;
            case 10:
                goToStoreOrderProductActivity();
                break;
            case 11:
                goToInstantOrderActivity();
                break;
            case 12:
                goToReviewActivity();
                break;
            case 13:
                goToPromoActivity();
                break;
            case 14:
                goToNotificationActivity();
                break;
            case 15:
                goToHelpActivity();
                break;
            default:
                activity.openLogoutDialog();
                break;
        }
    }

    private void goToBankDetailActivity() {
        Intent intent = new Intent(activity, BankDetailActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToPaymentsActivity() {
        Intent intent = new Intent(activity, PaymentActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToStoreOrderProductActivity() {
        Intent intent = new Intent(activity, StoreOrderProductActivity.class);
        intent.putExtra(Constant.IS_ORDER_UPDATE, false);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToReviewActivity() {
        Intent intent = new Intent(activity, ReviewActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToPromoActivity() {
        Intent intent = new Intent(activity, PromoCodeActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToNotificationActivity() {
        Intent intent = new Intent(activity, NotificationActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToHelpActivity() {
        Intent intent = new Intent(activity, HelpActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToInstantOrderActivity() {
        Intent intent = new Intent(activity, InstantOrderActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    private void goToSubStoreActivity() {
        Intent intent = new Intent(activity, SubStoresActivity.class);
        startActivity(intent);
        activity.overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
    }

    @SuppressLint("Recycle")
    private void initLanguageSpinner() {
        TypedArray array = activity.getResources().obtainTypedArray(R.array.language_code);
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(activity, R.array.language_name, R.layout.spinner_view_small);
        adapter.setDropDownViewResource(R.layout.item_spinner_view_small);
        spinnerLanguage.setAdapter(adapter);

        spinnerLanguage.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                String languageCode = array.getString(i);
                if (!TextUtils.equals(activity.preferenceHelper.getLanguageCode(), languageCode)) {
                    activity.preferenceHelper.putLanguageCode(languageCode);
                    Language.getInstance().setAdminLanguageIndex(
                            Utilities.getLangIndex(languageCode, Language.getInstance().getAdminLanguages(), false),
                            languageCode);
                    Language.getInstance().setStoreLanguageIndex(
                            Utilities.getLangIndex(languageCode, Language.getInstance().getStoreLanguages(), true)
                    );
                    activity.finishAffinity();
                    activity.restartApp();
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        int size = array.length();
        for (int i = 0; i < size; i++) {
            if (TextUtils.equals(activity.preferenceHelper.getLanguageCode(), array.getString(i))) {
                spinnerLanguage.setSelection(i);
                break;
            }
        }
    }
}