package com.dropo.store.parse;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dropo.store.BuildConfig;
import com.dropo.store.R;
import com.dropo.store.utils.Constant;
import com.dropo.store.utils.ServerConfig;
import com.dropo.store.utils.Utilities;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

public class ApiClient {

    public static final String Tag = "ApiClient";

    private static final int CONNECTION_TIMEOUT = 30; //seconds
    private static final int READ_TIMEOUT = 20; //seconds
    private static final int WRITE_TIMEOUT = 20; //seconds
    private static final MediaType MEDIA_TYPE_TEXT = MediaType.parse("text/plain");
    private static final MediaType MEDIA_TYPE_IMAGE = MediaType.parse("image/*");
    private static Retrofit retrofit = null;
    private static Gson gson;
    private static String lang;
    private static String langCode;
    private static String storeId;
    private static String subStoreId;
    private static String serverToken;

    public static Retrofit getClient() {
        if (retrofit == null) {
            OkHttpClient.Builder okHttpClient;
            okHttpClient = new OkHttpClient().newBuilder()
                    .connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS)
                    .readTimeout(READ_TIMEOUT, TimeUnit.SECONDS)
                    .writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS);
            okHttpClient.addInterceptor(chain -> {
                Request request = chain.request().newBuilder()
                        .addHeader(Constant.LANG, lang)
                        .addHeader(Constant.LANG_CODE, langCode)
                        .addHeader(Constant.STOREID, TextUtils.isEmpty(storeId) ? "" : storeId)
                        .addHeader(Constant.TOKEN, TextUtils.isEmpty(serverToken) ? "" : serverToken)
                        .addHeader(Constant.ID, TextUtils.isEmpty(subStoreId) ? "" : subStoreId)
                        .addHeader(Constant.TYPE, TextUtils.isEmpty(subStoreId) ? "0" : "1")
                        .addHeader(Constant.APP_CODE, Constant.ANDROID)
                        .addHeader(Constant.APP_VERSION, BuildConfig.VERSION_NAME)
                        .addHeader(Constant.MODEL, Build.MODEL)
                        .addHeader(Constant.OS_VERSION, String.valueOf(Build.VERSION.SDK_INT))
                        .addHeader(Constant.OS_ORIENTATION, String.valueOf(Resources.getSystem().getConfiguration().orientation))
                        .build();
                return chain.proceed(request);
            });

            if (BuildConfig.DEBUG) {
                // development build
                HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
                interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
                okHttpClient.addInterceptor(interceptor);
            }

            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(Integer.class, new IntegerDefaultAdapter())
                    .registerTypeAdapter(int.class, new IntegerDefaultAdapter())
                    .registerTypeAdapter(Long.class, new LongDefaultAdapter())
                    .registerTypeAdapter(long.class, new LongDefaultAdapter())
                    .registerTypeAdapter(Double.class, new DoubleDefaultAdapter())
                    .registerTypeAdapter(double.class, new DoubleDefaultAdapter())
                    .create();

            retrofit = new Retrofit.Builder()
                    .client(okHttpClient.build())
                    .addConverterFactory(ScalarsConverterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create(gson))
                    .baseUrl(ServerConfig.BASE_URL).build();
        }

        return retrofit;
    }

    public static MultipartBody.Part makeMultipartRequestBody(Context context, String photoPath, String partName) {
        if (TextUtils.isEmpty(photoPath)) {
            return null;
        } else {
            try {
                File file = new File(photoPath);
                RequestBody requestFile = RequestBody.create(file, MEDIA_TYPE_IMAGE);
                return MultipartBody.Part.createFormData(partName, context.getResources().getString(R.string.app_name), requestFile);
            } catch (Exception e) {
                return null;
            }
        }
    }

    @NonNull
    public static RequestBody makeTextRequestBody(Object stringData) {
        return RequestBody.create(String.valueOf(stringData), MEDIA_TYPE_TEXT);
    }

    @NonNull
    public static RequestBody makeGSONRequestBody(Object jsonObject) {
        if (gson == null) {
            gson = new Gson();
        }
        return RequestBody.create(gson.toJson(jsonObject), MEDIA_TYPE_TEXT);
    }

    @NonNull
    public static RequestBody makeJSONRequestBody(JSONObject jsonObject) {
        String params = jsonObject.toString();
        return RequestBody.create(params, MEDIA_TYPE_TEXT);
    }

    @NonNull
    public static String JSONResponse(Object jsonObject) {
        if (gson == null) {
            gson = new Gson();
        }
        return gson.toJson(jsonObject);
    }

    public static MultipartBody.Part[] addMultipleImage(ArrayList<String> imageList) {
        MultipartBody.Part[] partsImage = new MultipartBody.Part[imageList.size()];
        for (int i = 0; i < imageList.size(); i++) {
            File file = new File(imageList.get(i));

            RequestBody requestBody = RequestBody.create(file, MediaType.parse("multipart/form-data"));
            partsImage[i] = MultipartBody.Part.createFormData(Constant.IMAGE_URL, file.getName(), requestBody);
        }
        return partsImage;
    }

    public static JSONArray JSONArray(Object jsonObject) {
        if (gson == null) {
            gson = new Gson();
        }
        try {
            return new JSONArray(String.valueOf(gson.toJsonTree(jsonObject).getAsJsonArray()));
        } catch (JSONException e) {
            Utilities.handleException(Tag, e);
        }
        return null;
    }

    public static void setLanguage(String lang) {
        ApiClient.lang = lang;
        retrofit = null;
    }

    public static void setLanguageCode(String langCode) {
        ApiClient.langCode = langCode;
        retrofit = null;
    }

    public static void setStoreId(String storeId) {
        ApiClient.storeId = storeId;
        retrofit = null;
    }

    public static void setServerToken(String serverToken) {
        ApiClient.serverToken = serverToken;
        retrofit = null;
    }

    public static void setSubStoreId(String subStoreId) {
        ApiClient.subStoreId = subStoreId;
        retrofit = null;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putString("storeId", storeId);
            state.putString("lang", lang);
            state.putString("subStoreId", subStoreId);
            state.putString("serverToken", serverToken);
        }
    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            storeId = state.getString("storeId");
            lang = state.getString("lang");
            subStoreId = state.getString("subStoreId");
            serverToken = state.getString("serverToken");
        }
    }

    public Retrofit changeApiBaseUrl(String newApiBaseUrl) {
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient okHttpClient = new OkHttpClient()
                .newBuilder()
                .connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS)
                .readTimeout(READ_TIMEOUT, TimeUnit.SECONDS)
                .writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS)
                .addInterceptor(interceptor)
                .build();

        return new Retrofit.Builder()
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .baseUrl(newApiBaseUrl)
                .build();
    }

    public void changeAllApiBaseUrl(String baseUrl) {
        retrofit = changeApiBaseUrl(baseUrl);
    }
}