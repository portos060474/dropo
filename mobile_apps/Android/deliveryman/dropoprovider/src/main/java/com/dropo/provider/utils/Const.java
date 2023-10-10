package com.dropo.provider.utils;

public class Const {

    /***
     * Google url
     */
    public static final String GOOGLE_API_URL = "https://maps.googleapis.com/maps/";
    public static final String FCM_SERVER_KEY = "AAAA90qRmJQ:APA91bGlaCY-Jz9MD-1IxBlN1opfH8yHgfJHr-Um0aZsFT6GkjFo6Vk-ilDEvAkwOODvaS18qt77ctKhqbytioWyJMGWvX6YxyBChuUhceNYVvOUE1lIwA3ZV9xGgEHQ_66cQJZojWLU";
    /**
     * Timer Scheduled in Second
     */
    public static final long LOCATION_SCHEDULED_SECONDS = 15;//seconds
    public static final long AVAILABLE_DELIVER_SCHEDULED_SECONDS = 10;//seconds
    public static final int RESENT_CODE_SECONDS = 60; //seconds
    /**
     * Default privacy and Privacy policy and terms & condition url
     */

    public static final String PRIVACY_URL = ServerConfig.USER_PANEL_URL + "legal/provider-privacy-policy";
    public static final String TERMS_URL = ServerConfig.USER_PANEL_URL + "legal/provider-terms-conditions";

    public static final String PRIVACY_POSTFIX_URL = "legal/provider-privacy-policy";
    public static final String TERMS_POSTFIX_URL = "legal/provider-terms-conditions";
    /**
     * Permission requestCode
     */
    public static final int PERMISSION_FOR_LOCATION = 2;
    public static final int PERMISSION_FOR_CAMERA_AND_EXTERNAL_STORAGE = 3;
    public static final int REQUEST_CHECK_SETTINGS = 32;
    public static final int REQUEST_UPDATE_BANK_DETAIL = 34;
    public static final int ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 36;
    public static final int REQUEST_ADD_CARD = 33;
    public static final int REQUEST_PAYU = 334;
    /**
     * App intentId
     */
    public static final int LOGIN_ACTIVITY = 4;
    public static final int HOME_ACTIVITY = 5;
    public static final int GOOGLE_SIGN_IN = 21;
    /**
     * App result
     */
    public static final int ACTION_SETTINGS = 4;
    /**
     * AppGeneral
     */
    public static final String COURIER = "Courier";
    public static final int FOREGROUND_NOTIFICATION_ID = 2568;
    public static final String BUNDLE = "BUNDLE";
    public static final String BACK_TO_ACTIVE_DELIVERY = "BACK_TO_ACTIVE_DELIVERY";
    public static final String GO_TO_INVOICE = "GO_TO_INVOICE";
    public static final String ORDER_PAYMENT = "ORDER_PAYMENT";
    public static final String PAYMENT = "PAYMENT";
    public static final String USER_DETAIL = "USER_DETAIL";
    public static final String STORE_DETAIL = "STORE_DETAIL";
    public static final String APP_START = "APP_START";
    public static final int INVALID_TOKEN = 999;
    public static final int PROVIDER_DATA_NOT_FOUND = 424;
    public static final int SMS_VERIFICATION_ON = 1;
    public static final int EMAIL_VERIFICATION_ON = 2;
    public static final int SMS_AND_EMAIL_VERIFICATION_ON = 3;
    public static final int TYPE_PROVIDER = 8;
    public static final int TYPE_USER = 7;
    public static final int TYPE_STORE = 2;
    public static final int TYPE_PROVIDER_VEHICLE = 9;
    public static final String ERROR_CODE_PREFIX = "error_code_";
    public static final String MESSAGE_CODE_PREFIX = "message_code_";
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
    public static final String DATE_FORMAT_MONTH = "MMM yyyy";
    public static final String DAY = "d";
    public static final String DATE_FORMAT_3 = "dd MMM yy";
    public static final String DATE_FORMAT_2 = "MM-dd-yyyy";
    public static final String WEEK_DAY = "EEE, dd MMMM";
    public static final String DATE_TIME_FORMAT_AM = "yyyy-MM-dd h:mm a";

    public static final int PROVIDER_CHAT_ID = 3;
    public static final String TITLE = "title";
    public static final String ADMIN_RECIVER_ID = "000000000000000000000000";
    public static final String RECEIVER_ID = "receiver_id";
    public static final String COLOR_STATUS_PREFIX = "color_status";

