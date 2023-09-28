//
//  DSTouchIDInfoUtil.m
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import "DSTouchIDInfoUtil.h"
#import <DarkStarBaseKit/DarkStarBaseKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#include <sys/sysctl.h>

@implementation DSTouchIDInfoUtil
#pragma mark - 验证设备是否支持TouchID或者FaceID
+ (BOOL)returnTheResultOfPermissions {
    if ([self judueIPhonePlatformSupportTouchID:9] && DSDeviceInfo.isIOS11Later) {//iPhone8、8P、X 及以后手机  iOS11及以后系统
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;

        LAPolicy temp;
        // 区分是因为指纹被锁的状态下
        if (DSDeviceInfo.isIOS9Later) {
            //iOS 9.0以上支持，包含指纹验证与输入密码的验证方式
            temp = LAPolicyDeviceOwnerAuthentication;
        } else {
            //iOS8.0以上支持，只有指纹验证功能
            temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
        }

        if ([context canEvaluatePolicy:temp error:&error]) {
            //保持原有逻辑，并增加区分TouchID和FaceID
            if (DSDeviceInfo.isIOS11Later) {
                if (@available(iOS 11.0, *)) {
                    /*
                     iOS11之后LAContext新增biometryType属性，
                     调用时候可以根据这个属性来判断当前设备是使用FaceID还是TouchID，并据此做UI样式上的调整
                     */
                    if (@available(iOS 11.2, *)) {
                        if (context.biometryType == LABiometryTypeNone) {
                            return NO;
                        }
                    } else {
                        if (context.biometryType == LABiometryNone) {
                            return NO;
                        }
                    }

                    if (context.biometryType == LABiometryTypeTouchID) {
                        NSLog(@"手机支持指纹"); //指纹
                    } else if (context.biometryType == LABiometryTypeFaceID) {
                        NSLog(@"手机支持面容"); //FaceIDDD
                    }
                }
            }
            // 设备支持Touch ID
            return YES;
        } else {
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled: {// 未录入Touch ID
                    return YES;
                }
                break;

                case LAErrorPasscodeNotSet: {// 未设置设备密码
                    return YES;
                }
                break;

                default: {// 不支持Touch ID
                    return NO;
                }
                break;
            }
        }
    } else {
        if ([self judueIPhonePlatformSupportTouchID:5] && DSDeviceInfo.isIOS8Later) {//5s及以后手机  iOS8及以后系统
            LAContext *context = [[LAContext alloc] init];
            NSError *error = nil;

            LAPolicy temp;
            // 区分是因为指纹被锁的状态下
            if (DSDeviceInfo.isIOS9Later) {
                temp = LAPolicyDeviceOwnerAuthentication;
            } else {
                temp = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
            }

            if ([context canEvaluatePolicy:temp error:&error]) {
                // 设备支持Touch ID
                return YES;
            } else {
                switch (error.code) {
                    case LAErrorTouchIDNotEnrolled: {// 未录入Touch ID
                        return YES;
                    }
                    break;

                    case LAErrorPasscodeNotSet: {// 未设置设备密码
                        return YES;
                    }
                    break;

                    default: {// 不支持Touch ID
                        return NO;
                    }
                    break;
                }
            }
        } else {
            return NO;
        }
    }
}


#pragma mark - 验证设备是否支持FaceID
+ (BOOL)returnTheResultOfFaceID {
    if ([self judueIPhonePlatformSupportTouchID:9] && DSDeviceInfo.isIOS11Later) {
        LAContext *context = [[LAContext alloc] init];
        NSError *error = nil;

        LAPolicy temp;
        // 区分是因为指纹被锁的状态下
        temp = LAPolicyDeviceOwnerAuthentication;
        // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
        // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
        if ([context canEvaluatePolicy:temp error:&error]) {
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeFaceID) {
                    NSLog(@"手机支持面容ID"); //FaceID
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        } else {
            if (@available(iOS 11.0, *)) {
                if (context.biometryType == LABiometryTypeFaceID) {
                    NSLog(@"手机支持面容ID"); //FaceID
                    return YES;
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        }
    } else {
        return NO;
    }
}

#pragma mark - 指纹设置页面按钮显示（YES:关闭 NO:开启）
+ (BOOL)returnStateOfSettingButton {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([self judueIPhonePlatformSupportTouchID:9] && DSDeviceInfo.isIOS11Later && [self returnTheResultOfFaceID]) {
        // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
        // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            // 按钮显示开启状态
            return NO;
        } else {
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled: {// 设备未登记指纹
                    return YES;
                }
                break;

                case LAErrorPasscodeNotSet: {// 设备未设置设备密码
                    return YES;
                }
                break;

                case LAErrorTouchIDNotAvailable: {// 设备没有权限或者不可用
                    return YES;
                }
                break;

                default: {// 按钮显示开启状态
                    return NO;
                }
                break;
            }
        }
    } else {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            // 按钮显示开启状态
            return NO;
        } else {
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled: {// 设备未登记指纹
                    return YES;
                }
                break;

                case LAErrorPasscodeNotSet: {// 设备未设置设备密码
                    return YES;
                }
                break;

                default: {// 按钮显示开启状态
                    return NO;
                }
                break;
            }
        }
    }
}

#pragma mark - 判断设备类型
+ (NSString *)platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);

    return platform;
}

#pragma mark - 判定设备类型是iPhone 5s以上
+ (BOOL)judueIPhonePlatformSupportTouchID:(NSInteger)supportPlatform {
    if ([UIDevice ds_isIPhone]) {
        if ([self platform].length > 6) {
            NSArray *arr = [[self platform] componentsSeparatedByString:@"iPhone"];
            NSString *str = arr.lastObject;
            NSArray *arr2 = [str componentsSeparatedByString:@","];

            NSString *numberPlatformStr = [arr2 firstObject];
            NSInteger numberPlatform = [numberPlatformStr integerValue];
            if (numberPlatform > supportPlatform) {
                return YES;
            } else {
                return NO;
            }
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
