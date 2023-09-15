//
//  DSDownloadManager.m
//  common
//
//  Created by zhuyuhui on 2020/3/28.
//  Copyright © 2020 yuhuiMr. All rights reserved.
//

#import "DSDownloadManager.h"
#import <objc/runtime.h>

NSString *const kDSDownloadDiretoryName = @"com.amen.axd";

// Format of config files
NSString *const kDSDownloadFileExtensionJSON  = @"json";
NSString *const kDSDownloadFileExtensionPLIST = @"plist";
NSString *const kDSDownloadFileExtensionZIP   = @"zip";
// lock
NSString *const kDSDownloadLockName = @"com.amen.axd.lock";


/** Just an agent for each download task! */
@interface DSDownloadTaskDelegateWrapper: NSObject <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) DSDownloadManager *manager;
@property (strong, nonatomic) id<DSDownloadDelegate> delegate;
@property (strong, nonatomic) id<DSDownloadProtocol> sakuraDownloadInfos;

@property (nonatomic, copy) DSDownloadProgressHandler downloadProgressHandler;
@property (nonatomic, copy) DSDownloadErrorHandler downloadErrorHandler;
@property (nonatomic, copy) AMENUnzipProgressHandler unzipProgressHandler;
@property (nonatomic, copy) DSDownloadCompletedHandler completedHandler;

- (instancetype)initWithManager:(DSDownloadManager *)manager
                       delegate:(id<DSDownloadDelegate>)delegate
            sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos;

- (instancetype)initWithManager:(DSDownloadManager *)manager
            sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos
                progressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                   errorHandler:(DSDownloadErrorHandler)errorHandler
           unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
               completedHandler:(DSDownloadCompletedHandler)completedHandler;

+ (instancetype)wrapperWithManager:(DSDownloadManager *)manager
                          delegate:(id<DSDownloadDelegate>)delegate
               sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos;

+ (instancetype)wrapperWithManager:(DSDownloadManager *)manager
               sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos
                   progressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                      errorHandler:(DSDownloadErrorHandler)errorHandler
              unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
                  completedHandler:(DSDownloadCompletedHandler)completedHandler;

@end


@interface DSDownloadManager()<SSZipArchiveDelegate>
/** For cancel task！ */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionDownloadTask *> *sakuraDownloadTaskCache;
/** Task wrappers. */
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,  DSDownloadTaskDelegateWrapper*> *sakuraDownloadTaskDelegateWrappersByIdentifier;
/** Just lock. */
@property (nonatomic, strong) NSLock *lock;
@end

@implementation DSDownloadManager
/** Share instance */
static DSDownloadManager *_manager;

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Please use + manager: method instead." userInfo:nil];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (instancetype)initWithTaskCacheAndDelegateWrappers{
    if (self = [super init]) {
        self.sakuraDownloadTaskCache = [NSMutableDictionary dictionary];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier = [NSMutableDictionary dictionary];
        
        NSLock *lock = [[NSLock alloc] init];
        lock.name = kDSDownloadLockName;
        self.lock = lock;
    }
    return self;
}

+ (instancetype)_taskCacheAndDelegateWrappers {
    return [[self alloc] initWithTaskCacheAndDelegateWrappers];
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [DSDownloadManager _taskCacheAndDelegateWrappers];
    });
    return _manager;
}


+ (void)formatSakuraPath:(NSString *)sakuraPath cleanCachePath:(NSString *)cachePath {
    if (!sakuraPath || !sakuraPath.length) return;
    if (cachePath) {
        [self clearCacheWithPath:cachePath];
    }
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//    NSArray *folders = [fileManager contentsOfDirectoryAtPath:sakuraPath error:&error];
//    NSString *folderName = sakuraPath.lastPathComponent;
//    NSString *tempName = [folders.lastObject stringByAppendingString:folderName];
//    NSString *moveItemPath = [sakuraPath stringByAppendingPathComponent:folders.lastObject];
//    NSString *tempItemPath = [[sakuraPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:tempName];
//    [fileManager moveItemAtPath:moveItemPath toPath:tempItemPath error:&error];
//    [fileManager removeItemAtPath:sakuraPath error:&error];
//    [fileManager moveItemAtPath:tempItemPath toPath:sakuraPath error:&error];
//#ifdef DEBUG
//    NSLog(@"folders:%@", folders);
//    NSLog(@"sakuraPath:%@--%@",sakuraPath, error);
//#endif
}

