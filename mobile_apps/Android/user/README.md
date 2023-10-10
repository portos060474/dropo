# User app

### Add google-services.json to your project

### Set app content
 **Set app name** :
File name : `edelivery -> src -> main -> res -> values ->strings.xml`

File name : `build.gradle (app)`In `defaultConfig`
1. change applicationId
2. versionCode
3. versionName
4. FACEBOOK_APP_ID *if required
5. FB_LOGIN_PROTOCOL_SCHEME *if required
6. GOOGLE_ANDROID_API_KEY
> For places api we are using GOOGLE_ANDROID_API_KEY
> For other google api, we are using google key which will get from api response which is set in the admin panel.
> API name : “api/admin/check_app_keys”
> Method name : `parseAppSettingDetail`
Ex:`preferenceHelper.putGoogleKey(response.body().getGoogleKey());`

**Set server URL for API and Image(Assets)**
1) BASE_URL = “http://192.168.0.165:8001/”
2) IMAGE_URL = “http://192.168.0.165:8001/”



### Change app launcher icon and notification icon
File name: `edelivery -> src -> main -> res ->Image asset`

### Change Splash screen 



### Set provider path url for save captured image in internal storage 
File name :`provider_path.xml`
 
Ex : path="Android/data/your applicationId/files/Pictures"



### Change include subdomain 
File name : `network_security_config.xml`

Ex : `<domain includeSubdomains="true">192.168.0.165</domain> (From BASE_URL)`




### Change Theme color
File name : `AppColor.java`
`int COLOR_THEME = Color.parseColor(color code in hex);`

Ex : `int COLOR_THEME = Color.parseColor(“#ff00ff”);`




### Change font 
Add your font file in `edelivery -> src -> main ->assets ->fonts`
Change in your all custom view (button, text, Edittext etc)
 
EX : 
```java 
private boolean setCustomFont(Context ctx, String asset) {

   try {
       if (typeface == null) {
           // Log.i(TAG, "asset:: " + "fonts/" + asset);
           typeface = Typeface.createFromAsset(ctx.getAssets(),
                   "fonts/Poppins-Medium.ttf");
      }

   } catch (Exception e) {
       AppLog.handleException(TAG, e);
       // Log.e(TAG, "Could not get typeface: " + e.getMessage());
       return false;
   }

   setTypeface(typeface);
   return true;
}
```



### Build project
 
**Check build variants (check which have BASE_URL)**

1. Select target device
2. Run project 
