package com.dropo.utils;

import android.content.Context;
import android.graphics.Typeface;

import androidx.annotation.Nullable;

import org.jetbrains.annotations.NotNull;

import java.util.Hashtable;

public final class FontCache {
    @NotNull
    public static final FontCache INSTANCE;
    private static final Hashtable<String, Typeface> fontCache;

    static {
        INSTANCE = new FontCache();
        fontCache = new Hashtable<>();
    }

    private FontCache() {
    }

    @Nullable
    public Typeface get(@NotNull String name, @NotNull Context context) {
        Typeface tf = fontCache.get(name);
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
}