#pragma mark - Local sakura path operation(Public)
+ (NSString *)getDirectoryPath {
    NSString *libraryPath = [self _getLibraryPath];
    NSString *path = [libraryPath stringByAppendingPathComponent:kDSDownloadDiretoryName];
    return path;
}

// 获取指定文件夹的路径
+ (NSString *)getSandboxPathWithDirName:(NSString *)dirName {
    NSString *directoryPath = [self getDirectoryPath];
    NSString *savePath = [directoryPath stringByAppendingPathComponent:dirName];
    return savePath;
}


#pragma mark - File manager(Public)


#pragma mark - Clear operation(Public)

+ (BOOL)clearAllCaches {
    return [self clearCacheWithDirName:nil pathHandler:^NSString *(NSString *name) {
        return [self getDirectoryPath];
    }];
}

+ (BOOL)clearCacheWithDirName:(NSString *)dirName {
    return [self clearCacheWithDirName:dirName pathHandler:^NSString *(NSString *name) {
        return [self getSandboxPathWithDirName:dirName];
    }];
}

+ (BOOL)clearCacheWithDirName:(NSString *)dirName pathHandler:(NSString *(^)(NSString *))pathHandler {
    NSString *dirPath = pathHandler(dirName);
    return [self clearCacheWithPath:dirPath];
}

+ (BOOL)clearCacheWithPath:(NSString *)path {
    return [[DSDownloadManager manager] clearCacheWithPath:path];
}

- (BOOL)clearCacheWithPath:(NSString *)path {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = YES;
    if ([fileManager fileExistsAtPath:path]) {
        flag = [fileManager removeItemAtPath:path error:&error];
        if (flag && [NSThread currentThread] == [NSThread mainThread]) {
//            [FGThemeManager shiftSakuraWithName:FGThemeDefault type:FGThemeTypeMainBundle];
        }
    }
#ifdef DEBUG
    NSLog(@"clearCacheWithName error:%@", error);
#endif
    return flag;
}

#pragma mark - Block download operation(Public)

- (NSURLSessionDownloadTask *)downloadWithInfos:(id<DSDownloadProtocol>)infos
                                  downloadProgressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                                     downloadErrorHandler:(DSDownloadErrorHandler)downloadErrorHandler
                                     unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
                                         completedHandler:(DSDownloadCompletedHandler)completedHandler {
    DSDownloadTaskStatus status;
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadWithInfos:infos status:&status];
    switch (status) {
        case DSDownloadTaskStatusAlreadyExist:{
            if (downloadErrorHandler) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@(status) forKey:@"status"];
                [userInfo setValue:downloadTask forKey:@"task"];
                downloadErrorHandler([NSError errorWithDomain:@"This task already exist!" code:0 userInfo:userInfo]);
            }
        }
            break;
        case DSDownloadTaskStatusDownloading:{
            if (downloadErrorHandler) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@(status) forKey:@"status"];
                [userInfo setValue:downloadTask forKey:@"task"];
                downloadErrorHandler([NSError errorWithDomain:@"This task is downloading!" code:0 userInfo:userInfo]);
            }
        }
            break;
            
        default:
            break;
    }
    if (downloadTask) {
        DSDownloadTaskDelegateWrapper *delegateWrapper = [DSDownloadTaskDelegateWrapper wrapperWithManager:self sakuraDownloadInfos:infos progressHandler:downloadProgressHandler errorHandler:downloadErrorHandler unzipProgressHandler:unzipProgressHandler completedHandler:completedHandler];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)] = delegateWrapper;
    }
    return downloadTask;
}

#pragma mark - Delegate download operation(Public)

