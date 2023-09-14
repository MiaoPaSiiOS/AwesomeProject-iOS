//
//  HJReachability.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import "HJReachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
/**
 *  网络状态更新
 */
NSString *const NotificationNetworkStatusChange = @"NotificationNetworkStatusChange";
/**
 *  有网络
 */
NSString *const NotificationNetworkStatusReachable = @"NotificationNetworkStatusReachable";

@interface HJReachability()

@property (nonatomic, assign) ENetWorkStatus lastNetStatus;

@end

@implementation HJReachability
//DEF_SINGLETON(HJReachability)

+ (instancetype)sharedInstance {
    static HJReachability *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}
- (instancetype)init
{
    if (self = [super init]) {
        kWeakSelf;
        self.currentNetStatus = kConnectToInit;
//        if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
//            [NSNotificationCenter.defaultCenter addObserverForName:CTRadioAccessTechnologyDidChangeNotification
//                                                            object:nil
//                                                             queue:[NSOperationQueue mainQueue]
//                                                        usingBlock:^(NSNotification *note)
//             {
////                 Weak2Strong;
////                 NSString *status = note.object;
////                 [self dealWithCT:status];
//             }];
//        }
        
        [NSNotificationCenter.defaultCenter addObserverForName:AFNetworkingReachabilityDidChangeNotification
                                                        object:nil
                                                         queue:[[NSOperationQueue alloc] init]
                                                    usingBlock:^(NSNotification *note)
         {
             kStrongSelf;
             NSNumber *item = note.userInfo[AFNetworkingReachabilityNotificationStatusItem];
             AFNetworkReachabilityStatus status = (AFNetworkReachabilityStatus)item.intValue;
             [strongSelf dealWithReachabilityStatus:status];
         }];
        
        _manager = [AFNetworkReachabilityManager sharedManager];
        [_manager startMonitoring];
    }
    return self;
}

- (void)dealloc
{
    [self.manager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)generateNetStatus
{
    //new telephonyInfo will post a notification CTRadioAccessTechnologyDidChangeNotification
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
        [self dealWithCT:telephonyInfo.currentRadioAccessTechnology];
    }
}

- (void)dealWithCT:(NSString *)status
{
    //2g,2.5g
    if ([status isEqualToString:CTRadioAccessTechnologyGPRS] ||
        [status isEqualToString:CTRadioAccessTechnologyEdge]) {
        self.currentNetStatus = kConnectTo2G;
        self.currentNetStatusForTracker = @"2g";
    }
    //3g
    else if ([status isEqualToString:CTRadioAccessTechnologyWCDMA] ||
             [status isEqualToString:CTRadioAccessTechnologyHSDPA] ||
             [status isEqualToString:CTRadioAccessTechnologyHSUPA] ||
             [status isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
             [status isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
             [status isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
             [status isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
             [status isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        self.currentNetStatus = kConnectTo3G;
        self.currentNetStatusForTracker = @"3g";
    }
    //4g
    else if ([status isEqualToString:CTRadioAccessTechnologyLTE]){
        self.currentNetStatus = kConnectTo4G;
        self.currentNetStatusForTracker = @"4g";
    }
    else {
        self.currentNetStatus = kConnectToNull;
        self.currentNetStatusForTracker = @"无网";
    }
    
    [self dealWithReachabilityStatus:self.manager.networkReachabilityStatus];
}

- (void)dealWithReachabilityStatus:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            self.currentNetStatus = kConnectToNull;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_7_0) {
                self.currentNetStatus = kConnectToWWAN;
            }
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            self.currentNetStatus = kConnectToWifi;
            break;
        default: {
            break;
        }
    }
    
    if (self.lastNetStatus != self.currentNetStatus) {
        self.lastNetStatus = self.currentNetStatus;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNetworkStatusChange
                                                            object:nil
                                                          userInfo:nil];
    }
}
#warning 注释
//- (BOOL)isConnectedToNet
//{
//    return (self.currentNetStatus & kConnectToAny);
//}

- (BOOL)isConnectedToNet
{
    return self.currentNetStatus != kConnectToNull; // (self.currentNetStatus & kConnectToAny);
}

+ (BOOL)isConnectedToNetWork
{
    return [[self sharedInstance] isConnectedToNet];
}

+ (BOOL)isWiFiConnected
{
    return [HJReachability sharedInstance].currentNetStatus == kConnectToWifi;
}



@end
