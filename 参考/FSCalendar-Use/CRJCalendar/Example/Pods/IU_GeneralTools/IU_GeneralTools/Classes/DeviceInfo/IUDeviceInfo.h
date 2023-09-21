//
//  IUDeviceInfo.h
//  CRJCommon_Example
//
//  Created by zhuyuhui on 2020/8/31.
//  Copyright © 2020 zhuyuhui434@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    /**
     iPhone4 or iPhone4s
     */
    IUDevice_320x480,
    
    /**
     iPhone5 or iPhone5s or iPhone5c or iPhoneSE
     */
    IUDevice_320x568,
    
    /**
     iPhone6 or iPhone6s or iPhone 7 or iPhone 8
     */
    IUDevice_375x667,
    
    /**
     iPhone6Plus or iPhone6sPlus or iPhone7sPlus or iPhone8sPlus
     */
    IUDevice_414x736,
    
    /**
     iPhoneX or iPhoneXs
     */
    IUDevice_375x812,
    
    /**
     iPhoneXR or iPhoneXsMax
     */
    IUDevice_414x896,
    
    /**
     New device type not added.
     */
    IUDevice_Not_Added,
    
} IUDeviceType;




@interface IUDeviceInfo : NSObject

/**
 获取设备尺寸枚举值
 */
@property (class, nonatomic, readonly) IUDeviceType deviceType;

/**
 是否是竖屏
 */
@property (class, nonatomic, readonly) BOOL isPortrait;

/**
 window.safeAreaInsets
*/
@property (class, nonatomic, readonly) UIEdgeInsets safeAreaInsets;
/**
 是否是刘海屏幕
 */
@property (class, nonatomic, readonly) BOOL isFringeScreen;

/**
 刘海屏顶部安全距离(如果不是刘海屏幕,则安全高度为0)
 */
@property (class, nonatomic, readonly) CGFloat fringeScreenTopSafeHeight;

/**
 刘海屏底部安全距离(如果不是刘海屏幕,则安全高度为0)
 */
@property (class, nonatomic, readonly) CGFloat fringeScreenBottomSafeHeight;

/**
 获取设备版本号,比如 iPhone X, iPad Air 2
 */
@property (class, nonatomic, readonly) NSString *deviceName;

/**
 获取用户关于本机中的名称,比如 YouXianMing's iPhone
 */
@property (class, nonatomic, readonly) NSString *userDeviceName;

/**
 获取app版本,比如 1.0
 */
@property (class, nonatomic, readonly) NSString *appVersion;

/**
 当前系统名称,比如 iOS
 */
@property (class, nonatomic, readonly) NSString *systemName;

/**
 当前系统版本,比如 11.4
 */
@property (class, nonatomic, readonly) NSString *systemVersion;

/**
 获取当前设备IP地址,获取不到时返回空
 */
@property (class, nonatomic, readonly) NSString *IPAddress;

/**
 获取当前wifi名字
 */
@property (class, nonatomic, readonly) NSString *wifiName;

/**
 获取总内存大小,拿结果除以1024三次后就是G为单位
 */
@property (class, nonatomic, readonly) long long physicalMemory;

/**
 当前可用内存,拿结果除以1024三次后就是G为单位
 */
@property (class, nonatomic, readonly) long long availableMemory;

/**
 获取当前设备的语言
 */
@property (class, nonatomic, readonly) NSString *deviceLanguage;
@end

NS_ASSUME_NONNULL_END
