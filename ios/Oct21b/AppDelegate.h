#import <RCTAppDelegate.h>
#import <UIKit/UIKit.h>

// Enable Push for iOS　Step2
#import <UserNotifications/UserNotifications.h>// 追加 step2
#import <MarketingCloudSDK/MarketingCloudSDK.h>
#import <SFMCSDK/SFMCSDK.h>



// Enable Push for iOSStep2
@interface AppDelegate : RCTAppDelegate<UNUserNotificationCenterDelegate, SFMCSdkURLHandlingDelegate>

@end
