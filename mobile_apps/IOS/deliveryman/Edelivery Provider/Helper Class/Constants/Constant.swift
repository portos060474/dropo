//
//  Constant.swift
//
//  Created by Elluminati on 10/03/17.
//  Copyright © 2017 Elluminati. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import GoogleSignIn

let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let preferenceHelper = PreferenceHelper.preferenceHelper
let firebaseAuth = Auth.auth()
let RESEND_TIME = 60
let signInConfig = GIDConfiguration.init(clientID: Google.CLIENT_ID)

let passwordMinLength:Int = 6
let passwordMaxLength:Int = 20
let emailMinimumLength = 12
let emailMaximumLength = 64

//Don't Change this id even in installtion and clone
let bundleId = "com.elluminati.edelivery.provider"


//let arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),(language: "عربى", code: "ar"),(language: "Española", code: "es"),(language: "Française", code: "fr"),(language: "हिन्दी", code: "hi")]
let arrForLanguages:[(language:String,code:String)] = [(language: "English", code: "en"),
                                                        (language: "عربى", code: "ar"),
                                                        (language: "Española", code: "es"),
                                                        (language: "Française", code: "fr")]

struct DeliveryType {
    static var store = 1
    static var courier = 2
}

struct ProviderType {
    static var store = 2
    static var admin = 1
}

let isConsolePrint = true

public func printE(_ items: Any..., separator: String = "", terminator: String = "") {
    if isConsolePrint {
        //debugPrint(items.description)
        //debugPrint(items, separator, terminator)
        print(items, separator, terminator)
    }
}

enum AppMode: Int {
    case live = 0
    case staging = 1
    case developer = 2
    
    //When app submission time default Mode must be AppMode.Live
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

//MARK: - WEB SERVICES
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

    static let  WS_PROVIDER_LOGIN = "api/provider/login"
    static let  WS_CHECK_REFERRAL = "api/admin/check_referral"
    static let  UPDATE_DEVICE_TOKEN = "api/provider/update_device_token"
    static let  WS_GET_PROVIDER_INFO = "api/provider/get_detail"
    static let  WS_GET_REQUEST_COUNT = "api/provider/get_request_count"
    static let  WS_PROVIDER_REGISTER = "api/provider/register"
    static let  WS_GET_COUNTRY_LIST = "api/admin/get_country_list"
    static let  WS_GET_CITY_LIST = "api/admin/get_city_list"
    static let  WS_GET_SETTING_DETAIL = "api/admin/check_app_keys"
    static let  WS_GET_APP_KEYS = "api/admin/get_app_keys"
    static let  WS_OTP_VERIFICATION = "api/admin/otp_verification"
    static let  WS_GET_ACTIVE_ORDER = "api/provider/get_active_requests"
    static let  WS_GET_ORDER_STATUS = "api/provider/get_request_status"
    static let  WS_GET_ORDER = "api/provider/get_requests"
    static let  WS_CHANGE_STATUS = "api/provider/change_status"
    static let  WS_CHANGE_ORDER_STATUS = "api/provider/change_request_status"
    static let  WS_CANCEL_OR_REJECT_ORDER = "api/provider/provider_cancel_or_reject_request"
    static let  WS_PROVIDER_LOGOUT = "api/provider/logout"
    static let  WS_PROVIDER_UPDATE = "api/provider/update"
    static let  WS_GET_HISTORY = "api/provider/request_history"
    static let  WS_GET_HISTORY_DETAIL = "api/provider/request_history_detail"
    static let  WS_GET_DOCUMENT_LIST = "api/admin/get_document_list"
    static let  WS_UPLOAD_DOCUMENT = "api/admin/upload_document"
    static let  WS_COMPLETE_ORDER = "api/provider/complete_request"
    static let  WS_UPDATE_LOCATION = "api/provider/update_location"
    static let  WS_UPDATE_OTP_VERFICATION =  "api/provider/otp_verification"
    static let  WS_FORGET_PASSWORD = "api/admin/forgot_password";
    static let  WS_FORGET_PASSWORD_VERIFY = "api/admin/forgot_password_verify"
    static let  WS_NEW_PASSWORD = "api/admin/new_password"
    static let  WS_GET_DAILY_EARNING = "api/provider/daily_earning";
    static let  WS_GET_WEEKLY_EARNING = "api/provider/weekly_earning";
    static let WS_GET_CANCEL_REASON_LIST =  "api/provider/get_cancellation_reasons"
    //Web Services related to Invoice and rating
    static let WS_PROVIDER_RATE_TO_STORE = "api/provider/rating_to_store";
    static let WS_PROVIDER_RATE_TO_USER = "api/provider/rating_to_user";
    static let WS_GET_INVOICE = "api/provider/get_invoice";
    static let WS_SHOW_INVOICE = "api/provider/show_request_invoice";
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

