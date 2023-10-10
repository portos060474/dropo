//
//  AlamofireHelper.swift
//  Store
//
//  Created by Elluminati on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let preferenceHelper = PreferenceHelper.preferenceHelper
let vehicleType = 2
let passwordMinLength:Int = 6
let passwordMaxLength:Int = 20
let emailMinimumLength = 12
let emailMaximumLength = 64
let firebaseAuth = Auth.auth()
//let  arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),(language: "عربى", code: "ar"),(language: "Española", code: "es"),(language: "Française", code: "fr"),(language: "हिन्दी", code: "hi")]
let arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),(language: "عربى", code: "ar"),(language: "Española", code: "es"),(language: "Française", code: "fr")]

//var isSubStoreLogin : Bool = false

let RESEND_TIME = 60
var defaultLanguage:String = "en"
var selectedLanguage:String =  LocalizeLanguage.currentLanguage()

struct ConstantsLang {
    static var adminLanguages:[AdminLanguage] = []
    static var storeLanguages:[StoreLanguage] = []
    
    static var AdminLanguageIndexSelected: Int = 0
    static var AdminLanguageCodeSelected: String = "en"
    static var StoreLanguageIndexSelected: Int = 0
    static var StoreLanguageCodeSelected: String = "en"
}

struct ScreenVisibilityPermission {
    static var CreateOrder: Bool = true
    static var Order: Bool = true
    static var Deliveries: Bool = true
    static var History: Bool = true
    static var Group: Bool = true
    static var Product: Bool = true
    static var Promocode: Bool = true
    static var Setting: Bool = true
    static var Earning: Bool = false
    static var WeeklyEarning: Bool = true
}

enum AppMode: Int {
    case live = 0
    case staging = 1
    case developer = 2
    
    ///When app submission time default Mode must be AppMode.live
    static let defaultMode = AppMode.live
        
    static var currentMode: AppMode {
        get {
            if UserDefaults.standard.value(forKey: PreferenceHelper.KEY_CURRENT_APP_MODE) == nil {
                print("mode not found")
                return defaultMode
            } else {
                return AppMode(rawValue: preferenceHelper.getCurrentAppMode()) ?? defaultMode
            }
        } set {
            if AppMode.currentMode != newValue {
                print("App switch into new mode")
            }
            print("current mode \(newValue.rawValue)")
            preferenceHelper.setCurrentAppMode(newValue.rawValue)
        }
    }
}

let isConsolePrint = true

public func printE(_ items: Any..., separator: String = "", terminator: String = "") {
    if isConsolePrint {
        debugPrint(items.description)
        //debugPrint(items, separator, terminator)
        //print(items, separator, terminator)
    }
}

struct PromoCodeType {
    static let PERCENTAGE = 1
    static let ABSOLUTE = 2
}

struct WebService {

    static var BASE_URL : String {
        switch AppMode.currentMode {
        case .live:
            return "https://api.dropo.ro/v4/"
        case .developer:
         
            return "https://api.dropo.ro/v4/"
        case .staging:
            return "https://api.dropo.ro/v4/"
        }
    }
    static var BASE_URL_ASSETS : String {
        switch AppMode.currentMode {
        case .live:
            return "https://api.dropo.ro/"
        case .developer:
            return "https://api.dropo.ro/"
        case .staging:
            return "https://api.dropo.ro/"
        }
    }
    static var USER_PANEL_URL : String {
        if !preferenceHelper.getUserPanelUrl().isEmpty() {
            return preferenceHelper.getUserPanelUrl()
        } else {
            switch AppMode.currentMode {
            case .live:
                return "https://api.dropo.ro/"
            case .developer:
                return "https://api.dropo.ro/"
            case .staging:
                return "https://api.dropo.ro/"
            }
        }
    }



    static let UPDATE_DEVICE_TOKEN = "api/store/update_device_token"
    static let  WS_GET_SETTING_DETAIL = "api/admin/check_app_keys"
    static let  WS_GET_COUNTRY_LIST = "api/admin/get_country_list"
    static let  WS_GET_CITY_LIST = "api/admin/get_city_list"
    //    static let  WS_OTP_VERIFICATION = "api/admin/otp_verification"
    static let  WS_GENERATE_OTP = "api/store/store_generate_otp"
    //    static let  WS_OTP_VERIFY = "api/store/otp_verification"
    //    static let  WS_UPDATE_OTP_VERFICATION =  "api/store/otp_verification"
    
    static let WS_GET_IMAGE_SETTING = "api/admin/get_image_setting"
    static let  WS_GET_STORE_REVIEW_LIST = "api/user/user_get_store_review_list";
    /*Login And Register and store related Web Apis*/
    static let  WS_STORE_LOGIN = "api/store/login"
    static let  WS_STORE_REGISTER = "api/store/register"
    static let  WS_FORGET_PASSWORD = "api/admin/forgot_password";
    static let  WS_FORGET_PASSWORD_VERIFY = "api/admin/forgot_password_verify"
    static let  WS_NEW_PASSWORD = "api/admin/new_password"
    static let  WS_GET_NEAREST_DELIVERY_LIST = "api/admin/get_delivery_list_for_city"
    static let  WS_CHECK_REFERRAL = "api/admin/check_referral"
    static let  WS_STORE_LOGOUT = "api/store/logout"
    static let  WS_GET_STORE_INFO = "api/store/get_detail"
    static let  WS_GET_STORE_DATA = "api/store/get_store_data"
    static let  WS_UPDATE_STORE_TIME = "api/store/update_store_time"
    static let  WS_UPDATE_STORE = "api/store/update"
    static let WS_GET_CANCEL_REASON_LIST =  "api/store/get_cancellation_reasons"
    /* Documents */
    static let  WS_GET_DOCUMENT_LIST  =  "api/admin/get_document_list"
    static let  WS_UPLOAD_DOCUMENT  =  "api/admin/upload_document"
    /* Product */
    static let  WS_ADD_PRODUCT = "api/store/add_product";
    static let  WS_UPDATE_PRODUCT = "api/store/update_product";
    static let  WS_GET_PRODUCT_LIST = "api/store/get_product_list"    
    static let  WS_ADD_PRODUCT_SPECIFICATION = "api/store/add_specification";
    static let  WS_DELETE_PRODUCT_SPECIFICATION = "api/store/delete_specification"
    static let  WS_ADD_PRODUCT_SPECIFICATION_GROUP = "api/store/add_specification_group";
    static let  WS_GET_PRODUCT_SPECIFICATION_GROUP = "api/store/get_specification_group"
    static let  WS_DELETE_PRODUCT_SPECIFICATION_GROUP = "api/store/delete_specification_group"
    static let  WS_GET_PRODUCT_GROUP_LIST = "api/store/get_product_group_list"
    static let  WS_GET_GROUP_LIST_OF_GROUP = "api/store/get_group_list_of_group"
    static let  WS_UPDATE_PRODUCT_GROUP = "api/store/update_product_group"
    static let  WS_ADD_PRODUCT_GROUP_DATA = "api/store/add_product_group_data"
    static let  WS_DELETE_PRODUCT_GROUP = "api/store/delete_product_group"
    
