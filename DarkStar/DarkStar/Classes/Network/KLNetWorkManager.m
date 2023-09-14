//
//  KLNetWorkManager.m
//  AmenCore
//
//  Created by zhuyuhui on 2021/6/16.
//

#import "KLNetWorkManager.h"

@interface KLNetWorkManager()
/// sessionManager
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) KLRequestGenerator *requestGenerator;
@property (nonatomic, strong) NSMutableArray *allSessionTask;
@end

@implementation KLNetWorkManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KLNetWorkManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

- (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}
#pragma mark - Interface
-(NSString *)methodName:(AmenNetworkRequestType)requestType{
    NSString *method = @"";
    switch (requestType) {
        case AmenNetworkRequestTypeGET:
            method = @"GET";
            break;
        case AmenNetworkRequestTypePOST:
            method = @"POST";
            break;
        case AmenNetworkRequestTypePUT:
            method = @"PUT";
            break;
        case AmenNetworkRequestTypePATCH:
            method = @"PATCH";
            break;
        case AmenNetworkRequestTypeDELETE:
            method = @"DELETE";
            break;
        default:
            break;
    }
    return method;
}

#pragma mark - base dataTask
- (NSURLSessionDataTask *)dataTaskWithRequest:(KLRequest *)requestModel
                            completionHandler:(AmenCompletionHandler)completionHandler
{
    return [self dataTaskWithRequest:requestModel uploadProgressBlock:nil downloadProgressBlock:nil completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(KLRequest *)requestModel
                          uploadProgressBlock:(AmenHttpProgress)uploadProgressBlock
                        downloadProgressBlock:(AmenHttpProgress)downloadProgressBlock
                            completionHandler:(AmenCompletionHandler)completionHandler
{
    NSMutableURLRequest *request = [self.requestGenerator generateRequestWithRequest:requestModel];
    
    __block NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:task];

        if (error) {
            NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
            [self HTTPRequestLog:task body:requestModel.params error:parseError];
            /// 解析参数
            KLResponse *ojbkResponse = [[KLResponse alloc] initWithResponseObject:responseObject parseError:parseError];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(ojbkResponse);
                }
            });

        } else {
            [self HTTPRequestLog:task body:requestModel.params error:nil];
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *status = [responseObject objectForKey:@"code"];
                if (status.intValue == 99) {
                    [self tokenExpireHandle];
                }
            }

            /// 解析参数
            KLResponse *ojbkResponse = [[KLResponse alloc] initWithResponseObject:responseObject parseError:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(ojbkResponse);
                }
            });
        }
    }];
    
    // 添加sessionTask到数组
    task ? [[self allSessionTask] addObject:task] : nil ;
    [task resume];
    return task;
}

//下载
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(KLRequest *)requestModel
                                             progress:(AmenHttpProgress)downloadProgressBlock
                                          destination:(AmenDownloadDestination)destination
                                    completionHandler:(AmenDownloadCompletionHandler)completionHandler
{
    
    NSMutableURLRequest *request = [self.requestGenerator generateDownloadRequestWithRequest:requestModel];
        
    __block NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (downloadProgressBlock) {
                downloadProgressBlock(downloadProgress);
            }
        });

        KLNetLog(@"totalUnitCount:%lld  completedUnitCount: %lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (destination) {
            return destination(targetPath,response);
        }
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allSessionTask] removeObject:task];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler(response,filePath,error);
            }
        });

        KLNetLog(@"File downloaded to: %@", filePath);
    }];
    // 添加sessionTask到数组
    task ? [[self allSessionTask] addObject:task] : nil ;
    [task resume];
    return task;

}

//上传
- (NSURLSessionDataTask *)uploadDataWithRequest:(KLRequest *)requestModel
                            uploadProgressBlock:(AmenHttpProgress)uploadProgressBlock
                              completionHandler:(AmenCompletionHandler)completionHandler
{
    
    NSMutableURLRequest *request = [self.requestGenerator generateUploadRequestWithRequest:requestModel];

    __block NSURLSessionDataTask *task = [self.sessionManager uploadTaskWithStreamedRequest:request progress:uploadProgressBlock completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:task];

        if (error) {
            NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response responseObject:responseObject error:error];
            [self HTTPRequestLog:task body:requestModel.params error:parseError];
            /// 解析参数
            KLResponse *ojbkResponse = [[KLResponse alloc] initWithResponseObject:responseObject parseError:parseError];
            if (completionHandler) {
                completionHandler(ojbkResponse);
            }
        } else {
            [self HTTPRequestLog:task body:requestModel.params error:nil];
            /// 解析参数
            KLResponse *ojbkResponse = [[KLResponse alloc] initWithResponseObject:responseObject parseError:nil];
            if (completionHandler) {
                completionHandler(ojbkResponse);
            }
        }
    }];
    
    // 添加sessionTask到数组
    task ? [[self allSessionTask] addObject:task] : nil ;
    [task resume];
    return task;
}

