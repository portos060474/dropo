package com.dropo.store.fragment;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.dropo.store.HistoryDetailActivity;

public class BaseHistoryFragment extends Fragment implements View.OnClickListener {
    protected HistoryDetailActivity activity;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = (HistoryDetailActivity) getActivity();
    }

    @Override
    public void onClick(View v) {

    }
}
