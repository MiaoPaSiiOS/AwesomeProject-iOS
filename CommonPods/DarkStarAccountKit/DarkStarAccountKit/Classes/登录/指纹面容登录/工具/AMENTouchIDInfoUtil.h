//
//  AMENTouchIDInfoUtil.h
//  AFNetworking
//
//  Created by zhuyuhui on 2021/12/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AMENTouchIDInfoUtil : NSObject
// 验证设备是否支持Touch ID 或者FaceID
+ (BOOL)returnTheResultOfPermissions;
// 验证设备是否支持FaceID
+ (BOOL)returnTheResultOfFaceID;
// 指纹设置页面按钮显示(YES:关闭 NO:开启)
+ (BOOL)returnStateOfSettingButton;
@end

NS_ASSUME_NONNULL_END
