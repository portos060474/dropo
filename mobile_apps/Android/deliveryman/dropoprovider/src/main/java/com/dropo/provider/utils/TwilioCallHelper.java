package com.dropo.provider.utils;

import android.app.Activity;
import android.os.Handler;
import android.view.View;

import androidx.annotation.NonNull;

import com.dropo.provider.R;
import com.dropo.provider.component.CustomDialogAlert;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.parser.ApiClient;
import com.dropo.provider.parser.ApiInterface;

import java.util.HashMap;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class TwilioCallHelper {

    private static final String TAG = TwilioCallHelper.class.getSimpleName();

    /**
     * Call via Twilio Api
     */
    public static void callViaTwilio(Activity activity, View view, String orderId, String type) {
        Utils.showCustomProgressDialog(activity, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Const.Params.ORDER_ID, orderId);
        map.put(Const.Params.PROVIDER_ID, PreferenceHelper.getInstance(activity).getProviderId());
        map.put(Const.Params.SERVER_TOKEN, PreferenceHelper.getInstance(activity).getSessionToken());
        map.put(Const.Params.CALL_TO_USERTYPE, type);

        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).twilioVoiceCallFromProvider(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utils.hideCustomProgressDialog();
                if (response.body() != null && response.body().isSuccess()) {
                    openWaitForCallAssignDialog(activity);
                }
                view.setEnabled(false);
                new Handler().postDelayed(() -> view.setEnabled(true), 5000);
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utils.hideCustomProgressDialog();
                AppLog.handleThrowable(TAG, t);
            }
        });
    }

    private static void openWaitForCallAssignDialog(Activity activity) {
        if (!activity.isFinishing()) {
            final CustomDialogAlert dialogAlert = new CustomDialogAlert(activity, activity.getString(R.string.text_alert), activity.getString(R.string.text_call_message), activity.getString(R.string.text_ok)) {
                @Override
                public void onClickLeftButton() {
                    dismiss();
                }

                @Override
                public void onClickRightButton() {
                    dismiss();
                }
            };
            dialogAlert.show();
        }
    }
}
