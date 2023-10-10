package com.dropo.store.parse;

import com.dropo.store.models.responsemodel.AddCartResponse;
import com.dropo.store.models.responsemodel.AddOrDeleteSpecificationResponse;
import com.dropo.store.models.responsemodel.AddOrUpdateItemResponse;
import com.dropo.store.models.responsemodel.AllDocumentsResponse;
import com.dropo.store.models.responsemodel.AppSettingResponse;
import com.dropo.store.models.responsemodel.BankDetailResponse;
import com.dropo.store.models.responsemodel.CancellationReasonsResponse;
import com.dropo.store.models.responsemodel.CardsResponse;
import com.dropo.store.models.responsemodel.CategoriesResponse;
import com.dropo.store.models.responsemodel.CheckAvailableItemResponse;
import com.dropo.store.models.responsemodel.CityResponse;
import com.dropo.store.models.responsemodel.CountriesResponse;
import com.dropo.store.models.responsemodel.DayEarningResponse;
import com.dropo.store.models.responsemodel.DocumentResponse;
import com.dropo.store.models.responsemodel.ForgotPasswordOTPVerificationResponse;
import com.dropo.store.models.responsemodel.HistoryDetailsResponse;
import com.dropo.store.models.responsemodel.HistoryResponse;
import com.dropo.store.models.responsemodel.ImageSettingsResponse;
import com.dropo.store.models.responsemodel.InvoiceResponse;
import com.dropo.store.models.responsemodel.IsSuccessResponse;
import com.dropo.store.models.responsemodel.ItemsResponse;
import com.dropo.store.models.responsemodel.NearestProviderResponse;
import com.dropo.store.models.responsemodel.OTPResponse;
import com.dropo.store.models.responsemodel.OrderDetailResponse;
import com.dropo.store.models.responsemodel.OrderResponse;
import com.dropo.store.models.responsemodel.OrderStatusResponse;
import com.dropo.store.models.responsemodel.PaymentGatewayResponse;
import com.dropo.store.models.responsemodel.PaymentResponse;
import com.dropo.store.models.responsemodel.ProductGroupsResponse;
import com.dropo.store.models.responsemodel.ProductListResponse;
import com.dropo.store.models.responsemodel.ProductResponse;
import com.dropo.store.models.responsemodel.PromoCodeResponse;
import com.dropo.store.models.responsemodel.ReviewResponse;
import com.dropo.store.models.responsemodel.SpecificationGroupFroAddItemResponse;
import com.dropo.store.models.responsemodel.SpecificationGroupResponse;
import com.dropo.store.models.responsemodel.StoreDataResponse;
import com.dropo.store.models.responsemodel.SubStoresResponse;
import com.dropo.store.models.responsemodel.VehiclesResponse;
import com.dropo.store.models.responsemodel.WalletHistoryResponse;
import com.dropo.store.models.responsemodel.WalletResponse;
import com.dropo.store.models.responsemodel.WalletTransactionResponse;
import com.dropo.store.utils.Constant;

import java.util.HashMap;
import java.util.Map;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.Part;
import retrofit2.http.PartMap;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * A class to call different api on 24-01-2017.
 */
