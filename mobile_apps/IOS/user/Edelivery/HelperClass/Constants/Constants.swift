//
//  AlamofireHelper.swift
//  Store
//
//  Created by Disha Ladani on 07/02/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

let passwordMinLength:Int = 6
let passwordMaxLength:Int = 20
let emailMinimumLength = 12
let emailMaximumLength = 64

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let currentBooking = CurrentBooking.shared
let preferenceHelper = PreferenceHelper.preferenceHelper
let firebaseAuth = Auth.auth()
let signInConfig = GIDConfiguration.init(clientID: Google.CLIENT_ID)

//let  arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),(language: "عربى", code: "ar"),(language: "Española", code: "es"),(language: "Française", code: "fr"),(language: "हिन्दी", code: "hi")]

let RESEND_TIME = 60
let arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),
                                                        (language: "عربى", code: "ar"),
                                                        (language: "Española", code: "es"),
                                                        (language: "Française", code: "fr")]

var arrLanguages = [SettingDetailLang]()
var isChangedLanguageFromSettings : Bool = false
let isConsolePrint = true

struct Constants {
    static var selectedLanguageIndex : String = "0"
    static var selectedLanguageCode : String = "en"
}

public func printE(_ items: Any..., separator: String = "", terminator: String = "") {
    if isConsolePrint {
        print(items, separator, terminator)
    }
}

struct Branch_io {
    static var is_came_from_branch_io_link = false
}

struct DeliveryType {
    static var store = 1
    static var courier = 2
    static var tableBooking = 3
}

enum AppMode: Int {
    case live = 0
    case staging = 1
    case developer = 2
    
    ///When app submission time default Mode must be AppMode.Live
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

    static let  IS_USING_S3BUCKET = false
    static let  UPDATE_DEVICE_TOKEN = "api/user/update_device_token"
    static let  WS_GET_VEHICLES_LIST =  "api/store/get_vehicles_list"
    static let  WS_CHECK_DELIVERY_AVAILABLE =  "api/user/check_delivery_available"
    static let  WS_GET_PROVIDER_LOCATION =  "api/user/get_provider_location"
    static let  WS_USER_LOGIN = "api/user/login"
    static let  WS_USER_REGISTER = "api/user/register"
    static let  WS_APPROVE_EDIT_ORDER = "api/user/approve_edit_order"
//  static let  WS_GET_STORELIST = "api/user/get_store_list"
    static let  WS_GET_STORELIST = "api/user/get_delivery_store_list"
    static let  WS_GET_NEAREST_DELIVERY_LIST = "api/user/get_delivery_list_for_nearest_city"
    static let  WS_CHECK_REFERRAL = "api/admin/check_referral"
    static let  WS_USER_LOGOUT = "api/user/logout"
    static let  WS_GET_SETTING_DETAIL = "api/admin/check_app_keys"
    static let  WS_GET_COUNTRY_LIST = "api/admin/get_country_list"
    static let  WS_GET_CITY_LIST = "api/admin/get_city_list"
    static let  WS_OTP_VERIFICATION = "api/admin/otp_verification"
    static let  WS_UPDATE_OTP_VERFICATION =  "api/user/otp_verification"
    static let  WS_UPDATE_PROFILE = "api/user/update"
    static let  WS_GET_STORE_PRODUCT_ITEM_LIST = "api/user/user_get_store_product_item_list"
    static let  WS_ADD_ITEM_IN_CART = "api/user/add_item_in_cart"
    static let  WS_CLEAR_CART = "api/user/clear_cart"
    static let  WS_GET_CART = "api/user/get_cart"
    static let  WS_GET_CART_INVOICE = "api/user/get_order_cart_invoice"
    static let  WS_GET_COURIER_INVOICE =  "api/user/get_courier_order_invoice"
    static let  WS_GET_USER_INFO = "api/user/get_detail"
    static let  WS_CHECK_PROMO = "api/user/apply_promo_code"
    static let  WS_FORGET_PASSWORD = "api/admin/forgot_password"
    static let  WS_FORGET_PASSWORD_VERIFY = "api/admin/forgot_password_verify"
    static let  WS_NEW_PASSWORD = "api/admin/new_password"
    static let  WS_CHANGE_DELIVERY_ADDRESS = "api/user/change_delivery_address"
    static let  WS_GET_STORE_REVIEW_LIST = "api/user/user_get_store_review_list"
    /*Store Service*/

    static let WS_ADD_FAVOURITE_STORE =  "api/user/add_favourite_store"
    static let WS_REMOVE_FAVOURITE_STORE =  "api/user/remove_favourite_store"
    
