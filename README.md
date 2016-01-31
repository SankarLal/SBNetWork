SBNetWorking
================
  This is simple Network call using NSURLSession for iOS, developed in Objective C. Includes Cache, callbacks using blocks as well and we can downlod the images using NSURLSessionDataTask.
  
## Requirements
* Apple LLVM compiler
* iOS 8.0 or higher
* ARC

## Demo
## Installation
1. Drag the Framework `SBNetWorking.framework` to your project folder.
2. Add the Framework on `Project -> Targets -> General -> Embedded Binaries -> Press + Symbole -> Add SBNetWorking.framework`
3. Make an import statement for the file as `#import <SBNetWorking/SBManager.h>.`
4. To run in Simulator add the Framework under the given Folder Path `SBNetWorkingProject -> Framework -> Simulator`, For Device and Distributing to App Store use `SBNetWorkingProject -> Framework -> Device`.

<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen1.png" alt="SBNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen2.png" alt="SBNetWorking Screenshot" />
<img src="https://raw.githubusercontent.com/sankarlal/sbNetWork/master/Screen%20Shots/Screen3.png" alt="SBNetWorking Screenshot" />

## Configuration
Add to your AppDelegate.m class given below configuration.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Configure The URL Cache
    [[SBManager sharedInstance] defaultURLCacheConfig];
    //    [[SBManager sharedInstance] configURLCacheInMemoryCapacity:10*1024*1024 diskCapacity:20*1024*1024];
    
    // Configure The Cache Time
    [[SBManager sharedInstance] defaultCacheTimeConfig];
    //    [[SBManager sharedInstance] configCacheTimeInMinutes:5];
    
    // Update NetWork Failure Message
    [[SBManager sharedInstance] updateNetWorkFailureMessage:@"Internet connection appears offline."];
    return YES;
}
```
## Initialization with callback Using Blocks
## JSON RESPONSE
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
## DOWNLOAD IMAGES
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
## Contact
sankarlal20@gmail.com

## License

SBNetWorking is available under the MIT license.

Copyright © 2016 SBNetWorking

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
