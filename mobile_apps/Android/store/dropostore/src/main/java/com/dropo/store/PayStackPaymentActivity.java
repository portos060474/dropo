package com.dropo.store;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;

import com.dropo.store.utils.Constant;
import com.dropo.store.utils.ServerConfig;
import com.dropo.store.utils.Utilities;

public class PayStackPaymentActivity extends BaseActivity {

    @SuppressLint("SetJavaScriptEnabled")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_paystack_payment);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        toolbar.setNavigationOnClickListener(view -> {
            Utilities.hideSoftKeyboard(PayStackPaymentActivity.this);
            onBackPressed();
        });
        String payUHtml = getIntent().getStringExtra(Constant.PAYU_HTML);
        WebView webViewTerms = findViewById(R.id.webview);
        webViewTerms.getSettings().setLoadsImagesAutomatically(true);
        webViewTerms.getSettings().setDisplayZoomControls(false);
        webViewTerms.getSettings().setBuiltInZoomControls(true);
        webViewTerms.getSettings().setJavaScriptEnabled(true);
        webViewTerms.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        webViewTerms.getSettings().setDomStorageEnabled(true);
        if (TextUtils.isEmpty(payUHtml)) {
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getResources().getString(R.string.text_add_card));
            webViewTerms.loadUrl(getIntent().getStringExtra(Constant.AUTHORIZATION_URL));
        } else {
            ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getResources().getString(R.string.text_payments));
            webViewTerms.loadDataWithBaseURL(null, payUHtml, "text/html", "utf-8", null);
        }
        webViewTerms.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                if (url.contains("add_card_success")) {
                    setResult(RESULT_OK);
                    finish();
                } else if (url.contains(ServerConfig.BASE_URL + "payments")) {
                    setResult(RESULT_OK);
                    finish();
                } else if (url.contains(ServerConfig.BASE_URL + "payment_fail")) {
                    setResult(RESULT_CANCELED);
                    finish();
                } else if (url.contains(ServerConfig.BASE_URL + "fail_stripe_intent_payment")) {
                    setResult(RESULT_CANCELED);
                    finish();
                }
                return super.shouldOverrideUrlLoading(view, url);
            }
        });
    }

    @Override
    public void onClick(View v) {

    }
}