- (NSURLSessionDownloadTask *)downloadWithInfos:(id<DSDownloadProtocol>)infos
                                                 delegate:(id<DSDownloadDelegate>)delegate {
    DSDownloadTaskStatus status;
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadWithInfos:infos status:&status];
    switch (status) {
        case DSDownloadTaskStatusAlreadyExist:{
            if (delegate && [delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:status:)]) {
                [delegate sakuraManagerDownload:self downloadTask:nil status:DSDownloadTaskStatusAlreadyExist];
            }
        }
            break;
        case DSDownloadTaskStatusDownloading:{
            if (delegate && [delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:status:)]) {
                [delegate sakuraManagerDownload:self downloadTask:downloadTask status:DSDownloadTaskStatusDownloading];
            }
        }
            break;
            
        default:
            break;
    }
    if (downloadTask) {
        DSDownloadTaskDelegateWrapper *delegateWrapper = [DSDownloadTaskDelegateWrapper wrapperWithManager:self delegate:delegate sakuraDownloadInfos:infos];
        self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)] = delegateWrapper;
    }
    return downloadTask;
}

#pragma mark - Download cancel operation(Public)

- (void)cancelDownloadTaskWithURLStr:(NSString *)URLStr {
    if (URLStr || !URLStr.length || !_sakuraDownloadTaskCache) return;
    NSURLSessionDownloadTask *downloadTask = [_sakuraDownloadTaskCache objectForKey:URLStr];
    [self cancelDownloadTask:downloadTask];
}

- (void)cancelDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    if (!downloadTask || !_sakuraDownloadTaskCache) return;
    [downloadTask cancel];
    NSString *key = downloadTask.originalRequest.URL.absoluteString;
    if (key) {
        [_sakuraDownloadTaskCache removeObjectForKey:key];
    }
    [self _removeSakuraHandlersWithDownloadTask:downloadTask];
}

- (void)cancelAllDownloadTask {
    [[_sakuraDownloadTaskCache copy] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURLSessionDownloadTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
        [_sakuraDownloadTaskCache removeObjectForKey:key];
    }];
    [self _removeSakuraAllHandlers];
}

#pragma mark - Private

#pragma mark - Local sakura path operation(Private)

+ (NSString *)_getLibraryPath {
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

// Sakura/[folderName]/[zipFileName.zip]
+ (NSString *)_getZipFileSandboxPathWithDirName:(NSString *)dirName fileName:(NSString *)fileName {
    NSString *fileFullName = [fileName stringByAppendingPathExtension:kDSDownloadFileExtensionZIP];
    NSString *zipFilePath = [[self getSandboxPathWithDirName:dirName] stringByAppendingPathComponent:fileFullName];
    return zipFilePath;
}

// zipFileName
+ (NSString *)_getZipFileNameWithInfos:(id<DSDownloadProtocol>)infos {
    if (infos.zipName.length) return infos.zipName;
    return @"temp";
}

// dirName
+ (NSString *)_getDirNameWithInfos:(id<DSDownloadProtocol>)infos {
    if (infos.dirName.length) return infos.dirName;
    return [[infos.remoteURL lastPathComponent] stringByDeletingPathExtension];
}


// Sakura/[folderName]
+ (NSString *)_getDirPathWithInfos:(id<DSDownloadProtocol>)infos {
    NSString *dirName = [self _getDirNameWithInfos:infos];
    return [self getSandboxPathWithDirName:dirName];
}

#pragma mark - File manager(Private)
+ (BOOL)_fileExistsAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

/**
 文件遍历
 @param path 目录的绝对路径
 @param deep 是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
                       2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 @return 遍历结果数组
 */
+ (NSArray *)_listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}





#pragma mark - Delegate download operation(Private)