    /*payment related web service*/
    static let  WS_ADD_CARD = "api/user/add_card"
    static let  WS_GET_CARD_LIST = "api/user/get_card_list"
    static let  WS_SELECT_CARD = "api/user/select_card"
    static let  WS_DELET_CARD =  "api/user/delete_card"
    static let  WS_ADD_WALLET_AMOUNT = "api/user/add_wallet_amount"
    static let  WS_CHANGE_WALLET_STATUS = "api/user/change_user_wallet_status"
    static let  WS_GET_PAYMENT_GATEWAYS = "api/user/get_payment_gateway"
    
    /*Order Related Services*/
    static let WS_CREATE_ORDER = "api/user/create_order"
    static let WS_PAY_ORDER_PAYMENT =  "api/user/pay_order_payment"
    static let WS_GET_ORDER = "api/user/get_orders"
    static let WS_ORDER_STATUS =  "api/user/get_order_status"
    static let WS_CANCEL_ORDER =  "api/user/user_cancel_order"
    static let WS_GET_CANCEL_REASON_LIST =  "api/user/get_cancellation_reasons"
    static let WS_GET_CANCELLATION_CHARGES = "admin/get_cancellation_charges"
    static let WS_GET_INVOICE =  "api/user/get_invoice"
    static let WS_SHOW_INVOICE =  "api/user/show_invoice"
    static let WS_LIKE_DISLIKE_STORE_REVIEW =  "api/user/user_like_dislike_store_review"

    /* Documents */
    static let WS_GET_DOCUMENT_LIST =  "api/admin/get_document_list"
    static let WS_UPLOAD_DOCUMENT =  "api/admin/upload_document"
    
    /*History*/
    static let WS_GET_HISTORY = "api/user/order_history"
    static let WS_GET_HISTORY_DETAIL = "api/user/order_history_detail"
    static let WS_GET_WALLET_HISTORY = "api/admin/get_wallet_history"
    
    /*Feed Back*/
    static let WS_USER_RATE_TO_PROVIDER = "api/user/rating_to_provider"
    static let WS_USER_RATE_TO_STORE = "api/user/rating_to_store"
    static let WS_GET_ORDER_DETAIL = "api/user/get_order_detail"
    static let WS_GET_FAVOURITE_STORE_LIST = "api/user/get_favourite_store_list"
    static let WS_GET_PRODUCT_GROUP_LIST = "api/user/get_product_group_list"
    static let WS_GET_USER_SPECIFICATION_LIST = "api/user/user_get_specification_list"

    //Update user order
    static let WS_USER_UPDATE_ORDER = "api/user/user_update_order"

    //New Stripe
    static let GET_STRIPE_ADD_CARD_INTENT = "api/user/get_stripe_add_card_intent"
    static let GET_STRIPE_PAYMENT_INTENT_WALLET =  "api/user/get_stripe_payment_intent_wallet"
    static let WS_GET_PROMO_CODE_LIST =  "admin/get_promo_code_list"
    static let WS_GET_STORE_PROMO =  "api/store/get_store_promo"
    static let WS_GET_PROMO_DETAIL =  "admin/get_promo_detail"
    static let SEND_PAYSTACK_REQUIRED_DETAIL = "/api/user/send_paystack_required_detail"
    static let FETCH_TABLE_BOOKING_BASIC_SETTING = "api/store/fetch_table_booking_basic_setting"
    
    static let WS_ADD_FAV_ADDRESS = "api/user/add_favourite_address"
    static let WS_UPDATE_FAV_ADDRESS = "api/user/update_favourite_address"
    static let WS_GET_FAV_ADDRESS_LIST = "api/user/get_favoutire_addresses"
    static let WS_DELETE_FAV_ADDRESS = "api/user/delete_favourite_address"
    static let WS_REGISTER_USER_WITHOUT_CRED = "api/user/register_user_without_credentials"
    
    static let WS_TWILLO_VOICE_CALL_USER = "api/user/twilio_voice_call_from_user"
    
    static let WS_DELETE_ACCOUNT = "api/user/delete_account"
}

