package com.dropo.parser;

import com.dropo.models.datamodels.FavoriteAddressResponse;
import com.dropo.models.responsemodels.ActiveOrderResponse;
import com.dropo.models.responsemodels.AddCartResponse;
import com.dropo.models.responsemodels.AllDocumentsResponse;
import com.dropo.models.responsemodels.AppSettingDetailResponse;
import com.dropo.models.responsemodels.CancellationChargeResponse;
import com.dropo.models.responsemodels.CancellationReasonsResponse;
import com.dropo.models.responsemodels.CardsResponse;
import com.dropo.models.responsemodels.CartResponse;
import com.dropo.models.responsemodels.CheckAvailableItemResponse;
import com.dropo.models.responsemodels.DeliveryOffersResponse;
import com.dropo.models.responsemodels.DeliveryStoreResponse;
import com.dropo.models.responsemodels.DocumentResponse;
import com.dropo.models.responsemodels.FavouriteStoreResponse;
import com.dropo.models.responsemodels.ForgotPasswordOTPVerificationResponse;
import com.dropo.models.responsemodels.InvoiceResponse;
import com.dropo.models.responsemodels.IsSuccessResponse;
import com.dropo.models.responsemodels.OrderHistoryDetailResponse;
import com.dropo.models.responsemodels.OrderHistoryResponse;
import com.dropo.models.responsemodels.OrderResponse;
import com.dropo.models.responsemodels.OrdersResponse;
import com.dropo.models.responsemodels.OtpResponse;
import com.dropo.models.responsemodels.PaymentGatewayResponse;
import com.dropo.models.responsemodels.PaymentResponse;
import com.dropo.models.responsemodels.ProductGroupsResponse;
import com.dropo.models.responsemodels.ProviderLocationResponse;
import com.dropo.models.responsemodels.ReviewResponse;
import com.dropo.models.responsemodels.SetFavouriteResponse;
import com.dropo.models.responsemodels.SpecificationsResponse;
import com.dropo.models.responsemodels.StoreOffersResponse;
import com.dropo.models.responsemodels.StoreProductResponse;
import com.dropo.models.responsemodels.StoreResponse;
import com.dropo.models.responsemodels.TableBookingSettingsResponse;
import com.dropo.models.responsemodels.TableDetailResponse;
import com.dropo.models.responsemodels.UserDataResponse;
import com.dropo.models.responsemodels.VehiclesResponse;
import com.dropo.models.responsemodels.WalletHistoryResponse;

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
import retrofit2.http.QueryMap;

public interface ApiInterface {

