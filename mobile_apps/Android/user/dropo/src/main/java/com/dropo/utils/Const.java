package com.dropo.utils;

public class Const {

    /***
     * Error Code
     */
    public static final int TAXES_DETAILS_CHANGED = 968;
    public static final int MINIMUM_ORDER_AMOUNT = 557;
    public static final int STORE_DELIVERY_RADIUS = 967;
    public static final int USER_CHAT_ID = 2;
    public static final String ADMIN_RECIVER_ID = "000000000000000000000000";
    public static final String RECEIVER_ID = "receiver_id";
    public static final int STORE_PER_PAGE = 10;
    public static final int RESENT_CODE_SECONDS = 60;

    /***
     * Google url
     */
    public static final String GOOGLE_API_URL = "https://maps.googleapis.com/maps/";

    /**
     * Default privacy and Privacy policy and terms & condition url
     */
    public static final String PRIVACY_URL = ServerConfig.USER_PANEL_URL + "legal/user-privacy-policy";
    public static final String TERMS_URL = ServerConfig.USER_PANEL_URL + "legal/user-terms-conditions";

    public static final String PRIVACY_POSTFIX_URL = "legal/user-privacy-policy";
    public static final String TERMS_POSTFIX_URL = "legal/user-terms-conditions";

    /**
     * Permission requestCode
     */
    public static final int PERMISSION_FOR_LOCATION = 2;
    public static final int PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE = 3;
    public static final int PERMISSION_FOR_CALL = 4;

    /**
     * App IntentId
     */
    public static final int HOME_ACTIVITY = 2;
    public static final int LOGIN_ACTIVITY = 4;
    public static final int ORDER_TRACK_ACTIVITY = 5;

    /**
     * App result
     */
    public static final int DELIVERY_LIST_CODE = 2;
    public static final int ACTION_SETTINGS = 4;
    public static final int LOGIN_REQUEST = 16;
    public static final int DOCUMENT_REQUEST = 17;
    public static final int FEEDBACK_REQUEST = 18;
    public static final int REQUEST_CHECK_SETTINGS = 32;
    public static final int REQUEST_CODE_COURIER_ADDRESS = 46;
    public static final int REQUEST_FAVOURITE_ADDRESS = 49;
    public static final int REQUEST_DELIVERY_LOCATION = 50;
    public static final int REQUEST_ADD_CARD = 33;
    public static final int REQUEST_PAYU = 334;

    /**
     * Timer Scheduled in Second for display ADS
     */
    public static final long ADS_SCHEDULED_SECONDS = 5;//seconds

    /**
     * App General
     */
    public static final String TITLE = "title";
    public static final String COURIER = "Courier";
    public static final String STORE_DETAIL = "STORE_DETAIL";
    public static final String TABLE_DETAIL = "TABLE_DETAIL";
    public static final String STORE_INDEX = "STORE_INDEX";
    public static final String IS_STORE_CAN_CREATE_GROUP = "is_store_can_create_group";
    public static final int SMS_VERIFICATION_ON = 1;
    public static final int EMAIL_VERIFICATION_ON = 2;
    public static final int SMS_AND_EMAIL_VERIFICATION_ON = 3;
    public static final String SELECTED_STORE = "selected_store";
    public static final String FILTER = "filter";
    public static final String PRODUCT_ITEM = "product_item";
    public static final String PRODUCT_DETAIL = "product_detail";
    public static final String IS_FROM_COMPLETE_ORDER = "is_from_complete_order";
    public static final String IS_FROM_CHECKOUT = "is_from_checkout";

