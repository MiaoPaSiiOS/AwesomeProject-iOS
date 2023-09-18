
#import <Foundation/Foundation.h>


static NSString * _Nonnull const kNrAuthorityLogGetStatus = @"kNrAuthorityLogGetStatus";
static NSString * _Nonnull const kNrAuthorityLogRequestStatus = @"kNrAuthorityLogRequestStatus";
static NSString * _Nonnull const kNrAuthorityLogError = @"kNrAuthorityLogError";



typedef NS_ENUM(NSUInteger, NrAuthorityLogType) {
    NrAuthorityLogAddressBook,
    NrAuthorityLogEvent,
    NrAuthorityLogLocation,
    NrAuthorityLogMedia,
    NrAuthorityLogPhoto,
    NrAuthorityLogPush
};

NS_ASSUME_NONNULL_BEGIN

@interface NrAuthorityLog : NSObject


/**
 权限埋点

 @param type 权限类型
 @param subType 申请还是获取当前权限状态 1 获取 2 申请
 @param dict 自定义参数
 @param desc 描述
 */
+ (void)authorityLogWithType:(NrAuthorityLogType)type withSubType:(NSInteger)subType withDict:(NSDictionary *)dict withDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
