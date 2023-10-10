package com.dropo.interfaces;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

public abstract class TripleTapListener implements View.OnTouchListener {

    final Handler handler = new Handler();
    int numberOfTaps = 0;
    long lastTapTimeMs = 0;
    long touchDownMs = 0;

    @SuppressLint("ClickableViewAccessibility")
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                touchDownMs = System.currentTimeMillis();
                break;
            case MotionEvent.ACTION_UP:
                handler.removeCallbacksAndMessages(null);
                if (System.currentTimeMillis() - touchDownMs > ViewConfiguration.getTapTimeout()) {
                    numberOfTaps = 0;
                    lastTapTimeMs = 0;
                }
                if (numberOfTaps > 0
                        && System.currentTimeMillis() - lastTapTimeMs < ViewConfiguration.getDoubleTapTimeout()
                ) {
                    numberOfTaps += 1;
                } else {
                    numberOfTaps = 1;
                }
                lastTapTimeMs = System.currentTimeMillis();

                if (numberOfTaps == 3) {
                    onTripleTap();
                }
        }
        return true;
    }

    protected abstract void onTripleTap();
}
