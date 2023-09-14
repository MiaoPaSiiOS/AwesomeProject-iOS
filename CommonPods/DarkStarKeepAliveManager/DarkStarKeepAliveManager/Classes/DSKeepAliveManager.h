
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///时间900s
#define kKLTime   900
///功能开关名称
#define kKLEnable @"IOS_KEEPLIVE_SWITCH"

@interface DSKeepAliveManager : NSObject

/// 单例
+ (nonnull instancetype)share;

/// 开始监听应用
- (void)start;

@end

NS_ASSUME_NONNULL_END
