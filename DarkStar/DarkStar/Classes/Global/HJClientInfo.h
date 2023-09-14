//
//  HJClientInfo.h
//  CommonLib
//
//  Created by 秦曲波 on 15/6/23.
//  Copyright (c) 2015年 qinqubo. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PHONE_TRACK_TYPE
#define PHONE_TRACK_TYPE 0
#endif

@interface HJClientInfo : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy, readonly) NSString *clientSystem;       // 客户端系统
@property (nonatomic, copy, readonly) NSString *clientVersion;      // 客户端版本
@property (nonatomic, copy, readonly) NSString *clientDeviceType;   // 客户端设备类型

@property (nonatomic, copy, readonly) NSString *appVersion;         // 客户端app版本号

@property (nonatomic, copy, readonly) NSString *deviceCode;         // 设备号
@property (nonatomic, copy)           NSString *deviceToken;        //推送的Devicetoken

@property (nonatomic, copy, readonly) NSString *traderName;          // 平台名称
@property (nonatomic, copy, readonly) NSString *unionKey;            // 渠道id
@property (nonatomic, copy, readonly) NSString *nettype;            // 网络类型
@property (nonatomic, copy, readonly) NSNumber *iaddr;

@property (nonatomic, copy)           NSNumber *latitude;           // 纬度
@property (nonatomic, copy)           NSNumber *longitude;          // 经度

@end
