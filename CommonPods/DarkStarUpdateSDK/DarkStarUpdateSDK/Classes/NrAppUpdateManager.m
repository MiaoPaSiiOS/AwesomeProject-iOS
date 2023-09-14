//
//  NrAppUpdateManager.m
//  IU_UpdateSDK
//
//

#import "NrAppUpdateManager.h"

#import "NrUpdateUtils.h"
#import "NrAppUpdateManager.h"
#import "NrAppUpdateConfig.h"
#import "NrUpdateNetworkReachabilityManager.h"
#import <WebKit/WebKit.h>

#import "NrAppUpdateResponseModel.h"

static NSString * const NrAppUpdateServerUrl = @"dmz/appupdate/appupdate.do";

static NSString * const NrAppUpdateResponseCode = @"code";
static NSString * const NrAppUpdateResponseVersion = @"version";
static NSString * const NrAppUpdateResponsePriority = @"priority";
static NSString * const NrAppUpdateResponseDescription = @"description";
static NSString * const NrAppUpdateResponseDownloadUrl = @"downloadUrl";
static NSString * const NrAppUpdateResponsePlistUrl = @"plistUrl";
static NSString * const NrAppUpdateResponseiosPlistUrl = @"iospListUrl";

@interface NrAppUpdateManager ()

@property (nonatomic, strong) NrAppUpdateConfig *config;

@end

@implementation NrAppUpdateManager

+ (instancetype)share
{
    static NrAppUpdateManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NrAppUpdateManager alloc] init];
    });
    return _instance;
}

- (void)addObserverOfNetWorkReachabilityChange
{
    //这里是监听网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkReachabilityChanged:) name:LdzfUpdateNetworkReachabilityDidChangeNotification object:nil];
}

- (void)checkNetworkReachabilityChanged:(NSNotification *)notification
{
    BOOL status = [[NrUpdateNetworkReachabilityManager sharedManager] isReachable];

    if (status)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:LdzfUpdateNetworkReachabilityDidChangeNotification object:nil];
        [[NrUpdateNetworkReachabilityManager sharedManager] stopMonitoring];

        [self checkAppUpdate:self.config];
    }
}

- (void)checkAppUpdate:(NrAppUpdateConfig *)config
{
    [self checkAppUpdate:config success:nil failture:nil];
}

- (void)checkAppUpdate:(NrAppUpdateConfig *)config
               success:(AppUpdateCallback _Nullable)successCallback
              failture:(AppUpdateCallback _Nullable)failtureCallback
{
    self.config = config;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    params[NrAppUpdateEModelKey] = config.e_model;
    params[NrAppUpdateEVersionKey] = config.e_version;
    params[NrAppUpdateAppIdKey] = config.appId;
    params[NrAppUpdateAppVersionKey] = config.appVersion;
    params[NrAppUpdateOsKey] = config.os;
    params[NrAppUpdateOsVersionKey] = config.osVersion;

    NSString *host = config.host;
    NSString *URLString = [NSString stringWithFormat:@"%@/%@", host, NrAppUpdateServerUrl];

    NSLog(@"params = %@, url = %@", params, URLString);

    NSURL *url = [NSURL URLWithString:URLString];
    NSData *bodyData = [[NrUpdateUtils stringWithObject:params] dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];

    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:bodyData];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSLog(@"response ============ %@ /n error ============ %@",response,error);
        if (error)
        {
            [[NrUpdateNetworkReachabilityManager sharedManager] startMonitoring];
            [self addObserverOfNetWorkReachabilityChange];
            NSLog(@"NrAppUpgradeError->%@", error.localizedDescription);
            if (failtureCallback) {
                NrAppUpdateResponseModel *model = [[NrAppUpdateResponseModel alloc] init];
                model.errMsg = error.localizedDescription;
                failtureCallback(model);
            }
        }
        else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *response = [NrUpdateUtils objectFromJsonString:jsonString];
            NSLog(@"jsonString %@",jsonString);
            NSString *code = [response objectForKey:@"code"];
            id data = [response objectForKey:@"data"];
            if([code isEqualToString:@"000000"] && data && [data isKindOfClass:[NSDictionary class]])
            {
                [self handleResponse:data];
                
                if (successCallback) {
                    NrAppUpdateResponseModel *model = [[NrAppUpdateResponseModel alloc] init];
                    model.errMsg = nil;
                    model.code = [data[NrAppUpdateResponseCode] integerValue];
                    model.msg = data[@"msg"];
                    model.priority = data[NrAppUpdateResponsePriority];
                    model.downloadUrl = data[NrAppUpdateResponseDownloadUrl];
                    model.md5 = data[@"md5"];
                    model.size = data[@"size"];
                    model.version = data[NrAppUpdateResponseVersion];
                    model.descMsg = data[NrAppUpdateResponseDescription];
                    model.iospListUrl = data[NrAppUpdateResponseiosPlistUrl];
                    successCallback(model);
                }
            }else if (failtureCallback) {
                NSString *msg = [response objectForKey:@"msg"];
                NrAppUpdateResponseModel *model = [[NrAppUpdateResponseModel alloc] init];
                model.errMsg = msg;
                failtureCallback(model);
            }
        }

    }] resume] ;
}

