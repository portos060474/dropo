
import Foundation

public class SettingDetailResponse {
	public var success : Bool?
	public var message : Int?
	public var isUseReferral : Bool?
	public var isVerifyEmail : Bool?
	public var isVerifyPhone : Bool?
	public var isUploadDocuments : Bool?
	public var isLoginByEmail : Bool?
	public var isLoginByPhone : Bool?
	public var isProfilePictureRequired : Bool?
	public var isShowOptionalField : Bool?
    public var isPhoneFieldRequired:Bool!
    public var isEmailIdFieldRequired:Bool!
    public var versionCode : String?
	public var isOpenUpdateDialog : Bool?
	public var isForceUpdate : Bool?
	public var googleKey : String?
    var isSocialLoginEnable:Bool!
    
    var adminEmail:String!
    var adminContact:String!
    var termsAndCondition:String!
    var privacyPolicy:String!
    var userBaseUrl:String!
    var isAllowBringChange:Bool!
    var mobileMinLenfth = 7
    var mobileMaxLenfth = 12
    var is_enable_twilio_call_masking = false
    var max_courier_stop_limit = 0
    
    public var langItems : Array<SettingDetailLang>?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [SettingDetailResponse] {
        var models:[SettingDetailResponse] = []
        for item in array {
            models.append(SettingDetailResponse(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		success = dictionary["success"] as? Bool
		message = dictionary["message"] as? Int
		isUseReferral = dictionary["is_use_referral"] as? Bool
		isVerifyEmail = dictionary["is_verify_email"] as? Bool
		isVerifyPhone = dictionary["is_verify_phone"] as? Bool
		isUploadDocuments = dictionary["is_document_mandatory"] as? Bool
		isLoginByEmail = dictionary["is_login_by_email"] as? Bool
		isLoginByPhone = dictionary["is_login_by_phone"] as? Bool
		isProfilePictureRequired = dictionary["is_profile_picture_required"] as? Bool
		isShowOptionalField = (dictionary["is_show_optional_field"] as? Bool) ?? true
		versionCode = dictionary["version_code"] as? String
		isOpenUpdateDialog = dictionary["is_open_update_dialog"] as? Bool
		isForceUpdate = dictionary["is_force_update"] as? Bool
		googleKey = dictionary["google_key"] as? String
        isPhoneFieldRequired = (dictionary["is_phone_field_required"] as? Bool) ?? false
        isEmailIdFieldRequired = (dictionary["is_email_id_field_required"] as? Bool) ?? false
        
        let lhs = Utility.currentAppVersion()
        let rhs = Utility.getLatestVersion()
        if lhs.compare(rhs, options: .numeric) == .orderedDescending {
            isSocialLoginEnable = false
        } else {
            isSocialLoginEnable = (dictionary["is_login_by_social"] as? Bool) ?? false
        }
        
        userBaseUrl = (dictionary["user_base_url"] as? String) ?? ""
        
        adminEmail = (dictionary["admin_contact_email"] as? String) ?? ""
        adminContact = (dictionary["admin_contact_phone_number"] as? String) ?? ""
        termsAndCondition = (dictionary["terms_and_condition_url"] as? String) ?? ""
        privacyPolicy = (dictionary["privacy_policy_url"] as? String) ?? ""
        if (dictionary["lang"] != nil) { langItems = SettingDetailLang.modelsFromDictionaryArray(array: dictionary["lang"] as! NSArray)
        }
        
        mobileMinLenfth = (dictionary["minimum_phone_number_length"] as? Int) ?? 7
        mobileMaxLenfth = (dictionary["maximum_phone_number_length"] as? Int) ?? 12
        termsAndCondition = (dictionary["terms_and_condition_url"] as? String) ?? ""
        isAllowBringChange = dictionary["is_allow_bring_change_option"] as? Bool ?? false
        is_enable_twilio_call_masking = dictionary["is_enable_twilio_call_masking"] as? Bool ?? false
        max_courier_stop_limit = dictionary["max_courier_stop_limit"] as? Int ?? 0

	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message, forKey: "message")
		dictionary.setValue(self.isUseReferral, forKey: "use_referral")
		dictionary.setValue(self.isVerifyEmail, forKey: "verify_email")
		dictionary.setValue(self.isVerifyPhone, forKey: "verify_phone")
		dictionary.setValue(self.isUploadDocuments, forKey: "upload_documents")
		dictionary.setValue(self.isLoginByEmail, forKey: "login_by_email")
		dictionary.setValue(self.isLoginByPhone, forKey: "login_by_phone")
		dictionary.setValue(self.isProfilePictureRequired, forKey: "profile_picture_required")
		dictionary.setValue(self.isShowOptionalField, forKey: "is_show_optional_field")
		dictionary.setValue(self.versionCode, forKey: "version_code")
		dictionary.setValue(self.isOpenUpdateDialog, forKey: "open_update_dialog")
		dictionary.setValue(self.isForceUpdate, forKey: "force_update")
		dictionary.setValue(self.googleKey, forKey: "google_key")
        dictionary.setValue(self.is_enable_twilio_call_masking, forKey: "is_enable_twilio_call_masking")
        dictionary.setValue(self.max_courier_stop_limit, forKey: "max_courier_stop_limit")
		return dictionary
	}

}



public class SettingDetailLang {
    
    public var name : String?
    public var code : String?
    public var string_file_path : String?
    public var is_visible : Bool?

    public class func modelsFromDictionaryArray(array:NSArray) -> [SettingDetailLang] {
           var models:[SettingDetailLang] = []
           for item in array {
               models.append(SettingDetailLang(dictionary: item as! NSDictionary)!)
           }
           return models
       }

    required public init?(dictionary: NSDictionary) {
          name = (dictionary["name"] as? String) ?? ""
          code = (dictionary["code"] as? String) ?? ""
          string_file_path = (dictionary["string_file_path"] as? String) ?? ""
        is_visible = (dictionary["is_visible"] as? Bool)
        
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.code, forKey: "code")
        dictionary.setValue(self.string_file_path, forKey: "string_file_path")
        dictionary.setValue(self.is_visible, forKey: "is_visible")

        return dictionary
    }
    
}