    /*  Items  */
    static let  WS_ADD_ITEM = "api/store/add_item";
    static let  WS_UPDATE_ITEM = "api/store/update_item";
    static let  WS_GET_ITEM_LIST = "api/store/get_store_product_item_list"
    static let  WS_ADD_ITEM_SPECIFICATION = "api/store/add_specification";
    static let  WS_DELETE_ITEM_SPECIFICATION = "api/store/delete_specification"
    static let  WS_UPLOAD_ITEM_IMAGE = "api/store/upload_item_image"
    static let  WS_DELETE_ITEM_IMAGE = "api/store/delete_item_image"
    static let  WS_GET_SPECIFICATION_LIST = "api/store/get_specification_list"
    static let  WS_IS_ITEM_IN_STOCK = "api/store/is_item_in_stock"
    /*Otp */
    static let  WS_OTP_VERFICATION =  "api/store/otp_verification"
    
    
    /* History */
    static let WS_GET_HISTORY = "api/store/order_history"
    static let WS_GET_HISTORY_DETAIL = "api/store/order_history_detail"
    /* Earning*/
    static let  WS_GET_DAILY_EARNING = "api/store/daily_earning";
    static let  WS_GET_WEEKLY_EARNING = "api/store/weekly_earning";
    /*Order */
    
    static let  WS_GET_VEHICLE_LIST = "api/store/get_vehicles_list"
    static let  WS_GET_ORDER_LIST = "api/store/order_list"
    static let  WS_GET_ORDER_DETAIL = "api/store/get_order_detail"
    
    static let  WS_GET_ORDER_DELIVERY_LIST = "api/store/order_list_for_delivery"
    static let  WS_CHECK_ORDER_STATUS = "api/store/check_order_status"
    static let  WS_CHECK_REQUEST_STATUS = "api/store/check_request_status"
    static let  WS_CANCEL_REJECT_ORDER = "api/store/store_cancel_or_reject_order"
    static let  WS_SET_PAYMENT_STATUS = "api/store/order_payment_status_set_on_cash_on_delivery";
    static let  WS_CANCEL_REQUEST = "api/store/cancel_request"
    static let  WS_CREATE_REQUEST = "api/store/create_request"
    static let  WS_SET_ORDER_STATUS = "api/store/set_order_status"
    static let WS_COMPLETE_ORDER = "api/store/complete_order"
    static let WS_CHANGE_DELIVERY_ADDRESS = "api/user/change_delivery_address"
    
    
    /*Self Order Service*/
    static let  WS_ADD_ITEM_IN_CART = "api/user/add_item_in_cart"
    static let  WS_CLEAR_CART = "api/user/clear_cart"
    static let  WS_GET_CART_INVOICE = "api/user/get_order_cart_invoice"
    static let  WS_GET_USER_DATA = "api/store/get_user"
    static let  GET_ORDER_INVOICE = "api/store/get_order_invoice"
    static let  WS_CREATE_ORDER = "api/user/create_order"
    static let  WS_PAY_ORDER_PAYMENT  =  "api/user/pay_order_payment"
    static let  CREATE_ORDER_WITHOUT_ITEM = "api/store/create_order"
    static let  UPDATE_ORDER  =  "api/store/update_order"
    static let  CHANGE_DELIVERY_ADDRESS_WITHOUT_ITEM = "api/store/store_change_delivery_address"
    static let GET_ITEM_DETAIL = "api/get_item_detail"
    
    //Feedback
    static let  WS_STORE_RATE_TO_USER  = "api/store/rating_to_user"
    static let  WS_STORE_RATE_TO_PROVIDER  = "api/store/rating_to_provider"
    static let WS_FIND_NEAREST_PROVIDER_LIST = "api/store/find_nearest_provider_list"
    static let WS_UPDATE_SPECIFICATION_NAME =  "api/store/update_specification_name"
    static let WS_UPDATE_SP_NAME =  "api/admin/update_sp_name"
    
    //Web Service related to Wallet
    static let WS_CREATE_WALLET_REQUEST = "api/admin/create_wallet_request";
    static let WS_GET_WALLET_REQUEST_LIST = "api/admin/get_wallet_request_list"
    static let WS_CANCEL_WALLET_REQUEST = "admin/cancel_wallet_request"
    static let WS_GET_WALLET_HISTORY  = "api/admin/get_wallet_history"
    //Web Service related to Bank detail
    
    static let WS_SELECT_BANK_DETAIL = "api/admin/select_bank_detail"
    static let WS_ADD_BANK_DETAIL = "api/admin/add_bank_detail"
    static let WS_GET_BANK_DETAIL = "api/admin/get_bank_detail"
    static let WS_DELETE_BANK_DETAIL = "api/admin/delete_bank_detail"
    
