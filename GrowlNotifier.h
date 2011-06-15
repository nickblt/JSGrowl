#import <AppKit/AppKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Growl/Growl.h>

#define GN_APPLICATION_NAME @"JSGrowl"
#define GN_NOTIFICATION_NAME @"Javascript Notification"

@interface GrowlNotifier :NSObject <GrowlApplicationBridgeDelegate> {
  CFMutableDictionaryRef connectionToInfoMapping;
} 
-(BOOL) isInstalled;
-(BOOL) isRunning;
-(void) notifyWithTitle:(NSString *)title description:(NSString *)description;
-(void) notifyWithTitle:(NSString *)title description:(NSString *)description iconData:(NSData *)icon;
-(void) notifyWithTitle:(NSString *)title description:(NSString *)description iconURL:(NSString *)url;

@end
