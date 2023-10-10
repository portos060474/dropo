package com.dropo.fragments;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.user.R;
import com.dropo.StoreProductActivity;
import com.dropo.adapter.StoreTimeAdapter;
import com.dropo.component.CustomFontTextView;
import com.dropo.component.CustomPhotoDialog;
import com.dropo.utils.Utils;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

public class OverviewFragment extends BottomSheetDialogFragment implements View.OnClickListener {

    private CustomFontTextView tvStoreAddress, tvSlogan, tvStoreTime, tvStoreWebsite, tvStorePhoneNumber;
    private TextView btnShare, btnGetDirection;
    private StoreProductActivity storeProductActivity;
    private RecyclerView rcvStoreTime;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        storeProductActivity = (StoreProductActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_overview, container, false);
        tvStoreAddress = view.findViewById(R.id.tvStoreAddress);
        tvSlogan = view.findViewById(R.id.tvSlogan);
        tvStoreTime = view.findViewById(R.id.tvStoreTime);
        tvStoreWebsite = view.findViewById(R.id.tvStoreWebsite);
        tvStorePhoneNumber = view.findViewById(R.id.tvStorePhoneNumber);
        btnGetDirection = view.findViewById(R.id.btnGetDirection);
        btnShare = view.findViewById(R.id.btnShare);
        rcvStoreTime = view.findViewById(R.id.rcvStoreTime);
        view.findViewById(R.id.btnDialogAlertLeft).setOnClickListener(view1 -> dismiss());
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        btnGetDirection.setOnClickListener(this);
        btnShare.setOnClickListener(this);

        if (storeProductActivity.store != null) {
            tvStoreAddress.setText(storeProductActivity.store.getAddress());
            tvSlogan.setText(storeProductActivity.store.getSlogan());
            tvStoreWebsite.setText(storeProductActivity.store.getWebsiteUrl());
            tvStorePhoneNumber.setText(String.format("%s%s", storeProductActivity.store.getCountryPhoneCode(), storeProductActivity.store.getPhone()));
            tvStoreAddress.setVisibility(TextUtils.isEmpty(storeProductActivity.store.getAddress()) ? View.GONE : View.VISIBLE);
            tvSlogan.setVisibility(TextUtils.isEmpty(storeProductActivity.store.getSlogan()) ? View.GONE : View.VISIBLE);
            tvStoreWebsite.setVisibility(TextUtils.isEmpty(storeProductActivity.store.getWebsiteUrl()) ? View.GONE : View.VISIBLE);
            tvStorePhoneNumber.setVisibility(TextUtils.isEmpty(storeProductActivity.store.getPhone()) ? View.GONE : View.VISIBLE);
            rcvStoreTime.setLayoutManager(new LinearLayoutManager(storeProductActivity));
            rcvStoreTime.setAdapter(new StoreTimeAdapter(storeProductActivity.store.getStoreTime()));
            if (storeProductActivity.store.getWebsiteUrl().isEmpty()) {
                btnShare.setVisibility(View.GONE);
            }
        }
        rcvStoreTime.setNestedScrollingEnabled(false);
        rcvStoreTime.setVisibility(View.GONE);
        tvStoreTime.setOnClickListener(this);
        tvStorePhoneNumber.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.tvStoreWebsite) {
            Utils.openWebPage(storeProductActivity, storeProductActivity.store.getWebsiteUrl());
        } else if (id == R.id.btnGetDirection) {
            openPhotoMapDialog();
        } else if (id == R.id.btnShare) {
            shareStoreDetail();
        } else if (id == R.id.tvStorePhoneNumber) {
            Utils.openCallChooser(storeProductActivity, storeProductActivity.store.getCountryPhoneCode() + storeProductActivity.store.getPhone());
        } else if (id == R.id.tvStoreTime) {
            if (rcvStoreTime.getVisibility() == View.GONE) {
                rcvStoreTime.setVisibility(View.VISIBLE);
                tvStoreTime.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(storeProductActivity, R.drawable.ic_store_opening), null, AppCompatResources.getDrawable(storeProductActivity, R.drawable.ic_arrow_drop_up), null);
            } else {
                rcvStoreTime.setVisibility(View.GONE);
                tvStoreTime.setCompoundDrawablesRelativeWithIntrinsicBounds(AppCompatResources.getDrawable(storeProductActivity, R.drawable.ic_store_opening), null, AppCompatResources.getDrawable(storeProductActivity, R.drawable.ic_arrow_drop_down), null);
            }
        }
    }

    /**
     * this method is used to open Google Map app whit given LatLng
     */
    private void goToGoogleMapApp() {
        Uri gmmIntentUri = Uri.parse("google.navigation:q=" + storeProductActivity.store.getLocation().get(0) + "," + storeProductActivity.store.getLocation().get(1));
        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
        mapIntent.setPackage("com.google.android.apps.maps");
        if (mapIntent.resolveActivity(storeProductActivity.getPackageManager()) != null) {
            startActivity(mapIntent);
        } else {
            Utils.showToast(getResources().getString(R.string.msg_google_app_not_installed), storeProductActivity);
        }
    }

    /**
     * this method is used to open Waze Map app whit given LatLng
     */
    private void goToWazeMapApp() {
        try {
            String url = "waze://?ll=" + storeProductActivity.store.getLocation().get(0) + "," + storeProductActivity.store.getLocation().get(1) + "&navigate=yes";
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            startActivity(intent);
        } catch (ActivityNotFoundException ex) {
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.waze"));
            startActivity(intent);
            Utils.showToast(getResources().getString(R.string.waze_map_msg), storeProductActivity);
        }
    }

    private void openPhotoMapDialog() {
        //Do the stuff that requires permission...
        CustomPhotoDialog customPhotoDialog = new CustomPhotoDialog(storeProductActivity, getResources().getString(R.string.text_choose_map), getResources().getString(R.string.text_google_map), getResources().getString(R.string.text_waze_map)) {
            @Override
            public void clickedOnCamera() {
                goToGoogleMapApp();
                dismiss();
            }

            @Override
            public void clickedOnGallery() {
                goToWazeMapApp();
                dismiss();
            }
        };
        customPhotoDialog.show();
    }

    private void shareStoreDetail() {
        String msg = getResources().getString(R.string.text_try) + " " + storeProductActivity.store.getName() + "" + "(" + storeProductActivity.store.getWebsiteUrl() + ") " + getResources().getString(R.string.text_share_text).replace("*****", getString(R.string.app_name));
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, msg);
        startActivity(Intent.createChooser(sharingIntent, getResources().getString(R.string.msg_share_referral)));
    }
}