    /*Promo Webservice*/
    static let  GET_PROMO_CODE_LIST  = "api/store/promo_code_list"
    static let  UPDATE_PROMO_CODE = "api/store/update_promo_code"
    static let ADD_PROMO_CODE = "api/store/add_promo"
    static let CHECK_PROMO_CODE = "api/store/check_promo_code"
    
    /*payment related web service*/
    static let  WS_ADD_CARD = "api/user/add_card"
    static let  WS_GET_CARD_LIST = "api/user/get_card_list"
    static let  WS_SELECT_CARD = "api/user/select_card"
    static let  WS_DELET_CARD =  "api/user/delete_card"
    static let  WS_ADD_WALLET_AMOUNT  = "api/user/add_wallet_amount"
    static let  WS_CHANGE_WALLET_STATUS  = "api/user/change_user_wallet_status"
    static let  WS_GET_PAYMENT_GATEWAYS  = "api/user/get_payment_gateway"
    
    static let GET_STRIPE_ADD_CARD_INTENT = "api/user/get_stripe_add_card_intent"
    static let GET_STRIPE_PAYMENT_INTENT_WALLET =  "api/user/get_stripe_payment_intent_wallet"
    
    /*SubStore*/
    static let WS_SUB_STORE_LOGIN =  "api/store/sub_store_login"
    static let WS_GET_SUB_STORE_LIST =  "api/store/sub_store_list"
    static let WS_ADD_SUB_STORE =  "api/store/add_sub_store"
    static let WS_UPDATE_SUB_STORE =  "api/store/update_sub_store"
    static let WS_CHECK_STORE_LOCATION =  "api/store/check_store_location"
    static let SEND_PAYSTACK_REQUIRED_DETAIL = "/api/user/send_paystack_required_detail"
    
    static let WS_TWILIO_CALL_MASK_STORE = "api/store/twilio_voice_call_from_store"
    
    static let WS_DELETE_ACCOUNT = "api/store/delete_account"
}

struct SEGUE {
    
    static let  ITEM_TO_ADD_PRODUCT = "segueToProduct"
    static let  SPECIFICATION_GROUP_TO_SPECIFICATION = "segueSpecificationGroupToSpecification"
    static let  MENU_TO_SPECIFICATION_GROUP =   "segueMenuToSpecificationGroup"
    static let  MENU_TO_CATEGORY_GROUP =   "segueMenuToCategoryGroup"
    static let  SEGUE_LOGIN = "segueToLogin"
    static let  SEGUE_REGISTER = "segueToRegister"
    static let  SETTING = "segueToSetting"
    static let  DOCUMENT = "segueHomeToDocument"
    static let  PRODUCT  = "segueToProducts"
    static let  ADD_PRODUCT = "segueToAddProduct"
    static let  EDIT_PRODUCT = "segueToEditProduct"
    static let  ADD_ITEM_SPECIFICATIONS = "segueToAddItemSpec"
    static let  HISTORY = "segueToHistory"
    static let HISTORY_DETAIL = "segueHistoryToDetail"
    static let HISTORY_DETAIL_TO_INVOICE = "segueToInvoiceDetail"
    static let EARNING_TO_WEEKLY = "segueEarnToWeek";
    static let EARNING_TO_DAILY = "segueEarnToDaily";
    static let EARNING = "segueToEarning";
    static let ORDERSTATUS = "segueToOrderStatus"
    static let ORDERDETAIL = "segueToOrderDetail"
    static let FEEDBACK = "segueToFeedback"
    static let SHARE = "segueToShare"
    static let HELP =   "segueToHelp"
    static let LOCATION = "segueToLocation"
    static let STORE_SCHEDULE = "segueToStoreSchedule"
    static let FAMOUS_FOR = "segueToFamousFor"
    static let SPECIFICATION_TO_CART =   "segueToCart"
    static let PRODUCT_TO_CART =   "segueToCart"
    static let TO_INVOICE =  "segueOrderDetailToInvoice"
    static let EDIT_ORDER = "segueToEditOrder"
    static let UPDATE_ORDER_PRODUCT_SPECIFICATION =   "seguetoUpdateOrderProductSpecification"
    static let PROMOLIST_TO_PROMO = "seguePromoListToPromo"
    static let PROMOLIST = "segueToPromo"
    /*drawer SEGUE*/
    static let  SEGUE_PROFILE = "segueToProfile"
    static let  SEGUE_DOCUMENT = "segueToDocument"
    static let REVIEW =  "segueReview"
    static let USER_TO_BANK_DETAIL = "segueUserToBankDetails"
    static let USER_TO_WALLET_PAYMENT = "segueToWalletPayment"
    static let BANKLIST_TO_BANK_DETAIL = "segueToBankDetail"
    static let PAYMENT_TO_BANK_DETAIL =  "segueToBankDetail"
    static let SELECT_WITHDRAW_METHOD = "segueToSelectWithDrawalMethod"
    static let HISTORY_TO_TRANSACTION_HISTORY = "segueToTransactionHistory"
    static let HISTORY_TO_WALLET_HISTORY = "segueToWalletHistory"
    static let STORE_PRODUCT_LIST = "segueToProductList"
    static let ITEM_LIST = "segueToItemList"
    static let PRODUCT_SPECIFICATION_LIST = "segueToProductToProductSpecificationList"
    static let UPDATE_ORDER_ITEM_SPECIFICATION = "segueToUpdateOrderItem"
    static let WALLET_TO_HISTORY = "segueToHistoryVC"
    static let WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL = "segueToWalletHistoryDetail"
    static let TRANSACTION_HISTORY_TO_TRANSACTION_HISTORY_DETAIL = "segueToWalletTransactionDetail"
    static let INSTANCE_ORDER = "segueToInstanceOrder"
    static let INSTANCE_ORDER_INVOICE = "segueToInstanceOrderInvoice"
    static let SUB_STORE = "segueToSubStore"
    static let OTHER_DETAIL = "segueToOtherDetail"
    static let CART_DETAIL = "segueToCartDetail"
    static let ORDER_DELIVERY_DETAIL = "segueOrderDeliveryData"
    static let SEGUE_TO_MASS_NOTIFICATIONS = "segueToMassNoti"
    static let SEGUE_TO_ORDER_NOTIFICATIONS = "segueToOrderNoti"
    static let PAYMENT_TO_PAYSTACK_WEBVIEW = "seguePaymentToPaystackWebview"
}