    /*payment related web service*/
    static let  WS_ADD_CARD = "api/user/add_card"
    static let  WS_GET_CARD_LIST = "api/user/get_card_list"
    static let  WS_SELECT_CARD = "api/user/select_card"
    static let  WS_DELET_CARD =  "api/user/delete_card"
    static let  WS_ADD_WALLET_AMOUNT  = "api/user/add_wallet_amount"
    static let  WS_CHANGE_WALLET_STATUS  = "api/user/change_user_wallet_status"
    static let  WS_GET_PAYMENT_GATEWAYS  = "api/user/get_payment_gateway"

    /*Vehicle related web service*/
    static let WS_GET_VEHICLE_LIST = "api/provider/get_vehicle_list"
    static let WS_SELECT_VEHICLE = "api/provider/select_vehicle"
    static let WS_ADD_VEHICLE =  "api/provider/add_vehicle"
    static let WS_UPDATE_VEHICLE =  "api/provider/update_vehicle_detail"

    //New Stripe
    static let GET_STRIPE_ADD_CARD_INTENT = "api/user/get_stripe_add_card_intent"
    static let GET_STRIPE_PAYMENT_INTENT_WALLET = "api/user/get_stripe_payment_intent_wallet"
    static let SEND_PAYSTACK_REQUIRED_DETAIL = "/api/user/send_paystack_required_detail"
    
    static let WS_DELETE_ACCOUNT = "api/provider/delete_account"
    static let WS_TWILIO_VOICE_CALL_PROVIDER = "api/provider/twilio_voice_call_from_provider"

}

//MARK: - PARAMS
struct PARAMS {
    static let EMAIL: String = "email"
    static let PAYMENT_ID:String = "payment_id"
    static let IS_ACTIVE_FOR_JOB = "is_active_for_job"
    static let APP_VERSION: String = "app_version"
    static let PASSWORD: String = "password"
    static let LOGIN_BY: String = "login_by"
    static let DEVICE_TOKEN: String = "device_token"
    static let DEVICE_TYPE: String = "device_type"
    static let IMAGE_URL: String = "image_url"
    static let FIRST_NAME: String = "first_name"
    static let LAST_NAME: String = "last_name";
    static let COUNTRY_PHONE_CODE: String = "country_phone_code"
    static let PHONE: String = "phone"
    static let OTP: String = "otp"

