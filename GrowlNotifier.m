#import "GrowlNotifier.h"

@implementation GrowlNotifier

/* Init method */
- (id) init { 
  if ( (self = [super init]) ) {
    /* Tell growl we are going to use this class to hand growl notifications */
    [GrowlApplicationBridge setGrowlDelegate:self];
    // keeping track of connections and data in case there are concurrent downloads
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
/* End methods from GrowlApplicationBridgeDelegate */

/*!
 * @brief Returns state of growl installation
 *
 * @return BOOL growl installation state
 */
- (BOOL) isGrowlInstalled
{
  return [GrowlApplicationBridge isGrowlInstalled];
}

/*!
 * @brief Returns the running state of growl
 *
 * @return BOOL growl running state
 */
- (BOOL) isGrowlRunning
{
  return [GrowlApplicationBridge isGrowlRunning];
}

/*!
 * @brief Shows a growl alert with no icon
 */
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

/*!
 * @brief Shows a growl alert with an NSData icon
 */
- (void) growlAlertWithTitle:(NSString *)title message:(NSString *)message icon:(NSData *)icon
{
  [GrowlApplicationBridge notifyWithTitle:title
                              description:message
                         notificationName:GN_NOTIFICATION_NAME
                                 iconData:icon
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}


/*!
 * @brief Shows a growl alert with an icon after downloading it
 * 
 * This method take the url and starts downloading it and only displays
 * the growl notification if it successfully downloads it.
 * If there are any failures it displays the alert without an icon.
 */
- (void) growlAlertWithTitle:(NSString *)title message:(NSString *)message iconURL:(NSString *)url
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:3.0];

  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
 
  if (connection)
  {
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
  }
  else
  {
    [self growlAlertWithTitle:title message:message];
  }
}

/* Begin methods from NSURLConnection delegate */
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


/*!
 * @brief Shows a growl alert with no icon on failure
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

  [connection release];

  NSMutableDictionary *connectionInfo = CFDictionaryGetValue(connectionToInfoMapping, connection);
  [[connectionInfo objectForKey:@"receivedData"] release];

  [self growlAlertWithTitle:[connectionInfo objectForKey:@"title"]
                    message:[connectionInfo objectForKey:@"message"]];  
}


/*!
 * @brief Shows a growl alert with with the icon
 */
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

/* End methods from NSURLConnection delegate */

/* Dealloc method */
- (void) dealloc
{ 
  [super dealloc]; 
}
@end