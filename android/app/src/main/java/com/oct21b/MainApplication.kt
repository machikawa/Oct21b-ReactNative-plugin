package com.oct21b

import android.app.Application
import android.util.Log
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactHost
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load
import com.facebook.react.defaults.DefaultReactHost.getDefaultReactHost
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.soloader.SoLoader
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.messages.push.PushMessageManager
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions


// 😊 Salesforce Marketing Cloud SDK のインポート
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig

//import com.salesforce.marketingcloud.sfmcsdk.modules.SFMCSdkModuleConfig
//import com.salesforce.marketingcloud.initialization.MarketingCloudConfig
//import com.salesforce.marketingcloud.messages.push.PushMessageManager
//import com.salesforce.marketingcloud.messages.push.NotificationCustomizationOptions



class MainApplication : Application(), ReactApplication {

  override val reactNativeHost: ReactNativeHost =
      object : DefaultReactNativeHost(this) {
        override fun getPackages(): List<ReactPackage> =
            PackageList(this).packages.apply {
              // Packages that cannot be autolinked yet can be added manually here, for example:
              // add(MyReactNativePackage())
            }

        override fun getJSMainModuleName(): String = "index"

        override fun getUseDeveloperSupport(): Boolean = BuildConfig.DEBUG

        override val isNewArchEnabled: Boolean = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED
        override val isHermesEnabled: Boolean = BuildConfig.IS_HERMES_ENABLED
      }

  override val reactHost: ReactHost
    get() = getDefaultReactHost(applicationContext, reactNativeHost)

  override fun onCreate() {
    super.onCreate()
    SoLoader.init(this, false)

// 😊 Salesforce Marketing Cloud SDKの初期化を追加
      SFMCSdk.configure(applicationContext, SFMCSdkModuleConfig.build {
          pushModuleConfig =
              MarketingCloudConfig.builder()
                  .setApplicationId("XX")  // Salesforce Marketing Cloud App ID
                  .setAccessToken("XX")  // Salesforce Marketing Cloud Access Token
                  .setSenderId("XX")  // FCMのSender ID
                  .setMarketingCloudServerUrl("https://XX-8f4m.device.marketingcloudapis.com/")  // SalesforceサーバーURL
                  .setNotificationCustomizationOptions(
                      NotificationCustomizationOptions.create(com.facebook.react.R.drawable.ic_resume)  // 通知アイコン
                  )
                  .setAnalyticsEnabled(true)  // アナリティクスを有効化
                  .build(applicationContext)
      }) { initializationStatus ->
          if (initializationStatus.status == 1) {
              Log.d("LOGGGG","成功");
          }
      }

      if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
      // If you opted-in for the New Architecture, we load the native entry point for this app.
      load()
    }
  }
}
