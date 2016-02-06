SBNetWorking
================
This is simple Web service call using NSURLSession for iOS which is developed in Objective C.

### Benefits:

1. SBNetWorking framework will hepls us to write minimal code and faster implementation of web service into our application.
2. Using this framework we can perform GET, DELETE, POST, PUT methods using NSURLSession along with Cache or without Cache.
3. Async Image Download with Cache and without Cache the response using NSURLSessionDataTask.
4. Async Images, Videos, Audios and PDF's Download with Cache and without Cache the response using NSURLSessionDownloadTask.
5. Downloads are keep on running in Background state, Supended state, Terminated state and Not Running state.
6. This framework makes it easy to quickly download one or several large file(s).
7. Supports Pause / Resume and Cancel the downloads.
8. Progression/Completion Blocks.

  - [X] If an iOS app is terminated by the system and relaunched, the app can use the same identifier to create a new configuration object and session and retrieve the status of transfers that were in progress at the time of termination. This behavior applies only for normal termination of the app by the system. If the user terminates the app from the multitasking screen, the system cancels all of the session’s background transfers. In addition, the system does not automatically relaunch apps that were force quit by the user. The user must explicitly relaunch the app before transfers can begin again.

## Demo
## Installation
1. Drag the Framework `SBNetWorking.framework` to your project folder.
2. Add the Framework on `Project -> Targets -> General -> Embedded Binaries -> Press + Symbole -> Add SBNetWorking.framework`
3. Make an import statement for the file as `#import <SBNetWorking/SBManager.h>.`
4. To run in Simulator add the Framework under the given Folder Path `SBNetWork -> Framework -> Simulator`, For Device and Distributing to App Store use `SBNetWork -> Framework -> Device`.

<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen1.png" alt="SBNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen2.png" alt="SBNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen3.png" alt="SBNetWorking Screenshot" />

## Configuration
Add to your AppDelegate.m class given below configuration.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

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

    return YES;
}

// ********  SBNetwork Availbility ******** //
-(void)SBNetworkAvailbility :(NSNotification*)object {
    
    BOOL isSBNetworkAvailablity = [[[object userInfo] valueForKey:@"isSBNetworkAvailable"] boolValue];
    NSLog(@"isSBNetworkAvailablity %d",isSBNetworkAvailablity);
    
}

// ********  Background Download Process ******** //
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

```
## Initialization with callback Using Blocks
### JSON RESPONSE
```objective-c
If you want to add headers, user below method before calling the services.
   
    // ******** Each and every time, it will fetch to server ******** //

        [[SBManager sharedInstance] setHeaders:@{
                                             @"key" : @"value"
                                             }];

        [[SBManager sharedInstance] performDataTaskWithExecuteGetURL:urlString
                                                           onSuccess:^(NSDictionary *dictionary) {
                                                               NSLog(@"response %@",dictionary);
    
                                                               [self updateResponseData:dictionary];
    
    
                                                           } onFailure:^(NSError *error) {
    
                                                               [self showErrorMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    
                                                           }];
    
    
    // ******** After five minutes only (Based on "configCacheTimeInMinutes:5" Or "defaultCacheTimeConfig") next call will go to server. Eventhough Network available or Not available ******** //
      
          [[SBManager sharedInstance] setHeaders:@{
                                             @"key" : @"value"
                                             }];

        [[SBManager sharedInstance] performDataTaskWithCacheAndExecuteGetURL:urlString
                                                                   onSuccess:^(NSDictionary *dictionary) {
                                                                       NSLog(@"response %@",dictionary);
    
                                                                       [self updateResponseData:dictionary];
    
                                                                   } onFailure:^(NSError *error) {
    
                                                                       [self showErrorMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    
                                                                   }];

    // ******** After ten minutes (Based on "cacheExpireTimeInMinutes" value) only next call will go to server. Eventhough Network available or Not available ******** \\
  
      [[SBManager sharedInstance] setHeaders:@{
                                             @"key" : @"value"
                                             }];

    [[SBManager sharedInstance] performDataTaskWithCacheAndExecuteGetURL:urlString
                                                cacheExpireTimeInMinutes:10
                                                               onSuccess:^(NSDictionary *dictionary) {
                                                                   
                                                                   [self updateResponseData:dictionary];
                                                                   
                                                                   
                                                               } onFailure:^(NSError *error) {
                                                                   
                                                                   [self showErrorMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
                                                                   
                                                                   
                                                               }];
```
### DOWNLOAD IMAGES - DATA TASK
```objective-c
// ******** Data Task Request For Image Download, Without Cache ******** //
    [[SBManager sharedInstance] performDataTaskWithDownlaodImageURL:imageArray[indexPath.section]
                                                             onImageSuccess:^(UIImage *image) {
    
                                                                 imageView.image = image;
                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
    
                                                             } onFailure:^(NSError *error) {
    
                                                             }];

// ******** Data Task Request For Image Download, With Cache - Default System Cache Time ******** //
    [[SBManager sharedInstance] performDataTaskWithCacheAndDownlaodImageURL:imageArray[indexPath.section]
                                                             onImageSuccess:^(UIImage *image) {
    
                                                                 imageView.image = image;
                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
    
                                                             } onFailure:^(NSError *error) {
    
                                                             }];


// ******** Data Task Request For Image Download, With Cache - Image Cache Time will be different for Each Request ******** //
    [[SBManager sharedInstance] performDataTaskWithCacheAndDownlaodImageURL:imageArray[indexPath.section]
                                                   cacheExpireTimeInMinutes:10
                                                             onImageSuccess:^(UIImage *image) {
                                                                
                                                                 imageView.image = image;
                                                                 [(UIActivityIndicatorView*)[imageView viewWithTag:INDICATOR_TAG] stopAnimating];
                                                                 
                                                             } onFailure:^(NSError *error) {
                                                                 
                                                             }];


```
### DOWNLOAD IMAGES, VIDEOS, AUDIOS AND PDF'S - DOWNLOAD TASK
```objective-c
   
// ********  Download Task Request For Files Download, Without Cache ******** //
    [[SBManager sharedInstance] performDownloadTaskWithDownlaodFileURL:fileArray [indexPath.section]
                                                    onDownloadTaskData:^(NSData *data) {
                                                        
                                                        
                                                    } onFailure:^(NSError *error) {
                                                        
                                                        
                                                    } onDownloadProgress:^(double progressValue) {
                                                        
                                                    }];
    
    
// ******** Download Task Request For Files Download, With Cache - Default System Cache Time ******** //
    [[SBManager sharedInstance] performDownloadTaskWithCacheAndDownlaodFileURL:fileArray [indexPath.section]
                                                            onDownloadTaskData:^(NSData *data) {
                                                                
                                                            } onFailure:^(NSError *error) {
                                                                
                                                            } onDownloadProgress:^(double progressValue) {
                                                                
                                                            }];
                                                         
// ******** DownloadDownload Task Request For Files Download, With Cache - File Cache Time will be different for Each Request ******** //
    [[SBManager sharedInstance] performDownloadTaskWithCacheAndDownlaodFileURL:fileArray [indexPath.section]
                                                      cacheExpireTimeInMinutes:10
                                                            onDownloadTaskData:^(NSData *data) {

                                                            } onFailure:^(NSError *error) {
                                                                
                                                            } onDownloadProgress:^(double progressValue) {
                                                                
                                                            }];   

```

## Contact
sankarlal20@gmail.com

## License

SBNetWorking is available under the MIT license.

Copyright © 2016 SBNetWorking

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
