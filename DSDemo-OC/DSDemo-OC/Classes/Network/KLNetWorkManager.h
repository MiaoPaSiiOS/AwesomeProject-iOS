//
//  KLNetWorkManager.h
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "KLRequest.h"
#import "KLResponse.h"
#import "KLRequestGenerator.h"

// 项目打包上线都不会打印日志，因此可放心。
//#ifdef DEBUG
//#define KLNetLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
//#else
//#define KLNetLog(s, ... )
//#endif

//日志打印
#ifdef DEBUG
#define KLNetLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSSSSS"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[>>>>>>%s--]*[--%s--]*[--%s:%d--]\n",[str UTF8String] ,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__);\
}
#else
#define KLNetLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSSSSS"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[>>>>>>%s--]*[--%s--]*[--%s:%d--]\n",[str UTF8String] ,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String],[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__);\
}
#endif




/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void(^AmenHttpProgress)(NSProgress *progress);
/// 请求成功或失败回调
typedef void(^AmenCompletionHandler)(KLResponse *result);

typedef NSURL*(^AmenDownloadDestination)(NSURL *targetPath, NSURLResponse *response);

typedef void(^AmenDownloadCompletionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);


@interface KLNetWorkManager : NSObject

+ (instancetype)sharedInstance;
/// 取消所有HTTP请求
- (void)cancelAllRequest;

/// 取消指定URL的HTTP请求
- (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark - base dataTask
- (NSURLSessionDataTask *)dataTaskWithRequest:(KLRequest *)requestModel
                            completionHandler:(AmenCompletionHandler)completionHandler;

- (NSURLSessionDataTask *)dataTaskWithRequest:(KLRequest *)requestModel
                          uploadProgressBlock:(AmenHttpProgress)uploadProgressBlock
                        downloadProgressBlock:(AmenHttpProgress)downloadProgressBlock
                            completionHandler:(AmenCompletionHandler)completionHandler;
//下载
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(KLRequest *)requestModel
                                             progress:(AmenHttpProgress)downloadProgressBlock
                                          destination:(AmenDownloadDestination)destination
                                    completionHandler:(AmenDownloadCompletionHandler)completionHandler;

//上传
- (NSURLSessionDataTask *)uploadDataWithRequest:(KLRequest *)requestModel
                            uploadProgressBlock:(AmenHttpProgress)uploadProgressBlock
                              completionHandler:(AmenCompletionHandler)completionHandler;

@end