struct SEGUE {
    static let  SEGUE_LOGIN = "segueToLogin"
    static let  SEGUE_REGISTER = "segueToRegister"
    static let  SEGUE_DELIVERY_LOCATION = "segueToDeliveryLocation"
    static let  SEGUE_HOME_TAB = "segueToHomeTab"
    static let  SEGUE_USER_TAB = "segueToUserTab"
    static let  SEGUE_STORE_LIST = "segueToStoreList"
    static let  SEGUE_COURIER = "segueToCourier"
    static let  SEGUE_COURIER_INVOICE = "segueToCourierInvoice"
    static let  SEGUE_STORE_FRAGMENT_VC = "segueToStoreFragment"
    static let  SEGUE_PRDOCUT_LIST = "segueToProduct"
    static let  PRODUCT_TO_PRDOCUT_SPECIFICATION = "segueProductToProductSpecfication"
    static let  SEGUE_ORDER_LIST =   "segueToOrder"
    static let  SEGUE_CART =  "segueToCart"
    static let  SEGUE_CART_TO_INVOICE =  "segueCartToInvoice"
    static let  ORDER_STATUS_TO_TRACK_ORDER =  "segueToProviderTrack"
    static let  HOME_TO_DOCUMENT = "segueHomeToDocument"
    static let SHARE =   "segueToShare"
    static let HELP =   "segueToHelp"
    static let ITEM_IMAGES =   "segueToItemImages"
    static let STORE_TO_CART = "segueStoreToCart"
    static let COMPLET_ORDER_TO_CURRENTORDER = "segueCompleteOrderToCurrentOrder"
    static let REVIEW_TO_FEEDBACK = "segueToStoreFeedback"
    
    /*drawer SEGUE*/
    static let  SEGUE_PROFILE = "segueToProfile"
    static let  SEGUE_PAYMENT =  "segueToPayment"
    static let  SEGUE_SETTINGS =  "segueToSettings"
    static let  SEGUE_DOCUMENTS =  "segueToDocuments"
    static let  SEGUE_BANKDETAILS =  "segueToBankdetails"
    static let  SEGUE_SHARE =  "segueToShare"
    static let  SEGUE_SUPPORT =  "segueToSupport"
    static let  SEGUE_LOGOUT =  "segueToLogout"
    static let  SEGUE_ORDER_STATUS =  "segueToOrderStatus"
    static let SEGUE_PREPARE_ORDER = "segueToPrepareOrder"
    static let SETTING = "segueToSetting"
    static let WALLET_HISTORY = "segueToWalletHistory"
    static let FAVOURITE_STORE = "segueToFavouriteStore"
    
   /*Order and History Segue*/
    static let SEGUE_TO_CURRENT_ORDER = "segueToCurrentOrder"
    static let SEGUE_TO_HISTORY = "segueToHistory"
    static let HISTORY_TO_DETAIL = "segueToHistoryDetail"
    static let WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL = "segueToWalletHistoryDetail"
    static let OTHER_DETAIL = "segueToOtherDetail"
    static let CART_DETAIL = "segueToCartDetail"
    static let COURIER_HISTORY_DETAIL = "segueToCourierHistoryDetail"
    
    /*Invoice and Feedback Segue*/
    static let HISTORY_DETAIL_TO_INVOICE = "segueHistoryToInvoice"
    static let HISTORY_DETAIL_TO_FEEDBACK = "segueHistoryToFeedback"
    static let INVOICE_TO_FEEDBACK =  "segueToFeedback"
    static let ORDER_TO_INVOICE =  "segueOrderToInvoice"
    static let ORDER_TO_FEEDBACK =  "segueOrderToFeedback"
    static let ORDER_STATUS_TO_INVOICE = "segueOrderStatusToInvoice"
    static let PAYMENT_TO_PLACED_ORDER = "seguePaymentToPlacedOrder"
    static let HOME_TO_PRODUCT = "segueToProduct"
    static let REVIEW = "segueToReview"
    static let OVERVIEW = "segueToOverview"
    static let STORE_REVIEW =  "segueToStoreReview"
    static let FAV_STORE_TO_PRODUCT = "segueFavStoreToProduct"
    static let CART_TO_PRODUCT_SPECIFICATION = "segueCartToProductSpecification"
    static let ORDER_STATUS_TO_COURIER_DETAIL = "segueToCourierDetail"
    static let SEGUE_TO_MASS_NOTIFICATIONS = "segueToMassNoti"
    static let SEGUE_TO_ORDER_NOTIFICATIONS = "segueToOrderNoti"
    static let  PAYMENT_TO_PAYSTACK_WEBVIEW = "seguePaymentToPaystackWebview"

}