public interface ApiInterface {

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_app_keys")
    Call<AppSettingResponse> getAppSettingDetail(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/logout")
    Call<IsSuccessResponse> logout(@Body HashMap<String, Object> map);

    @GET("api/admin/get_country_list")
    Call<CountriesResponse> getCountries();

    @FormUrlEncoded
    @POST("api/admin/get_city_list")
    Call<CityResponse> getCities(@Field(Constant.COUNTRY_ID) String countryId);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_delivery_list_for_city")
    Call<CategoriesResponse> getCategories(@Body HashMap<String, Object> requestBody);

    @GET("http://maps.googleapis.com/maps/api/geocode/json?")
    Call<ResponseBody> getLatLngFromAddress(@Query(Constant.ADDRESS) String address);

    @Multipart
    @POST("api/store/register")
    Call<StoreDataResponse> register(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part profile);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/store_generate_otp")
    Call<OTPResponse> getStoreOtp(@Body HashMap<String, Object> body);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/otp_verification")
    Call<OTPResponse> storeOtpVerification(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/login")
    Call<StoreDataResponse> login(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_store_data")
    Call<StoreDataResponse> getStoreDate(@Body HashMap<String, Object> map);

    @Multipart
    @POST("api/store/get_product_list")
    Call<ProductResponse> getProductList(@PartMap Map<String, RequestBody> map);

    @Multipart
    @POST("api/store/add_product")
    Call<IsSuccessResponse> addProduct(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part productLogo);

    @Multipart
    @POST("api/store/add_product")
    Call<IsSuccessResponse> addProduct(@PartMap Map<String, RequestBody> map);

    @Multipart
    @POST("api/store/update_product")
    Call<IsSuccessResponse> updateProduct(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part productLogo);

    @Multipart
    @POST("api/store/update_product")
    Call<IsSuccessResponse> updateProduct(@PartMap Map<String, RequestBody> map);

    @Multipart
    @POST("api/store/add_product_group_data")
    Call<IsSuccessResponse> addProductGroup(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part productLogo);

    @Multipart
    @POST("api/store/add_product_group_data")
    Call<IsSuccessResponse> addProductGroup(@PartMap Map<String, RequestBody> map);

    @Multipart
    @POST("api/store/update_product_group")
    Call<IsSuccessResponse> updateProductGroup(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part productLogo);

    @Multipart
    @POST("api/store/update_product_group")
    Call<IsSuccessResponse> updateProductGroup(@PartMap Map<String, RequestBody> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/add_specification")
    Call<AddOrDeleteSpecificationResponse> addSpecification(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_detail")
    Call<StoreDataResponse> getDetails(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/store/update")
    Call<StoreDataResponse> updateProfile(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part profile);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update")
    Call<StoreDataResponse> updateSettings(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/delete_specification")
    Call<AddOrDeleteSpecificationResponse> deleteSpecification(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_store_product_item_list")
    Call<ProductResponse> getItemList(@Body Map<String, Object> map);

    @Multipart
    @POST("api/store/upload_item_image")
    Call<AddOrUpdateItemResponse> addItemImage(@PartMap Map<String, RequestBody> map, @Part MultipartBody.Part[] itemImage);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/is_item_in_stock")
    Call<IsSuccessResponse> isItemInStock(@Body Map<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/order_list")
    Call<OrderResponse> getOrderList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/set_order_status")
    Call<OrderStatusResponse> setOrderStatus(@Body Map<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/store_cancel_or_reject_order")
    Call<IsSuccessResponse> CancelOrRejectOrder(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/create_request")
    Call<OrderStatusResponse> assignProvider(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/order_list_for_delivery")
    Call<OrderResponse> getDeliveryList(@Body Map<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/check_request_status")
    Call<OrderStatusResponse> checkRequestStatus(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/order_history")
    Call<HistoryResponse> getHistoryList(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/order_history_detail")
    Call<HistoryDetailsResponse> getHistoryDetails(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_specification_group")
    Call<SpecificationGroupResponse> getSpecificationGroup(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_specification_group")
    Call<SpecificationGroupFroAddItemResponse> getSpecificationGroupFroAddItem(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/add_specification_group")
    Call<IsSuccessResponse> addSpecificationGroup(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/update_sp_name")
    Call<IsSuccessResponse> updateSpecificationGroupName(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update_specification_name")
    Call<IsSuccessResponse> updateSpecificationName(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/delete_specification_group")
    Call<IsSuccessResponse> deleteSpecificationGroup(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/delete_item_image")
    Call<IsSuccessResponse> deleteItemImage(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_document_list")
    Call<AllDocumentsResponse> getAllDocument(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/admin/upload_document")
    Call<DocumentResponse> uploadDocument(@Part MultipartBody.Part file, @PartMap() Map<String, RequestBody> partMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update_item")
    Call<AddOrUpdateItemResponse> updateItem(@Body RequestBody jsonData);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/add_item")
    Call<AddOrUpdateItemResponse> addItem(@Body RequestBody jsonData);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/order_payment_status_set_on_cash_on_delivery")
    Call<IsSuccessResponse> setOrderPaymentPaidBy(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/rating_to_provider")
    Call<IsSuccessResponse> setFeedbackProvider(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/rating_to_user")
    Call<IsSuccessResponse> setFeedbackUser(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/daily_earning")
    Call<DayEarningResponse> getDailyEarning(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/weekly_earning")
    Call<DayEarningResponse> getWeeklyEarning(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/cancel_request")
    Call<OrderStatusResponse> cancelDeliveryRequest(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/check_referral")
    Call<IsSuccessResponse> getCheckReferral(@Body HashMap<String, Object> requestBody);

    @GET("api/geocode/json")
    Call<ResponseBody> getGoogleGeocode(@QueryMap Map<String, String> stringMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update_store_time")
    Call<IsSuccessResponse> updateStoreTime(@Body RequestBody requestBody);

    @Multipart
    @POST("api/admin/add_bank_detail")
    Call<IsSuccessResponse> addBankDetail(@PartMap() Map<String, RequestBody> partMap, @Part MultipartBody.Part file, @Part MultipartBody.Part file2, @Part MultipartBody.Part file3);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/select_bank_detail")
    Call<IsSuccessResponse> selectBankDetail(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/delete_bank_detail")
    Call<BankDetailResponse> deleteBankDetail(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_bank_detail")
    Call<BankDetailResponse> getBankDetail(@Body RequestBody requestBody);

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
    @POST("api/user/add_item_in_cart")
    Call<AddCartResponse> addItemInCart(@Body RequestBody requestBody);

    @GET("api/distancematrix/json?")
    Call<ResponseBody> getGoogleDistanceMatrix(@QueryMap Map<String, String> stringMap);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_order_cart_invoice")
    Call<InvoiceResponse> getDeliveryInvoice(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/create_order")
    Call<IsSuccessResponse> createOrder(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/user_get_store_review_list")
    Call<ReviewResponse> getStoreReview(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/get_image_setting")
    Call<ImageSettingsResponse> getImageSettings();

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/complete_order")
    Call<IsSuccessResponse> completeOrder(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/check_promo_code")
    Call<IsSuccessResponse> checkPromoReuse(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/promo_code_list")
    Call<PromoCodeResponse> getPromoCodes(@Body HashMap<String, Object> requestBody);

    @Multipart
    @POST("api/store/add_promo")
    Call<IsSuccessResponse> addPromoCodes(@PartMap HashMap<String, String> requestBody, @Part MultipartBody.Part image);

    @Multipart
    @POST("api/store/update_promo_code")
    Call<IsSuccessResponse> updatePromoCodes(@PartMap HashMap<String, String> requestBody, @Part MultipartBody.Part image);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update_order")
    Call<IsSuccessResponse> updateOrder(@Body RequestBody requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/pay_order_payment")
    Call<IsSuccessResponse> payOrderPayment(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/get_item_detail")
    Call<ItemsResponse> getItems(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/store_change_delivery_address")
    Call<IsSuccessResponse> changeDeliveryAddressStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/create_order")
    Call<IsSuccessResponse> createOrderWithEmptyCart(@Body HashMap<String, Object> requestBody);

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
    @POST("api/store/get_vehicles_list")
    Call<VehiclesResponse> getVehiclesList(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_group_list_of_group")
    Call<ProductListResponse> getGroupProductList(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_product_group_list")
    Call<ProductGroupsResponse> getProductGroupList(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/delete_product_group")
    Call<ProductGroupsResponse> deleteProductGroup(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_add_card_intent")
    Call<PaymentResponse> getStripSetupIntent(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/get_stripe_payment_intent_wallet")
    Call<PaymentResponse> getStripPaymentIntentWallet(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_order_detail")
    Call<OrderDetailResponse> getOrderDetail(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/find_nearest_provider_list")
    Call<NearestProviderResponse> getNearestProviders(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/sub_store_login")
    Call<StoreDataResponse> subStoreLogin(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/sub_store_list")
    Call<SubStoresResponse> getSubStores(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/update_sub_store")
    Call<IsSuccessResponse> updateSubStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/add_sub_store")
    Call<IsSuccessResponse> addSubStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password")
    Call<IsSuccessResponse> forgotPassword(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/forgot_password_verify")
    Call<ForgotPasswordOTPVerificationResponse> verifyForgotPasswordOTP(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/admin/new_password")
    Call<IsSuccessResponse> resetPassword(@Body HashMap<String, Object> requestBody);

    //TODO check with back-end
    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/store_like_dislike_store_review")
    Call<IsSuccessResponse> setStoreReviewLikeAndDislike(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/send_paystack_required_detail")
    Call<PaymentResponse> sendPayStackRequiredDetails(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/get_cancellation_reasons")
    Call<CancellationReasonsResponse> getCancellationReasons(@Body HashMap<String, Object> map);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/delete_account")
    Call<IsSuccessResponse> deleteAccount(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/store/twilio_voice_call_from_store")
    Call<IsSuccessResponse> twilioVoiceCallFromStore(@Body HashMap<String, Object> requestBody);

    @Headers("Content-Type:application/json;charset=UTF-8")
    @POST("api/user/check_available_item")
    Call<CheckAvailableItemResponse> checkAvailableItem(@Body HashMap<String, Object> requestBody);
}