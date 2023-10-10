package com.dropo.provider.parser;

import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dropo.provider.BuildConfig;
import com.dropo.provider.utils.AppLog;
import com.dropo.provider.utils.Const;
import com.dropo.provider.utils.ServerConfig;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.File;
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
    private static String providerId = "", token = "";

    public static Retrofit getClient() {
        if (retrofit == null) {
            OkHttpClient.Builder okHttpClient;
            okHttpClient = new OkHttpClient().newBuilder().connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS).readTimeout(READ_TIMEOUT, TimeUnit.SECONDS).writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS);
            okHttpClient.addInterceptor(chain -> {
                Request request = chain.request().newBuilder()
                        .addHeader(Const.Params.LANG, TextUtils.isEmpty(lang) ? "0" : lang)
                        .addHeader(Const.Params.LANG_CODE, langCode)
                        .addHeader(Const.Params.PROVIDERID, TextUtils.isEmpty(providerId) ? "" : providerId)
                        .addHeader(Const.Params.TOKEN, TextUtils.isEmpty(token) ? "" : token)
                        .addHeader(Const.Params.APP_CODE, Const.ANDROID)
                        .addHeader(Const.Params.APP_VERSION, BuildConfig.VERSION_NAME)
                        .addHeader(Const.Params.MODEL, Build.MODEL)
                        .addHeader(Const.Params.OS_VERSION, String.valueOf(Build.VERSION.SDK_INT))
                        .addHeader(Const.Params.OS_ORIENTATION, String.valueOf(Resources.getSystem().getConfiguration().orientation))
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
            retrofit = new Retrofit.Builder().client(okHttpClient.build()).addConverterFactory(ScalarsConverterFactory.create()).addConverterFactory(GsonConverterFactory.create(gson)).baseUrl(ServerConfig.BASE_URL).build();


        }
        return retrofit;
    }

    public static MultipartBody.Part makeMultipartRequestBody(String photoPath, String partName) {
        try {
            File file = new File(photoPath);
            if (file.exists()) {
                RequestBody requestFile = RequestBody.create(file, MEDIA_TYPE_IMAGE);
                return MultipartBody.Part.createFormData(partName, "partfile", requestFile);
            } else {
                return null;
            }
        } catch (NullPointerException e) {
            AppLog.handleException(Tag, e);
            return null;
        }
    }

    @NonNull
    public static RequestBody makeTextRequestBody(Object stringData) {
        return RequestBody.create(MEDIA_TYPE_TEXT, String.valueOf(stringData));
    }

    @NonNull
    public static RequestBody makeGSONRequestBody(Object jsonObject) {
        if (gson == null) {
            gson = new Gson();
        }
        return RequestBody.create(MEDIA_TYPE_TEXT, gson.toJson(jsonObject));
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putString("lang", lang);
            state.putString("lang_code", langCode);
            state.putString("providerId", providerId);
            state.putString("token", token);
        }
    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            lang = state.getString("lang");
            langCode = state.getString("lang_code");
            providerId = state.getString("providerId");
            token = state.getString("token");
        }
    }

    public static void setLanguage(int lang) {
        ApiClient.lang = String.valueOf(lang);
        retrofit = null;
    }

    public static void setLanguageCode(String langCode) {
        ApiClient.langCode = langCode;
        retrofit = null;
    }

    public static void setLoginDetail(@NonNull String providerId, @NonNull String token) {
        ApiClient.providerId = providerId;
        ApiClient.token = token;
        retrofit = null;
    }

    public Retrofit changeApiBaseUrl(String newApiBaseUrl) {
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        OkHttpClient okHttpClient = new OkHttpClient().newBuilder().connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS).readTimeout(READ_TIMEOUT, TimeUnit.SECONDS).writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS).addInterceptor(interceptor).build();

        return new Retrofit.Builder().client(okHttpClient).addConverterFactory(GsonConverterFactory.create()).baseUrl(newApiBaseUrl).build();
    }

    public void changeAllApiBaseUrl(String baseUrl) {
        retrofit = changeApiBaseUrl(baseUrl);
    }
}