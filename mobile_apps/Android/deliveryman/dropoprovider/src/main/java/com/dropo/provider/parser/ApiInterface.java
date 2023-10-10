package com.dropo.provider.parser;


import com.dropo.provider.models.responsemodels.AllDocumentsResponse;
import com.dropo.provider.models.responsemodels.AppSettingDetailResponse;
import com.dropo.provider.models.responsemodels.AvailableOrdersResponse;
import com.dropo.provider.models.responsemodels.BankDetailResponse;
import com.dropo.provider.models.responsemodels.CancellationReasonsResponse;
import com.dropo.provider.models.responsemodels.CardsResponse;
import com.dropo.provider.models.responsemodels.CityResponse;
import com.dropo.provider.models.responsemodels.CompleteOrderResponse;
import com.dropo.provider.models.responsemodels.CountriesResponse;
import com.dropo.provider.models.responsemodels.DayEarningResponse;
import com.dropo.provider.models.responsemodels.DocumentResponse;
import com.dropo.provider.models.responsemodels.ForgotPasswordOTPVerificationResponse;
import com.dropo.provider.models.responsemodels.InvoiceResponse;
import com.dropo.provider.models.responsemodels.IsSuccessResponse;
import com.dropo.provider.models.responsemodels.OrderHistoryDetailResponse;
import com.dropo.provider.models.responsemodels.OrderHistoryResponse;
import com.dropo.provider.models.responsemodels.OrderStatusResponse;
import com.dropo.provider.models.responsemodels.OtpResponse;
import com.dropo.provider.models.responsemodels.PaymentGatewayResponse;
import com.dropo.provider.models.responsemodels.PaymentResponse;
import com.dropo.provider.models.responsemodels.ProviderDataResponse;
import com.dropo.provider.models.responsemodels.VehicleAddResponse;
import com.dropo.provider.models.responsemodels.VehicleDetailResponse;
import com.dropo.provider.models.responsemodels.WalletHistoryResponse;
import com.dropo.provider.models.responsemodels.WalletResponse;
import com.dropo.provider.models.responsemodels.WalletTransactionResponse;

import java.util.HashMap;
import java.util.Map;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.PartMap;
import retrofit2.http.Query;

public interface ApiInterface {


    @Multipart
    @POST("api/provider/register")
    Call<ProviderDataResponse> register(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/login")
    Call<ProviderDataResponse> login(@Body HashMap<String, Object> requestBody);

    @GET("api/admin/get_country_list")
    Call<CountriesResponse> getCountries();

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_city_list")
    Call<CityResponse> getCities(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/provider/update")
    Call<ProviderDataResponse> updateProfile(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_app_keys")
    Call<AppSettingDetailResponse> getAppSettingDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password")
    Call<IsSuccessResponse> forgotPassword(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/update_device_token")
    Call<IsSuccessResponse> updateDeviceToken(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/logout")
    Call<IsSuccessResponse> logOut(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/otp_verification")
    Call<OtpResponse> getOtpVerify(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_referral")
    Call<IsSuccessResponse> getCheckReferral(@Body HashMap<String, Object> requestBody);

    @GET("api/directions/json")
    Call<ResponseBody> getGoogleDirection(@Query("origin") String originLatLng, @Query("destination") String destinationLatLng, @Query("key") String googleKey);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/update_location")
    Call<IsSuccessResponse> updateProviderLocation(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/change_status")
    Call<IsSuccessResponse> changeProviderOnlineStatus(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_requests")
    Call<AvailableOrdersResponse> getNewOrder(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_active_requests")
    Call<AvailableOrdersResponse> getActiveOrders(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/provider_cancel_or_reject_request")
    Call<IsSuccessResponse> rejectOrCancelDelivery(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/provider/change_request_status")
    Call<OrderStatusResponse> setRequestStatus(@Part MultipartBody.Part file, @PartMap Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_request_status")
    Call<OrderStatusResponse> getRequestStatus(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/complete_request")
    Call<CompleteOrderResponse> completeOrder(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_document_list")
    Call<AllDocumentsResponse> getAllDocument(@Body HashMap<String, Object> requestBody);


    @Multipart
    @POST("api/admin/upload_document")
    Call<DocumentResponse> uploadDocument(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/request_history_detail")
    Call<OrderHistoryDetailResponse> getOrderHistoryDetail(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/request_history")
    Call<OrderHistoryResponse> getOrdersHistory(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_bank_detail")
    Call<BankDetailResponse> getBankDetail(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_detail")
    Call<ProviderDataResponse> getProviderDetail(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/otp_verification")
    Call<IsSuccessResponse> setOtpVerification(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/daily_earning")
    Call<DayEarningResponse> getDailyEarning(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/weekly_earning")
    Call<DayEarningResponse> getWeeklyEarning(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/show_request_invoice")
    Call<IsSuccessResponse> setShowInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_invoice")
    Call<InvoiceResponse> getInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/rating_to_store")
    Call<IsSuccessResponse> setFeedbackStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/rating_to_user")
    Call<IsSuccessResponse> setFeedbackUser(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/admin/add_bank_detail")
    Call<IsSuccessResponse> addBankDetail(@PartMap() Map<String, RequestBody> partMap, @Part MultipartBody.Part file, @Part MultipartBody.Part file2, @Part MultipartBody.Part file3);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/delete_bank_detail")
    Call<BankDetailResponse> deleteBankDetail(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/select_bank_detail")
    Call<IsSuccessResponse> selectBankDetail(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/create_wallet_request")
    Call<IsSuccessResponse> createWithdrawalRequest(@Body RequestBody requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("admin/cancel_wallet_request")
    Call<IsSuccessResponse> cancelWithdrawalRequest(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_wallet_history")
    Call<WalletHistoryResponse> getWalletHistory(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_wallet_request_list")
    Call<WalletTransactionResponse> getWalletTransaction(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_payment_gateway")
    Call<PaymentGatewayResponse> getPaymentGateway(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_card")
    Call<CardsResponse> getAddCreditCard(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/select_card")
    Call<CardsResponse> selectCreditCard(@Body HashMap<String, Object> requestBody);


    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/delete_card")
    Call<IsSuccessResponse> deleteCreditCard(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_card_list")
    Call<CardsResponse> getAllCreditCards(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_wallet_amount")
    Call<WalletResponse> getAddWalletAmount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/add_vehicle")
    Call<VehicleAddResponse> addVehicle(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/update_vehicle_detail")
    Call<VehicleAddResponse> updateVehicle(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_vehicle_list")
    Call<VehicleDetailResponse> getVehicleDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/select_vehicle")
    Call<IsSuccessResponse> selectVehicle(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_request_count")
    Call<IsSuccessResponse> getRequestCount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_add_card_intent")
    Call<PaymentResponse> getStripSetupIntent(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_payment_intent_wallet")
    Call<PaymentResponse> getStripPaymentIntentWallet(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password_verify")
    Call<ForgotPasswordOTPVerificationResponse> verifyForgotPasswordOTP(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/new_password")
    Call<IsSuccessResponse> resetPassword(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/send_paystack_required_detail")
    Call<PaymentResponse> sendPayStackRequiredDetails(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/get_cancellation_reasons")
    Call<CancellationReasonsResponse> getCancellationReasons(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/delete_account")
    Call<IsSuccessResponse> deleteAccount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/provider/twilio_voice_call_from_provider")
    Call<IsSuccessResponse> twilioVoiceCallFromProvider(@Body HashMap<String, Object> requestBody);
}