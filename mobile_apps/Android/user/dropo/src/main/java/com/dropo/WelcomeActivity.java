package com.dropo;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.viewpager.widget.ViewPager;

import com.dropo.adapter.WelcomePagerAdapter;
import com.dropo.component.CustomFontButton;
import com.dropo.component.CustomFontTextView;
import com.dropo.user.R;
import com.dropo.utils.AppColor;
import com.dropo.utils.Utils;

public class WelcomeActivity extends BaseAppCompatActivity {

    private ViewPager viewPager;
    private WelcomePagerAdapter welcomePagerAdapter;
    private int[] image;
    private CustomFontButton btnSkip, btnNext;
    private CustomFontTextView tvTitle, tvSubTitle;
    private LinearLayout llIndicator;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_welcome);
        initViewById();
        setViewListener();
        initWelcomePager();
    }

    @Override
    protected boolean isValidate() {
        return false;
    }

    @Override
    protected void initViewById() {
        viewPager = findViewById(R.id.view_pager);
        tvTitle = findViewById(R.id.tvTitle);
        llIndicator = findViewById(R.id.llIndicator);
        tvSubTitle = findViewById(R.id.tvSubTitle);
        btnSkip = findViewById(R.id.btnSkip);
        btnNext = findViewById(R.id.btnNext);
        btnSkip.setTextColor(AppColor.COLOR_THEME);
    }

    @Override
    protected void setViewListener() {
        btnSkip.setOnClickListener(this);
        btnNext.setOnClickListener(this);
    }

    @Override
    protected void onBackNavigation() {

    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.btnSkip) {
            preferenceHelper.putIsHideWelcomeScreen(true);
            if (ContextCompat.checkSelfPermission(WelcomeActivity.this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(WelcomeActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                goToMandatoryDeliveryLocationActivity();
            } else {
                goToHomeActivity();
            }
        } else if (id == R.id.btnNext) {
            viewPager.setCurrentItem(viewPager.getCurrentItem() + 1);
        }
    }

    private void initWelcomePager() {
        if (AppColor.isDarkTheme(this)) {
            image = new int[]{R.drawable.wc_img_dark_1, R.drawable.wc_img_dark_2, R.drawable.wc_img_dark_3};
        } else {
            image = new int[]{R.drawable.wc_img_white_1, R.drawable.wc_img_white_2, R.drawable.wc_img_white_3};
        }
        addBottomDots(llIndicator, image.length, 0);
        changeStatusBarColor();
        welcomePagerAdapter = new WelcomePagerAdapter(this, image);
        viewPager.setAdapter(welcomePagerAdapter);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (position == (welcomePagerAdapter.getCount() - 1)) {
                    btnNext.setVisibility(View.GONE);
                } else {
                    btnNext.setVisibility(View.VISIBLE);
                }
                dotColorChange(llIndicator, position);
                tvTitle.setText(Utils.getWelcomeTitle(position + 1, WelcomeActivity.this));
                tvSubTitle.setText(Utils.getWelcomeSubTitle(position + 1, WelcomeActivity.this));
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    private void changeStatusBarColor() {
        Window window = getWindow();
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.setStatusBarColor(Color.TRANSPARENT);
    }

    private void addBottomDots(LinearLayout layout, int dotCount, int currentPage) {
        if (dotCount > 0) {
            layout.removeAllViews();
            TextView[] dots = new TextView[dotCount];
            for (int i = 0; i < dots.length; i++) {
                dots[i] = new TextView(this);
                dots[i].setWidth((int) getResources().getDimension(R.dimen.dimen_horizontal_margin));
                dots[i].setHeight((int) getResources().getDimension(R.dimen.activity_horizontal_padding));
                dots[i].setBackground(ContextCompat.getDrawable(this, R.drawable.selector_round_theme_bg_alpha));
                layout.addView(dots[i]);
                LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) dots[i].getLayoutParams();
                params.setMargins((int) getResources().getDimension(R.dimen.pv_pin_view_cursor_width), 0, (int) getResources().getDimension(R.dimen.pv_pin_view_cursor_width), 0);
            }
            dots[currentPage].setBackground(ContextCompat.getDrawable(this, R.drawable.selector_round_theme_bg));
        }
    }

    private void dotColorChange(LinearLayout layout, int currentPage) {
        for (int i = 0; i < layout.getChildCount(); i++) {
            TextView textView = (TextView) layout.getChildAt(i);
            textView.setBackground(ContextCompat.getDrawable(this, R.drawable.selector_round_theme_bg_alpha));
        }
        TextView textView = (TextView) layout.getChildAt(currentPage);
        textView.setBackground(ContextCompat.getDrawable(this, R.drawable.selector_round_theme_bg));
    }
}
