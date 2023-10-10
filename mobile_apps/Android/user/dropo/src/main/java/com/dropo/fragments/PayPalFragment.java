package com.dropo.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.Nullable;

import com.dropo.user.R;

public class PayPalFragment extends BasePaymentFragments {

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_pay_pal, container, false);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onClick(View view) {

    }

   /* public void payWithPayPal(int requestCode,double amount) {
        PayPalConfiguration payPalConfiguration = new PayPalConfiguration()
                .environment(Const.PayPal.CONFIG_ENVIRONMENT)
                .clientId(paymentActivity.gatewayItem.getPaymentKeyId())
                // The following are only used in PayPalFuturePaymentActivity.
                .merchantName(paymentActivity.getResources().getString(R.string.app_name))
                .merchantPrivacyPolicyUri(Uri.parse(Const.PayPal.MERCHANT_PRIVACY_POLICY))
                .merchantUserAgreementUri(Uri.parse(Const.PayPal.MERCHANT_AGREEMENT));
        PayPalPayment thingToBuy = new PayPalPayment(new BigDecimal(String.valueOf(amount)),
                "USD",
                paymentActivity.getResources().getString(R.string.text_total_pay_amount),
                PayPalPayment.PAYMENT_INTENT_SALE);
        Intent intent = new Intent(paymentActivity, PaymentActivity.class);
        intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, payPalConfiguration);
        intent.putExtra(PaymentActivity.EXTRA_PAYMENT, thingToBuy);
        startActivityForResult(intent, requestCode);
    }*/

  /*  @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case Const.PayPal.REQUEST_CODE_ORDER_PAYMENT:
                    PaymentConfirmation confirm =
                            data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
                    if (confirm != null) {
                        try {
                            AppLog.Log(Tag, confirm.toJSONObject().toString(4));
                            AppLog.Log(Tag, confirm.getPayment().toJSONObject().toString(4));
                        } catch (JSONException e) {
                            AppLog.handleException(Tag, e);
                        }
                    }
                    break;
                case Const.PayPal.REQUEST_CODE_WALLET_PAYMENT:
                    PaymentConfirmation confirm2 =
                            data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
                    if (confirm2 != null) {
                        try {
                            AppLog.Log(Tag, confirm2.toJSONObject().toString(4));
                            AppLog.Log(Tag, confirm2.getPayment().toJSONObject().toString(4));

                        } catch (JSONException e) {
                            AppLog.handleException(Tag, e);
                        }
                    }
                    break;
                default:
                    // do with default
                    break;
            }
        }

    }*/
}