    public static final int TYPE_SPECIFICATION_MULTIPLE = 2;
    public static final int TYPE_SPECIFICATION_SINGLE = 1;
    public static final String ERROR_CODE_PREFIX = "error_code_";
    public static final String MESSAGE_CODE_PREFIX = "message_code_";
    public static final String WELCOME_TITLE_PREFIX = "welcome_title_";
    public static final String WELCOME_SUB_TITLE_PREFIX = "welcome_sub_title_";
    public static final String PUSH_MESSAGE_PREFIX = "push_message_";
    public static final String HTTP_ERROR_CODE_PREFIX = "http_error_";
    public static final String STRING = "string";
    public static final String ANDROID = "android";
    public static final String MANUAL = "manual";
    public static final String SOCIAL = "social";
    public static final String DATE_TIME_FORMAT_WEB = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    public static final String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm";
    public static final String TIME_FORMAT = "HH:mm:ss";
    public static final String TIME_FORMAT_AM = "h:mm a";
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATE_FORMAT_2 = "MM-dd-yyyy";
    public static final String DATE_FORMAT_3 = "dd MMM yy";
    public static final String TIME_FORMAT_2 = "HH:mm";
    public static final String DATE_FORMAT_MONTH = "MMM yyyy";
    public static final String DATE_TIME_FORMAT_AM = "yyyy-MM-dd h:mm a";
    public static final String DAY = "d";
    public static final int INVALID_TOKEN = 999;
    public static final int USER_DATA_NOT_FOUND = 534;
    public static final String BUNDLE = "bundle";
    public static final String UPDATE_ITEM_INDEX = "update_item_index";
    public static final String UPDATE_ITEM_INDEX_SECTION = "update_item_index_section";
    public static final String REQUEST_CODE = "request_code";
    public static final String COLOR_STATUS_PREFIX = "color_status";

