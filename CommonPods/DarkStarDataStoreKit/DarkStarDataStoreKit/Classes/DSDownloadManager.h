//
//  DSDownloadManager.h
//  common
//
//  Created by zhuyuhui on 2020/3/28.
//  Copyright © 2020 yuhuiMr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SSZipArchive/SSZipArchive.h>
/** Download task status. */
typedef NS_ENUM(NSInteger, DSDownloadTaskStatus) {
    DSDownloadTaskStatusNew = 1, // New task
    DSDownloadTaskStatusAlreadyExist, // Alreading exist task
    DSDownloadTaskStatusDownloading, // Downloading task
    DSDownloadTaskStatusSuspending // Suspending task
};

@class DSDownloadManager;

@protocol DSDownloadProtocol <NSObject>
@property (copy, nonatomic) NSString * remoteURL;
/// 文件夹名称
@property (copy, nonatomic) NSString * dirName;
/// 下载到本地的zip文件名 default is temp 不带后缀
@property (copy, nonatomic) NSString * zipName;

@end

@protocol DSDownloadDelegate <NSObject>

@optional

- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                       status:(DSDownloadTaskStatus)status;

/** Download completed callback */
- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                  sakuraInfos:(id<DSDownloadProtocol>)infos
    didFinishDownloadingToURL:(NSURL *)location;

/** Download progress callback */
- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/** Reserved for future use */
- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
            didResumeAtOffset:(int64_t)fileOffset
           expectedTotalBytes:(int64_t)expectedTotalBytes;

/** Download error completed handler */
- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                  sessionTask:(NSURLSessionTask *)downloadTask
         didCompleteWithError:(NSError *)error;

/** unzip progress handler */
- (void)sakuraManagerDownload:(DSDownloadManager *)manager
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                progressEvent:(unsigned long long)loaded
                        total:(unsigned long long)total;
@end

#pragma mark - TXDownload

/** Downloading progress block handler */
typedef void(^DSDownloadProgressHandler)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
/** Download completed block handler */
typedef void(^DSDownloadErrorHandler)(NSError *error);
/** Unzip download file progress block handler */
typedef void(^AMENUnzipProgressHandler)(unsigned long long loaded, unsigned long long total);
/** Unzip download file completed handler */
typedef void(^DSDownloadCompletedHandler)(id<DSDownloadProtocol>infos, NSURL *location);
/** Custom download operation block handler */
typedef void(^AMENGeneratePathSuccessHandler)(NSString *toFilePath, NSString *sakuraPath, NSString *sakuraName);

@interface DSDownloadManager : NSObject<NSURLSessionDownloadDelegate>
#pragma mark - Share

+ (instancetype)manager;


#pragma mark - Clear operation
+ (void)formatSakuraPath:(NSString *)sakuraPath cleanCachePath:(NSString *)cachePath;

/** Notice! This operation will remove all sakuras that you have downloaded! */
+ (BOOL)clearAllCaches;

/** Remove a special sakura if you want. */
+ (BOOL)clearCacheWithDirName:(NSString *)dirName;

/** Remove a special sakura with it path that you want to. */
+ (BOOL)clearCacheWithPath:(NSString *)path;

#pragma mark - Sakura operation

/** Path: Sakura */
+ (NSString *)getDirectoryPath;

// 获取指定文件夹的路径
+ (NSString *)getSandboxPathWithDirName:(NSString *)dirName;

#pragma mark - Dowload operation

- (NSURLSessionDownloadTask *)downloadWithInfos:(id<DSDownloadProtocol>)infos
                                       delegate:(id<DSDownloadDelegate> )delegate;

- (NSURLSessionDownloadTask *)downloadWithInfos:(id<DSDownloadProtocol>)infos
                        downloadProgressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                           downloadErrorHandler:(DSDownloadErrorHandler)downloadErrorHandler
                           unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
                               completedHandler:(DSDownloadCompletedHandler)completedHandler;

- (void)cancelDownloadTaskWithURLStr:(NSString *)URLStr;

- (void)cancelDownloadTask:(NSURLSessionDownloadTask *)downloadTask;

- (void)cancelAllDownloadTask;

#pragma mark - Custom operation
@end





