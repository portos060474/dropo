
import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class SettingDetailResponse {
    public var isOpenUpdateDialog : Bool?
    public var isUseReferral : Bool?
    public var isVerifyEmail : Bool?
    public var googleKey : String?
    public var isLoginByPhone :Bool?
    public var isUploadDocuments : Bool?
    public var success : Bool?
    public var versionCode : String?
    public var isForceUpdate : Bool?
    public var isLoginByEmail : Bool?
    public var isProfilePictureRequired : Bool?
    public var message : Int?
    public var isVerifyPhone : Bool?
    var isSocialLoginEnable:Bool!
    public var isShowOptionalField : Bool?
    var adminEmail:String!
    var adminContact:String!
    var termsAndCondition:String!
    var privacyPolicy:String!
    var userBaseUrl:String!
    
    var mobileMinLenfth = 7
    var mobileMaxLenfth = 12
    
    var is_enable_twilio_call_masking = false
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [SettingDetailResponse] {
        var models:[SettingDetailResponse] = []
        for item in array {
            models.append(SettingDetailResponse(dictionary: item as! [String:Any])!)
        }
        return models
    }
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let SettingDetailResponse = SettingDetailResponse(someDictionaryFromJSON)
     
     - parameter dictionary:  [String:Any] from JSON.
     
     - returns: SettingDetailResponse Instance.
     */
    required public init?(dictionary: [String:Any]) {
        
        isOpenUpdateDialog = dictionary["is_open_update_dialog"] as? Bool
        isShowOptionalField = (dictionary["is_show_optional_field"] as? Bool) ?? true
        isUseReferral = dictionary["is_use_referral"] as? Bool
        isVerifyEmail = dictionary["is_verify_email"] as? Bool
        googleKey = dictionary["google_key"] as? String
        isLoginByPhone = dictionary["is_login_by_phone"] as? Bool
        isUploadDocuments = dictionary["is_document_mandatory"] as? Bool
        success = dictionary["success"] as? Bool
        versionCode = dictionary["version_code"] as? String
        isForceUpdate = dictionary["is_force_update"] as? Bool
        isLoginByEmail = dictionary["is_login_by_email"] as? Bool
        isProfilePictureRequired = dictionary["is_profile_picture_required"] as? Bool
        message = dictionary["message"] as? Int
        isVerifyPhone = dictionary["is_verify_phone"] as? Bool
        
        let lhs = Utility.currentAppVersion()
        let rhs = Utility.getLatestVersion()
        if lhs.compare(rhs, options: .numeric) == .orderedDescending {
            isSocialLoginEnable = false
        } else {
            isSocialLoginEnable = (dictionary["is_login_by_social"] as? Bool) ?? false
        }
        
        adminEmail = (dictionary["admin_contact_email"] as? String) ?? ""
        adminContact = (dictionary["admin_contact_phone_number"] as? String) ?? ""
        termsAndCondition = (dictionary["terms_and_condition_url"] as? String) ?? ""
        privacyPolicy = (dictionary["privacy_policy_url"] as? String) ?? ""
        userBaseUrl = (dictionary["user_base_url"] as? String) ?? ""

        mobileMinLenfth = (dictionary["minimum_phone_number_length"] as? Int) ?? 7
        mobileMaxLenfth = (dictionary["maximum_phone_number_length"] as? Int) ?? 12
        
        is_enable_twilio_call_masking = (dictionary["is_enable_twilio_call_masking"] as? Bool) ?? false
    }
}
