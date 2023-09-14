
#import <Foundation/Foundation.h>


static NSString * _Nonnull const kDSAuthorityLogGetStatus = @"kDSAuthorityLogGetStatus";
static NSString * _Nonnull const kDSAuthorityLogRequestStatus = @"kDSAuthorityLogRequestStatus";
static NSString * _Nonnull const kDSAuthorityLogError = @"kDSAuthorityLogError";



typedef NS_ENUM(NSUInteger, DSAuthorityLogType) {
    DSAuthorityLogAddressBook,
    DSAuthorityLogEvent,
    DSAuthorityLogLocation,
    DSAuthorityLogMedia,
    DSAuthorityLogPhoto,
    DSAuthorityLogPush
};

NS_ASSUME_NONNULL_BEGIN

@interface DSAuthorityLog : NSObject


/**
 权限埋点

 @param type 权限类型
 @param subType 申请还是获取当前权限状态 1 获取 2 申请
 @param dict 自定义参数
 @param desc 描述
 */
+ (void)authorityLogWithType:(DSAuthorityLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
