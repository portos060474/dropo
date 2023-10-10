package com.dropo.store.models.singleton;

import android.os.Bundle;
import android.os.Parcel;
import android.os.Parcelable;

import com.dropo.store.models.datamodel.Languages;
import com.dropo.store.parse.ApiClient;

import java.util.ArrayList;

/**
 * Created by Ravi Bhalodi on 13,January,2020 in Elluminati
 */
public class Language implements Parcelable {
    public static final Creator<Language> CREATOR = new Creator<Language>() {
        @Override
        public Language createFromParcel(Parcel in) {
            return new Language(in);
        }

        @Override
        public Language[] newArray(int size) {
            return new Language[size];
        }
    };
    private static Language language;
    private ArrayList<Languages> storeLanguages;
    private ArrayList<Languages> adminLanguages;
    private int adminLanguageIndex;
    private int storeLanguageIndex;

    private Language() {
    }

    protected Language(Parcel in) {
        storeLanguages = in.createTypedArrayList(Languages.CREATOR);
        adminLanguages = in.createTypedArrayList(Languages.CREATOR);
        adminLanguageIndex = in.readInt();
        storeLanguageIndex = in.readInt();
    }

    public static Language getInstance() {
        if (language == null) {
            language = new Language();
        }
        return language;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putParcelable("language", language);
        }
    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            language = state.getParcelable("language");
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(storeLanguages);
        dest.writeTypedList(adminLanguages);
        dest.writeInt(adminLanguageIndex);
        dest.writeInt(storeLanguageIndex);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public ArrayList<Languages> getStoreLanguages() {
        return storeLanguages != null ? storeLanguages : new ArrayList<Languages>();
    }

    public void setStoreLanguages(ArrayList<Languages> storeLanguages) {
        this.storeLanguages = storeLanguages;
    }

    public ArrayList<Languages> getAdminLanguages() {
        return adminLanguages != null ? adminLanguages : new ArrayList<Languages>();
    }

    public void setAdminLanguages(ArrayList<Languages> adminLanguages) {
        this.adminLanguages = adminLanguages;
    }

    public int getAdminLanguageIndex() {
        return adminLanguageIndex;
    }

    public void setAdminLanguageIndex(int adminLanguageIndex, String languageCode) {
        this.adminLanguageIndex = adminLanguageIndex;
        ApiClient.setLanguage(String.valueOf(adminLanguageIndex));
        ApiClient.setLanguageCode(languageCode);
    }

    public int getStoreLanguageIndex() {
        return storeLanguageIndex;
    }

    public void setStoreLanguageIndex(int storeLanguageIndex) {
        this.storeLanguageIndex = storeLanguageIndex;
    }
}
