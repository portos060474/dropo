package com.dropo;

import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.view.View;
import android.widget.LinearLayout;

import com.dropo.component.CustomFontTextView;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.Utils;

public class HelpActivity extends BaseAppCompatActivity {

    private LinearLayout llMail, llCall;
    private CustomFontTextView tvTandC, tvPolicy;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_help);
        initToolBar();
        setTitleOnToolBar(getResources().getString(R.string.text_help));
        initViewById();
        setViewListener();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        llCall = findViewById(R.id.llCall);
        llMail = findViewById(R.id.llMail);
        tvTandC = findViewById(R.id.tvTandC);
        tvPolicy = findViewById(R.id.tvPolicy);
        tvTandC.setText(Utils.fromHtml("<a href=\"" + preferenceHelper.getTermsANdConditions() + "\"" + ">" + getResources().getString(R.string.text_t_and_c) + "</a>"));
        tvTandC.setMovementMethod(LinkMovementMethod.getInstance());
        tvPolicy.setText(Utils.fromHtml("<a href=\"" + preferenceHelper.getPolicy() + "\"" + ">" + getResources().getString(R.string.text_policy) + "</a>"));
        tvPolicy.setMovementMethod(LinkMovementMethod.getInstance());
        tvTandC.setLinkTextColor(AppColor.COLOR_THEME);
        tvPolicy.setLinkTextColor(AppColor.COLOR_THEME);
    }

    @Override
    protected void setViewListener() {
        llCall.setOnClickListener(this);
        llMail.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {
        onBackPressed();
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.llCall) {
            Utils.openCallChooser(HelpActivity.this, preferenceHelper.getAdminContact());
        } else if (id == R.id.llMail) {
            contactUsWithAdmin();
        }
    }
}