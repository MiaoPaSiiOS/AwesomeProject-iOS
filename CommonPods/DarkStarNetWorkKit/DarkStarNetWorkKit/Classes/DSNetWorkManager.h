//
//  DSNetWorkManager.h
//  DarkStarNetWorkKit
//
//  Created by zhuyuhui on 2021/6/16.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "DSNetResponse.h"
#import "DSRequestGenerator.h"

// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define DSNetworkLOG(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DSNetworkLOG(s, ... )
#endif

typedef NS_ENUM(NSInteger, DSNetworkRequestType) {
    DSNetworkRequestTypeGET,
    DSNetworkRequestTypePOST,
    DSNetworkRequestTypePUT,
    DSNetworkRequestTypePATCH,
    DSNetworkRequestTypeDELETE
};

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void(^DSHttpProgress)(NSProgress *progress);
/// 请求成功或失败回调
typedef void(^DSCompletionHandler)(DSNetResponse *response);

typedef NSURL*(^DSDownloadDestination)(NSURL *targetPath, NSURLResponse *response);

typedef void(^DSDownloadCompletionHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);


@interface DSNetWorkManager : NSObject

+ (instancetype)sharedInstance;
/// 取消所有HTTP请求
- (void)cancelAllRequest;

/// 取消指定URL的HTTP请求
- (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark - base dataTask
- (NSURLSessionDataTask *)dataTaskWithUrlPath:(NSString *)urlPath
      requestType:(DSNetworkRequestType)requestType
           header:(NSDictionary *)header
           params:(NSDictionary *)params
completionHandler:(DSCompletionHandler)completionHandler;

- (NSURLSessionDataTask *)dataTaskWithUrlPath:(NSString *)urlPath
          requestType:(DSNetworkRequestType)requestType
               header:(NSDictionary *)header
               params:(NSDictionary *)params
  uploadProgressBlock:(DSHttpProgress)uploadProgressBlock
downloadProgressBlock:(DSHttpProgress)downloadProgressBlock
    completionHandler:(DSCompletionHandler)completionHandler;
//下载
- (NSURLSessionDownloadTask *)downloadTaskithUrlPath:(NSString *)urlPath
     requestType:(DSNetworkRequestType)requestType
          header:(NSDictionary *)header
          params:(NSDictionary *)params
        progress:(DSHttpProgress)downloadProgressBlock
     destination:(DSDownloadDestination)destination
completionHandler:(DSDownloadCompletionHandler)completionHandler;

//上传
- (NSURLSessionDataTask *)uploadDataWithUrlPath:(NSString *)urlPath
        requestType:(DSNetworkRequestType)requestType
             header:(NSDictionary *)header
             params:(NSDictionary *)params
           contents:(NSArray<DSUploadFile *> *)contents
uploadProgressBlock:(DSHttpProgress)uploadProgressBlock
  completionHandler:(DSCompletionHandler)completionHandler;

@end