- (NSURLSessionDownloadTask *)_sakuraDownloadWithInfos:(id<DSDownloadProtocol>)infos
                                                 status:(DSDownloadTaskStatus *)status {
    NSURL *url = [NSURL URLWithString:infos.remoteURL];
    // URL not exist!
    if (!url) return nil;
    // Sakura do not exist in local ?
    NSString *dirPath = [DSDownloadManager _getDirPathWithInfos:infos];
    BOOL isAlreadyExist = NO;
    NSArray *subpathsOfDir = [DSDownloadManager _listFilesInDirectoryAtPath:dirPath deep:NO];
    if (subpathsOfDir.count) {
        isAlreadyExist = YES;
    }
    // Is alreadying download ?
    BOOL isDownloading = [_sakuraDownloadTaskCache.allKeys containsObject:infos.remoteURL];
    // Status changing.
    if (isAlreadyExist) {
        *status = DSDownloadTaskStatusAlreadyExist;
        return nil;
    }
    if (isDownloading) {
        NSURLSessionDownloadTask *downloadTask = [_sakuraDownloadTaskCache objectForKey:infos.remoteURL];
        *status = DSDownloadTaskStatusDownloading;
        return downloadTask;
    }
    // Create & Start.
    NSURLSessionDownloadTask *downloadTask = [self _sakuraDownloadTaskWithURL:url];
    return downloadTask;
}

- (NSURLSession *)session {
    NSURLSession *urlSession = objc_getAssociatedObject(self, _cmd);
    if (urlSession) return urlSession;
    @synchronized(self) {
        NSURLSessionConfiguration *congfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:congfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        objc_setAssociatedObject(self, _cmd, session, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        urlSession = session;
    }
    return urlSession;
}

- (NSURLSessionDownloadTask *)_sakuraDownloadTaskWithURL:(NSURL *)url {
    if (!url) return nil;
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url];
    [downloadTask resume];
    NSString *key = url.absoluteString;
    if (key) {
        [_sakuraDownloadTaskCache setObject:downloadTask forKey:key];
    }
    return downloadTask;
}


#pragma mark - NSLock operation(Private)

- (DSDownloadTaskDelegateWrapper *)_getSakuraDownloadTaskDelegateWrapperWithTask:(NSURLSessionTask *)task {
    DSDownloadTaskDelegateWrapper *delegateWrapper = nil;
    [self.lock lock];
    delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)];
    [self.lock unlock];
    return delegateWrapper;
}

- (void)_setSakuraDownloadTaskDelegateWrapper:(DSDownloadTaskDelegateWrapper *)delegateWrapper
                                      forTask:(NSURLSessionTask *)task {
    [self.lock lock];
    self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)] = delegateWrapper;
    [self.lock unlock];
}

- (void)_removeSakuraDownloadTaskDelegateWrapperForTask:(NSURLSessionTask *)task {
    [self.lock lock];
    [self.sakuraDownloadTaskDelegateWrappersByIdentifier removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

- (void)_removeAllSakuraDownloadTaskDelegateWrapper {
    [self.lock lock];
    [self.sakuraDownloadTaskDelegateWrappersByIdentifier removeAllObjects];
    [self.lock unlock];
}

#pragma mark - Download cancel operation(Private)

- (void)_removeSakuraHandlersWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self _removeSakuraDownloadTaskDelegateWrapperForTask:downloadTask];
    if (!_sakuraDownloadTaskCache.allKeys.count) {
        [self _sessionInvalidateAndCancel];
    }
}

- (void)_removeSakuraAllHandlers {
    [self _removeAllSakuraDownloadTaskDelegateWrapper];
    [self _sessionInvalidateAndCancel];
}

