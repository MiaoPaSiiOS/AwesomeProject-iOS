

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger, NrPushStatus) {
    // 表明用户尚未选择关于客户端是否有推送权限
    NrPushStatusNotDetermined = 0,
    
    // 明确拒绝推送权限
    NrPushStatusDenied,
    
    // 客户端授权推送权限
    NrPushStatusAuthorized,
    
    // The application is authorized to post non-interruptive user notifications.
    NrPushStatusProvisional __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __WATCHOS_AVAILABLE(5.0) __OSX_AVAILABLE(10.14)
};


typedef NS_OPTIONS(NSUInteger, NrPushOptions) {
    NrPushOptionBadge   = (1 << 0),
    NrPushOptionSound   = (1 << 1),
    NrPushOptionAlert   = (1 << 2),
    NrPushOptionCarPlay __IOS_AVAILABLE(10.0) =  (1 << 3),
    NrPushOptionCriticalAlert __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 4),
    NrPushOptionProvidesAppNotificationSettings __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 5),
    NrPushOptionProvisional __IOS_AVAILABLE(12.0) __TVOS_AVAILABLE(12.0) __OSX_AVAILABLE(10.14) __WATCHOS_AVAILABLE(5.0) = (1 << 6),
};

NS_ASSUME_NONNULL_BEGIN

@interface NrPushManger : NSObject


/**
 获取当前推送权限状态

 @param handler 回调
 */
+ (void)requestCurrentUserNotificationStatus:(nullable void(^)(NrPushStatus status))handler;


/**
 申请推送权限

 @param options 参考NrPushOptions
 @param completionHandler 回调
 */
+ (void)requestAuthorizationWithOptions:(NrPushOptions)options
                      completionHandler:(nullable void (^)(BOOL granted, NSError *__nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
