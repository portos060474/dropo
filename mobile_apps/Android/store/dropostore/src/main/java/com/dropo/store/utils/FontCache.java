package com.dropo.store.utils;

import android.content.Context;
import android.graphics.Typeface;

import androidx.annotation.Nullable;

import org.jetbrains.annotations.NotNull;

import java.util.Hashtable;

public final class FontCache {
    private static final Hashtable<String, Typeface> fontCache;
    @NotNull
    public static final FontCache INSTANCE;

    @Nullable
    public Typeface get(@NotNull String name, @NotNull Context context) {
        Typeface tf = (Typeface) fontCache.get(name);
        if (tf == null) {
            try {
                tf = Typeface.createFromAsset(context.getAssets(), name);
            } catch (Exception var5) {
                return null;
            }
            fontCache.put(name, tf);
        }
        return tf;
    }

    private FontCache() {
    }

    static {
        INSTANCE = new FontCache();
        fontCache = new Hashtable<>();
    }
}
