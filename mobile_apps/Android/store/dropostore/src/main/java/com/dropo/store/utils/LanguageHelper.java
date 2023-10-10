package com.dropo.store.utils;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.text.TextUtils;

import com.dropo.store.R;
import com.dropo.store.models.singleton.Language;

import java.util.Locale;

public class LanguageHelper extends ContextWrapper {

    public LanguageHelper(Context base) {
        super(base);
    }

    public static ContextWrapper wrapper(Context context, String language) {
        Resources res = context.getResources();
        Configuration config = res.getConfiguration();
        Locale sysLocale = config.locale;
        if (!sysLocale.getLanguage().equals(language)) {
            if (TextUtils.isEmpty(language)) {
                language = "en";
                TypedArray typedArray = context.getResources().obtainTypedArray(R.array.language_code);
                for (int i = 0; i < typedArray.length(); i++) {
                    if (TextUtils.equals(typedArray.getString(i), sysLocale.getLanguage())) {
                        language = sysLocale.getLanguage();
                        PreferenceHelper.getPreferenceHelper(context).putLanguageCode(language);
                        Language.getInstance().setAdminLanguageIndex(
                                Utilities.getLangIndex(language, Language.getInstance().getAdminLanguages(), false),
                                language);
                        Language.getInstance().setStoreLanguageIndex(
                                Utilities.getLangIndex(language, Language.getInstance().getStoreLanguages(), true)
                        );
                    }
                }
            }

            Locale locale = new Locale(language);
            Locale.setDefault(locale);
            config.locale = locale;
            config.setLayoutDirection(locale);
            res.updateConfiguration(config, res.getDisplayMetrics());
        }
        return new LanguageHelper(context);
    }
}