- (void)handleResponse:(NSDictionary *)response
{
    
    if (!response || response.count <= 0) return;

    NSInteger responseCode = [response[NrAppUpdateResponseCode] integerValue];

    if (responseCode == 20)
    {
        NSLog(@"NrAppUpgradeError-> 升级网络结果 - 出错");
        return;
    }
    
    [self showUpdateAlertWithResponse:response];

    NSLog(@"NrAppUpgrade-> 升级网络结果 - 完成");
}

- (void)showUpdateAlertWithResponse:(NSDictionary *)response
{
    NSNumber *priority = response[NrAppUpdateResponsePriority];

    if ([priority integerValue] == 0)
    {
        return;
    }
    
    //弹出框
    [self showAlert:response];
}

//弹出提示框
- (void)showAlert:(NSDictionary *)response
{
    NSNumber *priority = response[NrAppUpdateResponsePriority];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideKeyBoard];

        NSString *description = response[NrAppUpdateResponseDescription];
        if(description == nil || description.length == 0)
        {
            description = @"升级描述";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:description preferredStyle:UIAlertControllerStyleAlert];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *confrim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf gotoUpdateApp:response];
        }];
        
        if([priority intValue] == 1)
        {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alertController addAction:cancel];
        }
        
        [alertController addAction:confrim];
        
        UIWindow *window;
        if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]
            && [UIApplication sharedApplication].delegate.window != nil) {
            window = [[UIApplication sharedApplication].delegate window];
        }else{
            window = [UIApplication sharedApplication].keyWindow;
        }
        
        UIViewController *parentUpdateViewController = window.rootViewController;
        [parentUpdateViewController presentViewController:alertController animated:YES completion:nil];
    });
}

//跳转升级页面
- (void)gotoUpdateApp:(NSDictionary *)response
{
    NSString *urlStr = response[NrAppUpdateResponseiosPlistUrl];
    NSURL *URL = [NSURL URLWithString:urlStr];
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %d",success);
        }];
    } else {
        // Fallback on earlier versions
        if ([application canOpenURL:URL]) {
            [application openURL:URL];
        }
    }
    
    NSNumber *priority = response[NrAppUpdateResponsePriority];
    if([priority intValue] != 1)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showUpdateAlertWithResponse:response];
        });
    }
}

//限制键盘的弹出
- (void)hideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

- (BOOL)dismissAllKeyBoardInView:(UIView *)view
{
    if ([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }

    for (UIView *subView in view.subviews)
    {
        if ([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }

    return NO;
}

@end

