//
//  UIDevice+NrDevice.h
//  NrBaseCoreKit
//
//  Created by zhuyuhui on 2022/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (NrDevice)

/// 如 iPhone12,5、iPad6,8
+ (nonnull NSString *)nr_deviceModel;

/// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)
+ (nonnull NSString *)nr_deviceName;

+ (BOOL)nr_isIPad;
+ (BOOL)nr_isIPod;
+ (BOOL)nr_isIPhone;
+ (BOOL)nr_isSimulator;

@end

NS_ASSUME_NONNULL_END
