
#import "SBAppDelegate.h"
#import "SBHomeViewController.h"
#import <SBNetWorking/SBManager.h>

@interface SBAppDelegate ()

@end

@implementation SBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Configure The URL Cache -  MemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024
    [[SBManager sharedInstance] defaultURLCacheConfig];
    //    [[SBManager sharedInstance] configURLCacheInMemoryCapacity:10*1024*1024 diskCapacity:20*1024*1024];
    
    // Configure The Cache Time - 5 Minutes
    [[SBManager sharedInstance] defaultCacheTimeConfig];
    //    [[SBManager sharedInstance] configCacheTimeInMinutes:5];
    
    // Update NetWork Failure Message
    [[SBManager sharedInstance] updateNetWorkFailureMessage:@"Internet connection appears offline."];
    
    // SB Reachability Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SBNetworkAvailbility:)
                                                 name:@"SB_NETWORK_REACHABILITY"
                                               object:nil];
    
    // Background Download Process
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(URLSessionDidFinishEventsForBackgroundURLSession:)
                                                 name:@"SB_BACKGROUND_URLSESSION"
                                               object:nil];
    
    //need to enable background fetch
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Register Notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    // Root View Controller
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:[[SBHomeViewController alloc] init]];
    self.window.rootViewController = rootNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - SBNetwork Availbility
-(void)SBNetworkAvailbility :(NSNotification*)object {
    
    BOOL isSBNetworkAvailablity = [[[object userInfo] valueForKey:@"isSBNetworkAvailable"] boolValue];
    NSLog(@"isSBNetworkAvailablity %d",isSBNetworkAvailablity);
    
}

#pragma mark - Background Download Process
-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    
    self.backgroundTransferCompletionHandler = completionHandler;
    
    
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSNotification *)object {
    
    NSURLSession *session = [[object userInfo] valueForKey:@"sbURLSession"];
    
    // Check if all download tasks have been finished.
    [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {

        if ([downloadTasks count] == 0) {
            if (self.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = self.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                self.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    
                    [self presentNotification];
                }];
            }
        }
        else {
            
            for(NSURLSessionDownloadTask *task in downloadTasks) [task resume];
            
        }
    }];
    
    
}

-(void)presentNotification {
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    localNotification.alertBody = @"All files have been downloaded!";
    localNotification.alertAction = @"SBNetWorking!";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
}

-(void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

#pragma mark - App Life Cycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

