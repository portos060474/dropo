package com.dropo.store.component.tag.utils;

import android.graphics.Bitmap;
import android.graphics.Matrix;

public final class BitmapUtils {

    private BitmapUtils() {
        throw new AssertionError();
    }

    public static Bitmap zoom(Bitmap bitmap, int w, int h) {
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        Matrix matrix = new Matrix();
        float scaleWidth = ((float) w / width);
        float scaleHeight = ((float) h / height);
        matrix.postScale(scaleWidth, scaleHeight);
        Bitmap newBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
        return newBitmap;
    }
}