struct DATE_CONSTANT {
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let DATE_TIME_FORMAT_WEB   = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd HH:mm a"
    static let TIME_FORMAT = "HH:mm"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_MM_DD_YYYY = "MM/dd/yyyy"
    static let DATE_MM_DD_YYYY_VERTICALBAR = "MM|dd|yyyy"
    
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let WEEK_FORMAT = "EEE, dd MMMM"
    static let DD_MM_YY = "dd MM yy"
    static let DD_MMM_YY = "dd MMM yy"
    static let DD_MM_YYYY = "dd-MM-yyyy"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
    static let TIME_FORMAT_24Hours = "H:mm"
    static let MM_DD_YYY = "MM-dd-yyyy"
}

struct PARAMS {
    /*General Parameters*/
    static let ID = "id";
    static let DEST_LAT = "dest_latitude";
    static let DEST_LONG = "dest_longitude";
    static let VEHICLE_ID = "vehicle_id";

    static let ORDER_TYPE = "order_type";
    static let ORDER_DETAILS = "order_details"
    static let _ID = "_id";
    static let CART_ID = "cart_id";
    static let SERVER_TOKEN = "server_token";
    static let DEVICE_TOKEN = "device_token";
    static let DEVICE_TYPE = "device_type";
    static let IMAGE_URL = "image_url";
    static let TYPE = "type";
    static let APP_VERSION = "app_version"
    static let USER_ID = "user_id";
    static let STORE_ID="store_id";
    static let ORDER_ID="order_id";
    static let DELIVERY_PRICE_USED_TYPE = "delivery_price_used_type";
    static let PROVIDER_ID="provider_id";
    static let SOCIAL_ID = "social_id";
    static let DESTINATION_ADDRESSES = "destination_address";
    static let NOTE_FOR_DELIVERYMAN = "note_for_deliveryman";
    /*Login/Register/Profile/Setting Parameters*/
    static let NAME = "name";
    static let FIRST_NAME = "first_name";
    static let LAST_NAME = "last_name";
    static let EMAIL = "email";
    static let PASS_WORD = "password";
    static let LOGIN_BY = "login_by";
    static let COUNTRY_PHONE_CODE = "country_phone_code";
    static let PHONE = "phone";
    static let OTP = "otp";
    static let CAPTCHA_TOKEN = "captcha_token";

    static let ADDRESS = "address";
    static let STORE_DELIVERY_ID = "store_delivery_id";
    static let IS_STORE_CAN_CREATE_GROUP = "is_store_can_create_group"
    static let COUNTRY_ID = "country_id";
    static let CITY_ID = "city_id";
    static let DELIVERY_TYPE =   "delivery_type";
    static let IS_APPROVED =   "is_approved";

    static let COUNTRY = "country";
    static let COUNTRY_CODE = "country_code";
    static let REFERRAL_CODE = "referral_code";
    static let LATITUDE = "latitude";
    static let LONGITUDE = "longitude";
    static let SLOGAN = "slogan";
    static let FAMOUS_FOR = "famous_for";
    static let WEBSITE_URL = "website_url";
    static let IS_BUSINESS = "is_business";
    static let IS_STORE_BUSSY = "is_store_busy";
    static let IS_PROVIDER_PICKUP_DELIVERY = "is_provide_pickup_delivery";
    static let IS_VISIBLE = "is_visible";
    static let IS_STORE_PAY_DELIVERY_FEES = "is_store_pay_delivery_fees";
    static let IS_STORE_SET_SCHEDULE_DELIVERY_TIME = "is_store_set_schedule_delivery_time";

    static let STORE_TIME = "store_time";
    static let OFFER = "offer";
    static let OLD_PASSWORD = "old_password";
    static let NEW_PASSWORD = "new_password";
    static let FREE_DELIVERY_FOR_ABOVE_ORDER_PRICE = "free_delivery_for_above_order_price";
    static let PRODUCT_GROUP_ID = "product_group_id";
    static let PRODUCT_IDS = "product_ids";
    static let SP_ID = "sp_id";

    static let FREE_DELIVERY_RADIUS = "free_delivery_within_radius";
    static let ITEM_TAX = "item_tax";
    static let COMMENTS = "comments";
    static let DELIVERY_TIME = "delivery_time";
    static let DELIVERY_TIME_MAX = "delivery_time_max";
    static let PRICE_RATING = "price_rating";
    static let IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified"
    static let IS_EMAIL_VERIFIED = "is_email_verified"
    static let PAYMENT_ID = "payment_id";
    static let ORDER_PAYMENT_ID = "order_payment_id";

    static let REFERENCE = "reference"
    static let REQUIRED_PARAM = "required_param"
    static let PIN = "pin"
    static let BIRTHDAY = "birthday"

