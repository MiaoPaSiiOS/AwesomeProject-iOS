

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger, DSPushStatus) {
    // 表明用户尚未选择关于客户端是否有推送权限
    DSPushStatusNotDetermined = 0,
    
    // 明确拒绝推送权限
    DSPushStatusDenied,
    
    // 客户端授权推送权限
    DSPushStatusAuthorized,
    
    // The application is authorized to post non-interruptive user notifications.
    DSPushStatusProvisional __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __WATCHOS_AVAILABLE(5.0) __OSX_AVAILABLE(10.14)
};


typedef NS_OPTIONS(NSUInteger, DSPushOptions) {
    DSPushOptionBadge   = (1 << 0),
    DSPushOptionSound   = (1 << 1),
    DSPushOptionAlert   = (1 << 2),
    DSPushOptionCarPlay __IOS_AVAILABLE(10.0) =  (1 << 3),
    DSPushOptionCriticalAlert __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 4),
    DSPushOptionProvidesAppNotificationSettings __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 5),
    DSPushOptionProvisional __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 6),
};

NS_ASSUME_NONNULL_BEGIN

@interface DSPushManger : NSObject


/**
 获取当前推送权限状态

 @param handler 回调
 */
+ (void)requestCurrentUserNotificationStatus:(nullable void(^)(DSPushStatus status))handler;


/**
 申请推送权限

 @param options 参考DSPushOptions
 @param completionHandler 回调
 */
+ (void)requestAuthorizationWithOptions:(DSPushOptions)options
                      completionHandler:(nullable void (^)(BOOL granted, NSError *__nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