struct DATE_CONSTANT {
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let DATE_TIME_FORMAT_WEB  = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    static let TIME_FORMAT = "H:mm"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_MM_DD_YYYY = "MM/dd/yyyy"
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd hh:mm a"
    static let DATE_FORMAT_ORDER_STATUS = "MMM dd"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
    static let DATE_FORMATE_SLOT = "EEE, MMM dd yyyy H:mm"
    static let DATE_FORMATE_SLOT_DATE = "EEE, MMM dd"
    static let DATE_FORMATE_DAY = "EEE"
    static let DATE_FORMATE_WITHOUT_TIME = "EEE, MMM dd yyyy"
    static let DATE_FORMATE_TIME = "H:mm"
    static let DATE_FORMATE_NOTIFICATION = "E, d MMM yyyy HH:mm:ss a"
    static let DATE_DD_MMM_YY = "dd MMM yy"
    static let DATE_TIME_FORMAT_HISTORY = "dd MMM yyyy, hh:mm a"
    static let DATE_FORMATE_DAY_MONTH_YEAR = "dd MMM yyyy"
    static let DATE_SCHEDULE = "dd-MM-yyyy"
}

struct TimeRate {
    static let TIME_RATE_1 = 20
    static let TIME_RATE_2 = 60
    static let TIME_RATE_3 = 120
}
struct AddressType {
    static let DESTINATION = "destination"
    static let PICKUP = "pickup"
}
struct PriceRate {
    static let PRICE_RATE_1 = 1
    static let PRICE_RATE_2 = 2
    static let PRICE_RATE_3 = 3
    static let PRICE_RATE_4 = 4
}

struct TIP_TYPE {
    static let TIP_TYPE_PERCENTAGE = 1
    static let TIP_TYPE_ABS = 0
}

struct IMAGE_SIZE_TYPE {
//    static let LARGE = ""
//    static let MEDIUM = "_md"
//    static let SMALL = "_sm"
}

struct PARAMS {
    static let ID = "id"
    static let IS_USER_CLICKED_LIKE_STORE_REVIEW = "is_user_clicked_like_store_review"
    static let IS_USER_CLICKED_DISLIKE_STORE_REVIEW = "is_user_clicked_dislike_store_review"
    static let REVIEW_ID = "review_id"
    static let NOTE_FOR_DELIVERYMAN = "note_for_deliveryman"
    static let STORE_DELIVERY_ID = "store_delivery_id"
    static let DELIVERY_ID = "delivery_id"
    static let CART_ID = "cart_id"
    static let NOTE_FOR_ITEM = "note_for_item"
    static let SOCIAL_ID = "social_id"
    static let LOGIN_BY = "login_by"
    static let IS_USER_SHOW_INVOICE = "is_user_show_invoice"
    static let FIRST_NAME = "first_name"
    static let LAST_NAME = "last_name"
    static let EMAIL = "email"
    static let PASS_WORD = "password"
    static let COUNTRY_PHONE_CODE = "country_phone_code"
    static let PHONE = "phone"
    static let OTP = "otp"
    static let ADDRESS = "address"
    static let ADDRESS_NAME = "address_name"
    static let STREET = "street"
    static let FLAT_NO = "flat_no"
    static let LANDMARK = "landmark"
    static let COUNTRY_ID = "country_id"
    static let VEHICLE_ID = "vehicle_id"
    static let CITY_ID = "city_id"
    static let SERVER_TOKEN = "server_token"
    static let IS_USER_PICK_UP_ORDER = "is_user_pick_up_order"
    static let DEVICE_TOKEN = "device_token"
    static let DEVICE_TYPE = "device_type"
    static let IMAGE_URL = "image_url"
    static let TYPE = "type"
    static let USER_ID = "user_id"
    static let IPHONE_ID = "cart_unique_token"
    static let COUNTRY = "country"
    static let COUNTRY_CODE = "country_code"
    static let REFERRAL_CODE = "referral_code"
    static let IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified"
    static let IS_EMAIL_VERIFIED = "is_email_verified"
    static let APP_VERSION = "app_version"
    static let IS_SCHEDULE_ORDER = "is_schedule_order"
    static let ORDER_START_AT = "order_start_at"
    static let ORDER_START_AT2 = "order_start_at2"
    static let TIP_AMOUNT = "tip_amount"
    static let REFERENCE = "reference"
    static let REQUIRED_PARAM = "required_param"
    static let PIN = "pin"
    static let BIRTHDAY = "birthday"
    static let DELIVERY_USER_NAME =  "delivery_user_name"
    static let DELIVERY_USER_PHONE =   "delivery_user_phone"
    static let DELIVERY_TYPE =   "delivery_type"
    static let MIN_ORDER_PRICE =  "min_order_price"
    ///city