    static let MIN_ORDER_PRICE = "min_order_price";
    static let INFORM_SCHEDULE_ORDER_BEFORE_MIN = "inform_schedule_order_before_min";
    static let IS_TAKING_SCHEDULE_ORDER = "is_taking_schedule_order";
    static let DELIVERY_RADIUS = "delivery_radius";
    static let IS_PROVIDE_DELIVERY_ANYWHERE = "is_provide_delivery_anywhere";
    static let SCHEDULE_ORDER_CREATE_AFTER_MINUTE = "schedule_order_create_after_minute";
    static let MAX_ITEM_QUANTITY_ADD_BY_USER = "max_item_quantity_add_by_user";
    static let ORDER_CANCELLATION_CHARGE_VALUE = "order_cancellation_charge_value";
    static let ORDER_CANCELLATION_CHARGE_TYPE = "order_cancellation_charge_type";
    static let ORDER_CANCELLATION_CHARGE_FOR_ABOVE_ORDER_PRICE = "order_cancellation_charge_for_above_order_price";
    static let IS_ORDER_CANCELLATION_CHARGE_APPLY = "is_order_cancellation_charge_apply";
    /*Documents*/
    static let DOCUMENT_ID = "document_id";
    static let UNIQUE_CODE = "unique_code";
    static let EXPIRED_DATE = "expired_date";
    /*Product */
    static let PRODUCT_ID = "product_id";
    static let DETAILS = "details";
    static let IS_VISIBLE_IN_STORE = "is_visible_in_store";
    static let SPECIFICATION_GROUP_ID = "specification_group_id";
    static let SPECIFICATION_GROUP_NAME = "specification_group_name";
    static let SEQUENCE_NUMBER = "sequence_number";
    static let user_can_add_specification_quantity = "user_can_add_specification_quantity";

    static let SPECIFICATION_ID = "specification_id";
    static let SPECIFICATION_NAME = "specification_name";
    /*Items*/
    static let ITEM_ID = "item_id";
    static let IS_ITEM_IN_STOCK = "is_item_in_stock";
    static let ITEM_ARRAY = "item_array";

    /*History*/
    static let START_DATE = "start_date";
    static let END_DATE = "end_date";
    /*Order Params*/
    static let IS_PAY_BY_STORE = "is_order_price_paid_by_store"
    static let ORDER_STATUS = "order_status"
    static let CANCELATION_REASON = "cancel_reason"
    static let IS_SCHEDULE_ORDER = "is_schedule_order"
    static let ORDER_START_AT  = "order_start_at"
    static let TOTAL_ORDER_PRICE = "total_product_price"

    /*Feedback*/
    static let STORE_RATING_TO_USER =  "store_rating_to_user"
    static let STORE_REVIEW_TO_USER = "store_review_to_user"
    static let STORE_RATING_TO_PROVIDER = "store_rating_to_provider"
    static let STORE_REVIEW_TO_PROVIDER = "store_review_to_provider"

    /*Bank Params*/
    static let BANK_HOLDER_TYPE = "bank_holder_type"
    static let BANK_HOLDER_ID  = "bank_holder_id"
    static let BANK_DETAIL_ID  = "bank_detail_id"
    static let BANK_ACCOUNT_HOLDER_NAME = "bank_account_holder_name"
    static let BANK_ACCOUNT_NUMBER = "account_number"
    static let BANK_ROUTING_NUMBER = "routing_number"
    static let BANK_PERSONAL_ID_NUMBER = "personal_id_number"
    static let BANK_DOB = "dob"
    static let BANK_DOCUMENT = "document"
    static let GENDER = "gender"
    static let POSTAL_CODE = "postal_code"
    static let STATE = "state"
    static let ACCOUNT_HOLDER_TYPE = "account_holder_type"
    static let ACCOUNT_HOLDER_NAME = "account_holder_name"
    static let BANK_CODE = "bank_code";

    //Wallet Params
    static let REQUESTED_WALLET_AMOUNT = "requested_wallet_amount"
    static let DESCRIPTION_FOR_REQUESTED_WALLET_AMOUNT = "description_for_request_wallet_amount"
    static let TRANSACTION_DETAILS = "transaction_details"
    static let WALLET_STATUS = "wallet_status"
    static let IS_PAYMENT_MODE_CASH = "is_payment_mode_cash"

    static let CART_UNIQUE_TOKEN = "cart_unique_token"
    //Invoice Params
    static let TOTAL_DISTANCE = "total_distance";
    static let TOTAL_TIME = "total_time";
    static let TOTAL_ITEM_COUNT = "total_item_count";
    static let TOTAL_SPECIFICATION_COUNT = "total_specification_count";
    static let TOTAL_CART_PRICE = "total_cart_price";
    static let TOTAL_ITEM_PRICE = "total_item_price";
    static let TOTAL_SPECIFICATION_PRICE = "total_specification_price";
    static let PROMO_CODE = "promo_code_name"
    static let FAMOUS_PRODUCTS_TAGS = "famous_products_tags"
    static let ESTIMATED_TIME_FOR_READY_ORDER = "estimated_time_for_ready_order"
    static let IS_ASK_ESTIMATED_TIME_FOR_READY_ORDER = "is_ask_estimated_time_for_ready_order"
    static let IS_USER_PICK_UP_ORDER = "is_user_pick_up_order"

    /**Payment Card PARAMS*/
    static let LAST_FOUR = "last_four";
    static let PAYMENT_TOKEN = "payment_token";
    static let CARD_TYPE = "card_type";
    static let CARD_ID = "card_id";
    static let  CARD_EXPIRY_DATE = "card_expiry_date";
    static let CARD_HOLDER_NAME = "card_holder_name";
    static let WALLET = "wallet";
    static let REQUEST_ID = "request_id"
    static let TAX = "tax"

    static let PAYMENT_METHOD = "payment_method"
    static let PAYMENT_INTENT_ID = "payment_intent_id"
    static let AMOUNT = "amount"
    static let EMAIL_OTP = "email_otp"
    static let SMS_OTP = "sms_otp"
    static let OTP_ID = "otp_id"
    static let TOTAL_CART_AMOUNT_WITHOUT_TAX = "total_cart_amout_without_tax"
    static let IS_TAX_INCLUDED = "is_tax_included"
    static let IS_USE_ITEM_TAX = "is_use_item_tax"
    static let TAX_DETAILS = "tax_details"
    static let PAYMENT_GATEWAY_ID="payment_gateway_id"
    static let STORE_PAGE_TYPE = "store_page_type";
    static let call_to_usertype = "call_to_usertype"
}

struct PROMOFOR {
    static let ITEM = 22;
    static let STORE = 2;
    static let PRODUCT = 21;
    
}
struct PROMO_RECURSION_TYPE {
    static let NONE = 0;
    static let DAY = 1;
    static let WEEK = 2;
    static let MONTH = 3 ;
    static let ANNUAL = 4 ;
}

