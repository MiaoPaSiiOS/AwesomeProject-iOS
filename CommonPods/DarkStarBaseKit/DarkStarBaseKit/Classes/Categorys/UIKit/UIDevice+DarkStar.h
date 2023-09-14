//
//  UIDevice+DarkStar.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2022/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (DarkStar)

/// 如 iPhone12,5、iPad6,8
+ (nonnull NSString *)ds_deviceModel;

/// 如 iPhone 11 Pro Max、iPad Pro (12.9 inch)
+ (nonnull NSString *)ds_deviceName;

+ (BOOL)ds_isIPad;
+ (BOOL)ds_isIPod;
+ (BOOL)ds_isIPhone;
+ (BOOL)ds_isSimulator;

@end

NS_ASSUME_NONNULL_END