    public static class Params {
        public static final String FIRST_NAME = "first_name";
        public static final String LAST_NAME = "last_name";
        public static final String EMAIL = "email";
        public static final String PASS_WORD = "password";
        public static final String LOGIN_BY = "login_by";
        public static final String COUNTRY_PHONE_CODE = "country_phone_code";
        public static final String PHONE = "phone";
        public static final String OTP = "otp";
        public static final String ADDRESS = "address";
        public static final String ADDRESS_NAME = "address_name";
        public static final String ADDRESS_ID = "address_id";
        public static final String LANDMARK = "landmark";
        public static final String STREET = "street";
        public static final String FLAT_NO = "flat_no";
        public static final String DESTINATION_ADDRESSES = "destination_addresses";
        public static final String ZIP_CODE = "zipcode";
        public static final String COUNTRY_ID = "country_id";
        public static final String CITY_ID = "city_id";
        public static final String CITY = "city";
        public static final String STORE_DELIVERY_ID = "store_delivery_id";
        public static final String SERVER_TOKEN = "server_token";
        public static final String DEVICE_TOKEN = "device_token";
        public static final String DEVICE_TYPE = "device_type";
        public static final String IMAGE_URL = "image_url";
        public static final String TYPE = "type";
        public static final String USER_ID = "user_id";
        public static final String USERID = "userid";
        public static final String COUNTRY = "country";
        public static final String COUNTRY_CODE = "country_code";
        public static final String COUNTRY_CODE_2 = "country_code_2";
        public static final String CITY_CODE = "city_code";
        public static final String CITY1 = "city1"; // city
        public static final String CITY2 = "city2"; // subAdminArea
        public static final String CITY3 = "city3"; // adminArea
        public static final String LATITUDE = "latitude";
        public static final String LONGITUDE = "longitude";
        public static final String OLD_PASS_WORD = "old_password";
        public static final String NEW_PASS_WORD = "new_password";
        public static final String STORE_ID = "store_id";
        public static final String TOTAL_ITEM_COUNT = "total_item_count";
        public static final String TOTAL_DISTANCE = "total_distance";
        public static final String TOTAL_TIME = "total_time";
        public static final String TOTAL_CART_PRICE = "total_cart_price";
        public static final String IS_PAYMENT_MODE_CASH = "is_payment_mode_cash";
        public static final String TOTAL_SPECIFICATION_COUNT = "total_specification_count";
        public static final String WALLET = "wallet";
        public static final String CARD_ID = "card_id";
        public static final String PAYMENT_ID = "payment_id";
        public static final String LAST_FOUR = "last_four";
        public static final String CARD_TYPE = "card_type";
        public static final String IS_USE_WALLET = "is_use_wallet";
        public static final String ORDER_PAYMENT_ID = "order_payment_id";
        public static final String CART_ID = "cart_id";
        public static final String ORDER_ID = "order_id";
        public static final String ORDER = "order";
        public static final String ORDER_STATUS = "order_status";
        public static final String PUSH_DATA1 = "push_data1";
        public static final String PUSH_DATA2 = "push_data2";
        public static final String NEW_ORDER = "new_order";
        public static final String UNIQUE_CODE = "unique_code";
        public static final String CANCEL_REASON = "cancel_reason";
        public static final String ID = "id";
        public static final String DOCUMENT_ID = "document_id";
        public static final String EXPIRED_DATE = "expired_date";
        public static final String START_DATE = "start_date";
        public static final String END_DATE = "end_date";
        public static final String REFERRAL_CODE = "referral_code";
        public static final String SOCIAL_ID = "social_id";
        public static final String RATING = "rating";
        public static final String REVIEW = "review";
        public static final String PROVIDER_ID = "provider_id";
        public static final String IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
        public static final String IS_EMAIL_VERIFIED = "is_email_verified";
        public static final String APP_VERSION = "app_version";
        public static final String TOTAL_ITEM_PRICE = "total_item_price";
        public static final String TOTAL_SPECIFICATION_PRICE = "total_specification_price";
        public static final String PROMO_CODE_NAME = "promo_code_name";
        public static final String IS_USER_SHOW_INVOICE = "is_user_show_invoice";
        public static final String USER_RATING_TO_PROVIDER = "user_rating_to_provider";
        public static final String USER_REVIEW_TO_PROVIDER = "user_review_to_provider";
        public static final String USER_RATING_TO_STORE = "user_rating_to_store";
        public static final String USER_REVIEW_TO_STORE = "user_review_to_store";
        public static final String CART_UNIQUE_TOKEN = "cart_unique_token";
        public static final String NOTE_FOR_DELIVERYMAN = "note_for_deliveryman";
        public static final String IS_SCHEDULE_ORDER = "is_schedule_order";
        public static final String ORDER_START_AT = "order_start_at";
        public static final String ORDER_START_AT2 = "order_start_at2";
        public static final String IS_USER_PICK_UP_ORDER = "is_user_pick_up_order";
        public static final String REVIEW_ID = "review_id";
        public static final String IS_USER_CLICKED_LIKE_STORE_REVIEW = "is_user_clicked_like_store_review";
        public static final String IS_USER_CLICKED_DISLIKE_STORE_REVIEW = "is_user_clicked_dislike_store_review";
        public static final String ORDER_TYPE = "order_type";
        public static final String CARD_EXPIRY_DATE = "card_expiry_date";
        public static final String LOCATION = "Location";
        public static final String DELIVERY_TYPE = "delivery_type";
        public static final String VEHICLE_ID = "vehicle_id";
        public static final String PICKUP_ADDRESSES = "pickup_addresses";
        public static final String LANG = "lang";
        public static final String LANG_CODE = "lang_code";
        public static final String TOKEN = "token";
        public static final String GROUP_ID = "group_id";
        public static final String PRODUCT_IDS = "product_ids";
        public static final String ITEM_ID = "item_id";
        public static final String PAYMENT_METHOD = "payment_method";
        public static final String AMOUNT = "amount";
        public static final String PAYMENT_INTENT_ID = "payment_intent_id";
        public static final String NAME = "name";
        public static final String IS_ALLOW_CONTACT_LESS_DELIVERY = "is_allow_contactless_delivery";
        public static final String IS_ORDER_CHANGE = "is_order_change";
        public static final String TIP_AMOUNT = "tip_amount";
        public static final String CURRENCY = "currency";
        public static final String COUNTRY_NAME = "country_name";
        public static final String IS_SHOW_HISTORY = "isShowHistory";
        public static final String IS_STORE_RATING = "isStoreRating";
        public static final String PAGE = "page";
        public static final String PER_PAGE = "per_page";
        public static final String DELIVERY_ID = "delivery_id";
        public static final String PROMO_ID = "promo_id";
        public static final String TOTAL_CART_AMOUNT_WITHOUT_TAX = "total_cart_amout_without_tax";
        public static final String TAX_DETAILS = "tax_details";
        public static final String IS_TAX_INCLUDED = "is_tax_included";
        public static final String IS_USE_ITEM_TAX = "is_use_item_tax";
        public static final String MODEL = "model";
        public static final String OS_VERSION = "os_version";
        public static final String APP_CODE = "app_code";
        public static final String OS_ORIENTATION = "os_orientation";
        public static final String PAYMENT_GATEWAY_ID = "payment_gateway_id";
        public static final String AUTHORIZATION_URL = "authorization_url";
        public static final String REFERENCE = "reference";
        public static final String REQUIRED_PARAM = "required_param";
        public static final String PIN = "pin";
        public static final String BIRTHDAY = "birthday";
        public static final String PAYU_HTML = "payu_html";
        public static final String TABLE_NO = "table_no";
        public static final String NO_OF_PERSONS = "no_of_persons";
        public static final String BOOKING_TYPE = "booking_type";
        public static final String BOOKING_FEES = "booking_fees";
        public static final String TABLE_ID = "table_id";
        public static final String IS_BRING_CHANGE = "is_bring_change";
        public static final String CALL_TO_USERTYPE = "call_to_usertype";
        public static final String IS_ROUND_TRIP = "is_round_trip";
        public static final String NO_OF_STOP = "no_of_stop";
    }

