#import "GrowlNotifier.h"

@implementation GrowlNotifier

/* Init method */
- (id) init { 
  if ( (self = [super init]) ) {
    /* Tell growl we are going to use this class to hand growl notifications */
    [GrowlApplicationBridge setGrowlDelegate:self];
  }
  return self;
}

/* Begin methods from GrowlApplicationBridgeDelegate */
- (NSDictionary *) registrationDictionaryForGrowl
{
  NSArray *array = [NSArray arrayWithObjects:GN_NOTIFICATION_NAME, nil];
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:1],
                        GROWL_TICKET_VERSION,
                        array,
                        GROWL_NOTIFICATIONS_ALL,
                        array,
                        GROWL_NOTIFICATIONS_DEFAULT,
                        GN_APPLICATION_NAME,
                        GROWL_APP_NAME,
                        nil];
  return dict;
}


-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message
{
  [GrowlApplicationBridge notifyWithTitle:title
                              description:message
                         notificationName:GN_NOTIFICATION_NAME
                                 iconData:nil
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}


-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message iconURL:(NSString *)url
{
  [GrowlApplicationBridge notifyWithTitle:title
                              description:message
                         notificationName:GN_NOTIFICATION_NAME
                                 iconData:nil
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}

-(BOOL) isGrowlInstalled
{
  return [GrowlApplicationBridge isGrowlInstalled];
}

-(BOOL) isGrowlRunning
{
  return [GrowlApplicationBridge isGrowlRunning];
}

/* Dealloc method */
- (void) dealloc { 
  [super dealloc]; 
}
@end