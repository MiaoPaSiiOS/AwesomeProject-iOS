//
//  DSDeviceInfo.h
//  DarkStarBaseKit
//
//  Created by zhuyuhui on 2023/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// iPhoneX 系列全面屏手机的安全区域的静态值
#define SafeAreaInsetsConstantForDeviceWithNotch [DSDeviceInfo safeAreaInsetsForDeviceWithNotch]

@interface DSDeviceInfo : NSObject
//设备平台、os类型、设备用户名、设备型号、系统版本、应用版本
@property (nonatomic,strong) NSString *deviceModel;
@property (nonatomic,strong) NSString *ostype;
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *deviceid;
@property (nonatomic,strong) NSString *idfa;
@property (nonatomic,strong) NSString *systemVersion;
@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *appVersion;

+ (instancetype)sharedInstance;

+ (BOOL)isIPad;

+ (BOOL)isIPod;

+ (BOOL)isIPhone;

+ (BOOL)isSimulator;

/// 带物理凹槽的刘海屏或者使用 Home Indicator 类型的设备
+ (BOOL)isNotchedScreen;

// 用于获取 isNotchedScreen 设备的 insets，注意对于 iPad Pro 11-inch 这种无刘海凹槽但却有使用 Home Indicator 的设备，它的 top 返回0，bottom 返回 safeAreaInsets.bottom 的值
+ (UIEdgeInsets)safeAreaInsetsForDeviceWithNotch;
@end

NS_ASSUME_NONNULL_END
