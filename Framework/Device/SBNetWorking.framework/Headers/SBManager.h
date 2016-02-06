

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Blocks
typedef void (^OnSuccess)(NSDictionary *dictionary);
typedef void (^OnFailure)(NSError *error);
typedef void (^OnImageSuccess)(UIImage *image);

typedef void (^OnDownloadTaskData)(NSData *data);
typedef void (^OnDownloadProgress)(double progressValue);


@interface SBManager : NSObject

+ (id)sharedInstance;

#pragma mark - URL Cache Configuration
-(void)defaultURLCacheConfig; // MemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024
-(void)configURLCacheInMemoryCapacity:(NSInteger)mCapacity
                         diskCapacity:(NSInteger)dCapacity;

#pragma mark - Cache Time Configuration
-(void)defaultCacheTimeConfig;  // 5 Minutes
-(void)configCacheTimeInMinutes:(NSInteger)cTime;

#pragma mark - Remove All Cached Response
-(void)removeAllCachedResponses;

#pragma mark - Request Header
- (void)setHeaders:(NSDictionary *)headers;

#pragma mark - ***********************************************************************************************************************
#pragma mark - * Data Task Request Process *
#pragma mark - ***********************************************************************************************************************

#pragma mark - Data Task Request Without Cache
-(void)performDataTaskWithExecuteGetURL:(NSString*)url
                              onSuccess:(OnSuccess)success
                              onFailure:(OnFailure)failure;

-(void)performDataTaskWithExecuteDeleteURL:(NSString*)url
                                 onSuccess:(OnSuccess)success
                                 onFailure:(OnFailure)failure;

-(void)performDataTaskWithExecutePostURL:(NSString*)url
                             requestBody:(NSData *)requestBody
                               onSuccess:(OnSuccess)success
                               onFailure:(OnFailure)failure;

-(void)performDataTaskWithExecutePutURL:(NSString*)url
                            requestBody:(NSData *)requestBody
                              onSuccess:(OnSuccess)success
                              onFailure:(OnFailure)failure;

#pragma mark - Data Task Request With Cache - Cache Time will be same for All Request, Should Configure the Cache Time
-(void)performDataTaskWithCacheAndExecuteGetURL:(NSString*)url
                                      onSuccess:(OnSuccess)success
                                      onFailure:(OnFailure)failure;

-(void)performDataTaskWithCacheAndExecuteDeleteURL:(NSString*)url
                                         onSuccess:(OnSuccess)success
                                         onFailure:(OnFailure)failure;

-(void)performDataTaskWithCacheAndExecutePostURL:(NSString*)url
                                     requestBody:(NSData *)requestBody
                                       onSuccess:(OnSuccess)success
                                       onFailure:(OnFailure)failure;

-(void)performDataTaskWithCacheAndExecutePutURL:(NSString*)url
                                    requestBody:(NSData *)requestBody
                                      onSuccess:(OnSuccess)success
                                      onFailure:(OnFailure)failure;

#pragma mark - Data Task Request With Cache - Cache Time will be different for Each Request
- (void)performDataTaskWithCacheAndExecuteGetURL:(NSString *)url
                        cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                       onSuccess:(OnSuccess)success
                                       onFailure:(OnFailure)failure;

- (void)performDataTaskWithCacheAndExecuteDeleteURL:(NSString *)url
                           cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                          onSuccess:(OnSuccess)success
                                          onFailure:(OnFailure)failure;

- (void)performDataTaskWithCacheAndExecutePostURL:(NSString *)url
                                      requestBody:(NSData *)requestBody
                         cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                        onSuccess:(OnSuccess)success
                                        onFailure:(OnFailure)failure;

- (void)performDataTaskWithCacheAndExecutePutURL:(NSString *)url
                                     requestBody:(NSData *)requestBody
                        cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                       onSuccess:(OnSuccess)success
                                       onFailure:(OnFailure)failure;

#pragma mark - ***********************************************************************************************************************
#pragma mark - * Image Downlod - Data Task Process *
#pragma mark - ***********************************************************************************************************************

#pragma mark - Data Task Request For Image Download, Without Cache
-(void)performDataTaskWithDownlaodImageURL:(NSString*)url
                            onImageSuccess:(OnImageSuccess)imageSuccess
                                 onFailure:(OnFailure)failure;

#pragma mark - Data Task Request For Image Download, With Cache - Default System Cache Time
-(void)performDataTaskWithCacheAndDownlaodImageURL:(NSString*)url
                                    onImageSuccess:(OnImageSuccess)imageSuccess
                                         onFailure:(OnFailure)failure;

#pragma mark - Data Task Request For Image Download, With Cache - Image Cache Time will be different for Each Request
- (void)performDataTaskWithCacheAndDownlaodImageURL:(NSString *)url
                           cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                     onImageSuccess:(OnImageSuccess)imageSuccess
                                          onFailure:(OnFailure)failure;

#pragma mark - ***********************************************************************************************************************
#pragma mark - * Downlod Files (Image, Video, Audio, PDF etc.,) - Download Task Process *
#pragma mark - ***********************************************************************************************************************

#pragma mark - Download Task Request For Files Download, Without Cache
-(void)performDownloadTaskWithDownlaodFileURL:(NSString*)url
                           onDownloadTaskData:(OnDownloadTaskData)downloadTaskData
                                    onFailure:(OnFailure)failure
                           onDownloadProgress:(OnDownloadProgress)downloadProgress;


#pragma mark - Download Task Request For Files Download, With Cache - Default System Cache Time
-(void)performDownloadTaskWithCacheAndDownlaodFileURL:(NSString*)url
                                   onDownloadTaskData:(OnDownloadTaskData)downloadTaskData
                                            onFailure:(OnFailure)failure
                                   onDownloadProgress:(OnDownloadProgress)downloadProgress;


#pragma mark - Download Task Request For Files Download, With Cache - File Cache Time will be different for Each Request
- (void)performDownloadTaskWithCacheAndDownlaodFileURL:(NSString *)url
                              cacheExpireTimeInMinutes:(NSInteger)cacheExpireTimeInMinutes
                                    onDownloadTaskData:(OnDownloadTaskData)downloadTaskData
                                             onFailure:(OnFailure)failure
                                    onDownloadProgress:(OnDownloadProgress)downloadProgress;


#pragma mark - Pause, Resume And Cancel The Download Process
-(void)pauseResumeRequestedURL:(NSString *)url;
-(void)cancelDownloadingRequestedURL:(NSString *)url;

#pragma mark - ***********************************************************************************************************************

#pragma mark - Update NetWork Failure Message - As default "No Internet Connection."
-(void)updateNetWorkFailureMessage:(NSString*)failureMessage;

@end