    static let CITY = "city"
    static let CITY1 = "city1"
    
    ///subAdmin
    static let CITY2 = "city2"
    ///Admin
    static let CITY3 = "city3"
    static let LATITUDE = "latitude"
    static let LONGITUDE = "longitude"
    static let OLD_PASSWORD = "old_password"
    static let NEW_PASSWORD = "new_password"
    static let STORE_ID="store_id"
    static let GROUP_ID="group_id"
    static let PRODUCT_IDS = "product_ids"
    static let ITEM_ID="item_id"
    static let LATEST_APP_VERSION="ios_user_app_version_code"
    /*Invoice PARAMS*/
    static let TOTAL_DISTANCE = "total_distance"
    static let TOTAL_TIME = "total_time"
    static let TOTAL_ITEM_COUNT = "total_item_count"
    static let TOTAL_SPECIFICATION_COUNT = "total_specification_count"
    static let TOTAL_CART_PRICE = "total_cart_price"
    static let TOTAL_ITEM_PRICE = "total_item_price"
    static let TOTAL_SPECIFICATION_PRICE = "total_specification_price"
    static let PROMO_CODE = "promo_code_name"
    static let TOTAL_ITEM_TAX = "total_item_tax"
    /**Payment Card PARAMS*/
    static let LAST_FOUR = "last_four"
    static let PAYMENT_TOKEN = "payment_token"
    static let CARD_TYPE = "card_type"
    static let PAYMENT_ID = "payment_id"
    static let CARD_ID = "card_id"
    static let ORDER_PAYMENT_ID = "order_payment_id"
    static let WALLET =  "wallet"
    static let IS_WALLET =  "is_use_wallet"
    static let IS_PAYMENT_MODE_CASH =  "is_payment_mode_cash"
    
    static let ORDER_ID =   "order_id"
    static let ORDER_TYPE =   "order_type"
    static let PROVIDER_ID =   "provider_id"
    static let ORDER_STATUS =   "order_status"
    static let CANCEL_REASON =   "cancel_reason"
    static let CANCELLATION_CHARGE = "cancellation_charge"
    static let CANCELLATION_REASON = "cancellation_reason"
    /*Card Params*/
    static let  CARD_EXPIRY_DATE = "card_expiry_date"
    static let CARD_HOLDER_NAME = "card_holder_name"
    /**Documents*/
    static let DOCUMENT_ID = "document_id"
    static let UNIQUE_CODE = "unique_code"
    static let EXPIRED_DATE = "expired_date"
    /*history PARAMS*/
    static let  HISTORY_DETAIL = "history_detail"
    static let  START_DATE = "start_date"
    static let  END_DATE = "end_date"
    /*Feedback Params*/
    static let  USER_RATING_TO_STORE =  "user_rating_to_store"
    static let  USER_RATING_TO_PROVIDER =  "user_rating_to_provider"
    static let  USER_REVIEW_TO_PROVIDER =  "user_review_to_provider"
    static let  USER_REVIEW_TO_STORE =  "user_review_to_store"
    static let PAYMENT_METHOD = "payment_method"
    static let PAYMENT_INTENT_ID = "payment_intent_id"
    static let AMOUNT = "amount"
    static let IS_ALLOW_CONTACTLESS_DELIVERY = "is_allow_contactless_delivery"
    static let COUNTRY_NAME="country_name"
    static let CURRENCY="currency"
    static let PAGE = "page";
    static let PER_PAGE = "per_page";
    static let PROMO_ID = "promo_id";
    static let IS_USE_ITEM_TAX = "is_use_item_tax";
    static let IS_TAX_INCLUDED = "is_tax_included";
    static let TOTAL_CART_AMOUNT_WITHOUT_TAX = "total_cart_amout_without_tax";
    static let TAX_DETAILS = "tax_details";
    static let PAYMENT_GATEWAY_ID="payment_gateway_id"
    static let BOOKING_TYPE = "booking_type";
    static let NO_OF_PERSONS = "no_of_persons";
    static let TABLE_NO = "table_no";
    static let BOOKING_FEES = "booking_fees";
    static let TABLE_ID = "table_id";
    static let IS_BRING_CHANGE = "is_bring_change";
    static let ADDRESS_ID = "address_id";
    static let user_page_type = "user_page_type"
    static let call_to_usertype = "call_to_usertype"
    static let is_round_trip =  "is_round_trip"
    static let no_of_stop =  "no_of_stop"
}

