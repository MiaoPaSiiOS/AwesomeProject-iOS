
#import <Foundation/Foundation.h>

/**
    iOS11之前：访问相册和存储照片到相册（读写权限），需要用户授权，需要添加NSPhotoLibraryUsageDescription。
    iOS11之后：默认开启访问相册权限（读权限），无需用户授权，无需添加NSPhotoLibraryUsageDescription，适配iOS11之前的还是需要加的。 添加图片到相册（写权限），需要用户授权，需要添加NSPhotoLibraryAddUsageDescription。
 Privacy - Photo Library Usage Description
 Privacy - Photo Library Additions Usage Description
 */


typedef NS_ENUM(NSInteger, DSPhotoStatus) {
    //表明用户尚未选择关于客户端是否可以访问硬件
    DSPhotoStatusNotDetermined = 0,
    //客户端未被授权访问硬件的媒体类型。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    DSPhotoStatusRestricted,
    //明确拒绝用户访问硬件支持的媒体类型的客户
    DSPhotoStatusDenied,
    //客户端授权访问硬件支持的媒体类型
    DSPhotoStatusAuthorized
};

NS_ASSUME_NONNULL_BEGIN

@interface DSPhotoManger : NSObject

/**
 获取相册权限

 @return 返回权限
 */
+ (DSPhotoStatus)authorizationStatus;

/**
 申请相册权限

 @param handler 申请回调
 */
+ (void)requestAuthorization:(nullable void(^)(DSPhotoStatus status))handler;


@end

NS_ASSUME_NONNULL_END