- (void)_sessionInvalidateAndCancel {
    NSURLSession *session = [self session];
    [session invalidateAndCancel];
    objc_setAssociatedObject(self, @selector(session), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 Create a concurrent queue for SakuraKit
 */
static dispatch_queue_t _getSakuraBackgroundQueue(void)
{
    static dispatch_once_t onceToken;
    static dispatch_queue_t backgroundQueue = nil;
    dispatch_once(&onceToken, ^{
        /** backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); */
        backgroundQueue = dispatch_queue_create("tingxins.SakuraKit.Queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return backgroundQueue;
}

#pragma mark - Custom operation


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (error) {
        DSDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(task.taskIdentifier)];
        if (delegateWrapper) {
            [delegateWrapper URLSession:session task:task didCompleteWithError:error];
        }
    }
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (!location) return;
    DSDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)];
    if (delegateWrapper) {
        [delegateWrapper URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    DSDownloadTaskDelegateWrapper *delegateWrapper = self.sakuraDownloadTaskDelegateWrappersByIdentifier[@(downloadTask.taskIdentifier)];
    if (delegateWrapper) {
        [delegateWrapper URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
}

@end

/************************************************************************************************************/

@implementation DSDownloadTaskDelegateWrapper

- (instancetype)initWithManager:(DSDownloadManager  *)manager delegate:(id<DSDownloadDelegate>)delegate sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos {
    if (self = [super init]) {
        self.manager = manager;
        self.delegate = delegate;
        self.sakuraDownloadInfos = sakuraDownloadInfos;
    }
    return self;
}

- (instancetype)initWithManager:(DSDownloadManager  *)manager
            sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos
                progressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                   errorHandler:(DSDownloadErrorHandler)errorHandler
           unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
               completedHandler:(DSDownloadCompletedHandler)completedHandler {
    if (self = [super init]) {
        self.manager = manager;
        self.sakuraDownloadInfos = sakuraDownloadInfos;
        self.downloadProgressHandler = downloadProgressHandler;
        self.downloadErrorHandler = errorHandler;
        self.unzipProgressHandler = unzipProgressHandler;
        self.completedHandler = completedHandler;
    }
    return self;
}

+ (instancetype)wrapperWithManager:(DSDownloadManager  *)manager delegate:(id<DSDownloadDelegate>)delegate sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos {
    return [[self alloc] initWithManager:manager delegate:delegate sakuraDownloadInfos:sakuraDownloadInfos];
}

+ (instancetype)wrapperWithManager:(DSDownloadManager  *)manager
               sakuraDownloadInfos:(id<DSDownloadProtocol>)sakuraDownloadInfos
                   progressHandler:(DSDownloadProgressHandler)downloadProgressHandler
                      errorHandler:(DSDownloadErrorHandler)errorHandler
              unzipProgressHandler:(AMENUnzipProgressHandler)unzipProgressHandler
                  completedHandler:(DSDownloadCompletedHandler)completedHandler{
    return [[self alloc] initWithManager:manager
                     sakuraDownloadInfos:sakuraDownloadInfos
                         progressHandler:downloadProgressHandler
                            errorHandler:errorHandler
                    unzipProgressHandler:unzipProgressHandler
                        completedHandler:completedHandler];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    if (!error) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:sessionTask:didCompleteWithError:)]) {
        [self.delegate sakuraManagerDownload:self.manager sessionTask:task didCompleteWithError:error];
    }else {
        if (self.downloadErrorHandler) {
            self.downloadErrorHandler(error);
        }
        
        NSString *key = task.originalRequest.URL.absoluteString;
        if (key) {
            [self.manager.sakuraDownloadTaskCache removeObjectForKey:key];
        }
        [self.manager _removeSakuraHandlersWithDownloadTask:(NSURLSessionDownloadTask *)task];
    }
}

/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    if (!location) return;

    NSString *dirPath = [DSDownloadManager _getDirPathWithInfos:self.sakuraDownloadInfos];
    [self.manager clearCacheWithPath:dirPath];
    
#ifdef DEBUG
    NSLog(@"locationPath:%@", location.path);
    NSLog(@"dirPath:%@", dirPath);
#endif
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL flag = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!flag) return;
    
    error = nil;

    NSString *dirName = [DSDownloadManager _getDirNameWithInfos:self.sakuraDownloadInfos];
    NSString *zipFileName = [DSDownloadManager _getZipFileNameWithInfos:self.sakuraDownloadInfos];
    NSString *toFilePath = [DSDownloadManager _getZipFileSandboxPathWithDirName:dirName fileName:zipFileName];
    flag = [fileManager moveItemAtPath:location.path toPath:toFilePath error:&error];
    
    if (error) { }
    
    if (!flag) return;
    
    if (self.delegate) {
        [self _unzipSakuraFileAtPath:toFilePath toDestination:dirPath downloadTask:downloadTask];
    }else {
        [self _unzipSakuraFileBlockHandlerAtPath:toFilePath toDestination:dirPath downloadTask:downloadTask];
    }
}

