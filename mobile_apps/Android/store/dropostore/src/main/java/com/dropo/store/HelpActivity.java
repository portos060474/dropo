package com.dropo.store;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.view.Menu;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.dropo.store.utils.AppColor;
import com.dropo.store.utils.Utilities;
import com.dropo.store.widgets.CustomTextView;

public class HelpActivity extends BaseActivity {

    private LinearLayout llMail, llCall;
    private CustomTextView tvTandC, tvPolicy;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_help);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> onBackPressed());
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getString(R.string.text_help));
        llCall = findViewById(R.id.llCall);
        llMail = findViewById(R.id.llMail);
        tvTandC = findViewById(R.id.tvTandC);
        tvPolicy = findViewById(R.id.tvPolicy);
        tvTandC.setText(Utilities.fromHtml("<a href=\"" + preferenceHelper.getTermsANdConditions() + "\"" + ">" + getResources().getString(R.string.text_t_and_c) + "</a>"));
        tvTandC.setMovementMethod(LinkMovementMethod.getInstance());
        tvPolicy.setText(Utilities.fromHtml("<a href=\"" + preferenceHelper.getPolicy() + "\"" + ">" + getResources().getString(R.string.text_policy) + "</a>"));
        tvPolicy.setMovementMethod(LinkMovementMethod.getInstance());
        tvTandC.setLinkTextColor(AppColor.COLOR_THEME);
        tvPolicy.setLinkTextColor(AppColor.COLOR_THEME);
        llCall.setOnClickListener(this);
        llMail.setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.llCall) {
            Utilities.openCallChooser(HelpActivity.this, preferenceHelper.getAdminContact());
        } else if (id == R.id.llMail) {
            contactUsWithAdmin();
        }
    }

    public void contactUsWithAdmin() {
        Uri gmmIntentUri = Uri.parse("mailto:" + preferenceHelper.getAdminContactEmail() + "?subject=" + "Request to Admin" + "&body=" + "Hello sir");
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.gm");
        if (mapIntent.resolveActivity(getPackageManager()) != null) {
            startActivity(mapIntent);
        } else {
            Utilities.showToast(this, getResources().getString(R.string.msg_google_mail_app_not_installed));
        }
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }
}