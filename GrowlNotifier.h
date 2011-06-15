#import <AppKit/AppKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Growl/Growl.h>

#define GN_APPLICATION_NAME @"Growl Browser Plugin"
#define GN_NOTIFICATION_NAME @"Alert"

@interface GrowlNotifier :NSObject <GrowlApplicationBridgeDelegate> {
  CFMutableDictionaryRef connectionToInfoMapping;
} 
-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message;
-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message icon:(NSData *)icon;
-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message iconURL:(NSString *)url;
-(BOOL) isGrowlInstalled;
-(BOOL) isGrowlRunning;
@end