    static let ADDRESS: String = "address"
    static let STATE = "state"
    static let COUNTRY_ID: String = "country_id"
    static let REFERRAL_CODE = "referral_code";
    static let CITY_ID: String = "city_id"
    static let COUNTRY: String = "country"
    static let COUNTRY_CODE: String = "country_code"
    static let SOCIAL_ID: String = "social_id"
    static let VEHICAL_MODEL: String = "vehicle_model"
    static let VEHICAL_NUMBER: String = "vehicle_number"
    static let SORT_BIO: String = "sort_bio"
    static let TYPE: String = "type"
    static let SERVER_TOKEN: String = "server_token"
    static let PASS_WORD = "password"
    static let PROVIDER_ID: String = "provider_id"
    static let ORDER_ID: String = "order_id"
    static let REQUEST_ID: String = "request_id"
    static let IS_ONLINE: String = "is_online"
    static let ORDER_STATUS: String = "order_status"
    static let DELIVERY_STATUS: String = "delivery_status"
    static let CANCEL_REASON: String = "cancel_reasons"
    static let OLD_PASSWORD: String = "old_password"
    static let NEW_PASSWORD: String = "new_password"
    static let ID: String = "id"
    static let USER_ID: String = "user_id"
    static let START_DATE: String = "start_date"
    static let END_DATE: String = "end_date"
    static let DOCUMENT_ID: String = "document_id"
    static let UNIQUE_CODE: String = "unique_code"
    static let EXPIRED_DATE: String = "expired_date"
    static let LATITUDE: String = "latitude"
    static let LONGITUDE: String = "longitude"
    static let BEARING: String = "bearing"
    static let RATING:String = "rating"
    static let REVIEW:String = "review"
    static let VEHICLE_NUMBER:String = "vehicle_number"
    static let VEHICLE_MODEL:String = "vehicle_model"
    static let IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified"
    static let IS_EMAIL_VERIFIED = "is_email_verified"
    static let HISTORY_DETAIL: String = "history_detail"
    /*Feedback Params*/
    static let  PROVIDER_RATING_TO_STORE  =  "provider_rating_to_store";
    static let  PROVIDER_RATING_TO_USER  =  "provider_rating_to_user";
    static let  IS_PROVIDER_SHOW_INVOICE = "is_provider_show_invoice";
    static let  PROVIDER_REVIEW_TO_USER  =  "provider_review_to_user";
    static let  PROVIDER_REVIEW_TO_STORE  =  "provider_review_to_store";
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
    static let ACCOUNT_HOLDER_NAME = "account_holder_name"
    static let GENDER = "gender"
    static let POSTAL_CODE = "postal_code"
    static let ACCOUNT_HOLDER_TYPE = "account_holder_type"
    static let REQUESTED_WALLET_AMOUNT = "requested_wallet_amount"
    static let DESCRIPTION_FOR_REQUESTED_WALLET_AMOUNT = "description_for_request_wallet_amount"
    static let TRANSACTION_DETAILS = "transaction_details"
    static let WALLET_STATUS = "wallet_status"
    static let IS_PAYMENT_MODE_CASH = "is_payment_mode_cash"
    /**Payment Card PARAMS*/
    static let LAST_FOUR = "last_four";
    static let PAYMENT_TOKEN = "payment_token";
    static let CARD_TYPE = "card_type";
    static let CARD_ID = "card_id";
    static let CARD_EXPIRY_DATE = "card_expiry_date";
    static let CARD_HOLDER_NAME = "card_holder_name";
    static let WALLET = "wallet";
    static let PAYMENT_GATEWAY_ID="payment_gateway_id"
    /*Vehicle Params*/
    static let VEHICLE_ID = "vehicle_id"
    static let VEHICLE_YEAR = "vehicle_year"
    static let VEHICLE_NAME = "vehicle_name"
    static let VEHICLE_PLATE_NO = "vehicle_plate_no"
    static let VEHICLE_COLOR = "vehicle_color"
    static let USER_TYPE_ID = "user_type_id"

    static let PAYMENT_METHOD = "payment_method"
    static let PAYMENT_INTENT_ID = "payment_intent_id"
    static let AMOUNT = "amount"
    static let REQUIRED_PARAM = "required_param"
    static let REFERENCE = "reference"
    static let PIN = "pin"
    static let BIRTHDAY = "birthday"
    static let provider_page_type = "provider_page_type"
    
    static let call_to_usertype = "call_to_usertype"
}

struct VerificationParameter {
    static let SEND_PIN = "send_pin"
    static let SEND_OTP = "send_otp"
    static let SEND_PHONE = "send_phone"
    static let SEND_BIRTHDAY = "send_birthdate"
    static let SEND_ADDRESS = "send_address"
}