struct VerificationParameter {
    static let SEND_PIN = "send_pin"
    static let SEND_OTP = "send_otp"
    static let SEND_PHONE = "send_phone"
    static let SEND_BIRTHDAY = "send_birthdate"
    static let SEND_ADDRESS = "send_address"
}

struct CONSTANT {
    static let MANUAL = "manual"
    static let SOCIAL = "social"
    static let IOS = "ios"
    static let SMS_VERIFICATION_ON = 1;
    static let EMAIL_VERIFICATION_ON = 2;
    static let SMS_AND_EMAIL_VERIFICATION_ON = 3;
    static let DELIVERY_LIST = "delivery_list";
    static let SELECTED_STORE="selected_store";
    static let DELIVERY_STORE="delivery_store";
    static let TYPE_STORE =  2 ;
    static let TYPE_USER =  7 ;
    static let TYPE_PROVIDER =  8 ;
    
    static var STRIPE_KEY = "";
    static var CHAT_STORE_TYPE = 4
    
    struct TWITTER {
        static let CONSUMER_KEY = "Tm3zUCWPIpW4hnkiNy31E88aV";
        static let SECRET_KEY = "qo9vvmbuX7Y3nPVaP6RNZOB4gejR9LaKC8mKy0oc44rFXjnXCl";
    }
    static let UPDATE_URL = "https://itunes.apple.com/us/app/edelivery-store/id1281252858?ls=1&mt=8"
    
    struct  DBPROVIDER
    {
        static let MESSAGES = "MESSAGES"
        static let MEDIA_MESSAGES = "media_message"
        static let USER = "user"
        static let IMAGE_STORAGE = "image_storage"
        static let VIDEO_STORAGE = "video_storage"
        static let EMAIL = "email"
        static let PASSWORD = "password"
    }
    
    struct MESSAGES {
        static let ID = "id"
        //static let TYPE = "chat_type"
        static let TEXT = "message"
        static let TIME = "time"
        static let STATUS = "is_read"
        static let SENDER_TYPE = "sender_type"
        static let CHAT_TYPE = "chat_type"
        static let RECEIVER_ID = "receiver_id"
        
    }
    
    struct CHATTYPES {
        static let ADMIN_AND_STORE = 14
        static let USER_AND_STORE = 24
        static let PROVIDER_AND_STORE = 34
        
        //            ADMIN_AND_USER = 12;
        //            ADMIN_AND_PROVIDER = 13;
        //            ADMIN_AND_STORE = 14;
        //            USER_AND_PROVIDER = 23;
        //            USER_AND_STORE = 24;
        //            PROVIDER_AND_STORE = 34;
        
    }
}


struct Google {
    static let  GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let  AUTO_COMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"

    static var API_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"
    static var MAP_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"
    
    static var CLIENT_ID = "966521710311-nafbfmdfjtuvoh476mmc7nptfboulc3v.apps.googleusercontent.com"
    /*Google Parameters*/
    static let  OK = "OK";
    static let  STATUS = "status";
    static let  RESULTS = "results";
    static let  GEOMETRY = "geometry";
    static let  LOCATION = "location";
    static let  ADDRESS_COMPONENTS = "address_components";
    static let  LONG_NAME = "long_name";
    static let  ADMINISTRATIVE_AREA_LEVEL_2 = "administrative_area_level_2";
    static let  ADMINISTRATIVE_AREA_LEVEL_1 = "administrative_area_level_1";
    static let  COUNTRY = "country";
    static let  COUNTRY_CODE = "country_code";
    static let  SHORT_NAME = "short_name";
    static let  TYPES = "types";
    static let  LOCALITY = "locality";
    static let  PREDICTIONS = "predictions";
    static let  LAT = "lat";
    static let  LNG = "lng";
    static let  NAME = "name";
    static let  DESTINATION_ADDRESSES = "destination_addresses";
    static let  ORIGIN_ADDRESSES = "origin_addresses";
    static let  ROWS = "rows";
    static let  ELEMENTS = "elements";
    static let  DISTANCE = "distance";
    static let  VALUE = "value";
    static let  DURATION = "duration";
    static let  TEXT = "text";
    static let  ROUTES = "routes";
    static let  LEGS = "legs";
    static let  STEPS = "steps";
    static let  POLYLINE = "polyline";
    static let  POINTS = "points";
    static let  ORIGIN = "origin";
    static let  ORIGINS = "origins";
    static let  DESTINATION = "destination";
    static let  DESTINATIONS = "destinations";
    static let  DESCRIPTION = "description";
    static let  KEY = "key";
    static let  EMAIL = "email";
    static let  ID = "id";
    static let  PICTURE = "picture";
    static let  URL = "url";
    static let  DATA = "data";
    static let  RADIUS = "radius";
    static let  FIELDS = "fields";
    static let  ADDRESS = "address";
    static let  FORMATTED_ADDRESS = "formatted_address";
    static let  LAT_LNG = "latlng";
    static let  STRUCTURED_FORMATTING = "structured_formatting"
    static let  MAIN_TEXT = "main_text"
    static let  SECONDARY_TEXT = "secondary_text"
}

enum OrderStatus: Int {
    case WAITING_FOR_ACCEPT_STORE = 1
    case STORE_ACCEPTED = 3
    case STORE_PREPARING_ORDER =  5
    case ORDER_READY =  7
    case WAITING_FOR_DELIVERY_MAN =  9
    case DELIVERY_MAN_ACCEPTED =  11
    case DELIVERY_MAN_COMING =  13
    case DELIVERY_MAN_ARRIVED =  15
    case DELIVERY_MAN_PICKED_ORDER =  17
    case DELIVERY_MAN_STARTED_DELIVERY =  19
    case DELIVERY_MAN_ARRIVED_AT_DESTINATION =  21
    case DELIVERY_MAN_COMPLETE_DELIVERY =  25
    case TABLE_BOOKING_ARRIVED = 27
    case CANCELED_BY_USER = 101
    case STORE_CANCELLED =  104
    case STORE_REJECTED =  103
    case NO_DELIVERY_MAN_FOUND = 109
    case DELIVERY_MAN_REJECTED =  111
    case DELIVERY_MAN_CANCELLED =  112
    case STORE_CANCELLED_REQUEST =  105
    case Unknown