struct CONSTANT {
    static let MANUAL = "manual"
    static let SOCIAL = "social"
    static let IOS = "ios"
    static let SMS_VERIFICATION_ON = 1
    static let EMAIL_VERIFICATION_ON = 2
    static let SMS_AND_EMAIL_VERIFICATION_ON = 3
    static let DELIVERY_LIST = "delivery_list"
    static let SELECTED_STORE="selected_store"
    static let DELIVERY_STORE="delivery_store"
    static let TYPE_USER = 7
    static let TYPE_PROVIDER = 8
    static let TYPE_STORE = 2
    static let ERROR_MINMUM_INVOICE_AMOUNT = 557
    static var STRIPE_KEY = ""
    static let UPDATE_URL = "https://itunes.apple.com/us/app/id1276529954?ls=1&mt=8"
    static var CHAT_USER_TYPE = 2
    static var STORE_PER_PAGE = 10
    static var CURRENT_PAGE = 1
    
    struct TWITTER {
        static let CONSUMER_KEY = "5taIh2BFeWd7WaZTMmJ9jKUVw"
        static let SECRET_KEY = "A7OsDDUfhzDApOURe7cFUm1kfl3do4mvJBBxRzJoWhFYa04dbw"
    }
    
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
        static let ADMIN_AND_USER = 12
        static let USER_AND_PROVIDER = 23
        static let USER_AND_STORE = 24
    }
    
}
struct Google {
    static let  GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let  AUTO_COMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    static let DIRECTION_URL = "https://maps.googleapis.com/maps/api/directions/json?origin="

    static var API_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"
    static var MAP_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"

    static var CLIENT_ID = "966521710311-aqlo8stjnv8umv36cvars1809knou758.apps.googleusercontent.com"
    /*Google Parameters*/
    static let  OK = "OK"
    static let  STATUS = "status"
    static let  RESULTS = "results"
    static let  GEOMETRY = "geometry"
    static let  LOCATION = "location"
    static let  ADDRESS_COMPONENTS = "address_components"
    static let  LONG_NAME = "long_name"
    static let  ADMINISTRATIVE_AREA_LEVEL_2 = "administrative_area_level_2"
    static let  ADMINISTRATIVE_AREA_LEVEL_1 = "administrative_area_level_1"
    static let  COUNTRY = "country"
    static let  COUNTRY_CODE = "country_code"
    static let  SHORT_NAME = "short_name"
    static let  TYPES = "types"
    static let  LOCALITY = "locality"
    static let  PREDICTIONS = "predictions"
    static let  LAT = "lat"
    static let  LNG = "lng"
    static let  NAME = "name"
    static let  DESTINATION_ADDRESSES = "destination_addresses"
    static let  ORIGIN_ADDRESSES = "origin_addresses"
    static let  ROWS = "rows"
    static let  ELEMENTS = "elements"
    static let  DISTANCE = "distance"
    static let  VALUE = "value"
    static let  DURATION = "duration"
    static let  TEXT = "text"
    static let  ROUTES = "routes"
    static let  LEGS = "legs"
    static let  STEPS = "steps"
    static let  POLYLINE = "polyline"
    static let  POINTS = "points"
    static let  ORIGIN = "origin"
    static let  ORIGINS = "origins"
    static let  DESTINATION = "destination"
    static let  DESTINATIONS = "destinations"
    static let  DESCRIPTION = "description"
    static let  KEY = "key"
    static let  EMAIL = "email"
    static let  ID = "id"
    static let  PICTURE = "picture"
    static let  URL = "url"
    static let  DATA = "data"
    static let  RADIUS = "radius"
    static let  FIELDS = "fields"
    static let  ADDRESS = "address"
    static let  FORMATTED_ADDRESS = "formatted_address"
    static let  LAT_LNG = "latlng"
    static let  STRUCTURED_FORMATTING = "structured_formatting"
    static let  MAIN_TEXT = "main_text"
    static let  SECONDARY_TEXT = "secondary_text"
}
struct PROMO_CODE_TYPE {
    static let PERCENTAGE = 1
    static let ABS = 2
}

var IS_PROMOCODE_AVAILABLE: Bool = true

struct Payment {
    static let CASH = ""
    static let STRIPE = "586f7db95847c8704f537bd5"
    static let PAY_PAL = "586f7db95847c8704f537bd6"
    static let PAY_U_MONEY = "586f7db95847c8704f537bd"
    static let PAYSTACK = "613602def1d028b84bf85ae6"
}