#pragma mark - Error Handling
/// 请求错误解析
- (NSError *)_errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse responseObject:(NSDictionary *)responseObject error:(NSError *)error {
    NSInteger HTTPCode = httpResponse.statusCode;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode > 0) {
        if (httpFirstCode == 4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(408)~";
#else
                errorDesc = @"请求超时，请稍后再试~";
#endif
            }else{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",HTTPCode];
#else
                errorDesc = @"请求出错了，请稍后重试~";
#endif
            }
        } else if (httpFirstCode == 5 || httpFirstCode == 6){
            /// 服务器出错了，请稍后重试
#if defined(DEBUG)||defined(_DEBUG)
            errorDesc = [NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",HTTPCode];
#else
            errorDesc = @"服务器出错了，请稍后重试~";
#endif
            
        } else if (!self.sessionManager.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    } else {
        if (!self.sessionManager.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    
    /// 从error中解析
    if ([error.domain isEqual:NSURLErrorDomain]) {
#if defined(DEBUG)||defined(_DEBUG)
        errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",error.code];
#else
        errorDesc = @"请求出错了，请稍后重试~";
#endif
        switch (error.code) {
            case NSURLErrorSecureConnectionFailed:
            case NSURLErrorServerCertificateHasBadDate:
            case NSURLErrorServerCertificateHasUnknownRoot:
            case NSURLErrorServerCertificateUntrusted:
            case NSURLErrorServerCertificateNotYetValid:
            case NSURLErrorClientCertificateRejected:
            case NSURLErrorClientCertificateRequired:
                break;
            case NSURLErrorTimedOut:{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(-1001)~";
#else
                errorDesc = @"请求超时，请稍后再试~";
#endif
                break;
            }
            case NSURLErrorNotConnectedToInternet:{
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"网络开小差了，请稍后重试(-1009)~";
#else
                errorDesc = @"网络开小差了，请稍后重试~";
#endif
                break;
            }
        }
    }

    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithDictionary:error.userInfo];
    dict[NSLocalizedDescriptionKey] = errorDesc;
    return [NSError errorWithDomain:error.domain code:error.code userInfo:dict];
}

#pragma mark - 打印请求日志
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:(NSDictionary *)params error:(NSError *)error {
//    KLNetLog(@">>>>👇 REQUEST FINISH 👇>>>>>>>>");
//    KLNetLog(@"Request%@=======>:%@", error?@"失败":@"成功", task.currentRequest.URL.absoluteString);
//    KLNetLog(@"requestBody======>:%@", params);
//    KLNetLog(@"requstHeader=====>:%@", task.currentRequest.allHTTPHeaderFields);
//    KLNetLog(@"response=========>:%@", task.response);
//    KLNetLog(@"error============>:%@", error);
//    KLNetLog(@"<<<<👆 REQUEST FINISH 👆<<<<<<<<");
}

#pragma mark - token过期
- (void)tokenExpireHandle {
    dispatch_async(dispatch_get_main_queue(), ^{
        [RELoginUtil loginFromVC:[self ds_topViewController] dealResult:^(BOOL isSuccess) {
        
        }];
//        NSArray * views = [UIApplication sharedApplication].keyWindow.subviews;
//        for (UIView * subView in views) {
//            if ([subView isKindOfClass:[REAlertView class]]) {
//                return;
//            }
//        }
//
//        REAlertView *alertView = [[REAlertView alloc]initWithTitle:XPLocalizedString(@"当前未登录，请登录", nil) message:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        [alertView setSelctBtnBlock:^(NSInteger index, NSString * _Nullable btnCurrentTitle) {
//            [[REUser sharedMemory] logOut];
//            if (index == 1) {
//                [[PhoneRouter singletonInstance] routerWithUrlString:[NSString getRouterVCUrlStringFromUrlString:kQuickLogin  andParams:nil] navigationController:[REGlobal sharedInstance].globalNavC];
//            }
//        }];
//        [alertView show];
    });
}


#pragma mark - getter && setter
- (AFHTTPSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = self.requestGenerator.requestSerialize;
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"application/javascript", @"text/plain", @"text/json", @"application/x-javascript",@"text/javascript",@"application/octet-stream",nil];
    }
    
    return _sessionManager;
}

- (KLRequestGenerator *)requestGenerator {
    if (!_requestGenerator) {
        _requestGenerator = [[KLRequestGenerator alloc] init];
    }
    return _requestGenerator;
}

- (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

@end