    func text(orderItem:Order = Order(fromDictionary: [:])) -> String {
        switch self {
            case .WAITING_FOR_ACCEPT_STORE :
                if orderItem.order_change !=  nil {
                    if orderItem.order_change! {
                        return "MSG_WAIT_FOR_CONFIRMATION".localized
                    } else {
                        return "MSG_WAIT_FOR_ACCEPT_STORE".localized
                    }
                } else {
                    return "MSG_WAIT_FOR_ACCEPT_STORE".localized
                }
            case .CANCELED_BY_USER : return "MSG_CANCELED_BY_USER".localized
            case .STORE_ACCEPTED : return "MSG_STORE_ACCEPTED".localized
            case .STORE_REJECTED : return "MSG_STORE_REJECTED".localized
            case .STORE_CANCELLED: return "MSG_STORE_CANCELLED".localized
            case .STORE_PREPARING_ORDER : return "MSG_STORE_PREPARING_ORDER".localized
            case .ORDER_READY : return "MSG_ORDER_READY".localized
            case .WAITING_FOR_DELIVERY_MAN : return "MSG_WAITING_FOR_DELIVERY_MAN".localized
            case .DELIVERY_MAN_ACCEPTED : return "MSG_DELIVERY_MAN_ACCEPTED".localized
            case .DELIVERY_MAN_COMING : return "MSG_DELIVERY_MAN_COMING".localized
            case .DELIVERY_MAN_ARRIVED: return "MSG_DELIVERY_MAN_ARRIVED".localized
            case .DELIVERY_MAN_PICKED_ORDER :return "MSG_DELIVERY_MAN_PICKED_ORDER".localized
            case .DELIVERY_MAN_REJECTED: return "MSG_DELIVERY_MAN_REJECTED_ORDER".localized
            case .DELIVERY_MAN_CANCELLED : return "MSG_DELIVERY_MAN_CANCELLED".localized
            case .DELIVERY_MAN_STARTED_DELIVERY : return "MSG_DELIVERY_MAN_STARTED_DELIVERY".localized
            case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return "MSG_DELIVERY_MAN_ARRIVED_AT_DESTINATION".localized
            case .DELIVERY_MAN_COMPLETE_DELIVERY : return "MSG_DELIVERY_MAN_COMPLETE_DELIVERY".localized
            case .NO_DELIVERY_MAN_FOUND : return "MSG_NO_DELIVERY_MAN_FOUND".localized
            case .STORE_CANCELLED_REQUEST : return "MSG_STORE_CANCELLED_REQUEST".localized
            case .TABLE_BOOKING_ARRIVED : return "text_status27".localized
            default: return "Unknown"
        }
    }

    func textColor(orderItem:Order = Order(fromDictionary: [:])) -> UIColor {
        switch self {

            case .WAITING_FOR_ACCEPT_STORE :
                return UIColor(rgb: 0xE53935)
            case .CANCELED_BY_USER :                 return UIColor(rgb: 0xE53935)
            case .STORE_ACCEPTED :                 return UIColor(rgb: 0xFF8A65)
            case .STORE_REJECTED :                 return UIColor(rgb: 0xE53935)
            case .STORE_CANCELLED:                 return UIColor(rgb: 0xE53935)
            case .STORE_PREPARING_ORDER :                 return UIColor(rgb: 0xFFB300)
            case .ORDER_READY :                 return UIColor(rgb: 0x7CB342)
            case .WAITING_FOR_DELIVERY_MAN :                 return UIColor(rgb: 0xE53935)
            case .DELIVERY_MAN_ACCEPTED : return UIColor(rgb: 0xFF8A65)
            case .DELIVERY_MAN_COMING : return UIColor(rgb: 0xFFB300)
            case .DELIVERY_MAN_ARRIVED: return UIColor(rgb: 0xFFB300)
            case .DELIVERY_MAN_PICKED_ORDER :return UIColor(rgb: 0xFFB300)
            case .DELIVERY_MAN_REJECTED: return UIColor(rgb: 0xE53935)
            case .DELIVERY_MAN_CANCELLED : return UIColor(rgb: 0xFF8A65)
            case .DELIVERY_MAN_STARTED_DELIVERY : return UIColor(rgb: 0x7CB342)
            case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return UIColor(rgb: 0x00897B)
            case .DELIVERY_MAN_COMPLETE_DELIVERY : return UIColor(rgb: 0xFFB300)
            case .NO_DELIVERY_MAN_FOUND : return UIColor(rgb: 0xE53935)
            case .STORE_CANCELLED_REQUEST : return UIColor(rgb: 0xE53935)
            case .TABLE_BOOKING_ARRIVED: return UIColor(rgb: 0xFFB300)
            default: return UIColor(rgb: 0xE53935)
        }
    }
}


enum CancellationStates: Int {
    case STORE_ACCEPTED = 3
    case STORE_PREPARING_ORDER =  5
    case ORDER_READY =  7
    case DELIVERY_MAN_PICKED_ORDER =  17
    case DELIVERY_MAN_ARRIVED_AT_DESTINATION =  21
    case Unknown
    
    func text(orderItem:Order = Order(fromDictionary: [:])) -> String {
        switch self {
            case .STORE_ACCEPTED : return "TXT_ACCEPTED".localized
            case .STORE_PREPARING_ORDER : return "TXT_START_PREPARE".localized
            case .ORDER_READY : return "TXT_ORDER_READY".localized
            case .DELIVERY_MAN_PICKED_ORDER :return "TXT_PICKEDUP".localized
            case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return "TXT_ARRIVED".localized
            default: return "Unknown"

        }
    }
    
