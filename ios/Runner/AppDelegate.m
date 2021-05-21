#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.

  // 配置高德key
  [AMapServices sharedServices].apiKey = @"c2d51ddeb5711c0b1373bf55a492369c";

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
