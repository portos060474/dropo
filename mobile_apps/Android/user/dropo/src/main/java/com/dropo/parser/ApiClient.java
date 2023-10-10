package com.dropo.parser;

import static com.dropo.utils.Const.Params.IMAGE_URL;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.dropo.user.BuildConfig;
import com.dropo.user.R;
import com.dropo.utils.AppLog;
import com.dropo.utils.Const;
import com.dropo.utils.ServerConfig;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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

    public static final String TAG = "ApiClient";
    private static final int CONNECTION_TIMEOUT = 30; //seconds
    private static final int READ_TIMEOUT = 20; //seconds
    private static final int WRITE_TIMEOUT = 20; //seconds
    private static final MediaType MEDIA_TYPE_TEXT = MediaType.parse("multipart/form-data");
    public static MediaType MEDIA_TYPE_IMAGE = MediaType.parse("placeholder/*");
    private static Retrofit retrofit = null;
    private static Gson gson;
    private static String lang;
    private static String langCode;
    private static String userId = "", token = "";

    public static Retrofit getClient() {
        if (retrofit == null) {
            OkHttpClient.Builder okHttpClient;
            okHttpClient = new OkHttpClient().newBuilder().connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS).readTimeout(READ_TIMEOUT, TimeUnit.SECONDS).writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS);
            okHttpClient.addInterceptor(chain -> {
                Request request = chain.request().newBuilder()
                        .addHeader(Const.Params.LANG, lang)
                        .addHeader(Const.Params.LANG_CODE, langCode)
                        .addHeader(Const.Params.USERID, TextUtils.isEmpty(userId) ? "" : userId)
                        .addHeader(Const.Params.TOKEN, TextUtils.isEmpty(token) ? "" : token)
                        .addHeader(Const.Params.TYPE, String.valueOf(Const.Type.USER))
                        .addHeader(Const.Params.APP_CODE, Const.ANDROID)
                        .addHeader(Const.Params.APP_VERSION, BuildConfig.VERSION_NAME)
                        .addHeader(Const.Params.MODEL, Build.MODEL)
                        .addHeader(Const.Params.OS_VERSION, String.valueOf(Build.VERSION.SDK_INT))
                        .addHeader(Const.Params.OS_ORIENTATION, String.valueOf(Resources.getSystem().getConfiguration().orientation))
                        .build();
                return chain.proceed(request);
            });

            if (BuildConfig.DEBUG) {
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

    public static MultipartBody.Part makeMultipartRequestBody(Context context, String photoPath, String partName) {
        try {
            File file = new File(photoPath);
            RequestBody requestFile = RequestBody.create(file, MEDIA_TYPE_IMAGE);
            return MultipartBody.Part.createFormData(partName, context.getResources().getString(R.string.app_name), requestFile);
        } catch (NullPointerException e) {
            AppLog.handleException(TAG, e);
            return null;
        }
    }

    @NonNull
    public static RequestBody makeGSONRequestBody(Object jsonObject) {
        if (gson == null) {
            gson = new Gson();
        }
        return RequestBody.create(gson.toJson(jsonObject), MEDIA_TYPE_TEXT);
    }

    @NonNull
    public static RequestBody makeTextRequestBody(Object stringData) {
        return RequestBody.create(String.valueOf(stringData), MEDIA_TYPE_TEXT);
    }

    public static MultipartBody.Part[] addMultipleImage(ArrayList<String> imageList) {
        MultipartBody.Part[] partsImage = new MultipartBody.Part[imageList.size()];
        for (int i = 0; i < imageList.size(); i++) {
            File file = new File(imageList.get(i));

            RequestBody requestBody = RequestBody.create(file, MediaType.parse("multipart/form-data"));
            partsImage[i] = MultipartBody.Part.createFormData(IMAGE_URL, file.getName(), requestBody);
        }
        return partsImage;
    }

    public static void setLanguage(int lang) {
        ApiClient.lang = String.valueOf(lang);
        retrofit = null;
    }

    public static void setLanguageCode(String langCode) {
        ApiClient.langCode = langCode;
        retrofit = null;
    }

    public static void setLoginDetail(@NonNull String userId, @NonNull String token) {
        ApiClient.userId = userId;
        ApiClient.token = token;
        retrofit = null;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putString("lang", lang);
            state.putString("userid", userId);
            state.putString("token", token);
            state.putString("lang_code", langCode);
        }
    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            lang = state.getString("lang");
            userId = state.getString("userid");
            token = state.getString("token");
            langCode = state.getString("lang_code");
        }
    }

    public Retrofit changeApiBaseUrl(String newApiBaseUrl) {
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();

        if (BuildConfig.DEBUG) {
            interceptor.level(HttpLoggingInterceptor.Level.BODY);
        } else {
            interceptor.level(HttpLoggingInterceptor.Level.NONE);
        }

        OkHttpClient okHttpClient = new OkHttpClient().newBuilder().connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS).readTimeout(READ_TIMEOUT, TimeUnit.SECONDS).writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS).addInterceptor(interceptor).build();
        return new Retrofit.Builder().client(okHttpClient).addConverterFactory(GsonConverterFactory.create()).baseUrl(newApiBaseUrl).build();
    }

    public Retrofit changeHeaderLang(int language) {
        OkHttpClient.Builder okHttpClient;
        okHttpClient = new OkHttpClient().newBuilder().connectTimeout(CONNECTION_TIMEOUT, TimeUnit.SECONDS).readTimeout(READ_TIMEOUT, TimeUnit.SECONDS).writeTimeout(WRITE_TIMEOUT, TimeUnit.SECONDS);
        okHttpClient.addInterceptor(chain -> {
            Request request = chain.request().newBuilder().addHeader(Const.Params.LANG, String.valueOf(language)).build();
            return chain.proceed(request);
        });

        if (BuildConfig.DEBUG) {
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            okHttpClient.addInterceptor(interceptor);
        }

        return new Retrofit.Builder().client(okHttpClient.build()).addConverterFactory(ScalarsConverterFactory.create()).addConverterFactory(GsonConverterFactory.create()).baseUrl(ServerConfig.BASE_URL).build();
    }

    public void changeAllApiBaseUrl(String baseUrl) {
        retrofit = changeApiBaseUrl(baseUrl);
    }
}