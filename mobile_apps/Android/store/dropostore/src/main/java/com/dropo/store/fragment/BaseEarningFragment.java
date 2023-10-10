package com.dropo.store.fragment;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dropo.store.EarningActivity;

public abstract class BaseEarningFragment extends Fragment implements View.OnClickListener {
    protected String TAG = this.getClass().getSimpleName();

    protected EarningActivity earningActivity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        earningActivity = (EarningActivity) getActivity();
    }
}