    /**
     * all activity and fragment TAG for log
     */
    public static class Tag {
        public static final String HOME_FRAGMENT = "HOME_FRAGMENT";
        public static final String STORE_FRAGMENT = "STORE_FRAGMENT";
        public static final String REGISTER_FRAGMENT = "REGISTER_FRAGMENT";
        public static final String LOG_IN_FRAGMENT = "LOG_IN_FRAGMENT";
        public static final String SPLASH_SCREEN_ACTIVITY = "SPLASH_SCREEN_ACTIVITY";
        public static final String DELIVERY_LOCATION_ACTIVITY = "DELIVERY_LOCATION_ACTIVITY";
        public static final String USER_FRAGMENT = "USER_FRAGMENT";
        public static final String STORES_ACTIVITY = "STORES_ACTIVITY";
        public static final String PRODUCT_CATEGORY_ACTIVITY = "PRODUCT_CATEGORY_ACTIVITY";
        public static final String STORES_PRODUCT_ACTIVITY = "STORES_PRODUCT_ACTIVITY";
        public static final String PROFILE_ACTIVITY = "PROFILE_ACTIVITY";
        public static final String CHECKOUT_ACTIVITY = "CHECKOUT_ACTIVITY";
        public static final String CART_ACTIVITY = "CART_ACTIVITY";
        public static final String PAYMENT_ACTIVITY = "PAYMENT_ACTIVITY";
        public static final String PRODUCT_SPE_ACTIVITY = "PRODUCT_SPE_ACTIVITY";
        public static final String ORDER_TRACK_ACTIVITY = "ORDER_TRACK_ACTIVITY";
        public static final String CURRENT_ORDER_FRAGMENT = "CURRENT_ORDER_FRAGMENT";
        public static final String DOCUMENT_ACTIVITY = "DOCUMENT_ACTIVITY";
        public static final String PROVIDER_TRACK_ACTIVITY = "PROVIDER_TRACK_ACTIVITY";
        public static final String INVOICE_FRAGMENT = "INVOICE_FRAGMENT";
        public static final String FEEDBACK_FRAGMENT = "FEEDBACK_FRAGMENT";
        public static final String ORDER_DETAILS_FRAGMENT = "ORDER_DETAILS_FRAGMENT";
    }