//MARK: - CONSTANT VALUE
struct CONSTANT {
    static let UPDATE_URL = "https://itunes.apple.com/us/app/id1276556193?ls=1&mt=8"
    static let IOS: String = "ios"
    static let MANUAL = "manual"
    static let SOCIAL = "social"
    static var STRIPE_KEY = "";
    static let TYPE_USER: String = "7"
    static let TYPE_STORE: String = "2"
    static let TYPE_PROVIDER: String = "8"
    static let TYPE_PROVIDER_VEHICLE: String = "9"
    static let STATUS: String = "status"
    static let INVOICE_DATA: String = "invoice_data"
    static let SMS_VERIFICATION_ON = 1
    static let EMAIL_VERIFICATION_ON = 2
    static let SMS_AND_EMAIL_VERIFICATION_ON = 3
    static var CHAT_DELIVERYMAN_TYPE = 3

    struct TWITTER {
        static let CONSUMER_KEY = "lkmacDM1kam5PTMD0J2OaKztv";
        static let SECRET_KEY = "gE8gIy5aSQnHmp5BKAPfLNOYKIyQ9n4MdRuyyKp1osL8jlOB2O";
    }

    struct PREFIX {
        static let ST: String = "st"
        static let ND: String = "nd"
        static let RD: String = "rd"
        static let TH: String = "th"
    }

    struct DBPROVIDER {
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
        static let ADMIN_AND_PROVIDER = 13;
        static let USER_AND_PROVIDER = 23;
        static let PROVIDER_AND_STORE = 34;
    }
}

//MARK: - DATE CONST
struct DATE_CONSTANT {
    static let TIME_FORMAT_AM_PM = "hh:mm a"
    static let DATE_TIME_FORMAT_WEB   = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let DATE_TIME_FORMAT = "dd MMMM yyyy, HH:mm"
    static let TIME_FORMAT = "HH:mm"
    static let DATE_FORMAT = "yyyy-MM-dd"
    static let DATE_FORMAT_MONTH = "MMMM yyyy"
    static let DATE_MM_DD_YYYY = "MM/dd/yyyy"
    static let TIME_FORMAT_HH_MM = "HH:mm"
    static let WEEK_FORMAT = "EEE, dd MMMM"
    static let DD_MM_YY = "dd MM yy"
    static let DD_MMM_YY = "dd MMM yy"
    static let DD_MM_YYYY = "dd-MM-yyyy"
    static let DATE_FORMAT_ORDER_STATUS = "MMM dd"
    static let MESSAGE_FORMAT = "yyyy-MM-dd, hh:mm a"
    static let MM_DD_YYY = "MM-dd-yyyy"
    static let DAY_MMM_YYYY_MONTH = "dd MMM yyyy"
    static let DATE_TIME_FORMAT_AM_PM = "yyyy-MM-dd hh:mm a"
    static let NEW_ORDER_DATE_FORMAT = "d MMMM yyyy"
    static let DATE_TIME_AM_PM_FORMAT = "d MMMM yyyy, hh:mm a"
}

//MARK: - SEGUE IDENTIFIER
struct SEGUE {
    static let LOGIN_TO_HOME = "segueToHome"
    static let HOME_TO_AVAIL_DELIVERIES = "segueToAvailDeliveries"
    static let ACTIVEDELIVERIES_TO_DETAIL = "segueActiveDeliveriesToDetail"
    static let TRIP_TO_INVOICE = "segueTripToInvoice"