/* Sent periodically to notify the delegate of download progress. */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    /*
    问题
    Q:totalBytesExpectedToWrite 值为-1
    A:downloadTask中的response中返回的content length 参数没有。所以才导致了无法获取下载文件的总大小问题。可打印downloadTask.response查看
     */
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)])
    {
        [self.delegate sakuraManagerDownload:self.manager
                           downloadTask:downloadTask
                           didWriteData:bytesWritten
                      totalBytesWritten:totalBytesWritten
              totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }else {
        if (self.downloadProgressHandler) {
            self.downloadProgressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }
}

/* Sent when a download has been resumed. If a download failed with an
 * error, the -userInfo dictionary of the error will contain an
 * NSURLSessionDownloadTaskResumeData key, whose value is the resume
 * data.
 */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:didResumeAtOffset:expectedTotalBytes:)]) {
        [self.delegate sakuraManagerDownload:self.manager
                           downloadTask:downloadTask
                      didResumeAtOffset:fileOffset
                     expectedTotalBytes:expectedTotalBytes];
    }
}



#pragma mark - Delegate download operation(Private)

- (void)_unzipSakuraFileAtPath:(NSString *)toFilePath
                 toDestination:(NSString *)destination
                  downloadTask:(NSURLSessionDownloadTask *)downloadTask{
    
    dispatch_async(_getSakuraBackgroundQueue(), ^{
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:toFilePath error:nil];
        __block unsigned long long fileSize = [fileAttributes[NSFileSize] unsignedLongLongValue];
        __block unsigned long long currentPosition = 0;
        BOOL isSuccess = [SSZipArchive unzipFileAtPath:toFilePath toDestination:destination progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            currentPosition += zipInfo.compressed_size;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:progressEvent:total:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                       downloadTask:downloadTask
                                      progressEvent:currentPosition
                                              total:fileSize];
                }
            });
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:progressEvent:total:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                       downloadTask:downloadTask
                                      progressEvent:fileSize
                                              total:fileSize];
                }
            });
        }];
        
        if (isSuccess) {
            [DSDownloadManager formatSakuraPath:destination cleanCachePath:toFilePath];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                NSURL *sakuraPathURL = [NSURL fileURLWithPath:destination];
                if (sakuraPathURL && [self.delegate respondsToSelector:@selector(sakuraManagerDownload:downloadTask:sakuraInfos:didFinishDownloadingToURL:)]) {
                    [self.delegate sakuraManagerDownload:self.manager
                                            downloadTask:downloadTask
                                             sakuraInfos:self.sakuraDownloadInfos
                               didFinishDownloadingToURL:sakuraPathURL];
                }
            }
            
            [self.manager cancelDownloadTask:downloadTask];
        });
    });
    
}

#pragma mark - Block download operation(Private)

- (void)_unzipSakuraFileBlockHandlerAtPath:(NSString *)toFilePath
                             toDestination:(NSString *)destination
                              downloadTask:(NSURLSessionDownloadTask *)downloadTask{
    dispatch_async(_getSakuraBackgroundQueue(), ^{
        
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:toFilePath error:nil];
        __block unsigned long long fileSize = [fileAttributes[NSFileSize] unsignedLongLongValue];
        __block unsigned long long currentPosition = 0;
        BOOL isSuccess = [SSZipArchive unzipFileAtPath:toFilePath toDestination:destination progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            currentPosition += zipInfo.compressed_size;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.unzipProgressHandler) {
                    self.unzipProgressHandler(currentPosition, fileSize);
                }
            });
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.unzipProgressHandler) {
                    self.unzipProgressHandler(fileSize, fileSize);
                }
            });
        }];
        
        if (isSuccess) {
            // 删除zip文件
            [DSDownloadManager formatSakuraPath:destination cleanCachePath:toFilePath];
        }
        if (isSuccess) {
            NSURL *sakuraPathURL = [NSURL fileURLWithPath:destination];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.completedHandler) {
                    self.completedHandler(self.sakuraDownloadInfos, sakuraPathURL);
                }
                [self.manager cancelDownloadTask:downloadTask];
            });
        }
    });
}

@end
