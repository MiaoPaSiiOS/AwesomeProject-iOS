
#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

/**
 Privacy - Calendars Usage Description 日历
 */


typedef NS_ENUM(NSInteger, DSEventAuthorizationStatus) {
    /// 表明用户尚未选择关于客户端是否可以访问
    DSEventAuthorizationStatusNotDetermined = 0,
    /// 客户端未被授权访问。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    DSEventAuthorizationStatusRestricted,
    /// 明确拒绝用户访问
    DSEventAuthorizationStatusDenied,
    /// 用户授权访问
    DSEventAuthorizationStatusAuthorized,
} NS_AVAILABLE(10_9, 6_0);


NS_ASSUME_NONNULL_BEGIN

@interface DSEventManger : NSObject


/**
 获取日历或者备忘录权限状态

 @param type 参考EKEntityType
 @return 当前状态
 */
+ (DSEventAuthorizationStatus)getEventAuthorizationWithEntityType:(EKEntityType)type;


/**
 申请日历或者备忘录权限

 @param type 参考EKEntityType
 @param completion 回调
 */
+ (void)requestAccessToEntityType:(EKEntityType)type
                       completion:(nullable void(^)(BOOL granted, NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