    static let USER_TO_PROFILE = "segueUserToProfile"
    static let USER_TO_DOCUMENT = "segueUserToDocument"
    static let HISTORY_TO_DETAIL = "segueHistoryToDetail"
    static let HISTORY_DETAIL_TO_INVOICE = "segueHistoryDetailToInvoice"
    static let HOME_TO_LOGIN = "segueHomeToLogin"
    static let HOME_TO_REGISTER = "segueHomeToRegister"
    static let HOME_TO_DOCUMENT = "segueHomeToDocument"
    static let EARNING_TO_WEEKLY = "segueEarnToWeek"
    static let EARNING_TO_DAILY = "segueEarnToDaily"
    static let EARNING_TO_MONTHLY = "segueEarnToMonthly"
    static let HOME_TO_EARNING = "segueHomeToEarning"
    static let HISTORY_DETAIL_TO_FEEDBACK = "segueHistoryToFeedback"
    static let ACTIVE_ORDER_TO_INVOICE = "segueActiveOrderToInvoice"
    static let USER_TO_SHARE = "segueUserToShare"
    static let USER_TO_SETTING = "segueUserToSetting"
    static let USER_TO_MANAGE_VEHICLE = "segueDrawerToManageVehicle"
    static let USER_TO_BANK_DETAIL = "segueUserToBankDetails"
    static let PAYMENT_TO_BANK_DETAIL = "segueToBankDetail"
    static let USER_TO_WALLET_PAYMENT = "segueToWalletPayment"
    static let BANKLIST_TO_BANK_DETAIL = "segueToBankDetail"
    static let SELECT_WITHDRAW_METHOD = "segueToSelectWithDrawalMethod"
    static let HISTORY_TO_TRANSACTION_HISTORY = "segueToTransactionHistory"
    static let HISTORY_TO_WALLET_HISTORY = "segueToWalletHistory"
    static let HELP =   "segueToHelp"
    static let WALLET_TO_HISTORY = "segueToHistoryVC"
    static let WALLET_HISTORY_TO_WALLET_HISTORY_DETAIL = "segueToWalletHistoryDetail"
    static let TRANSACTION_HISTORY_TO_TRANSACTION_HISTORY_DETAIL = "segueToWalletTransactionDetail"
    static let VEHICLE_LIST_TO_VEHICLE_DETAIL = "segueFromVehiclelistToVehicleDetail"
    static let HOME_TO_MANAGE_VEHICLE = "segueToManageVehicle"
    static let SEGUE_TO_MASS_NOTIFICATIONS = "segueToMassNoti"
    static let SEGUE_TO_ORDER_NOTIFICATIONS = "segueToOrderNoti"
    static let PAYMENT_TO_PAYSTACK_WEBVIEW = "seguePaymentToPaystackWebview"
    static let HOME_TO_HISTORY = "segueHomeToHistory"
}

//MARK: - EMBEDED IDENTIFIER
struct EMBEDED {
    static let LOGIN = "embedeLogin"
    static let REGISTER = "embedeRegister"
    static let ACTIVE_ORDER = "embededForActiveOrder"
    static let PENDING_ORDER = "embedeForPendingOrder"
}

//MARK: - STORYBOARD NAME & ID
struct STORYBOARD {
    struct NAME {
        static let MAIN: String = "Main"
    }

    struct ID {
        static let HOMEVC: String = "home"
        static let MAINVC: String = "mainvc"
    }
}

//MARK: - Google Parameters
struct Google {
    static let  GEOCODE_URL = "https://maps.googleapis.com/maps/api/geocode/json?"
    static let  AUTO_COMPLETE_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
    static var API_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"
    static var MAP_KEY = "AIzaSyALeyDRLUHt6lI8hXBJdDeWElD11SxYqG8"

    static var CLIENT_ID = "966521710311-4g7r176t95q2bl3ag0kcdc3kjnpfd6ar.apps.googleusercontent.com"
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
}

enum WalletRequestStatus:Int {
    case CREATED = 1
    case ACCEPTED = 2
    case TRANSFERED = 3
    case COMPLETED = 4
    case CANCELLED = 5
    case Unknown

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

enum WalletHistoryStatus:Int {
    case ADDED_BY_ADMIN = 1
    case ADDED_BY_CARD = 2
    case ADDED_BY_REFERRAL = 3
    case ORDER_CHARGED = 4
    case ORDER_REFUND = 5
    case ORDER_PROFIT = 6
    case ORDER_CANCELLATION_CHARGE = 7
    case WALLET_REQUEST_CHARGE = 8
    case ORDER_PROFIT_DEDUCT_AMOUNT = 10
    case Unknown

