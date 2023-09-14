
#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureDevice.h>

/**
 Privacy - Camera Usage Description 相机
 Privacy - Microphone Usage Description 语音
 */


typedef NS_ENUM(NSInteger, DSMediaStatus) {
    //表明用户尚未选择关于客户端是否可以访问硬件
    DSMediaStatusNotDetermined = 0,
    //客户端未被授权访问硬件的媒体类型。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    DSMediaStatusRestricted    = 1,
    //明确拒绝用户访问硬件支持的媒体类型的客户
    DSMediaStatusDenied        = 2,
    //客户端授权访问硬件支持的媒体类型
    DSMediaStatusAuthorized    = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface DSMediaManger : NSObject


/**
 获取当前媒体权限

 @param mediaType 媒体类型
 @return 返回当前媒体权限
 */
+ (DSMediaStatus)authorizationStatusForMediaType:(AVMediaType)mediaType;


/**
 申请媒体权限

 @param mediaType 媒体类型
 @param handler 回调
 */
+ (void)requestAccessForMediaType:(AVMediaType)mediaType
                completionHandler:(nullable void (^)(BOOL granted))handler;


@end

NS_ASSUME_NONNULL_END
