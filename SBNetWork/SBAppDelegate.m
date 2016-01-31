
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
    
    
    UINavigationController *rootNavigationController = [[UINavigationController alloc] initWithRootViewController:[[SBHomeViewController alloc] init]];
    self.window.rootViewController = rootNavigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

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
