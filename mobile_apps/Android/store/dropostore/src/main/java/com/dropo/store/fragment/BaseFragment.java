package com.dropo.store.fragment;

import android.os.Bundle;
import android.view.View;

import androidx.fragment.app.Fragment;

import com.dropo.store.HomeActivity;

public class BaseFragment extends Fragment implements View.OnClickListener {

    protected HomeActivity activity;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (HomeActivity) getActivity();
    }

    @Override
    public void onClick(View v) {

    }
}