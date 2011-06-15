#import "GrowlNotifier.h"

@implementation GrowlNotifier

/* Init method */
- (id) init { 
  if ( (self = [super init]) ) {
    /* Tell growl we are going to use this class to hand growl notifications */
    [GrowlApplicationBridge setGrowlDelegate:self];
    connectionToInfoMapping = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                        0,
                                                        &kCFTypeDictionaryKeyCallBacks,
                                                        &kCFTypeDictionaryValueCallBacks);
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
-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message icon:(NSData *)icon
{
  [GrowlApplicationBridge notifyWithTitle:title
                              description:message
                         notificationName:GN_NOTIFICATION_NAME
                                 iconData:icon
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}

-(void) growlAlertWithTitle:(NSString *)title message:(NSString *)message iconURL:(NSString *)url
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:3.0];

  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
 
  if (connection) {
    CFDictionaryAddValue(connectionToInfoMapping,
                         connection,
                         [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [NSMutableData data], 
                          @"receivedData",
                          title,
                          @"title",
                          message,
                          @"message",
                          nil]);
  } else {
    [self growlAlertWithTitle:title message:message];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
  [[connectionInfo objectForKey:@"receivedData"] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
  [[connectionInfo objectForKey:@"receivedData"] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

  [connection release];

  NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
  [[connectionInfo objectForKey:@"receivedData"] release];

  [self growlAlertWithTitle:[connectionInfo objectForKey:@"title"]
                    message:[connectionInfo objectForKey:@"message"]];  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  [connection release];

  NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
  NSImage *icon = [[NSImage alloc] initWithData:[connectionInfo objectForKey:@"receivedData"]];

  [[connectionInfo objectForKey:@"receivedData"] release];
  
  [self growlAlertWithTitle:[connectionInfo objectForKey:@"title"]
                    message:[connectionInfo objectForKey:@"message"]
                       icon:[NSData dataWithData:[icon TIFFRepresentation]]];
  [icon release];
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