struct VerificationParameter {
    static let SEND_PIN = "send_pin"
    static let SEND_OTP = "send_otp"
    static let SEND_PHONE = "send_phone"
    static let SEND_BIRTHDAY = "send_birthdate"
    static let SEND_ADDRESS = "send_address"
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
    case CUSTOMER_ARRIVED = 27
    case CANCELED_BY_USER = 101
    case STORE_CANCELLED =  104
    case STORE_CANCELLED_REQUEST =  105
    case STORE_REJECTED =  103
    case NO_DELIVERY_MAN_FOUND =  109
    case DELIVERY_MAN_REJECTED =  111
    case DELIVERY_MAN_CANCELLED =  112
    case Unknown

    func text(cellItem:Order) -> String {
        switch self {
        case .WAITING_FOR_ACCEPT_STORE :
            if cellItem.order_change !=  nil{
                if cellItem.order_change!{
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
        case .ORDER_READY, .WAITING_FOR_DELIVERY_MAN, .NO_DELIVERY_MAN_FOUND,/*.STORE_CANCELLED_REQUEST,*/ .DELIVERY_MAN_CANCELLED : return "MSG_ORDER_READY".localized
        case .STORE_CANCELLED_REQUEST:
            return "MSG_STORE_CANCELLED".localized
            
        case .DELIVERY_MAN_ACCEPTED,.DELIVERY_MAN_COMING,.DELIVERY_MAN_ARRIVED,.DELIVERY_MAN_PICKED_ORDER,.DELIVERY_MAN_REJECTED:return "MSG_DELIVERY_MAN_PICKED_ORDER".localized
            
        case .DELIVERY_MAN_STARTED_DELIVERY : return "MSG_DELIVERY_MAN_STARTED_DELIVERY".localized
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return "MSG_DELIVERY_MAN_ARRIVED_AT_DESTINATION".localized
        case .DELIVERY_MAN_COMPLETE_DELIVERY : return "MSG_DELIVERY_MAN_COMPLETE_DELIVERY".localized
        case .CUSTOMER_ARRIVED : return "txt_customer_arrived".localized
        default: return "Unknown"
        }
    }

    func toInt() -> Int {
        switch self {
        case .WAITING_FOR_ACCEPT_STORE : return 1
        case .STORE_ACCEPTED : return 3
        case .STORE_PREPARING_ORDER : return  5
        case .ORDER_READY : return 7
        case .WAITING_FOR_DELIVERY_MAN : return  9
        case .DELIVERY_MAN_ACCEPTED : return 11
        case .DELIVERY_MAN_COMING : return  13
        case .DELIVERY_MAN_ARRIVED : return 15
        case .DELIVERY_MAN_PICKED_ORDER : return  17
        case .DELIVERY_MAN_STARTED_DELIVERY : return  19
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return  21
        case .DELIVERY_MAN_COMPLETE_DELIVERY : return  25
        case .CUSTOMER_ARRIVED : return  27
        case .CANCELED_BY_USER : return 101
        case .STORE_CANCELLED : return  104
        case .STORE_CANCELLED_REQUEST : return  105
        case .STORE_REJECTED : return  103
        case .NO_DELIVERY_MAN_FOUND : return  109
        case .DELIVERY_MAN_REJECTED : return  111
        case .DELIVERY_MAN_CANCELLED : return  112
        case .Unknown:
            return  0
        }
    }

    func textColor(cellItem:Order) -> UIColor {
        switch self {
            
        case .WAITING_FOR_ACCEPT_STORE,.CANCELED_BY_USER, .WAITING_FOR_DELIVERY_MAN, .STORE_REJECTED,.STORE_CANCELLED_REQUEST, .STORE_CANCELLED,.NO_DELIVERY_MAN_FOUND:
            return UIColor.themeStatusString1
        case .STORE_ACCEPTED : return UIColor.themeStatusString2
        case .ORDER_READY,.DELIVERY_MAN_STARTED_DELIVERY:
            return UIColor.themeStatusString3
        case .STORE_PREPARING_ORDER,.DELIVERY_MAN_COMING,.DELIVERY_MAN_ARRIVED,.DELIVERY_MAN_COMPLETE_DELIVERY : return UIColor.themeStatusString4
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return UIColor.themeStatusString5
        default: return UIColor.themeColor
            
        }
    }
    func textStatus(cellItem:Order_list) -> String {
        switch self {
            
        case .WAITING_FOR_ACCEPT_STORE :
            if cellItem.order_change !=  nil{
                if cellItem.order_change!{
                    return "MSG_WAIT_FOR_CONFIRMATION".localized
                }else{
                    return "MSG_WAIT_FOR_ACCEPT_STORE".localized
                }
            }else{
                return "MSG_WAIT_FOR_ACCEPT_STORE".localized
                
            }
            
        case .CANCELED_BY_USER : return "MSG_CANCELED_BY_USER".localized
        case .STORE_ACCEPTED : return "MSG_STORE_ACCEPTED".localized
        case .STORE_REJECTED : return "MSG_STORE_REJECTED".localized
        case .STORE_CANCELLED: return "MSG_STORE_CANCELLED".localized
        case .STORE_PREPARING_ORDER : return "MSG_STORE_PREPARING_ORDER".localized
        case .ORDER_READY, .WAITING_FOR_DELIVERY_MAN, .NO_DELIVERY_MAN_FOUND,/*.STORE_CANCELLED_REQUEST,*/ .DELIVERY_MAN_CANCELLED : return "MSG_ORDER_READY".localized
        case .STORE_CANCELLED_REQUEST:
            return "MSG_STORE_CANCELLED".localized
        case .DELIVERY_MAN_ACCEPTED,.DELIVERY_MAN_COMING,.DELIVERY_MAN_ARRIVED,.DELIVERY_MAN_PICKED_ORDER,.DELIVERY_MAN_REJECTED:return "MSG_DELIVERY_MAN_PICKED_ORDER".localized
            
        case .DELIVERY_MAN_STARTED_DELIVERY : return "MSG_DELIVERY_MAN_STARTED_DELIVERY".localized
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return "MSG_DELIVERY_MAN_ARRIVED_AT_DESTINATION".localized
        case .DELIVERY_MAN_COMPLETE_DELIVERY : return "MSG_DELIVERY_MAN_COMPLETE_DELIVERY".localized
        default: return "Unknown"
        }
    }

    func textColor(cellItem:Order_list) -> UIColor {
        switch self {
        case .WAITING_FOR_ACCEPT_STORE,.CANCELED_BY_USER,.DELIVERY_MAN_STARTED_DELIVERY, .WAITING_FOR_DELIVERY_MAN, .STORE_REJECTED,.STORE_CANCELLED_REQUEST, .STORE_CANCELLED,.NO_DELIVERY_MAN_FOUND:
            return UIColor.themeStatusString1
        case .STORE_ACCEPTED : return UIColor.themeStatusString2
        case .STORE_PREPARING_ORDER,.DELIVERY_MAN_COMING,.DELIVERY_MAN_ARRIVED,.DELIVERY_MAN_COMPLETE_DELIVERY : return UIColor.themeStatusString4
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return UIColor.themeStatusString5
        default: return UIColor.themeColor
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
            
        case .SUN : return "SUN".localizedCapitalized
        case .MON : return "MON".localizedCapitalized
        case .TUE : return "TUE".localizedCapitalized
        case .WED : return "WED".localizedCapitalized
        case .THU: return "THU".localizedCapitalized
        case .FRI : return "FRI".localizedCapitalized
        case .SAT : return "SAT".localizedCapitalized
        }
    }
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
        case .ADDED_BY_ADMIN : return "WALLET_STATUS_ADDED_BY_ADMIN".localizedUppercase
        case .ADDED_BY_CARD : return "WALLET_STATUS_ADDED_BY_CARD".localizedUppercase
        case .ADDED_BY_REFERRAL : return "WALLET_STATUS_ADDED_BY_REFERRAL".localizedUppercase
        case .ORDER_CHARGED : return "WALLET_STATUS_ORDER_CHARGED".localizedUppercase
        case .ORDER_REFUND : return "WALLET_STATUS_ORDER_REFUND".localizedUppercase
        case .ORDER_PROFIT : return "WALLET_STATUS_ORDER_PROFIT".localizedUppercase
        case .ORDER_CANCELLATION_CHARGE : return"WALLET_STATUS_ORDER_CANCELLATION_CHARGE".localized
        case .WALLET_REQUEST_CHARGE : return "WALLET_STATUS_WALLET_REQUEST_CHARGE".localizedUppercase
        default: return "Unknown"
        }
    }
}

struct CoreDataEntityName {
    static let  MASS_NOTIFICATION = "MassNotifications"
    static let  ORDER_NOTIFICATION = "OrderNotifications"
    static let  ADDRESS_DATA = "AddressData"
    static let  DELIVERY_LOCATION = "DeliveryLocation"
    static let  APPLE_SIGNIN = "AppleSignInData"
}

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}