    public interface Params {
        String FIRST_NAME = "first_name";
        String LAST_NAME = "last_name";
        String EMAIL = "email";
        String PASS_WORD = "password";
        String LOGIN_BY = "login_by";
        String COUNTRY_PHONE_CODE = "country_phone_code";
        String PHONE = "phone";
        String OTP = "otp";
        String ADDRESS = "address";
        String ZIP_CODE = "zipcode";
        String COUNTRY_ID = "country_id";
        String CITY_ID = "city_id";
        String DEVICE_TOKEN = "device_token";
        String DEVICE_TYPE = "device_type";
        String IMAGE_URL = "image_url";
        String TYPE = "type";
        String USER_TYPE_ID = "user_type_id";
        String SERVER_TOKEN = "server_token";
        String TOKEN = "token";
        String USER_ID = "user_id";
        String PROVIDER_ID = "provider_id";
        String PROVIDERID = "providerid";
        String IS_ONLINE = "is_online";
        String OLD_PASS_WORD = "old_password";
        String NEW_PASS_WORD = "new_password";
        String BEARING = "bearing";
        String LATITUDE = "latitude";
        String LONGITUDE = "longitude";
        String ORDER_ID = "order_id";
        String UNIQUE_CODE = "unique_code";
        String PUSH_DATA1 = "push_data1";
        String PUSH_DATA2 = "push_data2";
        String NEW_ORDER = "new_order";
        String ID = "id";
        String DOCUMENT_ID = "document_id";
        String EXPIRED_DATE = "expired_date";
        String START_DATE = "start_date";
        String END_DATE = "end_date";
        String CANCEL_REASONS = "cancel_reasons";
        String IS_ACTIVE_FOR_JOB = "is_active_for_job";
        String IS_PHONE_NUMBER_VERIFIED = "is_phone_number_verified";
        String IS_EMAIL_VERIFIED = "is_email_verified";
        String APP_VERSION = "app_version";
        String IS_PROVIDER_SHOW_INVOICE = "is_provider_show_invoice";
        String PROVIDER_RATING_TO_USER = "provider_rating_to_user";
        String PROVIDER_REVIEW_TO_USER = "provider_review_to_user";
        String PROVIDER_RATING_TO_STORE = "provider_rating_to_store";
        String PROVIDER_REVIEW_TO_STORE = "provider_review_to_store";
        String REFERRAL_CODE = "referral_code";
        String SOCIAL_ID = "social_id";
        String WALLET_STATUS = "wallet_status ";
        String CARD_ID = "card_id";
        String PAYMENT_ID = "payment_id";
        String LAST_FOUR = "last_four";
        String CARD_TYPE = "card_type";
        String WALLET = "wallet";
        String VEHICLE_ID = "vehicle_id";
        String DELIVERY_STATUS = "delivery_status";
        String REQUEST_ID = "request_id";
        String PAYMENT_METHOD = "payment_method";
        String AMOUNT = "amount";
        String PAYMENT_INTENT_ID = "payment_intent_id";
        String NAME = "name";
        String LANG = "lang";
        String LANG_CODE = "lang_code";
        String BANK_ACCOUNT_NUMBER = "account_number";
        String ACCOUNT_HOLDER_NAME = "account_holder_name";
        String BANK_ACCOUNT_HOLDER_NAME = "bank_account_holder_name";
        String BANK_PERSONAL_ID_NUMBER = "personal_id_number";
        String DOB = "dob";
        String BANK_ROUTING_NUMBER = "routing_number";
        String BANK_ACCOUNT_HOLDER_TYPE = "account_holder_type";
        String BANK_HOLDER_TYPE = "bank_holder_type";
        String POSTAL_CODE = "postal_code";
        String GENDER = "gender";
        String BUSINESS_NAME = "business_name";
        String BANK_HOLDER_ID = "bank_holder_id";
        String MODEL = "model";
        String OS_VERSION = "os_version";
        String APP_CODE = "app_code";
        String OS_ORIENTATION = "os_orientation";
        String PAYMENT_GATEWAY_ID = "payment_gateway_id";
        String AUTHORIZATION_URL = "authorization_url";
        String REFERENCE = "reference";
        String REQUIRED_PARAM = "required_param";
        String PIN = "pin";
        String BIRTHDAY = "birthday";
        String PAYU_HTML = "payu_html";
        String IS_BRING_CHANGE = "is_bring_change";
        String CALL_TO_USERTYPE = "call_to_usertype";
        String DELIVERY_TYPE = "delivery_type";
    }

    /**
     * all activity and fragment TAG for log
     */
    public interface Tag {
        String HOME_FRAGMENT = "HOME_FRAGMENT";
        String USER_FRAGMENT = "USER_FRAGMENT";
        String INVOICE_FRAGMENT = "INVOICE_FRAGMENT";
        String FEEDBACK_FRAGMENT = "FEEDBACK_FRAGMENT";
        String HISTORY_FRAGMENT = "HISTORY_FRAGMENT";
    }

    public interface ProviderStatus {
        int DELIVERY_MAN_NEW_DELIVERY = 9;
        int DELIVERY_MAN_ACCEPTED = 11;
        int DELIVERY_MAN_COMING = 13;
        int DELIVERY_MAN_ARRIVED = 15;
        int DELIVERY_MAN_PICKED_ORDER = 17;
        int DELIVERY_MAN_STARTED_DELIVERY = 19;
        int DELIVERY_MAN_ARRIVED_AT_DESTINATION = 21;
        int DELIVERY_MAN_COMPLETE_DELIVERY = 25;
        int DELIVERY_MAN_REJECTED = 111;
        int DELIVERY_MAN_CANCELLED = 112;
        int STORE_CANCELLED_REQUEST = 105;
    }