    @Multipart
    @POST("api/user/register")
    Call<UserDataResponse> register(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/login")
    Call<UserDataResponse> login(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/user/update")
    Call<UserDataResponse> updateProfile(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_app_keys")
    Call<AppSettingDetailResponse> getAppSettingDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password")
    Call<IsSuccessResponse> forgotPassword(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/update_device_token")
    Call<IsSuccessResponse> updateDeviceToken(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/logout")
    Call<IsSuccessResponse> logOut(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_delivery_store_list")
    Call<StoreResponse> getSelectedStoreList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_product_group_list")
    Call<ProductGroupsResponse> getProductGroupList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_get_store_product_item_list")
    Call<StoreProductResponse> getStoreProductList(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_get_specification_list")
    Call<SpecificationsResponse> getItemSpecificationList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_delivery_list_for_nearest_city")
    Call<DeliveryStoreResponse> getDeliveryStoreList(@Body HashMap<String, Object> requestBody);

    @GET("api/geocode/json")
    Call<ResponseBody> getGoogleGeocode(@QueryMap Map<String, String> stringMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_order_cart_invoice")
    Call<InvoiceResponse> getDeliveryInvoice(@Body HashMap<String, Object> requestBody);

    @GET("api/distancematrix/json")
    Call<ResponseBody> getGoogleDistanceMatrix(@QueryMap Map<String, String> stringMap);

    @GET("api/directions/json")
    Call<ResponseBody> getGoogleDirection(@QueryMap Map<String, String> stringMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/otp_verification")
    Call<OtpResponse> getOtpVerify(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/user/create_order")
    Call<IsSuccessResponse> createOrder(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part[] itemImage);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_payment_gateway")
    Call<PaymentGatewayResponse> getPaymentGateway(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_wallet_amount")
    Call<PaymentResponse> getAddWalletAmount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_card_list")
    Call<CardsResponse> getAllCreditCards(@Body HashMap<String, Object> requestBody);

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
    @POST("api/user/change_user_wallet_status")
    Call<IsSuccessResponse> toggleWalletUse(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/pay_order_payment")
    Call<PaymentResponse> payOrderPayment(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_item_in_cart")
    Call<AddCartResponse> addItemInCart(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_cart")
    Call<CartResponse> getCart(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/clear_cart")
    Call<IsSuccessResponse> clearCart(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_orders")
    Call<OrdersResponse> getOrders(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_order_status")
    Call<ActiveOrderResponse> getActiveOrderStatus(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_cancel_order")
    Call<IsSuccessResponse> cancelOrder(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_document_list")
    Call<AllDocumentsResponse> getAllDocument(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/admin/upload_document")
    Call<DocumentResponse> uploadDocument(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/order_history_detail")
    Call<OrderHistoryDetailResponse> getOrderHistoryDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/order_history")
    Call<OrderHistoryResponse> getOrdersHistory(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_referral")
    Call<IsSuccessResponse> getCheckReferral(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_provider_location")
    Call<ProviderLocationResponse> getProviderLocation(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_detail")
    Call<UserDataResponse> getUserDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/otp_verification")
    Call<IsSuccessResponse> setOtpVerification(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/apply_promo_code")
    Call<InvoiceResponse> applyPromoCode(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/show_invoice")
    Call<IsSuccessResponse> setShowInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_invoice")
    Call<InvoiceResponse> getInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/rating_to_store")
    Call<IsSuccessResponse> setFeedbackStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/rating_to_provider")
    Call<IsSuccessResponse> setFeedbackProvider(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/change_delivery_address")
    Call<IsSuccessResponse> changeDeliveryAddress(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_wallet_history")
    Call<WalletHistoryResponse> getWalletHistory(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_favourite_store")
    Call<SetFavouriteResponse> setFavouriteStore(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/remove_favourite_store")
    Call<SetFavouriteResponse> removeAsFavouriteStore(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_favourite_store_list")
    Call<FavouriteStoreResponse> getFavouriteStores(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_get_store_review_list")
    Call<ReviewResponse> getStoreReview(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_like_dislike_store_review")
    Call<IsSuccessResponse> setUserReviewLikeAndDislike(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_order_detail")
    Call<OrderResponse> getOrderDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/check_delivery_available")
    Call<IsSuccessResponse> checkCourierDeliveryAvailable(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_vehicles_list")
    Call<VehiclesResponse> getVehiclesList(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_courier_order_invoice")
    Call<InvoiceResponse> getCourierOrderInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_add_card_intent")
    Call<PaymentResponse> getStripSetupIntent(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_payment_intent")
    Call<PaymentResponse> getStripPaymentIntent(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_payment_intent_wallet")
    Call<PaymentResponse> getStripPaymentIntentWallet(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/approve_edit_order")
    Call<IsSuccessResponse> approveEditOrder(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_update_order")
    Call<IsSuccessResponse> updateOrder(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password_verify")
    Call<ForgotPasswordOTPVerificationResponse> verifyForgotPasswordOTP(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/new_password")
    Call<IsSuccessResponse> resetPassword(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_store_promo")
    Call<StoreOffersResponse> getStoreOffers(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("admin/get_promo_code_list")
    Call<DeliveryOffersResponse> getDeliveryOffers(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("admin/get_promo_detail")
    Call<DeliveryOffersResponse> getPromoDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/send_paystack_required_detail")
    Call<PaymentResponse> sendPayStackRequiredDetails(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/fetch_table_booking_basic_setting")
    Call<TableBookingSettingsResponse> tableBookingSettings(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("admin/get_cancellation_charges")
    Call<CancellationChargeResponse> getCancellationCharges(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_favoutire_addresses")
    Call<FavoriteAddressResponse> getFavAddressList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/delete_favourite_address")
    Call<IsSuccessResponse> deleteFavAddress(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/add_favourite_address")
    Call<IsSuccessResponse> saveFavAddress(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/update_favourite_address")
    Call<IsSuccessResponse> updateFavAddress(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/fetchTableDetails")
    Call<TableDetailResponse> getTableDetails(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/register_user_without_credentials")
    Call<UserDataResponse> registerUserWithoutCredentials(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_cancellation_reasons")
    Call<CancellationReasonsResponse> getCancellationReasons(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/delete_account")
    Call<IsSuccessResponse> deleteAccount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/twilio_voice_call_from_user")
    Call<IsSuccessResponse> twilioVoiceCallFromUser(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/check_available_item")
    Call<CheckAvailableItemResponse> checkAvailableItem(@Body HashMap<String, Object> requestBody);
}