    func text() -> String {
        switch self {
        case .ADDED_BY_ADMIN : return "WALLET_STATUS_ADDED_BY_ADMIN".localized
        case .ADDED_BY_CARD : return "WALLET_STATUS_ADDED_BY_CARD".localized
        case .ADDED_BY_REFERRAL : return "WALLET_STATUS_ADDED_BY_REFERRAL".localized
        case .ORDER_CHARGED : return "WALLET_STATUS_ORDER_CHARGED".localized
        case .ORDER_REFUND : return "WALLET_STATUS_ORDER_REFUND".localized
        case .ORDER_PROFIT : return "WALLET_STATUS_ORDER_PROFIT".localized
        case .ORDER_CANCELLATION_CHARGE : return "WALLET_STATUS_ORDER_CANCELLATION_CHARGE".localized
        case .WALLET_REQUEST_CHARGE : return "WALLET_STATUS_WALLET_REQUEST_CHARGE".localized
        case .ORDER_PROFIT_DEDUCT_AMOUNT : return "WALLET_STATUS_ORDER_PROFIT_DEDUCTED".localized
        default: return "Unknown"
        }
    }
};

enum OrderStatus: Int {
    case NEW_DELIVERY = 9
    case DELIVERY_MAN_ACCEPTED = 11
    case DELIVERY_MAN_COMING = 13
    case DELIVERY_MAN_ARRIVED = 15
    case DELIVERY_MAN_PICKED_ORDER = 17
    case DELIVERY_MAN_STARTED_DELIVERY = 19
    case DELIVERY_MAN_ARRIVED_AT_DESTINATION = 21
    case DELIVERY_MAN_COMPLETE_DELIVERY = 25
    case DELIVERY_MAN_COMPLETE_DELIVERY_2 = 23
    case DELIVERY_MAN_REJECTED = 111
    case DELIVERY_MAN_CANCELLED = 112
    case CANCELED_BY_USER = 101
    case STORE_CANCELLED =  104
    case NO_DELIVERY_MAN_FOUND =  105
    case ORDER_READY =  7
    case STORE_ACCEPTED = 3
    case STORE_CANCELLED_REQUEST =  109
    case Unknown

    func text() -> String {
        switch self {
        case .NEW_DELIVERY : return "MSG_NEW_DELIVERY".localized
        case .DELIVERY_MAN_ACCEPTED : return "MSG_DELIVERY_MAN_ACCEPTED".localized
        case .DELIVERY_MAN_COMING : return "MSG_DELIVERY_MAN_COMING".localized
        case .DELIVERY_MAN_ARRIVED : return "MSG_DELIVERY_MAN_ARRIVED".localized
        case .DELIVERY_MAN_PICKED_ORDER : return "MSG_DELIVERY_MAN_PICKED_ORDER".localized
        case .DELIVERY_MAN_STARTED_DELIVERY : return "MSG_DELIVERY_MAN_STARTED_DELIVERY".localized
        case .DELIVERY_MAN_ARRIVED_AT_DESTINATION : return "MSG_DELIVERY_MAN_ARRIVED_AT_DESTINATION".localized
        case .DELIVERY_MAN_COMPLETE_DELIVERY : return "MSG_DELIVERY_MAN_COMPLETE_DELIVERY".localized
        case .DELIVERY_MAN_REJECTED : return "MSG_DELIVERY_MAN_REJECTED".localized
        case .DELIVERY_MAN_CANCELLED : return "MSG_DELIVERY_MAN_CANCELLED".localized
        case .CANCELED_BY_USER : return "MSG_USER_CANCELLED".localized
        case .STORE_CANCELLED : return "MSG_STORE_CANCELLED".localized
        case .STORE_CANCELLED_REQUEST,.NO_DELIVERY_MAN_FOUND : return "MSG_STORE_CANCELLED".localized
        default: return "Unknown"
        }
    }
}

struct Payment {
    static let CASH = "0";
    static let STRIPE = "586f7db95847c8704f537bd5";
    static let PAY_PAL = "586f7db95847c8704f537bd6";
    static let PAY_U_MONEY = "586f7db95847c8704f537bd";
    static let PAYSTACK = "613602def1d028b84bf85ae6";
}

struct CoreDataEntityName {
    static let  MASS_NOTIFICATION = "MassNotifications"
    static let  ORDER_NOTIFICATION = "OrderNotifications"
}