    public interface Wallet {
        int ADDED_BY_ADMIN = 1;
        int ADDED_BY_CARD = 2;
        int ADDED_BY_REFERRAL = 3;
        int ORDER_CHARGED = 4;
        int ORDER_REFUND = 5;
        int ORDER_PROFIT = 6;
        int ORDER_CANCELLATION_CHARGE = 7;
        int WALLET_REQUEST_CHARGE = 8;
        int WALLET_STATUS_CREATED = 1;
        int WALLET_STATUS_ACCEPTED = 2;
        int WALLET_STATUS_TRANSFERRED = 3;
        int WALLET_STATUS_COMPLETED = 4;
        int WALLET_STATUS_CANCELLED = 5;
        int ADD_WALLET_AMOUNT = 1;
        int REMOVE_WALLET_AMOUNT = 2;
    }

    public interface Payment {
        String CASH = "0";
        String STRIPE = "586f7db95847c8704f537bd5";
        String PAY_PAL = "586f7db95847c8704f537bd6";
        String PAY_U_MONEY = "586f7db95847c8704f537bd";
        String PAYSTACK = "613602def1d028b84bf85ae6";
    }

    /**
     * App Receiver
     */
    public interface Action {
        String NETWORK_ACTION = "android.net.conn.CONNECTIVITY_CHANGE";
        String ACTION_NEW_ORDER = "edelivery.provider" + ".NEW_ORDER";
        String ACTION_ADMIN_DECLINE = "edelivery.provider" + ".ACTION_ADMIN_DECLINE";
        String ACTION_ADMIN_APPROVED = "edelivery.provider" + ".ACTION_ADMIN_APPROVED";
        String ACTION_ORDER_STATUS = "edelivery.provider" + ".ORDER_STATUS";
        String ACTION_STORE_CANCELED_REQUEST = "edelivery.provider" + ".STORE_CANCELED_REQUEST";
    }

    public interface Bank {
        String BANK_ACCOUNT_HOLDER_TYPE = "individual";
    }

    /**
     * Google params
     */
    public interface google {
        String LAT = "lat";
        String LNG = "lng";
        String ROUTES = "routes";
        String LEGS = "legs";
        String STEPS = "steps";
        String POLYLINE = "polyline";
        String POINTS = "points";
    }

    public interface Facebook {
        String EMAIL = "email";
        String PUBLIC_PROFILE = "public_profile";
    }

    public interface DeliveryType {
        int STORE = 1;
        int COURIER = 2;
    }

    public interface OrderStatus {
        int WAITING_FOR_ACCEPT_STORE = 1;
        int STORE_ORDER_ACCEPTED = 3;
        int STORE_ORDER_PREPARING = 5;
        int STORE_ORDER_READY = 7;
        int STORE_ORDER_REJECTED = 103;
        int STORE_ORDER_CANCELLED = 104;
        int STORE_CANCELLED_REQUEST = 105;
        int WAITING_FOR_DELIVERY_MEN = 9;
        int DELIVERY_MAN_ACCEPTED = 11;
        int DELIVERY_MAN_COMING = 13;
        int DELIVERY_MAN_ARRIVED = 15;
        int DELIVERY_MAN_PICKED_ORDER = 17;
        int DELIVERY_MAN_STARTED_DELIVERY = 19;
        int DELIVERY_MAN_ARRIVED_AT_DESTINATION = 21;
        int DELIVERY_MAN_COMPLETE_DELIVERY = 25;
        int DELIVERY_MAN_NOT_FOUND = 109;
        int DELIVERY_MAN_REJECTED = 111;
        int DELIVERY_MAN_CANCELLED = 112;
        int ORDER_CANCELED_BY_USER = 101;
    }

    public interface ChatType {
        //admin = 1, user = 2, provider = 3, store = 4
        int ADMIN_AND_USER = 12;
        int ADMIN_AND_PROVIDER = 13;
        int ADMIN_AND_STORE = 14;
        int USER_AND_PROVIDER = 23;
        int USER_AND_STORE = 24;
        int PROVIDER_AND_STORE = 34;
    }

    public interface ProviderType {
        int ADMIN = 1;
        int STORE = 2;
    }

    public static class VerificationParam {
        public static final String SEND_PIN = "send_pin";
        public static final String SEND_OTP = "send_otp";
        public static final String SEND_PHONE = "send_phone";
        public static final String SEND_BIRTHDATE = "send_birthdate";
        public static final String SEND_ADDRESS = "send_address";
    }

    /**
     * Phone number default length
     */
    public static class PhoneNumber {
        public static final int MINIMUM_PHONE_NUMBER_LENGTH = 7;
        public static final int MAXIMUM_PHONE_NUMBER_LENGTH = 12;
    }
}