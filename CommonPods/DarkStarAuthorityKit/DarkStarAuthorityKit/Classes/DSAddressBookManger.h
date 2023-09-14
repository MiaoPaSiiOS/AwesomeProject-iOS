#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif


/**
 需要在 plist 中增加 Privacy - Contacts Usage Description 对应的value为 允许开启，有助于提升您的信用等级、额度综合评估及快速推荐好友等
 */

typedef NS_ENUM(NSInteger, DSContactStatus) {
    /// 表明用户尚未选择关于客户端是否可以访问通讯录
    DSContactStatusNotDetermined = 0,
    /// 客户端未被授权访问通讯录。用户不能改变客户机的状态,可能由于活跃的限制,如家长控制
    DSContactStatusRestricted,
    /// 明确拒绝用户访问通讯录
    DSContactStatusDenied,
    /// 用户授权访问通讯录
    DSContactStatusAuthorized
};

NS_ASSUME_NONNULL_BEGIN

@interface DSAddressBookManger : NSObject


/**
 获取通讯录权限状态

 @return 回调
 */
+ (DSContactStatus)getAddressBookAuthorizationStatus;


/**
 申请通讯录权限

 @param completionHandler 回调
 */
+ (void)requestAddressBookAuthorizationCompletion:(nullable void(^)(BOOL granted, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