    func toInt(str:String) -> Int {
        switch str {
            case "TXT_ACCEPTED".localized : return 3
            case "TXT_START_PREPARE".localized : return 5
            case "TXT_ORDER_READY".localized : return 7
            case "TXT_PICKEDUP".localized :return 17
            case "TXT_ARRIVED".localized : return 21
            default: return 0
        }
    }
    
}

enum Day: Int {
    case SUN = 0
    case MON = 1
    case TUE = 2
    case WED = 3
    case THU = 4
    case FRI = 5
    case SAT = 6
    func text() -> String {
        switch self {

            case .SUN : return "SUN".localized
            case .MON : return "MON".localized
            case .TUE : return "TUE".localized
            case .WED : return "WED".localized
            case .THU: return "THU".localized
            case .FRI : return "FRI".localized
            case .SAT : return "SAT".localized
        }
    }
}

struct DeliveryType {
    static var store = 1
    static var courier = 2
    static var tableBooking = 3
}

enum WalletRequestStatus:Int {
    case  CREATED = 1
    case  ACCEPTED = 2
    case  TRANSFERED = 3
    case  COMPLETED = 4
    case  CANCELLED = 5
    case  Unknown
    func text() -> String {
        switch self {
            case .CREATED : return "WALLET_STATUS_CREATED".localized
            case .ACCEPTED : return "WALLET_STATUS_ACCEPTED".localized
            case .TRANSFERED : return "WALLET_STATUS_TRANSFERRED".localized
            case .COMPLETED : return "WALLET_STATUS_COMPLETED".localized
            case .CANCELLED : return "WALLET_STATUS_CANCELLED".localized
            default: return "Unknown"

        }
        
    }
    
};

enum SourceVC: Int {
    case CART_VC = 0
    case CREATE_ORDER_VC = 1
    case REGISTER_VC = 2
}

enum WalletHistoryStatus:Int {
    case  ADDED_BY_ADMIN = 1
    case  ADDED_BY_CARD = 2
    case  ADDED_BY_REFERRAL = 3
    case  ORDER_CHARGED = 4
    case  ORDER_REFUND = 5
    case  ORDER_PROFIT = 6
    case  ORDER_CANCELLATION_CHARGE = 7
    case  WALLET_REQUEST_CHARGE = 8
    case  Unknown
    func text() -> String {
        switch self {
            case .ADDED_BY_ADMIN : return "WALLET_STATUS_ADDED_BY_ADMIN".localized   case .ADDED_BY_CARD : return "WALLET_STATUS_ADDED_BY_CARD".localized        case .ADDED_BY_REFERRAL : return "WALLET_STATUS_ADDED_BY_REFERRAL".localized        case .ORDER_CHARGED : return "WALLET_STATUS_ORDER_CHARGED".localized        case .ORDER_REFUND : return "WALLET_STATUS_ORDER_REFUND".localized        case .ORDER_PROFIT : return "WALLET_STATUS_ORDER_PROFIT".localized        case .ORDER_CANCELLATION_CHARGE : return"WALLET_STATUS_ORDER_CANCELLATION_CHARGE".localized        case .WALLET_REQUEST_CHARGE : return "WALLET_STATUS_WALLET_REQUEST_CHARGE".localized        default: return "Unknown"
        }
    }
};

struct Payment {
    static let CASH = "0";
    static let STRIPE = "586f7db95847c8704f537bd5";
    static let PAY_PAL = "586f7db95847c8704f537bd6";
    static let PAY_U_MONEY = "586f7db95847c8704f537bd";
    static let PAYSTACK = "613602def1d028b84bf85ae6";
}

struct AddressType {
    static let DESTINATION = "destination"
    static let PICKUP = "pickup"
    
}

public func clearScreenVisibilityPermission(){
    ScreenVisibilityPermission.CreateOrder = true
    ScreenVisibilityPermission.Order = true
    ScreenVisibilityPermission.Deliveries = true
    ScreenVisibilityPermission.History = true
    ScreenVisibilityPermission.Group = true
    ScreenVisibilityPermission.Product = true
    ScreenVisibilityPermission.Promocode = true
    ScreenVisibilityPermission.Setting = true
    ScreenVisibilityPermission.Earning = true
    ScreenVisibilityPermission.WeeklyEarning = true
}

public func setScreenVisibilityPermission(name: String,permission:Int){
    
    var isShow : Bool = true
    if permission == 0{
        isShow = false
    }else{
        isShow = true
    }
    switch (name) {
        case "Create Order":
            ScreenVisibilityPermission.CreateOrder = isShow
            break
        case "Order":
            ScreenVisibilityPermission.Order = isShow
            break
        case "Deliveries":
            ScreenVisibilityPermission.Deliveries = isShow
            break
        case "History":
            ScreenVisibilityPermission.History = isShow
            break
        case "Group":
            ScreenVisibilityPermission.Group = isShow
            break
        case "Product":
            ScreenVisibilityPermission.Product = isShow
            break
        case "Promo Code":
            ScreenVisibilityPermission.Promocode = isShow
            break
        case "Settings":
            ScreenVisibilityPermission.Setting = isShow
            break
        case "Setting":
            ScreenVisibilityPermission.Setting = isShow
            break
        case "Earnings":
            ScreenVisibilityPermission.Earning = isShow
            break
        case "Earning":
            ScreenVisibilityPermission.Earning = isShow
            break
        case "Weekly Earning":
            ScreenVisibilityPermission.WeeklyEarning = isShow
            break
        default:
            break
    }
}

struct CoreDataEntityName {
    static let  MASS_NOTIFICATION = "MassNotifications"
    static let  ORDER_NOTIFICATION = "OrderNotifications"
    
}
struct Printers {
    static  var IS_PRINTER_CONNECTED : Bool = false
    //Printer 1 - Printer
    //Printer 2 - Printer SDK
    static var IS_PRINTER_1_CONNECTED : Bool = true
}
