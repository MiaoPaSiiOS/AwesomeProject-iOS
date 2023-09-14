//
//  HJReachability.h
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2015年 ihome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
typedef NS_ENUM(NSInteger, ENetWorkStatus) {
    kConnectToNull = 0,
    kConnectTo2G   = 1 << 0,
    kConnectTo3G   = 1 << 1,
    kConnectTo4G   = 1 << 2,
    kConnectToWWAN = 1 << 3,
    kConnectToWifi = 1 << 4,
    kConnectToInit = 1 << 5,
    /**
     *  联网了
     */
    kConnectToAny  = (kConnectTo2G | kConnectTo3G | kConnectTo4G | kConnectToWWAN | kConnectToWifi | kConnectToInit)
};

/**
 *  网络不可用回调
 */
typedef void(^UnReachableBlock)(void);

@interface HJReachability : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, assign) ENetWorkStatus currentNetStatus;
@property (nonatomic, assign) NSString *currentNetStatusForTracker;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;
/**
 *  是否联网了
 */
@property (nonatomic, getter=isConnectedToNet, readonly) BOOL connectedToNet;

/**
 *  功能:获取网络连接状况
 */
- (void)generateNetStatus;



+ (BOOL)isWiFiConnected;
+ (BOOL)isConnectedToNetWork;

@end
