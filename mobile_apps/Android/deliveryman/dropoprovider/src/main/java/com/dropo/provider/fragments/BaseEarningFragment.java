package com.dropo.provider.fragments;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dropo.provider.EarningActivity;

public abstract class BaseEarningFragment extends Fragment implements View.OnClickListener {

    protected EarningActivity earningActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        earningActivity = (EarningActivity) getActivity();
    }
}