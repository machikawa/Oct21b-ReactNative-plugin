#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import <MarketingCloudSDK/MarketingCloudSDK.h>  // 追加
#import <SFMCSDK/SFMCSDK.h>  // 追加


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"Oct21b";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  // Salesforce Marketing Cloud SDK の設定を追加
  PushConfigBuilder *pushConfigBuilder = [[PushConfigBuilder alloc] initWithAppId:@"yourid"];
  [pushConfigBuilder setAccessToken:@"yourid"];
  [pushConfigBuilder setMarketingCloudServerUrl:[NSURL URLWithString:@"https://yourid-8f4m.device.marketingcloudapis.com/"]];
  [pushConfigBuilder setMid:@"yourid"];
  [pushConfigBuilder setAnalyticsEnabled:YES];

  [SFMCSdk initializeSdk:[[[SFMCSdkConfigBuilder new] setPushWithConfig:[pushConfigBuilder build] onCompletion:^(SFMCSdkOperationResult result) {
      if (result == SFMCSdkOperationResultSuccess) {
        [self pushSetup];//// 🤜これ忘れるな！！！！
          // Enable Push
          NSLog(@"SFMC sdk configuration succeeded.");
      } else {
          // SFMC sdk configuration failed.
          NSLog(@"SFMC sdk configuration failed.");
      }
  }] build]];
 

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
/// ここをたす
/// ここの部分がないと、通知を聞いてくれなくなる。
- (void)pushSetup {
    dispatch_async(dispatch_get_main_queue(), ^{
      // set the UNUserNotificationCenter delegate - the delegate must be set here in
      // didFinishLaunchingWithOptions
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      [[SFMCSdk mp] setURLHandlingDelegate:self];
      [[UIApplication sharedApplication] registerForRemoteNotifications];

      [[UNUserNotificationCenter currentNotificationCenter]
      requestAuthorizationWithOptions:UNAuthorizationOptionAlert |
      UNAuthorizationOptionSound |
      UNAuthorizationOptionBadge
      completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (error == nil) {
          if (granted == YES) {
                NSLog(@"User granted permission");
          }
        }
      }];
    });
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[SFMCSdk mp] setDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    os_log_debug(OS_LOG_DEFAULT, "didFailToRegisterForRemoteNotificationsWithError = %@", error);
}

// The method will be called on the delegate when the user responded to the notification by opening
// the application, dismissing the notification or choosing a UNNotificationAction. The delegate
// must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
            withCompletionHandler:(void (^)(void))completionHandler {
    // tell the MarketingCloudSDK about the notification
    [[SFMCSdk mp] setNotificationRequest:response.notification.request];

    if (completionHandler != nil) {
        completionHandler();
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:
            (void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"User Info : %@", notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert |
                      UNAuthorizationOptionBadge);
}

// This method is REQUIRED for correct functionality of the SDK.
// This method will be called on the delegate when the application receives a silent push

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[SFMCSdk mp] setNotificationUserInfo:userInfo];

    completionHandler(UIBackgroundFetchResultNewData);
}

//URL Handling
- (void)sfmc_handleURL:(NSURL * _Nonnull)url type:(NSString * _Nonnull)type {
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
      if (success) {
        NSLog(@"url %@ opened successfully", url);
      } else {
        NSLog(@"url %@ could not be opened", url);
      }
    }];
  }
}
/// ここはそのまま
///
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