    public static class OrderStatus {
        public static final int WAITING_FOR_ACCEPT_STORE = 1;
        public static final int STORE_ORDER_ACCEPTED = 3;
        public static final int STORE_ORDER_PREPARING = 5;
        public static final int STORE_ORDER_READY = 7;
        public static final int STORE_ORDER_REJECTED = 103;
        public static final int STORE_ORDER_CANCELLED = 104;
        public static final int STORE_CANCELLED_REQUEST = 105;
        public static final int WAITING_FOR_DELIVERY_MEN = 9;
        public static final int DELIVERY_MAN_ACCEPTED = 11;
        public static final int DELIVERY_MAN_COMING = 13;
        public static final int DELIVERY_MAN_ARRIVED = 15;
        public static final int DELIVERY_MAN_PICKED_ORDER = 17;
        public static final int DELIVERY_MAN_STARTED_DELIVERY = 19;
        public static final int DELIVERY_MAN_ARRIVED_AT_DESTINATION = 21;
        public static final int DELIVERY_MAN_COMPLETE_DELIVERY = 25;
        public static final int TABLE_BOOKING_ARRIVED = 27;
        public static final int DELIVERY_MAN_NOT_FOUND = 109;
        public static final int DELIVERY_MAN_REJECTED = 111;
        public static final int DELIVERY_MAN_CANCELLED = 112;
        public static final int ORDER_CANCELED_BY_USER = 101;
    }

    public static class Wallet {
        public static final int ADDED_BY_ADMIN = 1;
        public static final int ADDED_BY_CARD = 2;
        public static final int ADDED_BY_REFERRAL = 3;
        public static final int ORDER_CHARGED = 4;
        public static final int ORDER_REFUND = 5;
        public static final int ORDER_PROFIT = 6;
        public static final int ORDER_CANCELLATION_CHARGE = 7;
        public static final int WALLET_REQUEST_CHARGE = 8;

        public static final int WALLET_STATUS_CREATED = 1;
        public static final int WALLET_STATUS_ACCEPTED = 2;
        public static final int WALLET_STATUS_TRANSFERRED = 3;
        public static final int WALLET_STATUS_COMPLETED = 4;
        public static final int WALLET_STATUS_CANCELLED = 5;

        public static final int ADD_WALLET_AMOUNT = 1;
        public static final int ORDER_REFUND_AMOUNT = 3;
        public static final int ORDER_PROFIT_AMOUNT = 5;
        public static final int REMOVE_WALLET_AMOUNT = 2;
        public static final int ORDER_CHARGE_AMOUNT = 4;
        public static final int ORDER_CANCELLATION_CHARGE_AMOUNT = 6;
        public static final int REQUEST_CHARGE_AMOUNT = 8;
        public static final int ORDER_PROFIT_DEDUCT_AMOUNT = 10;
    }

    public static class Store {
        public static final int STORE_PRICE_ONE = 1;
        public static final int STORE_PRICE_TWO = 2;
        public static final int STORE_PRICE_THREE = 3;
        public static final int STORE_PRICE_FOUR = 4;

        public static final int STORE_TIME_20 = 20;
        public static final int STORE_TIME_60 = 60;
        public static final int STORE_TIME_120 = 120;

        public static final int STORE_DISTANCE_5 = 5;
        public static final int STORE_DISTANCE_15 = 15;
        public static final int STORE_DISTANCE_25 = 25;
    }

    public static class Payment {
        public static final String CASH = "0";
        public static final String STRIPE = "586f7db95847c8704f537bd5";
        public static final String PAY_PAL = "586f7db95847c8704f537bd6";
        public static final String PAY_U_MONEY = "586f7db95847c8704f537bd";
        public static final String PAYSTACK = "613602def1d028b84bf85ae6";
    }

    /**
     * App Receiver
     */
    public static class Action {
        public static final String NETWORK_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";
        public static final String ACTION_ORDER_STATUS = "edelivery" + ".ACTION_ORDER_STATUS";
        public static final String ACTION_ADMIN_DECLINE = "edelivery" + ".ACTION_ADMIN_DECLINE";
        public static final String ACTION_ADMIN_APPROVED = "edelivery" + ".ACTION_ADMIN_APPROVED";
        public static final String ACTION_LOGIN_AT_ANOTHER_DEVICE = "edelivery" + ".ACTION_LOGIN_AT_ANOTHER_DEVICE";
    }

