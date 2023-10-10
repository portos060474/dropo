package com.dropo.store.utils;

import android.app.Activity;
import android.os.Handler;
import android.view.View;

import androidx.annotation.NonNull;

import com.dropo.store.R;
import com.dropo.store.component.CustomAlterDialog;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.parse.ApiClient;
import com.dropo.store.parse.ApiInterface;

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
        Utilities.showCustomProgressDialog(activity, false);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constant.ORDER_ID, orderId);
        map.put(Constant.STORE_ID, PreferenceHelper.getPreferenceHelper(activity).getStoreId());
        map.put(Constant.SERVER_TOKEN, PreferenceHelper.getPreferenceHelper(activity).getServerToken());
        map.put(Constant.CALL_TO_USERTYPE, type);

        Call<IsSuccessResponse> call = ApiClient.getClient().create(ApiInterface.class).twilioVoiceCallFromStore(map);
        call.enqueue(new Callback<IsSuccessResponse>() {
            @Override
            public void onResponse(@NonNull Call<IsSuccessResponse> call, @NonNull Response<IsSuccessResponse> response) {
                Utilities.hideCustomProgressDialog();
                if (response.body() != null && response.body().isSuccess()) {
                    openWaitForCallAssignDialog(activity);
                }
                view.setEnabled(false);
                new Handler().postDelayed(() -> view.setEnabled(true), 5000);
            }

            @Override
            public void onFailure(@NonNull Call<IsSuccessResponse> call, @NonNull Throwable t) {
                Utilities.hideCustomProgressDialog();
                Utilities.handleThrowable(TAG, t);
            }
        });
    }

    private static void openWaitForCallAssignDialog(Activity activity) {
        if (!activity.isFinishing()) {
            final CustomAlterDialog dialogAlert = new CustomAlterDialog(activity, activity.getString(R.string.text_alert), activity.getString(R.string.text_call_message), false, activity.getString(R.string.text_ok)) {
                @Override
                public void btnOnClick(int btnId) {
                    dismiss();
                }
            };
            dialogAlert.show();
        }
    }
}