    /**
     * Google params
     */
    public static class Google {
        public static final String OK = "OK";
        public static final String STATUS = "status";
        public static final String RESULTS = "results";
        public static final String GEOMETRY = "geometry";
        public static final String LOCATION = "location";
        public static final String ADDRESS_COMPONENTS = "address_components";
        public static final String LONG_NAME = "long_name";
        public static final String ADMINISTRATIVE_AREA_LEVEL_2 = "administrative_area_level_2";
        public static final String ADMINISTRATIVE_AREA_LEVEL_1 = "administrative_area_level_1";

        public static final String COUNTRY = "country";
        public static final String COUNTRY_CODE = "country_code";
        public static final String SHORT_NAME = "short_name";
        public static final String TYPES = "types";
        public static final String LOCALITY = "locality";
        public static final String LAT = "lat";
        public static final String LNG = "lng";
        public static final String DESTINATION_ADDRESSES = "destination_addresses";
        public static final String ORIGIN_ADDRESSES = "origin_addresses";
        public static final String ROWS = "rows";
        public static final String ELEMENTS = "elements";
        public static final String DISTANCE = "distance";
        public static final String VALUE = "value";
        public static final String DURATION = "duration";
        public static final String ORIGINS = "origins";
        public static final String DESTINATIONS = "destinations";
        public static final String KEY = "key";
        public static final String LAT_LNG = "latlng";
        public static final String ADDRESS = "address";
        public static final String FORMATTED_ADDRESS = "formatted_address";
        public static final int GOOGLE_SIGN_IN = 21;
        public static final String ORIGIN = "origin";
        public static final String DESTINATION = "destination";
        public static final String WAYPOINTS = "waypoints";
        public static final String OPTIMIZE = "optimize";
    }

    public static class Facebook {
        public static final String EMAIL = "email";
        public static final String PUBLIC_PROFILE = "public_profile";
    }

    public static class PayPal {
        public static final int REQUEST_CODE_ORDER_PAYMENT = 11;
        public static final int REQUEST_CODE_WALLET_PAYMENT = 22;
        public static final String MERCHANT_PRIVACY_POLICY = "https://www.elluminatiinc.com";
        public static final String MERCHANT_AGREEMENT = "https://www.elluminatiinc.com";
    }


    public static class Type {
        public static final int USER = 7;
        public static final int STORE = 2;
        public static final int PROVIDER = 8;
        public static final String DESTINATION = "destination";
        public static final String PICKUP = "pickup";
        public static final int PERCENTAGE = 1;
        public static final int ABSOLUTE = 0;
    }

    public static class DeliveryType {
        public static final int STORE = 1;
        public static final int COURIER = 2;
        public static final int TABLE_BOOKING = 3;
    }

    public static class ChatType {
        //admin = 1
        //user = 2
        //provider = 3
        //store = 4
        public static final int ADMIN_AND_USER = 12;
        public static final int ADMIN_AND_PROVIDER = 13;
        public static final int ADMIN_AND_STORE = 14;
        public static final int USER_AND_PROVIDER = 23;
        public static final int USER_AND_STORE = 24;
        public static final int PROVIDER_AND_STORE = 34;
    }

    public static class VerificationParam {
        public static final String SEND_PIN = "send_pin";
        public static final String SEND_OTP = "send_otp";
        public static final String SEND_PHONE = "send_phone";
        public static final String SEND_BIRTHDATE = "send_birthdate";
        public static final String SEND_ADDRESS = "send_address";
    }

    public static class TableBookingType {
        public static final int BOOK_AT_REST = 1;
        public static final int BOOK_WITH_ORDER = 2;
    }

    public static class Query {
        public static final String PAGE = "page";
        public static final String STORE_ID = "store_id";
        public static final String TABLE_ID = "table_id";
    }

    public static class Path {
        public static final String STORE = "store";
    }

    /**
     * Phone number default length
     */
    public static class PhoneNumber {
        public static final int MINIMUM_PHONE_NUMBER_LENGTH = 7;
        public static final int MAXIMUM_PHONE_NUMBER_LENGTH = 12;
    }

    public interface Size {
        int METER = 1;
        int CENTIMETER = 2;
    }

    public interface Weight {
        int KG = 1;
        int GRAM = 2;
    }
}